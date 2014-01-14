Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaANF0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:26:07 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53535 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaANF0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:00 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-86-52d4ca664613
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/24] perf tools: Factor out sample__resolve_callchain()
Date: Tue, 14 Jan 2014 14:25:35 +0900
Message-Id: <1389677157-30513-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The report__resolve_callchain() can be shared with perf top code as it
doesn't really depend on the perf report code.  Factor it out as
sample__resolve_callchain().  The same goes to the hist_entry__append_
callchain() too.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 24 +++---------------------
 tools/perf/builtin-top.c    | 22 +++++++---------------
 tools/perf/util/callchain.c | 23 +++++++++++++++++++++++
 tools/perf/util/callchain.h |  6 ++++++
 4 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1bb9e989c7bd..7ddea46594ae 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -85,24 +85,6 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int report__resolve_callchain(struct report *rep, struct symbol **parent,
-				     struct perf_evsel *evsel, struct addr_location *al,
-				     struct perf_sample *sample)
-{
-	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		return machine__resolve_callchain(al->machine, evsel, al->thread, sample,
-						  parent, al, rep->max_stack);
-	}
-	return 0;
-}
-
-static int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample)
-{
-	if (!symbol_conf.use_callchain)
-		return 0;
-	return callchain_append(he->callchain, &callchain_cursor, sample->period);
-}
-
 static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
 				      struct perf_sample *sample, struct perf_evsel *evsel,
 				      union perf_event *event)
@@ -113,7 +95,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
 
 	if (err)
 		return err;
@@ -165,7 +147,7 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 	unsigned i;
 	struct hist_entry *he;
 	struct branch_info *bi, *bx;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
 
 	if (err)
 		return err;
@@ -218,7 +200,7 @@ static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evs
 	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	struct hist_entry *he;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
 
 	if (err)
 		return err;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 569dd87690ef..76cd510d34d0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -743,15 +743,10 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (al.sym == NULL || !al.sym->ignore) {
 		struct hist_entry *he;
 
-		if ((sort__has_parent || symbol_conf.use_callchain) &&
-		    sample->callchain) {
-			err = machine__resolve_callchain(machine, evsel,
-							 al.thread, sample,
-							 &parent, &al,
-							 top->max_stack);
-			if (err)
-				return;
-		}
+		err = sample__resolve_callchain(sample, &parent, evsel, &al,
+						top->max_stack);
+		if (err)
+			return;
 
 		he = perf_evsel__add_hist_entry(evsel, &al, sample);
 		if (he == NULL) {
@@ -759,12 +754,9 @@ static void perf_event__process_sample(struct perf_tool *tool,
 			return;
 		}
 
-		if (symbol_conf.use_callchain) {
-			err = callchain_append(he->callchain, &callchain_cursor,
-					       sample->period);
-			if (err)
-				return;
-		}
+		err = hist_entry__append_callchain(he, sample);
+		if (err)
+			return;
 
 		if (sort__has_sym)
 			perf_top__record_precise_ip(top, he, evsel->idx, ip);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index e3970e3eaacf..9eb4f57f8663 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -17,6 +17,8 @@
 
 #include "hist.h"
 #include "util.h"
+#include "sort.h"
+#include "machine.h"
 #include "callchain.h"
 
 __thread struct callchain_cursor callchain_cursor;
@@ -531,3 +533,24 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 
 	return 0;
 }
+
+int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent,
+			      struct perf_evsel *evsel, struct addr_location *al,
+			      int max_stack)
+{
+	if (sample->callchain == NULL)
+		return 0;
+
+	if (symbol_conf.use_callchain || sort__has_parent) {
+		return machine__resolve_callchain(al->machine, evsel, al->thread,
+						  sample, parent, al, max_stack);
+	}
+	return 0;
+}
+
+int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample)
+{
+	if (!symbol_conf.use_callchain)
+		return 0;
+	return callchain_append(he->callchain, &callchain_cursor, sample->period);
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 08b25af9eea1..8ad97e9b119f 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -145,10 +145,16 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 }
 
 struct option;
+struct hist_entry;
 
 int record_parse_callchain(const char *arg, struct record_opts *opts);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
 int record_callchain_opt(const struct option *opt, const char *arg, int unset);
 
+int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent,
+			      struct perf_evsel *evsel, struct addr_location *al,
+			      int max_stack);
+int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
+
 extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.7.11.7

