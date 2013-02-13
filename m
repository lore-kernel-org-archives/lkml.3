Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab3BMNPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:15:14 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8649 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab3BMNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:15:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 13 Feb 2013 05:15:12 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] regmap: irq: Add support for interrupt type
Date: Wed, 13 Feb 2013 18:44:49 +0530
Message-ID: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the MFD module have the GPIO and gpio interrupt is
enabled/disabled through the rising/falling edge type. There
is no specific mask enable/disable registers for GPIO submodules.

Extend the regmap irq to support the irq_set_type() so that
gpio submodule of MFD devices can use the regmap-irq framework
for their interrupt registration.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |   97 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h           |   15 ++++++
 2 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4706c63..e7a1a26 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -39,8 +39,11 @@ struct regmap_irq_chip_data {
 	unsigned int *mask_buf;
 	unsigned int *mask_buf_def;
 	unsigned int *wake_buf;
+	unsigned int *type_buf;
+	unsigned int *type_buf_def;
 
 	unsigned int irq_reg_stride;
+	unsigned int type_reg_stride;
 };
 
 static inline const
@@ -107,6 +110,22 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 		}
 	}
 
+	for (i = 0; i < d->chip->num_type_reg; i++) {
+		if (!d->type_buf_def[i])
+			continue;
+		reg = d->chip->type_base +
+			(i * map->reg_stride * d->type_reg_stride);
+		if (d->chip->type_invert)
+			ret = regmap_update_bits(d->map, reg,
+				d->type_buf_def[i], ~d->type_buf[i]);
+		else
+			ret = regmap_update_bits(d->map, reg,
+				d->type_buf_def[i], d->type_buf[i]);
+		if (ret != 0)
+			dev_err(d->map->dev, "Failed to sync type in %x\n",
+				reg);
+	}
+
 	if (d->chip->runtime_pm)
 		pm_runtime_put(map->dev);
 
@@ -141,6 +160,38 @@ static void regmap_irq_disable(struct irq_data *data)
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
 }
 
+static int regmap_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
+	struct regmap *map = d->map;
+	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
+	int reg = irq_data->type_reg_offset / map->reg_stride;
+
+	if (!(irq_data->type_rising_mask | irq_data->type_falling_mask))
+		return 0;
+
+	d->type_buf[reg] &= ~(irq_data->type_falling_mask |
+					irq_data->type_rising_mask);
+	switch (type) {
+	case IRQ_TYPE_EDGE_FALLING:
+		d->type_buf[reg] |= irq_data->type_falling_mask;
+		break;
+
+	case IRQ_TYPE_EDGE_RISING:
+		d->type_buf[reg] |= irq_data->type_rising_mask;
+		break;
+
+	case IRQ_TYPE_EDGE_BOTH:
+		d->type_buf[reg] |= (irq_data->type_falling_mask |
+					irq_data->type_rising_mask);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
@@ -167,6 +218,7 @@ static const struct irq_chip regmap_irq_chip = {
 	.irq_bus_sync_unlock	= regmap_irq_sync_unlock,
 	.irq_disable		= regmap_irq_disable,
 	.irq_enable		= regmap_irq_enable,
+	.irq_set_type		= regmap_irq_set_type,
 	.irq_set_wake		= regmap_irq_set_wake,
 };
 
@@ -375,6 +427,18 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			goto err_alloc;
 	}
 
+	if (chip->num_type_reg) {
+		d->type_buf_def = kzalloc(sizeof(unsigned int) *
+					chip->num_type_reg, GFP_KERNEL);
+		if (!d->type_buf_def)
+			goto err_alloc;
+
+		d->type_buf = kzalloc(sizeof(unsigned int) * chip->num_type_reg,
+				      GFP_KERNEL);
+		if (!d->type_buf)
+			goto err_alloc;
+	}
+
 	d->irq_chip = regmap_irq_chip;
 	d->irq_chip.name = chip->name;
 	d->irq = irq;
@@ -387,6 +451,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	else
 		d->irq_reg_stride = 1;
 
