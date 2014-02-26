Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaBZTC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:02:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52634 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaBZS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:59:33 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 3/8] mfd: pm8921: Migrate to irqdomains
Date: Wed, 26 Feb 2014 10:59:21 -0800
Message-Id: <1393441166-32692-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
References: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this driver to use irqdomains so that the PMIC's child
devices can be converted to devicetree.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/Kconfig               |   1 +
 drivers/mfd/pm8921-core.c         | 198 +++++++++++++++-----------------------
 include/linux/mfd/pm8xxx/irq.h    |  36 -------
 include/linux/mfd/pm8xxx/pm8921.h |  30 ------
 4 files changed, 76 insertions(+), 189 deletions(-)
 delete mode 100644 include/linux/mfd/pm8xxx/irq.h
 delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index bee2d2c81c2a..c9b672c5dfa8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -474,6 +474,7 @@ config MFD_PM8XXX
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
 	depends on (ARCH_MSM || HEXAGON)
+	select IRQ_DOMAIN
 	select MFD_CORE
 	select MFD_PM8XXX
 	help
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 9ddc31f7a71d..c25e7dae150b 100644
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
 
@@ -53,11 +53,12 @@
 #define REG_HWREV		0x002  /* PMIC4 revision */
 #define REG_HWREV_2		0x0E8  /* PMIC4 revision 2 */
 
+#define PM8921_NR_IRQS		256
+
 struct pm_irq_chip {
 	struct device		*dev;
 	spinlock_t		pm_irq_lock;
-	unsigned int		devirq;
-	unsigned int		irq_base;
+	struct irq_domain	*irqdomain;
 	unsigned int		num_irqs;
 	unsigned int		num_blocks;
 	unsigned int		num_masters;
@@ -138,7 +139,7 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
 	for (i = 0; i < 8; i++) {
 		if (bits & (1 << i)) {
 			pmirq = block * 8 + i;
-			irq = pmirq + chip->irq_base;
+			irq = irq_find_mapping(chip->irqdomain, pmirq);
 			generic_handle_irq(irq);
 		}
 	}
@@ -197,12 +198,11 @@ static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
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
@@ -212,12 +212,11 @@ static void pm8xxx_irq_mask_ack(struct irq_data *d)
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
@@ -227,12 +226,11 @@ static void pm8xxx_irq_unmask(struct irq_data *d)
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
@@ -287,12 +285,9 @@ static int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
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
@@ -321,67 +316,29 @@ bail_out:
 	return rc;
 }
 
