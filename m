Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaCCTvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:51:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35096 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaCCTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:51:51 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 1/5] genirq: define flag IRQ_SRC_DST_INVERTED, and accessors
Date: Mon,  3 Mar 2014 12:51:36 -0700
Message-Id: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Some devices have configurable IRQ output polarities. Software might
use IRQ_TYPE_* to determine how to configure such a device's IRQ
output polarity in order to match how the IRQ controller input is
configured. If the board or SoC inverts the signal between the
device's IRQ output and controller's IRQ output, software must be
aware of this fact, in order to program the IRQ output to the correct
(i.e. opposite) polarity. This flag provides that information.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3: New patch.
---
 include/linux/irq.h    | 12 ++++++++++++
 kernel/irq/chip.c      | 24 ++++++++++++++++++++++++
 kernel/irq/irqdomain.c |  4 ++++
 3 files changed, 40 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc10036eff5..535f3937e99e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -73,6 +73,11 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_IS_POLLED		- Always polled by another interrupt. Exclude
  *				  it from the spurious interrupt detection
  *				  mechanism and from core side polling.
+ * IRQ_SRC_DST_INVERTED		- An inverter exists between the source's IRQ
+ *				  output, and the IRQ controller's input.
+ *				  For devices with programmable output polarity
+ *				  this helps the driver match the device output
+ *				  to the controller's input polarity.
  */
 enum {
 	IRQ_TYPE_NONE		= 0x00000000,
@@ -98,6 +103,7 @@ enum {
 	IRQ_NOTHREAD		= (1 << 16),
 	IRQ_PER_CPU_DEVID	= (1 << 17),
 	IRQ_IS_POLLED		= (1 << 18),
+	IRQ_SRC_DST_INVERTED	= (1 << 19),
 };
 
 #define IRQF_MODIFY_MASK	\
@@ -218,6 +224,11 @@ static inline u32 irqd_get_trigger_type(struct irq_data *d)
 	return d->state_use_accessors & IRQD_TRIGGER_MASK;
 }
 
+static inline u32 irqd_get_src_dst_inverted(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQ_SRC_DST_INVERTED;
+}
+
 /*
  * Must only be called inside irq_chip.irq_set_type() functions.
  */
@@ -538,6 +549,7 @@ extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
+extern int irq_set_src_dst_inverted(unsigned int irq, unsigned int inverted);
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
 				struct msi_desc *entry);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c166c54d..ff9e13fa1170 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -70,6 +70,30 @@ int irq_set_irq_type(unsigned int irq, unsigned int type)
 EXPORT_SYMBOL(irq_set_irq_type);
 
 /**
+ *	irq_set_src_dst_inverted(unsigned int irq, u32 inverted)
+ *	@irq:		irq number
+ *	@inverted:	IRQ_SRC_DST_INVERTED value - see include/linux/irq.h
+ */
+int irq_set_src_dst_inverted(unsigned int irq, unsigned int inverted)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	int ret = 0;
+
+	if (!desc)
+		return -EINVAL;
+
+	inverted &= IRQ_SRC_DST_INVERTED;
+	if (inverted)
+		irqd_set(&desc->irq_data, inverted);
+	else
+		irqd_clear(&desc->irq_data, inverted);
+	irq_put_desc_busunlock(desc, flags);
+	return ret;
+}
+EXPORT_SYMBOL(irq_set_src_dst_inverted);
+
+/**
  *	irq_set_handler_data - set irq handler data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to interrupt specific data
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index f14033700c25..f9cee747424e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -471,6 +471,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
+	unsigned int inverted = 0;
 	unsigned int virq;
 
 	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
@@ -487,6 +488,8 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 		if (domain->ops->xlate(domain, irq_data->np, irq_data->args,
 					irq_data->args_count, &hwirq, &type))
 			return 0;
+		inverted = type & IRQ_SRC_DST_INVERTED;
+		type &= IRQ_TYPE_SENSE_MASK;
 	}
 
 	/* Create mapping */
@@ -498,6 +501,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 	if (type != IRQ_TYPE_NONE &&
 	    type != irq_get_trigger_type(virq))
 		irq_set_irq_type(virq, type);
+	irq_set_src_dst_inverted(virq, inverted);
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-- 
1.8.1.5

