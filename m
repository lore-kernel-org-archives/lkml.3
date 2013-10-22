Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3JVNCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:02:14 -0400
Received: from ring0.de ([91.143.88.219]:36211 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3JVNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:02:08 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>, Milo Kim <milo.kim@ti.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-omap@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCH 1/2] leds: lp55xx: handle enable pin in driver
Date: Tue, 22 Oct 2013 15:01:35 +0200
Message-Id: <1382446896-28436-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382446896-28436-1-git-send-email-sre@debian.org>
References: <1382446896-28436-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the handling of the chip's enable pin from the board
code into the driver. It also updates all board-code files using the
driver to incorporate this change.

This is needed for device tree support of the enable pin.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/leds/leds-lp55xx.txt       |  1 +
 arch/arm/mach-omap2/board-rx51-peripherals.c       | 20 +----------------
 arch/arm/mach-ux500/board-mop500.c                 |  2 ++
 drivers/leds/leds-lp55xx-common.c                  | 25 +++++++++++-----------
 include/linux/platform_data/leds-lp55xx.h          |  6 ++----
 5 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
index a61727f..5fb7b21 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
+++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
@@ -10,6 +10,7 @@ Each child has own specific current settings
 - max-cur: Maximun current at each led channel.
 
 Optional properties:
+- enable-gpio: GPIO attached to the chip's enable pin
 - label: Used for naming LEDs
 - pwr-sel: LP8501 specific property. Power selection for output channels.
          0: D1~9 are connected to VDD
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index f6fe388..68dc998 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -211,29 +211,11 @@ static struct lp55xx_led_config rx51_lp5523_led_config[] = {
 	}
 };
 
-static int rx51_lp5523_setup(void)
-{
-	return gpio_request_one(RX51_LP5523_CHIP_EN_GPIO, GPIOF_DIR_OUT,
-			"lp5523_enable");
-}
-
-static void rx51_lp5523_release(void)
-{
-	gpio_free(RX51_LP5523_CHIP_EN_GPIO);
-}
-
-static void rx51_lp5523_enable(bool state)
-{
-	gpio_set_value(RX51_LP5523_CHIP_EN_GPIO, !!state);
-}
-
 static struct lp55xx_platform_data rx51_lp5523_platform_data = {
 	.led_config		= rx51_lp5523_led_config,
 	.num_channels		= ARRAY_SIZE(rx51_lp5523_led_config),
 	.clock_mode		= LP55XX_CLOCK_AUTO,
-	.setup_resources	= rx51_lp5523_setup,
-	.release_resources	= rx51_lp5523_release,
-	.enable			= rx51_lp5523_enable,
+	.enable_gpio		= RX51_LP5523_CHIP_EN_GPIO,
 };
 #endif
 
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index ad0806e..703dec2 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -297,6 +297,7 @@ static struct lp55xx_platform_data __initdata lp5521_pri_data = {
        .led_config     = &lp5521_pri_led[0],
        .num_channels   = 3,
        .clock_mode     = LP55XX_CLOCK_EXT,
+       .enable_gpio    = -1,
 };
 
 static struct lp55xx_led_config lp5521_sec_led[] = {
@@ -322,6 +323,7 @@ static struct lp55xx_platform_data __initdata lp5521_sec_data = {
        .led_config     = &lp5521_sec_led[0],
        .num_channels   = 3,
        .clock_mode     = LP55XX_CLOCK_EXT,
+       .enable_gpio    = -1,
 };
 
 /* I2C0 devices only available on the first HREF/MOP500 */
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 351825b..5160f8e 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -20,6 +20,8 @@
 #include <linux/module.h>
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
 
 #include "leds-lp55xx-common.h"
 
@@ -406,18 +408,18 @@ int lp55xx_init_device(struct lp55xx_chip *chip)
 	if (!pdata || !cfg)
 		return -EINVAL;
 
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
+	if (gpio_is_valid(pdata->enable_gpio)) {
+		ret = devm_gpio_request_one(dev, pdata->enable_gpio,
+					    GPIOF_DIR_OUT, "lp5523_enable");
 		if (ret < 0) {
-			dev_err(dev, "setup resoure err: %d\n", ret);
+			dev_err(dev, "could not acquire enable gpio (err=%d)\n",
+				ret);
 			goto err;
 		}
-	}
 
-	if (pdata->enable) {
-		pdata->enable(0);
+		gpio_set_value(pdata->enable_gpio, 0);
 		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
+		gpio_set_value(pdata->enable_gpio, 1);
 		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
@@ -458,11 +460,8 @@ void lp55xx_deinit_device(struct lp55xx_chip *chip)
 	if (chip->clk)
 		clk_disable_unprepare(chip->clk);
 
-	if (pdata->enable)
-		pdata->enable(0);
-
-	if (pdata->release_resources)
-		pdata->release_resources();
+	if (gpio_is_valid(pdata->enable_gpio))
+		gpio_set_value(pdata->enable_gpio, 0);
 }
 EXPORT_SYMBOL_GPL(lp55xx_deinit_device);
 
@@ -593,6 +592,8 @@ int lp55xx_of_populate_pdata(struct device *dev, struct device_node *np)
 	of_property_read_string(np, "label", &pdata->label);
 	of_property_read_u8(np, "clock-mode", &pdata->clock_mode);
 
+	pdata->enable_gpio = of_get_named_gpio(np, "enable-gpio", 0);
+
 	/* LP8501 specific */
 	of_property_read_u8(np, "pwr-sel", (u8 *)&pdata->pwr_sel);
 
diff --git a/include/linux/platform_data/leds-lp55xx.h b/include/linux/platform_data/leds-lp55xx.h
index 51a2ff5..820a5c7 100644
--- a/include/linux/platform_data/leds-lp55xx.h
+++ b/include/linux/platform_data/leds-lp55xx.h
@@ -66,10 +66,8 @@ struct lp55xx_platform_data {
 	/* Clock configuration */
 	u8 clock_mode;
 
-	/* Platform specific functions */
-	int (*setup_resources)(void);
-	void (*release_resources)(void);
-	void (*enable)(bool state);
+	/* optional enable GPIO */
+	int enable_gpio;
 
 	/* Predefined pattern data */
 	struct lp55xx_predef_pattern *patterns;
-- 
1.8.4.rc3

