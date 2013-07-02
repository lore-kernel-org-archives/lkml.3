Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3GBRwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:52:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44219 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GBRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:52:04 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Tue,  2 Jul 2013 18:51:16 +0100
Message-Id: <1372787476-10145-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: sec: Add register cache for interrupt mask registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The performance of regmap-irq is improved if the interrupt mask registers
can be cached since it does read/modify/update cycles so start using the
register cache infrastructure for those registers. We should use this more
widely but I don't have a datasheet and this is a nice, conservative
starting point.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/sec-core.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 7976768..bbfc6c7 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -103,6 +103,31 @@ int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask)
 }
 EXPORT_SYMBOL_GPL(sec_reg_update);
 
+static bool s2mps11_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case S2MPS11_REG_INT1M:
+	case S2MPS11_REG_INT2M:
+	case S2MPS11_REG_INT3M:
+		return false;
+	default:
+		return true;
+	}
+}
+
+static bool s5m8763_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case S5M8763_REG_IRQM1:
+	case S5M8763_REG_IRQM2:
+	case S5M8763_REG_IRQM3:
+	case S5M8763_REG_IRQM4:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static struct regmap_config sec_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -113,6 +138,8 @@ static struct regmap_config s2mps11_regmap_config = {
 	.val_bits = 8,
 
 	.max_register = S2MPS11_REG_L38CTRL,
+	.volatile_reg = s2mps11_volatile,
+	.cache_type = REGCACHE_FLAT,
 };
 
 static struct regmap_config s5m8763_regmap_config = {
@@ -120,6 +147,8 @@ static struct regmap_config s5m8763_regmap_config = {
 	.val_bits = 8,
 
 	.max_register = S5M8763_REG_LBCNFG2,
+	.volatile_reg = s5m8763_volatile,
+	.cache_type = REGCACHE_FLAT,
 };
 
 static struct regmap_config s5m8767_regmap_config = {
@@ -127,6 +156,8 @@ static struct regmap_config s5m8767_regmap_config = {
 	.val_bits = 8,
 
 	.max_register = S5M8767_REG_LDO28CTRL,
+	.volatile_reg = s2mps11_volatile,
+	.cache_type = REGCACHE_FLAT,
 };
 
 #ifdef CONFIG_OF
-- 
1.8.3.1

