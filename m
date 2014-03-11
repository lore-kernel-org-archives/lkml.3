Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaCKN7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:59:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34094 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaCKN7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:59:03 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-c2-531f16a43be2
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/3] mfd: max8997: handle IRQs using regmap
Date: Tue, 11 Mar 2014 14:58:23 +0100
Message-id: <1394546304-15191-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
References: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQd0lYvLBBj9mqFgsuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi9cvDC3ufz3KaPHtSgeTxc1P31gtLu+aw2ax
	9c06Rou1R+6yW9xuXMFmcW3vcWaLB4d3slvs3vWU1WJ/ZwejxeluVgcRj52z7rJ77Jl4ks1j
	8wotj02rOtk87lzbw+Yx72Sgx575P1g9+rasYvSYPu8nk8fnTXIe67dsZQrgjuKySUnNySxL
	LdK3S+DKaJi0i71g4hrGio8P77A2MG7pZexi5OCQEDCRuDRLoIuRE8gUk7hwbz1bFyMXh5DA
	dEaJ+Sdes4MkhATamSSWrywDsdkEdCS2fJ/ACGKLCOhLfNhxlRmkgVngJrPEnDP9YEOFBawl
	1jxXBalhEVCVeL/tMROIzSvgKvFg+UF2iL0KEnMm2YCEOQXcJK7PncwCscpVYu6xV+wTGHkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOhWdSOxhXNlgcYhTgYFTi4Q3wlQsWYk0s
	K67MPcQowcGsJMJ78R5QiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUAyPny1X8vfwHeQL+1HYe7mFfsk1KMeRaywtxqfaLU9TfpD/5WDjHuTfm4rv7zTzq
	7D5PvN0WhvFK1/r2J5wMSntXGbfAl2X/409PL8iI6q89KtbGMluM3UUg/p+CyO9FOe9Kzs2Y
	dOJzwXNl1gXHdtbNfa37x9lkK6ucC9+79Xd6si/yXWp5e0CJpTgj0VCLuag4EQBetsm9gQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies mfd driver to use regmap for handling interrupts.
It allows to simplify irq handling process. This modifications needed
to make small changes in function drivers, which use interrupts.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max8997.c     |    3 +-
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8997-irq.c           |  373 -----------------------------------
 drivers/mfd/max8997.c               |   91 ++++++++-
 drivers/rtc/rtc-max8997.c           |    2 +-
 include/linux/mfd/max8997-private.h |   63 +++++-
 6 files changed, 147 insertions(+), 387 deletions(-)
 delete mode 100644 drivers/mfd/max8997-irq.c

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index f258c08..5948061 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -679,7 +679,8 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
 		unsigned int virq = 0;
 
