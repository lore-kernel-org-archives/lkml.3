Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbaDJULj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759162AbaDJULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:11:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com
Cc: eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC 5/5] perf: Enable multiple hist_entry_group output
Date: Thu, 10 Apr 2014 16:11:01 -0400
Message-Id: <1397160661-33395-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable multiple hist_entry_group groups in the output based on a sort
method.

Currently only 'perf report' is hooked in with '--group-sort='.  The choices
are cpu, pid, and cacheline.  Only --stdio works right now.  I haven't figured
out how the other outputs work.

Sample output from 'perf mem record -a grep -r foo /* > /dev/null'

(normal) perf mem report --percent-limit=1.0 --stdio

 Overhead       Samples
  Local Weight             Memory access                                      Symbol
 ........  ............  ............  ........................  ........................

     4.13%             1  1759          Uncached hit              [k] ahci_scr_read
     1.16%             1  492           L1 hit                    [k] _raw_read_lock

(cpu groups) perf mem report --group-sort=cpu --percent-limit=1.0 --stdio

 Overhead       Samples  CPU
  Local Weight             Memory access                                      Symbol
 ........  ............  ............  ........................  ........................

    28.80%          1239   25
	     3.07%               377           L1 hit                    [k] complete_walk
	     2.76%               339           LFB hit                   [k] update_cfs_shares
	     2.66%               326           LFB hit                   [k] copy_user_enhanced_f
	     2.11%               259           Local RAM hit             [k] copy_user_enhanced_f
	     1.84%               226           LFB hit                   [k] copy_user_enhanced_f
	     1.74%               213           LFB hit                   [k] copy_user_enhanced_f
	     1.53%               187           LFB hit                   [k] copy_user_enhanced_f
	     1.04%               128           LFB hit                   [k] copy_user_enhanced_f
	     1.01%               124           LFB hit                   [k] copy_user_enhanced_f
    27.44%           990    7
	    15.06%               1759          Uncached hit              [k] ahci_scr_read
	     4.21%               492           L1 hit                    [k] _raw_read_lock
	     1.04%               122           LFB hit                   [k] find_busiest_group
	     1.02%            1  7             L1 hit                    [.] __gconv_transform_ut
    20.34%          1010    0
	     4.04%            5  7             L1 hit                    [k] poll_idle
	     3.56%               308           Local RAM hit             [k] copy_user_enhanced_f
	     2.59%               224           L3 hit                    [k] copy_user_enhanced_f
	     2.12%               184           Local RAM hit             [k] copy_user_enhanced_f
	     1.54%            1  7             L1 hit                    [.] __gconv_transform_ut

(pid groups) perf mem report --group-sort=pid --percent-limit=1.0 --stdio

 Overhead       Samples       Command:  Pid
  Local Weight             Memory access                                      Symbol
 ........  ............  ............  ........................  ........................

    67.98%          3023          grep:77842
	     1.70%               492           L1 hit                    [k] _raw_read_lock
	     1.30%               377           L1 hit                    [k] complete_walk
	     1.17%               339           LFB hit                   [k] update_cfs_shares
	     1.13%               326           LFB hit                   [k] copy_user_enhanced_f
	     1.09%            4  7             L1 hit                    [.] __gconv_transform_ut
	     1.06%               308           Local RAM hit             [k] copy_user_enhanced_f
    23.39%           660       swapper:    0
	    17.66%               1759          Uncached hit              [k] ahci_scr_read
	     4.17%               415           L1 hit                    [k] handle_irq
	     3.51%            5  7             L1 hit                    [k] poll_idle
	     3.34%               333           Remote Cache (1 hop) hit  [k] update_cfs_rq_blocke
	     2.79%               278           LFB hit                   [k] add_interrupt_random
	     2.69%               268           L1 hit                    [k] update_cpu_load_nohz
	     2.69%               268           Local RAM hit             [k] find_busiest_group
	     2.51%               250           LFB hit                   [k] ktime_get
	     2.45%               244           L1 hit                    [k] rcu_eqs_exit_common.
	     1.89%               188           LFB hit                   [k] ktime_get
	     1.25%               124           LFB hit                   [k] get_next_timer_inter
     5.90%           186     rcu_sched:    8
	     6.14%               154           L1 hit                    [k] _raw_spin_lock_irq
	     4.42%               111           L1 hit                    [k] _raw_spin_lock_irqsa
	     3.90%               49            L3 hit                    [k] find_busiest_group
	     3.11%               78            LFB hit                   [k] find_busiest_group
	     3.11%               78            LFB hit                   [k] find_busiest_group
	     2.39%               60            LFB hit                   [k] idle_cpu
	     2.27%               57            L3 hit                    [k] idle_cpu
	     2.27%               57            L3 hit                    [k] idle_cpu
	     2.19%               55            L3 hit                    [k] target_load

