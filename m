Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LXIWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:22:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44569 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3LXIWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:22:34 -0500
X-AuditID: 9c930179-b7c89ae000006438-f8-52b944470b15
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 08/21] perf hists: Sort hist entries by accumulated period
Date: Tue, 24 Dec 2013 17:22:14 +0900
Message-Id: <1387873347-28838-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When callchain accumulation is requested, we need to sort the entries
by accumulated period value.  When accumulated periods of two entries
are same (i.e. single path callchain) put the caller above since
accumulation tends to put callers on higher position for obvious
reason.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  6 ++++++
 tools/perf/util/hist.c      | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1314841ffad1..ae298ae91a47 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -509,6 +509,12 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
 
 	he_cache[iter->curr++] = he;
 
+	/*
+	 * This is for putting parents upward during output resort iff
+	 * only a child gets sampled.  See hist_entry__sort_on_period().
+	 */
+	he->callchain->max_depth = callchain_cursor.nr - callchain_cursor.pos;
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9a522a05b937..34bbff92b3d7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -625,6 +625,18 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
 	struct hist_entry *pair;
 	u64 *periods_a, *periods_b;
 
+	if (symbol_conf.cumulate_callchain) {
+		/*
+		 * Put caller above callee when they have equal period.
+		 */
+		if (a->stat_acc->period != b->stat_acc->period)
+			return a->stat_acc->period > b->stat_acc->period ? 1 : -1;
+
+		if (a->callchain->max_depth != b->callchain->max_depth)
+			return a->callchain->max_depth < b->callchain->max_depth ?
+				1 : -1;
+	}
+
 	ret = period_cmp(a->stat.period, b->stat.period);
 	if (ret || !symbol_conf.event_group)
 		return ret;
-- 
1.7.11.7

