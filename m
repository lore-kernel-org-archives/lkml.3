Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbaLKV1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:44302 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbaLKV1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:00 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/18] perf tools: Add --buildid-dir option to set cache directory
Date: Thu, 11 Dec 2014 18:25:56 -0300
Message-Id: <1418333166-15429-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding --buildid-dir to be able to set specific cache directory. It's
going to be handy for buildid tests coming in shortly.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1417460789-13874-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf.txt |  4 ++++
 tools/perf/perf.c                 | 14 ++++++++++++--
 tools/perf/util/config.c          |  8 +++++---
 tools/perf/util/util.h            |  2 +-
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index d240bb2e5b22..1e8e400b4493 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -18,6 +18,10 @@ OPTIONS
 	  --debug verbose   # sets verbose = 1
 	  --debug verbose=2 # sets verbose = 2
 
+--buildid-dir::
+	Setup buildid cache directory. It has higher priority than
+	buildid.dir config file option.
+
 DESCRIPTION
 -----------
 Performance counters for Linux are a new kernel-based subsystem
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 452a8474d29d..3700a7faca6c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -200,6 +200,16 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
+		} else if (!strcmp(cmd, "--buildid-dir")) {
+			if (*argc < 2) {
+				fprintf(stderr, "No directory given for --buildid-dir.\n");
+				usage(perf_usage_string);
+			}
+			set_buildid_dir((*argv)[1]);
+			if (envchanged)
+				*envchanged = 1;
+			(*argv)++;
+			(*argc)--;
 		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
 			perf_debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
 			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
@@ -499,7 +509,7 @@ int main(int argc, const char **argv)
 	}
 	if (!prefixcmp(cmd, "trace")) {
 #ifdef HAVE_LIBAUDIT_SUPPORT
-		set_buildid_dir();
+		set_buildid_dir(NULL);
 		setup_path();
 		argv[0] = "trace";
 		return cmd_trace(argc, argv, NULL);
@@ -514,7 +524,7 @@ int main(int argc, const char **argv)
 	argc--;
 	handle_options(&argv, &argc, NULL);
 	commit_pager_choice();
-	set_buildid_dir();
+	set_buildid_dir(NULL);
 
 	if (argc > 0) {
 		if (!prefixcmp(argv[0], "--"))
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index c802236b2bfe..e18f653cd7db 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -539,12 +539,14 @@ static void check_buildid_dir_config(void)
 	perf_config(buildid_dir_command_config, &c);
 }
 
-void set_buildid_dir(void)
+void set_buildid_dir(const char *dir)
 {
-	buildid_dir[0] = '\0';
+	if (dir)
+		scnprintf(buildid_dir, MAXPATHLEN-1, "%s", dir);
 
 	/* try config file */
-	check_buildid_dir_config();
+	if (buildid_dir[0] == '\0')
+		check_buildid_dir_config();
 
 	/* default to $HOME/.debug */
 	if (buildid_dir[0] == '\0') {
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 419bee030f83..abc445ee4f60 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -153,7 +153,7 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);
-extern void set_buildid_dir(void);
+extern void set_buildid_dir(const char *dir);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
-- 
1.9.3

