Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3DKXv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:51:29 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44423 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3DKXvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:51:25 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 3/5] sched: Update rq clock before calling check_preempt_curr()
Date: Fri, 12 Apr 2013 01:51:00 +0200
Message-Id: <1365724262-20142-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
References: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_preempt_curr() of fair class needs an uptodate sched clock
value to update runtime stats of the current task of the target's rq.

When a task is woken up, activate_task() is usually called right before
ttwu_do_wakeup() unless the task is still in the runqueue. In the latter
case we need to update the rq clock explicitly because activate_task()
isn't here to do the job for us.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec036d8..5f3e05d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1334,6 +1334,8 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 
 	rq = __task_rq_lock(p);
 	if (p->on_rq) {
+		/* check_preempt_curr() may use rq clock */
+		update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
 		ret = 1;
 	}
-- 
1.7.5.4

