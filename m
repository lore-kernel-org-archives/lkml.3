Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3AXPLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:11:46 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52369 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3AXPLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:11:42 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v7 11/18] perf tools: add mem access sampling core support
Date: Thu, 24 Jan 2013 16:10:35 +0100
Message-Id: <1359040242-8269-12-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the sorting and histogram support
functions to enable profiling of memory accesses.

The following sorting orders are added:
 - symbol_daddr: data address symbol (or raw address)
 - dso_daddr: data address shared object
 - locked: access uses locked transaction
 - tlb : TLB access
 - mem : memory level of the access (L1, L2, L3, RAM, ...)
 - snoop: access snoop mode

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/event.h   |    1 +
 tools/perf/util/evsel.c   |    6 +
 tools/perf/util/hist.c    |   77 +++++++++++-
 tools/perf/util/hist.h    |   13 ++
 tools/perf/util/session.c |   38 ++++++
 tools/perf/util/session.h |    4 +
 tools/perf/util/sort.c    |  297 ++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/sort.h    |    9 +-
 tools/perf/util/symbol.h  |    6 +
 9 files changed, 441 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a97fbbe..4008b7f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -91,6 +91,7 @@ struct perf_sample {
 	u64 weight;
 	u32 cpu;
 	u32 raw_size;
+	u64 dsrc;
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 805d33e..49daa7b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1068,6 +1068,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->dsrc = 0;
+	if (type & PERF_SAMPLE_DSRC) {
+		data->dsrc = *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a8d7647..9203683 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -66,12 +66,16 @@ static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
 void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 {
 	const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
+	int symlen;
 	u16 len;
 
 	if (h->ms.sym)
 		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen + 4);
-	else
+	else {
+		symlen = unresolved_col_width + 4 + 2;
+		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
+	}
 
 	len = thread__comm_len(h->thread);
 	if (hists__new_col_len(hists, HISTC_COMM, len))
@@ -83,7 +87,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	}
 
 	if (h->branch_info) {
-		int symlen;
 		/*
 		 * +4 accounts for '[x] ' priv level info
 		 * +2 account of 0x prefix on raw addresses
@@ -111,7 +114,35 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			hists__new_col_len(hists, HISTC_SYMBOL_TO, symlen);
 			hists__set_unres_dso_col_len(hists, HISTC_DSO_TO);
 		}
+	} else if (h->mem_info) {
+		/*
+		 * +4 accounts for '[x] ' priv level info
+		 * +2 account of 0x prefix on raw addresses
+		 */
+		if (h->mem_info->daddr.sym) {
+			symlen = (int)h->mem_info->daddr.sym->namelen + 4
+			       + unresolved_col_width + 2;
+			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
+					   symlen);
+		} else {
+			symlen = unresolved_col_width + 4 + 2;
+			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
+					   symlen);
+		}
+		if (h->mem_info->daddr.map) {
+			symlen = dso__name_len(h->mem_info->daddr.map->dso);
+			hists__new_col_len(hists, HISTC_MEM_DADDR_DSO,
+					   symlen);
+		} else {
+			symlen = unresolved_col_width + 4 + 2;
+			hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
+		}
+		hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
+		hists__new_col_len(hists, HISTC_MEM_TLB, 22);
+		hists__new_col_len(hists, HISTC_MEM_SNOOP, 12);
+		hists__new_col_len(hists, HISTC_MEM_LVL, 21+3);
 	}
