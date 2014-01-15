Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaAOUfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:35:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48512 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaAOUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/13] perf tools: Factor out sample__resolve_callchain()
Date: Wed, 15 Jan 2014 17:33:09 -0300
Message-Id: <1389817991-8145-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The report__resolve_callchain() can be shared with perf top code as it
doesn't really depend on the perf report code.  Factor it out as
sample__resolve_callchain().  The same goes to the hist_entry__append_
callchain() too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1389677157-30513-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 24 +++---------------------
 tools/perf/builtin-top.c    | 22 +++++++---------------
 tools/perf/util/callchain.c | 23 +++++++++++++++++++++++
 tools/perf/util/callchain.h |  6 ++++++
 4 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 46864dd7eb83..3c53ec268fbc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -75,24 +75,6 @@ static int report__config(const char *var, const char *value, void *cb)
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
@@ -103,7 +85,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
 
 	if (err)
 		return err;
@@ -155,7 +137,7 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 	unsigned i;
 	struct hist_entry *he;
 	struct branch_info *bi, *bx;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
+	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
 
 	if (err)
 		return err;
@@ -208,7 +190,7 @@ static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evs
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
1.8.1.4

