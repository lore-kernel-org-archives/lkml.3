Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab3E3PXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:23:31 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53617 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3E3PXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:23:25 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
Date: Thu, 30 May 2013 17:23:05 +0200
Message-Id: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have faced a sequence where the Idle Load Balance was sometime not
 triggered for a while on my platform.

CPU 0 and CPU 1 are running tasks and CPU 2 is idle

CPU 1 kicks the Idle Load Balance
CPU 1 selects CPU 2 as the new Idle Load Balancer
CPU 1 sets NOHZ_BALANCE_KICK for CPU 2
CPU 1 sends a reschedule IPI to CPU 2
While CPU 2 wakes up, CPU 0 or CPU 1 migrates a waking task A on CPU 2
CPU 2 finally wakes up, runs task A and discards the Idle Load Balance
Task A quickly goes back to sleep (before a tick occurs on CPU 2)
CPU 2 goes back to idle with NOHZ_BALANCE_KICK set

Whenever CPU 2 will be selected for the ILB, reschedule IPI will be not
sent to CPU2, which is idle, because NOHZ_BALANCE_KICK is already set
and no Idle Load Balance will be performed.

We must wait for the sched softirq to be raised on CPU 2 thanks to
another part of the kernel to clear NOHZ_BALANCE_KICKand come back to
a normal situation.

The proposed solution clears NOHZ_BALANCE_KICK in schedule_ipi if
we can't raise the sched_softirq for the Idle Load Balance.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..51fc715 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1420,7 +1420,8 @@ void scheduler_ipi(void)
 	if (unlikely(got_nohz_idle_kick() && !need_resched())) {
 		this_rq()->idle_balance = 1;
 		raise_softirq_irqoff(SCHED_SOFTIRQ);
-	}
+	} else
+		clear_bit(NOHZ_BALANCE_KICK, nohz_flags(smp_processor_id()));
 	irq_exit();
 }
 
-- 
1.7.9.5

