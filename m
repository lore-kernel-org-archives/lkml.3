Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaBJRgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:36:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbaBJRay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:54 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 12/21] perf, c2c: Display cacheline HITM analysis to stdout
Date: Mon, 10 Feb 2014 12:29:07 -0500
Message-Id: <1392053356-23024-13-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch mainly focuses on processing and displaying the collected
HITMs to stdout.  Most of it is just printing data in a pretty way.

There is one trick used when walking the cacheline.  When we get this
far we have two rbtrees.  One rbtree holds every record sorted on a
unique id (using the mmap2 decoder), the other rbtree holds every
cacheline with at least one HITM sorted on number of HITMs.

To display the output, the tool walks the second rbtree to display
the hottest cachelines.  Inside each hot cacheline, the tool displays
the offsets and the loads/stores it generates.  To determine the
cacheline offset, it uses linked list inside the cacheline elment
to walk the first rbtree elements for that particular cacheline.

The first rbtree elements are already sorted correctly in offset order, so
processing the offsets is fairly trivial and is done sequentially.

This is why you will see two while loops in the print_c2c_hitm_report(),
the outer one walks the cachelines, the inner one walks the offsets.

A knob has been added to display node information, which is useful
to see which cpus are involved in the contention and their nodes.

Another knob has been added to change the coalescing levels.  You can
coalesce the output based on pid, tid, ip, and/or symbol.

Original output and statistics done by Dick Fowles, backported by me.

Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 528 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 515 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 8b26ea2..39fd233 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -69,10 +69,13 @@ struct c2c_entry {
 	int			color;
 };
 
+#define DISPLAY_LINE_LIMIT  0.0015
 #define CACHE_LINESIZE       64
 #define CLINE_OFFSET_MSK     (CACHE_LINESIZE - 1)
 #define CLADRS(a)            ((a) & ~(CLINE_OFFSET_MSK))
 #define CLOFFSET(a)          (int)((a) &  (CLINE_OFFSET_MSK))
+#define MAXTITLE_SZ          400
+#define MAXLBL_SZ            256
 
 struct c2c_hit {
 	struct rb_node	rb_node;
@@ -113,6 +116,11 @@ enum { OP, LVL, SNP, LCK, TLB };
 #define LCL_HITM(a,b)        (L3CACHE_HIT(a) && ((b) & PERF_MEM_SNOOP_HITM))
 #define LCL_MEM(a)           (((a) & PERF_MEM_LVL_LOC_RAM) && ((a) & PERF_MEM_LVL_HIT))
 
+enum { LVL0, LVL1, LVL2, LVL3, LVL4, MAX_LVL };
+static int cloffset = LVL1;
+static int node_info = 0;
+static int coalesce_level = LVL1;
+
 static int			max_cpu_num;
 static int			max_node_num;
 static int			*cpunode_map;
@@ -710,6 +718,80 @@ static void c2c_hit__update_strings(struct c2c_hit *h,
 	CPU_SET(n->cpu, &h->stats.cpuset);
 }
 
+static inline bool matching_coalescing(struct c2c_hit *h,
+				       struct c2c_entry *e)
+{
+	bool value = false;
+	struct mem_info *mi = e->mi;
+
+	if (coalesce_level > MAX_LVL)
+		printf("DON: bad coalesce level %d\n", coalesce_level);
+
+	if (e->cpumode != PERF_RECORD_MISC_KERNEL) {
+
+		switch (coalesce_level) {
+
+		case LVL0:
+		case LVL1:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->pid   == e->thread->pid_) &&
+				 (h->tid   == e->thread->tid) &&
+				 (h->iaddr == mi->iaddr.addr));
+			break;
+
+		case LVL2:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->pid   == e->thread->pid_) &&
+				 (h->iaddr == mi->iaddr.addr));
+			break;
+
+		case LVL3:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->iaddr == mi->iaddr.addr));
+			break;
+
+		case LVL4:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->mi->iaddr.sym == mi->iaddr.sym));
+			break;
+
+		default:
+			break;
+
+		}
+
+	} else {
+
+		switch (coalesce_level) {
+
+		case LVL0:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->pid   == e->thread->pid_) &&
+				 (h->tid   == e->thread->tid) &&
+				 (h->iaddr == mi->iaddr.addr));
+			break;
+
+		case LVL1:
+		case LVL2:
+		case LVL3:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->iaddr == mi->iaddr.addr));
+			break;
+
+		case LVL4:
+			value = ((h->daddr == mi->daddr.addr) &&
+				 (h->mi->iaddr.sym == mi->iaddr.sym));
+			break;
+
+		default:
+			break;
+
+		}
+	}
+
+	return value;
+}
+
 static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 				  struct perf_sample *sample __maybe_unused,
 				  struct c2c_entry *entry)
