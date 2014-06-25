Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaFYJ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:28:58 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51339 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752091AbaFYJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:28:55 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 2/9] genirq: Allow the state of a  forwarded irq to be save/restored
Date: Wed, 25 Jun 2014 10:28:43 +0100
Message-Id: <1403688530-23273-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a peripheral is shared between virtual machines, its interrupt
state becomes part of the guest's state, and must be switched accordingly.

Introduce a pair of accessors (irq_get_fwd_state/irq_set_fwd_state) to
retrieve the bits that can be of interest to KVM: pending, active, and masked.

- irq_get_fwd_state returns the state of the interrupt according to a mask
containing any of the IRQ_STATE_PENDING, IRQ_STATE_ACTIVE or IRQ_STATE_MASKED
bits.
- irq_set_fwd_state sets the state of the interrupt according to a similar mask.

Only a forwarded interrupt can be manipulated in such a way.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/interrupt.h |  2 ++
 include/linux/irq.h       | 16 ++++++++++
 kernel/irq/manage.c       | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 698ad05..cfb8006 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -361,6 +361,8 @@ static inline int disable_irq_wake(unsigned int irq)
 	return irq_set_irq_wake(irq, 0);
 }
 
+extern int irq_get_fwd_state(unsigned int irq, u32 *val, u32 mask);
+extern int irq_set_fwd_state(unsigned int irq, u32 val, u32 mask);
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 extern bool force_irqthreads;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index b4b3120..88ecd58 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -323,6 +323,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				any other callback related to this irq
  * @irq_release_resources:	optional to release resources acquired with
  *				irq_request_resources
+ * @irq_get_fwd_state:	return the state of a forwarded interrupt
+ * @irq_set_fwd_state:	set the state of a forwarded interrupt
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -359,6 +361,9 @@ struct irq_chip {
 	int		(*irq_request_resources)(struct irq_data *data);
 	void		(*irq_release_resources)(struct irq_data *data);
 
+	u32		(*irq_get_fwd_state)(struct irq_data *data, u32 mask);
+	void		(*irq_set_fwd_state)(struct irq_data *data, u32 val, u32 mask);
+
 	unsigned long	flags;
 };
 
@@ -384,6 +389,17 @@ enum {
 	IRQCHIP_EOI_THREADED		= (1 <<  6),
 };
 
+/*
+ * irq_get_fwd_state/irq_set_fwd_state specific flags (used for both
+ * state and mask). Only valid for an interrupt that has the
+ * IRQD_IRQ_FORWARDED flag.
+ */
+enum {
+	IRQ_FWD_STATE_PENDING		= (1 << 0),
+	IRQ_FWD_STATE_ACTIVE		= (1 << 1),
+	IRQ_FWD_STATE_MASKED		= (1 << 2),
+};
+
 /* This include will go away once we isolated irq_desc usage to core code */
 #include <linux/irqdesc.h>
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3dc6a61..c42dd73 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1770,3 +1770,83 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 
 	return retval;
 }
+
+/**
+ *	irq_get_fwd_state - return the state of a forwarded interrupt.
+ *	@irq: Interrupt line that is forwarded to a VM
+ *	@val: Pointer where the state is being stored
+ *	@mask: Bitmask of IRQ_FWD_STATE_* the caller wants to know about
+ *
+ *	This call snapshots the state of a forwarded interrupt,
+ *	depending on the mask which indicates the requested bits.
+ *
+ *	This function should be called with preemption disabled if the
+ *	interrupt controller has per-cpu registers.
+ */
+int irq_get_fwd_state(unsigned int irq, u32 *val, u32 mask)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+	unsigned long flags;
+
+	desc = irq_to_desc(irq);
+	if (!desc)
+		return -EINVAL;
+
+	data = irq_desc_get_irq_data(desc);
+	if (!irqd_irq_forwarded(data))
+		return -EINVAL;
+
+	chip = irq_desc_get_chip(desc);
+	if (!chip->irq_get_fwd_state)
+		return -EINVAL;
+
+	chip_bus_lock(desc);
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	*val = chip->irq_get_fwd_state(data, mask);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(desc);
+
+	return 0;
+}
+
+/**
+ *	irq_set_fwd_state - set the state of a forwarded interrupt.
+ *	@irq: Interrupt line that is forwarded to a VM
+ *	@val: State to be restored
+ *	@mask: Bitmask of IRQ_FWD_STATE_* defining the valid bits in @val
+ *
+ *	This call sets the state of a forwarded interrupt, depending
+ *	on the mask which indicates the valid bits.
+ *
+ *	This function should be called with preemption disabled if the
+ *	interrupt controller has per-cpu registers.
+ */
+int irq_set_fwd_state(unsigned int irq, u32 val, u32 mask)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+	unsigned long flags;
+
+	desc = irq_to_desc(irq);
+	if (!desc)
+		return -EINVAL;
+
+	data = irq_desc_get_irq_data(desc);
+	if (!irqd_irq_forwarded(data))
+		return -EINVAL;
+
+	chip = irq_desc_get_chip(desc);
+	if (!chip->irq_set_fwd_state)
+		return -EINVAL;
+
+	chip_bus_lock(desc);
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	chip->irq_set_fwd_state(data, val, mask);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(desc);
+
+	return 0;
+}
-- 
1.8.3.4

