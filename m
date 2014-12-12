Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965420AbaLLISD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:18:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965325AbaLLISB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:18:01 -0500
Date: Fri, 12 Dec 2014 00:17:35 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-99ce8e9fce99147f865cda8a8e471900518c9a49@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, paulus@samba.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        hpa@zytor.com, cjashfor@linux.vnet.ibm.com, jolsa@kernel.org,
        dsahern@gmail.com, eranian@google.com, fweisbec@gmail.com,
        acme@redhat.com, mingo@kernel.org
Reply-To: mingo@kernel.org, acme@redhat.com, dsahern@gmail.com,
        jolsa@kernel.org, eranian@google.com, fweisbec@gmail.com,
        namhyung@kernel.org, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, paulus@samba.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1417460789-13874-4-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Add --buildid-dir option to set cache directory
Git-Commit-ID: 99ce8e9fce99147f865cda8a8e471900518c9a49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99ce8e9fce99147f865cda8a8e471900518c9a49
Gitweb:     http://git.kernel.org/tip/99ce8e9fce99147f865cda8a8e471900518c9a49
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 1 Dec 2014 20:06:24 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 09:14:35 -0300

perf tools: Add --buildid-dir option to set cache directory

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
index d240bb2..1e8e400 100644
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
index 452a847..3700a7f 100644
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
index c802236..e18f653 100644
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
index 419bee0..abc445e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -153,7 +153,7 @@ extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)))
 extern void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 
 extern int prefixcmp(const char *str, const char *prefix);
-extern void set_buildid_dir(void);
+extern void set_buildid_dir(const char *dir);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
