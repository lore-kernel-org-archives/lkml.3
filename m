Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaDHSY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:24:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41822 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbaDHSVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:21:17 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC PATCH 3/5] gpio: omap: convert driver to use gpio_chip_ops
Date: Tue,  8 Apr 2014 20:20:13 +0200
Message-Id: <1396981215-24888-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO controller operations has been split to be stored
on a separate struct gpio_chip_ops virtual function table.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/gpio/gpio-omap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 8cc9e91..50f0938 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1072,6 +1072,16 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
 			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
 }
 
+const struct gpio_chip_ops omap_gpio_ops = {
+	.request = omap_gpio_request,
+	.free = omap_gpio_free,
+	.direction_input = gpio_input,
+	.get = gpio_get,
+	.direction_output = gpio_output,
+	.set_debounce = gpio_debounce,
+	.set = gpio_set
+};
+
 static int omap_gpio_chip_init(struct gpio_bank *bank)
 {
 	int j;
@@ -1083,13 +1093,8 @@ static int omap_gpio_chip_init(struct gpio_bank *bank)
 	 * REVISIT eventually switch from OMAP-specific gpio structs
 	 * over to the generic ones
 	 */
-	bank->chip.request = omap_gpio_request;
-	bank->chip.free = omap_gpio_free;
-	bank->chip.direction_input = gpio_input;
-	bank->chip.get = gpio_get;
-	bank->chip.direction_output = gpio_output;
-	bank->chip.set_debounce = gpio_debounce;
-	bank->chip.set = gpio_set;
+	bank->chip.ops = &omap_gpio_ops;
+
 	if (bank->is_mpuio) {
 		bank->chip.label = "mpuio";
 		if (bank->regs->wkup_en)
-- 
1.9.0

