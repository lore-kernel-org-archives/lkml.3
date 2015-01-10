Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbbAJKeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:34:12 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61762 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbAJKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:34:03 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 2/4] perf probe: Do not rely on map__load() filter to find symbols
Date: Sat, 10 Jan 2015 19:33:46 +0900
Message-Id: <1420886028-15135-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The find_probe_trace_events_from_map() searches matching symbol from a
map (so from a backing dso).  For uprobes, it'll create a new map (and
dso) and loads it using a filter.  It's a little bit inefficient in that
it'll read out the symbol table everytime but works well anyway.

For kprobes however, it'll reuse existing kernel map which might be
loaded before.  In this case map__load() just returns with no result.
It makes kprobes always failed to find symbol even if it exists in the
map (dso).

To fix it, use map__find_symbol_by_name() instead.  It'll load a map
with full symbols and sorts them by name.  It needs to search sibing
nodes since there can be multiple (local) symbols with same name.  Now
resulting symbol references are saved in the funcs list.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-event.c | 101 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7f9b8632e433..e5af16988791 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2191,20 +2191,86 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static char *looking_function_name;
-static int num_matched_functions;
+struct symbol_entry {
+	struct list_head node;
+	struct symbol *sym;
+};
 
-static int probe_function_filter(struct map *map __maybe_unused,
-				      struct symbol *sym)
+/* returns 1 if symbol was added, 0 if symbol was skipped, -1 if error */
+static int add_symbol_entry(struct symbol *sym, struct list_head *head)
 {
-	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
-	    strcmp(looking_function_name, sym->name) == 0) {
-		num_matched_functions++;
+	struct symbol_entry *ent;
+
+	if (sym->binding != STB_GLOBAL && sym->binding != STB_LOCAL)
 		return 0;
-	}
+
+	ent = malloc(sizeof(*ent));
+	if (ent == NULL)
+		return -1;
+
+	ent->sym = sym;
+	list_add(&ent->node, head);
 	return 1;
 }
 
+static int find_probe_functions(struct map *map, char *name, struct list_head *head)
+{
+	struct symbol *sym, *orig_sym;
+	struct symbol_entry *ent;
+	struct rb_node *node;
+	int found = 0;
+	int ret;
+
+	sym = map__find_symbol_by_name(map, name, NULL);
+	if (sym == NULL)
+		return 0;
+
+	ret = add_symbol_entry(sym, head);
+	if (ret < 0)
+		goto err;
+
+	found += ret;
+
+	/* search back and forth to find symbols that have same name */
+	orig_sym = sym;
+
+	while ((node = rb_prev(&sym->rb_node)) != NULL) {
+		sym = rb_entry(node, struct symbol, rb_node);
+		if (strcmp(name, sym->name))
+			break;
+
+		ret = add_symbol_entry(sym, head);
+		if (ret < 0)
+			goto err;
+
+		found += ret;
+	}
+
+	sym = orig_sym;
+
+	while ((node = rb_next(&sym->rb_node)) != NULL) {
+		sym = rb_entry(node, struct symbol, rb_node);
+		if (strcmp(name, sym->name))
+			break;
+
+		ret = add_symbol_entry(sym, head);
+		if (ret < 0)
+			goto err;
+
+		found += ret;
+	}
+
+	return found;
+
+err:
+	while (!list_empty(head)) {
+		ent = list_first_entry(head, struct symbol_entry, node);
+		list_del(&ent->node);
+		free(ent);
+	}
+	return 0;
+}
+
 #define strdup_or_goto(str, label)	\
 	({ char *__p = strdup(str); if (!__p) goto label; __p; })
 
@@ -2220,10 +2286,12 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	struct kmap *kmap = NULL;
 	struct ref_reloc_sym *reloc_sym = NULL;
 	struct symbol *sym;
-	struct rb_node *nd;
 	struct probe_trace_event *tev;
 	struct perf_probe_point *pp = &pev->point;
 	struct probe_trace_point *tp;
+	LIST_HEAD(funcs);
+	struct symbol_entry *ent;
+	int num_matched_functions;
 	int ret, i;
 
 	/* Init maps of given executable or kernel */
@@ -2240,10 +2308,8 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	 * Load matched symbols: Since the different local symbols may have
 	 * same name but different addresses, this lists all the symbols.
 	 */
-	num_matched_functions = 0;
-	looking_function_name = pp->function;
-	ret = map__load(map, probe_function_filter);
-	if (ret || num_matched_functions == 0) {
+	num_matched_functions = find_probe_functions(map, pp->function, &funcs);
+	if (num_matched_functions == 0) {
 		pr_err("Failed to find symbol %s in %s\n", pp->function,
 			target ? : "kernel");
 		ret = -ENOENT;
@@ -2273,7 +2339,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	map__for_each_symbol(map, sym, nd) {
+	list_for_each_entry(ent, &funcs, node) {
 		tev = (*tevs) + ret;
 		tp = &tev->point;
 		if (ret == num_matched_functions) {
@@ -2282,6 +2348,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 		}
 		ret++;
 
+		sym = ent->sym;
 		if (pp->offset > sym->end - sym->start) {
 			pr_warning("Offset %ld is bigger than the size of %s\n",
 				   pp->offset, sym->name);
@@ -2324,6 +2391,12 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	}
 
 out:
+	while (!list_empty(&funcs)) {
+		ent = list_first_entry(&funcs, struct symbol_entry, node);
+		list_del(&ent->node);
+		free(ent);
+	}
+
 	if (map && pev->uprobes) {
 		/* Only when using uprobe(exec) map needs to be released */
 		dso__delete(map->dso);
-- 
2.2.1

