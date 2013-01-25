Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3AYIhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:37:54 -0500
Received: from [216.32.180.13] ([216.32.180.13]:13299 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab3AYIhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:37:51 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1hbe9i1155h)
Subject: [PATCH v1/1] mfd: i2c issue fix for da9052/53
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jan 2013 14:03:49 +0530
Message-ID: <1359102829.6620.10.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue has been reported where the PMIC either locks up or fails to
respond following a system Reset. This could result in a second write
in which the bus writes the current content of the write buffer to address
of the last I2C access.

The failure case is where this unwanted write transfers incorrect data to
a critical register.

This patch fixes this issue to by following any read or write with a dummy read
to a safe register address. A safe register address is one where the contents
will not affect the operation of the system.

Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/da9052-i2c.c          |   61 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h |   66 ++++++++++++++++++++++++++++++++++--
 include/linux/mfd/da9052/reg.h    |    3 ++
 3 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index ac74a4d..885e567 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -27,6 +27,66 @@
 #include <linux/of_device.h>
 #endif
 
+/* I2C safe register check */
+static inline bool i2c_safe_reg(unsigned char reg)
+{
+	switch (reg) {
+	case DA9052_STATUS_A_REG:
+	case DA9052_STATUS_B_REG:
+	case DA9052_STATUS_C_REG:
+	case DA9052_STATUS_D_REG:
+	case DA9052_ADC_RES_L_REG:
+	case DA9052_ADC_RES_H_REG:
+	case DA9052_VDD_RES_REG:
+	case DA9052_ICHG_AV_REG:
+	case DA9052_TBAT_RES_REG:
+	case DA9052_ADCIN4_RES_REG:
+	case DA9052_ADCIN5_RES_REG:
+	case DA9052_ADCIN6_RES_REG:
+	case DA9052_TJUNC_RES_REG:
+	case DA9052_TSI_X_MSB_REG:
+	case DA9052_TSI_Y_MSB_REG:
+	case DA9052_TSI_LSB_REG:
+	case DA9052_TSI_Z_MSB_REG:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * There is an issue with DA9052 and DA9053_AA/BA/BB PMIC where the PMIC
+ * gets lockup up or fails to respond following a system reset.
+ * This fix is to follow any read or write with a dummy read to a safe
+ * register.
+ */
+int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
+{
+	int val;
+
+	switch (da9052->chip_id) {
+	case DA9052:
+	case DA9053_AA:
+	case DA9053_BA:
+	case DA9053_BB:
+		/* A dummy read to a safe register address. */
+	if (!i2c_safe_reg(reg))
+			return regmap_read(da9052->regmap,
+					   DA9052_PARK_REGISTER,
+					   &val);
+		break;
+	default:
+		/*
+		 * For other chips parking of I2C register
+		 * to a safe place is not required.
+		 */
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(da9052_i2c_fix);
+
 static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 {
 	int reg_val, ret;
@@ -83,6 +143,7 @@ static int da9052_i2c_probe(struct i2c_client *client,
 
 	da9052->dev = &client->dev;
 	da9052->chip_irq = client->irq;
+	da9052->fix_io = da9052_i2c_fix;
 
 	i2c_set_clientdata(client, da9052);
 
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 86dd93d..786d02e 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -99,6 +99,9 @@ struct da9052 {
 	u8 chip_id;
 
 	int chip_irq;
+
+	/* SOC I/O transfer related fixes for DA9052/53 */
+	int (*fix_io) (struct da9052 *da9052, unsigned char reg);
 };
 
 /* ADC API */
@@ -113,32 +116,87 @@ static inline int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
 	ret = regmap_read(da9052->regmap, reg, &val);
 	if (ret < 0)
 		return ret;
+
+	if (da9052->fix_io) {
+		ret = da9052->fix_io(da9052, reg);
+		if (ret < 0)
+			return ret;
+	}
+
 	return val;
 }
 
 static inline int da9052_reg_write(struct da9052 *da9052, unsigned char reg,
 				    unsigned char val)
 {
-	return regmap_write(da9052->regmap, reg, val);
+	int ret;
+
+	ret = regmap_write(da9052->regmap, reg, val);
+	if (ret < 0)
+		return ret;
+
+	if (da9052->fix_io) {
+		ret = da9052->fix_io(da9052, reg);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
 }
 
 static inline int da9052_group_read(struct da9052 *da9052, unsigned char reg,
 				     unsigned reg_cnt, unsigned char *val)
 {
-	return regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
+	int ret;
+
+	ret = regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
+	if (ret < 0)
+		return ret;
+
+	if (da9052->fix_io) {
+		ret = da9052->fix_io(da9052, reg);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
 }
 
 static inline int da9052_group_write(struct da9052 *da9052, unsigned char reg,
 				      unsigned reg_cnt, unsigned char *val)
 {
-	return regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
+	int ret;
+
+	ret = regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
+	if (ret < 0)
+		return ret;
+
+	if (da9052->fix_io) {
+		ret = da9052->fix_io(da9052, reg);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
 }
 
 static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
 				     unsigned char bit_mask,
 				     unsigned char reg_val)
 {
-	return regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
+	int ret;
+
+	ret = regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
+	if (ret < 0)
+		return ret;
+
+	if (da9052->fix_io) {
+		ret = da9052->fix_io(da9052, reg);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
 }
 
 int da9052_device_init(struct da9052 *da9052, u8 chip_id);
diff --git a/include/linux/mfd/da9052/reg.h b/include/linux/mfd/da9052/reg.h
index b97f730..c4dd3a8 100644
--- a/include/linux/mfd/da9052/reg.h
+++ b/include/linux/mfd/da9052/reg.h
@@ -34,6 +34,9 @@
 #define DA9052_STATUS_C_REG		3
 #define DA9052_STATUS_D_REG		4
 
+/* PARK REGISTER */
+#define DA9052_PARK_REGISTER		DA9052_STATUS_D_REG
+
 /* EVENT REGISTERS */
 #define DA9052_EVENT_A_REG		5
 #define DA9052_EVENT_B_REG		6
-- 
1.7.0.4


