Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaKLNm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:42:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:41607 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaKLNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:42:56 -0500
Message-Id: <20141112134120.057028621@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:42:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 03/16] genirq: Introduce helper functions to support stacked
 irq_chip
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=genirq-introduce-helper-functions-to-support-stacked-irq_chip.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Now we already support hierarchy irq_data, so introduce several helpers
to support stacked irq_chips.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    5 +++++
 kernel/irq/chip.c   |   17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 13ba412ce3a0..0adcbbbf2e87 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -443,6 +443,11 @@ extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+extern void irq_chip_ack_parent(struct irq_data *data);
+extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
+#endif
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 72a93086216b..12f3e72449eb 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -850,3 +850,20 @@ void irq_cpu_offline(void)
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+void irq_chip_ack_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_ack(data);
+}
+
+int irq_chip_retrigger_hierarchy(struct irq_data *data)
+{
+	for (data = data->parent_data; data; data = data->parent_data)
+		if (data->chip && data->chip->irq_retrigger)
+			return data->chip->irq_retrigger(data);
+
+	return -ENOSYS;
+}
+#endif
-- 
1.7.10.4





