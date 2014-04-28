Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaD1DfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:35:24 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34396 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaD1DfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:35:22 -0400
Message-ID: <1398656117.19333.1.camel@phoenix>
Subject: [PATCH v2] irqchip: vt8500: Switch to a simple write clear for
 Interrupt Status Register
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2014 11:35:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet, the attribute of Interrupt Status Register is RW0S,
which means:
	Software can read the register.
	Software can also "write 1 to clear". "write 0" has no effect.

So the read/modify/write cycle is no necessary, switch to a simple write clear
instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2: Update commit log, this is a code simplification rather than bug fix.
 drivers/irqchip/irq-vt8500.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index eb6e91e..a0085bc 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -87,14 +87,10 @@ static void vt8500_irq_mask(struct irq_data *d)
 	void __iomem *base = priv->base;
 	void __iomem *stat_reg = base + VT8500_ICIS + (d->hwirq < 32 ? 0 : 4);
 	u8 edge, dctr;
-	u32 status;
 
 	edge = readb(base + VT8500_ICDC + d->hwirq) & VT8500_EDGE;
 	if (edge) {
-		status = readl(stat_reg);
-
-		status |= (1 << (d->hwirq & 0x1f));
-		writel(status, stat_reg);
+		writel(BIT(d->hwirq & 0x1f), stat_reg);
 	} else {
 		dctr = readb(base + VT8500_ICDC + d->hwirq);
 		dctr &= ~VT8500_INT_ENABLE;
-- 
1.8.3.2



