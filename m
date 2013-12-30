Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3L3DOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 22:14:12 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:54611 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3L3DOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 22:14:10 -0500
MIME-Version: 1.0
Date: Mon, 30 Dec 2013 11:14:08 +0800
Message-ID: <CALZhoST3oQnSOv0ZQ6CiHDgTC4D+t=Kd4Gp4oPqrnH__qMZ7Hw@mail.gmail.com>
Subject: [RFC] sched: update rq clock when only get preempt
From: Lei Wen <adrian.wenl@gmail.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we would update rq clock at task enqueue/dequeue, or schedule
tick. If we don't update the rq clock when our previous task get
preempted, our new started task would get a relative stale rq clock
which is updated during the previous task enqueue, or the last schedule
clock update.

If we want more precise account for the task start and duration time,
we'd better ensure rq clock get updated when it begin to run.

Best regards,
Lei

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..50e91b6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2503,7 +2503,7 @@ static void __sched __schedule(void)
        struct task_struct *prev, *next;
        unsigned long *switch_count;
        struct rq *rq;
-       int cpu;
+       int cpu, update = 1;

 need_resched:
        preempt_disable();
@@ -2530,6 +2530,7 @@ need_resched:
                if (unlikely(signal_pending_state(prev->state, prev))) {
                        prev->state = TASK_RUNNING;
                } else {
+                       update = 0;
                        deactivate_task(rq, prev, DEQUEUE_SLEEP);
                        prev->on_rq = 0;

@@ -2555,6 +2556,8 @@ need_resched:
                idle_balance(cpu, rq);

        put_prev_task(rq, prev);
+       if (update)
+               update_rq_clock(rq);
        next = pick_next_task(rq);
        clear_tsk_need_resched(prev);
        clear_preempt_need_resched();
-- 
1.8.3.2
