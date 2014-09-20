Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaITUa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 16:30:59 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:48261 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbaITUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 16:30:38 -0400
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
Subject: [PATCH 5/8] arm: Tell irq work about self IPI support
Date: Sat, 20 Sep 2014 22:30:21 +0200
Message-Id: <1411245024-10339-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411245024-10339-1-git-send-email-fweisbec@gmail.com>
References: <1411245024-10339-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM irq work IPI support depends on SMP support. That information is
partly known at early boottime. Lets implement
arch_irq_work_has_interrupt() accordingly.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/arm/include/asm/Kbuild     |  1 -
 arch/arm/include/asm/irq_work.h | 11 +++++++++++
 arch/arm/kernel/smp.c           |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/asm/irq_work.h

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 202905e..70cd84e 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -11,7 +11,6 @@ generic-y += hash.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
-generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
new file mode 100644
index 0000000..712d03e
--- /dev/null
+++ b/arch/arm/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_ARM_IRQ_WORK_H
+#define __ASM_ARM_IRQ_WORK_H
+
+#include <asm/smp_plat.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return is_smp();
+}
+
+#endif /* _ASM_ARM_IRQ_WORK_H */
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9388a3d..bbe22fc 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -503,7 +503,7 @@ void arch_send_call_function_single_ipi(int cpu)
 #ifdef CONFIG_IRQ_WORK
 void arch_irq_work_raise(void)
 {
-	if (is_smp())
+	if (arch_irq_work_has_interrupt())
 		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
 }
 #endif
-- 
2.1.0

