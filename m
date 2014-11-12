Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaKLNpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:45:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:41663 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaKLNnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:04 -0500
Message-Id: <20141112134120.474411359@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rfc-part4-v1-06-17-genirq-introduce-callback-irq_chip-irq_write_msi_msg.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Introduce callback irq_chip.irq_write_msi_msg, so we can share common
code among MSI alike interrupt controllers, such as HPET and DMAR.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -322,6 +322,7 @@ static inline irq_hw_number_t irqd_to_hw
  * @irq_release_resources:	optional to release resources acquired with
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
+ * @irq_write_msi_msg:	optional to write message content for MSI
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -359,6 +360,7 @@ struct irq_chip {
 	void		(*irq_release_resources)(struct irq_data *data);
 
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
+	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
 	unsigned long	flags;
 };
@@ -453,6 +455,12 @@ extern void irq_chip_ack_parent(struct i
 extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
 #endif
 
+static inline void irq_chip_write_msi_msg(struct irq_data *data,
+					  struct msi_msg *msg)
+{
+	data->chip->irq_write_msi_msg(data, msg);
+}
+
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);


