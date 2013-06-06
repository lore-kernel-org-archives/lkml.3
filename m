Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab3FFLlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:41:20 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37727 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab3FFLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:41:18 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH] x86: fix trigger_all_cpu_backtrace() implementation
Date: Thu,  6 Jun 2013 04:41:15 -0700
Message-Id: <1370518875-1346-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following change fixes the x86 implementation of
trigger_all_cpu_backtrace(), which was previously (accidentally, as
far as I can tell) disabled to always return false as on architectures
that do not implement this function.

Is there any chance that we could get this in before v3.10 ?

---------------------------------8<---------------------------------

trigger_all_cpu_backtrace(), as defined in include/linux/nmi.h,
should call arch_trigger_all_cpu_backtrace() if available, or return
false if the underlying arch doesn't implement this function.

x86 did provide a suitable arch_trigger_all_cpu_backtrace() implementation,
but it wasn't actually being used because it was declared in asm/nmi.h,
which linux/nmi.h doesn't include. Also, linux/nmi.h couldn't easily
be fixed by including asm/nmi.h, because that file is not available on
all architectures.

I am proposing to fix this by moving the x86 definition of
arch_trigger_all_cpu_backtrace() to asm/irq.h.

Tested: echo l > /proc/sysrq-trigger

Before the change, this uses a fallback implementation which shows
backtraces on active CPUs (using smp_call_function_interrupt() )

After the change, this shows NMI backtraces on all CPUs

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/include/asm/irq.h    | 5 +++++
 arch/x86/include/asm/nmi.h    | 4 +---
 arch/x86/kernel/apic/hw_nmi.c | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb6dd8e..57873beb3292 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -41,4 +41,9 @@ extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+#endif
+
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c0fa356e90de..86f9301903c8 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -18,9 +18,7 @@ extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
 
-void arch_trigger_all_cpu_backtrace(void);
-#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
-#endif
+#endif /* CONFIG_X86_LOCAL_APIC */
 
 #define NMI_FLAG_FIRST	1
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 31cb9ae992b7..a698d7165c96 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -9,6 +9,7 @@
  *
  */
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
-- 
1.8.3
