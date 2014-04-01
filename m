Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaDAMEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:04:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaDALRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen-Yu Tsai <wens@csie.org>, Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 046/144] pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility
Date: Tue,  1 Apr 2014 12:14:10 +0100
Message-Id: <1396350948-29910-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

commit 905a5117e79367b7e58ae046d12ca9961f048c89 upstream.

On tha Allwinner A20 SoC, the external interrupts on the pin controller
device are connected to the GIC. Without chained_irq_{enter, exit},
external GPIO interrupts, such as used by mmc core card detect, cause
the system to hang.

This issue was first encountered during my attempt to get out-of-band
interrupts for WiFi on the Cubietruck working. With David's new series
of sunci-mci using mmc slot-gpio for (GPIO interrupt based) card
detection, removing the SD card also causes my Cubietruck to hang. This
problem should extend to all Allwinner A20 based boards.

With this fix, the system no longer hangs when I remove or insert the
SD card. /proc/interrupts show that the interrupt has correctly fired.
However the system still does not detect card removal/insertion. I
believe this is another unrelated issue.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 0d9a1cf..95d3e7b 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/irqdomain.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -668,6 +669,7 @@ static struct irq_chip sunxi_pinctrl_irq_chip = {
 
 static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = irq_get_chip(irq);
 	struct sunxi_pinctrl *pctl = irq_get_handler_data(irq);
 	const unsigned long reg = readl(pctl->membase + IRQ_STATUS_REG);
 
@@ -677,10 +679,12 @@ static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 	if (reg) {
 		int irqoffset;
 
+		chained_irq_enter(chip, desc);
 		for_each_set_bit(irqoffset, &reg, SUNXI_IRQ_NUMBER) {
 			int pin_irq = irq_find_mapping(pctl->domain, irqoffset);
 			generic_handle_irq(pin_irq);
 		}
+		chained_irq_exit(chip, desc);
 	}
 }
 
-- 
1.9.1

