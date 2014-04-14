Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaDNOXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:23:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbaDNOSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/17] perf stat: Initialize statistics correctly
Date: Mon, 14 Apr 2014 16:17:37 +0200
Message-Id: <1397485061-17215-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
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
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1395768699-16060-1-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.8.3.1

