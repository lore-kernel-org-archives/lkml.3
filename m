Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3LRFWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:22:10 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48783 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3LRFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:32 -0500
X-AuditID: 9c93017d-b7c5eae000004296-2f-52b130d90da4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 11/18] perf hists: Sort hist entries by accumulated period
Date: Wed, 18 Dec 2013 14:21:19 +0900
Message-Id: <1387344086-12744-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
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
index 4ec1a090d1a3..b2bcb98a7300 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -566,6 +566,12 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
 	he_cache[iter->curr++] = he;
 
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
index 22b80b509c85..84fd1e6e9a37 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -626,6 +626,18 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
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

