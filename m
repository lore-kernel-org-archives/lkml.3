Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaD2Ft2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:49:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18260 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaD2FtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:49:05 -0400
X-AuditID: cbfee61b-b7f766d00000646c-df-535f3d4febdd
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 2/2] mfd: max77693: handle IRQs using regmap
Date: Tue, 29 Apr 2014 07:48:47 +0200
Message-id: <1398750527-20715-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
References: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQV1/2/hgg+23RS2WXLzKbvH6haHF
	/a9HGS0u75rDZrH2yF12iweHd7Jb7O/sYLQ43c3qwOGxZ+JJNo871/awecw7GejRt2UVo8f0
	eT+ZPD5vkgtgi+KySUnNySxLLdK3S+DKOHHuCEvBzU2MFXt/8jcwfp3I2MXIySEhYCKxdd1q
	ZghbTOLCvfVsXYxcHEIC0xklFjy6wgrhtDNJbNp4ixWkik1AR2LL9wlg3SIC+hIfdlxlBili
	FtjIKDFx5kewUcIC9hI/Fm5lAbFZBFQlZt5YCNbAK+AqsXfub6h1chInj00GGsrBwSngJjGr
	JREkLARUMmHfLJYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH2TPpHYyrGiwO
	MQpwMCrx8HbExAULsSaWFVfmHmKU4GBWEuHNt4oPFuJNSaysSi3Kjy8qzUktPsQozcGiJM57
	sNU6UEggPbEkNTs1tSC1CCbLxMEp1cA45cjtH29Uldc8/Fs0a/ds4fW3Vvzisd5oEbNK5Opi
	lqUsc3gX73BI3Pcv+EFtrm2TArP8jYuc/cyvhdZ9tZS4vCfybG25z7Sp+p+WmtZvSywtfZKR
	rrzus/xErqLi3RxJnle1tMIP3EjV/RtjNPlSFLfRkUduahKu/0ymTIsV3KTkFr8y5ft+JZbi
	jERDLeai4kQA6eM3MS8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies mfd driver to use regmap for handling interrupts.
It allows to simplify irq handling process. This modifications needed
to make small changes in function drivers, which use interrupts.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max77693.c     |   3 +-
 drivers/mfd/Kconfig                  |   1 +
 drivers/mfd/Makefile                 |   2 +-
 drivers/mfd/max77693-irq.c           | 346 -----------------------------------
 drivers/mfd/max77693.c               | 151 ++++++++++++++-
 include/linux/mfd/max77693-private.h |  47 ++++-
 6 files changed, 191 insertions(+), 359 deletions(-)
 delete mode 100644 drivers/mfd/max77693-irq.c

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 0b09bf3..725190a 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1154,7 +1154,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		struct max77693_muic_irq *muic_irq = &muic_irqs[i];
 		unsigned int virq = 0;
 
