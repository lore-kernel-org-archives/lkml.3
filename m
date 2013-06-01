Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3FAMEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 08:04:25 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38090 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAMER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 08:04:17 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: kgene.kim@samsung.com, linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2 RESEND] gpio: samsung: Remove OF support for s3c24xx
Date: Sat,  1 Jun 2013 14:03:45 +0200
Message-Id: <1370088225-5187-1-git-send-email-sylvester.nawrocki@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

There is no users of this code and there is already a pinctrl
driver written for s3c24xx which is going to be used on any
s3c24xx DT platforms. Hence this has been effectively a dead
code in mainline.

This reverts commit 172c6a13653ac8cd6a231293b87c93821e90c1d6
gpio: samsung: add devicetree init for s3c24xx arches

Cc: Heiko Stübner <heiko@sntech.de>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
This patch was supposed to be merged through the Samsung tree
(https://patchwork.kernel.org/patch/2450291) but it seem to
have slipped through the cracks.

 .../devicetree/bindings/gpio/gpio-samsung.txt      |   43 -------------
 drivers/gpio/gpio-samsung.c                        |   63 --------------------
 2 files changed, 0 insertions(+), 106 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-samsung.txt b/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
index f1e5dfe..5375625 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
@@ -39,46 +39,3 @@ Example:
 		#gpio-cells = <4>;
 		gpio-controller;
 	};
-
-
-Samsung S3C24XX GPIO Controller
-
-Required properties:
-- compatible: Compatible property value should be "samsung,s3c24xx-gpio".
-
-- reg: Physical base address of the controller and length of memory mapped
-  region.
-
-- #gpio-cells: Should be 3. The syntax of the gpio specifier used by client nodes
-  should be the following with values derived from the SoC user manual.
-     <[phandle of the gpio controller node]
-      [pin number within the gpio controller]
-      [mux function]
-      [flags and pull up/down]
-
-  Values for gpio specifier:
-  - Pin number: depending on the controller a number from 0 up to 15.
-  - Mux function: Depending on the SoC and the gpio bank the gpio can be set
-                  as input, output or a special function
-  - Flags and Pull Up/Down: the values to use differ for the individual SoCs
-                    example S3C2416/S3C2450:
-                            0 - Pull Up/Down Disabled.
-                            1 - Pull Down Enabled.
-                            2 - Pull Up Enabled.
-          Bit 16 (0x00010000) - Input is active low.
-  Consult the user manual for the correct values of Mux and Pull Up/Down.
-
-- gpio-controller: Specifies that the node is a gpio controller.
-- #address-cells: should be 1.
-- #size-cells: should be 1.
-
-Example:
-
-	gpa: gpio-controller@56000000 {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		compatible = "samsung,s3c24xx-gpio";
-		reg = <0x56000000 0x10>;
-		#gpio-cells = <3>;
-		gpio-controller;
-	};
diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index b22ca79..96f6a7c 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -933,67 +933,6 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
 		s3c_gpiolib_track(chip);
 }

-#if defined(CONFIG_PLAT_S3C24XX) && defined(CONFIG_OF)
-static int s3c24xx_gpio_xlate(struct gpio_chip *gc,
-			const struct of_phandle_args *gpiospec, u32 *flags)
-{
-	unsigned int pin;
-
-	if (WARN_ON(gc->of_gpio_n_cells < 3))
-		return -EINVAL;
-
-	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
-		return -EINVAL;
-
-	if (gpiospec->args[0] > gc->ngpio)
-		return -EINVAL;
-
-	pin = gc->base + gpiospec->args[0];
-
-	if (s3c_gpio_cfgpin(pin, S3C_GPIO_SFN(gpiospec->args[1])))
-		pr_warn("gpio_xlate: failed to set pin function\n");
-	if (s3c_gpio_setpull(pin, gpiospec->args[2] & 0xffff))
-		pr_warn("gpio_xlate: failed to set pin pull up/down\n");
-
-	if (flags)
-		*flags = gpiospec->args[2] >> 16;
-
-	return gpiospec->args[0];
-}
-
-static const struct of_device_id s3c24xx_gpio_dt_match[] __initdata = {
-	{ .compatible = "samsung,s3c24xx-gpio", },
-	{}
-};
-
-static __init void s3c24xx_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
-						 u64 base, u64 offset)
-{
-	struct gpio_chip *gc =  &chip->chip;
-	u64 address;
-
-	if (!of_have_populated_dt())
-		return;
-
-	address = chip->base ? base + ((u32)chip->base & 0xfff) : base + offset;
-	gc->of_node = of_find_matching_node_by_address(NULL,
-			s3c24xx_gpio_dt_match, address);
-	if (!gc->of_node) {
-		pr_info("gpio: device tree node not found for gpio controller"
-			" with base address %08llx\n", address);
-		return;
-	}
-	gc->of_gpio_n_cells = 3;
-	gc->of_xlate = s3c24xx_gpio_xlate;
-}
-#else
-static __init void s3c24xx_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
-						 u64 base, u64 offset)
-{
-	return;
-}
-#endif /* defined(CONFIG_PLAT_S3C24XX) && defined(CONFIG_OF) */
-
 static void __init s3c24xx_gpiolib_add_chips(struct samsung_gpio_chip *chip,
 					     int nr_chips, void __iomem *base)
 {
@@ -1018,8 +957,6 @@ static void __init s3c24xx_gpiolib_add_chips(struct samsung_gpio_chip *chip,
 			gc->direction_output = samsung_gpiolib_2bit_output;

 		samsung_gpiolib_add(chip);
-
-		s3c24xx_gpiolib_attach_ofnode(chip, S3C24XX_PA_GPIO, i * 0x10);
 	}
 }

--
1.7.4.1

