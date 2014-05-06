Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaEFB0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:26:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20594 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933432AbaEFB0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:26:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,992,1389715200"; 
   d="scan'208";a="30110077"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>
CC: <peterz@infradead.org>, <bsegall@google.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: Move the wakeup tracepoint from ttwu_do_wakeup() to ttwu_activate().
Date: Tue, 6 May 2014 09:26:20 +0900
Message-ID: <1399335980-10059-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <53682AA7.9060401@cn.fujitsu.com>
References: <53682AA7.9060401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ttwu_do_wakeup() is called when the task's state is switched back to
TASK_RUNNING, whether or not the task actually scheduled out. Tracing
the wakeup event when the task never scheduled out is quite confusing.
It should only trace the task wake up if the task actually did go to
sleep. Move the tracepoint from ttwu_do_wakeup() to ttwu_activate()
where it is called only if the task is really woken up and not just
have its state changed.

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

