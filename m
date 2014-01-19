Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaASM03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:26:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56030 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaASM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:26:24 -0500
Date: Sun, 19 Jan 2014 04:24:49 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-e53b00d382f4d8f55bcae301f49863c469fdff65@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dave.long@linaro.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140116093947.24403.80118.stgit@kbuild-fedora.novalocal>
References: <20140116093947.24403.80118.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Release all dynamically allocated parameters
Git-Commit-ID: e53b00d382f4d8f55bcae301f49863c469fdff65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:24:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e53b00d382f4d8f55bcae301f49863c469fdff65
Gitweb:     http://git.kernel.org/tip/e53b00d382f4d8f55bcae301f49863c469fdff65
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 16 Jan 2014 09:39:47 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:29:02 -0300

perf probe: Release all dynamically allocated parameters

To fix a memory leak, release all dynamically allocated
options/parameters in params data structure. This also
introduces/exports some init/clear routines.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140116093947.24403.80118.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    | 48 ++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/probe-event.c | 22 ++++++++++++++++++++
 tools/perf/util/probe-event.h |  6 ++++++
 3 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 43ff33d..7894888 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -59,7 +59,7 @@ static struct {
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
 	struct line_range line_range;
-	const char *target;
+	char *target;
 	int max_probe_points;
 	struct strfilter *filter;
 } params;
@@ -98,7 +98,10 @@ static int set_target(const char *ptr)
 	 * short module name.
 	 */
 	if (!params.target && ptr && *ptr == '/') {
-		params.target = ptr;
+		params.target = strdup(ptr);
+		if (!params.target)
+			return -ENOMEM;
+
 		found = 1;
 		buf = ptr + (strlen(ptr) - 3);
 
@@ -116,6 +119,9 @@ static int parse_probe_event_argv(int argc, const char **argv)
 	char *buf;
 
 	found_target = set_target(argv[0]);
+	if (found_target < 0)
+		return found_target;
+
 	if (found_target && argc == 1)
 		return 0;
 
@@ -217,7 +223,6 @@ static int opt_show_lines(const struct option *opt __maybe_unused,
 
 	params.show_lines = true;
 	ret = parse_line_range_desc(str, &params.line_range);
-	INIT_LIST_HEAD(&params.line_range.line_list);
 
 	return ret;
 }
@@ -263,7 +268,28 @@ static int opt_set_filter(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
+static void init_params(void)
+{
+	line_range__init(&params.line_range);
+}
+
+static void cleanup_params(void)
+{
+	int i;
+
+	for (i = 0; i < params.nevents; i++)
+		clear_perf_probe_event(params.events + i);
+	if (params.dellist)
+		strlist__delete(params.dellist);
+	line_range__clear(&params.line_range);
+	free(params.target);
+	if (params.filter)
+		strfilter__delete(params.filter);
+	memset(&params, 0, sizeof(params));
+}
+
+static int
+__cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const probe_usage[] = {
 		"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
@@ -417,6 +443,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		ret = show_available_funcs(params.target, params.filter,
 					params.uprobes);
 		strfilter__delete(params.filter);
+		params.filter = NULL;
 		if (ret < 0)
 			pr_err("  Error: Failed to show functions."
 			       " (%d)\n", ret);
@@ -456,6 +483,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 					  params.filter,
 					  params.show_ext_vars);
 		strfilter__delete(params.filter);
+		params.filter = NULL;
 		if (ret < 0)
 			pr_err("  Error: Failed to show vars. (%d)\n", ret);
 		return ret;
@@ -464,7 +492,6 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (params.dellist) {
 		ret = del_perf_probe_events(params.dellist);
-		strlist__delete(params.dellist);
 		if (ret < 0) {
 			pr_err("  Error: Failed to delete events. (%d)\n", ret);
 			return ret;
@@ -483,3 +510,14 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 	return 0;
 }
+
+int cmd_probe(int argc, const char **argv, const char *prefix)
+{
+	int ret;
+
+	init_params();
+	ret = __cmd_probe(argc, argv, prefix);
+	cleanup_params();
+
+	return ret;
+}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 579b655..c68711c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -794,6 +794,28 @@ int show_available_vars(struct perf_probe_event *pevs __maybe_unused,
 }
 #endif
 
+void line_range__clear(struct line_range *lr)
+{
+	struct line_node *ln;
+
+	free(lr->function);
+	free(lr->file);
+	free(lr->path);
+	free(lr->comp_dir);
+	while (!list_empty(&lr->line_list)) {
+		ln = list_first_entry(&lr->line_list, struct line_node, list);
+		list_del(&ln->list);
+		free(ln);
+	}
+	memset(lr, 0, sizeof(*lr));
+}
+
+void line_range__init(struct line_range *lr)
+{
+	memset(lr, 0, sizeof(*lr));
+	INIT_LIST_HEAD(&lr->line_list);
+}
+
 static int parse_line_num(char **ptr, int *val, const char *what)
 {
 	const char *start = *ptr;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index d481c46..fcaf727 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -120,6 +120,12 @@ extern void clear_perf_probe_event(struct perf_probe_event *pev);
 /* Command string to line-range */
 extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
+/* Release line range members */
+extern void line_range__clear(struct line_range *lr);
+
+/* Initialize line range */
+extern void line_range__init(struct line_range *lr);
+
 /* Internal use: Return kernel/module path */
 extern const char *kernel_get_module_path(const char *module);
 
