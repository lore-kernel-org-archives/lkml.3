Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3GIAVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:21:25 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64046 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:21:24 -0400
Message-ID: <1373329275.4223.1.camel@phoenix>
Subject: [RFT][PATCH 1/2] irqchip: vt8500: Fix implementation for irq_ack
 and irq_mask
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Prisk <linux@prisktech.co.nz>, Alexey Charkov <alchark@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Jul 2013 08:21:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code sets both irq_ack and irq_mask callbacks to vt8500_irq_mask().
However, vt8500_irq_mask does not clear interrupt enable bit when the interrupt
trigger mode is edge trigger.

This patch moves the code clearing Interrupt Status Register bit to irq_ack().
irq_mask() always clear interrupt enable bit for all interrupt trigger mode.

According to the datasheet, the Interrupt Status Register is written one to
clear(Write 0 has no effect). So we don't need a read-modify-write operation
for clearing a bit in interrupt status register.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Tony,
I don't have the hardware to test, just found this issue while reading the code.
I'd appreciate if you can review and test this patch serial.

Thanks,
Axel
 drivers/irqchip/irq-vt8500.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index d970595..eb6d05a 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -81,25 +81,24 @@ struct vt8500_irq_data {
 static struct vt8500_irq_data intc[VT8500_INTC_MAX];
 static u32 active_cnt = 0;
 
-static void vt8500_irq_mask(struct irq_data *d)
+static void vt8500_irq_ack(struct irq_data *d)
 {
 	struct vt8500_irq_data *priv = d->domain->host_data;
 	void __iomem *base = priv->base;
 	void __iomem *stat_reg = base + VT8500_ICIS + (d->hwirq < 32 ? 0 : 4);
-	u8 edge, dctr;
-	u32 status;
-
-	edge = readb(base + VT8500_ICDC + d->hwirq) & VT8500_EDGE;
-	if (edge) {
-		status = readl(stat_reg);
-
-		status |= (1 << (d->hwirq & 0x1f));
-		writel(status, stat_reg);
-	} else {
-		dctr = readb(base + VT8500_ICDC + d->hwirq);
-		dctr &= ~VT8500_INT_ENABLE;
-		writeb(dctr, base + VT8500_ICDC + d->hwirq);
-	}
+
+	writel(1 << (d->hwirq & 0x1f), stat_reg);
+}
+
+static void vt8500_irq_mask(struct irq_data *d)
+{
+	struct vt8500_irq_data *priv = d->domain->host_data;
+	void __iomem *base = priv->base;
+	u8 dctr;
+
+	dctr = readb(base + VT8500_ICDC + d->hwirq);
+	dctr &= ~VT8500_INT_ENABLE;
+	writeb(dctr, base + VT8500_ICDC + d->hwirq);
 }
 
 static void vt8500_irq_unmask(struct irq_data *d)
@@ -145,7 +144,7 @@ static int vt8500_irq_set_type(struct irq_data *d, unsigned int flow_type)
 
 static struct irq_chip vt8500_irq_chip = {
 	.name = "vt8500",
-	.irq_ack = vt8500_irq_mask,
+	.irq_ack = vt8500_irq_ack,
 	.irq_mask = vt8500_irq_mask,
 	.irq_unmask = vt8500_irq_unmask,
 	.irq_set_type = vt8500_irq_set_type,
-- 
1.8.1.2