+
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -154,6 +185,7 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 static void he_stat__add_period(struct he_stat *he_stat, u64 period,
 				u64 weight)
 {
+
 	he_stat->period		+= period;
 	he_stat->weight		+= weight;
 	he_stat->nr_events	+= 1;
@@ -239,13 +271,19 @@ void hists__decay_entries_threaded(struct hists *hists,
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
 {
 	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
-	struct hist_entry *he = malloc(sizeof(*he) + callchain_size);
+	struct hist_entry *he = calloc(1, sizeof(*he) + callchain_size);
 
 	if (he != NULL) {
 		*he = *template;
 
 		if (he->ms.map)
 			he->ms.map->referenced = true;
+		if (he->mem_info) {
+			if (he->mem_info->iaddr.map)
+				he->mem_info->iaddr.map->referenced = true;
+			if (he->mem_info->daddr.map)
+				he->mem_info->daddr.map->referenced = true;
+		}
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
 
@@ -328,6 +366,36 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	return he;
 }
 
+struct hist_entry *__hists__add_mem_entry(struct hists *self,
+					  struct addr_location *al,
+					  struct symbol *sym_parent,
+					  struct mem_info *mi,
+					  u64 period,
+					  u64 weight)
+{
+	struct hist_entry entry = {
+		.thread	= al->thread,
+		.ms = {
+			.map	= al->map,
+			.sym	= al->sym,
+		},
+		.stat = {
+			.period	= period,
+			.weight = weight,
+			.nr_events = 1,
+		},
+		.cpu	= al->cpu,
+		.ip	= al->addr,
+		.level	= al->level,
+		.parent = sym_parent,
+		.filtered = symbol__parent_filter(sym_parent),
+		.hists = self,
+		.mem_info = mi,
+		.branch_info = NULL,
+	};
+	return add_hist_entry(self, &entry, al, period, weight);
+}
+
 struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
@@ -353,6 +421,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.filtered = symbol__parent_filter(sym_parent),
 		.branch_info = bi,
 		.hists	= self,
+		.mem_info = NULL,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
@@ -380,6 +449,8 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
+		.branch_info = NULL,
+		.mem_info = NULL,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c769984a..012fb99 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -51,6 +51,12 @@ enum hist_column {
 	HISTC_SRCLINE,
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
+	HISTC_MEM_DADDR_SYMBOL,
+	HISTC_MEM_DADDR_DSO,
+	HISTC_MEM_LOCKED,
+	HISTC_MEM_TLB,
+	HISTC_MEM_LVL,
+	HISTC_MEM_SNOOP,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -90,6 +96,13 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     u64 period,
 					     u64 weight);
 
+struct hist_entry *__hists__add_mem_entry(struct hists *self,
+					  struct addr_location *al,
+					  struct symbol *sym_parent,
+					  struct mem_info *mi,
+					  u64 period,
+					  u64 weight);
+
 void hists__output_resort(struct hists *self);
 void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8fe3688..698be69 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -273,6 +273,41 @@ static void ip__resolve_ams(struct machine *self, struct thread *thread,
 	ams->map = al.map;
 }
 
+static void ip__resolve_data(struct machine *self, struct thread *thread,
+			     u8 m,
+			    struct addr_map_symbol *ams,
+			    u64 addr)
+{
+	struct addr_location al;
+
+	memset(&al, 0, sizeof(al));
+
+	thread__find_addr_location(thread, self, m, MAP__VARIABLE, addr, &al,
+				   NULL);
+	ams->addr = addr;
+	ams->al_addr = al.addr;
+	ams->sym = al.sym;
+	ams->map = al.map;
+}
+
+struct mem_info *machine__resolve_mem(struct machine *self,
+				      struct thread *thr,
+				      struct perf_sample *sample,
+				      u8 cpumode)
+{
+	struct mem_info *mi;
+
+	mi = calloc(1, sizeof(struct mem_info));
+	if (!mi)
+		return NULL;
+
+	ip__resolve_ams(self, thr, &mi->iaddr, sample->ip);
+	ip__resolve_data(self, thr, cpumode, &mi->daddr, sample->addr);
+	mi->dsrc.val = sample->dsrc;
+
+	return mi;
+}
+
 struct branch_info *machine__resolve_bstack(struct machine *self,
 					    struct thread *thr,
 					    struct branch_stack *bs)
@@ -1012,6 +1047,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_ADDR)
 		printf(" ..... data: 0x%"PRIx64"\n", sample->addr);
+
+	if (sample_type & PERF_SAMPLE_DSRC)
+		printf(" . data_src: 0x%"PRIx64"\n", sample->dsrc);
 }
 
 static struct machine *
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index cea133a..f3ea026 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -69,6 +69,10 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 				    struct ip_callchain *chain,
 				    struct symbol **parent);
 
