Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423123Ab3FUOW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:22:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41112 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161504Ab3FUOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:22:10 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 8/8] perf mem: add physical addr sampling support
Date: Fri, 21 Jun 2013 16:20:48 +0200
Message-Id: <1371824448-7306-9-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for PERF_SAMPLE_PHYS_ADDR to perf mem
and supporting code in the infrastructure.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-mem.c    | 116 +++++++++++++++++++++++++++++++++-----------
 tools/perf/builtin-report.c |   2 +-
 tools/perf/util/hist.c      |   4 +-
 tools/perf/util/hist.h      |   1 +
 tools/perf/util/machine.c   |   1 +
 tools/perf/util/sort.c      |  42 ++++++++++++++++
 tools/perf/util/sort.h      |   1 +
 tools/perf/util/symbol.h    |   1 +
 8 files changed, 139 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index a8ff6d2..5946f6a 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -17,6 +17,7 @@ struct perf_mem {
 	symbol_filter_t		annotate_init;
 	bool			hide_unresolved;
 	bool			dump_raw;
+	bool			phys_addr;
 	const char		*cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
@@ -26,14 +27,14 @@ static const char * const mem_usage[] = {
 	NULL
 };
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
 	char event[64];
 	int ret;
 
-	rec_argc = argc + 4;
+	rec_argc = argc + 5;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	if (!rec_argv)
 		return -1;
@@ -42,6 +43,10 @@ static int __cmd_record(int argc, const char **argv)
 	if (!strcmp(mem_operation, MEM_OPERATION_LOAD))
 		rec_argv[i++] = strdup("-W");
 	rec_argv[i++] = strdup("-d");
+
+	if (mem->phys_addr)
+		rec_argv[i++] = strdup("--phys-addr");
+
 	rec_argv[i++] = strdup("-e");
 
 	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
@@ -83,29 +88,62 @@ dump_raw_samples(struct perf_tool *tool,
 		al.map->dso->hit = 1;
 
 	if (symbol_conf.field_sep) {
-		fmt = "%d%s%d%s0x%"PRIx64"%s0x%"PRIx64"%s%"PRIu64
-		      "%s0x%"PRIx64"%s%s:%s\n";
+		if (mem->phys_addr)
+			fmt = "%d%s%d%s%d%s0x%"PRIx64"%s0x%"PRIx64"%s0x%"PRIx64
+			      "%s%"PRIu64"%s0x%"PRIx64"%s%s:%s\n";
+		else
+			fmt = "%d%s%d%s%d%s0x%"PRIx64"%s0x%"PRIx64
+			      "%s%"PRIu64"%s0x%"PRIx64"%s%s:%s\n";
 	} else {
-		fmt = "%5d%s%5d%s0x%016"PRIx64"%s0x016%"PRIx64
-		      "%s%5"PRIu64"%s0x%06"PRIx64"%s%s:%s\n";
+		if (mem->phys_addr)
+			fmt = "%5d%s%5d%s%5d%s0x%016"PRIx64"%s0x%016"PRIx64
+			      "%s0x016%"PRIx64"%s%5"PRIu64"%s0x%06"
+			      PRIx64"%s%s:%s\n";
+		else
+			fmt = "%5d%s%5d%s%5d%s0x%016"PRIx64"%s0x016%"PRIx64
+			      "%s%5"PRIu64"%s0x%06"PRIx64"%s%s:%s\n";
 		symbol_conf.field_sep = " ";
 	}
-
-	printf(fmt,
-		sample->pid,
-		symbol_conf.field_sep,
-		sample->tid,
-		symbol_conf.field_sep,
-		event->ip.ip,
-		symbol_conf.field_sep,
-		sample->addr,
-		symbol_conf.field_sep,
-		sample->weight,
-		symbol_conf.field_sep,
-		sample->data_src,
-		symbol_conf.field_sep,
-		al.map ? (al.map->dso ? al.map->dso->long_name : "???") : "???",
-		al.sym ? al.sym->name : "???");
+	if (mem->phys_addr)
+		printf(fmt,
+		       sample->pid,
+		       symbol_conf.field_sep,
+		       sample->tid,
+		       symbol_conf.field_sep,
+		       sample->cpu,
+		       symbol_conf.field_sep,
+		       event->ip.ip,
+		       symbol_conf.field_sep,
+		       sample->addr,
+		       symbol_conf.field_sep,
+		       sample->paddr,
+		       symbol_conf.field_sep,
+		       sample->weight,
+		       symbol_conf.field_sep,
+		       sample->data_src,
+		       symbol_conf.field_sep,
+		       al.map ? (al.map->dso ?
+				 al.map->dso->long_name : "???") : "???",
+		       al.sym ? al.sym->name : "???");
+	else
+		printf(fmt,
+		       sample->pid,
+		       symbol_conf.field_sep,
+		       sample->tid,
+		       symbol_conf.field_sep,
+		       sample->cpu,
+		       symbol_conf.field_sep,
+		       event->ip.ip,
+		       symbol_conf.field_sep,
+		       sample->addr,
+		       symbol_conf.field_sep,
+		       sample->weight,
+		       symbol_conf.field_sep,
+		       sample->data_src,
+		       symbol_conf.field_sep,
+		       al.map ? (al.map->dso ?
+				 al.map->dso->long_name : "???") : "???",
+		       al.sym ? al.sym->name : "???");
 
 	return 0;
 }
@@ -139,7 +177,10 @@ static int report_raw_events(struct perf_mem *mem)
 	if (symbol__init() < 0)
 		return -1;
 
-	printf("# PID, TID, IP, ADDR, LOCAL WEIGHT, DSRC, SYMBOL\n");
+	if (mem->phys_addr)
+		printf("# PID, TID, CPU, IP, ADDR, PADDR, LOCAL WEIGHT, DSRC, SYMBOL\n");
+	else
+		printf("# PID, TID, CPU, IP, ADDR, LOCAL WEIGHT, DSRC, SYMBOL\n");
 
 	err = perf_session__process_events(session, &mem->tool);
 	if (err)
@@ -152,15 +193,33 @@ out_delete:
 	return err;
 }
 
