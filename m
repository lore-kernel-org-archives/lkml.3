Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbbA1Ut6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbbA1Utz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:55 -0500
Date: Wed, 28 Jan 2015 07:02:11 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-564c62a4d7f9a4b60920ee0b02cfe890471d87f4@git.kernel.org>
Cc: acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com, namhyung@kernel.org,
        hpa@zytor.com, mingo@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, acme@redhat.com,
        jolsa@redhat.com, dsahern@gmail.com, namhyung@kernel.org,
        hpa@zytor.com
In-Reply-To: <1421234288-22758-3-git-send-email-namhyung@kernel.org>
References: <1421234288-22758-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Do not rely on map__load()
  filter to find symbols
Git-Commit-ID: 564c62a4d7f9a4b60920ee0b02cfe890471d87f4
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

Commit-ID:  564c62a4d7f9a4b60920ee0b02cfe890471d87f4
Gitweb:     http://git.kernel.org/tip/564c62a4d7f9a4b60920ee0b02cfe890471d87f4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 14 Jan 2015 20:18:07 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:06:02 -0300

perf probe: Do not rely on map__load() filter to find symbols

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
nodes since there can be multiple (local) symbols with same name.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1421234288-22758-3-git-send-email-namhyung@kernel.org
[ Use symbol__next_by_name ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 94a717b..b24482e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2193,18 +2193,20 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
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
+	int found = 0;
+	struct symbol *sym = map__find_symbol_by_name(map, name, NULL);
+
+	while (sym != NULL) {
+		if (sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL)
+			found++;
+		sym = symbol__next_by_name(sym);
+		if (sym == NULL || strcmp(sym->name, name))
+			break;
 	}
-	return 1;
+
+	return found;
 }
 
 #define strdup_or_goto(str, label)	\
@@ -2222,10 +2224,10 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	struct kmap *kmap = NULL;
 	struct ref_reloc_sym *reloc_sym = NULL;
 	struct symbol *sym;
-	struct rb_node *nd;
 	struct probe_trace_event *tev;
 	struct perf_probe_point *pp = &pev->point;
 	struct probe_trace_point *tp;
+	int num_matched_functions;
 	int ret, i;
 
 	/* Init maps of given executable or kernel */
@@ -2242,10 +2244,8 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
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
@@ -2275,7 +2275,9 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	map__for_each_symbol(map, sym, nd) {
+	sym = map__find_symbol_by_name(map, pp->function, NULL);
+
+	while (sym != NULL) {
 		tev = (*tevs) + ret;
 		tp = &tev->point;
 		if (ret == num_matched_functions) {
@@ -2323,6 +2325,10 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 					strdup_or_goto(pev->args[i].type,
 							nomem_out);
 		}
+
+		sym = symbol__next_by_name(sym);
+		if (sym == NULL || strcmp(sym->name, pp->function))
+			break;
 	}
 
 out:
