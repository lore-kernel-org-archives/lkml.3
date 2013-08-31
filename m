Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3HaQsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 12:48:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60567 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3HaQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 12:48:49 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 17:48:19 +0100
Message-Id: <1377967699-10277-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: twl6040: Use regmap for register cache
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Rather then open coding a cache of the vibra control registers use the
regmap cache code.  Also cache the interrupt mask register, providing
a small performance improvement for the interrupt code.

Signed-off-by: Mark Brown <broonie@linaro.org>
---

I'm hoping to have some ASoC improvements to build on top of this (there
is ASoC level register caching for the device) so it might make sense to
apply this via ASoC.

 drivers/mfd/twl6040.c       | 43 ++++++++++++++++++++++++++++++-------------
 include/linux/mfd/twl6040.h |  1 -
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 4d8d3b7..daf6694 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -58,15 +58,9 @@ int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 	int ret;
 	unsigned int val;
 
-	/* Vibra control registers from cache */
-	if (unlikely(reg == TWL6040_REG_VIBCTLL ||
-		     reg == TWL6040_REG_VIBCTLR)) {
-		val = twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)];
-	} else {
-		ret = regmap_read(twl6040->regmap, reg, &val);
-		if (ret < 0)
-			return ret;
-	}
+	ret = regmap_read(twl6040->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
 
 	return val;
 }
@@ -77,9 +71,6 @@ int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
 	int ret;
 
 	ret = regmap_write(twl6040->regmap, reg, val);
-	/* Cache the vibra control registers */
-	if (reg == TWL6040_REG_VIBCTLL || reg == TWL6040_REG_VIBCTLR)
-		twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)] = val;
 
 	return ret;
 }
@@ -456,9 +447,20 @@ EXPORT_SYMBOL(twl6040_get_sysclk);
 /* Get the combined status of the vibra control register */
 int twl6040_get_vibralr_status(struct twl6040 *twl6040)
 {
+	unsigned int reg;
+	int ret;
 	u8 status;
 
-	status = twl6040->vibra_ctrl_cache[0] | twl6040->vibra_ctrl_cache[1];
+	ret = regmap_read(twl6040->regmap, TWL6040_REG_VIBCTLL, &reg);
+	if (ret != 0)
+		return ret;
+	status = reg;
+
+	ret = regmap_read(twl6040->regmap, TWL6040_REG_VIBCTLR, &reg);
+	if (ret != 0)
+		return ret;
+	status |= reg;
+
 	status &= (TWL6040_VIBENA | TWL6040_VIBSEL);
 
 	return status;
@@ -485,12 +487,27 @@ static bool twl6040_readable_reg(struct device *dev, unsigned int reg)
 	return true;
 }
 
+static bool twl6040_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case TWL6040_REG_VIBCTLL:
+	case TWL6040_REG_VIBCTLR:
+	case TWL6040_REG_INTMR:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static struct regmap_config twl6040_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = TWL6040_REG_STATUS, /* 0x2e */
 
 	.readable_reg = twl6040_readable_reg,
+	.volatile_reg = twl6040_volatile_reg,
+
+	.cache_type = REGCACHE_RBTREE,
 };
 
 static const struct regmap_irq twl6040_irqs[] = {
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 6dd8893..81f639b 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -230,7 +230,6 @@ struct twl6040 {
 	int audpwron;
 	int power_count;
 	int rev;
-	u8 vibra_ctrl_cache[2];
 
 	/* PLL configuration */
 	int pll;
-- 
1.8.4.rc3

