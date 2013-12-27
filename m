Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3L0Usv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:48:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35723 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3L0Ur0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David A. Long" <dave.long@linaro.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 42/49] perf probe: Expand given path to absolute path
Date: Fri, 27 Dec 2013 17:46:58 -0300
Message-Id: <1388177225-17349-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
index c98ccb570509..1792a3f1f4ce 100644
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
index 544ac1898a9f..68013b91377c 100644
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
-- 
1.8.1.4

