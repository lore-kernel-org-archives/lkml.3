Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbaBFVNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:13:10 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46739 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbaBFVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:13:08 -0500
From: Carlo Caione <carlo@caione.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        hdegoede@redhat.com, tglx@linutronix.de, emilio@elopez.com.ar
Cc: Carlo Caione <carlo@caione.org>
Subject: [PATCH] irq: Add new flag to ack level-triggered interrupts before unmasking
Date: Thu,  6 Feb 2014 22:11:57 +0100
Message-Id: <1391721117-27446-1-git-send-email-carlo@caione.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several irqchip drivers require the level-triggered interrupt to be
acked before unmasking to avoid that a second interrupt is immediately
triggered. This small patch introduces a new irqchip flags that is used
to ack the IRQ line before it is unmasked.

Signed-off-by: Carlo Caione <carlo@caione.org>
---
 include/linux/irq.h    |  2 ++
 kernel/irq/chip.c      | 10 ++++++++++
 kernel/irq/internals.h |  1 +
 kernel/irq/manage.c    |  2 +-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..2cbe8d1 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -349,6 +349,7 @@ struct irq_chip {
  * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
  *				when irq enabled
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
+ * IRQCHIP_ACK_ON_UNMASK:	Ack level interrupts right before unmask
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -357,6 +358,7 @@ enum {
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
+	IRQCHIP_ACK_ON_UNMASK		= (1 <<  6),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..9d2d2e2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -265,6 +265,16 @@ static inline void mask_ack_irq(struct irq_desc *desc)
 	irq_state_set_masked(desc);
 }
 
+void ack_unmask_irq(struct irq_desc *desc)
+{
+	if ((desc->irq_data.chip->flags & IRQCHIP_ACK_ON_UNMASK) &&
+	    (irqd_get_trigger_type(&desc->irq_data) & IRQ_TYPE_LEVEL_MASK) &&
+	    desc->irq_data.chip->irq_ack)
+			desc->irq_data.chip->irq_ack(&desc->irq_data);
+
+	unmask_irq(desc);
+}
+
 void mask_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_mask) {
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..06ff850 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -73,6 +73,7 @@ extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
 extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
+extern void ack_unmask_irq(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..39505d8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -718,7 +718,7 @@ again:
 
 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data))
-		unmask_irq(desc);
+		ack_unmask_irq(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
-- 
1.8.5.3