@@ -816,26 +898,442 @@ static void c2c_hit__update_stats(struct c2c_stats *new,
 	new->total_period	+= old->total_period;
 }
 
-static void dump_tree_hitm(struct rb_root *tree,
-			   struct perf_c2c *c2c __maybe_unused)
+static void print_hitm_cacheline_header(void)
+{
+#define SHARING_REPORT_TITLE  "Shared Cache Line Distribution Pareto"
+#define PARTICIPANTS1         "Node{cpus %htims %stores} Node{cpus %hitms %stores} ..."
+#define PARTICIPANTS2         "Node{cpu list}; Node{cpu list}; Node{cpu list}; ..."
+
+	int i;
+	const  char *docptr;
+	static char  delimit[MAXTITLE_SZ];
+	static char  title2[MAXTITLE_SZ];
+	int       pad;
+
+	docptr = " ";
+	if (node_info == 1)
+		docptr = PARTICIPANTS1;
+	if (node_info  == 2)
+		docptr = PARTICIPANTS2;
+
+	sprintf(title2, "%4s %6s %6s %6s %6s %8s %8s %8s %8s %18s %6s %6s %18s %8s %8s %8s %6s %-30s %-20s %s",
+			"Num",
+			"%dist",
+			"%cumm",
+			"%dist",
+			"%cumm",
+			"LLCmiss",
+			"LLChit",
+			"L1 hit",
+			"L1 Miss",
+			"Data Address",
+			"Pid",
+			"Tid",
+			"Inst Address",
+			"median",
+			"mean",
+			"CV  ",
+			"cnt",
+			"Symbol",
+			"Object",
+			docptr);
+
+	for (i = 0; i < (int)strlen(title2); i++) strcat(delimit, "=");
+
+
+	printf("\n\n");
+	printf("%s\n", delimit);
+	printf("\n");
+
+	pad = (strlen(title2)/2) - (strlen(SHARING_REPORT_TITLE)/2);
+	for (i = 0; i < pad; i++) printf(" ");
+	printf("%s\n", SHARING_REPORT_TITLE);
+
+	printf("\n");
+	printf("%4s %13s %13s %17s %8s %8s %18s %6s %6s %18s %26s %6s %30s %20s %s\n",
+		" ",
+		"---- All ----",
+		"-- Shared --",
+		"---- HITM ----",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		"Load Inst Execute Latency",
+		" ",
+		" ",
+		" ",
+		node_info  ? "Shared Data Participants" : " ");
+
+
+	printf("%4s %13s %13s %8s %8s %17s %18s %6s %6s %17s %18s\n",
+		" ",
+		" Data Misses",
+		" Data Misses",
+		"Remote",
+		"Local",
+		"-- Store Refs --",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ");
+
+	printf("%4s %13s %13s %8s %8s %8s %8s %18s %6s %6s %17s %18s %8s %6s\n",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		"---- cycles ----",
+		" ",
+		"cpu");
+
+	printf("%s\n", title2);
+	printf("%s\n", delimit);
+}
+
+static void print_hitm_cacheline(struct c2c_hit *h,
+				 int record,
+				 double tot_cumm,
+				 double ld_cumm,
+				 double tot_dist,
+				 double ld_dist)
+{
+	char pidstr[7];
+	char addrstr[20];
+	static char  summary[MAXLBL_SZ];
+	int j;
+
+	if (h->pid > 0)
+		sprintf(pidstr, "%6d", h->pid);
+	else
+		sprintf(pidstr, "***");
+	/*
+	 * It is possible to have none distinct virtual addresses
+	 * pointing to a distinct SYstem V shared memory region.
+	 * if there are multple virtual addresses the address
+	 * field will be astericks. It would be possible to subsitute
+	 * the physical address but this count be confusing as some
+	 * times the field is a virtual address while or times it
+	 * may be a physical address which may lead to confusion.
+	 */
+	if (h->daddr != ~0UL)
+		sprintf(addrstr, "%#18lx", CLADRS(h->daddr));
+	else
+		sprintf(addrstr, "****************");
+
+
+	sprintf(summary, "%4d %5.1f%% %5.1f%% %5.1f%% %5.1f%% %8d %8d %8d %8d %18s %6s\n",
+			record,
+			tot_dist * 100.,
+			tot_cumm * 100.,
+			ld_dist * 100.,
+			ld_cumm * 100.,
+			h->stats.t.rmt_hitm,
+			h->stats.t.lcl_hitm,
+			h->stats.t.st_l1hit,
+			h->stats.t.st_l1miss,
+			addrstr,
+			pidstr);
+
+	for (j = 0; j < (int)strlen(summary); j++) printf("-");
+	printf("\n");
+	printf("%s", summary);
+	for (j = 0; j < (int)strlen(summary); j++) printf("-");
+	printf("\n");
+}
+
+static void print_socket_stats_str(struct c2c_hit *clo,
+				   struct c2c_stats *node_stats)
 {
-	struct rb_node *next = rb_first(tree);
-	struct c2c_hit *h;
+	int i, j;
+
+	if (!node_stats)
+		return;
+
+	for (i = 0; i < max_node_num; i++) {
+		struct c2c_stats *stats = &node_stats[i];
+		int num = CPU_COUNT(&stats->cpuset);
+
+		if (!num) {
+			/* pad align socket info */
+			for (j = 0; j < 21; j++)
+				printf(" ");
+			continue;
+		}
+
+		printf("%2d{%2d ", i, num);
+
+		if (clo->stats.t.rmt_hitm > 0)
+			printf("%5.1f%% ", 100. * ((double)stats->t.rmt_hitm / (double) clo->stats.t.rmt_hitm));
+		else
+			printf("%6s ", "n/a");
+
+		if (clo->stats.t.store > 0)
+			printf("%5.1f%%} ", 100. * ((double)stats->t.store / (double)clo->stats.t.store));
+		else
+			printf("%6s} ", "n/a");
+	}
+}
+
+static void print_socket_shared_str(struct c2c_stats *node_stats)
+{
+	int i, j;
+
+	if (!node_stats)
+		return;
+
+	for (i = 0; i < max_node_num; i++) {
+		struct c2c_stats *stats = &node_stats[i];
+		int num = CPU_COUNT(&stats->cpuset);
+		int start = -1;
+		bool first = true;
+
+		if (!num)
+			continue;
+
+		printf("%d{", i);
+
+		for (j = 0; j < max_cpu_num; j++) {
+			if (!CPU_ISSET(j, &stats->cpuset)) {
+				if (start != -1) {
+					if ((j-1) - start)
+						/* print the range */
+						printf("%s%d-%d", (first ? "" : ","), start, j-1);
+					else
+						/* standalone */
+						printf("%s%d", (first ? "" : ",") , start);
+					start = -1;
+					first = false;
+				}
+				continue;
+			}
+
+			if (start == -1)
+				start = j;
+		}
+		/* last chunk */
+		if (start != -1) {
+			if ((j-1) - start)
+				/* print the range */
+				printf("%s%d-%d", (first ? "" : ","), start, j-1);
+			else
+				/* standalone */
+				printf("%s%d", (first ? "" : ",") , start);
+		}
+
+		printf("}; ");
+	}
+}
+
+static void print_hitm_cacheline_offset(struct c2c_hit *clo,
+					struct c2c_hit *h,
+					struct c2c_stats *node_stats)
+{
+#define SHORT_STR_LEN	7
+#define LONG_STR_LEN	30
+
+	char pidstr[SHORT_STR_LEN];
+	char tidstr[SHORT_STR_LEN];
+	char addrstr[LONG_STR_LEN];
+	char latstr[LONG_STR_LEN];
+	char objptr[LONG_STR_LEN];
+	char symptr[LONG_STR_LEN];
+	struct c2c_stats *stats = &clo->stats;
+	struct addr_map_symbol *ams;
+
+	ams = &clo->mi->iaddr;
+
+	if (clo->pid >= 0)
+		snprintf(pidstr, SHORT_STR_LEN, "%6d", clo->pid);
+	else
+		sprintf(pidstr, "***");
+
+	if (clo->tid >= 0)
+		snprintf(tidstr, SHORT_STR_LEN, "%6d", clo->tid);
+	else
+		sprintf(tidstr, "***");
+
+	if (clo->iaddr != ~0UL)
+		snprintf(addrstr, LONG_STR_LEN, "%#18lx", clo->iaddr);
+	else
+		sprintf(addrstr, "****************");
+	snprintf(objptr, LONG_STR_LEN, "%-18s", ams->map->dso->short_name);
+	snprintf(symptr, LONG_STR_LEN, "%-18s", (ams->sym ? ams->sym->name : "?????"));
+
+	if (stats->t.rmt_hitm > 0) {
+		double mean = avg_stats(&stats->stats);
+		double std = stddev_stats(&stats->stats);
+
+		sprintf(latstr, "%8.0f %8.0f %7.1f%%",
+			-1.0, /* FIXME */
+			mean,
+			rel_stddev_stats(std, mean));
+	} else {
+		sprintf(latstr, "%8s %8s %8s",
+			"n/a",
+			"n/a",
+			"n/a");
+
+	}
+
+	/*
+	 * implicit assumption that we are not coalescing over IPs
+	 */
+	printf("%4s %6s %6s %6s %6s %7.1f%% %7.1f%% %7.1f%% %7.1f%% %14s0x%02lx %6s %6s %18s %8s %6d %-30s %-20s",
+		" ",
+		" ",
+		" ",
+		" ",
+		" ",
+		(stats->t.rmt_hitm  > 0) ? (100. * ((double)stats->t.rmt_hitm  / (double)h->stats.t.rmt_hitm))  : 0.0,
+		(stats->t.lcl_hitm  > 0) ? (100. * ((double)stats->t.lcl_hitm  / (double)h->stats.t.lcl_hitm))  : 0.0,
+		(stats->t.st_l1hit  > 0) ? (100. * ((double)stats->t.st_l1hit  / (double)h->stats.t.st_l1hit))  : 0.0,
+		(stats->t.st_l1miss > 0) ? (100. * ((double)stats->t.st_l1miss / (double)h->stats.t.st_l1miss)) : 0.0,
+		" ",
+		(cloffset == LVL2) ? (clo->daddr & 0xff) : CLOFFSET(clo->daddr),
+		pidstr,
+		tidstr,
+		addrstr,
+		latstr,
+		CPU_COUNT(&clo->stats.cpuset),
+		symptr,
+		objptr);
+
+	if (node_info == 0)
+		printf("  ");
+	else if (node_info  == 1)
+		print_socket_stats_str(clo, node_stats);
+	else if (node_info  == 2)
+		print_socket_shared_str(node_stats);
+
+	printf("\n");
+}
+
+static void print_c2c_hitm_report(struct rb_root *hitm_tree,
+				  struct c2c_stats *hitm_stats __maybe_unused,
+				  struct c2c_stats *c2c_stats)
+{
+	struct rb_node	*next = rb_first(hitm_tree);
+	struct c2c_hit	*h, *clo = NULL;
+	u64		addr;
+	double		tot_dist, tot_cumm;
+	double		ld_dist, ld_cumm;
+	int		llc_misses;
+	int		record = 0;
+	struct c2c_stats *node_stats = NULL;
+
+	if (node_info) {
+		node_stats = zalloc(sizeof(struct c2c_stats) * max_node_num);
+		if (!node_stats) {
+			printf("Can not allocate stats for node output\n");
+			return;
+		}
+	}
+
+	print_hitm_cacheline_header();
+
+	llc_misses = c2c_stats->t.lcl_dram +
+		     c2c_stats->t.rmt_dram +
+		     c2c_stats->t.rmt_hit +
+		     c2c_stats->t.rmt_hitm;
+
+	/*
+	 * generate distinct cache line report
+	 */
+	tot_cumm = 0.0;
+	ld_cumm  = 0.0;
 
-	printf("%16s %8s %8s %8s\n",
-		"Cacheline", "nr", "loads", "stores");
 	while (next) {
+		struct c2c_entry *entry;
+
 		h = rb_entry(next, struct c2c_hit, rb_node);
 		next = rb_next(&h->rb_node);
 
-		printf("%16lx %8d %8d %8d\n",
-			h->cacheline,
-			h->stats.nr_entries,
-			h->stats.t.load,
-			h->stats.t.store);
+		tot_dist  = ((double)h->stats.t.rmt_hitm / llc_misses);
+		tot_cumm += tot_dist;
+
+		ld_dist  = ((double)h->stats.t.rmt_hitm / c2c_stats->t.rmt_hitm);
+		ld_cumm += ld_dist;
+
+		/*
+		 * don't display lines with insignificant sharing contribution
+		 */
+		if (ld_dist < DISPLAY_LINE_LIMIT)
+			break;
+
+		print_hitm_cacheline(h, record, tot_cumm, ld_cumm, tot_dist, ld_dist);
+
+		list_for_each_entry(entry, &h->list, scratch) {
+
+			if (!clo || !matching_coalescing(clo, entry)) {
+				if (clo)
+					print_hitm_cacheline_offset(clo, h, node_stats);
+
+				free(clo);
+				addr = entry->mi->iaddr.al_addr;
+				clo = c2c_hit__new(addr, entry);
+				if (node_info)
+					memset(node_stats, 0, sizeof(struct c2c_stats) * max_node_num);
+			}
+			c2c_decode_stats(&clo->stats, entry);
+			c2c_hit__update_strings(clo, entry);
+
+			if (node_info) {
+				int node = cpunode_map[entry->cpu];
+				c2c_decode_stats(&node_stats[node], entry);
+				CPU_SET(entry->cpu, &(node_stats[node].cpuset));
+			}
+
+		}
+		if (clo) {
+			print_hitm_cacheline_offset(clo, h, node_stats);
+			free(clo);
+			clo = NULL;
+		}
+
+		if (node_info)
+			memset(node_stats, 0, sizeof(struct c2c_stats) * max_node_num);
+
+		printf("\n");
+		record++;
 	}
 }
 
+static inline int valid_hitm_or_store(union perf_mem_data_src *dsrc)
+{
+	return ((dsrc->mem_snoop & P(SNOOP,HITM)) ||
+		(dsrc->mem_op & P(OP,STORE)));
+}
+
+static void print_shared_cacheline_info(struct c2c_stats *stats, int cline_cnt)
+{
+	int hitm_cnt = stats->t.lcl_hitm + stats->t.rmt_hitm;
+
+	printf("=================================================\n");
+	printf("    Global Shared Cache Line Event Information   \n");
+	printf("=================================================\n");
+	printf("  Total Shared Cache Lines          : %10d\n", cline_cnt);
+	printf("  Load HITs on shared lines         : %10d\n", stats->t.load);
+	printf("  Fill Buffer Hits on shared lines  : %10d\n", stats->t.ld_fbhit);
+	printf("  L1D hits on shared lines          : %10d\n", stats->t.ld_l1hit);
+	printf("  L2D hits on shared lines          : %10d\n", stats->t.ld_l2hit);
+	printf("  LLC hits on shared lines          : %10d\n", stats->t.ld_llchit + stats->t.lcl_hitm);
+	printf("  Locked Access on shared lines     : %10d\n", stats->t.locks);
+	printf("  Store HITs on shared lines        : %10d\n", stats->t.store);
+	printf("  Store L1D hits on shared lines    : %10d\n", stats->t.st_l1hit);
+	printf("  Total Merged records              : %10d\n", hitm_cnt + stats->t.store);
+}
+
 static void c2c_analyze_hitms(struct perf_c2c *c2c)
 {
 
@@ -894,8 +1392,8 @@ static void c2c_analyze_hitms(struct perf_c2c *c2c)
 	} else
 		free(h);
 
-	if (verbose > 2)
-		dump_tree_hitm(&c2c->tree_hitm, c2c);
+	print_shared_cacheline_info(&hitm_stats, shared_clines);
+	print_c2c_hitm_report(&hitm_tree, &hitm_stats, &c2c->stats);
 
 cleanup:
 	next = rb_first(&hitm_tree);
@@ -1026,6 +1524,10 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 	};
 	const struct option c2c_options[] = {
 	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
+	OPT_INCR('N', "node-info", &node_info,
+		 "show extra node info in report (repeat for more info)"),
+	OPT_INTEGER('c', "coalesce-level", &coalesce_level,
+		 "how much coalescing for tid, pid, and ip is done (repeat for more coalescing)"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('i', "input", &input_name, "file",
-- 
1.7.11.7

