Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaJYVwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:52:12 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:48459 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbaJYVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:51:11 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
Date: Sat, 25 Oct 2014 11:14:55 +0100
Message-Id: <1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: adharmap@codeaurora.org, pvo@apm.com, linus.walleij@linaro.org, tnhuynh@apm.com, yvo@apm.com, tglx@linutronix.de, toanle@apm.com, bjorn@kryo.se, arnd@arndb.de, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a number of cases where a kernel subsystem may want to
introspect the state of an interrupt at the irqchip level:

- When a peripheral is shared between virtual machines, its interrupt
  state becomes part of the guest's state, and must be switched accordingly.
  KVM on arm/arm64 requires this for its guest-visible timer
- Some GPIO controllers seem to require peeking into the interrupt controller
  they are connected to to report their internal state

This seem to be a pattern that is common enough for the core code to try and
support this without too many horrible hacks. Introduce a pair of accessors
(irq_get_irqchip_state/irq_set_irqchip_state) to retrieve the bits that can
be of interest to another subsystem: pending, active, and masked.

- irq_get_irqchip_state returns the state of the interrupt according to a
  state parameter set to IRQCHIP_STATE_PENDING, IRQCHIP_STATE_ACTIVE
  or IRQCHIP_STATE_MASKED.
- irq_set_irqchip_state sets the state of the interrupt according to
  a similar state.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/interrupt.h |  2 ++
 include/linux/irq.h       | 18 ++++++++++++
 kernel/irq/manage.c       | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 69517a2..80818b4 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -356,6 +356,8 @@ static inline int disable_irq_wake(unsigned int irq)
 	return irq_set_irq_wake(irq, 0);
 }
 
+extern int irq_get_irqchip_state(unsigned int irq, int state);
+extern int irq_set_irqchip_state(unsigned int irq, int state, int val);
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 extern bool force_irqthreads;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 03f48d9..257d59a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -315,6 +315,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				any other callback related to this irq
  * @irq_release_resources:	optional to release resources acquired with
  *				irq_request_resources
+ * @irq_get_irqchip_state:	return the internal state of an interrupt
+ * @irq_set_irqchip_state:	set the internal state of a interrupt
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -351,6 +353,9 @@ struct irq_chip {
 	int		(*irq_request_resources)(struct irq_data *data);
 	void		(*irq_release_resources)(struct irq_data *data);
 
+	int		(*irq_get_irqchip_state)(struct irq_data *data, int state);
+	void		(*irq_set_irqchip_state)(struct irq_data *data, int state, int val);
+
 	unsigned long	flags;
 };
 
@@ -376,6 +381,19 @@ enum {
 	IRQCHIP_EOI_THREADED		= (1 <<  6),
 };
 
+/*
+ * irq_get_irqchip_state/irq_set_irqchip_state specific flags:
+ *
+ * IRQCHIP_STATE_PENDING:	Interrupt asserted at the pin level
+ * IRQCHIP_STATE_ACTIVE:	Interrupt in progress (ACKed, but not EOIed)
+ * IRQCHIP_STATE_MASKED:	Interrupt is masked
+ */
+enum {
+	IRQCHIP_STATE_PENDING,
+	IRQCHIP_STATE_ACTIVE,
+	IRQCHIP_STATE_MASKED,
+};
+
 /* This include will go away once we isolated irq_desc usage to core code */
 #include <linux/irqdesc.h>
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b..6a4c03f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1756,3 +1756,74 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 
 	return retval;
 }
+
+/**
+ *	irq_get_irqchip_state - returns the irqchip state of a interrupt.
+ *	@irq: Interrupt line that is forwarded to a VM
+ *	@state: One of IRQCHIP_STATE_* the caller wants to know about
+ *
+ *	This call snapshots the internal irqchip state of an
+ *	interrupt, returning the bit corresponding to the requested
+ *	@state.
+ *
+ *	This function should be called with preemption disabled if the
+ *	interrupt controller has per-cpu registers.
+ */
+int irq_get_irqchip_state(unsigned int irq, int state)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+	int val;
+
+	desc = irq_to_desc(irq);
+	if (!desc)
+		return -EINVAL;
+
+	data = irq_desc_get_irq_data(desc);
+
+	chip = irq_desc_get_chip(desc);
+	if (!chip->irq_get_irqchip_state)
+		return -EINVAL;
+
+	chip_bus_lock(desc);
+	val = chip->irq_get_irqchip_state(data, state);
+	chip_bus_sync_unlock(desc);
+
+	return val;
+}
+
+/**
+ *	irq_set_irqchip_state - set the state of a forwarded interrupt.
+ *	@irq: Interrupt line that is forwarded to a VM
+ *	@state: State to be restored (one of IRQCHIP_STATE_*)
+ *	@val: value corresponding to @state
+ *
+ *	This call sets the internal irqchip state of an interrupt,
+ *	depending on the value of @state.
+ *
+ *	This function should be called with preemption disabled if the
+ *	interrupt controller has per-cpu registers.
+ */
+int irq_set_irqchip_state(unsigned int irq, int state, int val)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+
+	desc = irq_to_desc(irq);
+	if (!desc)
+		return -EINVAL;
+
+	data = irq_desc_get_irq_data(desc);
+
+	chip = irq_desc_get_chip(desc);
+	if (!chip->irq_set_irqchip_state)
+		return -EINVAL;
+
+	chip_bus_lock(desc);
+	chip->irq_set_irqchip_state(data, state, val);
+	chip_bus_sync_unlock(desc);
+
+	return 0;
+}
-- 
2.1.0

