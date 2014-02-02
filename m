Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaBBVjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:39:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaBBVjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/22] perf tools: Add --list report option
Date: Sun,  2 Feb 2014 22:38:52 +0100
Message-Id: <1391377150-23920-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding --list report option to display entries sequentialy:

  $ perf report --list --stdio
  ...
       0.00%       13151.543527 +000000.000000       ls  [kernel.kallsyms]  [k] native_write_msr_safe
       0.00%       13151.543530 +000000.000003       ls  [kernel.kallsyms]  [k] native_write_msr_safe
       0.00%       13151.543532 +000000.000005       ls  [kernel.kallsyms]  [k] native_write_msr_safe
       0.00%       13151.543534 +000000.000007       ls  [kernel.kallsyms]  [k] native_write_msr_safe
       0.05%       13151.543536 +000000.000009       ls  [kernel.kallsyms]  [k] native_write_msr_safe
       0.92%       13151.543538 +000000.000011       ls  [kernel.kallsyms]  [k] perf_event_comm
      14.52%       13151.543560 +000000.000033       ls  [kernel.kallsyms]  [k] uprobe_mmap
      30.10%       13151.543878 +000000.000351       ls  ld-2.17.so         [.] _dl_setup_hash
      29.30%       13151.544531 +000000.001004       ls  ls                 [.] gobble_file.constprop.49
      25.09%       13151.545613 +000000.002086       ls  [kernel.kallsyms]  [k] _cond_resched

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-report.c |  6 +++++-
 tools/perf/util/hist.c      |  3 +++
 tools/perf/util/sort.c      | 26 ++++++++++++++++++++++++++
 tools/perf/util/sort.h      |  1 +
 tools/perf/util/symbol.h    |  3 ++-
 5 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3dbf2b8..a752687 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -731,7 +731,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
 		    "Interleave source code with assembly code (default)"),
 	OPT_BOOLEAN(0, "asm-raw", &symbol_conf.annotate_asm_raw,
-		    "Display raw encoding of assembly instructions (default)"),
+		    "display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
@@ -749,6 +749,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "how to display percentage of filtered entries", parse_percentage),
+	OPT_BOOLEAN(0, "list", &symbol_conf.show_list, "Show events list"),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -891,6 +892,9 @@ repeat:
 
 	sort__setup_elide(stdout);
 
+	if (symbol_conf.show_list)
+		sort__setup_list();
+
 	ret = __cmd_report(&report);
 	if (ret == K_SWITCH_INPUT_DATA) {
 		perf_session__delete(session);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2ecb976..43241ea 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1073,6 +1073,9 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
 	struct hist_entry *pair;
 	u64 *periods_a, *periods_b;
 
+	if (symbol_conf.show_list)
+		return b->idx - a->idx;
+
 	if (symbol_conf.cumulate_callchain) {
 		/*
 		 * Put caller above callee when they have equal period.
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5607edb..4ddf934 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1102,6 +1102,21 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
 #undef DIM
 
+static void __sort_dimension__prep(struct sort_dimension *sd,
+				   enum sort_type idx)
+{
+	if (sd->taken)
+		return;
+
+	if (sd->entry->se_collapse)
+		sort__need_collapse = 1;
+
+	sort__first_dimension = idx;
+
+	list_add(&sd->entry->list, &hist_entry__sort_list);
+	sd->taken = 1;
+}
+
 static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 {
 	if (sd->taken)
@@ -1271,3 +1286,14 @@ void sort__setup_elide(FILE *output)
 	list_for_each_entry(se, &hist_entry__sort_list, list)
 		se->elide = false;
 }
+
+void sort__setup_list(void)
+{
+	struct sort_dimension *sd_idx  = &common_sort_dimensions[SORT_IDX];
+	struct sort_dimension *sd_time = &common_sort_dimensions[SORT_TIME];
+
+	__sort_dimension__prep(sd_time, SORT_TIME);
+	__sort_dimension__prep(sd_idx, SORT_IDX);
+
+	sd_idx->entry->elide = true;
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 666bf0b..c2fa361 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -211,6 +211,7 @@ extern struct list_head hist_entry__sort_list;
 int setup_sorting(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
+void sort__setup_list(void);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 0657e72..423e55c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -106,7 +106,8 @@ struct symbol_conf {
 			annotate_src,
 			event_group,
 			demangle,
-			filter_relative;
+			filter_relative,
+			show_list;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.8.3.1

