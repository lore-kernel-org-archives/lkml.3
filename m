Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaJ2KHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:07:40 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:58741 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932137AbaJ2KHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:07:35 -0400
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>, <arm@kernel.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srv_heupstream@mediatek.com>,
        <yingjoe.chen@gmail.com>, <hc.yen@mediatek.com>,
        <eddie.huang@mediatek.com>, <nathan.chung@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 2/6] genirq: Add more helper functions to support stacked irq_chip
Date: Wed, 29 Oct 2014 18:00:20 +0800
Message-ID: <1414576824-16143-3-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com>
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
index 0adcbbb..ff0a89c 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -445,6 +445,12 @@ extern void handle_nested_irq(unsigned int irq);
 
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
index 12f3e72..fe53575 100644
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

