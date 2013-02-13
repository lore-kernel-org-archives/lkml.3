Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab3BMME5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:04:57 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55508 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759381Ab3BMMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:04:54 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 5/5] metag: move irq enable out of irqflags.h on SMP
Date: Wed, 13 Feb 2013 12:03:49 +0000
Message-ID: <1360757029-28868-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_12_04_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMP version of arch_local_irq_enable() uses preempt_disable(), but
<asm/irqflags.h> doesn't include <linux/preempt.h> causing the following
errors on SMP when pstore/ftrace is enabled (caught by buildbot smp
allyesconfig):

In file included from include/linux/irqflags.h:15,
                 from fs/pstore/ftrace.c:16:
arch/metag/include/asm/irqflags.h: In function 'arch_local_irq_enable':
arch/metag/include/asm/irqflags.h:84: error: implicit declaration of function 'preempt_disable'
arch/metag/include/asm/irqflags.h:86: error: implicit declaration of function 'preempt_enable_no_resched'

However <linux/preempt.h> cannot be easily included from
<asm/irqflags.h> as it can cause circular include dependencies in the
!SMP case, and potentially in the SMP case in the future. Therefore move
the SMP implementation of arch_local_irq_enable() into traps.c and use
an inline version of get_trigger_mask() which is also defined in traps.c
for SMP.

This adds an extra layer of function call / stack push when
preempt_disable needs to call other functions, however in the
non-preemptive SMP case it should be about as fast, as it was already
calling the get_trigger_mask() function which is now used inline.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/irqflags.h |   11 +++++------
 arch/metag/kernel/traps.c         |   15 ++++++++++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/metag/include/asm/irqflags.h b/arch/metag/include/asm/irqflags.h
index cba5e13..339b16f 100644
--- a/arch/metag/include/asm/irqflags.h
+++ b/arch/metag/include/asm/irqflags.h
@@ -78,16 +78,15 @@ static inline void arch_local_irq_disable(void)
 	asm volatile("MOV TXMASKI,%0\n" : : "r" (flags) : "memory");
 }
 
-static inline void arch_local_irq_enable(void)
-{
 #ifdef CONFIG_SMP
-	preempt_disable();
-	arch_local_irq_restore(get_trigger_mask());
-	preempt_enable_no_resched();
+/* Avoid circular include dependencies through <linux/preempt.h> */
+void arch_local_irq_enable(void);
 #else
+static inline void arch_local_irq_enable(void)
+{
 	arch_local_irq_restore(get_trigger_mask());
-#endif
 }
+#endif
 
 #endif /* (__ASSEMBLY__) */
 
diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index 2808042..3f7764b 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/preempt.h>
 #include <linux/ptrace.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -776,17 +777,29 @@ int traps_restore_context(void)
 #endif
 
 #ifdef CONFIG_SMP
-unsigned int get_trigger_mask(void)
+static inline unsigned int _get_trigger_mask(void)
 {
 	unsigned long cpu = smp_processor_id();
 	return per_cpu(trigger_mask, cpu);
 }
 
+unsigned int get_trigger_mask(void)
+{
+	return _get_trigger_mask();
+}
+
 static void set_trigger_mask(unsigned int mask)
 {
 	unsigned long cpu = smp_processor_id();
 	per_cpu(trigger_mask, cpu) = mask;
 }
+
+void arch_local_irq_enable(void)
+{
+	preempt_disable();
+	arch_local_irq_restore(_get_trigger_mask());
+	preempt_enable_no_resched();
+}
 #else
 static void set_trigger_mask(unsigned int mask)
 {
-- 
1.7.7.6


