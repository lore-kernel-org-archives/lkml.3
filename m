Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbbANOpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:45:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33918 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbANOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:45:36 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] genirq: Abstract access to irq_chip flags
Date: Wed, 14 Jan 2015 14:45:16 +0000
Message-Id: <1421246717-11640-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com>
References: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to safely migrate to a cumulative set of flags, start by
abstracting the way we look at these flags. There is otherwise no
change in semantics here.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqdesc.h |  5 +++++
 kernel/irq/chip.c       | 10 +++++-----
 kernel/irq/manage.c     |  8 ++++----
 kernel/irq/pm.c         |  2 +-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index faf433a..32d9fff 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -107,6 +107,11 @@ static inline void *irq_desc_get_chip_data(struct irq_desc *desc)
 	return desc->irq_data.chip_data;
 }
 
+static inline unsigned long irq_desc_get_chip_flags(struct irq_desc *desc)
+{
+	return desc->irq_data.chip->flags;
+}
+
 static inline void *irq_desc_get_handler_data(struct irq_desc *desc)
 {
 	return desc->irq_data.handler_data;
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6f1c7a5..d8ffb36 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -287,7 +287,7 @@ void unmask_threaded_irq(struct irq_desc *desc)
 {
 	struct irq_chip *chip = desc->irq_data.chip;
 
-	if (chip->flags & IRQCHIP_EOI_THREADED)
+	if (irq_desc_get_chip_flags(desc) & IRQCHIP_EOI_THREADED)
 		chip->irq_eoi(&desc->irq_data);
 
 	if (chip->irq_unmask) {
@@ -489,7 +489,7 @@ static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
 	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
 		chip->irq_eoi(&desc->irq_data);
 		unmask_irq(desc);
-	} else if (!(chip->flags & IRQCHIP_EOI_THREADED)) {
+	} else if (!(irq_desc_get_chip_flags(desc) & IRQCHIP_EOI_THREADED)) {
 		chip->irq_eoi(&desc->irq_data);
 	}
 }
@@ -538,7 +538,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_unlock(&desc->lock);
 	return;
 out:
-	if (!(chip->flags & IRQCHIP_EOI_IF_HANDLED))
+	if (!(irq_desc_get_chip_flags(desc) & IRQCHIP_EOI_IF_HANDLED))
 		chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
@@ -836,7 +836,7 @@ void irq_cpu_online(void)
 
 		chip = irq_data_get_irq_chip(&desc->irq_data);
 		if (chip && chip->irq_cpu_online &&
-		    (!(chip->flags & IRQCHIP_ONOFFLINE_ENABLED) ||
+		    (!(irq_desc_get_chip_flags(desc) & IRQCHIP_ONOFFLINE_ENABLED) ||
 		     !irqd_irq_disabled(&desc->irq_data)))
 			chip->irq_cpu_online(&desc->irq_data);
 
@@ -866,7 +866,7 @@ void irq_cpu_offline(void)
 
 		chip = irq_data_get_irq_chip(&desc->irq_data);
 		if (chip && chip->irq_cpu_offline &&
-		    (!(chip->flags & IRQCHIP_ONOFFLINE_ENABLED) ||
+		    (!(irq_desc_get_chip_flags(desc) & IRQCHIP_ONOFFLINE_ENABLED) ||
 		     !irqd_irq_disabled(&desc->irq_data)))
 			chip->irq_cpu_offline(&desc->irq_data);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8069237..be7ce78 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -491,7 +491,7 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
-	if (irq_desc_get_chip(desc)->flags &  IRQCHIP_SKIP_SET_WAKE)
+	if (irq_desc_get_chip_flags(desc) &  IRQCHIP_SKIP_SET_WAKE)
 		return 0;
 
 	if (desc->irq_data.chip->irq_set_wake)
@@ -589,7 +589,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 
 	flags &= IRQ_TYPE_SENSE_MASK;
 
-	if (chip->flags & IRQCHIP_SET_TYPE_MASKED) {
+	if (irq_desc_get_chip_flags(desc) & IRQCHIP_SET_TYPE_MASKED) {
 		if (!irqd_irq_masked(&desc->irq_data))
 			mask_irq(desc);
 		if (!irqd_irq_disabled(&desc->irq_data))
@@ -1043,7 +1043,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 * chip flags, so we can avoid the unmask dance at the end of
 	 * the threaded handler for those.
 	 */
-	if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)
+	if (irq_desc_get_chip_flags(desc) & IRQCHIP_ONESHOT_SAFE)
 		new->flags &= ~IRQF_ONESHOT;
 
 	/*
@@ -1121,7 +1121,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		new->thread_mask = 1 << ffz(thread_mask);
 
 	} else if (new->handler == irq_default_primary_handler &&
-		   !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
+		   !(irq_desc_get_chip_flags(desc) & IRQCHIP_ONESHOT_SAFE)) {
 		/*
 		 * The interrupt was requested with handler = NULL, so
 		 * we use the default primary handler for it. But it
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 3ca5325..8ed029d 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -88,7 +88,7 @@ static bool suspend_device_irq(struct irq_desc *desc, int irq)
 	 * chip level. The chip implementation indicates that with
 	 * IRQCHIP_MASK_ON_SUSPEND.
 	 */
-	if (irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
+	if (irq_desc_get_chip_flags(desc) & IRQCHIP_MASK_ON_SUSPEND)
 		mask_irq(desc);
 	return true;
 }
-- 
2.1.4

