Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaCZHLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:11:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49516 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaCZHLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:11:04 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-85-53327d7fff78
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] mfd: max77686: handle IRQs using regmap
Date: Wed, 26 Mar 2014 08:10:40 +0100
Message-id: <1395817840-12604-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e+xgG59rVGwwemlOhZLLl5lt3j9wtDi
	/tejjBaXd81hs1h75C67xYPDO9kt9nd2MFqc7mZ14PDYM/Ekm8eda3vYPOadDPTo27KK0WP6
	vJ9MHp83yQWwRXHZpKTmZJalFunbJXBlrJ+7m6Vg4wzGilfvSxsYO2u6GDk4JARMJF5MyOhi
	5AQyxSQu3FvPBmILCSxilDj8XriLkQvIbmeSuLm4HSzBJqAjseX7BEYQW0RAX+LDjqvMIEXM
	AhsZJSbO/MgMkhAWsJDoXtIHVsQioCrR9+UVE4jNK+Aq8a9lJiPEYgWJOZNsJjByL2BkWMUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHDDPpHYwrmywOMQowMGoxMM7YYJhsBBrYllxZe4h
	RgkOZiUR3iPyRsFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4
	OKUaGOefTCiZ5vVdKuUSh3YN87rT3Fee3DTQqqht3d4uFtYt9T11dq/eVH634/8bVBkXJOQd
	r9q27RSbxKWpK39oGt06WvHaoJv5fF1r/i2NK021SbobpR0kGFPMb688yFFSvq+m+vvzkNsL
	o3k+fbu37MYb9aOTplxtcbr/MONZwwyubeGFf/S07imxFGckGmoxFxUnAgDBOFxWFAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies mfd driver to use regmap for handling interrupts.
It allows to simplify irq handling process. This modifications needed
to make small changes in function drivers, which use interrupts.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/mfd/Kconfig                  |    2 +-
 drivers/mfd/Makefile                 |    2 +-
 drivers/mfd/max77686-irq.c           |  319 ----------------------------------
 drivers/mfd/max77686.c               |   54 +++++-
 drivers/rtc/rtc-max77686.c           |   43 ++++-
 include/linux/mfd/max77686-private.h |   32 +++-
 6 files changed, 119 insertions(+), 333 deletions(-)
 delete mode 100644 drivers/mfd/max77686-irq.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9e87504..969e685 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -349,7 +349,7 @@ config MFD_MAX77686
 	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
-	select IRQ_DOMAIN
+	select REGMAP_IRQ
 	help
 	  Say yes here to add support for Maxim Semiconductor MAX77686.
 	  This is a Power Management IC with RTC on chip.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b91f3e31..bcc57d7 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -115,7 +115,7 @@ da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
 obj-$(CONFIG_MFD_DA9063)	+= da9063.o
 
 obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
-obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
+obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
deleted file mode 100644
index cdc3280..0000000
--- a/drivers/mfd/max77686-irq.c
+++ /dev/null
@@ -1,319 +0,0 @@
-/*
- * max77686-irq.c - Interrupt controller support for MAX77686
- *
- * Copyright (C) 2012 Samsung Electronics Co.Ltd
- * Chiwoong Byun <woong.byun@samsung.com>
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
-#include <linux/gpio.h>
-#include <linux/mfd/max77686.h>
-#include <linux/mfd/max77686-private.h>
-#include <linux/irqdomain.h>
-#include <linux/regmap.h>
-
-enum {
-	MAX77686_DEBUG_IRQ_INFO = 1 << 0,
-	MAX77686_DEBUG_IRQ_MASK = 1 << 1,
-	MAX77686_DEBUG_IRQ_INT = 1 << 2,
-};
-
-static int debug_mask = 0;
-module_param(debug_mask, int, 0);
-MODULE_PARM_DESC(debug_mask, "Set debug_mask : 0x0=off 0x1=IRQ_INFO  0x2=IRQ_MASK 0x4=IRQ_INI)");
-
-static const u8 max77686_mask_reg[] = {
-	[PMIC_INT1] = MAX77686_REG_INT1MSK,
-	[PMIC_INT2] = MAX77686_REG_INT2MSK,
-	[RTC_INT] = MAX77686_RTC_INTM,
-};
-
-static struct regmap *max77686_get_regmap(struct max77686_dev *max77686,
-				enum max77686_irq_source src)
-{
-	switch (src) {
-	case PMIC_INT1 ... PMIC_INT2:
-		return max77686->regmap;
-	case RTC_INT:
-		return max77686->rtc_regmap;
-	default:
-		return ERR_PTR(-EINVAL);
-	}
-}
-
-struct max77686_irq_data {
-	int mask;
-	enum max77686_irq_source group;
-};
-
-#define DECLARE_IRQ(idx, _group, _mask)		\
-	[(idx)] = { .group = (_group), .mask = (_mask) }
-static const struct max77686_irq_data max77686_irqs[] = {
-	DECLARE_IRQ(MAX77686_PMICIRQ_PWRONF,	PMIC_INT1, 1 << 0),
-	DECLARE_IRQ(MAX77686_PMICIRQ_PWRONR,	PMIC_INT1, 1 << 1),
-	DECLARE_IRQ(MAX77686_PMICIRQ_JIGONBF,	PMIC_INT1, 1 << 2),
-	DECLARE_IRQ(MAX77686_PMICIRQ_JIGONBR,	PMIC_INT1, 1 << 3),
-	DECLARE_IRQ(MAX77686_PMICIRQ_ACOKBF,	PMIC_INT1, 1 << 4),
-	DECLARE_IRQ(MAX77686_PMICIRQ_ACOKBR,	PMIC_INT1, 1 << 5),
-	DECLARE_IRQ(MAX77686_PMICIRQ_ONKEY1S,	PMIC_INT1, 1 << 6),
-	DECLARE_IRQ(MAX77686_PMICIRQ_MRSTB,		PMIC_INT1, 1 << 7),
-	DECLARE_IRQ(MAX77686_PMICIRQ_140C,		PMIC_INT2, 1 << 0),
-	DECLARE_IRQ(MAX77686_PMICIRQ_120C,		PMIC_INT2, 1 << 1),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTC60S,		RTC_INT, 1 << 0),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA1,		RTC_INT, 1 << 1),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTCA2,		RTC_INT, 1 << 2),
-	DECLARE_IRQ(MAX77686_RTCIRQ_SMPL,		RTC_INT, 1 << 3),
-	DECLARE_IRQ(MAX77686_RTCIRQ_RTC1S,		RTC_INT, 1 << 4),
-	DECLARE_IRQ(MAX77686_RTCIRQ_WTSR,		RTC_INT, 1 << 5),
-};
-
-static void max77686_irq_lock(struct irq_data *data)
-{
-	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
-
-	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
-		pr_info("%s\n", __func__);
-
-	mutex_lock(&max77686->irqlock);
-}
-
-static void max77686_irq_sync_unlock(struct irq_data *data)
-{
-	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
-	int i;
-
-	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
-		u8 mask_reg = max77686_mask_reg[i];
-		struct regmap *map = max77686_get_regmap(max77686, i);
-
-		if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
-			pr_debug("%s: mask_reg[%d]=0x%x, cur=0x%x\n",
-			__func__, i, mask_reg, max77686->irq_masks_cur[i]);
-
-		if (mask_reg == MAX77686_REG_INVALID ||
-				IS_ERR_OR_NULL(map))
-			continue;
-
-		max77686->irq_masks_cache[i] = max77686->irq_masks_cur[i];
-
-		regmap_write(map, max77686_mask_reg[i],
-				max77686->irq_masks_cur[i]);
-	}
-
-	mutex_unlock(&max77686->irqlock);
-}
-
-static const inline struct max77686_irq_data *to_max77686_irq(int irq)
-{
-	struct irq_data *data = irq_get_irq_data(irq);
-	return &max77686_irqs[data->hwirq];
-}
-
-static void max77686_irq_mask(struct irq_data *data)
-{
-	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
-	const struct max77686_irq_data *irq_data = to_max77686_irq(data->irq);
-
-	max77686->irq_masks_cur[irq_data->group] |= irq_data->mask;
-
-	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
-		pr_info("%s: group=%d, cur=0x%x\n",
-			__func__, irq_data->group,
-			max77686->irq_masks_cur[irq_data->group]);
-}
-
-static void max77686_irq_unmask(struct irq_data *data)
-{
-	struct max77686_dev *max77686 = irq_get_chip_data(data->irq);
-	const struct max77686_irq_data *irq_data = to_max77686_irq(data->irq);
-
-	max77686->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
-
-	if (debug_mask & MAX77686_DEBUG_IRQ_MASK)
-		pr_info("%s: group=%d, cur=0x%x\n",
-			__func__, irq_data->group,
-			max77686->irq_masks_cur[irq_data->group]);
-}
-
-static struct irq_chip max77686_irq_chip = {
-	.name			= "max77686",
-	.irq_bus_lock		= max77686_irq_lock,
-	.irq_bus_sync_unlock	= max77686_irq_sync_unlock,
-	.irq_mask		= max77686_irq_mask,
-	.irq_unmask		= max77686_irq_unmask,
-};
-
-static irqreturn_t max77686_irq_thread(int irq, void *data)
-{
-	struct max77686_dev *max77686 = data;
-	unsigned int irq_reg[MAX77686_IRQ_GROUP_NR] = {};
-	unsigned int irq_src;
-	int ret;
-	int i, cur_irq;
-
-	ret = regmap_read(max77686->regmap,  MAX77686_REG_INTSRC, &irq_src);
-	if (ret < 0) {
-		dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	if (debug_mask & MAX77686_DEBUG_IRQ_INT)
-		pr_info("%s: irq_src=0x%x\n", __func__, irq_src);
-
-	if (irq_src == MAX77686_IRQSRC_PMIC) {
-		ret = regmap_bulk_read(max77686->regmap,
-					 MAX77686_REG_INT1, irq_reg, 2);
-		if (ret < 0) {
-			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
-					ret);
-			return IRQ_NONE;
-		}
-
-		if (debug_mask & MAX77686_DEBUG_IRQ_INT)
-			pr_info("%s: int1=0x%x, int2=0x%x\n", __func__,
-				 irq_reg[PMIC_INT1], irq_reg[PMIC_INT2]);
-	}
-
-	if (irq_src & MAX77686_IRQSRC_RTC) {
-		ret = regmap_read(max77686->rtc_regmap,
-					MAX77686_RTC_INT, &irq_reg[RTC_INT]);
-		if (ret < 0) {
-			dev_err(max77686->dev, "Failed to read interrupt source: %d\n",
-					ret);
-			return IRQ_NONE;
-		}
-
-		if (debug_mask & MAX77686_DEBUG_IRQ_INT)
-			pr_info("%s: rtc int=0x%x\n", __func__,
-							 irq_reg[RTC_INT]);
-
-	}
-
-	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++)
-		irq_reg[i] &= ~max77686->irq_masks_cur[i];
-
-	for (i = 0; i < MAX77686_IRQ_NR; i++) {
-		if (irq_reg[max77686_irqs[i].group] & max77686_irqs[i].mask) {
-			cur_irq = irq_find_mapping(max77686->irq_domain, i);
-			if (cur_irq)
-				handle_nested_irq(cur_irq);
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
-static int max77686_irq_domain_map(struct irq_domain *d, unsigned int irq,
-					irq_hw_number_t hw)
-{
-	struct max77686_dev *max77686 = d->host_data;
-
-	irq_set_chip_data(irq, max77686);
-	irq_set_chip_and_handler(irq, &max77686_irq_chip, handle_edge_irq);
-	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
-	irq_set_noprobe(irq);
-#endif
-	return 0;
-}
-
-static struct irq_domain_ops max77686_irq_domain_ops = {
-	.map = max77686_irq_domain_map,
-};
-
-int max77686_irq_init(struct max77686_dev *max77686)
-{
-	struct irq_domain *domain;
-	int i;
-	int ret;
-	int val;
-	struct regmap *map;
-
-	mutex_init(&max77686->irqlock);
-
-	if (max77686->irq_gpio && !max77686->irq) {
-		max77686->irq = gpio_to_irq(max77686->irq_gpio);
-
-		if (debug_mask & MAX77686_DEBUG_IRQ_INT) {
-			ret = gpio_request(max77686->irq_gpio, "pmic_irq");
-			if (ret < 0) {
-				dev_err(max77686->dev,
-					"Failed to request gpio %d with ret:"
-					"%d\n",	max77686->irq_gpio, ret);
-				return IRQ_NONE;
-			}
-
-			gpio_direction_input(max77686->irq_gpio);
-			val = gpio_get_value(max77686->irq_gpio);
-			gpio_free(max77686->irq_gpio);
-			pr_info("%s: gpio_irq=%x\n", __func__, val);
-		}
-	}
-
-	if (!max77686->irq) {
-		dev_err(max77686->dev, "irq is not specified\n");
-		return -ENODEV;
-	}
-
-	/* Mask individual interrupt sources */
-	for (i = 0; i < MAX77686_IRQ_GROUP_NR; i++) {
-		max77686->irq_masks_cur[i] = 0xff;
-		max77686->irq_masks_cache[i] = 0xff;
-		map = max77686_get_regmap(max77686, i);
-
-		if (IS_ERR_OR_NULL(map))
-			continue;
-		if (max77686_mask_reg[i] == MAX77686_REG_INVALID)
-			continue;
-
-		regmap_write(map, max77686_mask_reg[i], 0xff);
-	}
-	domain = irq_domain_add_linear(NULL, MAX77686_IRQ_NR,
-					&max77686_irq_domain_ops, max77686);
-	if (!domain) {
-		dev_err(max77686->dev, "could not create irq domain\n");
-		return -ENODEV;
-	}
-	max77686->irq_domain = domain;
-
-	ret = request_threaded_irq(max77686->irq, NULL, max77686_irq_thread,
-				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   "max77686-irq", max77686);
-
-	if (ret)
-		dev_err(max77686->dev, "Failed to request IRQ %d: %d\n",
-			max77686->irq, ret);
-
-
-	if (debug_mask & MAX77686_DEBUG_IRQ_INFO)
-		pr_info("%s-\n", __func__);
-
-	return 0;
-}
-
-void max77686_irq_exit(struct max77686_dev *max77686)
-{
-	if (max77686->irq)
-		free_irq(max77686->irq, max77686);
-}
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index e5fce76..9b4a854 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -32,6 +32,7 @@
 #include <linux/mfd/max77686-private.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/interrupt.h>
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
@@ -46,6 +47,30 @@ static struct regmap_config max77686_regmap_config = {
 	.val_bits = 8,
 };
 
