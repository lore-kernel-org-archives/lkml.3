Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3APKOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:14:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758365Ab3APKOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:14:46 -0500
Date: Wed, 16 Jan 2013 11:14:38 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -tip] sched: Pair ttwu_activate() with uwtt_deactivate()
Message-ID: <10a81412c1ac7549412b11a9aa0b5c70dac5de37.1358331166.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to make reading of __schedule() bit more easy.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/sched/core.c |   42 ++++++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 38413f6..dd54ded 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1272,6 +1272,27 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
+static void try_to_wake_up_local(struct task_struct *p);
+
+static void uwtt_deactivate(struct rq *rq, struct task_struct *p, int de_flags)
+{
+	deactivate_task(rq, p, de_flags);
+	p->on_rq = 0;
+
+	/*
+	 * If a worker went to sleep, notify and ask workqueue
+	 * whether it wants to wake up a task to maintain
+	 * concurrency.
+	 */
+	if (p->flags & PF_WQ_WORKER) {
+		struct task_struct *to_wakeup;
+
+		to_wakeup = wq_worker_sleeping(p, cpu_of(rq));
+		if (to_wakeup)
+			try_to_wake_up_local(to_wakeup);
+	}
+}
+
 /*
  * Mark the task runnable and perform wakeup-preemption.
  */
@@ -2907,25 +2928,10 @@ need_resched:
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely(signal_pending_state(prev->state, prev))) {
+		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		} else {
-			deactivate_task(rq, prev, DEQUEUE_SLEEP);
-			prev->on_rq = 0;
-
-			/*
-			 * If a worker went to sleep, notify and ask workqueue
-			 * whether it wants to wake up a task to maintain
-			 * concurrency.
-			 */
-			if (prev->flags & PF_WQ_WORKER) {
-				struct task_struct *to_wakeup;
-
-				to_wakeup = wq_worker_sleeping(prev, cpu);
-				if (to_wakeup)
-					try_to_wake_up_local(to_wakeup);
-			}
-		}
+		else
+			uwtt_deactivate(rq, prev, DEQUEUE_SLEEP);
 		switch_count = &prev->nvcsw;
 	}
 
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
