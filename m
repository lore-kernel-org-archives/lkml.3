Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaGIGN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:13:56 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30315 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaGIGNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:13:55 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <xiaofeng.yan2012@gmail.com>, <lizefan@huawei.com>,
        "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH] sched/core: Limit the least time slice in hrtick_start()
Date: Wed, 9 Jul 2014 05:56:25 +0000
Message-ID: <1404885385-14105-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move this piece of code with the limit of the least time slice
from hrtick_start_fair() to hrtick_start() because
EDF schedule class also need this function in start_hrtick_dl().

EDF tasks with the runtime of microsecond level will lead to the wrong
precision because system can't control the end of process when left runtime is
less than 10us.

The goal is to fix this bug from start_hrtick_dl() and reduce code redundancy.

Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
Reviewed-by:   Li Zefan <lizefan@huawei.com>
---
 kernel/sched/core.c     |    8 +++++++-
 kernel/sched/deadline.c |    5 +----
 kernel/sched/fair.c     |    8 --------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..7f066c2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -442,8 +442,14 @@ static void __hrtick_start(void *arg)
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
index fc4f98b1..9135771 100644
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
index fea7d33..e5cfd57 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3857,14 +3857,6 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 				resched_task(p);
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