-		virq = irq_create_mapping(max8997->irq_domain, muic_irq->irq);
+		virq = regmap_irq_get_virq(max8997->irq_data_muic,
+					muic_irq->irq);
 		if (!virq) {
 			ret = -EINVAL;
 			goto err_irq;
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5aea5ef..db2a1eb 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -117,7 +117,7 @@ obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
-obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
+obj-$(CONFIG_MFD_MAX8997)	+= max8997.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
deleted file mode 100644
index 656d03b..0000000
--- a/drivers/mfd/max8997-irq.c
+++ /dev/null
@@ -1,373 +0,0 @@
-/*
- * max8997-irq.c - Interrupt controller support for MAX8997
- *
- * Copyright (C) 2011 Samsung Electronics Co.Ltd
- * MyungJoo Ham <myungjoo.ham@samsung.com>
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
- * This driver is based on max8998-irq.c
- */
-
-#include <linux/err.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/mfd/max8997.h>
-#include <linux/mfd/max8997-private.h>
-#include <linux/regmap.h>
-
-static const u8 max8997_mask_reg[] = {
-	[PMIC_INT1] = MAX8997_REG_INT1MSK,
-	[PMIC_INT2] = MAX8997_REG_INT2MSK,
-	[PMIC_INT3] = MAX8997_REG_INT3MSK,
-	[PMIC_INT4] = MAX8997_REG_INT4MSK,
-	[FUEL_GAUGE] = MAX8997_REG_INVALID,
-	[MUIC_INT1] = MAX8997_MUIC_REG_INTMASK1,
-	[MUIC_INT2] = MAX8997_MUIC_REG_INTMASK2,
-	[MUIC_INT3] = MAX8997_MUIC_REG_INTMASK3,
-	[GPIO_LOW] = MAX8997_REG_INVALID,
-	[GPIO_HI] = MAX8997_REG_INVALID,
-	[FLASH_STATUS] = MAX8997_REG_INVALID,
-};
-
-struct max8997_irq_data {
-	int mask;
-	enum max8997_irq_source group;
-};
-
-#define DECLARE_IRQ(idx, _group, _mask)		\
-	[(idx)] = { .group = (_group), .mask = (_mask) }
-static const struct max8997_irq_data max8997_irqs[] = {
-	DECLARE_IRQ(MAX8997_PMICIRQ_PWRONR,	PMIC_INT1, 1 << 0),
-	DECLARE_IRQ(MAX8997_PMICIRQ_PWRONF,	PMIC_INT1, 1 << 1),
-	DECLARE_IRQ(MAX8997_PMICIRQ_PWRON1SEC,	PMIC_INT1, 1 << 3),
-	DECLARE_IRQ(MAX8997_PMICIRQ_JIGONR,	PMIC_INT1, 1 << 4),
-	DECLARE_IRQ(MAX8997_PMICIRQ_JIGONF,	PMIC_INT1, 1 << 5),
-	DECLARE_IRQ(MAX8997_PMICIRQ_LOWBAT2,	PMIC_INT1, 1 << 6),
-	DECLARE_IRQ(MAX8997_PMICIRQ_LOWBAT1,	PMIC_INT1, 1 << 7),
-
-	DECLARE_IRQ(MAX8997_PMICIRQ_JIGR,	PMIC_INT2, 1 << 0),
-	DECLARE_IRQ(MAX8997_PMICIRQ_JIGF,	PMIC_INT2, 1 << 1),
-	DECLARE_IRQ(MAX8997_PMICIRQ_MR,		PMIC_INT2, 1 << 2),
-	DECLARE_IRQ(MAX8997_PMICIRQ_DVS1OK,	PMIC_INT2, 1 << 3),
-	DECLARE_IRQ(MAX8997_PMICIRQ_DVS2OK,	PMIC_INT2, 1 << 4),
-	DECLARE_IRQ(MAX8997_PMICIRQ_DVS3OK,	PMIC_INT2, 1 << 5),
-	DECLARE_IRQ(MAX8997_PMICIRQ_DVS4OK,	PMIC_INT2, 1 << 6),
-
-	DECLARE_IRQ(MAX8997_PMICIRQ_CHGINS,	PMIC_INT3, 1 << 0),
-	DECLARE_IRQ(MAX8997_PMICIRQ_CHGRM,	PMIC_INT3, 1 << 1),
-	DECLARE_IRQ(MAX8997_PMICIRQ_DCINOVP,	PMIC_INT3, 1 << 2),
-	DECLARE_IRQ(MAX8997_PMICIRQ_TOPOFFR,	PMIC_INT3, 1 << 3),
-	DECLARE_IRQ(MAX8997_PMICIRQ_CHGRSTF,	PMIC_INT3, 1 << 5),
-	DECLARE_IRQ(MAX8997_PMICIRQ_MBCHGTMEXPD,	PMIC_INT3, 1 << 7),
-
-	DECLARE_IRQ(MAX8997_PMICIRQ_RTC60S,	PMIC_INT4, 1 << 0),
-	DECLARE_IRQ(MAX8997_PMICIRQ_RTCA1,	PMIC_INT4, 1 << 1),
-	DECLARE_IRQ(MAX8997_PMICIRQ_RTCA2,	PMIC_INT4, 1 << 2),
-	DECLARE_IRQ(MAX8997_PMICIRQ_SMPL_INT,	PMIC_INT4, 1 << 3),
-	DECLARE_IRQ(MAX8997_PMICIRQ_RTC1S,	PMIC_INT4, 1 << 4),
-	DECLARE_IRQ(MAX8997_PMICIRQ_WTSR,	PMIC_INT4, 1 << 5),
-
-	DECLARE_IRQ(MAX8997_MUICIRQ_ADCError,	MUIC_INT1, 1 << 2),
-	DECLARE_IRQ(MAX8997_MUICIRQ_ADCLow,	MUIC_INT1, 1 << 1),
-	DECLARE_IRQ(MAX8997_MUICIRQ_ADC,	MUIC_INT1, 1 << 0),
-
-	DECLARE_IRQ(MAX8997_MUICIRQ_VBVolt,	MUIC_INT2, 1 << 4),
-	DECLARE_IRQ(MAX8997_MUICIRQ_DBChg,	MUIC_INT2, 1 << 3),
-	DECLARE_IRQ(MAX8997_MUICIRQ_DCDTmr,	MUIC_INT2, 1 << 2),
-	DECLARE_IRQ(MAX8997_MUICIRQ_ChgDetRun,	MUIC_INT2, 1 << 1),
-	DECLARE_IRQ(MAX8997_MUICIRQ_ChgTyp,	MUIC_INT2, 1 << 0),
-
-	DECLARE_IRQ(MAX8997_MUICIRQ_OVP,	MUIC_INT3, 1 << 2),
-};
-
-static void max8997_irq_lock(struct irq_data *data)
-{
-	struct max8997_dev *max8997 = irq_get_chip_data(data->irq);
-
-	mutex_lock(&max8997->irqlock);
-}
-
-static void max8997_irq_sync_unlock(struct irq_data *data)
-{
-	struct max8997_dev *max8997 = irq_get_chip_data(data->irq);
-	int i;
-
-	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
-		struct regmap *map;
-		u8 mask_reg = max8997_mask_reg[i];
-
-		if (i >= MUIC_INT1 && i <= MUIC_INT3)
-			map = max8997->regmap_muic;
-		else
-			map = max8997->regmap;
-
-		if (mask_reg == MAX8997_REG_INVALID ||
-				IS_ERR_OR_NULL(map))
-			continue;
-		max8997->irq_masks_cache[i] = max8997->irq_masks_cur[i];
-
-		regmap_write(map, max8997_mask_reg[i],
-				max8997->irq_masks_cur[i]);
-	}
-
-	mutex_unlock(&max8997->irqlock);
-}
-
-static const inline struct max8997_irq_data *
-irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
-{
-	struct irq_data *data = irq_get_irq_data(irq);
-	return &max8997_irqs[data->hwirq];
-}
-
-static void max8997_irq_mask(struct irq_data *data)
-{
-	struct max8997_dev *max8997 = irq_get_chip_data(data->irq);
-	const struct max8997_irq_data *irq_data = irq_to_max8997_irq(max8997,
-								data->irq);
-
-	max8997->irq_masks_cur[irq_data->group] |= irq_data->mask;
-}
-
-static void max8997_irq_unmask(struct irq_data *data)
-{
-	struct max8997_dev *max8997 = irq_get_chip_data(data->irq);
-	const struct max8997_irq_data *irq_data = irq_to_max8997_irq(max8997,
-								data->irq);
-
-	max8997->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
-}
-
-static struct irq_chip max8997_irq_chip = {
-	.name			= "max8997",
-	.irq_bus_lock		= max8997_irq_lock,
-	.irq_bus_sync_unlock	= max8997_irq_sync_unlock,
-	.irq_mask		= max8997_irq_mask,
-	.irq_unmask		= max8997_irq_unmask,
-};
-
-#define MAX8997_IRQSRC_PMIC		(1 << 1)
-#define MAX8997_IRQSRC_FUELGAUGE	(1 << 2)
-#define MAX8997_IRQSRC_MUIC		(1 << 3)
-#define MAX8997_IRQSRC_GPIO		(1 << 4)
-#define MAX8997_IRQSRC_FLASH		(1 << 5)
-static irqreturn_t max8997_irq_thread(int irq, void *data)
-{
-	struct max8997_dev *max8997 = data;
-	unsigned int irq_reg[MAX8997_IRQ_GROUP_NR] = {};
-	unsigned int irq_src;
-	int ret;
-	int i, cur_irq;
-
-	ret = regmap_read(max8997->regmap, MAX8997_REG_INTSRC, &irq_src);
-	if (ret < 0) {
-		dev_err(max8997->dev, "Failed to read interrupt source: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	if (irq_src & MAX8997_IRQSRC_PMIC) {
-		/* PMIC INT1 ~ INT4 */
-		for (i = 0; i < 4; ++i)
-			regmap_read(max8997->regmap,
-				MAX8997_REG_INT1+i, &irq_reg[PMIC_INT1+i]);
-	}
-	if (irq_src & MAX8997_IRQSRC_FUELGAUGE) {
-		/*
-		 * TODO: FUEL GAUGE
-		 *
-		 * This is to be supported by Max17042 driver. When
-		 * an interrupt incurs here, it should be relayed to a
-		 * Max17042 device that is connected (probably by
-		 * platform-data). However, we do not have interrupt
-		 * handling in Max17042 driver currently. The Max17042 IRQ
-		 * driver should be ready to be used as a stand-alone device and
-		 * a Max8997-dependent device. Because it is not ready in
-		 * Max17042-side and it is not too critical in operating
-		 * Max8997, we do not implement this in initial releases.
-		 */
-		irq_reg[FUEL_GAUGE] = 0;
-	}
-	if (irq_src & MAX8997_IRQSRC_MUIC) {
-		/* MUIC INT1 ~ INT3 */
-		for (i = 0; i < 3; ++i)
-			regmap_read(max8997->regmap_muic,
-				MAX8997_MUIC_REG_INT1+i, &irq_reg[MUIC_INT1+i]);
-	}
-	if (irq_src & MAX8997_IRQSRC_GPIO) {
-		/* GPIO Interrupt */
-		u8 gpio_info[MAX8997_NUM_GPIO];
-
-		irq_reg[GPIO_LOW] = 0;
-		irq_reg[GPIO_HI] = 0;
-
-		regmap_bulk_read(max8997->regmap, MAX8997_REG_GPIOCNTL1,
-				gpio_info, MAX8997_NUM_GPIO);
-		for (i = 0; i < MAX8997_NUM_GPIO; i++) {
-			bool interrupt = false;
-
-			switch (gpio_info[i] & MAX8997_GPIO_INT_MASK) {
-			case MAX8997_GPIO_INT_BOTH:
-				if (max8997->gpio_status[i] != gpio_info[i])
-					interrupt = true;
-				break;
-			case MAX8997_GPIO_INT_RISE:
-				if ((max8997->gpio_status[i] != gpio_info[i]) &&
-				    (gpio_info[i] & MAX8997_GPIO_DATA_MASK))
-					interrupt = true;
-				break;
-			case MAX8997_GPIO_INT_FALL:
-				if ((max8997->gpio_status[i] != gpio_info[i]) &&
-				    !(gpio_info[i] & MAX8997_GPIO_DATA_MASK))
-					interrupt = true;
-				break;
-			default:
-				break;
-			}
-
-			if (interrupt) {
-				if (i < 8)
-					irq_reg[GPIO_LOW] |= (1 << i);
-				else
-					irq_reg[GPIO_HI] |= (1 << (i - 8));
-			}
-
-		}
-	}
-	if (irq_src & MAX8997_IRQSRC_FLASH) {
-		/* Flash Status Interrupt */
-		ret = regmap_read(max8997->regmap, MAX8997_REG_FLASHSTATUS,
-				&irq_reg[FLASH_STATUS]);
-	}
-
-	/* Apply masking */
-	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++)
-		irq_reg[i] &= ~max8997->irq_masks_cur[i];
-
-	/* Report */
-	for (i = 0; i < MAX8997_IRQ_NR; i++) {
-		if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask) {
-			cur_irq = irq_find_mapping(max8997->irq_domain, i);
-			if (cur_irq)
-				handle_nested_irq(cur_irq);
-		}
-	}
-
-	return IRQ_HANDLED;
-}
-
-int max8997_irq_resume(struct max8997_dev *max8997)
-{
-	if (max8997->irq && max8997->irq_domain)
-		max8997_irq_thread(0, max8997);
-	return 0;
-}
-
-static int max8997_irq_domain_map(struct irq_domain *d, unsigned int irq,
-					irq_hw_number_t hw)
-{
-	struct max8997_dev *max8997 = d->host_data;
-
-	irq_set_chip_data(irq, max8997);
-	irq_set_chip_and_handler(irq, &max8997_irq_chip, handle_edge_irq);
-	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
-	irq_set_noprobe(irq);
-#endif
-	return 0;
-}
-
-static struct irq_domain_ops max8997_irq_domain_ops = {
-	.map = max8997_irq_domain_map,
-};
-
-int max8997_irq_init(struct max8997_dev *max8997)
-{
-	struct irq_domain *domain;
-	int i;
-	int ret;
-	unsigned int val;
-
-	if (!max8997->irq) {
-		dev_warn(max8997->dev, "No interrupt specified.\n");
-		return 0;
-	}
-
-	mutex_init(&max8997->irqlock);
-
-	/* Mask individual interrupt sources */
-	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
-		max8997->irq_masks_cur[i] = 0xff;
-		max8997->irq_masks_cache[i] = 0xff;
-
-		if (IS_ERR_OR_NULL(max8997->regmap))
-			continue;
-		if (max8997_mask_reg[i] == MAX8997_REG_INVALID)
-			continue;
-
-		regmap_write(max8997->regmap, max8997_mask_reg[i], 0xff);
-	}
-
-	for (i = 0; i < MAX8997_NUM_GPIO; i++) {
-		max8997->gpio_status[i] = (regmap_read(max8997->regmap,
-						MAX8997_REG_GPIOCNTL1 + i,
-						&val)
-					& MAX8997_GPIO_DATA_MASK) ?
-					true : false;
-	}
-
-	domain = irq_domain_add_linear(NULL, MAX8997_IRQ_NR,
-					&max8997_irq_domain_ops, max8997);
-	if (!domain) {
-		dev_err(max8997->dev, "could not create irq domain\n");
-		return -ENODEV;
-	}
-	max8997->irq_domain = domain;
-
-	ret = request_threaded_irq(max8997->irq, NULL, max8997_irq_thread,
-			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-			"max8997-irq", max8997);
-
-	if (ret) {
-		dev_err(max8997->dev, "Failed to request IRQ %d: %d\n",
-				max8997->irq, ret);
-		return ret;
-	}
-
-	if (!max8997->ono)
-		return 0;
-
-	ret = request_threaded_irq(max8997->ono, NULL, max8997_irq_thread,
-			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING |
-			IRQF_ONESHOT, "max8997-ono", max8997);
-
-	if (ret)
-		dev_err(max8997->dev, "Failed to request ono-IRQ %d: %d\n",
-				max8997->ono, ret);
-
-	return 0;
-}
-
-void max8997_irq_exit(struct max8997_dev *max8997)
-{
-	if (max8997->ono)
-		free_irq(max8997->ono, max8997);
-
-	if (max8997->irq)
-		free_irq(max8997->irq, max8997);
-}
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index ca6f310..9b6edfa 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -64,6 +64,49 @@ static const struct regmap_config max8997_regmap_config = {
 	.max_register = MAX8997_REG_PMIC_END,
 };
 