(cacheline groups) perf mem report --group-sort=cacheline --percent-limit=1.0 --stdio

 Overhead       Samples  Cacheline
  Local Weight             Memory access                                      Symbol
 ........  ............  ............  ........................  ........................

     4.67%           284  [.] 0x0000000000b030c0
	     1.76%               7             L1 hit                    [.] 0x0000000000008651
	     1.41%               7             L1 hit                    [.] 0x00000000000085cc
	     1.41%               7             L1 hit                    [.] 0x00000000000085e4
	     1.41%               7             L1 hit                    [.] 0x00000000000085e4
	     1.41%               7             L1 hit                    [.] 0x00000000000085f8
	     1.41%               7             L1 hit                    [.] 0x0000000000008624
	     1.06%               7             L1 hit                    [.] 0x00000000000085d8
	     1.06%               7             L1 hit                    [.] 0x00000000000085e4
	     1.06%               7             L1 hit                    [.] 0x00000000000085e4
	     1.06%               7             L1 hit                    [.] 0x0000000000008610
	     1.06%               7             L1 hit                    [.] 0x0000000000008610
	     1.06%               7             L1 hit                    [.] 0x0000000000008624
	     1.06%               7             L1 hit                    [.] 0x0000000000008624
	     1.06%               7             L1 hit                    [.] 0x0000000000008645
	     1.06%               7             L1 hit                    [.] 0x0000000000008645
	     1.06%               7             L1 hit                    [.] 0x0000000000008645
	     1.06%               7             L1 hit                    [.] 0x0000000000008651
	     1.06%               7             L1 hit                    [.] 0x0000000000008651
     4.26%           250  [.] 0x0000000000b03080
	     3.91%               71            L3 hit                    [.] 0x0000000000008651
	     1.54%               7             L1 hit                    [.] 0x00000000000085d8
	     1.16%               7             L1 hit                    [.] 0x00000000000085cc
	     1.16%               7             L1 hit                    [.] 0x00000000000085f8
	     1.16%               7             L1 hit                    [.] 0x0000000000008604
	     1.16%               7             L1 hit                    [.] 0x0000000000008624
	     1.16%               7             L1 hit                    [.] 0x0000000000008645
	     1.16%               7             L1 hit                    [.] 0x0000000000008645
	     1.16%               7             L1 hit                    [.] 0x0000000000008645
     4.13%             1  [k] 0xffffc90000062180
	   100.00%               1759          Uncached hit              [k] ahci_scr_read
     3.44%           209  [.] 0x0000000000b03040
	     6.70%            1  7             L1 hit                    [.] 0x00000000000085e4
	     6.22%            1  7             L1 hit                    [.] 0x0000000000008624
	     5.74%            1  7             L1 hit                    [.] 0x00000000000085cc
	     5.74%            1  7             L1 hit                    [.] 0x0000000000008610
	     5.74%            1  7             L1 hit                    [.] 0x0000000000008645
	     5.26%            1  7             L1 hit                    [.] 0x00000000000085d8
	     5.26%            1  7             L1 hit                    [.] 0x0000000000008651
	     4.78%            1  7             L1 hit                    [.] 0x00000000000085f8
	     4.78%            1  7             L1 hit                    [.] 0x0000000000008604
	     2.87%               7             L1 hit                    [.] 0x0000000000008630
	     1.44%               7             L1 hit                    [.] 0x00000000000085f8

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-report.c |   2 +
 tools/perf/ui/gtk/hists.c   |  10 +++
 tools/perf/ui/hist.c        |  19 +++++
 tools/perf/ui/stdio/hist.c  |  69 ++++++++++++++++-
 tools/perf/util/hist.c      |  17 +++++
 tools/perf/util/hist.h      |   3 +
 tools/perf/util/sort.c      | 181 +++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/sort.h      |   4 +
 8 files changed, 301 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 51a37d6..010271e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -764,6 +764,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
 		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
 		   "snoop, locked, abort, in_tx, transaction"),
