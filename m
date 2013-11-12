Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3KLTHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:07:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:7247 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3KLTHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,686,1378882800"; 
   d="scan'208";a="426387429"
From: Fei Yang <fei.yang@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Fei Yang <fei.yang@linux.intel.com>,
        Sundar Iyer <sundar.iyer@intel.com>, Fei Yang <fei.yang@intel.com>
Subject: [RFC/PATCH] x86/irq: handle chained interrupts during IRQ migration
Date: Tue, 12 Nov 2013 11:00:59 -0800
Message-Id: <1384282860-56571-1-git-send-email-fei.yang@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chained interrupt handlers dont have an irqaction and hence are not
handled during migrating interrupts when some cores go offline.

Handle this by introducing a irq_is_chained() check which is based
on the the CHAINED flag being set for such interrupts. fixup_irq()
can then handle such interrupts and not skip them over.

Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
Signed-off-by: Fei Yang <fei.yang@linux.intel.com>
Cc: Fei Yang <fei.yang@intel.com>
---
Issue was found with GPIO interrupts whose handlers are registered as
chained handler, see drivers/gpio/gpio-langwell.c for details. These
interrupts stop coming after offlining a few cpus, and never come back
even after put the cpus back online. This patch had been integrated in
the kernel for Intel's Android software platform, and proved to solve
the issue.

 arch/x86/kernel/irq.c   |    4 +++-
 include/linux/irq.h     |    1 +
 include/linux/irqdesc.h |    7 +++++++
 kernel/irq/chip.c       |    1 +
 kernel/irq/settings.h   |    7 +++++++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 22d0687..3790ef5 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -286,7 +286,9 @@ void fixup_irqs(void)
 
 		data = irq_desc_get_irq_data(desc);
 		affinity = data->affinity;
-		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
+		/* include IRQs who have no action, but are chained */
+		if ((!irq_has_action(irq) && !irq_is_chained(irq)) ||
+			irqd_is_per_cpu(data) ||
 		    cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 56bb0dc..9fef6ee 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -94,6 +94,7 @@ enum {
 	IRQ_NESTED_THREAD	= (1 << 15),
 	IRQ_NOTHREAD		= (1 << 16),
 	IRQ_PER_CPU_DEVID	= (1 << 17),
+	IRQ_CHAINED		= (1 << 18),
 };
 
 #define IRQF_MODIFY_MASK	\
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 56fb646..74d2b5e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -121,6 +121,13 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
+/* Test to see if the IRQ is chained */
+static inline int irq_is_chained(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return desc->status_use_accessors & IRQ_CHAINED;
+}
+
 /* caller has locked the irq_desc and both params are valid */
 static inline void __irq_set_handler_locked(unsigned int irq,
 					    irq_flow_handler_t handler)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a3bb14f..d0c4e4a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -685,6 +685,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
+		irq_settings_set_chained(desc);
 		irq_startup(desc, true);
 	}
 out:
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index 1162f10..4ea2f96 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -15,6 +15,7 @@ enum {
 	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
 	_IRQ_PER_CPU_DEVID	= IRQ_PER_CPU_DEVID,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
+	_IRQ_CHAINED		= IRQ_CHAINED,
 };
 
 #define IRQ_PER_CPU		GOT_YOU_MORON
@@ -28,6 +29,7 @@ enum {
 #define IRQ_PER_CPU_DEVID	GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
+#define IRQ_CHAINED		GOT_YOU_MORON
 
 static inline void
 irq_settings_clr_and_set(struct irq_desc *desc, u32 clr, u32 set)
@@ -147,3 +149,8 @@ static inline bool irq_settings_is_nested_thread(struct irq_desc *desc)
 {
 	return desc->status_use_accessors & _IRQ_NESTED_THREAD;
 }
+
+static inline bool irq_settings_set_chained(struct irq_desc *desc)
+{
+	return desc->status_use_accessors |= _IRQ_CHAINED;
+}
-- 
1.7.9.5