+static const struct regmap_irq max8997_irqs[] = {
+	/* PMIC_INT1 interrupts */
+	{ .reg_offset = 0, .mask = PMIC_INT1_PWRONR_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_PWRONF_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_PWRON1SEC_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_JIGONR_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_JIGONF_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_LOWBAT2_MASK, },
+	{ .reg_offset = 0, .mask = PMIC_INT1_LOWBAT1_MASK, },
+	/* PMIC_INT2 interrupts */
+	{ .reg_offset = 1, .mask = PMIC_INT2_JIGR_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_JIGF_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_MR_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_DVS1OK_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_DVS2OK_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_DVS3OK_MASK, },
+	{ .reg_offset = 1, .mask = PMIC_INT2_DVS4OK_MASK, },
+	/* PMIC_INT3 interrupts */
+	{ .reg_offset = 2, .mask = PMIC_INT3_CHGINS_MASK, },
+	{ .reg_offset = 2, .mask = PMIC_INT3_CHGRM_MASK, },
+	{ .reg_offset = 2, .mask = PMIC_INT3_DCINOVP_MASK, },
+	{ .reg_offset = 2, .mask = PMIC_INT3_TOPOFFR_MASK, },
+	{ .reg_offset = 2, .mask = PMIC_INT3_CHGRSTF_MASK, },
+	{ .reg_offset = 2, .mask = PMIC_INT3_MBCHGTMEXPD_MASK, },
+	/* PMIC_INT4 interrupts */
+	{ .reg_offset = 3, .mask = PMIC_INT4_RTC60S_MASK, },
+	{ .reg_offset = 3, .mask = PMIC_INT4_RTCA1_MASK, },
+	{ .reg_offset = 3, .mask = PMIC_INT4_RTCA2_MASK, },
+	{ .reg_offset = 3, .mask = PMIC_INT4_SMPL_INT_MASK, },
+	{ .reg_offset = 3, .mask = PMIC_INT4_RTC1S_MASK, },
+	{ .reg_offset = 3, .mask = PMIC_INT4_WTSR_MASK, },
+};
+
+static const struct regmap_irq_chip max8997_irq_chip = {
+	.name			= "max8997",
+	.status_base		= MAX8997_REG_INT1,
+	.mask_base		= MAX8997_REG_INT1MSK,
+	.mask_invert		= false,
+	.num_regs		= 4,
+	.irqs			= max8997_irqs,
+	.num_irqs		= ARRAY_SIZE(max8997_irqs),
+};
+
 static const struct regmap_config max8997_regmap_rtc_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -82,6 +125,31 @@ static const struct regmap_config max8997_regmap_muic_config = {
 	.max_register = MAX8997_MUIC_REG_END,
 };
 
