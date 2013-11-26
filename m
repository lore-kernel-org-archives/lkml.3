Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3KZToN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:44:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54637 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803Ab3KZToH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:44:07 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-gpio@vger.kernel.org>, <nsekhar@ti.com>
CC: <prabhakar.csengg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC v1 3/9] gpio: davinci: use chained_irq_enter/chained_irq_exit API
Date: Tue, 26 Nov 2013 21:40:09 +0200
Message-ID: <1385494815-15740-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unsafe to call IRQ chip callbacks (.irq_mask/irq_unmask/irq_ack)
from chained IRQ handler directly. Because, Davinci GPIO block is used
by different SoCs, which, in turn, have different Main IRQ controllers
(Davinci - aintc, cp-intc; Keystone - arm-gic) which may introduce
diffrent set of IRQ chip callbacks. As result, call of
gpio_irq_handler() on Keysone will simply cause crash the system,
because ARM-GIC implements .irq_eoi() instead of .irq_ack().

Hence, fix it by using Kernel chained_irq_enter/chained_irq_exit APIs as
they are intended to handle exact such cases.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/gpio/gpio-davinci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 70b5f2f..ee7a2df 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -22,6 +22,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/gpio-davinci.h>
+#include <linux/irqchip/chained_irq.h>
 
 struct davinci_gpio_regs {
 	u32	dir;
@@ -321,8 +322,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		mask <<= 16;
 
 	/* temporarily mask (level sensitive) parent IRQ */
-	desc->irq_data.chip->irq_mask(&desc->irq_data);
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	chained_irq_enter(irq_desc_get_chip(desc), desc);
 	while (1) {
 		u32		status;
 		int		bit;
@@ -343,7 +343,7 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 						 d->chip.base + bit));
 		}
 	}
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	chained_irq_exit(irq_desc_get_chip(desc), desc);
 	/* now it may re-trigger */
 }
 
-- 
1.7.9.5

