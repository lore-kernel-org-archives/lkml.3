Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaG1Rhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:37:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64374 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaG1Rhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:37:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 03/10] rcu: Kick full dynticks CPU on extended grace period with kick_cpu_async()
Date: Mon, 28 Jul 2014 19:37:29 +0200
Message-Id: <1406569056-30217-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a full dynticks CPU stays for too long in the kernel, it may fail
to report quiescent states due to it missing ticks and therefore it can
delay the completion of grace periods.

A way to solve this is to send an IPI to the incriminated CPU such that
it can check rcu_needs_cpu() and reschedule some ticks accordingly to
poll again on quiescent states reports.

This is what we try to achieve while calling rcu_kick_nohz_cpu() but it
has no effect because we trigger a scheduler IPI which is actually a
no-op when not used for scheduler internal purpose, ie: it doesn't call
irq_exit() when not used for remote wakeup or other specifics.

No need to tweak the scheduler IPI further though. Lets keep it clean
of external noise and use an empty IPI instead. We hereby get sure that
we will call irq_exit() on the target without much overhead nor added
noise on scheduler fast path.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcu/tree_plugin.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbc2c45..551398b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2401,14 +2401,16 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
  * off.  RCU will be paying attention to this CPU because it is in the
  * kernel, but the CPU cannot be guaranteed to be executing the RCU state
  * machine because the scheduling-clock tick has been disabled.  Therefore,
- * if an adaptive-ticks CPU is failing to respond to the current grace
- * period and has not be idle from an RCU perspective, kick it.
+ * if a full dynticks CPU is failing to respond to the current grace
+ * period and has not been idle from an RCU perspective, kick it with a
+ * void IRQ so that it can check that RCU needs its tick from rcu_needs_cpu()
+ * on irq exit.
  */
 static void rcu_kick_nohz_cpu(int cpu)
 {
 #ifdef CONFIG_NO_HZ_FULL
 	if (tick_nohz_full_cpu(cpu))
-		smp_send_reschedule(cpu);
+		kick_cpu_async(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
 
-- 
1.8.3.1

