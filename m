Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaJNG2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:28:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52198 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaJNG2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:28:18 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com
Subject: [RFC PATCH v3 2/5] regulator: act8865: Add support to turn off all outputs
Date: Tue, 14 Oct 2014 06:31:10 +0000
Message-Id: <1413268273-15151-2-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the property "poweroff-source" is found in the
devicetree, the function pm_power_off is defined. This function sends the
rights bit fields to the global off control register. shutdown/poweroff
commands are now supported for hardware components which use these PMU.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/regulator/act8865-regulator.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index afd06f9..76301ed 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -61,6 +61,8 @@
 #define	ACT8846_REG12_VSET	0xa0
 #define	ACT8846_REG12_CTRL	0xa1
 #define	ACT8846_REG13_CTRL	0xb1
+#define	ACT8846_GLB_OFF_CTRL	0xc3
+#define	ACT8846_OFF_SYSMASK	0x18
 
 /*
  * ACT8865 Global Register Map.
@@ -84,6 +86,7 @@
 #define	ACT8865_LDO3_CTRL	0x61
 #define	ACT8865_LDO4_VSET	0x64
 #define	ACT8865_LDO4_CTRL	0x65
+#define	ACT8865_MSTROFF		0x20
 
 /*
  * Field Definitions.
@@ -98,6 +101,8 @@
 
 struct act8865 {
 	struct regmap *regmap;
+	int off_reg;
+	int off_mask;
 };
 
 static const struct regmap_config act8865_regmap_config = {
@@ -275,6 +280,16 @@ static struct regulator_init_data
 	return NULL;
 }
 
+static struct i2c_client *act8865_i2c_client;
+static void act8865_power_off(void)
+{
+	struct act8865 *act8865;
+
+	act8865 = i2c_get_clientdata(act8865_i2c_client);
+	regmap_write(act8865->regmap, act8865->off_reg, act8865->off_mask);
+	while (1);
+}
+
 static int act8865_pmic_probe(struct i2c_client *client,
 			      const struct i2c_device_id *i2c_id)
 {
@@ -285,6 +300,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	int i, ret, num_regulators;
 	struct act8865 *act8865;
 	unsigned long type;
+	int off_reg, off_mask;
 
 	pdata = dev_get_platdata(dev);
 
@@ -304,10 +320,14 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	case ACT8846:
 		regulators = act8846_regulators;
 		num_regulators = ARRAY_SIZE(act8846_regulators);
+		off_reg = ACT8846_GLB_OFF_CTRL;
+		off_mask = ACT8846_OFF_SYSMASK;
 		break;
 	case ACT8865:
 		regulators = act8865_regulators;
 		num_regulators = ARRAY_SIZE(act8865_regulators);
+		off_reg = ACT8865_SYS_CTRL;
+		off_mask = ACT8865_MSTROFF;
 		break;
 	default:
 		dev_err(dev, "invalid device id %lu\n", type);
@@ -345,6 +365,17 @@ static int act8865_pmic_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	if (of_system_has_poweroff_source(dev->of_node)) {
+		if (!pm_power_off) {
+			act8865_i2c_client = client;
+			act8865->off_reg = off_reg;
+			act8865->off_mask = off_mask;
+			pm_power_off = act8865_power_off;
+		} else {
+			dev_err(dev, "Failed to set poweroff capability, already defined\n");
+		}
+	}
+
 	/* Finally register devices */
 	for (i = 0; i < num_regulators; i++) {
 		const struct regulator_desc *desc = &regulators[i];
-- 
1.9.1

