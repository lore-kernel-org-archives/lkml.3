Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaDOI2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:28:16 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45624 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaDOI2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:28:14 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] irqchip: vic: properly chain the cascaded IRQs
Date: Tue, 15 Apr 2014 10:28:04 +0200
Message-Id: <1397550484-7119-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are flagging the parent IRQ as chained, then we must also
make sure to call the chained_irq_[enter|exit] functions for
things to work smoothly.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Thomas, please pick this fix for v3.15-rc:s if it's OK.
---
 drivers/irqchip/irq-vic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 37dab0b472cd..7d35287f9e90 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -228,12 +229,17 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 static void vic_handle_irq_cascaded(unsigned int irq, struct irq_desc *desc)
 {
 	u32 stat, hwirq;
+	struct irq_chip *host_chip = irq_desc_get_chip(desc);
 	struct vic_device *vic = irq_desc_get_handler_data(desc);
 
+	chained_irq_enter(host_chip, desc);
+
 	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
 		hwirq = ffs(stat) - 1;
 		generic_handle_irq(irq_find_mapping(vic->domain, hwirq));
 	}
+
+	chained_irq_exit(host_chip, desc);
 }
 
 /*
-- 
1.9.0

