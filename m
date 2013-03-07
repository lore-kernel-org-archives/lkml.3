Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3CGQfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:35:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7752 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3CGQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:35:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Mar 2013 08:28:58 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 RESEND 1/2] regmap: irq: Add support for interrupt type
Date: Thu, 7 Mar 2013 22:03:17 +0530
Message-ID: <1362673997-6762-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com>
References: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support of setting the irq_type of the interrupt which
is registered through regmap irq framework.

The client who register the interrupt can pass the supported
irq type through irq chip data along with the type mask and
type value of each type which is supported. Client also need
to provide the type base register address and number of type
register to write into the device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Make the irq type value in place of bit wise allocation as suggested in
  patch V1.
- Also added the suboffset register for type so that type
  configuration can be acoomodated in multiple register.
- Rewrite the description.

- Resending in case of it it is missed.

 drivers/base/regmap/regmap-irq.c |  126 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h           |   40 ++++++++++++
 2 files changed, 166 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4706c63..8ca32bc 100644
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
@@ -107,6 +110,24 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 		}
 	}
 
+	for (i = 0; i < d->chip->num_type_reg; i++) {
+		int j;
+		for (j = 0; j < d->chip->num_type_sub_reg; ++j) {
+			int k = i * d->chip->num_type_sub_reg + j;
+
+			if (!d->type_buf_def[k])
+				continue;
+
+			reg = d->chip->type_base +
+				(i * map->reg_stride * d->type_reg_stride)  + j;
+			ret = regmap_update_bits(d->map, reg,
+				d->type_buf_def[k], d->type_buf[k]);
+			if (ret != 0)
+				dev_err(d->map->dev,
+					"Failed to sync type in %x\n", reg);
+		}
+	}
+
 	if (d->chip->runtime_pm)
 		pm_runtime_put(map->dev);
 
@@ -141,6 +162,56 @@ static void regmap_irq_disable(struct irq_data *data)
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
 }
 
+static int regmap_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
+	struct regmap *map = d->map;
+	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
+	int reg;
+
+	if (!irq_data->type_supported_flags)
+		return 0;
+
+	type &= irq_data->type_supported_flags;
+	reg = (irq_data->type_reg_offset / map->reg_stride) *
+			d->chip->num_type_sub_reg +
+			irq_data->type_reg_sub_offset;
+	d->type_buf[reg] &= ~irq_data->type_mask;
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_FALLING:
+		d->type_buf[reg] |=
+			irq_data->type_value[REGMAP_IRQ_TYPE_FALLING];
+		break;
+
+	case IRQ_TYPE_EDGE_RISING:
+		d->type_buf[reg] |=
+			irq_data->type_value[REGMAP_IRQ_TYPE_RISING];
+		break;
+
+	case IRQ_TYPE_EDGE_BOTH:
+		d->type_buf[reg] |=
+			irq_data->type_value[REGMAP_IRQ_TYPE_BOTH];
+		break;
+
+	case IRQ_TYPE_LEVEL_HIGH:
+		d->type_buf[reg] |=
+			irq_data->type_value[REGMAP_IRQ_TYPE_LEVEL_HIGH];
+		break;
+
+	case IRQ_TYPE_LEVEL_LOW:
+		d->type_buf[reg] |=
+			irq_data->type_value[REGMAP_IRQ_TYPE_LEVEL_LOW];
+		break;
+
+	default:
+		d->type_buf[reg] |=
+			irq_data->type_value[REGMAP_IRQ_TYPE_NONE];
+		break;
+	}
+	return 0;
+}
+
 static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
@@ -167,6 +238,7 @@ static const struct irq_chip regmap_irq_chip = {
 	.irq_bus_sync_unlock	= regmap_irq_sync_unlock,
 	.irq_disable		= regmap_irq_disable,
 	.irq_enable		= regmap_irq_enable,
+	.irq_set_type		= regmap_irq_set_type,
 	.irq_set_wake		= regmap_irq_set_wake,
 };
 
@@ -375,6 +447,20 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			goto err_alloc;
 	}
 
+	if (chip->num_type_reg) {
+		d->type_buf_def = kzalloc(sizeof(unsigned int) *
+					chip->num_type_reg *
+					chip->num_type_sub_reg, GFP_KERNEL);
+		if (!d->type_buf_def)
+			goto err_alloc;
+
+		d->type_buf = kzalloc(sizeof(unsigned int) *
+				chip->num_type_reg * chip->num_type_sub_reg,
+				GFP_KERNEL);
+		if (!d->type_buf)
+			goto err_alloc;
+	}
+
 	d->irq_chip = regmap_irq_chip;
 	d->irq_chip.name = chip->name;
 	d->irq = irq;
@@ -387,6 +473,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	else
 		d->irq_reg_stride = 1;
 
+	d->type_reg_stride = chip->type_reg_stride ? : 1;
+
 	if (!map->use_single_rw && map->reg_stride == 1 &&
 	    d->irq_reg_stride == 1) {
 		d->status_reg_buf = kmalloc(map->format.val_bytes *
@@ -442,6 +530,40 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		}
 	}
 
