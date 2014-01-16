Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaAPJj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:39:56 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51532 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaAPJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:39:50 -0500
Subject: [PATCH -tip 2/3] [BUGFIX] perf-probe: Release all dynamically
 allocated parameters
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 16 Jan 2014 09:39:47 +0000
Message-ID: <20140116093947.24403.80118.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140116093942.24403.50992.stgit@kbuild-fedora.novalocal>
References: <20140116093942.24403.50992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix a memory leak, release all dynamically allocated
options/parameters in params data structure. This also
introduces/exports some init/clear routines.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---
 tools/perf/builtin-probe.c    |   48 +++++++++++++++++++++++++++++++++++++----
 tools/perf/util/probe-event.c |   22 +++++++++++++++++++
 tools/perf/util/probe-event.h |    6 +++++
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
 


