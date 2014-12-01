Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaLAO7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:59:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:48570 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbaLAO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:59:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,494,1413270000"; 
   d="scan'208";a="640742604"
From: Kan Liang <kan.liang@intel.com>
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 1/3] perf tool: Add sort key symoff for perf diff
Date: Mon,  1 Dec 2014 09:40:10 -0500
Message-Id: <1417444812-22063-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Sometime, especially debugging scaling issue, the function level diff
may be high granularity. The user may want to do deeper diff analysis
for some cache or lock issue. The "symoff" key can let the user sort
differential profile by ips.

Here is an example.

The source code for example_v1.c is as below:

noinline void f3(void)
{
        volatile int i;
        for (i = 0; i < 10000;) {
                if(i%2)
                        i++;
                else
                        i++;
        }
}

noinline void f2(void)
{
        volatile int a = 100, b, c;
        for (b = 0; b < 10000; b++)
                c = a * b;

}

noinline void f1(void)
{
                f2();
                f3();
}

int main()
{
        int i;
        for (i = 0; i < 100000; i++)
                f1();
}

We run the example twice. (That's a simplified case. Of course, we
cannot find the scaling issue here. )

[lk@localhost perf_diff]$ gcc example_v1.c -o example
[lk@localhost perf_diff]$ perf record -o example_symoff_1.data ./example
[ perf record: Woken up 4 times to write data ]
[ perf record: Captured and wrote 0.808 MB example_symoff_1.data (~35314
samples) ]

[lk@localhost perf_diff]$ perf record -o example_symoff_2.data ./example
[ perf record: Woken up 4 times to write data ]
[ perf record: Captured and wrote 0.814 MB example_symoff_2.data (~35580
samples) ]

[lk@localhost perf_diff]$ perf diff -s symoff example_symoff_1.data
example_symoff_2.data

 Event 'cycles'

 Baseline    Delta  Symbol + Offset
 ........  .......  ....................................

     0.00%           _raw_spin_lock+0x13
                     account_process_tick+0x15a
                     apic_timer_interrupt+0x0
                     check_preempt_wakeup+0x174
     0.00%           f1+0x0
     0.00%           f1+0x1
     0.00%           f1+0xe
     0.00%           f2+0xb
     0.03%   +0.02%  f2+0x14
     0.02%           f2+0x1a
    30.75%   -0.18%  f2+0x1d
     7.66%   -0.18%  f2+0x20
     0.00%           f2+0x29
     7.69%   +0.12%  f2+0x2c
     0.01%           f2+0x33
     0.01%           f2+0x34
     0.00%           f3+0x0
     7.67%   +0.15%  f3+0xd
     0.01%           f3+0x10
                     f3+0x13
     3.95%   -0.21%  f3+0x17
     3.91%   -0.05%  f3+0x20
     3.74%   +0.04%  f3+0x22
     4.00%   -0.10%  f3+0x2b
    30.44%   +0.45%  f3+0x2e
     0.02%           f3+0x35
     0.02%           f3+0x36
     0.00%           ktime_get+0x9c
     0.00%           main+0x1a
                     main+0x21
     0.00%           native_read_tsc+0x6
     0.00%           native_write_msr_safe+0xa
                     rcu_irq_enter+0x88
     0.00%           rcu_note_context_switch+0x12
     0.00%           run_timer_softirq+0x292
                     timekeeping_update.constprop.7+0x9c
     0.00%           timerqueue_add+0x50

Signed-off-by: Kan Liang <kan.liang@intel.com>
---

The patch is seperated from "[PATCH V4 0/3] perf tool: perf diff sort
changes" patch set.
The first patch of the patch set has been merged.
The second patch to support perf diff different binaries was submitted by
another thread.
This is the third patch to support symoff.

Changes since V4:
 - Seperate from old patch set
 - Symoff print format
 - Check build_id
 - Update man page

No change since V5

 tools/perf/Documentation/perf-diff.txt   |  2 +-
 tools/perf/Documentation/perf-report.txt |  1 +
 tools/perf/builtin-diff.c                |  2 +-
 tools/perf/util/hist.c                   |  7 ++++
 tools/perf/util/hist.h                   |  1 +
 tools/perf/util/sort.c                   | 67 ++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |  2 +
 7 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index e463caa..4179ddfa 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -50,7 +50,7 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline.
+	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline, symoff.
 	Please see description of --sort in the perf-report man page.
 
 -t::
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 0927bf4..5b63311 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -70,6 +70,7 @@ OPTIONS
 	- pid: command and tid of the task
 	- dso: name of library or module executed at the time of sample
 	- symbol: name of function executed at the time of sample
