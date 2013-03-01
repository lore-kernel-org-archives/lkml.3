Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab3CAMga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:36:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3223 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAMg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:36:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 01 Mar 2013 04:30:47 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <gg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <ian@slimlogic.co.uk>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] mfd: palmas: provide irq flags through DT/platform data
Date: Fri, 1 Mar 2013 18:04:56 +0530
Message-ID: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently driver sets the irq type to IRQF_TRIGGER_LOW which is
causing interrupt registration failure in ARM based SoCs as:
[    0.208479] genirq: Setting trigger mode 8 for irq 118 failed (gic_set_type+0x0/0xf0)
[    0.208513] dummy 0-0059: Failed to request IRQ 118: -22

Provide the irq flags through platform data if device is registered
through board file or get the irq type from DT node property in place
of hardcoding the irq flag in driver to support multiple platforms.

Also configure the device to generate the interrupt signal according to
flag type.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch was 1/3 of earlier patch and the 2/2 is not needed if child
nodes are registered in a recomended DTS file. The discussion is still
going on on the dts file.

However, this patch is independent of discussion and dts file and hence
separating this patch from series and resending as independent patch.

 drivers/mfd/palmas.c       |   42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/mfd/palmas.h |    1 +
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index bbdbc50..25f0eab 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -257,9 +257,24 @@ static struct regmap_irq_chip palmas_irq_chip = {
 			PALMAS_INT1_MASK),
 };
 
-static void palmas_dt_to_pdata(struct device_node *node,
+static int palmas_set_pdata_irq_flag(struct i2c_client *i2c,
 		struct palmas_platform_data *pdata)
 {
+	struct irq_data *irq_data = irq_get_irq_data(i2c->irq);
+	if (!irq_data) {
+		dev_err(&i2c->dev, "Invalid IRQ: %d\n", i2c->irq);
+		return -EINVAL;
+	}
+
+	pdata->irq_flags = irqd_get_trigger_type(irq_data);
+	dev_info(&i2c->dev, "Irq flag is 0x%08x\n", pdata->irq_flags);
+	return 0;
+}
+
+static void palmas_dt_to_pdata(struct i2c_client *i2c,
+		struct palmas_platform_data *pdata)
+{
+	struct device_node *node = i2c->dev.of_node;
 	int ret;
 	u32 prop;
 
@@ -283,6 +298,8 @@ static void palmas_dt_to_pdata(struct device_node *node,
 		pdata->power_ctrl = PALMAS_POWER_CTRL_NSLEEP_MASK |
 					PALMAS_POWER_CTRL_ENABLE1_MASK |
 					PALMAS_POWER_CTRL_ENABLE2_MASK;
+	if (i2c->irq)
+		palmas_set_pdata_irq_flag(i2c, pdata);
 }
 
 static int palmas_i2c_probe(struct i2c_client *i2c,
@@ -304,7 +321,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		if (!pdata)
 			return -ENOMEM;
 
-		palmas_dt_to_pdata(node, pdata);
+		palmas_dt_to_pdata(i2c, pdata);
 	}
 
 	if (!pdata)
@@ -344,6 +361,25 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
+	/* Change interrupt line output polarity */
+	ret = palmas_read(palmas, PALMAS_PU_PD_OD_BASE,
+				PALMAS_POLARITY_CTRL, &reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "POLARITY_CTRL read failed: %d\n", ret);
+		goto err;
+	}
+
+	if (pdata->irq_flags & IRQ_TYPE_LEVEL_HIGH)
+		reg |= PALMAS_POLARITY_CTRL_INT_POLARITY;
+	else
+		reg &= ~PALMAS_POLARITY_CTRL_INT_POLARITY;
+	ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
+			PALMAS_POLARITY_CTRL, reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "POLARITY_CTRL write failed: %d\n", ret);
+		goto err;
+	}
+
 	/* Change IRQ into clear on read mode for efficiency */
 	slave = PALMAS_BASE_TO_SLAVE(PALMAS_INTERRUPT_BASE);
 	addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL);
@@ -352,7 +388,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	regmap_write(palmas->regmap[slave], addr, reg);
 
 	ret = regmap_add_irq_chip(palmas->regmap[slave], palmas->irq,
-			IRQF_ONESHOT | IRQF_TRIGGER_LOW, 0, &palmas_irq_chip,
+			IRQF_ONESHOT | pdata->irq_flags, 0, &palmas_irq_chip,
 			&palmas->irq_data);
 	if (ret < 0)
 		goto err;
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index a4d13d7..3bbda22 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -221,6 +221,7 @@ struct palmas_clk_platform_data {
 };
 
 struct palmas_platform_data {
+	int irq_flags;
 	int gpio_base;
 
 	/* bit value to be loaded to the POWER_CTRL register */
-- 
1.7.1.1

