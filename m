Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaAHSiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:38:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60482 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbaAHSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:37:56 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 5/7] mfd: pm8921: Use ssbi regmap
Date: Wed,  8 Jan 2014 10:37:48 -0800
Message-Id: <1389206270-3728-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a regmap so that the pm8xxx read/write APIs can be removed
once all consumer drivers are converted.

Reviewed-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/Kconfig       |  1 +
 drivers/mfd/pm8921-core.c | 66 +++++++++++++++++++++++++++--------------------
 2 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 03bb43bb40b9..d33bc35d13a2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -467,6 +467,7 @@ config MFD_PM8921_CORE
 	depends on (ARCH_MSM || HEXAGON)
 	select MFD_CORE
 	select MFD_PM8XXX
+	select REGMAP
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in PM8921 PMIC chip.
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index c25e7dae150b..e9340bd6d1ab 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/ssbi.h>
+#include <linux/regmap.h>
 #include <linux/of_platform.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/pm8xxx/core.h>
@@ -57,6 +58,7 @@
 
 struct pm_irq_chip {
 	struct device		*dev;
+	struct regmap		*regmap;
 	spinlock_t		pm_irq_lock;
 	struct irq_domain	*irqdomain;
 	unsigned int		num_irqs;
@@ -70,29 +72,19 @@ struct pm8921 {
 	struct pm_irq_chip		*irq_chip;
 };
 
-static int pm8xxx_read_root_irq(const struct pm_irq_chip *chip, u8 *rp)
-{
-	return pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_ROOT, rp);
-}
-
-static int pm8xxx_read_master_irq(const struct pm_irq_chip *chip, u8 m, u8 *bp)
-{
-	return pm8xxx_readb(chip->dev,
-			SSBI_REG_ADDR_IRQ_M_STATUS1 + m, bp);
-}
-
-static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, u8 bp, u8 *ip)
+static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, unsigned int bp,
+				 unsigned int *ip)
 {
 	int	rc;
 
 	spin_lock(&chip->pm_irq_lock);
-	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
+	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
 	if (rc) {
 		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
 		goto bail;
 	}
 
-	rc = pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
+	rc = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
 	if (rc)
 		pr_err("Failed Reading Status rc=%d\n", rc);
 bail:
@@ -100,19 +92,20 @@ bail:
 	return rc;
 }
 
-static int pm8xxx_config_irq(struct pm_irq_chip *chip, u8 bp, u8 cp)
+static int
+pm8xxx_config_irq(struct pm_irq_chip *chip, unsigned int bp, unsigned int cp)
 {
 	int	rc;
 
 	spin_lock(&chip->pm_irq_lock);
-	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
+	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
 	if (rc) {
 		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
 		goto bail;
 	}
 
 	cp |= PM_IRQF_WRITE;
-	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_CONFIG, cp);
+	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_CONFIG, cp);
 	if (rc)
 		pr_err("Failed Configuring IRQ rc=%d\n", rc);
 bail:
@@ -123,7 +116,7 @@ bail:
 static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 {
 	int pmirq, irq, i, ret = 0;
-	u8 bits;
+	unsigned int bits;
 
 	ret = pm8xxx_read_block_irq(chip, block, &bits);
 	if (ret) {
@@ -148,10 +141,11 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 
 static int pm8xxx_irq_master_handler(struct pm_irq_chip *chip, int master)
 {
-	u8 blockbits;
+	unsigned int blockbits;
 	int block_number, i, ret = 0;
 
-	ret = pm8xxx_read_master_irq(chip, master, &blockbits);
+	ret = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_M_STATUS1 + master,
+			  &blockbits);
 	if (ret) {
 		pr_err("Failed to read master %d ret=%d\n", master, ret);
 		return ret;
@@ -173,12 +167,12 @@ static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct pm_irq_chip *chip = irq_desc_get_handler_data(desc);
 	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
-	u8	root;
+	unsigned int root;
 	int	i, ret, masters = 0;
 
 	chained_irq_enter(irq_chip, desc);
 
-	ret = pm8xxx_read_root_irq(chip, &root);
+	ret = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_ROOT, &root);
 	if (ret) {
 		pr_err("Can't read root status ret=%d\n", ret);
 		return;
@@ -283,7 +277,7 @@ static struct irq_chip pm8xxx_irq_chip = {
 static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
 {
 	int pmirq, rc;
-	u8  block, bits, bit;
+	unsigned int  block, bits, bit;
 	unsigned long flags;
 	struct irq_data *irq_data = irq_get_irq_data(irq);
 
@@ -294,14 +288,14 @@ static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
 
 	spin_lock_irqsave(&chip->pm_irq_lock, flags);
 
-	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_BLK_SEL, block);
+	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_BLK_SEL, block);
 	if (rc) {
 		pr_err("Failed Selecting block irq=%d pmirq=%d blk=%d rc=%d\n",
 			irq, pmirq, block, rc);
 		goto bail_out;
 	}
 
-	rc = pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
+	rc = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
 	if (rc) {
 		pr_err("Failed Configuring irq=%d pmirq=%d blk=%d rc=%d\n",
 			irq, pmirq, block, rc);
@@ -389,11 +383,21 @@ static struct pm8xxx_drvdata pm8921_drvdata = {
 	.pmic_read_irq_stat	= pm8921_read_irq_stat,
 };
 
+static const struct regmap_config ssbi_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 8,
+	.max_register = 0x3ff,
+	.fast_io = true,
+	.reg_read = ssbi_reg_read,
+	.reg_write = ssbi_reg_write
+};
+
 static int pm8921_probe(struct platform_device *pdev)
 {
 	struct pm8921 *pmic;
+	struct regmap *regmap;
 	int rc;
-	u8 val;
+	unsigned int val;
 	unsigned int irq;
 	u32 rev;
 	struct pm_irq_chip *chip;
@@ -409,8 +413,13 @@ static int pm8921_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	regmap = devm_regmap_init(&pdev->dev, NULL, pdev->dev.parent,
+				  &ssbi_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
 	/* Read PMIC chip revision */
-	rc = ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
+	rc = regmap_read(regmap, REG_HWREV, &val);
 	if (rc) {
 		pr_err("Failed to read hw rev reg %d:rc=%d\n", REG_HWREV, rc);
 		return rc;
@@ -419,7 +428,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	rev = val;
 
 	/* Read PMIC chip revision 2 */
-	rc = ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
+	rc = regmap_read(regmap, REG_HWREV_2, &val);
 	if (rc) {
 		pr_err("Failed to read hw rev 2 reg %d:rc=%d\n",
 			REG_HWREV_2, rc);
@@ -440,6 +449,7 @@ static int pm8921_probe(struct platform_device *pdev)
 
 	pmic->irq_chip = chip;
 	chip->dev = &pdev->dev;
+	chip->regmap = regmap;
 	chip->num_irqs = nirqs;
 	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
 	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