+static const struct regmap_irq max77686_irqs[] = {
+	{ .reg_offset = 0, .mask = PMIC_INT1_PWRONF_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_PWRONR_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_JIGONBF_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_JIGONBR_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_ACOKBF_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_ACOKBR_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_ONKEY1S_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_MRSTB_MASK, },
+
+	{ .reg_offset = 1, .mask = PMIC_INT2_140C_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_120C_MASK, },
+};
+
+static const struct regmap_irq_chip max77686_irq_chip = {
+	.name                   = "max77686",
+	.status_base            = MAX77686_REG_INT1,
+	.mask_base              = MAX77686_REG_INT1MSK,
+	.mask_invert            = true,
+	.num_regs               = 2,
+	.irqs                   = max77686_irqs,
+	.num_irqs               = ARRAY_SIZE(max77686_irqs),
+};
+
 #ifdef CONFIG_OF
 static struct of_device_id max77686_pmic_dt_match[] = {
 	{.compatible = "maxim,max77686", .data = NULL},
@@ -112,31 +137,46 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
+			IRQF_ONESHOT | IRQF_SHARED |
+			IRQF_TRIGGER_FALLING, 0,
+			&max77686_irq_chip, &max77686->irq_data);
+	if (ret) {
+		dev_err(max77686->dev, "failed to add irq chip: %d\n", ret);
+		return ret;
+	}
+
 	if (regmap_read(max77686->regmap,
 			 MAX77686_REG_DEVICE_ID, &data) < 0) {
 		dev_err(max77686->dev,
 			"device not found on this channel (this is not an error)\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_irq;
 	} else
 		dev_info(max77686->dev, "device found\n");
 
 	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
 	if (!max77686->rtc) {
 		dev_err(max77686->dev, "Failed to allocate I2C device for RTC\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_irq;
 	}
 	i2c_set_clientdata(max77686->rtc, max77686);
 
-	max77686_irq_init(max77686);
-
 	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
 			      ARRAY_SIZE(max77686_devs), NULL, 0, NULL);
 	if (ret < 0) {
-		mfd_remove_devices(max77686->dev);
-		i2c_unregister_device(max77686->rtc);
+		goto err_mfd;
 	}
 
 	return ret;
+
+err_mfd:
+	mfd_remove_devices(max77686->dev);
+	i2c_unregister_device(max77686->rtc);
+err_irq:
+	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
+	return ret;
 }
 
 static int max77686_i2c_remove(struct i2c_client *i2c)
