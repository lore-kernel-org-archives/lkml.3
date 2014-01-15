Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaAOJKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:10:52 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60855 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaAOJKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:10:48 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Barry Song <Baohua.Song@csr.com>
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: sirf: lock IRQs when starting them
Date: Wed, 15 Jan 2014 10:10:42 +0100
Message-Id: <1389777042-2363-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the new API for tagging GPIO lines as in use by
IRQs. This enforces a few semantic checks on how the underlying
GPIO line is used.

Also assign the gpio_chip.dev pointer to be used for error
messages.

Cc: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Barry, it's be great if you could test this so I can just
add it to the v3.14 series.
---
 drivers/pinctrl/sirf/pinctrl-sirf.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
index b637f5ab022c..a0d6152701cd 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -594,12 +594,34 @@ static int sirfsoc_gpio_irq_type(struct irq_data *d, unsigned type)
 	return 0;
 }
 
+static unsigned int sirfsoc_gpio_irq_startup(struct irq_data *d)
+{
+	struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	if (gpio_lock_as_irq(&bank->chip.gc, d->hwirq))
+		dev_err(bank->chip.gc.dev,
+			"unable to lock HW IRQ %lu for IRQ\n",
+			d->hwirq);
+	sirfsoc_gpio_irq_unmask(d);
+	return 0;
+}
+
+static void sirfsoc_gpio_irq_shutdown(struct irq_data *d)
+{
+	struct sirfsoc_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	sirfsoc_gpio_irq_mask(d);
+	gpio_unlock_as_irq(&bank->chip.gc, d->hwirq);
+}
+
 static struct irq_chip sirfsoc_irq_chip = {
 	.name = "sirf-gpio-irq",
 	.irq_ack = sirfsoc_gpio_irq_ack,
 	.irq_mask = sirfsoc_gpio_irq_mask,
 	.irq_unmask = sirfsoc_gpio_irq_unmask,
 	.irq_set_type = sirfsoc_gpio_irq_type,
+	.irq_startup = sirfsoc_gpio_irq_startup,
+	.irq_shutdown = sirfsoc_gpio_irq_shutdown,
 };
 
 static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
@@ -877,6 +899,7 @@ static int sirfsoc_gpio_probe(struct device_node *np)
 		bank->chip.gc.of_node = np;
 		bank->chip.gc.of_xlate = sirfsoc_gpio_of_xlate;
 		bank->chip.gc.of_gpio_n_cells = 2;
+		bank->chip.gc.dev = &pdev->dev;
 		bank->chip.regs = regs;
 		bank->id = i;
 		bank->is_marco = is_marco;
-- 
1.8.4.2

