Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaKLGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:25:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40565 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbaKLGZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:25:56 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 3/3] irqchip: dw-apb-ictl: add PM support
Date: Wed, 12 Nov 2014 14:22:54 +0800
Message-ID: <1415773374-4629-4-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
References: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-12_04:2014-11-11,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411120057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in support for S2R for dw-apb-ictl irqchip driver.

We can used relaxed variants in the resume hook because there's no DMA
at all here, the device type memory attribute can ensure the operations
order and relaxed version imply compiler barrier.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/irqchip/irq-dw-apb-ictl.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
index c136b67..53bb732 100644
--- a/drivers/irqchip/irq-dw-apb-ictl.c
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -50,6 +50,21 @@ static void dw_apb_ictl_handler(unsigned int irq, struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
+#ifdef CONFIG_PM
+static void dw_apb_ictl_resume(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	irq_gc_lock(gc);
+	writel_relaxed(~0, gc->reg_base + ct->regs.enable);
+	writel_relaxed(*ct->mask_cache, gc->reg_base + ct->regs.mask);
+	irq_gc_unlock(gc);
+}
+#else
+#define dw_apb_ictl_resume	NULL
+#endif /* CONFIG_PM */
+
 static int __init dw_apb_ictl_init(struct device_node *np,
 				   struct device_node *parent)
 {
@@ -127,13 +142,17 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 	gc->reg_base = iobase;
 
 	gc->chip_types[0].regs.mask = APB_INT_MASK_L;
+	gc->chip_types[0].regs.enable = APB_INT_ENABLE_L;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_resume = dw_apb_ictl_resume;
 
 	if (nrirqs > 32) {
 		gc->chip_types[1].regs.mask = APB_INT_MASK_H;
+		gc->chip_types[1].regs.enable = APB_INT_ENABLE_H;
 		gc->chip_types[1].chip.irq_mask = irq_gc_mask_set_bit;
 		gc->chip_types[1].chip.irq_unmask = irq_gc_mask_clr_bit;
+		gc->chip_types[1].chip.irq_resume = dw_apb_ictl_resume;
 	}
 
 	irq_set_handler_data(irq, gc);
-- 
2.1.3

