Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3C1RGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:06:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab3C1RCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/36] perf tools: Add mem access sampling core support
Date: Thu, 28 Mar 2013 14:02:25 -0300
Message-Id: <1364490156-32064-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

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
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359040242-8269-12-git-send-email-eranian@google.com
[ committer note: changed to cope with fc5871ed, the move of methods to
  machine.[ch], and the rename of dsrc to data_src, to match the change
  made in the PERF_SAMPLE_DSRC in a previous patch. ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h   |    8 +
 tools/perf/util/evsel.c   |    6 +
 tools/perf/util/hist.c    |   86 ++++++++++-
 tools/perf/util/hist.h    |   13 ++
 tools/perf/util/machine.c |   32 ++++
 tools/perf/util/machine.h |    3 +
 tools/perf/util/session.c |    3 +
 tools/perf/util/sort.c    |  369 ++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/sort.h    |    9 +-
 tools/perf/util/symbol.h  |    6 +
 10 files changed, 525 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a97fbbe..1813895 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -91,6 +91,7 @@ struct perf_sample {
 	u64 weight;
 	u32 cpu;
 	u32 raw_size;
+	u64 data_src;
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
@@ -98,6 +99,13 @@ struct perf_sample {
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
index 23061a6..5c4ca51 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1177,6 +1177,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->data_src = PERF_MEM_DATA_SRC_NONE;
+	if (type & PERF_SAMPLE_DATA_SRC) {
+		data->data_src = *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 97ddd18..99cc719 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -67,12 +67,16 @@ static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
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
@@ -87,7 +91,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		hists__new_col_len(hists, HISTC_PARENT, h->parent->namelen);
 
 	if (h->branch_info) {
-		int symlen;
 		/*
 		 * +4 accounts for '[x] ' priv level info
 		 * +2 account of 0x prefix on raw addresses
@@ -116,6 +119,42 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			hists__set_unres_dso_col_len(hists, HISTC_DSO_TO);
 		}
 	}
+
+	if (h->mem_info) {
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
+	} else {
+		symlen = unresolved_col_width + 4 + 2;
+		hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL, symlen);
+		hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
+	}
+
+	hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
+	hists__new_col_len(hists, HISTC_MEM_TLB, 22);
+	hists__new_col_len(hists, HISTC_MEM_SNOOP, 12);
+	hists__new_col_len(hists, HISTC_MEM_LVL, 21 + 3);
+	hists__new_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
+	hists__new_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -158,6 +197,7 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 static void he_stat__add_period(struct he_stat *he_stat, u64 period,
 				u64 weight)
 {
+
 	he_stat->period		+= period;
 	he_stat->weight		+= weight;
 	he_stat->nr_events	+= 1;
@@ -243,7 +283,7 @@ void hists__decay_entries_threaded(struct hists *hists,
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
 {
 	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
-	struct hist_entry *he = malloc(sizeof(*he) + callchain_size);
+	struct hist_entry *he = zalloc(sizeof(*he) + callchain_size);
 
 	if (he != NULL) {
 		*he = *template;
@@ -258,6 +298,13 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 				he->branch_info->to.map->referenced = true;
 		}
 
+		if (he->mem_info) {
+			if (he->mem_info->iaddr.map)
+				he->mem_info->iaddr.map->referenced = true;
+			if (he->mem_info->daddr.map)
+				he->mem_info->daddr.map->referenced = true;
+		}
+
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
 
@@ -346,6 +393,36 @@ out_unlock:
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
@@ -371,6 +448,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.filtered = symbol__parent_filter(sym_parent),
 		.branch_info = bi,
 		.hists	= self,
+		.mem_info = NULL,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
@@ -398,6 +476,8 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
+		.branch_info = NULL,
+		.mem_info = NULL,
 	};
 
 	return add_hist_entry(self, &entry, al, period, weight);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 121cc14..fd63134 100644
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
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c5e3b12..d77ba86 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1097,6 +1097,38 @@ found:
 	ams->map = al.map;
 }
 
+static void ip__resolve_data(struct machine *machine, struct thread *thread,
+			     u8 m, struct addr_map_symbol *ams, u64 addr)
+{
+	struct addr_location al;
+
+	memset(&al, 0, sizeof(al));
+
+	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr, &al,
+				   NULL);
+	ams->addr = addr;
+	ams->al_addr = al.addr;
+	ams->sym = al.sym;
+	ams->map = al.map;
+}
+
+struct mem_info *machine__resolve_mem(struct machine *machine,
+				      struct thread *thr,
+				      struct perf_sample *sample,
+				      u8 cpumode)
+{
+	struct mem_info *mi = zalloc(sizeof(*mi));
+
+	if (!mi)
+		return NULL;
+
+	ip__resolve_ams(machine, thr, &mi->iaddr, sample->ip);
+	ip__resolve_data(machine, thr, cpumode, &mi->daddr, sample->addr);
+	mi->data_src.val = sample->data_src;
+
+	return mi;
+}
+
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thr,
 					    struct branch_stack *bs)
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index e0b2c00..7794068 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -76,6 +76,9 @@ void machine__delete(struct machine *machine);
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thread,
 					    struct branch_stack *bs);
+struct mem_info *machine__resolve_mem(struct machine *machine,
+				      struct thread *thread,
+				      struct perf_sample *sample, u8 cpumode);
 int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 627be09..cf1fe01 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -801,6 +801,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		printf("... weight: %" PRIu64 "\n", sample->weight);
+
+	if (sample_type & PERF_SAMPLE_DATA_SRC)
+		printf(" . data_src: 0x%"PRIx64"\n", sample->data_src);
 }
 
 static struct machine *
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d66bcd3..32a1ef1 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -198,11 +198,19 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
-	if (sym)
-		ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
-				       width - ret,
-				       sym->name);
-	else {
+	if (sym && map) {
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
@@ -457,6 +465,304 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
+/* --sort daddr_sym */
+static int64_t
+sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	uint64_t l = 0, r = 0;
+
+	if (left->mem_info)
+		l = left->mem_info->daddr.addr;
+	if (right->mem_info)
+		r = right->mem_info->daddr.addr;
+
+	return (int64_t)(r - l);
+}
+
+static int hist_entry__daddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
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
+}
+
+static int64_t
+sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct map *map_l = NULL;
+	struct map *map_r = NULL;
+
+	if (left->mem_info)
+		map_l = left->mem_info->daddr.map;
+	if (right->mem_info)
+		map_r = right->mem_info->daddr.map;
+
+	return _sort__dso_cmp(map_l, map_r);
+}
+
+static int hist_entry__dso_daddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	struct map *map = NULL;
+
+	if (self->mem_info)
+		map = self->mem_info->daddr.map;
+
+	return _hist_entry__dso_snprintf(map, bf, size, width);
+}
+
+static int64_t
+sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_lock = PERF_MEM_LOCK_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_lock = PERF_MEM_LOCK_NA;
+
+	return (int64_t)(data_src_r.mem_lock - data_src_l.mem_lock);
+}
+
+static int hist_entry__locked_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	const char *out;
+	u64 mask = PERF_MEM_LOCK_NA;
+
+	if (self->mem_info)
+		mask = self->mem_info->data_src.mem_lock;
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
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_dtlb = PERF_MEM_TLB_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_dtlb = PERF_MEM_TLB_NA;
+
+	return (int64_t)(data_src_r.mem_dtlb - data_src_l.mem_dtlb);
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
+	u64 m = PERF_MEM_TLB_NA;
+	u64 hit, miss;
+
+	out[0] = '\0';
+
+	if (self->mem_info)
+		m = self->mem_info->data_src.mem_dtlb;
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
+	if (*out == '\0')
+		strcpy(out, "N/A");
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
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_lvl = PERF_MEM_LVL_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_lvl = PERF_MEM_LVL_NA;
+
+	return (int64_t)(data_src_r.mem_lvl - data_src_l.mem_lvl);
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
+	u64 m =  PERF_MEM_LVL_NA;
+	u64 hit, miss;
+
+	if (self->mem_info)
+		m  = self->mem_info->data_src.mem_lvl;
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
+	if (*out == '\0')
+		strcpy(out, "N/A");
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
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_snoop = PERF_MEM_SNOOP_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_snoop = PERF_MEM_SNOOP_NA;
+
+	return (int64_t)(data_src_r.mem_snoop - data_src_l.mem_snoop);
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
+	u64 m = PERF_MEM_SNOOP_NA;
+
+	out[0] = '\0';
+
+	if (self->mem_info)
+		m = self->mem_info->data_src.mem_snoop;
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
+	if (*out == '\0')
+		strcpy(out, "N/A");
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
 struct sort_entry sort_mispredict = {
 	.se_header	= "Branch Mispredicted",
 	.se_cmp		= sort__mispredict_cmp,
@@ -507,6 +813,48 @@ struct sort_entry sort_global_weight = {
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
@@ -525,6 +873,12 @@ static struct sort_dimension common_sort_dimensions[] = {
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
 
 #undef DIM
@@ -561,7 +915,10 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
-		} else if (sd->entry == &sort_sym) {
+		} else if (sd->entry == &sort_sym ||
+			   sd->entry == &sort_sym_from ||
+			   sd->entry == &sort_sym_to ||
+			   sd->entry == &sort_mem_daddr_sym) {
 			sort__has_sym = 1;
 		}
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 3939250..f24bdf6 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -101,7 +101,8 @@ struct hist_entry {
 	struct rb_root		sorted_chain;
 	struct branch_info	*branch_info;
 	struct hists		*hists;
-	struct callchain_root	callchain[0];
+	struct mem_info		*mem_info;
+	struct callchain_root	callchain[0]; /* must be last member */
 };
 
 static inline bool hist_entry__has_pairs(struct hist_entry *he)
@@ -133,6 +134,12 @@ enum sort_type {
 	SORT_SRCLINE,
 	SORT_LOCAL_WEIGHT,
 	SORT_GLOBAL_WEIGHT,
+	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_DSO,
+	SORT_MEM_LOCKED,
+	SORT_MEM_TLB,
+	SORT_MEM_LVL,
+	SORT_MEM_SNOOP,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d7654c2..5f720dc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -156,6 +156,12 @@ struct branch_info {
 	struct branch_flags flags;
 };
 
+struct mem_info {
+	struct addr_map_symbol iaddr;
+	struct addr_map_symbol daddr;
+	union perf_mem_data_src data_src;
+};
+
 struct addr_location {
 	struct thread *thread;
 	struct map    *map;
-- 
1.7.1

