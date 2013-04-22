Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3DVTAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:55 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:53416 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3DVTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:00:14 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/10] nohz: Disable the tick when irq resume in full dynticks CPU
Date: Mon, 22 Apr 2013 20:59:46 +0200
Message-Id: <1366657186-20556-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eventually try to disable tick on irq exit, now that the
fundamental infrastructure is in place.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/softirq.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index de15813..8b1446d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -337,6 +337,19 @@ static inline void invoke_softirq(void)
 	}
 }
 
+static inline void tick_irq_exit(void)
+{
+#ifdef CONFIG_NO_HZ_COMMON
+	int cpu = smp_processor_id();
+
+	/* Make sure that timer wheel updates are propagated */
+	if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
+		if (!in_interrupt())
+			tick_nohz_irq_exit();
+	}
+#endif
+}
+
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
  */
@@ -348,11 +361,7 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-#ifdef CONFIG_NO_HZ_COMMON
-	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
-		tick_nohz_irq_exit();
-#endif
+	tick_irq_exit();
 	rcu_irq_exit();
 	sched_preempt_enable_no_resched();
 }
-- 
1.7.5.4

