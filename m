Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3BVO2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:28:45 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44141 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3BVO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:28:44 -0500
Date: Fri, 22 Feb 2013 15:28:38 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jolsa@redhat.com, peterz@infradead.org, mingo@elte.hu,
        namhyung@gmail.com
Subject: [PATCH] perf report: fix handling of memory sampling sort orders
Message-ID: <20130222142838.GA2847@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When the memory sampling sort orders were used on perf.data
files without memory sampling data, it would crash perf. This
patch fixes this by  handling the lack of memory information
gracefully, printing N/A and formatting columns correctly
whenever necessary.

This patch is to be applied on top of the memory sampling
patchset. It is relative to Arnaldo's perf/mem branch.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 4008b7f..98572ca 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -99,6 +99,13 @@ struct perf_sample {
 	struct stack_dump user_stack;
 };
 
+#define PERF_MEM_DATA_SRC_NONE \
+	(PERF_MEM_S(OP, NA) |\
+	 PERF_MEM_S(LVL, NA) |\
+	 PERF_MEM_S(SNOOP, NA) |\
+	 PERF_MEM_S(LOCK, NA) |\
+	 PERF_MEM_S(TLB, NA))
+
 struct build_id_event {
 	struct perf_event_header header;
 	pid_t			 pid;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bace0cc..d1799a4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1175,7 +1175,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
-	data->dsrc = 0;
+	data->dsrc = PERF_MEM_DATA_SRC_NONE;
 	if (type & PERF_SAMPLE_DATA_SRC) {
 		data->dsrc = *array;
 		array++;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 043593d..454d7f1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -118,7 +118,9 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			hists__new_col_len(hists, HISTC_SYMBOL_TO, symlen);
 			hists__set_unres_dso_col_len(hists, HISTC_DSO_TO);
 		}
-	} else if (h->mem_info) {
+	}
+
+	if (h->mem_info) {
 		/*
 		 * +4 accounts for '[x] ' priv level info
 		 * +2 account of 0x prefix on raw addresses
@@ -141,11 +143,15 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			symlen = unresolved_col_width + 4 + 2;
 			hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
 		}
-		hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
-		hists__new_col_len(hists, HISTC_MEM_TLB, 22);
-		hists__new_col_len(hists, HISTC_MEM_SNOOP, 12);
-		hists__new_col_len(hists, HISTC_MEM_LVL, 21+3);
+	} else {
+		symlen = unresolved_col_width + 4 + 2;
+		hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL, symlen);
+		hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
 	}
+	hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
+	hists__new_col_len(hists, HISTC_MEM_TLB, 22);
+	hists__new_col_len(hists, HISTC_MEM_SNOOP, 12);
+	hists__new_col_len(hists, HISTC_MEM_LVL, 21+3);
 
 }
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1dc3860..0fdaac7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -198,7 +198,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
-	if (sym) {
+	if (sym && map) {
 		if (map->type == MAP__VARIABLE) {
 			ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
 			ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
@@ -469,39 +469,72 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *self, char *bf,
 static int64_t
 sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct addr_map_symbol *l = &left->mem_info->daddr;
-	struct addr_map_symbol *r = &right->mem_info->daddr;
+	uint64_t l = 0, r = 0;
 
-	return (int64_t)(r->addr - l->addr);
+	if (left->mem_info)
+		l = left->mem_info->daddr.addr;
+	if (right->mem_info)
+		r = right->mem_info->daddr.addr;
+
+	return (int64_t)(r - l);
 }
 
 static int hist_entry__daddr_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__sym_snprintf(self->mem_info->daddr.map,
-					 self->mem_info->daddr.sym,
-					 self->mem_info->daddr.addr,
-					 self->level, bf, size, width);
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+
+	if (self->mem_info) {
+		addr = self->mem_info->daddr.addr;
+		map = self->mem_info->daddr.map;
+		sym = self->mem_info->daddr.sym;
+	}
+	return _hist_entry__sym_snprintf(map, sym, addr, self->level, bf, size,
+					 width);
 }
 
 static int64_t
 sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->mem_info->daddr.map, right->mem_info->daddr.map);
+	struct map *map_l = NULL;
+	struct map *map_r = NULL;
+
+	if (left->mem_info)
+		map_l = left->mem_info->daddr.map;
+	if (right->mem_info)
+		map_r = right->mem_info->daddr.map;
+
+	return _sort__dso_cmp(map_l, map_r);
 }
 
 static int hist_entry__dso_daddr_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(self->mem_info->daddr.map, bf, size,
-					 width);
+	struct map *map = NULL;
+
+	if (self->mem_info)
+		map = self->mem_info->daddr.map;
+
+	return _hist_entry__dso_snprintf(map, bf, size, width);
 }
 
 static int64_t
 sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	union perf_mem_data_src dsrc_l = left->mem_info->dsrc;
-	union perf_mem_data_src dsrc_r = right->mem_info->dsrc;
+	union perf_mem_data_src dsrc_l;
+	union perf_mem_data_src dsrc_r;
+
+	if (left->mem_info)
+		dsrc_l = left->mem_info->dsrc;
+	else
+		dsrc_l.mem_lock = PERF_MEM_LOCK_NA;
+
+	if (right->mem_info)
+		dsrc_r = right->mem_info->dsrc;
+	else
+		dsrc_r.mem_lock = PERF_MEM_LOCK_NA;
 
 	return (int64_t)(dsrc_r.mem_lock - dsrc_l.mem_lock);
 }
@@ -509,8 +542,11 @@ sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__locked_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width)
 {
-	const char *out = "??";
-	u64 mask = self->mem_info->dsrc.mem_lock;
+	const char *out;
+	u64 mask = PERF_MEM_LOCK_NA;
+
+	if (self->mem_info)
+		mask = self->mem_info->dsrc.mem_lock;
 
 	if (mask & PERF_MEM_LOCK_NA)
 		out = "N/A";
@@ -525,8 +561,18 @@ static int hist_entry__locked_snprintf(struct hist_entry *self, char *bf,
 static int64_t
 sort__tlb_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	union perf_mem_data_src dsrc_l = left->mem_info->dsrc;
-	union perf_mem_data_src dsrc_r = right->mem_info->dsrc;
+	union perf_mem_data_src dsrc_l;
+	union perf_mem_data_src dsrc_r;
+
+	if (left->mem_info)
+		dsrc_l = left->mem_info->dsrc;
+	else
+		dsrc_l.mem_dtlb = PERF_MEM_TLB_NA;
+
+	if (right->mem_info)
+		dsrc_r = right->mem_info->dsrc;
+	else
+		dsrc_r.mem_dtlb = PERF_MEM_TLB_NA;
 
 	return (int64_t)(dsrc_r.mem_dtlb - dsrc_l.mem_dtlb);
 }
@@ -548,11 +594,14 @@ static int hist_entry__tlb_snprintf(struct hist_entry *self, char *bf,
 	char out[64];
 	size_t sz = sizeof(out) - 1; /* -1 for null termination */
 	size_t l = 0, i;
-	u64 m = self->mem_info->dsrc.mem_dtlb;
+	u64 m = PERF_MEM_TLB_NA;
 	u64 hit, miss;
 
 	out[0] = '\0';
 
+	if (self->mem_info)
+		m = self->mem_info->dsrc.mem_dtlb;
+
 	hit = m & PERF_MEM_TLB_HIT;
 	miss = m & PERF_MEM_TLB_MISS;
 
@@ -569,6 +618,8 @@ static int hist_entry__tlb_snprintf(struct hist_entry *self, char *bf,
 		strncat(out, tlb_access[i], sz - l);
 		l += strlen(tlb_access[i]);
 	}
+	if (*out == '\0')
+		strcpy(out, "N/A");
 	if (hit)
 		strncat(out, " hit", sz - l);
 	if (miss)
@@ -580,8 +631,18 @@ static int hist_entry__tlb_snprintf(struct hist_entry *self, char *bf,
 static int64_t
 sort__lvl_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	union perf_mem_data_src dsrc_l = left->mem_info->dsrc;
-	union perf_mem_data_src dsrc_r = right->mem_info->dsrc;
+	union perf_mem_data_src dsrc_l;
+	union perf_mem_data_src dsrc_r;
+
+	if (left->mem_info)
+		dsrc_l = left->mem_info->dsrc;
+	else
+		dsrc_l.mem_lvl = PERF_MEM_LVL_NA;
+
+	if (right->mem_info)
+		dsrc_r = right->mem_info->dsrc;
+	else
+		dsrc_r.mem_lvl = PERF_MEM_LVL_NA;
 
 	return (int64_t)(dsrc_r.mem_lvl - dsrc_l.mem_lvl);
 }
@@ -610,9 +671,12 @@ static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
 	char out[64];
 	size_t sz = sizeof(out) - 1; /* -1 for null termination */
 	size_t i, l = 0;
-	u64 m = self->mem_info->dsrc.mem_lvl;
+	u64 m =  PERF_MEM_LVL_NA;
 	u64 hit, miss;
 
+	if (self->mem_info)
+		m  = self->mem_info->dsrc.mem_lvl;
+
 	out[0] = '\0';
 
 	hit = m & PERF_MEM_LVL_HIT;
@@ -631,6 +695,8 @@ static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
 		strncat(out, mem_lvl[i], sz - l);
 		l += strlen(mem_lvl[i]);
 	}
