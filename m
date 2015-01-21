Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbbAUPCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:02:50 -0500
Received: from mail.kernel.org ([198.145.29.136]:43488 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbbAUPBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:49 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 8/9] perf symbols: Introduce 'for' method to iterate over the symbols with a given name
Date: Wed, 21 Jan 2015 12:01:09 -0300
Message-Id: <1421852470-20153-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing boilerplate from two places, where one would have to find the
first entry, then iterate using symbol__next_by_name + strcmp to see if
the next member had the same name.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/n/tip-eh73z8gthv20yowirmx2yk38@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.h         | 16 ++++++++++++++++
 tools/perf/util/probe-event.c | 14 +++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 6951a9d42339..0e42438b1e59 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -116,6 +116,22 @@ struct thread;
 #define map__for_each_symbol(map, pos, n)	\
 	dso__for_each_symbol(map->dso, pos, n, map->type)
 
+/* map__for_each_symbol_with_name - iterate over the symbols in the given map
+ *                                  that have the given name
+ *
+ * @map: the 'struct map *' in which symbols itereated
+ * @sym_name: the symbol name
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @filter: to use when loading the DSO
+ */
+#define __map__for_each_symbol_by_name(map, sym_name, pos, filter)	\
+	for (pos = map__find_symbol_by_name(map, sym_name, filter);	\
+	     pos && strcmp(pos->name, sym_name) == 0;		\
+	     pos = symbol__next_by_name(pos))
+
+#define map__for_each_symbol_by_name(map, sym_name, pos)		\
+	__map__for_each_symbol_by_name(map, sym_name, (pos), NULL)
+
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *map, enum map_type type,
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b24482e54451..7cc89b15fdb0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2196,14 +2196,11 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 static int find_probe_functions(struct map *map, char *name)
 {
 	int found = 0;
-	struct symbol *sym = map__find_symbol_by_name(map, name, NULL);
+	struct symbol *sym;
 
-	while (sym != NULL) {
+	map__for_each_symbol_by_name(map, name, sym) {
 		if (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL)
 			found++;
-		sym = symbol__next_by_name(sym);
-		if (sym == NULL || strcmp(sym->name, name))
-			break;
 	}
 
 	return found;
@@ -2275,9 +2272,8 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	sym = map__find_symbol_by_name(map, pp->function, NULL);
 
-	while (sym != NULL) {
+	map__for_each_symbol_by_name(map, pp->function, sym) {
 		tev = (*tevs) + ret;
 		tp = &tev->point;
 		if (ret == num_matched_functions) {
@@ -2325,10 +2321,6 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 					strdup_or_goto(pev->args[i].type,
 							nomem_out);
 		}
-
-		sym = symbol__next_by_name(sym);
-		if (sym == NULL || strcmp(sym->name, pp->function))
-			break;
 	}
 
 out:
-- 
1.9.3