+struct mem_info *machine__resolve_mem(struct machine *self,
+				      struct thread *thread,
+				      struct perf_sample *sample, u8 cpumode);
+
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 void mem_bswap_64(void *src, int byte_size);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 633b3e8..0625ea7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -182,11 +182,19 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
-	if (sym)
-		ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
-				       width - ret,
-				       sym->name);
-	else {
+	if (sym) {
+		if (map->type == MAP__VARIABLE) {
+			ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
+			ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
+					ip - sym->start);
+			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+				       width - ret, "");
+		} else {
+			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+					       width - ret,
+					       sym->name);
+		}
+	} else {
 		size_t len = BITS_PER_LONG / 4;
 		ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx",
 				       len, ip);
@@ -469,6 +477,222 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
+/* --sort daddr_sym */
+static int64_t
+sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct addr_map_symbol *l = &left->mem_info->daddr;
+	struct addr_map_symbol *r = &right->mem_info->daddr;
+
+	return (int64_t)(r->addr - l->addr);
+}
+
+static int hist_entry__daddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return _hist_entry__sym_snprintf(self->mem_info->daddr.map,
+					 self->mem_info->daddr.sym,
+					 self->mem_info->daddr.addr,
+					 self->level, bf, size, width);
+}
+
+static int64_t
+sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return _sort__dso_cmp(left->mem_info->daddr.map, right->mem_info->daddr.map);
+}
+
+static int hist_entry__dso_daddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return _hist_entry__dso_snprintf(self->mem_info->daddr.map, bf, size,
+					 width);
+}
+
+static int64_t
+sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_dsrc dsrc_l = left->mem_info->dsrc;
+	union perf_mem_dsrc dsrc_r = right->mem_info->dsrc;
+
+	return (int64_t)(dsrc_r.mem_lock - dsrc_l.mem_lock);
+}
+
+static int hist_entry__locked_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	const char *out = "??";
+	u64 mask = self->mem_info->dsrc.mem_lock;
+
+	if (mask & PERF_MEM_LOCK_NA)
+		out = "N/A";
+	else if (mask & PERF_MEM_LOCK_LOCKED)
+		out = "Yes";
+	else
+		out = "No";
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+static int64_t
+sort__tlb_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_dsrc dsrc_l = left->mem_info->dsrc;
+	union perf_mem_dsrc dsrc_r = right->mem_info->dsrc;
+
+	return (int64_t)(dsrc_r.mem_dtlb - dsrc_l.mem_dtlb);
+}
+
+static const char * const tlb_access[] = {
+	"N/A",
+	"HIT",
+	"MISS",
+	"L1",
+	"L2",
+	"Walker",
+	"Fault",
+};
+#define NUM_TLB_ACCESS (sizeof(tlb_access)/sizeof(const char *))
+
+static int hist_entry__tlb_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	char out[64];
+	size_t sz = sizeof(out) - 1; /* -1 for null termination */
+	size_t l = 0, i;
+	u64 m = self->mem_info->dsrc.mem_dtlb;
+	u64 hit, miss;
+
+	out[0] = '\0';
+
+	hit = m & PERF_MEM_TLB_HIT;
+	miss = m & PERF_MEM_TLB_MISS;
+
+	/* already taken care of */
+	m &= ~(PERF_MEM_TLB_HIT|PERF_MEM_TLB_MISS);
+
+	for (i = 0; m && i < NUM_TLB_ACCESS; i++, m >>= 1) {
+		if (!(m & 0x1))
+			continue;
+		if (l) {
+			strcat(out, " or ");
+			l += 4;
+		}
+		strncat(out, tlb_access[i], sz - l);
+		l += strlen(tlb_access[i]);
+	}
+	if (hit)
+		strncat(out, " hit", sz - l);
+	if (miss)
+		strncat(out, " miss", sz - l);
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+static int64_t
+sort__lvl_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_dsrc dsrc_l = left->mem_info->dsrc;
+	union perf_mem_dsrc dsrc_r = right->mem_info->dsrc;
+
+	return (int64_t)(dsrc_r.mem_lvl - dsrc_l.mem_lvl);
+}
+
+static const char * const mem_lvl[] = {
+	"N/A",
+	"HIT",
+	"MISS",
+	"L1",
+	"LFB",
+	"L2",
+	"L3",
+	"Local RAM",
+	"Remote RAM (1 hop)",
+	"Remote RAM (2 hops)",
+	"Remote Cache (1 hop)",
+	"Remote Cache (2 hops)",
+	"I/O",
+	"Uncached",
+};
+#define NUM_MEM_LVL (sizeof(mem_lvl)/sizeof(const char *))
+
+static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	char out[64];
+	size_t sz = sizeof(out) - 1; /* -1 for null termination */
+	size_t i, l = 0;
+	u64 m = self->mem_info->dsrc.mem_lvl;
+	u64 hit, miss;
+
+	out[0] = '\0';
+
+	hit = m & PERF_MEM_LVL_HIT;
+	miss = m & PERF_MEM_LVL_MISS;
+
+	/* already taken care of */
+	m &= ~(PERF_MEM_LVL_HIT|PERF_MEM_LVL_MISS);
+
+	for (i = 0; m && i < NUM_MEM_LVL; i++, m >>= 1) {
+		if (!(m & 0x1))
+			continue;
+		if (l) {
+			strcat(out, " or ");
+			l += 4;
+		}
+		strncat(out, mem_lvl[i], sz - l);
+		l += strlen(mem_lvl[i]);
+	}
+	if (hit)
+		strncat(out, " hit", sz - l);
+	if (miss)
+		strncat(out, " miss", sz - l);
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+static int64_t
+sort__snoop_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_dsrc dsrc_l = left->mem_info->dsrc;
+	union perf_mem_dsrc dsrc_r = right->mem_info->dsrc;
+
+	return (int64_t)(dsrc_r.mem_snoop - dsrc_l.mem_snoop);
+}
+
+static const char * const snoop_access[] = {
+	"N/A",
+	"None",
+	"Miss",
+	"Hit",
+	"HitM",
+};
+#define NUM_SNOOP_ACCESS (sizeof(snoop_access)/sizeof(const char *))
+
+static int hist_entry__snoop_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	char out[64];
+	size_t sz = sizeof(out) - 1; /* -1 for null termination */
+	size_t i, l = 0;
+	u64 m = self->mem_info->dsrc.mem_snoop;
+
+	out[0] = '\0';
+
+	for (i = 0; m && i < NUM_SNOOP_ACCESS; i++, m >>= 1) {
+		if (!(m & 0x1))
+			continue;
+		if (l) {
+			strcat(out, " or ");
+			l += 4;
+		}
+		strncat(out, snoop_access[i], sz - l);
+		l += strlen(snoop_access[i]);
+	}
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
 struct sort_entry sort_mispredict = {
 	.se_header	= "Branch Mispredicted",
 	.se_cmp		= sort__mispredict_cmp,
@@ -519,6 +743,48 @@ struct sort_entry sort_global_weight = {
 	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
 };
 
+struct sort_entry sort_mem_daddr_sym = {
+	.se_header	= "Data Symbol",
+	.se_cmp		= sort__daddr_cmp,
+	.se_snprintf	= hist_entry__daddr_snprintf,
+	.se_width_idx	= HISTC_MEM_DADDR_SYMBOL,
+};
+
+struct sort_entry sort_mem_daddr_dso = {
+	.se_header	= "Data Object",
+	.se_cmp		= sort__dso_daddr_cmp,
+	.se_snprintf	= hist_entry__dso_daddr_snprintf,
+	.se_width_idx	= HISTC_MEM_DADDR_SYMBOL,
+};
+
+struct sort_entry sort_mem_locked = {
+	.se_header	= "Locked",
+	.se_cmp		= sort__locked_cmp,
+	.se_snprintf	= hist_entry__locked_snprintf,
+	.se_width_idx	= HISTC_MEM_LOCKED,
+};
+
+struct sort_entry sort_mem_tlb = {
+	.se_header	= "TLB access",
+	.se_cmp		= sort__tlb_cmp,
+	.se_snprintf	= hist_entry__tlb_snprintf,
+	.se_width_idx	= HISTC_MEM_TLB,
+};
+
+struct sort_entry sort_mem_lvl = {
+	.se_header	= "Memory access",
+	.se_cmp		= sort__lvl_cmp,
+	.se_snprintf	= hist_entry__lvl_snprintf,
+	.se_width_idx	= HISTC_MEM_LVL,
+};
+
+struct sort_entry sort_mem_snoop = {
+	.se_header	= "Snoop",
+	.se_cmp		= sort__snoop_cmp,
+	.se_snprintf	= hist_entry__snoop_snprintf,
+	.se_width_idx	= HISTC_MEM_SNOOP,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -542,6 +808,12 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
+	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
+	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
+	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
+	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
+	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
 };
 
 int sort_dimension__add(const char *tok)
@@ -565,7 +837,8 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym ||
 			   sd->entry == &sort_sym_from ||
-			   sd->entry == &sort_sym_to) {
+			   sd->entry == &sort_sym_to ||
+			   sd->entry == &sort_mem_daddr_sym) {
 			sort__has_sym = 1;
 		}
 
