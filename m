Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab3KWKgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 05:36:24 -0500
Received: from gnurou.org ([207.192.72.5]:40590 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab3KWKgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 05:36:21 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: use platform GPIO mappings as fallback
Date: Sat, 23 Nov 2013 19:34:50 +0900
Message-Id: <1385202890-9511-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms that use device tree or ACPI as the standard way to look
GPIOs up, allow the platform-defined GPIO mappings to be used as a
fallback. This may be useful for platforms that need extra GPIOs mappings
not defined by the firmware.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 86caf17..4edd68c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2417,7 +2417,7 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 					       const char *con_id,
 					       unsigned int idx)
 {
-	struct gpio_desc *desc;
+	struct gpio_desc *desc = NULL;
 	int status;
 	enum gpio_lookup_flags flags = 0;
 
@@ -2430,9 +2430,19 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 	} else if (IS_ENABLED(CONFIG_ACPI) && dev && ACPI_HANDLE(dev)) {
 		dev_dbg(dev, "using ACPI for GPIO lookup\n");
 		desc = acpi_find_gpio(dev, con_id, idx, &flags);
-	} else {
+	}
+
+	/*
+	 * Either we are not using DT or ACPI, or their lookup did not return
+	 * a result. In that case, use platform lookup as a fallback.
+	 */
+	if (!desc || IS_ERR(desc)) {
+		struct gpio_desc *pdesc;
 		dev_dbg(dev, "using lookup tables for GPIO lookup");
-		desc = gpiod_find(dev, con_id, idx, &flags);
+		pdesc = gpiod_find(dev, con_id, idx, &flags);
+		/* If used as fallback, do not replace the previous error */
+		if (!IS_ERR(pdesc) || !desc)
+			desc = pdesc;
 	}
 
 	if (IS_ERR(desc)) {
-- 
1.8.4.2