@@ -146,6 +186,8 @@ static int max77686_i2c_remove(struct i2c_client *i2c)
 	mfd_remove_devices(max77686->dev);
 	i2c_unregister_device(max77686->rtc);
 
+	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
+
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 9efe118..b8bc412 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -497,6 +497,25 @@ static struct regmap_config max77686_rtc_regmap_config = {
 	.val_bits = 8,
 };
 
+static const struct regmap_irq max77686_irqs_rtc[] = {
+	{ .mask = RTC_INT_RTC60S_MASK, },
+	{ .mask = RTC_INT_RTCA1_MASK, },
+	{ .mask = RTC_INT_RTCA2_MASK, },
+	{ .mask = RTC_INT_SMPL_MASK, },
+	{ .mask = RTC_INT_RTC1S_MASK, },
+	{ .mask = RTC_INT_WTSR_MASK, },
+};
+
+static const struct regmap_irq_chip max77686_irq_chip_rtc = {
+	.name                   = "max77686-rtc",
+	.status_base            = MAX77686_RTC_INT,
+	.mask_base              = MAX77686_RTC_INTM,
+	.mask_invert            = true,
+	.num_regs               = 2,
+	.irqs                   = max77686_irqs_rtc,
+	.num_irqs               = ARRAY_SIZE(max77686_irqs_rtc),
+};
+
 static int max77686_rtc_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
