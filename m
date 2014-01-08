Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaAHItb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:49:31 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47900 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbaAHIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:51 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-2c-52cd10704b07
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 21/28] perf tools: Factor out sample__resolve_callchain()
Date: Wed,  8 Jan 2014 17:46:26 +0900
Message-Id: <1389170793-21926-22-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-report.c | 26 ++------------------------
 tools/perf/builtin-top.c    | 22 +++++++---------------
 tools/perf/util/callchain.c | 24 ++++++++++++++++++++++++
 tools/perf/util/callchain.h |  6 ++++++
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a15fa05e4a70..06eceab8d4af 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,28 +79,6 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int report__resolve_callchain(struct report *rep, struct symbol **parent,
-				     struct perf_evsel *evsel, struct addr_location *al,
-				     struct perf_sample *sample)
-{
-	if (sample->callchain == NULL)
-		return 0;
-
-	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
-	    sort__has_parent) {
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
 struct hist_entry_iter {
 	int total;
 	int curr;
@@ -562,8 +540,8 @@ iter_add_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
 	int err, err2;
 
-	err = report__resolve_callchain(iter->rep, &iter->parent, iter->evsel,
-					al, iter->sample);
+	err = sample__resolve_callchain(iter->sample, &iter->parent,
+					iter->evsel, al, iter->rep->max_stack);
 	if (err)
 		return err;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6d721bccdd26..f0f55e6030cd 100644
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
index e3970e3eaacf..92b9010a651c 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -17,6 +17,8 @@
 
 #include "hist.h"
 #include "util.h"
+#include "sort.h"
+#include "machine.h"
 #include "callchain.h"
 
 __thread struct callchain_cursor callchain_cursor;
@@ -531,3 +533,25 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 
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
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
+	    sort__has_parent) {
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
index bad694287cb8..209538924cb6 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -145,11 +145,17 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
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
 
 static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
-- 
1.7.11.7