-		virq = irq_create_mapping(max77693->irq_domain, muic_irq->irq);
+		virq = regmap_irq_get_virq(max77693->irq_data_muic,
+					muic_irq->irq);
 		if (!virq) {
 			ret = -EINVAL;
 			goto err_irq;
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 67141e8..9e479d0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -372,6 +372,7 @@ config MFD_MAX77693
 	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  Say yes here to add support for Maxim Semiconductor MAX77693.
 	  This is a companion Power Management IC with Flash, Haptic, Charger,
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6d0f65e..b0c55e4 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -114,7 +114,7 @@ obj-$(CONFIG_MFD_DA9063)	+= da9063.o
 
 obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
-obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
+obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
deleted file mode 100644
index 7d8f99f..0000000
--- a/drivers/mfd/max77693-irq.c
+++ /dev/null
@@ -1,346 +0,0 @@
-/*
- * max77693-irq.c - Interrupt controller support for MAX77693
- *
- * Copyright (C) 2012 Samsung Electronics Co.Ltd
- * SangYoung Son <hello.son@samsung.com>
- *
- * This program is not provided / owned by Maxim Integrated Products.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * This driver is based on max8997-irq.c
- */
-
-#include <linux/err.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/irqdomain.h>
-#include <linux/mfd/max77693.h>
-#include <linux/mfd/max77693-private.h>
-#include <linux/regmap.h>
-
-static const unsigned int max77693_mask_reg[] = {
-	[LED_INT] = MAX77693_LED_REG_FLASH_INT_MASK,
-	[TOPSYS_INT] = MAX77693_PMIC_REG_TOPSYS_INT_MASK,
-	[CHG_INT] = MAX77693_CHG_REG_CHG_INT_MASK,
-	[MUIC_INT1] = MAX77693_MUIC_REG_INTMASK1,
-	[MUIC_INT2] = MAX77693_MUIC_REG_INTMASK2,
-	[MUIC_INT3] = MAX77693_MUIC_REG_INTMASK3,
-};
-
-static struct regmap *max77693_get_regmap(struct max77693_dev *max77693,
-				enum max77693_irq_source src)
-{
-	switch (src) {
-	case LED_INT ... CHG_INT:
-		return max77693->regmap;
-	case MUIC_INT1 ... MUIC_INT3:
-		return max77693->regmap_muic;
-	default:
-		return ERR_PTR(-EINVAL);
-	}
-}
-
-struct max77693_irq_data {
-	int mask;
-	enum max77693_irq_source group;
-};
-
-#define DECLARE_IRQ(idx, _group, _mask)		\
-	[(idx)] = { .group = (_group), .mask = (_mask) }
-static const struct max77693_irq_data max77693_irqs[] = {
-	DECLARE_IRQ(MAX77693_LED_IRQ_FLED2_OPEN,	LED_INT, 1 << 0),
-	DECLARE_IRQ(MAX77693_LED_IRQ_FLED2_SHORT,	LED_INT, 1 << 1),
-	DECLARE_IRQ(MAX77693_LED_IRQ_FLED1_OPEN,	LED_INT, 1 << 2),
-	DECLARE_IRQ(MAX77693_LED_IRQ_FLED1_SHORT,	LED_INT, 1 << 3),
-	DECLARE_IRQ(MAX77693_LED_IRQ_MAX_FLASH,		LED_INT, 1 << 4),
-
-	DECLARE_IRQ(MAX77693_TOPSYS_IRQ_T120C_INT,	TOPSYS_INT, 1 << 0),
-	DECLARE_IRQ(MAX77693_TOPSYS_IRQ_T140C_INT,	TOPSYS_INT, 1 << 1),
-	DECLARE_IRQ(MAX77693_TOPSYS_IRQ_LOWSYS_INT,	TOPSYS_INT, 1 << 3),
-
-	DECLARE_IRQ(MAX77693_CHG_IRQ_BYP_I,		CHG_INT, 1 << 0),
-	DECLARE_IRQ(MAX77693_CHG_IRQ_THM_I,		CHG_INT, 1 << 2),
-	DECLARE_IRQ(MAX77693_CHG_IRQ_BAT_I,		CHG_INT, 1 << 3),
-	DECLARE_IRQ(MAX77693_CHG_IRQ_CHG_I,		CHG_INT, 1 << 4),
-	DECLARE_IRQ(MAX77693_CHG_IRQ_CHGIN_I,		CHG_INT, 1 << 6),
-
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC,		MUIC_INT1, 1 << 0),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC_LOW,	MUIC_INT1, 1 << 1),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC_ERR,	MUIC_INT1, 1 << 2),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT1_ADC1K,	MUIC_INT1, 1 << 3),
-
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_CHGTYP,	MUIC_INT2, 1 << 0),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_CHGDETREUN,	MUIC_INT2, 1 << 1),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_DCDTMR,	MUIC_INT2, 1 << 2),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_DXOVP,	MUIC_INT2, 1 << 3),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_VBVOLT,	MUIC_INT2, 1 << 4),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT2_VIDRM,	MUIC_INT2, 1 << 5),
-
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_EOC,		MUIC_INT3, 1 << 0),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_CGMBC,	MUIC_INT3, 1 << 1),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_OVP,		MUIC_INT3, 1 << 2),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR,	MUIC_INT3, 1 << 3),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,	MUIC_INT3, 1 << 4),
-	DECLARE_IRQ(MAX77693_MUIC_IRQ_INT3_BAT_DET,	MUIC_INT3, 1 << 5),
-};
-
-static void max77693_irq_lock(struct irq_data *data)
-{
-	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
-
-	mutex_lock(&max77693->irqlock);
-}
-
-static void max77693_irq_sync_unlock(struct irq_data *data)
-{
-	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
-	int i;
-
-	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
-		u8 mask_reg = max77693_mask_reg[i];
-		struct regmap *map = max77693_get_regmap(max77693, i);
-
-		if (mask_reg == MAX77693_REG_INVALID ||
-				IS_ERR_OR_NULL(map))
-			continue;
-		max77693->irq_masks_cache[i] = max77693->irq_masks_cur[i];
-
-		regmap_write(map, max77693_mask_reg[i],
-				max77693->irq_masks_cur[i]);
-	}
-
-	mutex_unlock(&max77693->irqlock);
-}
-
-static const inline struct max77693_irq_data *
-irq_to_max77693_irq(struct max77693_dev *max77693, int irq)
-{
-	struct irq_data *data = irq_get_irq_data(irq);
-	return &max77693_irqs[data->hwirq];
-}
-
-static void max77693_irq_mask(struct irq_data *data)
-{
-	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
-	const struct max77693_irq_data *irq_data =
-				irq_to_max77693_irq(max77693, data->irq);
-
-	if (irq_data->group >= MAX77693_IRQ_GROUP_NR)
-		return;
-
-	if (irq_data->group >= MUIC_INT1 && irq_data->group <= MUIC_INT3)
-		max77693->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
-	else
-		max77693->irq_masks_cur[irq_data->group] |= irq_data->mask;
-}
-
-static void max77693_irq_unmask(struct irq_data *data)
-{
-	struct max77693_dev *max77693 = irq_get_chip_data(data->irq);
-	const struct max77693_irq_data *irq_data =
-	    irq_to_max77693_irq(max77693, data->irq);
-
-	if (irq_data->group >= MAX77693_IRQ_GROUP_NR)
-		return;
-
-	if (irq_data->group >= MUIC_INT1 && irq_data->group <= MUIC_INT3)
-		max77693->irq_masks_cur[irq_data->group] |= irq_data->mask;
-	else
-		max77693->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
-}
-
-static struct irq_chip max77693_irq_chip = {
-	.name			= "max77693",
-	.irq_bus_lock		= max77693_irq_lock,
-	.irq_bus_sync_unlock	= max77693_irq_sync_unlock,
-	.irq_mask		= max77693_irq_mask,
-	.irq_unmask		= max77693_irq_unmask,
-};
-
-#define MAX77693_IRQSRC_CHG		(1 << 0)
-#define MAX77693_IRQSRC_TOP		(1 << 1)
-#define MAX77693_IRQSRC_FLASH		(1 << 2)
-#define MAX77693_IRQSRC_MUIC		(1 << 3)
-static irqreturn_t max77693_irq_thread(int irq, void *data)
-{
-	struct max77693_dev *max77693 = data;
-	u8 irq_reg[MAX77693_IRQ_GROUP_NR] = {};
-	unsigned int irq_src;
-	int ret;
-	int i, cur_irq;
-
-	ret = regmap_read(max77693->regmap, MAX77693_PMIC_REG_INTSRC,
-				&irq_src);
-	if (ret < 0) {
-		dev_err(max77693->dev, "Failed to read interrupt source: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	if (irq_src & MAX77693_IRQSRC_CHG) {
-		/* CHG_INT */
-		unsigned int data;
-		ret = regmap_read(max77693->regmap,
-				MAX77693_CHG_REG_CHG_INT, &data);
-		irq_reg[CHG_INT] = data;
-	}
-
-	if (irq_src & MAX77693_IRQSRC_TOP) {
-		/* TOPSYS_INT */
-		unsigned int data;
-		ret = regmap_read(max77693->regmap,
-			MAX77693_PMIC_REG_TOPSYS_INT, &data);
-		irq_reg[TOPSYS_INT] = data;
-	}
-
-	if (irq_src & MAX77693_IRQSRC_FLASH) {
-		/* LED_INT */
-		unsigned int data;
-		ret = regmap_read(max77693->regmap,
-			MAX77693_LED_REG_FLASH_INT, &data);
-		irq_reg[LED_INT] = data;
-	}
-
-	if (irq_src & MAX77693_IRQSRC_MUIC)
-		/* MUIC INT1 ~ INT3 */
-		regmap_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
-			&irq_reg[MUIC_INT1], MAX77693_NUM_IRQ_MUIC_REGS);
-
-	/* Apply masking */
-	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
-		if (i >= MUIC_INT1 && i <= MUIC_INT3)
-			irq_reg[i] &= max77693->irq_masks_cur[i];
-		else
-			irq_reg[i] &= ~max77693->irq_masks_cur[i];
-	}
-
-	/* Report */
-	for (i = 0; i < MAX77693_IRQ_NR; i++) {
-		if (irq_reg[max77693_irqs[i].group] & max77693_irqs[i].mask) {
-			cur_irq = irq_find_mapping(max77693->irq_domain, i);
-			if (cur_irq)
-				handle_nested_irq(cur_irq);
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
-int max77693_irq_resume(struct max77693_dev *max77693)
-{
-	if (max77693->irq)
-		max77693_irq_thread(0, max77693);
-
-	return 0;
-}
-
-static int max77693_irq_domain_map(struct irq_domain *d, unsigned int irq,
-				irq_hw_number_t hw)
-{
-	struct max77693_dev *max77693 = d->host_data;
-
-	irq_set_chip_data(irq, max77693);
-	irq_set_chip_and_handler(irq, &max77693_irq_chip, handle_edge_irq);
-	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
-	irq_set_noprobe(irq);
-#endif
-	return 0;
-}
-
-static struct irq_domain_ops max77693_irq_domain_ops = {
-	.map = max77693_irq_domain_map,
-};
-
-int max77693_irq_init(struct max77693_dev *max77693)
-{
-	struct irq_domain *domain;
-	int i;
-	int ret = 0;
-	unsigned int intsrc_mask;
-
-	mutex_init(&max77693->irqlock);
-
-	/* Mask individual interrupt sources */
-	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
-		struct regmap *map;
-		/* MUIC IRQ  0:MASK 1:NOT MASK */
-		/* Other IRQ 1:MASK 0:NOT MASK */
-		if (i >= MUIC_INT1 && i <= MUIC_INT3) {
-			max77693->irq_masks_cur[i] = 0x00;
-			max77693->irq_masks_cache[i] = 0x00;
-		} else {
-			max77693->irq_masks_cur[i] = 0xff;
-			max77693->irq_masks_cache[i] = 0xff;
-		}
-		map = max77693_get_regmap(max77693, i);
-
-		if (IS_ERR_OR_NULL(map))
-			continue;
-		if (max77693_mask_reg[i] == MAX77693_REG_INVALID)
-			continue;
-		if (i >= MUIC_INT1 && i <= MUIC_INT3)
-			regmap_write(map, max77693_mask_reg[i], 0x00);
-		else
-			regmap_write(map, max77693_mask_reg[i], 0xff);
-	}
-
-	domain = irq_domain_add_linear(NULL, MAX77693_IRQ_NR,
-					&max77693_irq_domain_ops, max77693);
-	if (!domain) {
-		dev_err(max77693->dev, "could not create irq domain\n");
-		ret = -ENODEV;
-		goto err_irq;
-	}
-	max77693->irq_domain = domain;
-
-	/* Unmask max77693 interrupt */
-	ret = regmap_read(max77693->regmap,
-			MAX77693_PMIC_REG_INTSRC_MASK, &intsrc_mask);
-	if (ret < 0) {
-		dev_err(max77693->dev, "fail to read PMIC register\n");
-		goto err_irq;
-	}
-
-	intsrc_mask &= ~(MAX77693_IRQSRC_CHG);
-	intsrc_mask &= ~(MAX77693_IRQSRC_FLASH);
-	intsrc_mask &= ~(MAX77693_IRQSRC_MUIC);
-	ret = regmap_write(max77693->regmap,
-			MAX77693_PMIC_REG_INTSRC_MASK, intsrc_mask);
-	if (ret < 0) {
-		dev_err(max77693->dev, "fail to write PMIC register\n");
-		goto err_irq;
-	}
-
-	ret = request_threaded_irq(max77693->irq, NULL, max77693_irq_thread,
-				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   "max77693-irq", max77693);
-	if (ret)
-		dev_err(max77693->dev, "Failed to request IRQ %d: %d\n",
-			max77693->irq, ret);
-
-err_irq:
-	return ret;
-}
-
-void max77693_irq_exit(struct max77693_dev *max77693)
-{
-	if (max77693->irq)
-		free_irq(max77693->irq, max77693);
-}
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 6336251..5b85dc3 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -55,12 +55,95 @@ static const struct regmap_config max77693_regmap_config = {
 	.max_register = MAX77693_PMIC_REG_END,
 };
 
+static const struct regmap_irq max77693_led_irqs[] = {
+	{ .mask = LED_IRQ_FLED2_OPEN, },
+	{ .mask = LED_IRQ_FLED2_SHORT, },
+	{ .mask = LED_IRQ_FLED1_OPEN, },
+	{ .mask = LED_IRQ_FLED1_SHORT, },
+	{ .mask = LED_IRQ_MAX_FLASH, },
+};
+
+static const struct regmap_irq_chip max77693_led_irq_chip = {
+	.name                   = "max77693-led",
+	.status_base            = MAX77693_LED_REG_FLASH_INT,
+	.mask_base              = MAX77693_LED_REG_FLASH_INT_MASK,
+	.mask_invert            = false,
+	.num_regs               = 1,
+	.irqs                   = max77693_led_irqs,
+	.num_irqs               = ARRAY_SIZE(max77693_led_irqs),
+};
+
+static const struct regmap_irq max77693_topsys_irqs[] = {
+	{ .mask = TOPSYS_IRQ_T120C_INT, },
+	{ .mask = TOPSYS_IRQ_T140C_INT, },
+	{ .mask = TOPSYS_IRQ_LOWSYS_INT, },
+};
+
+static const struct regmap_irq_chip max77693_topsys_irq_chip = {
+	.name                   = "max77693-topsys",
+	.status_base            = MAX77693_PMIC_REG_TOPSYS_INT,
+	.mask_base              = MAX77693_PMIC_REG_TOPSYS_INT_MASK,
+	.mask_invert            = false,
+	.num_regs               = 1,
+	.irqs                   = max77693_topsys_irqs,
+	.num_irqs               = ARRAY_SIZE(max77693_topsys_irqs),
+};
+
+static const struct regmap_irq max77693_charger_irqs[] = {
+	{ .mask = CHG_IRQ_BYP_I, },
+	{ .mask = CHG_IRQ_THM_I, },
+	{ .mask = CHG_IRQ_BAT_I, },
+	{ .mask = CHG_IRQ_CHG_I, },
+	{ .mask = CHG_IRQ_CHGIN_I, },
+};
+
+static const struct regmap_irq_chip max77693_charger_irq_chip = {
+	.name                   = "max77693-charger",
+	.status_base            = MAX77693_CHG_REG_CHG_INT,
+	.mask_base              = MAX77693_CHG_REG_CHG_INT_MASK,
+	.mask_invert            = false,
+	.num_regs               = 1,
+	.irqs                   = max77693_charger_irqs,
+	.num_irqs               = ARRAY_SIZE(max77693_charger_irqs),
+};
+
 static const struct regmap_config max77693_regmap_muic_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = MAX77693_MUIC_REG_END,
 };
 
