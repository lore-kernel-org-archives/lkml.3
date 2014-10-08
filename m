Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbaJHNsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:48:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60166 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbaJHNsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:48:00 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Krzysztof=20Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v2 1/4] regulator: Add ena_gpio_initialized to regulator_config
Date: Wed,  8 Oct 2014 15:47:05 +0200
Message-Id: <1412776028-15655-2-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most drivers do not set the ena_gpio field of struct regulator_config
before passing it to the regulator core. This is fine as long as the
gpio identifier that is passed is a positive integer. But the gpio
identifier 0 is also valid. So we are not able to decide wether we got a
real gpio identifier or not based on a 0 in ena_gpio.

To be able to decide if it is a valid gpio that got passed, this patch
adds a ena_gpio_initialized field that should be set if was initialized
with a correct value, either a gpio >= 0 or a negative error number. The
core then checks if ena_gpio or ena_gpio_initialized before handling it
as a gpio. This way we maintain backwards compatibility and fix the
behaviour for gpio number 0.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---

Notes:
    Changes in v2:
     - Squash all regulator core changes into one patch
     - Fix the ena_gpio check to be backwards compatible

 drivers/regulator/core.c         | 3 ++-
 include/linux/regulator/driver.h | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c37034..55a87a2722d8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3650,7 +3650,8 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
-	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
+	if ((config->ena_gpio || config->ena_gpio_initialized) &&
+	    gpio_is_valid(config->ena_gpio)) {
 		ret = regulator_ena_gpio_request(rdev, config);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index fc0ee0ce8325..28da08e4671f 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -301,6 +301,9 @@ struct regulator_desc {
  *           NULL).
  * @regmap: regmap to use for core regmap helpers if dev_get_regulator() is
  *          insufficient.
+ * @ena_gpio_initialized: GPIO controlling regulator enable was properly
+ *                        initialized, meaning that >= 0 is a valid gpio
+ *                        identifier and < 0 is a non existent gpio.
  * @ena_gpio: GPIO controlling regulator enable.
  * @ena_gpio_invert: Sense for GPIO enable control.
  * @ena_gpio_flags: Flags to use when calling gpio_request_one()
@@ -312,6 +315,7 @@ struct regulator_config {
 	struct device_node *of_node;
 	struct regmap *regmap;
 
+	bool ena_gpio_initialized;
 	int ena_gpio;
 	unsigned int ena_gpio_invert:1;
 	unsigned int ena_gpio_flags;
-- 
2.1.0

