Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaK2QOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:14:00 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42385 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2QN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:13:59 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH urgent v2] sched: Add missing rcu protection to wake_up_all_idle_cpus
Date: Sat, 29 Nov 2014 08:13:51 -0800
Message-Id: <729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locklessly doing is_idle_task(rq->curr) is only okay because of RCU
protection.  The older variant of the broken code checked
rq->curr == rq->idle instead and therefore didn't need RCU.

Fixes: f6be8af1c95d sched: Add new API wake_up_if_idle() to wake up the idle cpu
Cc: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This fixes a 3.18 regression, I think.  This code seems to only be called
inside preempt_disable, so I think it's unlikely to be a problem in practice.

Compile-tested only, although the kbuild bot is chewing on it.

Changes from v1:
 - Cc the right people (whoops)
 - Add rcu_read_lock and rcu_read_unlock.

 kernel/sched/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c13ddc..b7937512965f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1623,8 +1623,10 @@ void wake_up_if_idle(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!is_idle_task(rq->curr))
-		return;
+	rcu_read_lock();
+
+	if (!is_idle_task(rcu_dereference(rq->curr)))
+		goto out;
 
 	if (set_nr_if_polling(rq->idle)) {
 		trace_sched_wake_idle_without_ipi(cpu);
@@ -1635,6 +1637,9 @@ void wake_up_if_idle(int cpu)
 		/* Else cpu is not in idle, do nothing here */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
-- 
1.9.3