+static const struct regmap_irq max77693_muic_irqs[] = {
+	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC, },
+	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC_LOW, },
+	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC_ERR, },
+	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC1K, },
+
+	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_CHGTYP, },
+	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_CHGDETREUN, },
+	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_DCDTMR, },
+	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_DXOVP, },
+	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_VBVOLT, },
+	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_VIDRM, },
+
+	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_EOC, },
+	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_CGMBC, },
+	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_OVP, },
+	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_MBCCHG_ERR, },
+	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_CHG_ENABLED, },
+	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_BAT_DET, },
+};
+
+static const struct regmap_irq_chip max77693_muic_irq_chip = {
+	.name                   = "max77693-muic",
+	.status_base            = MAX77693_MUIC_REG_INT1,
+	.mask_base              = MAX77693_MUIC_REG_INTMASK1,
+	.mask_invert            = true,
+	.num_regs               = 3,
+	.irqs                   = max77693_muic_irqs,
+	.num_irqs               = ARRAY_SIZE(max77693_muic_irqs),
+};
+
 static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -124,9 +207,45 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		goto err_regmap_muic;
 	}
 
-	ret = max77693_irq_init(max77693);
-	if (ret < 0)
-		goto err_irq;
+	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max77693_led_irq_chip,
+				&max77693->irq_data_led);
+	if (ret) {
+		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
+		goto err_regmap_muic;
+	}
+
+	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max77693_topsys_irq_chip,
+				&max77693->irq_data_topsys);
+	if (ret) {
+		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
+		goto err_irq_topsys;
+	}
+
+	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max77693_charger_irq_chip,
+				&max77693->irq_data_charger);
+	if (ret) {
+		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
+		goto err_irq_charger;
+	}
+
+	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max77693_muic_irq_chip,
+				&max77693->irq_data_muic);
+	if (ret) {
+		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
+		goto err_irq_muic;
+	}
 
 	pm_runtime_set_active(max77693->dev);
 
