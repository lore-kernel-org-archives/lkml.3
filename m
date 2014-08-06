Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaHFJ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:26:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:53614 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaHFJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:26:17 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <xiaofeng.yan2012@gmail.com>, "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH v3] sched/deadline: overrun could happen in start_hrtick_dl
Date: Wed, 6 Aug 2014 09:08:14 +0000
Message-ID: <1407316094-18207-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.53E1F4B7.012B,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 497b5d197367f6e5853f3491e18835bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It could be wrong for the precision of runtime and deadline
when the precision is within microsecond level. For example:
Task runtime deadline period
 P1   200us   500us   500us

This case need enbale HRTICK feature by the next command
PC#echo "HRTICK" > /sys/kernel/debug/sched_features
PC#trace-cmd record -e sched_switch &
PC#./schedtool -E -t 200000:500000 -e ./test

Some of runtime and deadline run with millisecond level by
reading kernershark. Some pieces of trace.dat are as follows:
(remove some irrelevant information)
<idle>-0   157.603157: sched_switch: :R ==> 2481:4294967295: test
test-2481  157.603203: sched_switch:  2481:R ==> 0:120: swapper/2
<idle>-0   157.605657: sched_switch:  :R ==> 2481:4294967295: test
test-2481  157.608183: sched_switch:  2481:R ==> 2483:120: trace-cmd
trace-cmd-2483 157.609656: sched_switch:2483:R==>2481:4294967295: test

We can get the runtime from the information at some point.
runtime = 157.605657 - 157.608183
runtime = 0.002526(2.526ms)
The correct runtime should be less than or equal to 200us at some point.

The problem is caused by a conditional judgment "delta > 10000".
Because no hrtimer start up to control the runtime when runtime is less than 10us.
So the process will continue to run until tick-period coming.

Move the code with the limit of the least time slice
from hrtick_start_fair() to hrtick_start() because
EDF schedule class also need this function in start_hrtick_dl().

To fix this problem, we call hrtimer_start() unconditionally in start_hrtick_dl(),
and make sure schedule slice won't be smaller than 10us in hrtimer_start().

Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
Reviewed-by:   Peter Zijlstra <peterz@infradead.org>
Reviewed-by:   Li Zefan <lizefan@huawei.com>
---
 kernel/sched/core.c     |    8 +++++++-
 kernel/sched/deadline.c |    5 +----
 kernel/sched/fair.c     |    8 --------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575..53514ba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -449,8 +449,14 @@ static void __hrtick_start(void *arg)
 void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
-	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
+	ktime_t time;
 
+	/*
+	 * Don't schedule slices shorter than 10000ns, that just
+	 * doesn't make sense and can cause timer DoS.
+	 */
+	s64 delta = max_t(s64, delay, 10000LL);
+	time = ktime_add_ns(timer->base->get_time(), delta);
 	hrtimer_set_expires(timer, time);
 
 	if (rq == this_rq()) {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 255ce13..ce52d07 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -997,10 +997,7 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 #ifdef CONFIG_SCHED_HRTICK
 static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
-	s64 delta = p->dl.dl_runtime - p->dl.runtime;
-
-	if (delta > 10000)
-		hrtick_start(rq, p->dl.runtime);
+	hrtick_start(rq, p->dl.runtime);
 }
 #endif
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..0d6b3e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3892,14 +3892,6 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 				resched_curr(rq);
 			return;
 		}
-
-		/*
-		 * Don't schedule slices shorter than 10000ns, that just
-		 * doesn't make sense. Rely on vruntime for fairness.
-		 */
-		if (rq->curr != p)
-			delta = max_t(s64, 10000LL, delta);
-
 		hrtick_start(rq, delta);
 	}
 }
-- 
1.7.9.5

