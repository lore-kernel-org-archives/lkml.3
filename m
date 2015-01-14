Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbbANXsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:48:45 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42598 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbANXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:48:43 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v3 2/3] perf probe: Do not rely on map__load() filter to find symbols
Date: Thu, 15 Jan 2015 08:48:21 +0900
Message-Id: <1421279302-7105-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
References: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
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

To fix it, use map__find_symbol_by_name_from() instead.  It'll load a
map with full symbols and sorts them by name.  It needs to search sibing
nodes since there can be multiple (local) symbols with same name.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-event.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 94a717bf007d..3cfad9c74faf 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2193,18 +2193,17 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static char *looking_function_name;
-static int num_matched_functions;
-
-static int probe_function_filter(struct map *map __maybe_unused,
-				      struct symbol *sym)
+static int find_probe_functions(struct map *map, char *name)
 {
-	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
-	    strcmp(looking_function_name, sym->name) == 0) {
-		num_matched_functions++;
-		return 0;
+	struct symbol *sym = NULL;
+	int found = 0;
+
+	while ((sym = map__find_symbol_by_name_from(map, name, NULL, sym))) {
+		if (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL)
+			found++;
 	}
-	return 1;
+
+	return found;
 }
 
 #define strdup_or_goto(str, label)	\
@@ -2221,11 +2220,11 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	struct map *map = NULL;
 	struct kmap *kmap = NULL;
 	struct ref_reloc_sym *reloc_sym = NULL;
-	struct symbol *sym;
-	struct rb_node *nd;
+	struct symbol *sym = NULL;
 	struct probe_trace_event *tev;
 	struct perf_probe_point *pp = &pev->point;
 	struct probe_trace_point *tp;
+	int num_matched_functions;
 	int ret, i;
 
 	/* Init maps of given executable or kernel */
@@ -2242,10 +2241,8 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	 * Load matched symbols: Since the different local symbols may have
 	 * same name but different addresses, this lists all the symbols.
 	 */
-	num_matched_functions = 0;
-	looking_function_name = pp->function;
-	ret = map__load(map, probe_function_filter);
-	if (ret || num_matched_functions == 0) {
+	num_matched_functions = find_probe_functions(map, pp->function);
+	if (num_matched_functions == 0) {
 		pr_err("Failed to find symbol %s in %s\n", pp->function,
 			target ? : "kernel");
 		ret = -ENOENT;
@@ -2275,7 +2272,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	map__for_each_symbol(map, sym, nd) {
+	while ((sym = map__find_symbol_by_name_from(map, pp->function, NULL, sym))) {
 		tev = (*tevs) + ret;
 		tp = &tev->point;
 		if (ret == num_matched_functions) {
-- 
2.2.1

