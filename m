Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3LCOYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:24:06 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:53000 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3LCOYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:24:00 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] pinctrl: baytrail: lock IRQs when starting them
Date: Tue,  3 Dec 2013 15:23:52 +0100
Message-Id: <1386080632-24402-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the new API for tagging GPIO lines as in use by
IRQs. This enforces a few semantic checks on how the underlying
GPIO line is used.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
I have no idea how to compile and test this, please help,
I have high confidence in the patch though.
---
 drivers/pinctrl/pinctrl-baytrail.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 1174ea86b6e9..7ad61c59f34a 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -372,11 +372,33 @@ static void byt_irq_mask(struct irq_data *d)
 {
 }
 
+static unsigned int lp_irq_startup(struct irq_data *d)
+{
+	struct byt_gpio *vg = irq_data_get_irq_handler_data(d);
+
+	if (gpio_lock_as_irq(&vg->chip, irqd_to_hwirq(d)))
+		dev_err(vg->chip.dev,
+			"unable to lock HW IRQ %lu for IRQ\n",
+			irqd_to_hwirq(d));
+	byt_irq_unmask(d);
+	return 0;
+}
+
+static void lp_irq_shutdown(struct irq_data *d)
+{
+	struct byt_gpio *vg = irq_data_get_irq_handler_data(d);
+
+	byt_irq_mask(d);
+	gpio_unlock_as_irq(&vg->chip, irqd_to_hwirq(d));
+}
+
 static struct irq_chip byt_irqchip = {
 	.name = "BYT-GPIO",
 	.irq_mask = byt_irq_mask,
 	.irq_unmask = byt_irq_unmask,
 	.irq_set_type = byt_irq_type,
+	.irq_startup = byt_irq_startup,
+	.irq_shutdown = byt_irq_shutdown,
 };
 
 static void byt_gpio_irq_init_hw(struct byt_gpio *vg)
-- 
1.8.3.1

