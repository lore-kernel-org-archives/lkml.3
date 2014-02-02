Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaBBVsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:48:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaBBVjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:46 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/22] perf tools: Add sort_entry struct into sort entries callbacks
Date: Sun,  2 Feb 2014 22:38:53 +0100
Message-Id: <1391377150-23920-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'struct sort_entry' to all its callback
as the first parameter. This will be usefull
for dynamic sort entries to get specific data.

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
 tools/perf/ui/gtk/hists.c |   2 +-
 tools/perf/ui/hist.c      |   2 +-
 tools/perf/util/hist.c    |   7 +-
 tools/perf/util/sort.c    | 225 +++++++++++++++++++++++++++++-----------------
 tools/perf/util/sort.h    |  10 ++-
 5 files changed, 154 insertions(+), 92 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index ded22b4..4a3a207 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -322,7 +322,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			if (se->elide)
 				continue;
 
-			se->se_snprintf(h, s, ARRAY_SIZE(s),
+			se->se_snprintf(se, h, s, ARRAY_SIZE(s),
 					hists__col_len(hists, se->se_width_idx));
 
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 1f9e252..470a1c6 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -310,7 +310,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			continue;
 
 		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(he, s + ret, size - ret,
+		ret += se->se_snprintf(se, he, s + ret, size - ret,
 				       hists__col_len(hists, se->se_width_idx));
 	}
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 43241ea..164d20d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -916,7 +916,7 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->se_cmp(left, right);
+		cmp = se->se_cmp(se, left, right);
 		if (cmp)
 			break;
 	}
@@ -931,11 +931,12 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	int64_t cmp = 0;
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
+		int64_t (*f)(struct sort_entry *, struct hist_entry *,
+			     struct hist_entry *);
 
 		f = se->se_collapse ?: se->se_cmp;
 
-		cmp = f(left, right);
+		cmp = f(se, left, right);
 		if (cmp)
 			break;
 	}
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 4ddf934..823a958 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -58,12 +58,14 @@ static int64_t cmp_null(const void *l, const void *r)
 /* --sort idx */
 
 static int64_t
-sort__idx_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__idx_cmp(struct sort_entry *se __maybe_unused,
+	      struct hist_entry *left, struct hist_entry *right)
 {
 	return right->idx - left->idx;
 }
 
