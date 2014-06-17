Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbaFQOxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:53:34 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41362 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbaFQOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:25 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 15/20] pinctrl: sunxi: Add A23 R_PIO controller support
Date: Tue, 17 Jun 2014 22:52:52 +0800
Message-Id: <1403016777-15121-16-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A23 has a R_PIO pin controller, similar to the one found on the A31 SoC.
Add support for the pins controlled by the R_PIO controller.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   1 +
 drivers/pinctrl/sunxi/Kconfig                      |   5 +
 drivers/pinctrl/sunxi/Makefile                     |   1 +
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c        | 142 +++++++++++++++++++++
 4 files changed, 149 insertions(+)
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c

diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
index 44a78c1..93ce12e 100644
--- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
@@ -14,6 +14,7 @@ Required properties:
   "allwinner,sun6i-a31-r-pinctrl"
   "allwinner,sun7i-a20-pinctrl"
   "allwinner,sun8i-a23-pinctrl"
+  "allwinner,sun8i-a23-r-pinctrl"
 - reg: Should contain the register physical address and length for the
   pin controller.
 
diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kconfig
index 7c72ed8..da49524 100644
--- a/drivers/pinctrl/sunxi/Kconfig
+++ b/drivers/pinctrl/sunxi/Kconfig
@@ -37,4 +37,9 @@ config PINCTRL_SUN8I_A23
 	def_bool MACH_SUN8I
 	select PINCTRL_SUNXI_COMMON
 
+config PINCTRL_SUN8I_A23_R
+	def_bool MACH_SUN8I
+	depends on RESET_CONTROLLER
+	select PINCTRL_SUNXI_COMMON
+
 endif
diff --git a/drivers/pinctrl/sunxi/Makefile b/drivers/pinctrl/sunxi/Makefile
index 850cd50..e797efb 100644
--- a/drivers/pinctrl/sunxi/Makefile
+++ b/drivers/pinctrl/sunxi/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_PINCTRL_SUN6I_A31)		+= pinctrl-sun6i-a31.o
 obj-$(CONFIG_PINCTRL_SUN6I_A31_R)	+= pinctrl-sun6i-a31-r.o
 obj-$(CONFIG_PINCTRL_SUN7I_A20)		+= pinctrl-sun7i-a20.o
 obj-$(CONFIG_PINCTRL_SUN8I_A23)		+= pinctrl-sun8i-a23.o
+obj-$(CONFIG_PINCTRL_SUN8I_A23_R)	+= pinctrl-sun8i-a23-r.o
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c b/drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c
new file mode 100644
index 0000000..90f3b3a
--- /dev/null
+++ b/drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c
@@ -0,0 +1,142 @@
+/*
+ * Allwinner A23 SoCs special pins pinctrl driver.
+ *
+ * Copyright (C) 2014 Chen-Yu Tsai
+ * Chen-Yu Tsai <wens@csie.org>
+ *
+ * Copyright (C) 2014 Boris Brezillon
+ * Boris Brezillon <boris.brezillon@free-electrons.com>
+ *
+ * Copyright (C) 2014 Maxime Ripard
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/reset.h>
+
+#include "pinctrl-sunxi.h"
+
+static const struct sunxi_desc_pin sun8i_a23_r_pins[] = {
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 0),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_rsb"),		/* SCK */
+		  SUNXI_FUNCTION(0x3, "s_twi"),		/* SCK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 0)),	/* PL_EINT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 1),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_rsb"),		/* SDA */
+		  SUNXI_FUNCTION(0x3, "s_twi"),		/* SDA */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 1)),	/* PL_EINT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 2),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_uart"),	/* TX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 2)),	/* PL_EINT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 3),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_uart"),	/* RX */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 3)),	/* PL_EINT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 4),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag"),	/* MS */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 4)),	/* PL_EINT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 5),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag"),	/* CK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 5)),	/* PL_EINT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 6),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag"),	/* DO */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 6)),	/* PL_EINT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 7),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "s_jtag"),	/* DI */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 7)),	/* PL_EINT7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 8),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_twi"),		/* SCK */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 8)),	/* PL_EINT8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 9),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_twi"),		/* SDA */
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 9)),	/* PL_EINT9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 10),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "s_pwm"),
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 10)),	/* PL_EINT10 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN(L, 11),
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION_IRQ_BANK(0x4, 0, 11)),	/* PL_EINT11 */
+};
+
+static const struct sunxi_pinctrl_desc sun8i_a23_r_pinctrl_data = {
+	.pins = sun8i_a23_r_pins,
+	.npins = ARRAY_SIZE(sun8i_a23_r_pins),
+	.pin_base = PL_BASE,
+	.irq_banks = 1,
+};
+
+static int sun8i_a23_r_pinctrl_probe(struct platform_device *pdev)
+{
+	struct reset_control *rstc;
+	int ret;
+
+	rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(rstc)) {
+		dev_err(&pdev->dev, "Reset controller missing\n");
+		return PTR_ERR(rstc);
+	}
+
+	ret = reset_control_deassert(rstc);
+	if (ret)
+		return ret;
+
+	ret = sunxi_pinctrl_init(pdev,
+				 &sun8i_a23_r_pinctrl_data);
+
+	if (ret)
+		reset_control_assert(rstc);
+
+	return ret;
+}
+
+static struct of_device_id sun8i_a23_r_pinctrl_match[] = {
+	{ .compatible = "allwinner,sun8i-a23-r-pinctrl", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, sun8i_a23_r_pinctrl_match);
+
+static struct platform_driver sun8i_a23_r_pinctrl_driver = {
+	.probe	= sun8i_a23_r_pinctrl_probe,
+	.driver	= {
+		.name		= "sun8i-a23-r-pinctrl",
+		.owner		= THIS_MODULE,
+		.of_match_table	= sun8i_a23_r_pinctrl_match,
+	},
+};
+module_platform_driver(sun8i_a23_r_pinctrl_driver);
+
+MODULE_AUTHOR("Chen-Yu Tsai <wens@csie.org>");
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com");
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
+MODULE_DESCRIPTION("Allwinner A23 R_PIO pinctrl driver");
+MODULE_LICENSE("GPL");
-- 
2.0.0

