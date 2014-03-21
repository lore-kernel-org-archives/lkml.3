Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbaCUADt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760152AbaCUADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.13 054/149] pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility
Date: Thu, 20 Mar 2014 17:03:37 -0700
Message-Id: <20140321000438.830631686@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-sunxi.c |    4 ++++
 1 file changed, 4 insertions(+)

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
@@ -665,6 +666,7 @@ static struct irq_chip sunxi_pinctrl_irq
 
 static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = irq_get_chip(irq);
 	struct sunxi_pinctrl *pctl = irq_get_handler_data(irq);
 	const unsigned long reg = readl(pctl->membase + IRQ_STATUS_REG);
 
@@ -674,10 +676,12 @@ static void sunxi_pinctrl_irq_handler(un
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
 


