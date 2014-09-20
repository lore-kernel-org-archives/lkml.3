Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaITUa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 16:30:56 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62538 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942AbaITUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 16:30:37 -0400
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
Subject: [PATCH 4/8] x86: Tell irq work about self IPI support
Date: Sat, 20 Sep 2014 22:30:20 +0200
Message-Id: <1411245024-10339-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411245024-10339-1-git-send-email-fweisbec@gmail.com>
References: <1411245024-10339-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 supports irq work self-IPIs when local apic is available. This is
partly known on runtime so lets implement arch_irq_work_has_interrupt()
accordingly.

This should be safely called after setup_arch().

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/Kbuild     |  1 -
 arch/x86/include/asm/irq_work.h | 11 +++++++++++
 arch/x86/kernel/irq_work.c      |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/irq_work.h

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 8fa909c..3bf000f 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -7,6 +7,5 @@ genhdr-y += unistd_x32.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += early_ioremap.h
-generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += scatterlist.h
diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
new file mode 100644
index 0000000..78162f8
--- /dev/null
+++ b/arch/x86/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_IRQ_WORK_H
+#define _ASM_IRQ_WORK_H
+
+#include <asm/processor.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return cpu_has_apic;
+}
+
+#endif /* _ASM_IRQ_WORK_H */
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 1de84e3..15d741d 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -41,7 +41,7 @@ __visible void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 void arch_irq_work_raise(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (!cpu_has_apic)
+	if (!arch_irq_work_has_interrupt())
 		return;
 
 	apic->send_IPI_self(IRQ_WORK_VECTOR);
-- 
2.1.0

