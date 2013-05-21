Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3EUVfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:35:14 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10299 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3EUVfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:35:12 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 17:35:12 EDT
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 May 2013 14:30:10 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Date: Tue, 21 May 2013 14:30:09 -0700
Subject: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
Thread-Topic: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
Thread-Index: AQHOVmmEEc7uQ+HN6k6ZIIT7WMiarg==
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RT throttling aims to prevent starvation of non-SCHED_FIFO threads
when a rogue RT thread is hogging the CPU. It does so by piggybacking
on the rt_bandwidth system and allocating at most rt_runtime per
rt_period to SCHED_FIFO tasks (e.g. 950ms out of every second,
allowing 'regular' tasks to run for at least 50ms every second).

However, when multiple cores are available, rt_bandwidth allows cores
to borrow rt_runtime from one another. This means that a core with a
rogue RT thread, consuming 100% CPU cycles, can borrow enough runtime
from other cores to allow the RT thread to run continuously, with no
runtime for regular tasks on this core.

Although regular tasks can get scheduled on other available cores
(which are guaranteed to have some non-RT runtime avaible, since they
just lent some RT time to us), tasks that are specifically affined to
a particular core may not be able to make progress (e.g. workqueues,
timer functions). This can break e.g. watchdog-like functionality that
is supposed to kill the rogue RT thread.

This patch changes do_balance_runtime() in such a way that no core can
aquire (borrow) more runtime than the globally set rt_runtime /
rt_period ratio. This guarantees there will always be some non-RT
runtime available on every individual core.

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
---
 kernel/sched/rt.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 127a2c4..5ec4eab 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -571,11 +571,25 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more = 0;
 	u64 rt_period;
+	u64 max_runtime;
 
 	weight = cpumask_weight(rd->span);
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
+
+	/* Don't allow more runtime than global ratio */
+	if (global_rt_runtime() == RUNTIME_INF)
+		max_runtime = rt_period;
+	else
+		max_runtime = div64_u64(global_rt_runtime() * rt_period,
+					global_rt_period());
+
+	if (rt_rq->rt_runtime >= max_runtime) {
+		raw_spin_unlock(&rt_b->rt_runtime_lock);
+		return more;
+	}
+
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
@@ -592,6 +606,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 		if (iter->rt_runtime == RUNTIME_INF)
 			goto next;
 
+
 		/*
 		 * From runqueues with spare time, take 1/n part of their
 		 * spare time, but no more than our period.
@@ -599,12 +614,12 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			diff = div_u64((u64)diff, weight);
-			if (rt_rq->rt_runtime + diff > rt_period)
-				diff = rt_period - rt_rq->rt_runtime;
+			if (rt_rq->rt_runtime + diff > max_runtime)
+				diff = max_runtime - rt_rq->rt_runtime;
 			iter->rt_runtime -= diff;
 			rt_rq->rt_runtime += diff;
 			more = 1;
-			if (rt_rq->rt_runtime == rt_period) {
+			if (rt_rq->rt_runtime == max_runtime) {
 				raw_spin_unlock(&iter->rt_runtime_lock);
 				break;
 			}
-- 
1.7.0.4
