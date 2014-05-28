Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaE1KV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:21:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbaE1KVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:21:52 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 4/9] mfd: palmas: Add tps65917 support
Date: Wed, 28 May 2014 15:50:17 +0530
Message-ID: <1401272423-25761-5-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tps65917 PMIC support. tps65917 is a subset of palmas PMIC.
Some of the register definitions and the interrupt mappings
are different.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 171 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index d280d78..485d755 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -92,6 +92,133 @@ static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
 	},
 };
 
+static const struct regmap_irq tps65917_irqs[] = {
+	/* INT1 IRQs */
+	[TPS65917_RESERVED1] = {
+		.mask = TPS65917_RESERVED,
+	},
+	[TPS65917_PWRON_IRQ] = {
+		.mask = TPS65917_INT1_STATUS_PWRON,
+	},
+	[TPS65917_LONG_PRESS_KEY_IRQ] = {
+		.mask = TPS65917_INT1_STATUS_LONG_PRESS_KEY,
+	},
+	[TPS65917_RESERVED2] = {
+		.mask = TPS65917_RESERVED,
+	},
+	[TPS65917_PWRDOWN_IRQ] = {
+		.mask = TPS65917_INT1_STATUS_PWRDOWN,
+	},
+	[TPS65917_HOTDIE_IRQ] = {
+		.mask = TPS65917_INT1_STATUS_HOTDIE,
+	},
+	[TPS65917_VSYS_MON_IRQ] = {
+		.mask = TPS65917_INT1_STATUS_VSYS_MON,
+	},
+	[TPS65917_RESERVED3] = {
+		.mask = TPS65917_RESERVED,
+	},
+	/* INT2 IRQs*/
+	[TPS65917_RESERVED4] = {
+		.mask = TPS65917_RESERVED,
+		.reg_offset = 1,
+	},
+	[TPS65917_OTP_ERROR_IRQ] = {
+		.mask = TPS65917_INT2_STATUS_OTP_ERROR,
+		.reg_offset = 1,
+	},
+	[TPS65917_WDT_IRQ] = {
+		.mask = TPS65917_INT2_STATUS_WDT,
+		.reg_offset = 1,
+	},
+	[TPS65917_RESERVED5] = {
+		.mask = TPS65917_RESERVED,
+		.reg_offset = 1,
+	},
+	[TPS65917_RESET_IN_IRQ] = {
+		.mask = TPS65917_INT2_STATUS_RESET_IN,
+		.reg_offset = 1,
+	},
+	[TPS65917_FSD_IRQ] = {
+		.mask = TPS65917_INT2_STATUS_FSD,
+		.reg_offset = 1,
+	},
+	[TPS65917_SHORT_IRQ] = {
+		.mask = TPS65917_INT2_STATUS_SHORT,
+		.reg_offset = 1,
+	},
+	[TPS65917_RESERVED6] = {
+		.mask = TPS65917_RESERVED,
+		.reg_offset = 1,
+	},
+	/* INT3 IRQs */
+	[TPS65917_GPADC_AUTO_0_IRQ] = {
+		.mask = TPS65917_INT3_STATUS_GPADC_AUTO_0,
+		.reg_offset = 2,
+	},
+	[TPS65917_GPADC_AUTO_1_IRQ] = {
+		.mask = TPS65917_INT3_STATUS_GPADC_AUTO_1,
+		.reg_offset = 2,
+	},
+	[TPS65917_GPADC_EOC_SW_IRQ] = {
+		.mask = TPS65917_INT3_STATUS_GPADC_EOC_SW,
+		.reg_offset = 2,
+	},
+	[TPS65917_RESREVED6] = {
+		.mask = TPS65917_RESERVED6,
+		.reg_offset = 2,
+	},
+	[TPS65917_RESERVED7] = {
+		.mask = TPS65917_RESERVED,
+		.reg_offset = 2,
+	},
+	[TPS65917_RESERVED8] = {
+		.mask = TPS65917_RESERVED,
+		.reg_offset = 2,
+	},
+	[TPS65917_RESERVED9] = {
+		.mask = TPS65917_RESERVED,
+		.reg_offset = 2,
+	},
+	[TPS65917_VBUS_IRQ] = {
+		.mask = TPS65917_INT3_STATUS_VBUS,
+		.reg_offset = 2,
+	},
+	/* INT4 IRQs */
+	[TPS65917_GPIO_0_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_0,
+		.reg_offset = 3,
+	},
+	[TPS65917_GPIO_1_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_1,
+		.reg_offset = 3,
+	},
+	[TPS65917_GPIO_2_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_2,
+		.reg_offset = 3,
+	},
+	[TPS65917_GPIO_3_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_3,
+		.reg_offset = 3,
+	},
+	[TPS65917_GPIO_4_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_4,
+		.reg_offset = 3,
+	},
+	[TPS65917_GPIO_5_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_5,
+		.reg_offset = 3,
+	},
+	[TPS65917_GPIO_6_IRQ] = {
+		.mask = TPS65917_INT4_STATUS_GPIO_6,
+		.reg_offset = 3,
+	},
+	[TPS65917_RESERVED10] = {
+		.mask = TPS65917_RESERVED10,
+		.reg_offset = 3,
+	},
+};
+
 static const struct regmap_irq palmas_irqs[] = {
 	/* INT1 IRQs */
 	[PALMAS_CHARG_DET_N_VBUS_OVV_IRQ] = {
@@ -232,6 +359,19 @@ static struct regmap_irq_chip palmas_irq_chip = {
 			PALMAS_INT1_MASK),
 };
 
+static struct regmap_irq_chip tps65917_irq_chip = {
+	.name = "tps65917",
+	.irqs = tps65917_irqs,
+	.num_irqs = ARRAY_SIZE(tps65917_irqs),
+
+	.num_regs = 4,
+	.irq_reg_stride = 5,
+	.status_base = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE,
+			PALMAS_INT1_STATUS),
+	.mask_base = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE,
+			PALMAS_INT1_MASK),
+};
+
 int palmas_ext_control_req_config(struct palmas *palmas,
 	enum palmas_external_requestor_id id,  int ext_ctrl, bool enable)
 {
@@ -357,14 +497,38 @@ static void palmas_power_off(void)
 static unsigned int palmas_features = PALMAS_PMIC_FEATURE_SMPS10_BOOST;
 static unsigned int tps659038_features;
 
+struct palmas_driver_data {
+	unsigned int *features;
+	struct regmap_irq_chip *irq_chip;
+};
+
+static struct palmas_driver_data palmas_data = {
+	.features = &palmas_features,
+	.irq_chip = &palmas_irq_chip,
+};
+
+static struct palmas_driver_data tps659038_data = {
+	.features = &tps659038_features,
+	.irq_chip = &palmas_irq_chip,
+};
+
+static struct palmas_driver_data tps65917_data = {
+	.features = &tps659038_features,
+	.irq_chip = &tps65917_irq_chip,
+};
+
 static const struct of_device_id of_palmas_match_tbl[] = {
 	{
 		.compatible = "ti,palmas",
-		.data = &palmas_features,
+		.data = &palmas_data,
 	},
 	{
 		.compatible = "ti,tps659038",
-		.data = &tps659038_features,
+		.data = &tps659038_data,
+	},
+	{
+		.compatible = "ti,tps65917",
+		.data = &tps65917_data,
 	},
 	{ },
 };
@@ -375,6 +539,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 {
 	struct palmas *palmas;
 	struct palmas_platform_data *pdata;
+	struct palmas_driver_data *driver_data;
 	struct device_node *node = i2c->dev.of_node;
 	int ret = 0, i;
 	unsigned int reg, addr, *features;
@@ -408,7 +573,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (!match)
 		return -ENODATA;
 
-	features = (unsigned int *)match->data;
+	driver_data = (struct palmas_driver_data *)match->data;
+	features = (unsigned int *)driver_data->features;
 	palmas->features = *features;
 
 	for (i = 0; i < PALMAS_NUM_CLIENTS; i++) {
@@ -463,8 +629,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	regmap_write(palmas->regmap[slave], addr, reg);
 
 	ret = regmap_add_irq_chip(palmas->regmap[slave], palmas->irq,
-			IRQF_ONESHOT | pdata->irq_flags, 0, &palmas_irq_chip,
-			&palmas->irq_data);
+				  IRQF_ONESHOT | pdata->irq_flags, 0,
+				  driver_data->irq_chip, &palmas->irq_data);
 	if (ret < 0)
 		goto err_i2c;
 
-- 
1.7.9.5

