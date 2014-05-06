Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbaEFCwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:52:22 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:26007 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933714AbaEFCwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:52:20 -0400
X-IronPort-AV: E=Sophos;i="4.97,993,1389715200"; 
   d="scan'208";a="30113503"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>
CC: <peterz@infradead.org>, <bsegall@google.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: Distinguish sched_wakeup event when wake up a task which did schedule out or not.
Date: Tue, 6 May 2014 10:52:34 +0900
Message-ID: <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <53683B14.3060702@cn.fujitsu.com>
References: <53683B14.3060702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ttwu_do_wakeup() is called when the task's state is switched back to
TASK_RUNNING, whether or not the task actually scheduled out. Tracing
the wakeup event when the task never scheduled out is quite confusing.

This patch take the use of 'success' parameter in sched_wakeup tracepoint,
to indicate that the task we are waking up did schedule out or just
change its state to TASK_RUNNING.

success is true:
	task was out of run queue and sleeping, we are really wake it up.
success is false:
	taks was on run queue all the time and we just change its state
	to TASK_RUNNING.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9074c6d..14b9fe4 100644
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
@@ -1481,6 +1481,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	if (p->on_rq) {
 		/* check_preempt_curr() may use rq clock */
 		update_rq_clock(rq);
+		trace_sched_wakeup(p, false);
 		ttwu_do_wakeup(rq, p, wake_flags);
 		ret = 1;
 	}
@@ -1675,6 +1676,8 @@ static void try_to_wake_up_local(struct task_struct *p)
 
 	if (!p->on_rq)
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+	else
+		trace_sched_wakeup(p, false);
 
 	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
-- 
1.8.2.1

