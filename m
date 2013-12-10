Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3LJXgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:36:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37900 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3LJXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:35:30 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/8] mfd: pm8921: Migrate to irqdomains
Date: Tue, 10 Dec 2013 15:35:22 -0800
Message-Id: <1386718523-2587-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this driver to use irqdomains so that the PMIC's child
devices can be converted to devicetree.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/pm8921-core.c         | 186 ++++++++++++++------------------------
 include/linux/mfd/pm8xxx/irq.h    |  59 ------------
 include/linux/mfd/pm8xxx/pm8921.h |  30 ------
 3 files changed, 66 insertions(+), 209 deletions(-)
 delete mode 100644 include/linux/mfd/pm8xxx/irq.h
 delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 083fab2..7ea6c7a 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -17,15 +17,15 @@
 #include <linux/interrupt.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/ssbi.h>
+#include <linux/of_platform.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/pm8xxx/pm8921.h>
 #include <linux/mfd/pm8xxx/core.h>
-#include <linux/mfd/pm8xxx/irq.h>
 
 #define	SSBI_REG_ADDR_IRQ_BASE		0x1BB
 
@@ -61,8 +61,7 @@ struct pm8921 {
 struct pm_irq_chip {
 	struct device		*dev;
 	spinlock_t		pm_irq_lock;
-	unsigned int		devirq;
-	unsigned int		irq_base;
+	struct irq_domain	*domain;
 	unsigned int		num_irqs;
 	unsigned int		num_blocks;
 	unsigned int		num_masters;
@@ -138,7 +137,7 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 	for (i = 0; i < 8; i++) {
 		if (bits & (1 << i)) {
 			pmirq = block * 8 + i;
-			irq = pmirq + chip->irq_base;
+			irq = irq_find_mapping(chip->domain, pmirq);
 			generic_handle_irq(irq);
 		}
 	}
@@ -197,12 +196,11 @@ static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
 static void pm8xxx_irq_mask_ack(struct irq_data *d)
 {
 	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
-	unsigned int pmirq = d->irq - chip->irq_base;
-	int	master, irq_bit;
+	unsigned int pmirq = irqd_to_hwirq(d);
+	int	irq_bit;
 	u8	block, config;
 
 	block = pmirq / 8;
-	master = block / 8;
 	irq_bit = pmirq % 8;
 
 	config = chip->config[pmirq] | PM_IRQF_MASK_ALL | PM_IRQF_CLR;
@@ -212,12 +210,11 @@ static void pm8xxx_irq_mask_ack(struct irq_data *d)
 static void pm8xxx_irq_unmask(struct irq_data *d)
 {
 	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
-	unsigned int pmirq = d->irq - chip->irq_base;
-	int	master, irq_bit;
+	unsigned int pmirq = irqd_to_hwirq(d);
+	int	irq_bit;
 	u8	block, config;
 
 	block = pmirq / 8;
-	master = block / 8;
 	irq_bit = pmirq % 8;
 
 	config = chip->config[pmirq];
@@ -227,12 +224,11 @@ static void pm8xxx_irq_unmask(struct irq_data *d)
 static int pm8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
 	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
-	unsigned int pmirq = d->irq - chip->irq_base;
-	int master, irq_bit;
+	unsigned int pmirq = irqd_to_hwirq(d);
+	int irq_bit;
 	u8 block, config;
 
 	block = pmirq / 8;
-	master = block / 8;
 	irq_bit  = pmirq % 8;
 
 	chip->config[pmirq] = (irq_bit << PM_IRQF_BITS_SHIFT)
@@ -282,17 +278,14 @@ static struct irq_chip pm8xxx_irq_chip = {
  * RETURNS:
  * an int indicating the value read on that line
  */
-int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
+static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
 {
 	int pmirq, rc;
 	u8  block, bits, bit;
 	unsigned long flags;
+	struct irq_data *irq_data = irq_get_irq_data(irq);
 
-	if (chip == NULL || irq < chip->irq_base ||
-			irq >= chip->irq_base + chip->num_irqs)
-		return -EINVAL;
-
-	pmirq = irq - chip->irq_base;
+	pmirq = irq_data->hwirq;
 
 	block = pmirq / 8;
 	bit = pmirq % 8;
@@ -322,64 +315,55 @@ bail_out:
 }
 EXPORT_SYMBOL_GPL(pm8xxx_get_irq_stat);
 
-struct pm_irq_chip *  pm8xxx_irq_init(struct device *dev,
-				const struct pm8xxx_irq_platform_data *pdata)
+static struct lock_class_key pm8xxx_irq_lock_class;
+
+static int pm8xxx_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hwirq)
 {
-	struct pm_irq_chip  *chip;
-	int devirq, rc;
-	unsigned int pmirq;
+	struct pm_irq_chip *chip = d->host_data;
 
-	if (!pdata) {
-		pr_err("No platform data\n");
-		return ERR_PTR(-EINVAL);
-	}
+	irq_set_lockdep_class(irq, &pm8xxx_irq_lock_class);
+	irq_set_chip_and_handler(irq, &pm8xxx_irq_chip, handle_level_irq);
+	irq_set_chip_data(irq, chip);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+	return 0;
+}
 
-	devirq = pdata->devirq;
-	if (devirq < 0) {
-		pr_err("missing devirq\n");
-		rc = devirq;
-		return ERR_PTR(-EINVAL);
-	}
+static const struct irq_domain_ops pm8xxx_irq_domain_ops = {
+	.xlate = irq_domain_xlate_twocell,
+	.map = pm8xxx_irq_domain_map,
+};
 
-	chip = kzalloc(sizeof(struct pm_irq_chip)
-			+ sizeof(u8) * pdata->irq_cdata.nirqs, GFP_KERNEL);
-	if (!chip) {
-		pr_err("Cannot alloc pm_irq_chip struct\n");
-		return ERR_PTR(-EINVAL);
-	}
+static int pm8xxx_irq_init(struct platform_device *pdev, unsigned int irq,
+			   unsigned int nirqs)
+{
+	struct pm_irq_chip  *chip;
+
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip) + sizeof(u8) * nirqs,
+			    GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
 
-	chip->dev = dev;
-	chip->devirq = devirq;
-	chip->irq_base = pdata->irq_base;
-	chip->num_irqs = pdata->irq_cdata.nirqs;
+	chip->dev = &pdev->dev;
+	chip->num_irqs = nirqs;
 	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
 	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
 	spin_lock_init(&chip->pm_irq_lock);
 
-	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
-		irq_set_chip_and_handler(chip->irq_base + pmirq,
-				&pm8xxx_irq_chip,
-				handle_level_irq);
-		irq_set_chip_data(chip->irq_base + pmirq, chip);
-#ifdef CONFIG_ARM
-		set_irq_flags(chip->irq_base + pmirq, IRQF_VALID);
-#else
-		irq_set_noprobe(chip->irq_base + pmirq);
-#endif
-	}
+	chip->domain = irq_domain_add_linear(pdev->dev.of_node, nirqs,
+						&pm8xxx_irq_domain_ops,
+						chip);
+	if (!chip->domain)
+		return -ENODEV;
 
-	irq_set_irq_type(devirq, pdata->irq_trigger_flag);
-	irq_set_handler_data(devirq, chip);
-	irq_set_chained_handler(devirq, pm8xxx_irq_handler);
-	irq_set_irq_wake(devirq, 1);
+	irq_set_handler_data(irq, chip);
+	irq_set_chained_handler(irq, pm8xxx_irq_handler);
+	irq_set_irq_wake(irq, 1);
 
-	return chip;
-}
-
-int pm8xxx_irq_exit(struct pm_irq_chip *chip)
-{
-	irq_set_chained_handler(chip->devirq, NULL);
-	kfree(chip);
 	return 0;
 }
 
@@ -433,42 +417,18 @@ static struct pm8xxx_drvdata pm8921_drvdata = {
 	.pmic_read_irq_stat	= pm8921_read_irq_stat,
 };
 
-static int pm8921_add_subdevices(const struct pm8921_platform_data
-					   *pdata,
-					   struct pm8921 *pmic,
-					   u32 rev)
-{
-	int ret = 0, irq_base = 0;
-	struct pm_irq_chip *irq_chip;
-
-	if (pdata->irq_pdata) {
-		pdata->irq_pdata->irq_cdata.nirqs = PM8921_NR_IRQS;
-		pdata->irq_pdata->irq_cdata.rev = rev;
-		irq_base = pdata->irq_pdata->irq_base;
-		irq_chip = pm8xxx_irq_init(pmic->dev, pdata->irq_pdata);
-
-		if (IS_ERR(irq_chip)) {
-			pr_err("Failed to init interrupts ret=%ld\n",
-					PTR_ERR(irq_chip));
-			return PTR_ERR(irq_chip);
-		}
-		pmic->irq_chip = irq_chip;
-	}
-	return ret;
-}
-
 static int pm8921_probe(struct platform_device *pdev)
 {
-	const struct pm8921_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct pm8921 *pmic;
 	int rc;
 	u8 val;
+	unsigned int irq;
 	u32 rev;
 
-	if (!pdata) {
-		pr_err("missing platform data\n");
-		return -EINVAL;
-	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(struct pm8921), GFP_KERNEL);
 	if (!pmic) {
@@ -499,37 +459,23 @@ static int pm8921_probe(struct platform_device *pdev)
 	pm8921_drvdata.pm_chip_data = pmic;
 	platform_set_drvdata(pdev, &pm8921_drvdata);
 
-	rc = pm8921_add_subdevices(pdata, pmic, rev);
-	if (rc) {
-		pr_err("Cannot add subdevices rc=%d\n", rc);
-		goto err;
-	}
+	rc = pm8xxx_irq_init(pdev, irq, 256);
+	if (rc)
+		return rc;
 
-	/* gpio might not work if no irq device is found */
-	WARN_ON(pmic->irq_chip == NULL);
+	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+}
 
+static int pm8921_remove_child(struct device *dev, void *unused)
+{
+	platform_device_unregister(to_platform_device(dev));
 	return 0;
-
-err:
-	mfd_remove_devices(pmic->dev);
-	return rc;
 }
 
 static int pm8921_remove(struct platform_device *pdev)
 {
-	struct pm8xxx_drvdata *drvdata;
-	struct pm8921 *pmic = NULL;
-
-	drvdata = platform_get_drvdata(pdev);
-	if (drvdata)
-		pmic = drvdata->pm_chip_data;
-	if (pmic)
-		mfd_remove_devices(pmic->dev);
-	if (pmic->irq_chip) {
-		pm8xxx_irq_exit(pmic->irq_chip);
-		pmic->irq_chip = NULL;
-	}
-
+	device_for_each_child(&pdev->dev, NULL, pm8921_remove_child);
+	irq_set_chained_handler(platform_get_irq(pdev, 0), NULL);
 	return 0;
 }
 
diff --git a/include/linux/mfd/pm8xxx/irq.h b/include/linux/mfd/pm8xxx/irq.h
deleted file mode 100644
index f83d6b4..0000000
--- a/include/linux/mfd/pm8xxx/irq.h
+++ /dev/null
@@ -1,59 +0,0 @@
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
- * Qualcomm PMIC irq 8xxx driver header file
- *
- */
-
-#ifndef __MFD_PM8XXX_IRQ_H
-#define __MFD_PM8XXX_IRQ_H
-
-#include <linux/errno.h>
-#include <linux/err.h>
-
-struct pm8xxx_irq_core_data {
-	u32		rev;
-	int		nirqs;
-};
-
-struct pm8xxx_irq_platform_data {
-	int				irq_base;
-	struct pm8xxx_irq_core_data	irq_cdata;
-	int				devirq;
-	int				irq_trigger_flag;
-};
-
-struct pm_irq_chip;
-
-#ifdef CONFIG_MFD_PM8XXX_IRQ
-int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq);
-struct pm_irq_chip *pm8xxx_irq_init(struct device *dev,
-				const struct pm8xxx_irq_platform_data *pdata);
-int pm8xxx_irq_exit(struct pm_irq_chip *chip);
-#else
-static inline int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
-{
-	return -ENXIO;
-}
-static inline struct pm_irq_chip *pm8xxx_irq_init(
-				const struct device *dev,
-				const struct pm8xxx_irq_platform_data *pdata)
-{
-	return ERR_PTR(-ENXIO);
-}
-static inline int pm8xxx_irq_exit(struct pm_irq_chip *chip)
-{
-	return -ENXIO;
-}
-#endif /* CONFIG_MFD_PM8XXX_IRQ */
-#endif /* __MFD_PM8XXX_IRQ_H */
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
deleted file mode 100644
index 00fa3de..0000000
--- a/include/linux/mfd/pm8xxx/pm8921.h
+++ /dev/null
@@ -1,30 +0,0 @@
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
- * Qualcomm PMIC 8921 driver header file
- *
- */
-
-#ifndef __MFD_PM8921_H
-#define __MFD_PM8921_H
-
-#include <linux/mfd/pm8xxx/irq.h>
-
-#define PM8921_NR_IRQS		256
-
-struct pm8921_platform_data {
-	int					irq_base;
-	struct pm8xxx_irq_platform_data		*irq_pdata;
-};
-
-#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