@@ -522,6 +541,16 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 				ret);
 		return ret;
 	}
+
+	ret = regmap_add_irq_chip(max77686->rtc_regmap, max77686->irq,
+			IRQF_ONESHOT | IRQF_SHARED |
+			IRQF_TRIGGER_FALLING, 0,
+			&max77686_irq_chip_rtc, &max77686->irq_data_rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add irq chip: %d\n", ret);
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, info);
 
 	ret = max77686_rtc_init_reg(info);
@@ -550,7 +579,8 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 			ret = -EINVAL;
 		goto err_rtc;
 	}
-	virq = irq_create_mapping(max77686->irq_domain, MAX77686_RTCIRQ_RTCA1);
+	virq = regmap_irq_get_virq(max77686->irq_data_rtc,
+				   MAX77686_RTCIRQ_RTCA1);
 	if (!virq) {
 		ret = -ENXIO;
 		goto err_rtc;
@@ -564,9 +594,19 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 			info->virq, ret);
 
 err_rtc:
+	regmap_del_irq_chip(max77686->irq, max77686->irq_data_rtc);
 	return ret;
 }
 
+static int max77686_rtc_remove(struct platform_device *pdev)
+{
+	struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
+
+	regmap_del_irq_chip(max77686->irq, max77686->irq_data_rtc);
+
+	return 0;
+}
+
 static void max77686_rtc_shutdown(struct platform_device *pdev)
 {
 #ifdef MAX77686_RTC_WTSR_SMPL
@@ -605,6 +645,7 @@ static struct platform_driver max77686_rtc_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max77686_rtc_probe,
+	.remove		= max77686_rtc_remove,
 	.shutdown	= max77686_rtc_shutdown,
 	.id_table	= rtc_id,
 };
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
index 8c75a9c..efc0762 100644
--- a/include/linux/mfd/max77686-private.h
+++ b/include/linux/mfd/max77686-private.h
@@ -192,6 +192,25 @@ enum max77686_irq_source {
 	MAX77686_IRQ_GROUP_NR,
 };
 
