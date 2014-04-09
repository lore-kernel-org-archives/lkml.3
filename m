Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbaDIAOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:14:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54528 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbaDIAOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:14:20 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: pm8921: Remove pm8xxx API now that sub-devices use regmap
Date: Tue,  8 Apr 2014 17:14:15 -0700
Message-Id: <1397002455-12854-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm8xxx read/write wrappers are no longer necessary now that
all the sub-device drivers are using the regmap API. Remove it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Based on Linus' tip as of a7963eb7f4c4 (Merge branch 'for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs, 2014-04-07)

 drivers/mfd/pm8921-core.c       | 123 +---------------------------------------
 include/linux/mfd/pm8xxx/core.h |  81 --------------------------
 2 files changed, 2 insertions(+), 202 deletions(-)
 delete mode 100644 include/linux/mfd/pm8xxx/core.h

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index b97a97187ae9..959513803542 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -26,7 +26,6 @@
 #include <linux/regmap.h>
 #include <linux/of_platform.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/pm8xxx/core.h>
 
 #define	SSBI_REG_ADDR_IRQ_BASE		0x1BB
 
@@ -57,7 +56,6 @@
 #define PM8921_NR_IRQS		256
 
 struct pm_irq_chip {
-	struct device		*dev;
 	struct regmap		*regmap;
 	spinlock_t		pm_irq_lock;
 	struct irq_domain	*irqdomain;
@@ -67,11 +65,6 @@ struct pm_irq_chip {
 	u8			config[0];
 };
 
-struct pm8921 {
-	struct device			*dev;
-	struct pm_irq_chip		*irq_chip;
-};
-
 static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, unsigned int bp,
 				 unsigned int *ip)
 {
@@ -255,55 +248,6 @@ static struct irq_chip pm8xxx_irq_chip = {
 	.flags		= IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_SKIP_SET_WAKE,
 };
 
-/**
- * pm8xxx_get_irq_stat - get the status of the irq line
- * @chip: pointer to identify a pmic irq controller
- * @irq: the irq number
- *
- * The pm8xxx gpio and mpp rely on the interrupt block to read
- * the values on their pins. This function is to facilitate reading
- * the status of a gpio or an mpp line. The caller has to convert the
- * gpio number to irq number.
- *
- * RETURNS:
- * an int indicating the value read on that line
- */
-static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
-{
-	int pmirq, rc;
-	unsigned int  block, bits, bit;
-	unsigned long flags;
-	struct irq_data *irq_data = irq_get_irq_data(irq);
-
-	pmirq = irq_data->hwirq;
-
-	block = pmirq / 8;
-	bit = pmirq % 8;
-
-	spin_lock_irqsave(&chip->pm_irq_lock, flags);
-
-	rc = regmap_write(chip->regmap, SSBI_REG_ADDR_IRQ_BLK_SEL, block);
-	if (rc) {
-		pr_err("Failed Selecting block irq=%d pmirq=%d blk=%d rc=%d\n",
-			irq, pmirq, block, rc);
-		goto bail_out;
-	}
-
-	rc = regmap_read(chip->regmap, SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
-	if (rc) {
-		pr_err("Failed Configuring irq=%d pmirq=%d blk=%d rc=%d\n",
-			irq, pmirq, block, rc);
-		goto bail_out;
-	}
-
-	rc = (bits & (1 << bit)) ? 1 : 0;
-
-bail_out:
-	spin_unlock_irqrestore(&chip->pm_irq_lock, flags);
-
-	return rc;
-}
-
 static int pm8xxx_irq_domain_map(struct irq_domain *d, unsigned int irq,
 				   irq_hw_number_t hwirq)
 {
@@ -324,56 +268,6 @@ static const struct irq_domain_ops pm8xxx_irq_domain_ops = {
 	.map = pm8xxx_irq_domain_map,
 };
 
-static int pm8921_readb(const struct device *dev, u16 addr, u8 *val)
-{
-	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
-	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
-
-	return ssbi_read(pmic->dev->parent, addr, val, 1);
-}
-
-static int pm8921_writeb(const struct device *dev, u16 addr, u8 val)
-{
-	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
-	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
-
-	return ssbi_write(pmic->dev->parent, addr, &val, 1);
-}
-
-static int pm8921_read_buf(const struct device *dev, u16 addr, u8 *buf,
-									int cnt)
-{
-	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
-	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
-
-	return ssbi_read(pmic->dev->parent, addr, buf, cnt);
-}
-
-static int pm8921_write_buf(const struct device *dev, u16 addr, u8 *buf,
-									int cnt)
-{
-	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
-	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
-
-	return ssbi_write(pmic->dev->parent, addr, buf, cnt);
-}
-
-static int pm8921_read_irq_stat(const struct device *dev, int irq)
-{
-	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
-	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
-
-	return pm8xxx_get_irq_stat(pmic->irq_chip, irq);
-}
-
-static struct pm8xxx_drvdata pm8921_drvdata = {
-	.pmic_readb		= pm8921_readb,
-	.pmic_writeb		= pm8921_writeb,
-	.pmic_read_buf		= pm8921_read_buf,
-	.pmic_write_buf		= pm8921_write_buf,
-	.pmic_read_irq_stat	= pm8921_read_irq_stat,
-};
-
 static const struct regmap_config ssbi_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 8,
@@ -392,7 +286,6 @@ MODULE_DEVICE_TABLE(of, pm8921_id_table);
 
 static int pm8921_probe(struct platform_device *pdev)
 {
-	struct pm8921 *pmic;
 	struct regmap *regmap;
 	int irq, rc;
 	unsigned int val;
@@ -404,12 +297,6 @@ static int pm8921_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	pmic = devm_kzalloc(&pdev->dev, sizeof(struct pm8921), GFP_KERNEL);
-	if (!pmic) {
-		pr_err("Cannot alloc pm8921 struct\n");
-		return -ENOMEM;
-	}
-
 	regmap = devm_regmap_init(&pdev->dev, NULL, pdev->dev.parent,
 				  &ssbi_regmap_config);
 	if (IS_ERR(regmap))
@@ -434,18 +321,13 @@ static int pm8921_probe(struct platform_device *pdev)
 	pr_info("PMIC revision 2: %02X\n", val);
 	rev |= val << BITS_PER_BYTE;
 
-	pmic->dev = &pdev->dev;
-	pm8921_drvdata.pm_chip_data = pmic;
-	platform_set_drvdata(pdev, &pm8921_drvdata);
-
 	chip = devm_kzalloc(&pdev->dev, sizeof(*chip) +
 					sizeof(chip->config[0]) * nirqs,
 					GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
-	pmic->irq_chip = chip;
-	chip->dev = &pdev->dev;
+	platform_set_drvdata(pdev, chip);
 	chip->regmap = regmap;
 	chip->num_irqs = nirqs;
 	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
@@ -481,8 +363,7 @@ static int pm8921_remove_child(struct device *dev, void *unused)
 static int pm8921_remove(struct platform_device *pdev)
 {
 	int irq = platform_get_irq(pdev, 0);
-	struct pm8921 *pmic = pm8921_drvdata.pm_chip_data;
-	struct pm_irq_chip *chip = pmic->irq_chip;
+	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
 
 	device_for_each_child(&pdev->dev, NULL, pm8921_remove_child);
 	irq_set_chained_handler(irq, NULL);
diff --git a/include/linux/mfd/pm8xxx/core.h b/include/linux/mfd/pm8xxx/core.h
deleted file mode 100644
index bd2f4f64e931..000000000000
--- a/include/linux/mfd/pm8xxx/core.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-/*
- * Qualcomm PMIC 8xxx driver header file
- *
- */
-
-#ifndef __MFD_PM8XXX_CORE_H
-#define __MFD_PM8XXX_CORE_H
-
-#include <linux/mfd/core.h>
-
-struct pm8xxx_drvdata {
-	int	(*pmic_readb) (const struct device *dev, u16 addr, u8 *val);
-	int	(*pmic_writeb) (const struct device *dev, u16 addr, u8 val);
-	int	(*pmic_read_buf) (const struct device *dev, u16 addr, u8 *buf,
-									int n);
-	int	(*pmic_write_buf) (const struct device *dev, u16 addr, u8 *buf,
-									int n);
-	int	(*pmic_read_irq_stat) (const struct device *dev, int irq);
-	void	*pm_chip_data;
-};
-
-static inline int pm8xxx_readb(const struct device *dev, u16 addr, u8 *val)
-{
-	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
-
-	if (!dd)
-		return -EINVAL;
-	return dd->pmic_readb(dev, addr, val);
-}
-
-static inline int pm8xxx_writeb(const struct device *dev, u16 addr, u8 val)
-{
-	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
-
-	if (!dd)
-		return -EINVAL;
-	return dd->pmic_writeb(dev, addr, val);
-}
-
-static inline int pm8xxx_read_buf(const struct device *dev, u16 addr, u8 *buf,
-									int n)
-{
-	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
-
-	if (!dd)
-		return -EINVAL;
-	return dd->pmic_read_buf(dev, addr, buf, n);
-}
-
-static inline int pm8xxx_write_buf(const struct device *dev, u16 addr, u8 *buf,
-									int n)
-{
-	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
-
-	if (!dd)
-		return -EINVAL;
-	return dd->pmic_write_buf(dev, addr, buf, n);
-}
-
-static inline int pm8xxx_read_irq_stat(const struct device *dev, int irq)
-{
-	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
-
-	if (!dd)
-		return -EINVAL;
-	return dd->pmic_read_irq_stat(dev, irq);
-}
-
-#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

