Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaLCQSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:18:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44165 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaLCQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:18:36 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Bjorn Andersson <bjorn@kryo.se>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
Date: Wed,  3 Dec 2014 16:18:21 +0000
Message-Id: <1417623503-30261-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
References: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a number of cases where a kernel subsystem may want to
introspect the state of an interrupt at the irqchip level:

- When a peripheral is shared between virtual machines,
  its interrupt state becomes part of the guest's state,
  and must be switched accordingly. KVM on arm/arm64 requires
  this for its guest-visible timer
- Some GPIO controllers seem to require peeking into the
  interrupt controller they are connected to to report
  their internal state

This seem to be a pattern that is common enough for the core code
to try and support this without too many horrible hacks. Introduce
a pair of accessors (irq_get_irqchip_state/irq_set_irqchip_state)
to retrieve the bits that can be of interest to another subsystem:
pending, active, and masked.

- irq_get_irqchip_state returns the state of the interrupt according
  to a parameter set to IRQCHIP_STATE_PENDING, IRQCHIP_STATE_ACTIVE,
  IRQCHIP_STATE_MASKED or IRQCHIP_STATE_LINE_LEVEL.
- irq_set_irqchip_state similarly sets the state of the interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/interrupt.h | 14 ++++++++
 include/linux/irq.h       |  6 ++++
 kernel/irq/manage.c       | 91 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 69517a2..cbbe6a2 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -356,6 +356,20 @@ static inline int disable_irq_wake(unsigned int irq)
 	return irq_set_irq_wake(irq, 0);
 }
 
+/*
+ * irq_get_irqchip_state/irq_set_irqchip_state specific flags
+ */
+enum irqchip_irq_state {
+	IRQCHIP_STATE_PENDING,		/* Is interrupt pending? */
+	IRQCHIP_STATE_ACTIVE,		/* Is interrupt in progress? */
+	IRQCHIP_STATE_MASKED,		/* Is interrupt masked? */
+	IRQCHIP_STATE_LINE_LEVEL,	/* Is IRQ line high? */
+};
+
+extern int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
+				 bool *state);
+extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
+				 bool state);
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 extern bool force_irqthreads;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8badf34..1922539 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -29,6 +29,7 @@
 struct seq_file;
 struct module;
 struct msi_msg;
+enum irqchip_irq_state;
 
 /*
  * IRQ line status.
@@ -323,6 +324,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_get_irqchip_state:	return the internal state of an interrupt
+ * @irq_set_irqchip_state:	set the internal state of a interrupt
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -362,6 +365,9 @@ struct irq_chip {
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
+	int		(*irq_get_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool *state);
+	int		(*irq_set_irqchip_state)(struct irq_data *data, enum irqchip_irq_state which, bool state);
+
 	unsigned long	flags;
 };
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8069237..06840ba 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1758,3 +1758,94 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 
 	return retval;
 }
+
+/**
+ *	irq_get_irqchip_state - returns the irqchip state of a interrupt.
+ *	@irq: Interrupt line that is forwarded to a VM
+ *	@which: One of IRQCHIP_STATE_* the caller wants to know about
+ *	@state: a pointer to a boolean where the state is to be storeed
+ *
+ *	This call snapshots the internal irqchip state of an
+ *	interrupt, returning into @state the bit corresponding to
+ *	stage @which
+ *
+ *	This function should be called with preemption disabled if the
+ *	interrupt controller has per-cpu registers.
+ */
+int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
+			  bool *state)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+	unsigned long flags;
+	int err = -EINVAL;
+
+	desc = irq_get_desc_buslock(irq, &flags, 0);
+	if (!desc)
+		return err;
+
+	data = irq_desc_get_irq_data(desc);
+
+	do {
+		chip = irq_data_get_irq_chip(data);
+		if (chip->irq_get_irqchip_state)
+			break;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		data = data->parent_data;
+#else
+		data = NULL;
+#endif
+	} while (data);
+
+	if (data)
+		err = chip->irq_get_irqchip_state(data, which, state);
+
+	irq_put_desc_busunlock(desc, flags);
+	return err;
+}
+
+/**
+ *	irq_set_irqchip_state - set the state of a forwarded interrupt.
+ *	@irq: Interrupt line that is forwarded to a VM
+ *	@which: State to be restored (one of IRQCHIP_STATE_*)
+ *	@val: Value corresponding to @which
+ *
+ *	This call sets the internal irqchip state of an interrupt,
+ *	depending on the value of @which.
+ *
+ *	This function should be called with preemption disabled if the
+ *	interrupt controller has per-cpu registers.
+ */
+int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
+			  bool val)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+	unsigned long flags;
+	int err = -EINVAL;
+
+	desc = irq_get_desc_buslock(irq, &flags, 0);
+	if (!desc)
+		return err;
+
+	data = irq_desc_get_irq_data(desc);
+
+	do {
+		chip = irq_data_get_irq_chip(data);
+		if (chip->irq_set_irqchip_state)
+			break;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		data = data->parent_data;
+#else
+		data = NULL;
+#endif
+	} while (data);
+
+	if (data)
+		chip->irq_set_irqchip_state(data, which, val);
+
+	irq_put_desc_busunlock(desc, flags);
+	return err;
+}
-- 
2.1.3

