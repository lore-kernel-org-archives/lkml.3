Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaBGT7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:59:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:48253 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaBGT7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:59:01 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/6] sched: Adjust sched_reset_on_fork when nothing else changes
Date: Fri,  7 Feb 2014 20:58:40 +0100
Message-Id: <1391803122-4425-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If the policy and priority remain unchanged a possible modification of
sched_reset_on_fork gets lost in the early exit path.

Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: rebase ontop of v3.14-rc1]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/sched/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3112b28..a4c06a8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3392,7 +3392,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed further,
+	 * but store a possible modification of reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy)) {
 		if (fair_policy(policy) && attr->sched_nice != TASK_NICE(p))
@@ -3402,6 +3403,7 @@ static int __sched_setscheduler(struct task_struct *p,
 		if (dl_policy(policy))
 			goto change;
 
+		p->sched_reset_on_fork = reset_on_fork;
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
-- 
1.9.rc1