+	OPT_STRING(0, "group-sort", &group_sort_order, "key[,key2...]",
+		   "group sort by key(s): pid, cacheline"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index befbf3b..ab9c96a 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -200,6 +200,16 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
+	list_for_each_entry(se, &hist_group__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+							    -1, se->se_header,
+							    renderer, "text",
+							    col_idx++, NULL);
+	}
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 21c4e5c..31c74b3 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -319,6 +319,25 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 	return ret;
 }
 
+int hist_entry_group__sort_snprintf(struct hist_entry *he, char *s, size_t size,
+			      struct hists *hists)
+{
+	const char *sep = symbol_conf.field_sep;
+	struct sort_entry *se;
+	int ret = 0;
+
+	list_for_each_entry(se, &hist_group__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
+		ret += se->se_snprintf(he, s + ret, size - ret,
+				       hists__col_len(hists, se->se_width_idx));
+	}
+
+	return ret;
+}
+
 /*
  * See hists__fprintf to match the column widths
  */
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 6c1a85a..c3d3c1b 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -354,6 +354,10 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
+	if (sort__has_group) {
+		*hpp.buf++ = '\t';
+		hpp.size--;
+	}
 	ret = hist_entry__period_snprintf(&hpp, he);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
@@ -365,6 +369,28 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	return ret;
 }
 
+static int hist_entry_group__fprintf(struct hist_entry *he, size_t size,
+				     struct hists *hists,
+				     char *bf, size_t bfsz, FILE *fp)
+{
+	int ret;
+	struct perf_hpp hpp = {
+		.buf		= bf,
+		.size		= size,
+		.total_period	= he->groups->hists->stats.total_period,
+	};
+
+	if (size == 0 || size > bfsz)
+		size = hpp.size = bfsz;
+
+	ret = hist_entry__period_snprintf(&hpp, he);
+	hist_entry_group__sort_snprintf(he, bf + ret, size - ret, hists);
+
+	ret = fprintf(fp, "%s\n", bf);
+
+	return ret;
+}
+
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp)
 {
@@ -403,6 +429,32 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		fprintf(fp, "%s", bf);
 	}
 
