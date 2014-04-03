Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaDCNCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:02:41 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.173]:43823 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbaDCNCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:02:39 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 09:02:39 EDT
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-12.tower-39.messagelabs.com!1396529773!14994626!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201404031256.s33Cu991061898@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Thu, 3 Apr 2014 13:47:22 +0100
Subject: [PATCH V1] drivers/mfd: da9052: use multiwrite mode
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Support Opensource <support.opensource@diasemi.com>
CC: <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new regmap core API regmap_multi_reg_write(), to prevent a rare
problem with the Dialog DA9052/3 PMIC devices that causes the device to
fail.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140403

Even though the probability of the problem occurring is exceedingly rare,
the consequences are a bricked device and so this workround is essential.

The patch has been tested using the RTC ALARM function in conjuctions with
an I2C logic analyser.

 drivers/mfd/da9052-i2c.c          |   34 +++++++++-------------------------
 include/linux/mfd/da9052/da9052.h |   24 ++++++++++++++++--------
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 6da8ec8..ca6b4f6 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -87,27 +87,11 @@ static int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
 	return 0;
 }
 
-/*
- * According to errata item 24, multiwrite mode should be avoided
- * in order to prevent register data corruption after power-down.
- */
-static int da9052_i2c_disable_multiwrite(struct da9052 *da9052)
+static int da9052_i2c_config_multiwrite(struct da9052 *da9052, bool enable)
 {
-	int reg_val, ret;
-
-	ret = regmap_read(da9052->regmap, DA9052_CONTROL_B_REG, &reg_val);
-	if (ret < 0)
-		return ret;
-
-	if (!(reg_val & DA9052_CONTROL_B_WRITEMODE)) {
-		reg_val |= DA9052_CONTROL_B_WRITEMODE;
-		ret = regmap_write(da9052->regmap, DA9052_CONTROL_B_REG,
-				   reg_val);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
+	return regmap_update_bits(da9052->regmap, DA9052_CONTROL_B_REG,
+				DA9052_CONTROL_B_WRITEMODE,
+				enable ? 0xFF : 0);
 }
 
 static const struct i2c_device_id da9052_i2c_id[] = {
@@ -153,6 +137,8 @@ static int da9052_i2c_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, da9052);
 
+	da9052_regmap_config.can_multi_write = true;
+
 	da9052->regmap = devm_regmap_init_i2c(client, &da9052_regmap_config);
 	if (IS_ERR(da9052->regmap)) {
 		ret = PTR_ERR(da9052->regmap);
@@ -161,7 +147,8 @@ static int da9052_i2c_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	ret = da9052_i2c_disable_multiwrite(da9052);
+	ret = da9052_i2c_config_multiwrite(da9052,
+					da9052_regmap_config.can_multi_write);
 	if (ret < 0)
 		return ret;
 
@@ -182,10 +169,7 @@ static int da9052_i2c_probe(struct i2c_client *client,
 	}
 
 	ret = da9052_device_init(da9052, id->driver_data);
-	if (ret != 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static int da9052_i2c_remove(struct i2c_client *client)
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index bba65f5..967c802 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -172,20 +172,28 @@ static inline int da9052_group_write(struct da9052 *da9052, unsigned char reg,
 				      unsigned reg_cnt, unsigned char *val)
 {
 	int ret;
+	unsigned char r = reg;
+	struct reg_default *regs;
 	int i;
 
+	regs = kmalloc(sizeof(struct reg_default)*reg_cnt, GFP_KERNEL);
+	if (!regs)
+		return -ENOMEM;
+
 	for (i = 0; i < reg_cnt; i++) {
-		ret = regmap_write(da9052->regmap, reg + i, val[i]);
-		if (ret < 0)
-			return ret;
+		regs[i].reg = r++;
+		regs[i].def = val[i];
 	}
 
-	if (da9052->fix_io) {
-		ret = da9052->fix_io(da9052, reg);
-		if (ret < 0)
-			return ret;
-	}
+	ret = regmap_multi_reg_write(da9052->regmap, regs, reg_cnt);
+
+	kfree(regs);
+
+	if (ret < 0)
+		return ret;
 
+	if (da9052->fix_io)
+		ret = da9052->fix_io(da9052, reg+reg_cnt-1);
 	return ret;
 }
 
-- 
end-of-patch 1/1 for drivers/mfd: da9052: use multiwrite mode V1

