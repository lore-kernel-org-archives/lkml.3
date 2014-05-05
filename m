Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaEEHdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:33:55 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:16011 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754635AbaEEHdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:33:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,985,1389715200"; 
   d="scan'208";a="30072270"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <peterz@infradead.org>, <bsegall@google.com>, <rostedt@goodmis.org>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: Move the wakeup tracepoint from ttwu_do_wakeup() to ttwu_activate().
Date: Mon, 5 May 2014 15:34:07 +0900
Message-ID: <1399271647-25696-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <53673074.1040406@cn.fujitsu.com>
References: <53673074.1040406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original design of sched:sched_wakeup is to trace the event inserting
a task into run queue. It means we can know that the state of this task is
changed from "sleeping" to "waiting_cpu". Then we can calculate the delay time
from this task on_rq = 1 to running on cpu in `perf sched latency`.

But currently, sched:sched_wakeup event is tracing ttwu_do_wakeup() and this
function only set the p->state to TASK_RUNNING. This trace point can tell user
very little. When get a event of sched:sched_wakeup, user know that kernel call
ttwu_do_wakeup() once, but we can not say that task start to wait cpu from now
on. Maybe it did not dequeue at all, in this case we will get a wrong latency
time calculated by "sched_in_time - wakeup_time".

Anyway, current sched:sched_wakeup event can tell user very little.
When we get a sched:sched_wakeup:
* We can not say a task is inserted into run queue, it is also used for task
which is on_rq and only change the task->state to TASK_RUNNING.
* We can not say the task->state is changed from {UN}INTERRUPTABLE to RUNNING,
sometimes task->state is already changed to RUNNING by other cpu.

As explained above, this patch move the trace point of sched:sched_wakeup from
ttwu_do_wakeup() to ttwu_activate(), then when we get an event of sched_wakeup,
we can say that a task enqueued and started waiting cpu to run.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9074c6d..0cae994 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1420,6 +1420,7 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
 	p->on_rq = 1;
+	trace_sched_wakeup(p, true);
 
 	/* if a worker is waking up, notify workqueue */
 	if (p->flags & PF_WQ_WORKER)
@@ -1433,7 +1434,6 @@ static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	check_preempt_curr(rq, p, wake_flags);
-	trace_sched_wakeup(p, true);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
-- 
1.8.2.1