+	list_for_each_entry(se, &hist_group__sort_list, list) {
+		if (se->elide)
+			continue;
+		if (sep) {
+			fprintf(fp, "%c%s", *sep, se->se_header);
+			continue;
+		}
+		width = strlen(se->se_header);
+		if (symbol_conf.col_width_list_str) {
+			if (col_width) {
+				hists__set_col_len(hists, se->se_width_idx,
+						   atoi(col_width));
+				col_width = strchr(col_width, ',');
+				if (col_width)
+					++col_width;
+			}
+		}
+		if (!hists__new_col_len(hists, se->se_width_idx, width))
+			width = hists__col_len(hists, se->se_width_idx);
+		fprintf(fp, "  %*s", width, se->se_header);
+	}
+
+	fprintf(fp, "\n");
+	if (max_rows && ++nr_rows >= max_rows)
+		goto out;
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
@@ -481,9 +533,22 @@ print_entries:
 	}
 
 	hist__for_each_group_out(g, hists) {
-		hist_group__for_each_entry_out(h, g) {
+		float percent = g->entry.stat.period * 100.0 /
+					hists->stats.total_period;
+
+		if (percent < min_pcnt)
+			continue;
 
-			float percent = h->stat.period * 100.0 /
+		if (sort__has_group) {
+			ret += hist_entry_group__fprintf(&g->entry, max_cols, hists,
+							 line, linesz, fp);
+
+			if (max_rows && ++nr_rows >= max_rows)
+				break;
+		}
+
+		hist_group__for_each_entry_out(h, g) {
+			percent = h->stat.period * 100.0 /
 					g->entry.stat.period;
 
 			if (h->filtered)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 32cdc7a..f9735c4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -786,6 +786,12 @@ out:
 	return ret;
 }
 
+static int hist_entry_group__sort_on_period(struct hist_entry_group *a,
+					    struct hist_entry_group *b)
+{
+	return period_cmp(a->entry.stat.period, b->entry.stat.period);
+}
+
 static void __hists__insert_output_entry(struct rb_root *entries,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
@@ -818,6 +824,17 @@ static void __hists__insert_output_entry_group(struct rb_root *groups,
 {
 	struct rb_node **p = &groups->rb_node;
 	struct rb_node *parent = NULL;
+	struct hist_entry_group *iter;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry_group, rb_node);
+
+		if (hist_entry_group__sort_on_period(hg, iter) > 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
 
 	rb_link_node(&hg->rb_node, parent, p);
 	rb_insert_color(&hg->rb_node, groups);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1155397..75a041c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -71,6 +71,7 @@ enum hist_column {
 	HISTC_MEM_TLB,
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
+	HISTC_MEM_CACHELINE,
 	HISTC_TRANSACTION,
 	HISTC_NR_COLS, /* Last entry */
 };
@@ -106,6 +107,8 @@ int64_t hist_group__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
 int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
+int hist_entry_group__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
+				    struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *hists);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index c292c78..bfb4a668 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,6 +8,8 @@ const char	default_parent_pattern[] = "^sys_|^do_page_fault";
 const char	*parent_pattern = default_parent_pattern;
 const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
+const char	default_group_sort_order[] = "";
+const char	*group_sort_order = default_group_sort_order;
 regex_t		ignore_callees_regex;
 int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
@@ -61,7 +63,7 @@ static int64_t cmp_null(const void *l, const void *r)
 static int64_t
 sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->tid - left->thread->tid;
+	return right->thread->pid_ - left->thread->pid_;
 }
 
 static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
@@ -809,6 +811,94 @@ static int hist_entry__global_weight_snprintf(struct hist_entry *he, char *bf,
 	return repsep_snprintf(bf, size, "%-*llu", width, he->stat.weight);
 }
 
+#define L1_CACHE_BYTES 64
+#define CACHELINE_MASK (L1_CACHE_BYTES - 1)
+#define CL(x)  (x & ~CACHELINE_MASK)
+
+static int64_t
+sort__cacheline_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 l, r;
+	struct map *l_map = left->mem_info->daddr.map;
+	struct map *r_map = right->mem_info->daddr.map;
+
+	/* store all NULL mem maps at the bottom */
+	/* shouldn't even need this check, should have stubs */
+	if (!left->mem_info->daddr.map || !right->mem_info->daddr.map)
+		return 1;
+
+	/* group event types together */
+	if (left->cpumode > right->cpumode) return -1;
+	if (left->cpumode < right->cpumode) return 1;
+
+	/*
+	 * Addresses with no major/minor numbers are assumed to be
+	 * anonymous in userspace.  Sort those on pid then address.
+	 *
+	 * The kernel and non-zero major/minor mapped areas are
+	 * assumed to be unity mapped.  Sort those on address then pid.
+	 */
+
+	if ((l_map->maj || l_map->min || l_map->ino || l_map-> ino_generation)) {
+		/* mmapped areas */
+
+		if (l_map->maj > r_map->maj) return -1;
+		if (l_map->maj < r_map->maj) return 1;
+
+		if (l_map->min > r_map->min) return -1;
+		if (l_map->min < r_map->min) return 1;
+
+		if (l_map->ino > r_map->ino) return -1;
+		if (l_map->ino < r_map->ino) return 1;
+
+		if (l_map->ino_generation > r_map->ino_generation) return -1;
+		if (l_map->ino_generation < r_map->ino_generation) return 1;
+
+	} else if (left->cpumode != PERF_RECORD_MISC_KERNEL) {
+		/* userspace anonymous */
+		if (left->thread->pid_ > right->thread->pid_) return -1;
+		if (left->thread->pid_ < right->thread->pid_) return 1;
+	}
+
+	/* al_addr does all the right addr - start + offset calculations */
+	l = left->mem_info->daddr.al_addr;
+	r = right->mem_info->daddr.al_addr;
+
+	if (CL(l) > CL(r)) return -1;
+	if (CL(l) < CL(r)) return 1;
+		
+	/* sanity check the maps; only mmaped areas should have different maps */
+	if ((left->mem_info->daddr.map != right->mem_info->daddr.map) &&
+	     !right->mem_info->daddr.map->maj && !right->mem_info->daddr.map->min)
+		pr_debug("mem_cacheline_cmp: Similar entries have different maps\n");
+
+	return 0;
+}
+
+static int hist_entry__cacheline_snprintf(struct hist_entry *he, char *bf,
+					    size_t size, unsigned int width)
+{
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+	char level = he->level;
+
+	if (he->mem_info) {
+		addr = CL(he->mem_info->daddr.al_addr);
+		map = he->mem_info->daddr.map;
+		sym = he->mem_info->daddr.sym;
+
+		/* print [s] for data mmaps */
+		if ((he->cpumode != PERF_RECORD_MISC_KERNEL) &&
+		     map && (map->type == MAP__VARIABLE) &&
+		    (map->maj || map->min || map->ino ||
+		     map-> ino_generation))
+			level = 's';
+	}
+
+	return _hist_entry__sym_snprintf(map, sym, addr, level, bf, size,
+					 width);
+}
 struct sort_entry sort_global_weight = {
 	.se_header	= "Weight",
 	.se_cmp		= sort__global_weight_cmp,
@@ -858,6 +948,13 @@ struct sort_entry sort_mem_snoop = {
 	.se_width_idx	= HISTC_MEM_SNOOP,
 };
 
+struct sort_entry sort_mem_cacheline = {
+	.se_header	= "Cacheline",
+	.se_cmp		= sort__cacheline_cmp,
+	.se_snprintf	= hist_entry__cacheline_snprintf,
+	.se_width_idx	= HISTC_MEM_CACHELINE,
+};
+
 static int64_t
 sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -1000,6 +1097,11 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
 };
 
+static struct sort_dimension common_group_sort_dimensions[] = {
+	DIM(0, "pid", sort_thread),
+	DIM(1, "cpu", sort_cpu),
+};
+
 #undef DIM
 
 #define DIM(d, n, func) [d - __SORT_BRANCH_STACK] = { .name = n, .entry = &(func) }
@@ -1027,6 +1129,12 @@ static struct sort_dimension memory_sort_dimensions[] = {
 	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
 };
 
+static struct sort_dimension memory_group_sort_dimensions[] = {
+	DIM(0 + __SORT_MEMORY_MODE, "cacheline", sort_mem_cacheline),
+	DIM(1 + __SORT_MEMORY_MODE, "mem", sort_mem_lvl),
+	DIM(2 + __SORT_MEMORY_MODE, "snoop", sort_mem_snoop),
+};
+
 #undef DIM
 
 static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
@@ -1109,12 +1217,81 @@ int sort_dimension__add(const char *tok)
 	return -ESRCH;
 }
 
+static void __sort_dimension__add_group(struct sort_dimension *sd, enum sort_type idx)
+{
+	if (sd->taken)
+		return;
+
+	if (sd->entry->se_collapse)
+		sort__need_collapse = 1;
+
+	if (list_empty(&hist_group__sort_list))
+		sort__first_dimension = idx;
+
+	list_add_tail(&sd->entry->list, &hist_group__sort_list);
+	sd->taken = 1;
+}
+
+int sort_dimension__add_group(const char *tok)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(common_group_sort_dimensions); i++) {
+		struct sort_dimension *sd = &common_group_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		sort__has_group = 1;
+
+		__sort_dimension__add_group(sd, i);
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
+		struct sort_dimension *sd = &memory_group_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		if (sort__mode != SORT_MODE__MEMORY)
+			return -EINVAL;
+
+		sort__has_group = 1;
+
+		__sort_dimension__add_group(sd, i + __SORT_MEMORY_MODE);
+		return 0;
+	}
+
+	return -ESRCH;
+}
+
 int setup_sorting(void)
 {
-	char *tmp, *tok, *str = strdup(sort_order);
+	char *tmp, *tok, *str = strdup(group_sort_order);
 	int ret = 0;
 
 	if (str == NULL) {
+		error("Not enough memory to setup group sort keys");
+		return -ENOMEM;
+	}
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		ret = sort_dimension__add_group(tok);
+		if (ret == -EINVAL) {
+			error("Invalid --sort key: `%s'", tok);
+			break;
+		} else if (ret == -ESRCH) {
+			error("Unknown --sort key: `%s'", tok);
+			break;
+		}
+	}
+
+	free(str);
+	str = strdup(sort_order);
+
+	if (str == NULL) {
 		error("Not enough memory to setup sort keys");
 		return -ENOMEM;
 	}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index ff24050..ad5001f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -26,9 +26,11 @@
 
 extern regex_t parent_regex;
 extern const char *sort_order;
+extern const char *group_sort_order;
 extern const char default_parent_pattern[];
 extern const char *parent_pattern;
 extern const char default_sort_order[];
+extern const char default_group_sort_order[];
 extern regex_t ignore_callees_regex;
 extern int have_ignore_callees;
 extern int sort__need_collapse;
@@ -91,6 +93,7 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u8			cpumode;
 
 	struct hist_entry_diff	diff;
 
@@ -322,6 +325,7 @@ extern struct list_head hist_group__sort_list;
 
 int setup_sorting(void);
 extern int sort_dimension__add(const char *);
+extern int sort_dimension__add_group(const char *);
 void sort__setup_elide(FILE *fp);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
-- 
1.7.11.7

