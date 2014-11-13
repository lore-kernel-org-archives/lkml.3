Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaKMPhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:37:34 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46353 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753973AbaKMPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:37:30 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>, <srv_heupstream@mediatek.com>,
        <yingjoe.chen@gmail.com>, <hc.yen@mediatek.com>,
        <eddie.huang@mediatek.com>, <nathan.chung@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH v6 2/6] genirq: Add more helper functions to support stacked irq_chip
Date: Thu, 13 Nov 2014 23:37:05 +0800
Message-ID: <1415893029-2971-3-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more helper function for stacked irq_chip to just call parent's
function.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 include/linux/irq.h |  6 ++++++
 kernel/irq/chip.c   | 28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index d88a28a..aa0703b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -452,6 +452,12 @@ extern void handle_nested_irq(unsigned int irq);
 extern int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg);
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
 extern void irq_chip_ack_parent(struct irq_data *data);
+extern void irq_chip_mask_parent(struct irq_data *data);
+extern void irq_chip_unmask_parent(struct irq_data *data);
+extern void irq_chip_eoi_parent(struct irq_data *data);
+extern int irq_chip_set_affinity_parent(struct irq_data *data,
+					const struct cpumask *dest,
+					bool force);
 extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
 #endif
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 8f362db..7abdef5 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -858,6 +858,34 @@ void irq_chip_ack_parent(struct irq_data *data)
 	data->chip->irq_ack(data);
 }
 
+void irq_chip_mask_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_mask(data);
+}
+
+void irq_chip_unmask_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_unmask(data);
+}
+
+void irq_chip_eoi_parent(struct irq_data *data)
+{
+	data = data->parent_data;
+	data->chip->irq_eoi(data);
+}
+
+int irq_chip_set_affinity_parent(struct irq_data *data,
+				 const struct cpumask *dest, bool force)
+{
+	data = data->parent_data;
+	if (data->chip->irq_set_affinity)
+		return data->chip->irq_set_affinity(data, dest, force);
+
+	return -ENOSYS;
+}
+
 int irq_chip_retrigger_hierarchy(struct irq_data *data)
 {
 	for (data = data->parent_data; data; data = data->parent_data)
-- 
1.8.1.1.dirty