-static struct pm_irq_chip *pm8xxx_irq_init(struct device *dev,
-				const struct pm8xxx_irq_platform_data *pdata)
-{
-	struct pm_irq_chip  *chip;
-	int devirq, rc;
-	unsigned int pmirq;
-
-	if (!pdata) {
-		pr_err("No platform data\n");
-		return ERR_PTR(-EINVAL);
-	}
+static struct lock_class_key pm8xxx_irq_lock_class;
 
-	devirq = pdata->devirq;
-	if (devirq < 0) {
-		pr_err("missing devirq\n");
-		rc = devirq;
-		return ERR_PTR(-EINVAL);
-	}
-
-	chip = kzalloc(sizeof(struct pm_irq_chip)
-			+ sizeof(u8) * pdata->irq_cdata.nirqs, GFP_KERNEL);
-	if (!chip) {
-		pr_err("Cannot alloc pm_irq_chip struct\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	chip->dev = dev;
-	chip->devirq = devirq;
-	chip->irq_base = pdata->irq_base;
-	chip->num_irqs = pdata->irq_cdata.nirqs;
-	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
-	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
-	spin_lock_init(&chip->pm_irq_lock);
+static int pm8xxx_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hwirq)
+{
+	struct pm_irq_chip *chip = d->host_data;
 
-	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
-		irq_set_chip_and_handler(chip->irq_base + pmirq,
-				&pm8xxx_irq_chip,
-				handle_level_irq);
-		irq_set_chip_data(chip->irq_base + pmirq, chip);
+	irq_set_lockdep_class(irq, &pm8xxx_irq_lock_class);
+	irq_set_chip_and_handler(irq, &pm8xxx_irq_chip, handle_level_irq);
+	irq_set_chip_data(irq, chip);
 #ifdef CONFIG_ARM
-		set_irq_flags(chip->irq_base + pmirq, IRQF_VALID);
+	set_irq_flags(irq, IRQF_VALID);
 #else
-		irq_set_noprobe(chip->irq_base + pmirq);
+	irq_set_noprobe(irq);
 #endif
-	}
-
-	irq_set_irq_type(devirq, pdata->irq_trigger_flag);
-	irq_set_handler_data(devirq, chip);
-	irq_set_chained_handler(devirq, pm8xxx_irq_handler);
-	irq_set_irq_wake(devirq, 1);
-
-	return chip;
-}
-
-static int pm8xxx_irq_exit(struct pm_irq_chip *chip)
-{
-	irq_set_chained_handler(chip->devirq, NULL);
-	kfree(chip);
 	return 0;
 }
 
+static const struct irq_domain_ops pm8xxx_irq_domain_ops = {
+	.xlate = irq_domain_xlate_twocell,
+	.map = pm8xxx_irq_domain_map,
+};
+
 static int pm8921_readb(const struct device *dev, u16 addr, u8 *val)
 {
 	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
@@ -432,42 +389,19 @@ static struct pm8xxx_drvdata pm8921_drvdata = {
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
+	struct pm_irq_chip *chip;
+	unsigned int nirqs = PM8921_NR_IRQS;
 
-	if (!pdata) {
-		pr_err("missing platform data\n");
-		return -EINVAL;
-	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(struct pm8921), GFP_KERNEL);
 	if (!pmic) {
@@ -498,37 +432,55 @@ static int pm8921_probe(struct platform_device *pdev)
 	pm8921_drvdata.pm_chip_data = pmic;
 	platform_set_drvdata(pdev, &pm8921_drvdata);
 
-	rc = pm8921_add_subdevices(pdata, pmic, rev);
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip) +
+					sizeof(chip->config[0]) * nirqs,
+					GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	pmic->irq_chip = chip;
+	chip->dev = &pdev->dev;
+	chip->num_irqs = nirqs;
+	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
+	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
+	spin_lock_init(&chip->pm_irq_lock);
+
+	chip->irqdomain = irq_domain_add_linear(pdev->dev.of_node, nirqs,
+						&pm8xxx_irq_domain_ops,
+						chip);
+	if (!chip->irqdomain)
+		return -ENODEV;
+
+	irq_set_handler_data(irq, chip);
+	irq_set_chained_handler(irq, pm8xxx_irq_handler);
+	irq_set_irq_wake(irq, 1);
+
+	rc = of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
 	if (rc) {
-		pr_err("Cannot add subdevices rc=%d\n", rc);
-		goto err;
+		irq_set_chained_handler(irq, NULL);
+		irq_set_handler_data(irq, NULL);
+		irq_domain_remove(chip->irqdomain);
 	}
 
-	/* gpio might not work if no irq device is found */
-	WARN_ON(pmic->irq_chip == NULL);
+	return rc;
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
-	if (pmic) {
-		mfd_remove_devices(pmic->dev);
-		if (pmic->irq_chip) {
-			pm8xxx_irq_exit(pmic->irq_chip);
-			pmic->irq_chip = NULL;
-		}
-	}
+	int irq = platform_get_irq(pdev, 0);
+	struct pm8921 *pmic = pm8921_drvdata.pm_chip_data;
+	struct pm_irq_chip *chip = pmic->irq_chip;
+
+	device_for_each_child(&pdev->dev, NULL, pm8921_remove_child);
+	irq_set_chained_handler(irq, NULL);
+	irq_set_handler_data(irq, NULL);
+	irq_domain_remove(chip->irqdomain);
 
 	return 0;
 }
diff --git a/include/linux/mfd/pm8xxx/irq.h b/include/linux/mfd/pm8xxx/irq.h
deleted file mode 100644
index 1a11b02383f0..000000000000
--- a/include/linux/mfd/pm8xxx/irq.h
+++ /dev/null
@@ -1,36 +0,0 @@
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
-#endif /* __MFD_PM8XXX_IRQ_H */
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
deleted file mode 100644
index 00fa3de7659d..000000000000
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

