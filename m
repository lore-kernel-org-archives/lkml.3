Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaIJVdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:33:53 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55846 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaIJVdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:33:43 -0400
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
Subject: [PATCH 6/8] arm64: Tell irq work about self IPI support
Date: Wed, 10 Sep 2014 23:33:26 +0200
Message-Id: <1410384808-14760-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM64 irq work self-IPI support depends on __smp_cross_call to point to
some relevant IRQ controller operations. This information should be
available after the call to init_IRQ().

Lets implement arch_irq_work_has_interrupt() accordingly.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/arm64/include/asm/Kbuild     |  1 -
 arch/arm64/include/asm/irq_work.h | 11 +++++++++++
 arch/arm64/include/asm/smp.h      |  2 ++
 arch/arm64/kernel/smp.c           |  2 +-
 4 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/irq_work.h

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index d617789..c196847 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -19,7 +19,6 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
-generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
new file mode 100644
index 0000000..8e24ef3
--- /dev/null
+++ b/arch/arm64/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_IRQ_WORK_H
+#define __ASM_IRQ_WORK_H
+
+#include <asm/smp.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return !!__smp_cross_call;
+}
+
+#endif /* __ASM_IRQ_WORK_H */
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index a498f2c..780f82c 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -48,6 +48,8 @@ extern void smp_init_cpus(void);
  */
 extern void set_smp_cross_call(void (*)(const struct cpumask *, unsigned int));
 
+extern void (*__smp_cross_call)(const struct cpumask *, unsigned int);
+
 /*
  * Called from the secondary holding pen, this is the secondary CPU entry point.
  */
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 4743397..b06d1d9 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -470,7 +470,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-static void (*__smp_cross_call)(const struct cpumask *, unsigned int);
+void (*__smp_cross_call)(const struct cpumask *, unsigned int);
 
 void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 {
-- 
2.1.0