-static int hist_entry__idx_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__idx_snprintf(struct sort_entry *se __maybe_unused,
+				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*lu", width, he->idx);
@@ -80,7 +82,9 @@ struct sort_entry sort_idx = {
 /* --sort time */
 
 static int64_t
-sort__time_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__time_cmp(struct sort_entry *se __maybe_unused,
+	       struct hist_entry *left,
+	       struct hist_entry *right)
 {
 	return right->time - left->time;
 }
@@ -95,8 +99,9 @@ static u64 get_time_base(struct hist_entry *he)
 	return hists->time_base;
 }
 
-static int hist_entry__time_snprintf(struct hist_entry *he, char *bf,
-				       size_t size, unsigned int width)
+static int hist_entry__time_snprintf(struct sort_entry *se __maybe_unused,
+				     struct hist_entry *he, char *bf,
+				     size_t size, unsigned int width)
 {
 	char buf[100];
 	u64 time_base = get_time_base(he);
@@ -130,12 +135,14 @@ struct sort_entry sort_time = {
 /* --sort pid */
 
 static int64_t
-sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__thread_cmp(struct sort_entry *se __maybe_unused,
+		 struct hist_entry *left, struct hist_entry *right)
 {
 	return right->thread->tid - left->thread->tid;
 }
 
-static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__thread_snprintf(struct sort_entry *se __maybe_unused,
+				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	const char *comm = thread__comm_str(he->thread);
@@ -153,20 +160,23 @@ struct sort_entry sort_thread = {
 /* --sort comm */
 
 static int64_t
-sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__comm_cmp(struct sort_entry *se __maybe_unused,
+	       struct hist_entry *left, struct hist_entry *right)
 {
 	/* Compare the addr that should be unique among comm */
 	return comm__str(right->comm) - comm__str(left->comm);
 }
 
 static int64_t
-sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
+sort__comm_collapse(struct sort_entry *se __maybe_unused,
+		    struct hist_entry *left, struct hist_entry *right)
 {
 	/* Compare the addr that should be unique among comm */
 	return comm__str(right->comm) - comm__str(left->comm);
 }
 
-static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__comm_snprintf(struct sort_entry *se __maybe_unused,
+				     struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*s", width, comm__str(he->comm));
@@ -182,7 +192,8 @@ struct sort_entry sort_comm = {
 
 /* --sort dso */
 
-static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
+static int64_t _sort__dso_cmp(struct sort_entry *se __maybe_unused,
+			      struct map *map_l, struct map *map_r)
 {
 	struct dso *dso_l = map_l ? map_l->dso : NULL;
 	struct dso *dso_r = map_r ? map_r->dso : NULL;
@@ -203,12 +214,14 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 }
 
 static int64_t
-sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__dso_cmp(struct sort_entry *se,
+	      struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->ms.map, right->ms.map);
+	return _sort__dso_cmp(se, left->ms.map, right->ms.map);
 }
 
-static int _hist_entry__dso_snprintf(struct map *map, char *bf,
+static int _hist_entry__dso_snprintf(struct sort_entry *se __maybe_unused,
+				     struct map *map, char *bf,
 				     size_t size, unsigned int width)
 {
 	if (map && map->dso) {
@@ -220,10 +233,11 @@ static int _hist_entry__dso_snprintf(struct map *map, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
 }
 
-static int hist_entry__dso_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__dso_snprintf(struct sort_entry *se,
+				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->ms.map, bf, size, width);
+	return _hist_entry__dso_snprintf(se, he->ms.map, bf, size, width);
 }
 
 struct sort_entry sort_dso = {
@@ -240,7 +254,8 @@ static int64_t _sort__addr_cmp(u64 left_ip, u64 right_ip)
 	return (int64_t)(right_ip - left_ip);
 }
 
-static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
+static int64_t _sort__sym_cmp(struct sort_entry *se __maybe_unused,
+			      struct symbol *sym_l, struct symbol *sym_r)
 {
 	u64 ip_l, ip_r;
 
@@ -257,7 +272,8 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
 }
 
 static int64_t
-sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__sym_cmp(struct sort_entry *se,
+	      struct hist_entry *left, struct hist_entry *right)
 {
 	int64_t ret;
 
@@ -269,15 +285,16 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * relative address within a dso.
 	 */
 	if (!sort__has_dso) {
-		ret = sort__dso_cmp(left, right);
+		ret = sort__dso_cmp(se, left, right);
 		if (ret != 0)
 			return ret;
 	}
 
-	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
+	return _sort__sym_cmp(se, left->ms.sym, right->ms.sym);
 }
 
-static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
+static int _hist_entry__sym_snprintf(struct sort_entry *se __maybe_unused,
+				     struct map *map, struct symbol *sym,
 				     u64 ip, char level, char *bf, size_t size,
 				     unsigned int width)
 {
@@ -313,10 +330,11 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	return ret;
 }
 
-static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__sym_snprintf(struct sort_entry *se __maybe_unused,
+				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__sym_snprintf(he->ms.map, he->ms.sym, he->ip,
+	return _hist_entry__sym_snprintf(se, he->ms.map, he->ms.sym, he->ip,
 					 he->level, bf, size, width);
 }
 
@@ -330,7 +348,8 @@ struct sort_entry sort_sym = {
 /* --sort srcline */
 
 static int64_t
-sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__srcline_cmp(struct sort_entry *se __maybe_unused,
+		  struct hist_entry *left, struct hist_entry *right)
 {
 	if (!left->srcline) {
 		if (!left->ms.map)
@@ -353,7 +372,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 	return strcmp(left->srcline, right->srcline);
 }
 
-static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__srcline_snprintf(struct sort_entry *se __maybe_unused,
+					struct hist_entry *he, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
@@ -370,7 +390,8 @@ struct sort_entry sort_srcline = {
 /* --sort parent */
 
 static int64_t
-sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__parent_cmp(struct sort_entry *se __maybe_unused,
+		 struct hist_entry *left, struct hist_entry *right)
 {
 	struct symbol *sym_l = left->parent;
 	struct symbol *sym_r = right->parent;
@@ -381,7 +402,8 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 	return strcmp(sym_l->name, sym_r->name);
 }
 
-static int hist_entry__parent_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__parent_snprintf(struct sort_entry *se __maybe_unused,
+				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%-*s", width,
@@ -398,12 +420,14 @@ struct sort_entry sort_parent = {
 /* --sort cpu */
 
 static int64_t
-sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__cpu_cmp(struct sort_entry *se __maybe_unused,
+	      struct hist_entry *left, struct hist_entry *right)
 {
 	return right->cpu - left->cpu;
 }
 
-static int hist_entry__cpu_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__cpu_snprintf(struct sort_entry *se __maybe_unused,
+				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*d", width, he->cpu);
@@ -419,35 +443,40 @@ struct sort_entry sort_cpu = {
 /* sort keys for branch stacks */
 
 static int64_t
-sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__dso_from_cmp(struct sort_entry *se,
+		   struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->branch_info->from.map,
+	return _sort__dso_cmp(se, left->branch_info->from.map,
 			      right->branch_info->from.map);
 }
 
-static int hist_entry__dso_from_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__dso_from_snprintf(struct sort_entry *se,
+					 struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->branch_info->from.map,
+	return _hist_entry__dso_snprintf(se, he->branch_info->from.map,
 					 bf, size, width);
 }
 
 static int64_t
-sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__dso_to_cmp(struct sort_entry *se,
+		 struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->branch_info->to.map,
+	return _sort__dso_cmp(se, left->branch_info->to.map,
 			      right->branch_info->to.map);
 }
 
-static int hist_entry__dso_to_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__dso_to_snprintf(struct sort_entry *se __maybe_unused,
+				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->branch_info->to.map,
+	return _hist_entry__dso_snprintf(se, he->branch_info->to.map,
 					 bf, size, width);
 }
 
 static int64_t
-sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__sym_from_cmp(struct sort_entry *se,
+		   struct hist_entry *left, struct hist_entry *right)
 {
 	struct addr_map_symbol *from_l = &left->branch_info->from;
 	struct addr_map_symbol *from_r = &right->branch_info->from;
@@ -455,11 +484,12 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!from_l->sym && !from_r->sym)
 		return _sort__addr_cmp(from_l->addr, from_r->addr);
 
-	return _sort__sym_cmp(from_l->sym, from_r->sym);
+	return _sort__sym_cmp(se, from_l->sym, from_r->sym);
 }
 
 static int64_t
-sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__sym_to_cmp(struct sort_entry *se,
+		 struct hist_entry *left, struct hist_entry *right)
 {
 	struct addr_map_symbol *to_l = &left->branch_info->to;
 	struct addr_map_symbol *to_r = &right->branch_info->to;
@@ -467,23 +497,25 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!to_l->sym && !to_r->sym)
 		return _sort__addr_cmp(to_l->addr, to_r->addr);
 
-	return _sort__sym_cmp(to_l->sym, to_r->sym);
+	return _sort__sym_cmp(se, to_l->sym, to_r->sym);
 }
 
-static int hist_entry__sym_from_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__sym_from_snprintf(struct sort_entry *se,
+					 struct hist_entry *he, char *bf,
 					 size_t size, unsigned int width)
 {
 	struct addr_map_symbol *from = &he->branch_info->from;
-	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
+	return _hist_entry__sym_snprintf(se, from->map, from->sym, from->addr,
 					 he->level, bf, size, width);
 
 }
 
-static int hist_entry__sym_to_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__sym_to_snprintf(struct sort_entry *se __maybe_unused,
+				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
 	struct addr_map_symbol *to = &he->branch_info->to;
-	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
+	return _hist_entry__sym_snprintf(se, to->map, to->sym, to->addr,
 					 he->level, bf, size, width);
 
 }
@@ -517,7 +549,8 @@ struct sort_entry sort_sym_to = {
 };
 
 static int64_t
-sort__mispredict_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__mispredict_cmp(struct sort_entry *se __maybe_unused,
+		     struct hist_entry *left, struct hist_entry *right)
 {
 	const unsigned char mp = left->branch_info->flags.mispred !=
 					right->branch_info->flags.mispred;
@@ -527,8 +560,9 @@ sort__mispredict_cmp(struct hist_entry *left, struct hist_entry *right)
 	return mp || p;
 }
 
-static int hist_entry__mispredict_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width){
+static int hist_entry__mispredict_snprintf(struct sort_entry *se __maybe_unused,
+					   struct hist_entry *he, char *bf,
+					   size_t size, unsigned int width){
 	static const char *out = "N/A";
 
 	if (he->branch_info->flags.predicted)
@@ -541,7 +575,8 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *he, char *bf,
 
 /* --sort daddr_sym */
 static int64_t
-sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__daddr_cmp(struct sort_entry *se __maybe_unused,
+		struct hist_entry *left, struct hist_entry *right)
 {
 	uint64_t l = 0, r = 0;
 
@@ -553,8 +588,9 @@ sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
 	return (int64_t)(r - l);
 }
 
-static int hist_entry__daddr_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int hist_entry__daddr_snprintf(struct sort_entry *se,
+				      struct hist_entry *he, char *bf,
+				      size_t size, unsigned int width)
 {
 	uint64_t addr = 0;
 	struct map *map = NULL;
@@ -565,12 +601,13 @@ static int hist_entry__daddr_snprintf(struct hist_entry *he, char *bf,
 		map = he->mem_info->daddr.map;
 		sym = he->mem_info->daddr.sym;
 	}
-	return _hist_entry__sym_snprintf(map, sym, addr, he->level, bf, size,
-					 width);
+	return _hist_entry__sym_snprintf(se, map, sym, addr, he->level, bf,
+					 size, width);
 }
 
 static int64_t
-sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__dso_daddr_cmp(struct sort_entry *se __maybe_unused,
+		    struct hist_entry *left, struct hist_entry *right)
 {
 	struct map *map_l = NULL;
 	struct map *map_r = NULL;
@@ -580,22 +617,24 @@ sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (right->mem_info)
 		map_r = right->mem_info->daddr.map;
 
-	return _sort__dso_cmp(map_l, map_r);
+	return _sort__dso_cmp(se, map_l, map_r);
 }
 
-static int hist_entry__dso_daddr_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int hist_entry__dso_daddr_snprintf(struct sort_entry *se,
+					  struct hist_entry *he, char *bf,
+					  size_t size, unsigned int width)
 {
 	struct map *map = NULL;
 
 	if (he->mem_info)
 		map = he->mem_info->daddr.map;
 
-	return _hist_entry__dso_snprintf(map, bf, size, width);
+	return _hist_entry__dso_snprintf(se, map, bf, size, width);
 }
 
 static int64_t
-sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__locked_cmp(struct sort_entry *se __maybe_unused,
+		 struct hist_entry *left, struct hist_entry *right)
 {
 	union perf_mem_data_src data_src_l;
 	union perf_mem_data_src data_src_r;
@@ -613,8 +652,9 @@ sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
 	return (int64_t)(data_src_r.mem_lock - data_src_l.mem_lock);
 }
 
-static int hist_entry__locked_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int hist_entry__locked_snprintf(struct sort_entry *se __maybe_unused,
+				       struct hist_entry *he, char *bf,
+				       size_t size, unsigned int width)
 {
 	const char *out;
 	u64 mask = PERF_MEM_LOCK_NA;
@@ -633,7 +673,8 @@ static int hist_entry__locked_snprintf(struct hist_entry *he, char *bf,
 }
 
 static int64_t
-sort__tlb_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__tlb_cmp(struct sort_entry *se __maybe_unused,
+	      struct hist_entry *left, struct hist_entry *right)
 {
 	union perf_mem_data_src data_src_l;
 	union perf_mem_data_src data_src_r;
@@ -662,7 +703,8 @@ static const char * const tlb_access[] = {
 };
 #define NUM_TLB_ACCESS (sizeof(tlb_access)/sizeof(const char *))
 
-static int hist_entry__tlb_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__tlb_snprintf(struct sort_entry *se __maybe_unused,
+				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
 	char out[64];
@@ -703,7 +745,8 @@ static int hist_entry__tlb_snprintf(struct hist_entry *he, char *bf,
 }
 
 static int64_t
-sort__lvl_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__lvl_cmp(struct sort_entry *se __maybe_unused,
+	      struct hist_entry *left, struct hist_entry *right)
 {
 	union perf_mem_data_src data_src_l;
 	union perf_mem_data_src data_src_r;
@@ -739,7 +782,8 @@ static const char * const mem_lvl[] = {
 };
 #define NUM_MEM_LVL (sizeof(mem_lvl)/sizeof(const char *))
 
-static int hist_entry__lvl_snprintf(struct hist_entry *he, char *bf,
+static int hist_entry__lvl_snprintf(struct sort_entry *se __maybe_unused,
+				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
 	char out[64];
@@ -780,7 +824,8 @@ static int hist_entry__lvl_snprintf(struct hist_entry *he, char *bf,
 }
 
 static int64_t
-sort__snoop_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__snoop_cmp(struct sort_entry *se __maybe_unused,
+		struct hist_entry *left, struct hist_entry *right)
 {
 	union perf_mem_data_src data_src_l;
 	union perf_mem_data_src data_src_r;
@@ -807,8 +852,9 @@ static const char * const snoop_access[] = {
 };
 #define NUM_SNOOP_ACCESS (sizeof(snoop_access)/sizeof(const char *))
 
-static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int hist_entry__snoop_snprintf(struct sort_entry *se __maybe_unused,
+				      struct hist_entry *he, char *bf,
+				      size_t size, unsigned int width)
 {
 	char out[64];
 	size_t sz = sizeof(out) - 1; /* -1 for null termination */
@@ -850,13 +896,16 @@ static u64 he_weight(struct hist_entry *he)
 }
 
 static int64_t
-sort__local_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__local_weight_cmp(struct sort_entry *se __maybe_unused,
+		       struct hist_entry *left, struct hist_entry *right)
 {
 	return he_weight(left) - he_weight(right);
 }
 
-static int hist_entry__local_weight_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int
+hist_entry__local_weight_snprintf(struct sort_entry *se __maybe_unused,
+				  struct hist_entry *he, char *bf,
+				  size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%-*llu", width, he_weight(he));
 }
@@ -869,13 +918,16 @@ struct sort_entry sort_local_weight = {
 };
 
 static int64_t
-sort__global_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__global_weight_cmp(struct sort_entry *se __maybe_unused,
+			struct hist_entry *left, struct hist_entry *right)
 {
 	return left->stat.weight - right->stat.weight;
 }
 
-static int hist_entry__global_weight_snprintf(struct hist_entry *he, char *bf,
-					      size_t size, unsigned int width)
+static int
+hist_entry__global_weight_snprintf(struct sort_entry *se __maybe_unused,
+				   struct hist_entry *he, char *bf,
+				   size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%-*llu", width, he->stat.weight);
 }
@@ -930,14 +982,16 @@ struct sort_entry sort_mem_snoop = {
 };
 
 static int64_t
-sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__abort_cmp(struct sort_entry *se __maybe_unused,
+		struct hist_entry *left, struct hist_entry *right)
 {
 	return left->branch_info->flags.abort !=
 		right->branch_info->flags.abort;
 }
 
-static int hist_entry__abort_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int hist_entry__abort_snprintf(struct sort_entry *se __maybe_unused,
+				      struct hist_entry *he, char *bf,
+				      size_t size, unsigned int width)
 {
 	static const char *out = ".";
 
@@ -954,14 +1008,16 @@ struct sort_entry sort_abort = {
 };
 
 static int64_t
-sort__in_tx_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__in_tx_cmp(struct sort_entry *se __maybe_unused,
+		struct hist_entry *left, struct hist_entry *right)
 {
 	return left->branch_info->flags.in_tx !=
 		right->branch_info->flags.in_tx;
 }
 
-static int hist_entry__in_tx_snprintf(struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+static int hist_entry__in_tx_snprintf(struct sort_entry *se __maybe_unused,
+				      struct hist_entry *he, char *bf,
+				      size_t size, unsigned int width)
 {
 	static const char *out = ".";
 
@@ -979,7 +1035,8 @@ struct sort_entry sort_in_tx = {
 };
 
 static int64_t
-sort__transaction_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__transaction_cmp(struct sort_entry *se __maybe_unused,
+		      struct hist_entry *left, struct hist_entry *right)
 {
 	return left->transaction - right->transaction;
 }
@@ -1019,8 +1076,10 @@ int hist_entry__transaction_len(void)
 	return len;
 }
 
-static int hist_entry__transaction_snprintf(struct hist_entry *he, char *bf,
-					    size_t size, unsigned int width)
+static int
+hist_entry__transaction_snprintf(struct sort_entry *se __maybe_unused,
+				 struct hist_entry *he, char *bf,
+				 size_t size, unsigned int width)
 {
 	u64 t = he->transaction;
 	char buf[128];
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index c2fa361..1dffebc 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -197,10 +197,12 @@ struct sort_entry {
 
 	const char *se_header;
 
-	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
-	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
-	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
-			       unsigned int width);
+	int64_t (*se_cmp)(struct sort_entry *, struct hist_entry *,
+			  struct hist_entry *);
+	int64_t (*se_collapse)(struct sort_entry *, struct hist_entry *,
+			       struct hist_entry *);
+	int	(*se_snprintf)(struct sort_entry *, struct hist_entry *he,
+			       char *bf, size_t size, unsigned int width);
 	u8	se_width_idx;
 	bool	elide;
 };
-- 
1.8.3.1

