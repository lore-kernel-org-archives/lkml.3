Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3JaG5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:57:42 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52116 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3JaG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:24 -0400
X-AuditID: 9c930197-b7b3eae00000122e-e8-5271ff16fc58
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 09/14] perf hists: Sort hist entries by accumulated period
Date: Thu, 31 Oct 2013 15:56:11 +0900
Message-Id: <1383202576-28141-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-report.c | 13 +++++++++++++
 tools/perf/util/hist.c      | 12 ++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1a0de9a4a568..3b626127c8d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -349,6 +349,13 @@ iter_add_single_normal_entry(struct add_entry_iter *iter, struct addr_location *
 	if (he == NULL)
 		return -ENOMEM;
 
+	/*
+	 * This is for putting parents upward during output resort iff
+	 * only a child gets sampled.  See hist_entry__sort_on_period().
+	 */
+	he->callchain->max_depth = callchain_cursor.nr - callchain_cursor.pos;
+	he->callchain->max_depth += PERF_MAX_STACK_DEPTH + 1;
+
 	iter->he = he;
 	return 0;
 }
@@ -559,6 +566,12 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
 		return -ENOMEM;
 
 	/*
+	 * This is for putting parents upward during output resort iff
+	 * only a child gets sampled.  See hist_entry__sort_on_period().
+	 */
+	he->callchain->max_depth = callchain_cursor.nr - callchain_cursor.pos;
+
+	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 229329a20ba5..c1d5d6b43bba 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -623,6 +623,18 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
 	struct hist_entry *pair;
 	u64 *periods_a, *periods_b;
 
+	if (callchain_param.mode == CHAIN_CUMULATIVE) {
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

