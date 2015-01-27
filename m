Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbbA0EqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:46:21 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59978 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbbA0EqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:46:18 -0500
From: Rob Herring <robh@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 1/3] gpio: pxa: remove mach IRQ includes
Date: Mon, 26 Jan 2015 22:46:04 -0600
Message-Id: <1422333966-18338-2-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422333966-18338-1-git-send-email-robh@kernel.org>
References: <1422333966-18338-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to enable ARCH_MMP on ARM64, the include of mach/irqs.h
must be eliminated. mach/irqs.h was being included for IRQ_GPIO{0,1},
but these IRQs are always passed in as resources now. We can use irq0
and irq1 and get rid of IRQ_GPIOx. Get rid of the ifdef in the process
as it is no longer needed.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
---
 drivers/gpio/gpio-pxa.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index ad3feec..b4fb8de 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -17,6 +17,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio-pxa.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
@@ -27,8 +28,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/slab.h>
 
-#include <mach/irqs.h>
-
 /*
  * We handle the GPIOs by banks, each bank covers up to 32 GPIOs with
  * one set of registers. The register offsets are organized below:
@@ -629,19 +628,18 @@ static int pxa_gpio_probe(struct platform_device *pdev)
 	}
 
 	if (!use_of) {
-#ifdef CONFIG_ARCH_PXA
-		irq = gpio_to_irq(0);
-		irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
-					 handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-		irq_set_chained_handler(IRQ_GPIO0, pxa_gpio_demux_handler);
-
-		irq = gpio_to_irq(1);
-		irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
-					 handle_edge_irq);
-		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-		irq_set_chained_handler(IRQ_GPIO1, pxa_gpio_demux_handler);
-#endif
+		if (irq0 > 0) {
+			irq = gpio_to_irq(0);
+			irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
+						 handle_edge_irq);
+			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+		}
+		if (irq1 > 0) {
+			irq = gpio_to_irq(1);
+			irq_set_chip_and_handler(irq, &pxa_muxed_gpio_chip,
+						 handle_edge_irq);
+			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+		}
 
 		for (irq  = gpio_to_irq(gpio_offset);
 			irq <= gpio_to_irq(pxa_last_gpio); irq++) {
@@ -649,13 +647,13 @@ static int pxa_gpio_probe(struct platform_device *pdev)
 						 handle_edge_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
-	} else {
-		if (irq0 > 0)
-			irq_set_chained_handler(irq0, pxa_gpio_demux_handler);
-		if (irq1 > 0)
-			irq_set_chained_handler(irq1, pxa_gpio_demux_handler);
 	}
 
+	if (irq0 > 0)
+		irq_set_chained_handler(irq0, pxa_gpio_demux_handler);
+	if (irq1 > 0)
+		irq_set_chained_handler(irq1, pxa_gpio_demux_handler);
+
 	irq_set_chained_handler(irq_mux, pxa_gpio_demux_handler);
 	return 0;
 }
-- 
2.1.0

