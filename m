Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaJaTwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:52:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:50963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbaJaTwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:52:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="629198812"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@kernel.org
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/1] perf tools: perf diff for different binaries
Date: Fri, 31 Oct 2014 05:06:12 -0700
Message-Id: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

perf diff can display the differential profile between two perf.data
files. However, the perf.data files have to come from same binaries.

The patch introduced a key "symbol_name" for --sort option, so the user
can compare the perf.data files from different binaries, even different
kernel version. If symbol_name is set, perf diff display the
differential profile of functions.
It could help the user quickly locate the scaling regression caused by
new binaries/kernels.

Here is an example. I have two version of binaries. One is running on
kernel 3.16. The other is running on kernel 3.17.

Using perf record, I got two perf.data files, v1_1_6perf.data (version
one in 3.16) and v2_1_7perf.data (version two in 3.17).

If I run old perf diff with --sort dso,symbol, we cannot get any useful
information for the user space binary. Furthermore, it failed to compare
the kernel function. E.g. native_write_msr_safe.

perf diff -s dso,symbol --compute ratio v1_1_6perf.data v2_1_7perf.data

 Event 'cycles'

 Baseline           Ratio  Shared Object      Symbol
 ........  ..............  .................
....................................

                            [kernel.kallsyms]  [k]
__update_entity_load_avg_contrib
                            [kernel.kallsyms]  [k] _raw_spin_lock
                            [kernel.kallsyms]  [k] apic_timer_interrupt
                            [kernel.kallsyms]  [k] hrtimer_interrupt
     0.01%                  [kernel.kallsyms]  [k] native_write_msr_safe
                            [kernel.kallsyms]  [k] native_write_msr_safe
     0.01%                  [kernel.kallsyms]  [k] notifier_call_chain
     0.01%                  [kernel.kallsyms]  [k] perf_event_task_tick
     0.01%                  [kernel.kallsyms]  [k] run_posix_cpu_timers
     0.01%                  [kernel.kallsyms]  [k] run_timer_softirq
     0.01%                  [kernel.kallsyms]  [k] trigger_load_balance
     0.01%                  [kernel.kallsyms]  [k] update_vsyscall
     0.05%                  [unknown]          [.] 0x0000000000400540
     0.04%                  [unknown]          [.] 0x0000000000400541
     0.03%                  [unknown]          [.] 0x000000000040054b
     0.04%                  [unknown]          [.] 0x0000000000400552
    33.55%                  [unknown]          [.] 0x0000000000400554
     1.22%                  [unknown]          [.] 0x000000000040055a
     8.00%                  [unknown]          [.] 0x000000000040055e
     0.02%                  [unknown]          [.] 0x0000000000400562
     8.41%                  [unknown]          [.] 0x0000000000400564
    48.13%                  [unknown]          [.] 0x000000000040056b
     0.16%                  [unknown]          [.] 0x0000000000400570
     0.17%                  [unknown]          [.] 0x0000000000400571
                            [unknown]          [.] 0x0000000000400580
                            [unknown]          [.] 0x0000000000400581
     0.01%                  [unknown]          [.] 0x0000000000400583
     0.01%                  [unknown]          [.] 0x0000000000400588
                            [unknown]          [.] 0x000000000040058b
     0.01%     1240.990221  [unknown]          [.] 0x000000000040058d
                            [unknown]          [.] 0x0000000000400590
     0.06%                  [unknown]          [.] 0x0000000000400591
                            [unknown]          [.] 0x0000000000400593
     0.04%                  [unknown]          [.] 0x0000000000400595
     0.01%     1240.603148  [unknown]          [.] 0x0000000000400597
                            [unknown]          [.] 0x000000000040059b
                            [unknown]          [.] 0x000000000040059d
                            [unknown]          [.] 0x00000000004005a1
                            [unknown]          [.] 0x00000000004005a5
                            [unknown]          [.] 0x00000000004005a7
                            [unknown]          [.] 0x00000000004005a8
                            [unknown]          [.] 0x00000000004005aa
                            [unknown]          [.] 0x00000000004005ba
                            [unknown]          [.] 0x00000000004005bf
                            [unknown]          [.] 0x00000000004005c4
                            [unknown]          [.] 0x00000000004005c9
                            [unknown]          [.] 0x00000000004005ce
                            [unknown]          [.] 0x00000000004005d2
                            [unknown]          [.] 0x00000000004005d6
                            [unknown]          [.] 0x00000000004005d8
                            [unknown]          [.] 0x00000000004005f5