+	- symoff: exact symbol + offset address executed at the time of sample.
 	- parent: name of function matched to the parent regex filter. Unmatched
 	entries are displayed as "[other]".
 	- cpu: cpu number the task ran at the time of sample
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1ce425d..03a4001 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -744,7 +744,7 @@ static const struct option options[] = {
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, symoff, ..."
 		   " Please refer the man page for the complete list."),
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6e88b9e..062c3d4b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -59,6 +59,7 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	u16 len;
 
 	/*
+	 * +6 accounts for '"+0xYYY ' symoff info
 	 * +4 accounts for '[x] ' priv level info
 	 * +2 accounts for 0x prefix on raw addresses
 	 * +3 accounts for ' y ' symtab origin info
@@ -68,10 +69,16 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		if (verbose)
 			symlen += BITS_PER_LONG / 4 + 2 + 3;
 		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
+
+		symlen = h->ms.sym->namelen + 6;
+		hists__new_col_len(hists, HISTC_SYMOFF, symlen);
 	} else {
 		symlen = unresolved_col_width + 4 + 2;
 		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
+
+		symlen = unresolved_col_width + 2;
+		hists__new_col_len(hists, HISTC_SYMOFF, symlen);
 	}
 
 	len = thread__comm_len(h->thread);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d0ef9a1..874b203 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -24,6 +24,7 @@ enum hist_filter {
 
 enum hist_column {
 	HISTC_SYMBOL,
+	HISTC_SYMOFF,
 	HISTC_DSO,
 	HISTC_THREAD,
 	HISTC_COMM,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9139dda..2a1df9f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -280,6 +280,65 @@ struct sort_entry sort_sym = {
 	.se_width_idx	= HISTC_SYMBOL,
 };
 
+static int64_t
+sort__symoff_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return _sort__addr_cmp(left->ip, right->ip);
+}
+
+static int64_t
+sort__symoff_collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	struct symbol *sym_l = left->ms.sym;
+	struct symbol *sym_r = right->ms.sym;
+	u64 symoff_l, symoff_r;
+	int64_t ret;
+
+	if (!sym_l || !sym_r)
+		return cmp_null(sym_l, sym_r);
+
+	ret = strcmp(sym_r->name, sym_l->name);
+	if (ret)
+		return ret;
+
+
+	symoff_l = left->ip - sym_l->start;
+	symoff_r = right->ip - sym_r->start;
+
+	return (int64_t)(symoff_r - symoff_l);
+}
+
+static int hist_entry__symoff_snprintf(struct hist_entry *he, char *bf,
+				    size_t size, unsigned int width)
+{
+	struct map *map = he->ms.map;
+	struct symbol *sym = he->ms.sym;
+	size_t ret = 0;
+
+	if (sym) {
+		ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
+		ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
+				       he->ip - sym->start);
+
+	} else {
+		size_t len = BITS_PER_LONG / 4;
+
+		ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx", len,
+				       map ? map->unmap_ip(map, he->ip) : he->ip);
+	}
+
+	ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+			       width - ret, "");
+	return ret;
+}
+
+struct sort_entry sort_symoff = {
+	.se_header	= "Symbol + Offset",
+	.se_cmp		= sort__symoff_cmp,
+	.se_snprintf	= hist_entry__symoff_snprintf,
+	.se_width_idx	= HISTC_SYMOFF,
+};
+
 /* --sort srcline */
 
 static int64_t
@@ -1172,6 +1231,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_COMM, "comm", sort_comm),
 	DIM(SORT_DSO, "dso", sort_dso),
 	DIM(SORT_SYM, "symbol", sort_sym),
+	DIM(SORT_SYMOFF, "symoff", sort_symoff),
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
@@ -1434,6 +1494,13 @@ int sort_dimension__add(const char *tok)
 			sort__has_sym = 1;
 		} else if (sd->entry == &sort_dso) {
 			sort__has_dso = 1;
+		} else if (sd->entry == &sort_symoff) {
+			/*
+			 * For symoff sort key, not only the offset but also the
+			 * symbol name should be compared.
+			 */
+			if (sort__mode == SORT_MODE__DIFF)
+				sd->entry->se_collapse = sort__symoff_collapse;
 		}
 
 		return __sort_dimension__add(sd);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index c03e4ff..ea0122f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -38,6 +38,7 @@ extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
+extern struct sort_entry sort_symoff;
 extern struct sort_entry sort_parent;
 extern struct sort_entry sort_dso_from;
 extern struct sort_entry sort_dso_to;
@@ -161,6 +162,7 @@ enum sort_type {
 	SORT_COMM,
 	SORT_DSO,
 	SORT_SYM,
+	SORT_SYMOFF,
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
-- 
1.8.3.2