+	d->type_reg_stride = chip->type_reg_stride ? : 1;
+
 	if (!map->use_single_rw && map->reg_stride == 1 &&
 	    d->irq_reg_stride == 1) {
 		d->status_reg_buf = kmalloc(map->format.val_bytes *
@@ -442,6 +508,33 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		}
 	}
 
+	if (chip->num_type_reg) {
+		for (i = 0; i < chip->num_irqs; i++) {
+			reg = chip->irqs[i].type_reg_offset / map->reg_stride;
+			d->type_buf_def[reg] |= chip->irqs[i].type_rising_mask |
+					chip->irqs[i].type_falling_mask;
+		}
+		for (i = 0; i < chip->num_type_reg; ++i) {
+			if (!d->type_buf_def[i])
+				continue;
+
+			reg = chip->type_base +
+				(i * map->reg_stride * d->type_reg_stride);
+			if (chip->type_invert)
+				ret = regmap_update_bits(map, reg,
+					d->type_buf_def[i], ~d->type_buf[i]);
+			else
+				ret = regmap_update_bits(map, reg,
+					d->type_buf_def[i], d->type_buf[i]);
+			if (ret != 0) {
+				dev_err(map->dev,
+					"Failed to set type in 0x%x: %x\n",
+					reg, ret);
+				goto err_alloc;
+			}
+		}
+	}
+
 	if (irq_base)
 		d->domain = irq_domain_add_legacy(map->dev->of_node,
 						  chip->num_irqs, irq_base, 0,
@@ -468,6 +561,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 err_domain:
 	/* Should really dispose of the domain but... */
 err_alloc:
+	kfree(d->type_buf);
+	kfree(d->type_buf_def);
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
@@ -491,6 +586,8 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 
 	free_irq(irq, d);
 	/* We should unmap the domain but... */
+	kfree(d->type_buf);
+	kfree(d->type_buf_def);
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 5e81abf..c98db7d 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -348,10 +348,16 @@ bool regmap_reg_in_ranges(unsigned int reg,
  *
  * @reg_offset: Offset of the status/mask register within the bank
  * @mask:       Mask used to flag/control the register.
+ * @type_reg_offset: Offset register for the irq type setting.
+ * @type_rising_mask: Mask bit to configure RISING type irq.
+ * @type_falling_mask: Mask bit to configure FALLING type irq.
  */
 struct regmap_irq {
 	unsigned int reg_offset;
 	unsigned int mask;
+	unsigned int type_reg_offset;
+	unsigned int type_rising_mask;
+	unsigned int type_falling_mask;
 };
 
 /**
@@ -365,6 +371,7 @@ struct regmap_irq {
  * @mask_base:   Base mask register address.
  * @ack_base:    Base ack address.  If zero then the chip is clear on read.
  * @wake_base:   Base address for wake enables.  If zero unsupported.
+ * @type_base:   Base address for irq type.  If zero unsupported.
  * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
  * @runtime_pm:  Hold a runtime PM lock on the device when accessing it.
  *
@@ -372,6 +379,9 @@ struct regmap_irq {
  * @irqs:        Descriptors for individual IRQs.  Interrupt numbers are
  *               assigned based on the index in the array of the interrupt.
  * @num_irqs:    Number of descriptors.
+ * @num_type_reg:    Number of type registers.
+ * @type_reg_stride: Stride to use for chips where type registers are not
+ *			contiguous.
  */
 struct regmap_irq_chip {
 	const char *name;
@@ -380,15 +390,20 @@ struct regmap_irq_chip {
 	unsigned int mask_base;
 	unsigned int ack_base;
 	unsigned int wake_base;
+	unsigned int type_base;
 	unsigned int irq_reg_stride;
 	unsigned int mask_invert;
 	unsigned int wake_invert;
+	unsigned int type_invert;
 	bool runtime_pm;
 
 	int num_regs;
 
 	const struct regmap_irq *irqs;
 	int num_irqs;
+
+	int num_type_reg;
+	unsigned int type_reg_stride;
 };
 
 struct regmap_irq_chip_data;
-- 
1.7.1.1