+static const struct regmap_irq max8997_irqs_muic[] = {
+	/* MUIC_INT1 interrupts */
+	{ .reg_offset = 0, .mask = MUIC_INT1_ADC_MASK, },
+	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLow_MASK, },
+	{ .reg_offset = 0, .mask = MUIC_INT1_ADCError_MASK, },
+	/* MUIC_INT2 interrupts */
+	{ .reg_offset = 1, .mask = MUIC_INT2_ChgTyp_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_ChgDetRun_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTmr_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_DBChg_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_VBVolt_MASK, },
+	/* MUIC_INT3 interrupts */
+	{ .reg_offset = 2, .mask = MUIC_INT3_OVP_MASK, },
+};
+
+static const struct regmap_irq_chip max8997_irq_chip_muic = {
+	.name			= "max8997-muic",
+	.status_base		= MAX8997_MUIC_REG_INT1,
+	.mask_base		= MAX8997_MUIC_REG_INTMASK1,
+	.mask_invert		= true,
+	.num_regs		= 3,
+	.irqs			= max8997_irqs_muic,
+	.num_irqs		= ARRAY_SIZE(max8997_irqs_muic),
+};
+
 /*
  * Only the common platform data elements for max8997 are parsed here from the
  * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
@@ -173,6 +241,15 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	ret = regmap_add_irq_chip(max8997->regmap, max8997->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max8997_irq_chip, &max8997->irq_data);
+	if (ret) {
+		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
+		return ret;
+	}
+
 	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
 					&max8997_regmap_rtc_config);
 	if (IS_ERR(max8997->regmap_rtc)) {
@@ -200,9 +277,17 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 		goto err_regmap;
 	}
 
-	pm_runtime_set_active(max8997->dev);
+	ret = regmap_add_irq_chip(max8997->regmap_muic, max8997->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max8997_irq_chip_muic,
+				&max8997->irq_data_muic);
+	if (ret) {
+		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
+		return ret;
+	}
 
-	max8997_irq_init(max8997);
+	pm_runtime_set_active(max8997->dev);
 
 	ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
 			ARRAY_SIZE(max8997_devs),
@@ -464,7 +549,7 @@ static int max8997_resume(struct device *dev)
 
 	if (device_may_wakeup(dev))
 		irq_set_irq_wake(max8997->irq, 0);
-	return max8997_irq_resume(max8997);
+	return 0;
 }
 
 static const struct dev_pm_ops max8997_pm = {
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index b866f7d5..22769ea 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -494,7 +494,7 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	virq = irq_create_mapping(max8997->irq_domain, MAX8997_PMICIRQ_RTCA1);
+	virq = regmap_irq_get_virq(max8997->irq_data, MAX8997_PMICIRQ_RTCA1);
 	if (!virq) {
 		dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
 		ret = -ENXIO;
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index ea80ef8..af2f0aa 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -333,6 +333,48 @@ enum max8997_irq_source {
 	MAX8997_IRQ_GROUP_NR,
 };
 
+#define PMIC_INT1_PWRONR_MASK		(0x1 << 0)
+#define PMIC_INT1_PWRONF_MASK		(0x1 << 1)
+#define PMIC_INT1_PWRON1SEC_MASK	(0x1 << 3)
+#define PMIC_INT1_JIGONR_MASK		(0x1 << 4)
+#define PMIC_INT1_JIGONF_MASK		(0x1 << 5)
+#define PMIC_INT1_LOWBAT2_MASK		(0x1 << 6)
+#define PMIC_INT1_LOWBAT1_MASK		(0x1 << 7)
+
+#define PMIC_INT2_JIGR_MASK		(0x1 << 0)
+#define PMIC_INT2_JIGF_MASK		(0x1 << 1)
+#define PMIC_INT2_MR_MASK		(0x1 << 2)
+#define PMIC_INT2_DVS1OK_MASK		(0x1 << 3)
+#define PMIC_INT2_DVS2OK_MASK		(0x1 << 4)
+#define PMIC_INT2_DVS3OK_MASK		(0x1 << 5)
+#define PMIC_INT2_DVS4OK_MASK		(0x1 << 6)
+
+#define PMIC_INT3_CHGINS_MASK		(0x1 << 0)
+#define PMIC_INT3_CHGRM_MASK		(0x1 << 1)
+#define PMIC_INT3_DCINOVP_MASK		(0x1 << 2)
+#define PMIC_INT3_TOPOFFR_MASK		(0x1 << 3)
+#define PMIC_INT3_CHGRSTF_MASK		(0x1 << 5)
+#define PMIC_INT3_MBCHGTMEXPD_MASK	(0x1 << 7)
+
+#define PMIC_INT4_RTC60S_MASK		(0x1 << 0)
+#define PMIC_INT4_RTCA1_MASK		(0x1 << 1)
+#define PMIC_INT4_RTCA2_MASK		(0x1 << 2)
+#define PMIC_INT4_SMPL_INT_MASK		(0x1 << 3)
+#define PMIC_INT4_RTC1S_MASK		(0x1 << 4)
+#define PMIC_INT4_WTSR_MASK		(0x1 << 5)
+
+#define MUIC_INT1_ADC_MASK		(0x1 << 0)
+#define MUIC_INT1_ADCLow_MASK		(0x1 << 1)
+#define MUIC_INT1_ADCError_MASK		(0x1 << 2)
+
+#define MUIC_INT2_ChgTyp_MASK		(0x1 << 0)
+#define MUIC_INT2_ChgDetRun_MASK	(0x1 << 1)
+#define MUIC_INT2_DCDTmr_MASK		(0x1 << 2)
+#define MUIC_INT2_DBChg_MASK		(0x1 << 3)
+#define MUIC_INT2_VBVolt_MASK		(0x1 << 4)
+
+#define MUIC_INT3_OVP_MASK		(0x1 << 2)
+
 enum max8997_irq {
 	MAX8997_PMICIRQ_PWRONR,
 	MAX8997_PMICIRQ_PWRONF,
@@ -364,19 +406,23 @@ enum max8997_irq {
 	MAX8997_PMICIRQ_RTC1S,
 	MAX8997_PMICIRQ_WTSR,
 
-	MAX8997_MUICIRQ_ADCError,
-	MAX8997_MUICIRQ_ADCLow,
+	MAX8997_PMICIRQ_NR,
+};
+
+enum max8997_irq_muic {
 	MAX8997_MUICIRQ_ADC,
+	MAX8997_MUICIRQ_ADCLow,
+	MAX8997_MUICIRQ_ADCError,
 
-	MAX8997_MUICIRQ_VBVolt,
-	MAX8997_MUICIRQ_DBChg,
-	MAX8997_MUICIRQ_DCDTmr,
-	MAX8997_MUICIRQ_ChgDetRun,
 	MAX8997_MUICIRQ_ChgTyp,
+	MAX8997_MUICIRQ_ChgDetRun,
+	MAX8997_MUICIRQ_DCDTmr,
+	MAX8997_MUICIRQ_DBChg,
+	MAX8997_MUICIRQ_VBVolt,
 
 	MAX8997_MUICIRQ_OVP,
 
-	MAX8997_IRQ_NR,
+	MAX8997_MUCIRQ_NR,
 };
 
 #define MAX8997_NUM_GPIO	12
@@ -397,9 +443,10 @@ struct max8997_dev {
 	struct regmap *regmap_haptic;
 	struct regmap *regmap_muic;
 
+	struct regmap_irq_chip_data *irq_data;
+	struct regmap_irq_chip_data *irq_data_muic;
 	int irq;
 	int ono;
-	struct irq_domain *irq_domain;
 	struct mutex irqlock;
 	int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
 	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
-- 
1.7.9.5