With the key "symbol_name", we can easily get the differential profile
from different binary versions and different kernel versions.

./perf diff -s dso,symbol_name --compute ratio v1_1_6perf.data v2_1_7perf.data

 Event 'cycles'

 Baseline           Ratio  Shared Object      Symbol Name
 ........  ..............  .................
....................................

                            [kernel.kallsyms]  [k]
__update_entity_load_avg_contrib
                            [kernel.kallsyms]  [k] _raw_spin_lock
                            [kernel.kallsyms]  [k] apic_timer_interrupt
                            [kernel.kallsyms]  [k] hrtimer_interrupt
     0.01%        1.998522  [kernel.kallsyms]  [k] native_write_msr_safe
     0.01%                  [kernel.kallsyms]  [k] notifier_call_chain
     0.01%                  [kernel.kallsyms]  [k] perf_event_task_tick
     0.01%                  [kernel.kallsyms]  [k] run_posix_cpu_timers
     0.01%                  [kernel.kallsyms]  [k] run_timer_softirq
     0.01%                  [kernel.kallsyms]  [k] trigger_load_balance
     0.01%                  [kernel.kallsyms]  [k] update_vsyscall
                            tchain_edit        [.] f1
     0.14%        3.913444  tchain_edit        [.] f2
    99.82%        1.005478  tchain_edit        [.] f3

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/builtin-diff.c |  5 ++++-
 tools/perf/util/sort.c    | 26 ++++++++++++++++++++++++++
 tools/perf/util/sort.h    |  3 +++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 25114c9..71183c1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -743,7 +743,7 @@ static const struct option options[] = {
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   "sort by key(s): pid, comm, dso, symbol, symbol_name, parent, cpu, srcline, ..."
 		   " Please refer the man page for the complete list."),
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
@@ -1164,6 +1164,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (setup_sorting() < 0)
 		usage_with_options(diff_usage, options);
 
+	if (sort__has_sym_name)
+		tool.mmap2 = perf_event__process_mmap2;
+
 	setup_pager();
 
 	sort__setup_elide(NULL);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9402885..1226e37 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -20,6 +20,7 @@ int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
+int		sort__has_sym_name = 0;
 int		sort__has_dso = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
@@ -280,6 +281,27 @@ struct sort_entry sort_sym = {
 	.se_width_idx	= HISTC_SYMBOL,
 };
 
+static int64_t
+sort__sym_name_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	const char *sym_name_l, *sym_name_r;
+
+	if (!left->ms.sym || !right->ms.sym)
+		return cmp_null(right->ms.sym, left->ms.sym);
+
+	sym_name_l = left->ms.sym->name;
+	sym_name_r = right->ms.sym->name;
+
+	return strcmp(sym_name_l, sym_name_r);
+}
+
+struct sort_entry sort_sym_name = {
+	.se_header	= "Symbol Name",
+	.se_cmp		= sort__sym_name_cmp,
+	.se_sort	= sort__sym_sort,
+	.se_snprintf	= hist_entry__sym_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
+};
 /* --sort srcline */
 
 static int64_t
@@ -1170,6 +1192,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_COMM, "comm", sort_comm),
 	DIM(SORT_DSO, "dso", sort_dso),
 	DIM(SORT_SYM, "symbol", sort_sym),
+	DIM(SORT_SYM_NAME, "symbol_name", sort_sym_name),
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
@@ -1430,6 +1453,8 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
+		} else if (sd->entry == &sort_sym_name) {
+			sort__has_sym_name = 1;
 		} else if (sd->entry == &sort_dso) {
 			sort__has_dso = 1;
 		}
@@ -1809,6 +1834,7 @@ void reset_output_field(void)
 	sort__need_collapse = 0;
 	sort__has_parent = 0;
 	sort__has_sym = 0;
+	sort__has_sym_name = 0;
 	sort__has_dso = 0;
 
 	field_order = NULL;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index c03e4ff..9b43c6c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -34,10 +34,12 @@ extern int have_ignore_callees;
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
+extern int sort__has_sym_name;
 extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
+extern struct sort_entry sort_sym_name;
 extern struct sort_entry sort_parent;
 extern struct sort_entry sort_dso_from;
 extern struct sort_entry sort_dso_to;
@@ -161,6 +163,7 @@ enum sort_type {
 	SORT_COMM,
 	SORT_DSO,
 	SORT_SYM,
+	SORT_SYM_NAME,
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
-- 
1.8.3.1

