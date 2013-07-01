Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3GAQEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:04:55 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10426 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3GAQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:04:52 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, James Hogan <james.hogan@imgtec.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/5] metag: smp: enable irqs after set_cpu_online
Date: Mon, 1 Jul 2013 17:04:16 +0100
Message-ID: <1372694659-30176-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_01_17_04_49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In secondary_start_kernel() interrupts should be enabled with
local_irq_enable() after the cpu is marked as online with
set_cpu_online(). Otherwise it's possible for a timer interrupt to
trigger a softirq, which if the cpu is marked as offline may have it's
affinity altered.

Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/metag/kernel/smp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index b813515..09979f2 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -379,12 +379,7 @@ asmlinkage void secondary_start_kernel(void)
 
 	setup_priv();
 
-	/*
-	 * Enable local interrupts.
-	 */
-	tbi_startup_interrupt(TBID_SIGNUM_TRT);
 	notify_cpu_starting(cpu);
-	local_irq_enable();
 
 	pr_info("CPU%u (thread %u): Booted secondary processor\n",
 		cpu, cpu_2_hwthread_id[cpu]);
@@ -398,6 +393,12 @@ asmlinkage void secondary_start_kernel(void)
 	set_cpu_online(cpu, true);
 
 	/*
+	 * Enable local interrupts.
+	 */
+	tbi_startup_interrupt(TBID_SIGNUM_TRT);
+	local_irq_enable();
+
+	/*
 	 * OK, it's off to the idle thread for us
 	 */
 	cpu_startup_entry(CPUHP_ONLINE);
-- 
1.8.1.2


