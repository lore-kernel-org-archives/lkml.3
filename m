Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaCYRqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:46:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:16584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaCYRqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:46:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="499273746"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, tools, stat: Initialize statistics correctly
Date: Tue, 25 Mar 2014 10:31:38 -0700
Message-Id: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf stat did initialize the stats structure used to compute
stddev etc. incorrectly. It merely zeroes it. But one member
(min) needs to be set to a non zero value. This causes min
to be not computed at all. Call init_stats() correctly.

It doesn't matter for stat currently because it doesn't use
min, but it's still better to do it correctly.

The other users of statistics are already correct.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b0e1c9..65a151e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -174,13 +174,20 @@ static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
 
 static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
 {
-	memset(evsel->priv, 0, sizeof(struct perf_stat));
+	int i;
+	struct perf_stat *ps = evsel->priv;
+
+	for (i = 0; i < 3; i++)
+		init_stats(&ps->res_stats[i]);
 }
 
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
-	return evsel->priv == NULL ? -ENOMEM : 0;
+	if (evsel == NULL)
+		return -ENOMEM;
+	perf_evsel__reset_stat_priv(evsel);
+	return 0;
 }
 
 static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
-- 
1.8.5.3

