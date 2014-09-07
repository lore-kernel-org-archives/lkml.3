Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaIGKvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:51:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaIGKvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:51:11 -0400
Date: Sun, 7 Sep 2014 03:49:24 -0700
From: "tip-bot for xiaofeng.yan" <tipbot@zytor.com>
Message-ID: <tip-177ef2a6315ea7bf173653182324e1dcd08ffeaa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        juri.lelli@arm.com, tglx@linutronix.de, xiaofeng.yan@huawei.com,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        juri.lelli@arm.com, tglx@linutronix.de, xiaofeng.yan@huawei.com,
        lizefan@huawei.com
In-Reply-To: <1409022941-5880-1-git-send-email-xiaofeng.yan@huawei.com>
References: <1409022941-5880-1-git-send-email-xiaofeng.yan@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Fix a precision problem in the microseconds range
Git-Commit-ID: 177ef2a6315ea7bf173653182324e1dcd08ffeaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  177ef2a6315ea7bf173653182324e1dcd08ffeaa
Gitweb:     http://git.kernel.org/tip/177ef2a6315ea7bf173653182324e1dcd08ffeaa
Author:     xiaofeng.yan <xiaofeng.yan@huawei.com>
AuthorDate: Tue, 26 Aug 2014 03:15:41 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 7 Sep 2014 11:09:59 +0200

sched/deadline: Fix a precision problem in the microseconds range

An overrun could happen in function start_hrtick_dl()
when a task with SCHED_DEADLINE runs in the microseconds
range.

For example, if a task with SCHED_DEADLINE has the following parameters:

  Task  runtime  deadline  period
   P1   200us     500us    500us

The deadline and period from task P1 are less than 1ms.

In order to achieve microsecond precision, we need to enable HRTICK feature
by the next command:

  PC#echo "HRTICK" > /sys/kernel/debug/sched_features
  PC#trace-cmd record -e sched_switch &
  PC#./schedtool -E -t 200000:500000:500000 -e ./test

The binary test is in an endless while(1) loop here.
Some pieces of trace.dat are as follows:

  <idle>-0   157.603157: sched_switch: :R ==> 2481:4294967295: test
  test-2481  157.603203: sched_switch:  2481:R ==> 0:120: swapper/2
  <idle>-0   157.605657: sched_switch:  :R ==> 2481:4294967295: test
  test-2481  157.608183: sched_switch:  2481:R ==> 2483:120: trace-cmd
  trace-cmd-2483 157.609656: sched_switch:2483:R==>2481:4294967295: test

We can get the runtime of P1 from the information above:

  runtime = 157.608183 - 157.605657
  runtime = 0.002526(2.526ms)

The correct runtime should be less than or equal to 200us at some point.

The problem is caused by a conditional judgment "delta > 10000"
in function start_hrtick_dl().

Because no hrtimer start up to control the rest of runtime
when the reset of runtime is less than 10us.

So the process will continue to run until tick-period is coming.

Move the code with the limit of the least time slice
from hrtick_start_fair() to hrtick_start() because the
EDF schedule class also needs this function in start_hrtick_dl().

To fix this problem, we call hrtimer_start() unconditionally in
start_hrtick_dl(), and make sure the scheduling slice won't be smaller
than 10us in hrtimer_start().

Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
Reviewed-by: Li Zefan <lizefan@huawei.com>
Acked-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409022941-5880-1-git-send-email-xiaofeng.yan@huawei.com
[ Massaged the changelog and the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c     | 10 +++++++++-
 kernel/sched/deadline.c |  5 +----
 kernel/sched/fair.c     |  8 --------
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a773c91..8d00f4a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -455,7 +455,15 @@ static void __hrtick_start(void *arg)
 void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
-	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
+	ktime_t time;
+	s64 delta;
+
+	/*
+	 * Don't schedule slices shorter than 10000ns, that just
+	 * doesn't make sense and can cause timer DoS.
+	 */
+	delta = max_t(s64, delay, 10000LL);
+	time = ktime_add_ns(timer->base->get_time(), delta);
 
 	hrtimer_set_expires(timer, time);
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d21a8e0..cc4eb89 100644
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
index 02fc949..50d2025 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3897,14 +3897,6 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
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
