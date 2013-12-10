Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3LJXgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:36:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37903 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3LJXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:35:30 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 8/8] mfd: pm8921: Use ssbi regmap
Date: Tue, 10 Dec 2013 15:35:23 -0800
Message-Id: <1386718523-2587-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a regmap so that the pm8xxx read/write APIs can be removed
once all consumer drivers are converted.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/Kconfig       |  1 +
 drivers/mfd/pm8921-core.c | 70 +++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 35007ed..87d8e1b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -455,6 +455,7 @@ config MFD_PM8921_CORE
 	depends on (ARCH_MSM || HEXAGON)
 	select MFD_CORE
 	select MFD_PM8XXX
+	select REGMAP_SSBI
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in PM8921 PMIC chip.
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 7ea6c7a..d1d996e 100644
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
@@ -60,6 +61,7 @@ struct pm8921 {
 
 struct pm_irq_chip {
 	struct device		*dev;
+	struct regmap		*regmap;
 	spinlock_t		pm_irq_lock;
 	struct irq_domain	*domain;
 	unsigned int		num_irqs;
@@ -68,29 +70,19 @@ struct pm_irq_chip {
 	u8			config[0];
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
@@ -98,19 +90,20 @@ bail:
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
@@ -121,7 +114,7 @@ bail:
 static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 {
 	int pmirq, irq, i, ret = 0;
-	u8 bits;
+	unsigned int bits;
 
 	ret = pm8xxx_read_block_irq(chip, block, &bits);
 	if (ret) {
@@ -146,10 +139,11 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 
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
@@ -171,12 +165,12 @@ static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
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
@@ -281,7 +275,7 @@ static struct irq_chip pm8xxx_irq_chip = {
 static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
 {
 	int pmirq, rc;
-	u8  block, bits, bit;
+	unsigned int  block, bits, bit;
 	unsigned long flags;
 	struct irq_data *irq_data = irq_get_irq_data(irq);
 
@@ -292,14 +286,14 @@ static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
 
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
@@ -338,8 +332,8 @@ static const struct irq_domain_ops pm8xxx_irq_domain_ops = {
 	.map = pm8xxx_irq_domain_map,
 };
 
-static int pm8xxx_irq_init(struct platform_device *pdev, unsigned int irq,
-			   unsigned int nirqs)
+static int pm8xxx_irq_init(struct platform_device *pdev, struct regmap *regmap,
+			   unsigned int irq, unsigned int nirqs)
 {
 	struct pm_irq_chip  *chip;
 
@@ -348,7 +342,7 @@ static int pm8xxx_irq_init(struct platform_device *pdev, unsigned int irq,
 	if (!chip)
 		return -ENOMEM;
 
-	chip->dev = &pdev->dev;
+	chip->regmap = regmap;
 	chip->num_irqs = nirqs;
 	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
 	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
@@ -417,11 +411,19 @@ static struct pm8xxx_drvdata pm8921_drvdata = {
 	.pmic_read_irq_stat	= pm8921_read_irq_stat,
 };
 
+static const struct regmap_config ssbi_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 8,
+	.max_register = 0x3ff,
+	.fast_io = true,
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
 
@@ -436,8 +438,12 @@ static int pm8921_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	regmap = devm_regmap_init_ssbi(&pdev->dev, &ssbi_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
 	/* Read PMIC chip revision */
-	rc = ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
+	rc = regmap_read(regmap, REG_HWREV, &val);
 	if (rc) {
 		pr_err("Failed to read hw rev reg %d:rc=%d\n", REG_HWREV, rc);
 		return rc;
@@ -446,7 +452,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	rev = val;
 
 	/* Read PMIC chip revision 2 */
-	rc = ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
+	rc = regmap_read(regmap, REG_HWREV_2, &val);
 	if (rc) {
 		pr_err("Failed to read hw rev 2 reg %d:rc=%d\n",
 			REG_HWREV_2, rc);
@@ -459,7 +465,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	pm8921_drvdata.pm_chip_data = pmic;
 	platform_set_drvdata(pdev, &pm8921_drvdata);
 
-	rc = pm8xxx_irq_init(pdev, irq, 256);
+	rc = pm8xxx_irq_init(pdev, regmap, irq, 256);
 	if (rc)
 		return rc;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