+	if (chip->num_type_reg) {
+		for (i = 0; i < chip->num_irqs; i++) {
+			int tv = chip->irqs[i].type_value[REGMAP_IRQ_TYPE_NONE];
+
+			reg = (chip->irqs[i].type_reg_offset /
+				map->reg_stride) * chip->num_type_sub_reg +
+					chip->irqs[i].type_reg_sub_offset;
+			d->type_buf_def[reg] |= chip->irqs[i].type_mask;
+			d->type_buf[reg] |= (tv & chip->irqs[i].type_mask);
+		}
+
+		for (i = 0; i < chip->num_type_reg; ++i) {
+			int j;
+			for (j = 0; j < chip->num_type_sub_reg; ++j) {
+				int k = i * chip->num_type_sub_reg + j;
+
+				if (!d->type_buf_def[k])
+					continue;
+
+				reg = chip->type_base + (i * map->reg_stride *
+						d->type_reg_stride) + j;
+
+				ret = regmap_update_bits(map, reg,
+					d->type_buf_def[k], d->type_buf[k]);
+				if (ret != 0) {
+					dev_err(map->dev,
+					"Failed to set type in 0x%x: %x\n",
+					reg, ret);
+					goto err_alloc;
+				}
+			}
+		}
+	}
+
 	if (irq_base)
 		d->domain = irq_domain_add_legacy(map->dev->of_node,
 						  chip->num_irqs, irq_base, 0,
@@ -468,6 +590,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 err_domain:
 	/* Should really dispose of the domain but... */
 err_alloc:
+	kfree(d->type_buf);
+	kfree(d->type_buf_def);
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
@@ -491,6 +615,8 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 
 	free_irq(irq, d);
 	/* We should unmap the domain but... */
+	kfree(d->type_buf);
+	kfree(d->type_buf_def);
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e34f9f1..c07fcb8 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -376,14 +376,42 @@ bool regmap_reg_in_ranges(unsigned int reg,
 			  unsigned int nranges);
 
 /**
+ * The Regmap IRQ type Index
+ * REGMAP_IRQ_TYPE_NONE is used for setting inital value for clearing type.
+ */
+enum {
+	REGMAP_IRQ_TYPE_NONE,
+	REGMAP_IRQ_TYPE_RISING,
+	REGMAP_IRQ_TYPE_FALLING,
+	REGMAP_IRQ_TYPE_BOTH,
+	REGMAP_IRQ_TYPE_LEVEL_HIGH,
+	REGMAP_IRQ_TYPE_LEVEL_LOW,
+
+	/* Last entry to get maximum index */
+	REGMAP_IRQ_TYPE_NR,
+};
+
+/**
  * Description of an IRQ for the generic regmap irq_chip.
  *
  * @reg_offset: Offset of the status/mask register within the bank
  * @mask:       Mask used to flag/control the register.
+ * @type_reg_offset: Offset register for the irq type setting.
+ * @type_reg_sub_offset: Suboffset for type register if type mask are
+ *              accomodated in the multiple register.
+ * @type_supported_flags: Supported interrupt type as per interrupt.h.
+ *             All supported flags are ORed.
+ * type_mask: Type mask for getting related register bits.
+ * @type_value: The type value in array form to set value for a given flag.
  */
 struct regmap_irq {
 	unsigned int reg_offset;
 	unsigned int mask;
+	unsigned int type_reg_offset;
+	unsigned int type_reg_sub_offset;
+	unsigned int type_supported_flags;
+	unsigned int type_mask;
+	unsigned int type_value[REGMAP_IRQ_TYPE_NR];
 };
 
 /**
@@ -397,6 +425,7 @@ struct regmap_irq {
  * @mask_base:   Base mask register address.
  * @ack_base:    Base ack address.  If zero then the chip is clear on read.
  * @wake_base:   Base address for wake enables.  If zero unsupported.
+ * @type_base:   Base address for irq type.  If zero unsupported.
  * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
  * @runtime_pm:  Hold a runtime PM lock on the device when accessing it.
  *
@@ -404,6 +433,12 @@ struct regmap_irq {
  * @irqs:        Descriptors for individual IRQs.  Interrupt numbers are
  *               assigned based on the index in the array of the interrupt.
  * @num_irqs:    Number of descriptors.
+ * @num_type_reg:    Number of type registers.
+ * @num_type_sub_reg: Number of sub register for type. It may be possible that
+ *               type configuration register for given set on interrupt from one
+ *               register are having multiple register for type configuration.
+ * @type_reg_stride: Stride to use for chips where type registers are not
+ *			contiguous.
  */
 struct regmap_irq_chip {
 	const char *name;
@@ -412,6 +447,7 @@ struct regmap_irq_chip {
 	unsigned int mask_base;
 	unsigned int ack_base;
 	unsigned int wake_base;
+	unsigned int type_base;
 	unsigned int irq_reg_stride;
 	unsigned int mask_invert;
 	unsigned int wake_invert;
@@ -421,6 +457,10 @@ struct regmap_irq_chip {
 
 	const struct regmap_irq *irqs;
 	int num_irqs;
+
+	int num_type_reg;
+	int num_type_sub_reg;
+	unsigned int type_reg_stride;
 };
 
 struct regmap_irq_chip_data;
-- 
1.7.1.1

