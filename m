Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaIJVdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:33:49 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35311 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaIJVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:33:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 8/8] nohz: nohz full depends on irq work self IPI support
Date: Wed, 10 Sep 2014 23:33:28 +0200
Message-Id: <1410384808-14760-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nohz full functionality depends on IRQ work to trigger its own
interrupts. As it's used to restart the tick, we can't rely on the tick
fallback for irq work callbacks, ie: we can't use the tick to restart
the tick itself.

Lets reject the full dynticks initialization if that arch support isn't
available.

As a side effect, this makes sure that nohz kick is never called from
the tick. That otherwise would result in illegal hrtimer self-cancellation
and lockup.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 45cdfbb..d0f0785 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -351,6 +351,20 @@ void __init tick_nohz_init(void)
 		return;
 	}
 
+	/*
+	 * Full dynticks uses irq work to drive the tick rescheduling on safe
+	 * locking contexts. But then we need irq work to raise its own
+	 * interrupts to avoid circular dependency on the tick
+	 */
+	if (!arch_irq_work_has_interrupt()) {
+		pr_warning("NO_HZ: Can't run full dynticks because arch doesn't "
+			   "support irq work self-IPIs\n");
+		cpumask_clear(tick_nohz_full_mask);
+		cpumask_copy(housekeeping_mask, cpu_possible_mask);
+		tick_nohz_full_running = false;
+		return;
+	}
+
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-- 
2.1.0