@@ -602,6 +875,18 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_GLOBAL_WEIGHT;
 			else if (!strcmp(sd->name, "local_weight"))
 				sort__first_dimension = SORT_LOCAL_WEIGHT;
+			else if (!strcmp(sd->name, "symbol_daddr"))
+				sort__first_dimension = SORT_MEM_DADDR_SYMBOL;
+			else if (!strcmp(sd->name, "dso_daddr"))
+				sort__first_dimension = SORT_MEM_DADDR_DSO;
+			else if (!strcmp(sd->name, "locked"))
+				sort__first_dimension = SORT_MEM_LOCKED;
+			else if (!strcmp(sd->name, "tlb"))
+				sort__first_dimension = SORT_MEM_TLB;
+			else if (!strcmp(sd->name, "mem_lvl"))
+				sort__first_dimension = SORT_MEM_LVL;
+			else if (!strcmp(sd->name, "snoop"))
+				sort__first_dimension = SORT_MEM_SNOOP;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 9af5446..0184f1c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -104,7 +104,8 @@ struct hist_entry {
 	struct rb_root		sorted_chain;
 	struct branch_info	*branch_info;
 	struct hists		*hists;
-	struct callchain_root	callchain[0];
+	struct mem_info		*mem_info;
+	struct callchain_root	callchain[0]; /* must be last member */
 };
 
 static inline bool hist_entry__has_pairs(struct hist_entry *he)
@@ -140,6 +141,12 @@ enum sort_type {
 	SORT_SRCLINE,
 	SORT_LOCAL_WEIGHT,
 	SORT_GLOBAL_WEIGHT,
+	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_DSO,
+	SORT_MEM_LOCKED,
+	SORT_MEM_TLB,
+	SORT_MEM_LVL,
+	SORT_MEM_SNOOP,
 };
 
 /*
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index de68f98..d0dab17 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -152,6 +152,12 @@ struct branch_info {
 	struct branch_flags flags;
 };
 
+struct mem_info {
+	struct addr_map_symbol iaddr;
+	struct addr_map_symbol daddr;
+	union perf_mem_dsrc dsrc;
+};
+
 struct addr_location {
 	struct thread *thread;
 	struct map    *map;
-- 
1.7.9.5