+	if (*out == '\0')
+		strcpy(out, "N/A");
 	if (hit)
 		strncat(out, " hit", sz - l);
 	if (miss)
@@ -642,8 +708,18 @@ static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
 static int64_t
 sort__snoop_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	union perf_mem_data_src dsrc_l = left->mem_info->dsrc;
-	union perf_mem_data_src dsrc_r = right->mem_info->dsrc;
+	union perf_mem_data_src dsrc_l;
+	union perf_mem_data_src dsrc_r;
+
+	if (left->mem_info)
+		dsrc_l = left->mem_info->dsrc;
+	else
+		dsrc_l.mem_snoop = PERF_MEM_SNOOP_NA;
+
+	if (right->mem_info)
+		dsrc_r = right->mem_info->dsrc;
+	else
+		dsrc_r.mem_snoop = PERF_MEM_SNOOP_NA;
 
 	return (int64_t)(dsrc_r.mem_snoop - dsrc_l.mem_snoop);
 }
@@ -663,10 +739,13 @@ static int hist_entry__snoop_snprintf(struct hist_entry *self, char *bf,
 	char out[64];
 	size_t sz = sizeof(out) - 1; /* -1 for null termination */
 	size_t i, l = 0;
-	u64 m = self->mem_info->dsrc.mem_snoop;
+	u64 m = PERF_MEM_SNOOP_NA;
 
 	out[0] = '\0';
 
+	if (self->mem_info)
+		m = self->mem_info->dsrc.mem_snoop;
+
 	for (i = 0; m && i < NUM_SNOOP_ACCESS; i++, m >>= 1) {
 		if (!(m & 0x1))
 			continue;
@@ -678,6 +757,9 @@ static int hist_entry__snoop_snprintf(struct hist_entry *self, char *bf,
 		l += strlen(snoop_access[i]);
 	}
 
+	if (*out == '\0')
+		strcpy(out, "N/A");
+
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
