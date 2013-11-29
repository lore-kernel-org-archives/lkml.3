Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3K2OEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:04:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38351 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab3K2OED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:04:03 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 3/5] MFD: twl6040: reg_defaults support for regmap
Date: Fri, 29 Nov 2013 16:03:45 +0200
Message-ID: <1385733827-19831-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reg_defaults to regmap and at the same time implement proper power state
handling with using regcache_cache_only(), regcache_sync() and
regcache_mark_dirty().
This will make sure that we do not need to do restore operations in child
drivers anymore.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 0779d5a..51b6df1 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -44,6 +44,54 @@
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
 #define TWL6040_NUM_SUPPLIES	(2)
 
+static struct reg_default twl6040_defaults[] = {
+	{ 0x01, 0x4B }, /* REG_ASICID	(ro) */
+	{ 0x02, 0x00 }, /* REG_ASICREV	(ro) */
+	{ 0x03, 0x00 }, /* REG_INTID	*/
+	{ 0x04, 0x00 }, /* REG_INTMR	*/
+	{ 0x05, 0x00 }, /* REG_NCPCTRL	*/
+	{ 0x06, 0x00 }, /* REG_LDOCTL	*/
+	{ 0x07, 0x60 }, /* REG_HPPLLCTL	*/
+	{ 0x08, 0x00 }, /* REG_LPPLLCTL	*/
+	{ 0x09, 0x4A }, /* REG_LPPLLDIV	*/
+	{ 0x0A, 0x00 }, /* REG_AMICBCTL	*/
+	{ 0x0B, 0x00 }, /* REG_DMICBCTL	*/
+	{ 0x0C, 0x00 }, /* REG_MICLCTL	*/
+	{ 0x0D, 0x00 }, /* REG_MICRCTL	*/
+	{ 0x0E, 0x00 }, /* REG_MICGAIN	*/
+	{ 0x0F, 0x1B }, /* REG_LINEGAIN	*/
+	{ 0x10, 0x00 }, /* REG_HSLCTL	*/
+	{ 0x11, 0x00 }, /* REG_HSRCTL	*/
+	{ 0x12, 0x00 }, /* REG_HSGAIN	*/
+	{ 0x13, 0x00 }, /* REG_EARCTL	*/
+	{ 0x14, 0x00 }, /* REG_HFLCTL	*/
+	{ 0x15, 0x00 }, /* REG_HFLGAIN	*/
+	{ 0x16, 0x00 }, /* REG_HFRCTL	*/
+	{ 0x17, 0x00 }, /* REG_HFRGAIN	*/
+	{ 0x18, 0x00 }, /* REG_VIBCTLL	*/
+	{ 0x19, 0x00 }, /* REG_VIBDATL	*/
+	{ 0x1A, 0x00 }, /* REG_VIBCTLR	*/
+	{ 0x1B, 0x00 }, /* REG_VIBDATR	*/
+	{ 0x1C, 0x00 }, /* REG_HKCTL1	*/
+	{ 0x1D, 0x00 }, /* REG_HKCTL2	*/
+	{ 0x1E, 0x00 }, /* REG_GPOCTL	*/
+	{ 0x1F, 0x00 }, /* REG_ALB	*/
+	{ 0x20, 0x00 }, /* REG_DLB	*/
+	/* 0x28, REG_TRIM1 */
+	/* 0x29, REG_TRIM2 */
+	/* 0x2A, REG_TRIM3 */
+	/* 0x2B, REG_HSOTRIM */
+	/* 0x2C, REG_HFOTRIM */
+	{ 0x2D, 0x08 }, /* REG_ACCCTL	*/
+	{ 0x2E, 0x00 }, /* REG_STATUS	(ro) */
+};
+
+struct reg_default twl6040_patch[] = {
+	/* Select I2C bus access to dual access registers */
+	{ TWL6040_REG_ACCCTL, 0x09 },
+};
+
+
 static bool twl6040_has_vibra(struct device_node *node)
 {
 #ifdef CONFIG_OF
@@ -238,6 +286,9 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 		if (twl6040->power_count++)
 			goto out;
 
+		/* Allow writes to the chip */
+		regcache_cache_only(twl6040->regmap, false);
+
 		if (gpio_is_valid(twl6040->audpwron)) {
 			/* use automatic power-up sequence */
 			ret = twl6040_power_up_automatic(twl6040);
@@ -253,6 +304,10 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 				goto out;
 			}
 		}
+
+		/* Sync with the HW */
+		regcache_sync(twl6040->regmap);
+
 		/* Default PLL configuration after power up */
 		twl6040->pll = TWL6040_SYSCLK_SEL_LPPLL;
 		twl6040->sysclk = 19200000;
@@ -279,6 +334,11 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			/* use manual power-down sequence */
 			twl6040_power_down_manual(twl6040);
 		}
+
+		/* Set regmap to cache only and mark it as dirty */
+		regcache_cache_only(twl6040->regmap, true);
+		regcache_mark_dirty(twl6040->regmap);
+
 		twl6040->sysclk = 0;
 		twl6040->mclk = 0;
 	}
@@ -490,9 +550,24 @@ static bool twl6040_readable_reg(struct device *dev, unsigned int reg)
 static bool twl6040_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case TWL6040_REG_VIBCTLL:
-	case TWL6040_REG_VIBCTLR:
-	case TWL6040_REG_INTMR:
+	case TWL6040_REG_ASICID:
+	case TWL6040_REG_ASICREV:
+	case TWL6040_REG_INTID:
+	case TWL6040_REG_LPPLLCTL:
+	case TWL6040_REG_HPPLLCTL:
+	case TWL6040_REG_STATUS:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool twl6040_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case TWL6040_REG_ASICID:
+	case TWL6040_REG_ASICREV:
+	case TWL6040_REG_STATUS:
 		return false;
 	default:
 		return true;
@@ -502,10 +577,15 @@ static bool twl6040_volatile_reg(struct device *dev, unsigned int reg)
 static struct regmap_config twl6040_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
+
+	.reg_defaults = twl6040_defaults,
+	.num_reg_defaults = ARRAY_SIZE(twl6040_defaults),
+
 	.max_register = TWL6040_REG_STATUS, /* 0x2e */
 
 	.readable_reg = twl6040_readable_reg,
 	.volatile_reg = twl6040_volatile_reg,
+	.writeable_reg = twl6040_writeable_reg,
 
 	.cache_type = REGCACHE_RBTREE,
 };
@@ -624,6 +704,8 @@ static int twl6040_probe(struct i2c_client *client,
 
 	/* dual-access registers controlled by I2C only */
 	twl6040_set_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_I2CSEL);
+	regmap_register_patch(twl6040->regmap, twl6040_patch,
+			      ARRAY_SIZE(twl6040_patch));
 
 	/*
 	 * The main functionality of twl6040 to provide audio on OMAP4+ systems.
@@ -656,6 +738,10 @@ static int twl6040_probe(struct i2c_client *client,
 	cell->name = "twl6040-gpo";
 	children++;
 
+	/* The chip is powered down so mark regmap to cache only and dirty */
+	regcache_cache_only(twl6040->regmap, true);
+	regcache_mark_dirty(twl6040->regmap);
+
 	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
 			      NULL, 0, NULL);
 	if (ret)
-- 
1.8.4.2