+static const char *ld_sort_order = "--sort=mem,sym,dso,symbol_daddr,dso_daddr,"
+				   "tlb,locked";
+static const char *st_sort_order = "--sort=local_weight,mem,sym,dso,"
+				   "symbol_daddr,dso_daddr,snoop,tlb,locked";
+static const char *ld_sort_order_p = "--sort=mem,sym,dso,symbol_daddr,"
+				     "symbol_paddr,dso_daddr,tlb,locked";
+static const char *st_sort_order_p = "--sort=local_weight,mem,sym,dso,"
+				     "symbol_daddr,symbol_paddr,dso_daddr,snoop,tlb,locked";
+
 static int report_events(int argc, const char **argv, struct perf_mem *mem)
 {
 	const char **rep_argv;
+	const char *ld_sort, *st_sort;
 	int ret, i = 0, j, rep_argc;
 
 	if (mem->dump_raw)
 		return report_raw_events(mem);
 
-	rep_argc = argc + 3;
+	if (mem->phys_addr) {
+		ld_sort = ld_sort_order_p;
+		st_sort = st_sort_order_p;
+	} else {
+		ld_sort = ld_sort_order;
+		st_sort = st_sort_order;
+	}
+
+	rep_argc = argc + 4;
 	rep_argv = calloc(rep_argc + 1, sizeof(char *));
 	if (!rep_argv)
 		return -1;
@@ -174,8 +233,9 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 	 * the column
 	 */
 	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
-		rep_argv[i++] = strdup("--sort=mem,sym,dso,symbol_daddr,"
-				       "dso_daddr,tlb,locked");
+		rep_argv[i++] = strdup(st_sort);
+	else
+		rep_argv[i++] = strdup(ld_sort);
 
 	for (j = 1; j < argc; j++, i++)
 		rep_argv[i] = argv[j];
@@ -207,6 +267,8 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "dump raw samples in ASCII"),
 	OPT_BOOLEAN('U', "hide-unresolved", &mem.hide_unresolved,
 		    "Only display entries resolved to a symbol"),
