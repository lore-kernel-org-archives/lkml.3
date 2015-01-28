Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbbA1VZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:25:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762094AbbA1Utp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:45 -0500
Date: Wed, 28 Jan 2015 07:02:30 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-eh73z8gthv20yowirmx2yk38@git.kernel.org>
Cc: dsahern@gmail.com, tglx@linutronix.de, masami.hiramatsu.pt@hitachi.com,
        acme@redhat.com, hpa@zytor.com, jolsa@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, jolsa@redhat.com, mingo@kernel.org,
        acme@redhat.com, hpa@zytor.com, masami.hiramatsu.pt@hitachi.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Introduce 'for'
  method to iterate over the symbols with a given name
Git-Commit-ID: 0a3873a8e2709ebc759361e2d872d9f71541806c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a3873a8e2709ebc759361e2d872d9f71541806c
Gitweb:     http://git.kernel.org/tip/0a3873a8e2709ebc759361e2d872d9f71541806c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 16 Jan 2015 16:40:25 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:06:15 -0300

perf symbols: Introduce 'for' method to iterate over the symbols with a given name

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
index 6951a9d..0e42438 100644
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
index b24482e..7cc89b1 100644
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
