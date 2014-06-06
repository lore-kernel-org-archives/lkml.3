Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaFFRVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:21:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:27385 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752504AbaFFRVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:05 -0400
Message-Id: <20140606172104.552734596@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/6] tracing: Only calculate stats of tracepoint benchmarks for 2^32 times
References: <20140606163034.516780857@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Only-calculate-stats-of-tracepoint-benchmark.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When calculating the average and standard deviation, it is required that
the count be less than UINT_MAX, otherwise the do_div() will get
undefined results. After 2^32 counts of data, the average and standard
deviation should pretty much be set anyway.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_benchmark.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_benchmark.c b/kernel/trace/trace_benchmark.c
index 8bd3365a65b2..40a14cbcf8e0 100644
--- a/kernel/trace/trace_benchmark.c
+++ b/kernel/trace/trace_benchmark.c
@@ -16,7 +16,10 @@ static u64 bm_last;
 static u64 bm_max;
 static u64 bm_min;
 static u64 bm_first;
-static s64 bm_cnt;
+static u64 bm_cnt;
+static u64 bm_stddev;
+static unsigned int bm_avg;
+static unsigned int bm_std;
 
 /*
  * This gets called in a loop recording the time it took to write
@@ -66,22 +69,35 @@ static void trace_do_benchmark(void)
 
 	bm_last = delta;
 
-	bm_total += delta;
-	bm_totalsq += delta * delta;
-
 	if (delta > bm_max)
 		bm_max = delta;
 	if (!bm_min || delta < bm_min)
 		bm_min = delta;
 
+	/*
+	 * When bm_cnt is greater than UINT_MAX, it breaks the statistics
+	 * accounting. Freeze the statistics when that happens.
+	 * We should have enough data for the avg and stddev anyway.
+	 */
+	if (bm_cnt > UINT_MAX) {
+		scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
+		    "last=%llu first=%llu max=%llu min=%llu ** avg=%u std=%d std^2=%lld",
+			  bm_last, bm_first, bm_max, bm_min, bm_avg, bm_std, bm_stddev);
+		return;
+	}
+
+	bm_total += delta;
+	bm_totalsq += delta * delta;
+
+
 	if (bm_cnt > 1) {
 		/*
 		 * Apply Welford's method to calculate standard deviation:
 		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
 		 */
 		stddev = (u64)bm_cnt * bm_totalsq - bm_total * bm_total;
-		do_div(stddev, bm_cnt);
-		do_div(stddev, bm_cnt - 1);
+		do_div(stddev, (u32)bm_cnt);
+		do_div(stddev, (u32)bm_cnt - 1);
 	} else
 		stddev = 0;
 
@@ -119,6 +135,10 @@ static void trace_do_benchmark(void)
 	scnprintf(bm_str, BENCHMARK_EVENT_STRLEN,
 		  "last=%llu first=%llu max=%llu min=%llu avg=%u std=%d std^2=%lld",
 		  bm_last, bm_first, bm_max, bm_min, avg, std, stddev);
+
+	bm_std = std;
+	bm_avg = avg;
+	bm_stddev = stddev;
 }
 
 static int benchmark_event_kthread(void *arg)
@@ -170,6 +190,9 @@ void trace_benchmark_unreg(void)
 	bm_max = 0;
 	bm_min = 0;
 	bm_cnt = 0;
-	/* bm_first doesn't need to be reset but reset it anyway */
+	/* These don't need to be reset but reset them anyway */
 	bm_first = 0;
+	bm_std = 0;
+	bm_avg = 0;
+	bm_stddev = 0;
 }
-- 
2.0.0.rc2


