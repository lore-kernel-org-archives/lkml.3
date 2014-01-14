Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaANFaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:30:09 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60799 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaANF0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:05 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-a0-52d4ca67f884
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/24] perf hists: Sort hist entries by accumulated period
Date: Tue, 14 Jan 2014 14:25:45 +0900
Message-Id: <1389677157-30513-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When callchain accumulation is requested, we need to sort the entries
by accumulated period value.  When accumulated periods of two entries
are same (i.e. single path callchain) put the caller above since
accumulation tends to put callers on higher position for obvious
reason.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 765ac5953201..da4fbec3d0d8 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1063,6 +1063,18 @@ static int hist_entry__sort_on_period(struct hist_entry *a,
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