+#define PMIC_INT1_PWRONF_MASK		(0x1 << 0)
+#define PMIC_INT1_PWRONR_MASK		(0x1 << 1)
+#define PMIC_INT1_JIGONBF_MASK		(0x1 << 2)
+#define PMIC_INT1_JIGONBR_MASK		(0x1 << 3)
+#define PMIC_INT1_ACOKBF_MASK		(0x1 << 4)
+#define PMIC_INT1_ACOKBR_MASK		(0x1 << 5)
+#define PMIC_INT1_ONKEY1S_MASK		(0x1 << 6)
+#define PMIC_INT1_MRSTB_MASK		(0x1 << 7)
+
+#define PMIC_INT2_140C_MASK		(0x1 << 0)
+#define PMIC_INT2_120C_MASK		(0x1 << 1)
+
+#define RTC_INT_RTC60S_MASK		(0x1 << 0)
+#define RTC_INT_RTCA1_MASK		(0x1 << 1)
+#define RTC_INT_RTCA2_MASK		(0x1 << 2)
+#define RTC_INT_SMPL_MASK		(0x1 << 3)
+#define RTC_INT_RTC1S_MASK		(0x1 << 4)
+#define RTC_INT_WTSR_MASK		(0x1 << 5)
+
 enum max77686_irq {
 	MAX77686_PMICIRQ_PWRONF,
 	MAX77686_PMICIRQ_PWRONR,
@@ -205,6 +224,10 @@ enum max77686_irq {
 	MAX77686_PMICIRQ_140C,
 	MAX77686_PMICIRQ_120C,
 
+	MAX77686_PMICIRQ_NR,
+};
+
+enum max77686_irq_rtc {
 	MAX77686_RTCIRQ_RTC60S,
 	MAX77686_RTCIRQ_RTCA1,
 	MAX77686_RTCIRQ_RTCA2,
@@ -212,7 +235,7 @@ enum max77686_irq {
 	MAX77686_RTCIRQ_RTC1S,
 	MAX77686_RTCIRQ_WTSR,
 
-	MAX77686_IRQ_NR,
+	MAX77686_RTCIRQ_NR,
 };
 
 struct max77686_dev {
@@ -225,6 +248,9 @@ struct max77686_dev {
 	struct regmap *regmap;		/* regmap for mfd */
 	struct regmap *rtc_regmap;	/* regmap for rtc */
 
+	struct regmap_irq_chip_data *irq_data;
+	struct regmap_irq_chip_data *irq_data_rtc;
+
 	struct irq_domain *irq_domain;
 
 	int irq;
@@ -239,8 +265,4 @@ enum max77686_types {
 	TYPE_MAX77686,
 };
 
-extern int max77686_irq_init(struct max77686_dev *max77686);
-extern void max77686_irq_exit(struct max77686_dev *max77686);
-extern int max77686_irq_resume(struct max77686_dev *max77686);
-
 #endif /*  __LINUX_MFD_MAX77686_PRIV_H */
-- 
1.7.9.5

