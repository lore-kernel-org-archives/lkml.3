Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaALSjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:39:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaALSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:39:35 -0500
Date: Sun, 12 Jan 2014 10:39:13 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-8a613d40e389b723fd5889ac8d4033ed4030be31@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.long@linaro.org,
        hpa@zytor.com, mingo@kernel.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, dsahern@gmail.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
References: <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Expand given path to absolute path
Git-Commit-ID: 8a613d40e389b723fd5889ac8d4033ed4030be31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:39:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a613d40e389b723fd5889ac8d4033ed4030be31
Gitweb:     http://git.kernel.org/tip/8a613d40e389b723fd5889ac8d4033ed4030be31
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 26 Dec 2013 05:41:50 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Dec 2013 11:21:19 -0300

perf probe: Expand given path to absolute path

Expand given path to absolute path in the option parser, except for a
module name.

Since realpath at later stage in processing several probe point, can be
called several times (even if currently doesn't, it can happen when we
expands the feature), it is waste of the performance.

Processing it once at the early stage can avoid that.

Changes from previous one:
 - Fix not to print null string.
 - Allocate memory for given path/module name everytime.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap@sourceware.org
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20131226054150.22364.12187.stgit@kbuild-fedora.novalocal
[ Clarified the pr_warning message as per David Ahern's suggestion ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    | 15 ++++++++++++++-
 tools/perf/util/probe-event.c | 11 ++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c98ccb5..1792a3f 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -169,6 +169,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 			int unset __maybe_unused)
 {
 	int ret = -ENOENT;
+	char *tmp;
 
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
@@ -180,7 +181,19 @@ static int opt_set_target(const struct option *opt, const char *str,
 		else
 			return ret;
 
-		params.target = str;
+		/* Expand given path to absolute path, except for modulename */
+		if (params.uprobes || strchr(str, '/')) {
+			tmp = realpath(str, NULL);
+			if (!tmp) {
+				pr_warning("Failed to get the absolute path of %s: %m\n", str);
+				return ret;
+			}
+		} else {
+			tmp = strdup(str);
+			if (!tmp)
+				return -ENOMEM;
+		}
+		params.target = tmp;
 		ret = 0;
 	}
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 544ac18..68013b9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2281,7 +2281,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 	struct perf_probe_point *pp = &pev->point;
 	struct symbol *sym;
 	struct map *map = NULL;
-	char *function = NULL, *name = NULL;
+	char *function = NULL;
 	int ret = -EINVAL;
 	unsigned long long vaddr = 0;
 
@@ -2297,12 +2297,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		goto out;
 	}
 
-	name = realpath(exec, NULL);
-	if (!name) {
-		pr_warning("Cannot find realpath for %s.\n", exec);
-		goto out;
-	}
-	map = dso__new_map(name);
+	map = dso__new_map(exec);
 	if (!map) {
 		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
 		goto out;
@@ -2367,7 +2362,5 @@ out:
 	}
 	if (function)
 		free(function);
-	if (name)
-		free(name);
 	return ret;
 }