@@ -138,8 +257,13 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err_mfd:
-	max77693_irq_exit(max77693);
-err_irq:
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
+err_irq_muic:
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
+err_irq_charger:
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
+err_irq_topsys:
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
 err_regmap_muic:
 	i2c_unregister_device(max77693->haptic);
 err_i2c_haptic:
@@ -152,7 +276,12 @@ static int max77693_i2c_remove(struct i2c_client *i2c)
 	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(max77693->dev);
-	max77693_irq_exit(max77693);
+
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
+	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
+
 	i2c_unregister_device(max77693->muic);
 	i2c_unregister_device(max77693->haptic);
 
@@ -171,7 +300,9 @@ static int max77693_suspend(struct device *dev)
 	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
 
 	if (device_may_wakeup(dev))
-		irq_set_irq_wake(max77693->irq, 1);
+		enable_irq_wake(max77693->irq);
+	disable_irq(max77693->irq);
+
 	return 0;
 }
 
@@ -181,8 +312,10 @@ static int max77693_resume(struct device *dev)
 	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
 
 	if (device_may_wakeup(dev))
-		irq_set_irq_wake(max77693->irq, 0);
-	return max77693_irq_resume(max77693);
+		disable_irq_wake(max77693->irq);
+	enable_irq(max77693->irq);
+
+	return 0;
 }
 
 static const struct dev_pm_ops max77693_pm = {
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 80ec31d..7257f3b 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -262,6 +262,42 @@ enum max77693_irq_source {
 	MAX77693_IRQ_GROUP_NR,
 };
 
+#define LED_IRQ_FLED2_OPEN		(0x1 << 0)
+#define LED_IRQ_FLED2_SHORT		(0x1 << 1)
+#define LED_IRQ_FLED1_OPEN		(0x1 << 2)
+#define LED_IRQ_FLED1_SHORT		(0x1 << 3)
+#define LED_IRQ_MAX_FLASH		(0x1 << 4)
+
+#define TOPSYS_IRQ_T120C_INT		(0x1 << 0)
+#define TOPSYS_IRQ_T140C_INT		(0x1 << 1)
+#define TOPSYS_IRQ_LOWSYS_INT		(0x1 << 3)
+
+#define CHG_IRQ_BYP_I			(0x1 << 0)
+#define CHG_IRQ_THM_I			(0x1 << 2)
+#define CHG_IRQ_BAT_I			(0x1 << 3)
+#define CHG_IRQ_CHG_I			(0x1 << 4)
+#define CHG_IRQ_CHGIN_I			(0x1 << 6)
+
+#define MUIC_IRQ_INT1_ADC		(0x1 << 0)
+#define MUIC_IRQ_INT1_ADC_LOW		(0x1 << 1)
+#define MUIC_IRQ_INT1_ADC_ERR		(0x1 << 2)
+#define MUIC_IRQ_INT1_ADC1K		(0x1 << 3)
+
+#define MUIC_IRQ_INT2_CHGTYP		(0x1 << 0)
+#define MUIC_IRQ_INT2_CHGDETREUN	(0x1 << 1)
+#define MUIC_IRQ_INT2_DCDTMR		(0x1 << 2)
+#define MUIC_IRQ_INT2_DXOVP		(0x1 << 3)
+#define MUIC_IRQ_INT2_VBVOLT		(0x1 << 4)
+#define MUIC_IRQ_INT2_VIDRM		(0x1 << 5)
+
+#define MUIC_IRQ_INT3_EOC		(0x1 << 0)
+#define MUIC_IRQ_INT3_CGMBC		(0x1 << 1)
+#define MUIC_IRQ_INT3_OVP		(0x1 << 2)
+#define MUIC_IRQ_INT3_MBCCHG_ERR	(0x1 << 3)
+#define MUIC_IRQ_INT3_CHG_ENABLED	(0x1 << 4)
+#define MUIC_IRQ_INT3_BAT_DET		(0x1 << 5)
+
+
 enum max77693_irq {
 	/* PMIC - FLASH */
 	MAX77693_LED_IRQ_FLED2_OPEN,
@@ -282,6 +318,10 @@ enum max77693_irq {
 	MAX77693_CHG_IRQ_CHG_I,
 	MAX77693_CHG_IRQ_CHGIN_I,
 
+	MAX77693_IRQ_NR,
+};
+
+enum max77693_irq_muic {
 	/* MUIC INT1 */
 	MAX77693_MUIC_IRQ_INT1_ADC,
 	MAX77693_MUIC_IRQ_INT1_ADC_LOW,
@@ -304,7 +344,7 @@ enum max77693_irq {
 	MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,
 	MAX77693_MUIC_IRQ_INT3_BAT_DET,
 
-	MAX77693_IRQ_NR,
+	MAX77693_MUIC_IRQ_NR,
 };
 
 struct max77693_dev {
@@ -319,7 +359,10 @@ struct max77693_dev {
 	struct regmap *regmap_muic;
 	struct regmap *regmap_haptic;
 
-	struct irq_domain *irq_domain;
+	struct regmap_irq_chip_data *irq_data_led;
+	struct regmap_irq_chip_data *irq_data_topsys;
+	struct regmap_irq_chip_data *irq_data_charger;
+	struct regmap_irq_chip_data *irq_data_muic;
 
 	int irq;
 	int irq_gpio;
-- 
1.9.1