+	OPT_BOOLEAN(0, "phys-addr", &mem.phys_addr,
+		    "sample physical data addr"),
 	OPT_STRING('i', "input", &input_name, "file",
 		   "input file name"),
 	OPT_STRING('C', "cpu", &mem.cpu_list, "cpu",
@@ -232,7 +294,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
+		return __cmd_record(argc, argv, &mem);
 	else if (!strncmp(argv[0], "rep", 3))
 		return report_events(argc, argv, &mem);
 	else
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca98d34..6b2531f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -894,7 +894,7 @@ repeat:
 		 * branch-mode specific order
 		 */
 		if (sort_order == default_sort_order)
-			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+			sort_order = "local_weight,mem,sym,dso,symbol_daddr,symbol_paddr,dso_daddr,snoop,tlb,locked";
 	}
 
 	if (setup_sorting() < 0)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b11a6cf..136a851 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -148,10 +148,12 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
 		}
 	} else {
-		symlen = unresolved_col_width + 4 + 2;
+		symlen = unresolved_col_width + 2 + 4;
 		hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
 	}
+	symlen = unresolved_col_width + 2;
+	hists__new_col_len(hists, HISTC_MEM_PADDR_SYMBOL, symlen);
 
 	hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
 	hists__new_col_len(hists, HISTC_MEM_TLB, 22);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2d3790f..9add9ae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -52,6 +52,7 @@ enum hist_column {
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
 	HISTC_MEM_DADDR_SYMBOL,
+	HISTC_MEM_PADDR_SYMBOL,
 	HISTC_MEM_DADDR_DSO,
 	HISTC_MEM_LOCKED,
 	HISTC_MEM_TLB,
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..7823460 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1133,6 +1133,7 @@ struct mem_info *machine__resolve_mem(struct machine *machine,
 	ip__resolve_ams(machine, thr, &mi->iaddr, sample->ip);
 	ip__resolve_data(machine, thr, cpumode, &mi->daddr, sample->addr);
 	mi->data_src.val = sample->data_src;
+	mi->paddr = sample->paddr;
 
 	return mi;
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 313a5a7..1a0ea58 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -497,6 +497,39 @@ static int hist_entry__daddr_snprintf(struct hist_entry *self, char *bf,
 }
 
 static int64_t
+sort__paddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	uint64_t l = 0, r = 0;
+
+	if (left->mem_info)
+		l = left->mem_info->paddr;
+	if (right->mem_info)
+		r = right->mem_info->paddr;
+
+	return (int64_t)(r - l);
+}
+
+static int hist_entry__paddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	uint64_t addr = 0;
+	size_t len = BITS_PER_LONG / 4;
+	int ret = 0;
+
+	if (!self->mem_info)
+		return 0;
+
+	addr = self->mem_info->paddr;
+
+	ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx",
+			       len, addr);
+	ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+			       width - ret, "");
+	return ret;
+}
+
+
+static int64_t
 sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	struct map *map_l = NULL;
@@ -821,6 +854,14 @@ struct sort_entry sort_mem_daddr_sym = {
 	.se_width_idx	= HISTC_MEM_DADDR_SYMBOL,
 };
 
+struct sort_entry sort_mem_paddr_sym = {
+	.se_header	= "Data Physical Addr",
+	.se_cmp		= sort__paddr_cmp,
+	.se_snprintf	= hist_entry__paddr_snprintf,
+	.se_width_idx	= HISTC_MEM_PADDR_SYMBOL,
+};
+
+
 struct sort_entry sort_mem_daddr_dso = {
 	.se_header	= "Data Object",
 	.se_cmp		= sort__dso_daddr_cmp,
@@ -894,6 +935,7 @@ static struct sort_dimension memory_sort_dimensions[] = {
 	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
+	DIM(SORT_MEM_PADDR_SYMBOL, "symbol_paddr", sort_mem_paddr_sym),
 	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
 	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
 	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 45ac84c..4d4bdce 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -152,6 +152,7 @@ enum sort_type {
 	SORT_LOCAL_WEIGHT = __SORT_MEMORY_MODE,
 	SORT_GLOBAL_WEIGHT,
 	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_PADDR_SYMBOL,
 	SORT_MEM_DADDR_DSO,
 	SORT_MEM_LOCKED,
 	SORT_MEM_TLB,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5f720dc..c2e933c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -159,6 +159,7 @@ struct branch_info {
 struct mem_info {
 	struct addr_map_symbol iaddr;
 	struct addr_map_symbol daddr;
+	u64		       paddr;
 	union perf_mem_data_src data_src;
 };
 
-- 
1.8.1.2

