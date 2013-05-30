Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967832Ab3E3Hu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:50:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52657 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966822Ab3E3HuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:50:22 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        kernel@pengutronix.de, Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v3] pwm: add pca9685 driver
Date: Thu, 30 May 2013 09:50:12 +0200
Message-Id: <1369900212-14368-1-git-send-email-s.trumtrar@pengutronix.de>
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
therefore the corresponding registers are not supported.
The driver was tested on a HW where this pin is tied to GND.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
Changes since v2:
	- s/pwm-pca9685-led/pwm-pca9685/g
	- replace DT properties with booleans
	- whitespace/blank line cleanup
	- add "depends on REGMAP_I2C" in Kconfig
	- rework code readability
	- add pwm_ops.free function
	- set SLEEP bit on request/free/remove

Changes since v1:
	- fix typo in documentation example

 .../devicetree/bindings/pwm/nxp,pca9685-pwm.txt    |  27 ++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-pca9685.c                          | 291 +++++++++++++++++++++
 4 files changed, 328 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm.txt
 create mode 100644 drivers/pwm/pwm-pca9685.c

diff --git a/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm.txt b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm.txt
new file mode 100644
index 0000000..1e3dfe7
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm.txt
@@ -0,0 +1,27 @@
+NXP PCA9685 16-channel 12-bit PWM LED controller
+================================================
+
+Required properties:
+  - compatible: "nxp,pca9685-pwm"
+  - #pwm-cells: should be 2. The first cell specifies the per-chip index
+    of the PWM to use and the second cell is the period in nanoseconds.
+    The index 16 is the ALLCALL channel, that sets all PWM channels at the same
+    time.
+
+Optional properties:
+  - invert (bool): boolean to enable inverted logic
+  - open-drain (bool): boolean to configure outputs with open-drain structure;
+		       if omitted use totem-pole structure
+
+Example:
+
+For LEDs that are directly connected to the PCA, the following setting is
+applicable:
+
+pca: pca@41 {
+	compatible = "nxp,pca9685-pwm";
+	#pwm-cells = <2>;
+	reg = <0x41>;
+	invert;
+	open-drain;
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 115b644..d3fe320 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -97,6 +97,15 @@ config PWM_MXS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-mxs.
 
+config PWM_PCA9685
+	tristate "NXP PCA9685 PWM driver"
+	depends on OF && REGMAP_I2C
+	help
+	  Generic PWM framework driver for NXP PCA9685 LED controller.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-pca9685.
+
 config PWM_PUV3
 	tristate "PKUnity NetBook-0916 PWM support"
 	depends on ARCH_PUV3
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 94ba21e..b3afc0a 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
 obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
+obj-$(CONFIG_PWM_PCA9685)	+= pwm-pca9685.o
 obj-$(CONFIG_PWM_PUV3)		+= pwm-puv3.o
 obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
 obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
new file mode 100644
index 0000000..576ec2a
--- /dev/null
+++ b/drivers/pwm/pwm-pca9685.c
@@ -0,0 +1,291 @@
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
+
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
+#define LED_N_ON_H(N)	(PCA9685_LEDX_ON_H + (4 * (N)))
+#define LED_N_ON_L(N)	(PCA9685_LEDX_ON_L + (4 * (N)))
+#define LED_N_OFF_H(N)	(PCA9685_LEDX_OFF_H + (4 * (N)))
+#define LED_N_OFF_L(N)	(PCA9685_LEDX_OFF_L + (4 * (N)))
+
+struct pca9685 {
+	struct pwm_chip chip;
+	struct regmap	*regmap;
+	struct device	*dev;
+	int		active_cnt;
+};
+
+static inline struct pca9685 *to_pca(struct pwm_chip *chip)
+{
+	return container_of(chip, struct pca9685, chip);
+}
+
+static int pca9685_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	struct pca9685 *pca = to_pca(chip);
+	unsigned long long duty;
+	unsigned int reg;
+
+	if (duty_ns < 1) {
+		if (pwm->hwpwm >= PCA9685_MAXCHAN)
+			reg = PCA9685_ALL_LED_OFF_H;
+		else
+			reg = LED_N_OFF_H(pwm->hwpwm);
+		regmap_write(pca->regmap, reg, LED_FULL);
+
+		return 0;
+	}
+
+	if (duty_ns == period_ns) {
+		if (pwm->hwpwm >= PCA9685_MAXCHAN)
+			reg = PCA9685_ALL_LED_ON_H;
+		else
+			reg = LED_N_ON_H(pwm->hwpwm);
+		regmap_write(pca->regmap, reg, LED_FULL);
+
+		return 0;
+	}
+
+	duty = 4096 * (unsigned long long)duty_ns;
+	duty = DIV_ROUND_UP_ULL(duty, period_ns);
+
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_OFF_L;
+	else
+		reg = LED_N_OFF_L(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, (int)duty & 0xff);
+
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_OFF_H;
+	else
+		reg = LED_N_OFF_H(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, ((int)duty >> 8) & 0xf);
+
+	return 0;
+}
+
+static int pca9685_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+	unsigned int reg;
+
+	/*
+	 * The PWM subsystem does not support a pre-delay.
+	 * So, set the ON-timeout to 0
+	 */
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_ON_L;
+	else
+		reg = LED_N_ON_L(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0);
+
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_ON_H;
+	else
+		reg = LED_N_ON_H(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0);
+
+	/*
+	 * Clear the full-off bit.
+	 * It has precedence over the others and must be off.
+	 */
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_OFF_H;
+	else
+		reg = LED_N_OFF_H(pwm->hwpwm);
+	regmap_update_bits(pca->regmap, reg, LED_FULL, 0x0);
+
+	return 0;
+}
+
+static void pca9685_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+	unsigned int reg;
+
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_OFF_H;
+	else
+		reg = LED_N_OFF_H(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, LED_FULL);
+
+	/* Clear the LED_OFF counter. */
+	if (pwm->hwpwm >= PCA9685_MAXCHAN)
+		reg = PCA9685_ALL_LED_OFF_L;
+	else
+		reg = LED_N_OFF_L(pwm->hwpwm);
+	regmap_write(pca->regmap, reg, 0x0);
+}
+
+static int pca9685_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+
+	if (pca->active_cnt++ == 0)
+		return regmap_update_bits(pca->regmap, PCA9685_MODE1,
+						MODE1_SLEEP, 0x0);
+
+	return 0;
+}
+
+static void pca9685_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct pca9685 *pca = to_pca(chip);
+
+	pca->active_cnt--;
+
+	if (pca->active_cnt == 0)
+		regmap_update_bits(pca->regmap, PCA9685_MODE1, MODE1_SLEEP, 0x1);
+}
+
+static const struct pwm_ops pca9685_pwm_ops = {
+	.enable = pca9685_pwm_enable,
+	.disable = pca9685_pwm_disable,
+	.config = pca9685_pwm_config,
+	.request = pca9685_pwm_request,
+	.free = pca9685_pwm_free,
+};
+
+static struct regmap_config pca9685_regmap_i2c_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = PCA9685_NUMREGS,
+	.cache_type = REGCACHE_NONE,
+};
+
+static int pca9685_pwm_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct device_node *np = client->dev.of_node;
+	struct pca9685 *pca;
+	int ret;
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
+
+	if (of_property_read_bool(np, "invert"))
+		mode2 |= MODE2_INVRT;
+	else
+		mode2 &= ~MODE2_INVRT;
+
+	if (of_property_read_bool(np, "open-drain"))
+		mode2 &= ~MODE2_OUTDRV;
+	else
+		mode2 |= MODE2_OUTDRV;
+
+	regmap_write(pca->regmap, PCA9685_MODE2, mode2);
+
+	/* clear all "full off" bits */
+	regmap_write(pca->regmap, PCA9685_ALL_LED_OFF_L, 0);
+	regmap_write(pca->regmap, PCA9685_ALL_LED_OFF_H, 0);
+
+	pca->chip.ops = &pca9685_pwm_ops;
+	/* add an extra channel for ALL_LED */
+	pca->chip.npwm = PCA9685_MAXCHAN + 1;
+
+	pca->chip.dev = &client->dev;
+	pca->chip.base = -1;
+	pca->chip.can_sleep = true;
+
+	return pwmchip_add(&pca->chip);
+}
+
+static int pca9685_pwm_remove(struct i2c_client *client)
+{
+	struct pca9685 *pca = i2c_get_clientdata(client);
+
+	regmap_update_bits(pca->regmap, PCA9685_MODE1, MODE1_SLEEP, 0x1);
+	return pwmchip_remove(&pca->chip);
+}
+
+static const struct i2c_device_id pca9685_id[] = {
+	{ "pca9685", 0 },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(i2c, pca9685_id);
+
+static const struct of_device_id pca9685_dt_ids[] = {
+	{ .compatible = "nxp,pca9685-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pca9685_dt_ids);
+
+static struct i2c_driver pca9685_i2c_driver = {
+	.driver = {
+		.name		= "pca9685-pwm",
+		.owner		= THIS_MODULE,
+		.of_match_table	= pca9685_dt_ids,
+	},
+	.probe = pca9685_pwm_probe,
+	.remove = pca9685_pwm_remove,
+	.id_table = pca9685_id,
+};
+
+module_i2c_driver(pca9685_i2c_driver);
+
+MODULE_AUTHOR("Steffen Trumtrar <s.trumtrar@pengutronix.de>");
+MODULE_DESCRIPTION("PWM driver for PCA9685");
+MODULE_LICENSE("GPL");
-- 
1.8.2.rc2

