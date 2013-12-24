Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3LXIYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:24:53 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50238 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3LXIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:22:36 -0500
X-AuditID: 9c930179-b7c89ae000006438-17-52b94449fd4c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 16/21] perf tools: Factor out sample__resolve_callchain()
Date: Tue, 24 Dec 2013 17:22:22 +0900
Message-Id: <1387873347-28838-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The report__resolve_callchain() can be shared with perf top code as it
doesn't really depend on the perf report code.  Factor it out as
sample__resolve_callchain().  The same goes to the hist_entry__append_
callchain() too.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 22 ++--------------------
 tools/perf/builtin-top.c    | 22 +++++++---------------
 tools/perf/util/callchain.c | 23 +++++++++++++++++++++++
 tools/perf/util/callchain.h |  6 ++++++
 4 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 615f078cc94e..1ec00acfcd92 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,24 +79,6 @@ static int report__config(const char *var, const char *value, void *cb)
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
 struct add_entry_iter {
 	int total;
 	int curr;
@@ -576,8 +558,8 @@ perf_evsel__add_entry(struct perf_evsel *evsel, struct addr_location *al,
 {
 	int err, err2;
 
-	err = report__resolve_callchain(iter->rep, &iter->parent, evsel, al,
-					sample);
+	err = sample__resolve_callchain(sample, &iter->parent, evsel, al,
+					iter->rep->max_stack);
 	if (err)
 		return err;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 142a41bd5062..48c527a0f4c8 100644
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
index e3970e3eaacf..c938da83144e 100644
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
+	if (sort__has_parent || symbol_conf.use_callchain) {
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

