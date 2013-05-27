Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3E0IyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:54:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47234 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3E0IyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:54:08 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, kernel@pengutronix.de,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH] pwm: add pca9685 driver
Date: Mon, 27 May 2013 10:53:34 +0200
Message-Id: <1369644814-18369-1-git-send-email-s.trumtrar@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pwm driver for the NXP pca9685 16 channel pwm-led controller.

The driver is really barebones at this stage. E.g. the OE' pin and
therefore the according registers are not supported.
The driver was tested on a HW where this pin is tied to GND.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 .../devicetree/bindings/pwm/nxp,pca9685-pwmled.txt |  28 +++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-pca9685-led.c                      | 245 +++++++++++++++++++++
 4 files changed, 283 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
 create mode 100644 drivers/pwm/pwm-pca9685-led.c

diff --git a/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
new file mode 100644
index 0000000..16f11c8
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
@@ -0,0 +1,28 @@
+NXP PCA9685 16-channel 12-bit PWM LED controller
+================================================
+
+Required properties:
+  - compatible: "nxp,pca9685-pwmled"
+  - #pwm-cells: should be 2.  The first cell specifies the per-chip index
+    of the PWM to use and the second cell is the period in nanoseconds.
+    The index 16 is the ALLCALL channel, that sets all pwm channels at the same
+    time.
+
+Optional properties:
+  - invrt:  <0> output logic state not inverted
+	    <1> output logic state inverted
+  - outdrv: <0> configure outputs with open-drain structure
+	    <1> configure outputs with totem pole structure
+
+Example:
+
+For LEDs that are directly connected to the pca, the following setting is
+applicable:
+
+pca: pca@41 {
+	compatible = "nx.,pca9685--pwmled";
+	#pwm-cells = <2>;
+	reg = <0x41>;
+	invrt = <1>;
+	outdrv = <0>;
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 115b644..8696f61 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -97,6 +97,15 @@ config PWM_MXS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-mxs.
 
+config PWM_PCA9685_LED
+	tristate "NXP PCA9685 PWM support for LED drivers"
+	depends on OF
+	help
+	  Generic PWM framework driver for NXP PCA9685 LED controller.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-pca9685-led.
+
 config PWM_PUV3
 	tristate "PKUnity NetBook-0916 PWM support"
 	depends on ARCH_PUV3
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 94ba21e..1924f03 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
 obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
+obj-$(CONFIG_PWM_PCA9685_LED)	+= pwm-pca9685-led.o
 obj-$(CONFIG_PWM_PUV3)		+= pwm-puv3.o
 obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
 obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
diff --git a/drivers/pwm/pwm-pca9685-led.c b/drivers/pwm/pwm-pca9685-led.c
new file mode 100644
index 0000000..c5e78b0
--- /dev/null
+++ b/drivers/pwm/pwm-pca9685-led.c
@@ -0,0 +1,245 @@
+/*
+ * Driver for PCA9685 16-channel 12-bit PWM LED controller
+ *
+ * Copyright (C) 2013 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * based on the pwm-twl-led.c driver
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#define PCA9685_MODE1		0x00
+#define PCA9685_MODE2		0x01
+#define PCA9685_SUBADDR1	0x02
+#define PCA9685_SUBADDR2	0x03
+#define PCA9685_SUBADDR3	0x04
+#define PCA9685_ALLCALLADDR	0x05
+#define PCA9685_LEDX_ON_L	0x06
+#define PCA9685_LEDX_ON_H	0x07
+#define PCA9685_LEDX_OFF_L	0x08
+#define PCA9685_LEDX_OFF_H	0x09
+
+#define PCA9685_ALL_LED_ON_L	0xFA
+#define PCA9685_ALL_LED_ON_H	0xFB
+#define PCA9685_ALL_LED_OFF_L	0xFC
+#define PCA9685_ALL_LED_OFF_H	0xFD
+#define PCA9685_PRESCALE	0xFE
+
+#define PCA9685_NUMREGS		0xFF
+#define PCA9685_MAXCHAN		0x10
+
+#define LED_FULL		(1 << 4)
+#define MODE1_SLEEP		(1 << 4)
+#define MODE2_INVRT		(1 << 4)
+#define MODE2_OUTDRV		(1 << 2)
+
+#define LED_N_ON_H(N)		(PCA9685_LEDX_ON_H + (4 * (N)))
+#define LED_N_ON_L(N)		(PCA9685_LEDX_ON_L + (4 * (N)))
+#define LED_N_OFF_H(N)		(PCA9685_LEDX_OFF_H + (4 * (N)))
+#define LED_N_OFF_L(N)		(PCA9685_LEDX_OFF_L + (4 * (N)))
+
+struct pca9685 {
+	struct pwm_chip chip;
+	struct regmap *regmap;
+	struct device *dev;
+};
+
+static inline struct pca9685 *to_pca(struct pwm_chip *chip)
+{
+	return container_of(chip, struct pca9685, chip);
+}
+
+static int pca9685_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	struct pca9685 *pca = to_pca(chip);
+	unsigned long long duty;
+	unsigned int reg;
+
+	if (duty_ns < 1)
+		return 0;
+
+	if (duty_ns == period_ns) {
+		reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_ON_H
+						: LED_N_ON_H(pwm->hwpwm);
+		regmap_write(pca->regmap, reg, LED_FULL);
+		return 0;
+	}
+
+	duty = 4096 * (unsigned long long)duty_ns;
+	duty = DIV_ROUND_UP_ULL(duty, period_ns);
+
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_L
+					: LED_N_OFF_L(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0xff & (int)duty);
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_H
+					: LED_N_OFF_H(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0xf & ((int)duty >> 8));
+
+	return 0;
+}
+
+static int pca9685_pwmled_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+	unsigned int reg;
+
+	/* the PWM subsystem does not support a pre-delay */
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_ON_L
+						: LED_N_ON_L(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0);
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_ON_H
+						: LED_N_ON_H(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0);
+
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_H
+						: LED_N_OFF_H(pwm->hwpwm);
+	regmap_update_bits(pca->regmap, reg, LED_FULL, 0x0);
+
+	return 0;
+}
+
+static void pca9685_pwmled_disable(struct pwm_chip *chip,
+				   struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+	unsigned int reg;
+
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_H
+						: LED_N_OFF_H(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, LED_FULL);
+	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_L
+					: LED_N_OFF_L(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0x0);
+}
+
+static int pca9685_pwmled_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+
+	return regmap_update_bits(pca->regmap, PCA9685_MODE1, MODE1_SLEEP, 0x0);
+}
+
+static const struct pwm_ops pca9685_pwmled_ops = {
+	.enable = pca9685_pwmled_enable,
+	.disable = pca9685_pwmled_disable,
+	.config = pca9685_pwmled_config,
+	.request = pca9685_pwmled_request,
+};
+
+static struct regmap_config pca9685_regmap_i2c_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = PCA9685_NUMREGS,
+	.cache_type = REGCACHE_NONE,
+};
+
+static int pca9685_pwmled_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device_node *np = client->dev.of_node;
+	struct pca9685 *pca;
+	int ret;
+	int val;
+	int mode2;
+
+	pca = devm_kzalloc(&client->dev, sizeof(*pca), GFP_KERNEL);
+	if (!pca)
+		return -ENOMEM;
+
+	pca->regmap = devm_regmap_init_i2c(client, &pca9685_regmap_i2c_config);
+	if (IS_ERR(pca->regmap)) {
+		ret = PTR_ERR(pca->regmap);
+		dev_err(&client->dev, "Failed to initialize register map: %d\n",
+				ret);
+		return ret;
+	}
+
+	i2c_set_clientdata(client, pca);
+	pca->dev = &client->dev;
+
+	regmap_read(pca->regmap, PCA9685_MODE2, &mode2);
+	if (!of_property_read_u32(np, "invrt", &val)) {
+		if (val)
+			mode2 |= MODE2_INVRT;
+		else
+			mode2 &= ~MODE2_INVRT;
+	}
+	if (!of_property_read_u32(np, "outdrv", &val)) {
+		if (val)
+			mode2 |= MODE2_OUTDRV;
+		else
+			mode2 &= ~MODE2_OUTDRV;
+	}
+	regmap_write(pca->regmap, PCA9685_MODE2, mode2);
+
+	/* clear all "full off" bits */
+	regmap_write(pca->regmap, PCA9685_ALL_LED_OFF_L, 0);
+	regmap_write(pca->regmap, PCA9685_ALL_LED_OFF_H, 0);
+
+	pca->chip.ops = &pca9685_pwmled_ops;
+	/* add an extra channel for ALL_LED */
+	pca->chip.npwm = PCA9685_MAXCHAN + 1;
+
+	pca->chip.dev = &client->dev;
+	pca->chip.base = -1;
+	pca->chip.can_sleep = true;
+
+	ret = pwmchip_add(&pca->chip);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int pca9685_pwmled_remove(struct i2c_client *client)
+{
+	struct pca9685 *pca = i2c_get_clientdata(client);
+
+	return pwmchip_remove(&pca->chip);
+}
+
+static const struct i2c_device_id pca9685_id[] = {
+	{"pca9685", 0},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, pca9685_id);
+
+static const struct of_device_id pca9685_dt_ids[] = {
+	{ .compatible = "nxp,pca9685-pwmled", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pca9685_dt_ids);
+
+static struct i2c_driver pca9685_i2c_driver = {
+	.driver = {
+		   .name = "pca9685",
+		   .owner = THIS_MODULE,
+		   .of_match_table = pca9685_dt_ids,
+		   },
+	.probe = pca9685_pwmled_probe,
+	.remove = pca9685_pwmled_remove,
+	.id_table = pca9685_id,
+};
+
+module_i2c_driver(pca9685_i2c_driver);
+
+MODULE_AUTHOR("Steffen Trumtrar <s.trumtrar@pengutronix.de>");
+MODULE_DESCRIPTION("PWM driver for PCA9685 LED outputs");
+MODULE_LICENSE("GPL");
-- 
1.8.2.rc2

