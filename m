Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3LQAJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:09:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41010 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3LQAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:09:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 06/10] mfd: menelaus: Limit the usage of the_menelaus
Date: Mon, 16 Dec 2013 18:08:20 -0600
Message-ID: <1387238904-7843-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1387238904-7843-1-git-send-email-balbi@ti.com>
References: <20131216153936.GQ18769@lee--X1>
 <1387238904-7843-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass a menelaus_chip pointer as argument to most functions so we can
minimize the usage of the global the_menelaus pointer. This will
help later getting of the_menelaus altogether.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 420 ++++++++++++++++++++++++++-----------------------
 1 file changed, 222 insertions(+), 198 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index d3e3022..ae3209d 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -177,9 +177,9 @@ struct menelaus_chip {
 
 static struct menelaus_chip *the_menelaus;
 
-static int menelaus_write_reg(int reg, u8 value)
+static int menelaus_write_reg(struct menelaus_chip *m, int reg, u8 value)
 {
-	int val = i2c_smbus_write_byte_data(the_menelaus->client, reg, value);
+	int val = i2c_smbus_write_byte_data(m->client, reg, value);
 
 	if (val < 0) {
 		pr_err(DRIVER_NAME ": write error");
@@ -189,9 +189,9 @@ static int menelaus_write_reg(int reg, u8 value)
 	return 0;
 }
 
-static int menelaus_read_reg(int reg)
+static int menelaus_read_reg(struct menelaus_chip *m, int reg)
 {
-	int val = i2c_smbus_read_byte_data(the_menelaus->client, reg);
+	int val = i2c_smbus_read_byte_data(m->client, reg);
 
 	if (val < 0)
 		pr_err(DRIVER_NAME ": read error");
@@ -199,65 +199,65 @@ static int menelaus_read_reg(int reg)
 	return val;
 }
 
-static int menelaus_enable_irq(int irq)
+static int menelaus_enable_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7) {
 		irq -= 8;
-		the_menelaus->mask2 &= ~(1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK2,
-				the_menelaus->mask2);
+		m->mask2 &= ~(1 << irq);
+		return menelaus_write_reg(m, MENELAUS_INT_MASK2,
+				m->mask2);
 	} else {
-		the_menelaus->mask1 &= ~(1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK1,
-				the_menelaus->mask1);
+		m->mask1 &= ~(1 << irq);
+		return menelaus_write_reg(m, MENELAUS_INT_MASK1,
+				m->mask1);
 	}
 }
 
-static int menelaus_disable_irq(int irq)
+static int menelaus_disable_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7) {
 		irq -= 8;
-		the_menelaus->mask2 |= (1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK2,
-				the_menelaus->mask2);
+		m->mask2 |= (1 << irq);
+		return menelaus_write_reg(m, MENELAUS_INT_MASK2,
+				m->mask2);
 	} else {
-		the_menelaus->mask1 |= (1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK1,
-				the_menelaus->mask1);
+		m->mask1 |= (1 << irq);
+		return menelaus_write_reg(m, MENELAUS_INT_MASK1,
+				m->mask1);
 	}
 }
 
-static int menelaus_ack_irq(int irq)
+static int menelaus_ack_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7)
-		return menelaus_write_reg(MENELAUS_INT_ACK2, 1 << (irq - 8));
+		return menelaus_write_reg(m, MENELAUS_INT_ACK2, 1 << (irq - 8));
 	else
-		return menelaus_write_reg(MENELAUS_INT_ACK1, 1 << irq);
+		return menelaus_write_reg(m, MENELAUS_INT_ACK1, 1 << irq);
 }
 
 /* Adds a handler for an interrupt. Does not run in interrupt context */
-static int menelaus_add_irq_work(int irq,
+static int menelaus_add_irq_work(struct menelaus_chip *m, int irq,
 		void (*handler)(struct menelaus_chip *))
 {
 	int ret = 0;
 
-	mutex_lock(&the_menelaus->lock);
-	the_menelaus->handlers[irq] = handler;
-	ret = menelaus_enable_irq(irq);
-	mutex_unlock(&the_menelaus->lock);
+	mutex_lock(&m->lock);
+	m->handlers[irq] = handler;
+	ret = menelaus_enable_irq(m, irq);
+	mutex_unlock(&m->lock);
 
 	return ret;
 }
 
 /* Removes handler for an interrupt */
-static int menelaus_remove_irq_work(int irq)
+static int menelaus_remove_irq_work(struct menelaus_chip *m, int irq)
 {
 	int ret = 0;
 
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_disable_irq(irq);
-	the_menelaus->handlers[irq] = NULL;
-	mutex_unlock(&the_menelaus->lock);
+	mutex_lock(&m->lock);
+	ret = menelaus_disable_irq(m, irq);
+	m->handlers[irq] = NULL;
+	mutex_unlock(&m->lock);
 
 	return ret;
 }
@@ -268,12 +268,12 @@ static int menelaus_remove_irq_work(int irq)
  * in each slot. In this case the cards are not seen by menelaus.
  * FIXME: Add handling for D1 too
  */
-static void menelaus_mmc_cd_work(struct menelaus_chip *menelaus_hw)
+static void menelaus_mmc_cd_work(struct menelaus_chip *m)
 {
 	int reg;
 	unsigned char card_mask = 0;
 
-	reg = menelaus_read_reg(MENELAUS_MCT_PIN_ST);
+	reg = menelaus_read_reg(m, MENELAUS_MCT_PIN_ST);
 	if (reg < 0)
 		return;
 
@@ -283,8 +283,8 @@ static void menelaus_mmc_cd_work(struct menelaus_chip *menelaus_hw)
 	if (!(reg & 0x2))
 		card_mask |= MCT_PIN_ST_S2_CD_ST;
 
-	if (menelaus_hw->mmc_callback)
-		menelaus_hw->mmc_callback(menelaus_hw->mmc_callback_data,
+	if (m->mmc_callback)
+		m->mmc_callback(m->mmc_callback_data,
 					  card_mask);
 }
 
@@ -293,14 +293,16 @@ static void menelaus_mmc_cd_work(struct menelaus_chip *menelaus_hw)
  */
 int menelaus_set_mmc_opendrain(int slot, int enable)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int ret, val;
 
 	if (slot != 1 && slot != 2)
 		return -EINVAL;
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_read_reg(MENELAUS_MCT_CTRL1);
+
+	mutex_lock(&m->lock);
+	ret = menelaus_read_reg(m, MENELAUS_MCT_CTRL1);
 	if (ret < 0) {
-		mutex_unlock(&the_menelaus->lock);
+		mutex_unlock(&m->lock);
 		return ret;
 	}
 	val = ret;
@@ -315,8 +317,8 @@ int menelaus_set_mmc_opendrain(int slot, int enable)
 		else
 			val &= ~MCT_CTRL1_S2_CMD_OD;
 	}
-	ret = menelaus_write_reg(MENELAUS_MCT_CTRL1, val);
-	mutex_unlock(&the_menelaus->lock);
+	ret = menelaus_write_reg(m, MENELAUS_MCT_CTRL1, val);
+	mutex_unlock(&m->lock);
 
 	return ret;
 }
@@ -324,10 +326,12 @@ EXPORT_SYMBOL(menelaus_set_mmc_opendrain);
 
 int menelaus_set_slot_sel(int enable)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int ret;
 
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_read_reg(MENELAUS_GPIO_CTRL);
+	mutex_lock(&m->lock);
+
+	ret = menelaus_read_reg(m, MENELAUS_GPIO_CTRL);
 	if (ret < 0)
 		goto out;
 	ret |= GPIO2_DIR_INPUT;
@@ -335,15 +339,16 @@ int menelaus_set_slot_sel(int enable)
 		ret |= GPIO_CTRL_SLOTSELEN;
 	else
 		ret &= ~GPIO_CTRL_SLOTSELEN;
-	ret = menelaus_write_reg(MENELAUS_GPIO_CTRL, ret);
+	ret = menelaus_write_reg(m, MENELAUS_GPIO_CTRL, ret);
 out:
-	mutex_unlock(&the_menelaus->lock);
+	mutex_unlock(&m->lock);
 	return ret;
 }
 EXPORT_SYMBOL(menelaus_set_slot_sel);
 
 int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int ret, val;
 
 	if (slot != 1 && slot != 2)
@@ -351,9 +356,9 @@ int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
 	if (power >= 3)
 		return -EINVAL;
 
-	mutex_lock(&the_menelaus->lock);
+	mutex_lock(&m->lock);
 
-	ret = menelaus_read_reg(MENELAUS_MCT_CTRL2);
+	ret = menelaus_read_reg(m, MENELAUS_MCT_CTRL2);
 	if (ret < 0)
 		goto out;
 	val = ret;
@@ -368,11 +373,11 @@ int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
 		else
 			val &= ~(MCT_CTRL2_S2CD_BUFEN | MCT_CTRL2_S2CD_BEN);
 	}
-	ret = menelaus_write_reg(MENELAUS_MCT_CTRL2, val);
+	ret = menelaus_write_reg(m, MENELAUS_MCT_CTRL2, val);
 	if (ret < 0)
 		goto out;
 
-	ret = menelaus_read_reg(MENELAUS_MCT_CTRL3);
+	ret = menelaus_read_reg(m, MENELAUS_MCT_CTRL3);
 	if (ret < 0)
 		goto out;
 	val = ret;
@@ -388,18 +393,18 @@ int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
 			val |= MCT_CTRL3_SLOT2_EN;
 		else
 			val &= ~MCT_CTRL3_SLOT2_EN;
-		b = menelaus_read_reg(MENELAUS_MCT_CTRL2);
+		b = menelaus_read_reg(m, MENELAUS_MCT_CTRL2);
 		b &= ~(MCT_CTRL2_VS2_SEL_D0 | MCT_CTRL2_VS2_SEL_D1);
 		b |= power;
-		ret = menelaus_write_reg(MENELAUS_MCT_CTRL2, b);
+		ret = menelaus_write_reg(m, MENELAUS_MCT_CTRL2, b);
 		if (ret < 0)
 			goto out;
 	}
 	/* Disable autonomous shutdown */
 	val &= ~(MCT_CTRL3_S1_AUTO_EN | MCT_CTRL3_S2_AUTO_EN);
-	ret = menelaus_write_reg(MENELAUS_MCT_CTRL3, val);
+	ret = menelaus_write_reg(m, MENELAUS_MCT_CTRL3, val);
 out:
-	mutex_unlock(&the_menelaus->lock);
+	mutex_unlock(&m->lock);
 	return ret;
 }
 EXPORT_SYMBOL(menelaus_set_mmc_slot);
@@ -407,23 +412,24 @@ EXPORT_SYMBOL(menelaus_set_mmc_slot);
 int menelaus_register_mmc_callback(void (*callback)(void *data, u8 card_mask),
 				   void *data)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int ret = 0;
 
-	the_menelaus->mmc_callback_data = data;
-	the_menelaus->mmc_callback = callback;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S1CD_IRQ,
+	m->mmc_callback_data = data;
+	m->mmc_callback = callback;
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S1CD_IRQ,
 				    menelaus_mmc_cd_work);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S2CD_IRQ,
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S2CD_IRQ,
 				    menelaus_mmc_cd_work);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S1D1_IRQ,
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S1D1_IRQ,
 				    menelaus_mmc_cd_work);
 	if (ret < 0)
 		return ret;
-	ret = menelaus_add_irq_work(MENELAUS_MMC_S2D1_IRQ,
+	ret = menelaus_add_irq_work(m, MENELAUS_MMC_S2D1_IRQ,
 				    menelaus_mmc_cd_work);
 
 	return ret;
@@ -432,13 +438,15 @@ EXPORT_SYMBOL(menelaus_register_mmc_callback);
 
 void menelaus_unregister_mmc_callback(void)
 {
-	menelaus_remove_irq_work(MENELAUS_MMC_S1CD_IRQ);
-	menelaus_remove_irq_work(MENELAUS_MMC_S2CD_IRQ);
-	menelaus_remove_irq_work(MENELAUS_MMC_S1D1_IRQ);
-	menelaus_remove_irq_work(MENELAUS_MMC_S2D1_IRQ);
+	struct menelaus_chip *m = the_menelaus;
+
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S1CD_IRQ);
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S2CD_IRQ);
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S1D1_IRQ);
+	menelaus_remove_irq_work(m, MENELAUS_MMC_S2D1_IRQ);
 
-	the_menelaus->mmc_callback = NULL;
-	the_menelaus->mmc_callback_data = NULL;
+	m->mmc_callback = NULL;
+	m->mmc_callback_data = NULL;
 }
 EXPORT_SYMBOL(menelaus_unregister_mmc_callback);
 
@@ -455,17 +463,17 @@ struct menelaus_vtg_value {
 	u16 val;
 };
 
-static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
-				int vtg_val, int mode)
+static int menelaus_set_voltage(struct menelaus_chip *m,
+		const struct menelaus_vtg *vtg, int mV, int vtg_val, int mode)
 {
+	struct i2c_client *c = m->client;
 	int val, ret;
-	struct i2c_client *c = the_menelaus->client;
 
-	mutex_lock(&the_menelaus->lock);
+	mutex_lock(&m->lock);
 	if (!vtg)
 		goto set_voltage;
 
-	ret = menelaus_read_reg(vtg->vtg_reg);
+	ret = menelaus_read_reg(m, vtg->vtg_reg);
 	if (ret < 0)
 		goto out;
 	val = ret & ~(((1 << vtg->vtg_bits) - 1) << vtg->vtg_shift);
@@ -475,13 +483,13 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
 			 "to %d mV (reg 0x%02x, val 0x%02x)\n",
 			vtg->name, mV, vtg->vtg_reg, val);
 
-	ret = menelaus_write_reg(vtg->vtg_reg, val);
+	ret = menelaus_write_reg(m, vtg->vtg_reg, val);
 	if (ret < 0)
 		goto out;
 set_voltage:
-	ret = menelaus_write_reg(vtg->mode_reg, mode);
+	ret = menelaus_write_reg(m, vtg->mode_reg, mode);
 out:
-	mutex_unlock(&the_menelaus->lock);
+	mutex_unlock(&m->lock);
 	if (ret == 0) {
 		/* Wait for voltage to stabilize */
 		msleep(1);
@@ -489,8 +497,8 @@ out:
 	return ret;
 }
 
-static int menelaus_get_vtg_value(int vtg, const struct menelaus_vtg_value *tbl,
-				  int n)
+static int menelaus_get_vtg_value(struct menelaus_chip *m,
+		int vtg, const struct menelaus_vtg_value *tbl, int n)
 {
 	int i;
 
@@ -533,10 +541,11 @@ static const struct menelaus_vtg_value vcore_values[] = {
 
 int menelaus_set_vcore_sw(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
+	struct i2c_client *c = m->client;
 	int val, ret;
-	struct i2c_client *c = the_menelaus->client;
 
-	val = menelaus_get_vtg_value(mV, vcore_values,
+	val = menelaus_get_vtg_value(m, mV, vcore_values,
 				     ARRAY_SIZE(vcore_values));
 	if (val < 0)
 		return -EINVAL;
@@ -544,11 +553,11 @@ int menelaus_set_vcore_sw(unsigned int mV)
 	dev_dbg(&c->dev, "Setting VCORE to %d mV (val 0x%02x)\n", mV, val);
 
 	/* Set SW mode and the voltage in one go. */
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_write_reg(MENELAUS_VCORE_CTRL1, val);
+	mutex_lock(&m->lock);
+	ret = menelaus_write_reg(m, MENELAUS_VCORE_CTRL1, val);
 	if (ret == 0)
-		the_menelaus->vcore_hw_mode = 0;
-	mutex_unlock(&the_menelaus->lock);
+		m->vcore_hw_mode = 0;
+	mutex_unlock(&m->lock);
 	msleep(1);
 
 	return ret;
@@ -556,14 +565,15 @@ int menelaus_set_vcore_sw(unsigned int mV)
 
 int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
 {
+	struct menelaus_chip *m = the_menelaus;
+	struct i2c_client *c = m->client;
 	int fval, rval, val, ret;
-	struct i2c_client *c = the_menelaus->client;
 
-	rval = menelaus_get_vtg_value(roof_mV, vcore_values,
+	rval = menelaus_get_vtg_value(m, roof_mV, vcore_values,
 				      ARRAY_SIZE(vcore_values));
 	if (rval < 0)
 		return -EINVAL;
-	fval = menelaus_get_vtg_value(floor_mV, vcore_values,
+	fval = menelaus_get_vtg_value(m, floor_mV, vcore_values,
 				      ARRAY_SIZE(vcore_values));
 	if (fval < 0)
 		return -EINVAL;
@@ -571,23 +581,23 @@ int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
 	dev_dbg(&c->dev, "Setting VCORE FLOOR to %d mV and ROOF to %d mV\n",
 	       floor_mV, roof_mV);
 
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_write_reg(MENELAUS_VCORE_CTRL3, fval);
+	mutex_lock(&m->lock);
+	ret = menelaus_write_reg(m, MENELAUS_VCORE_CTRL3, fval);
 	if (ret < 0)
 		goto out;
-	ret = menelaus_write_reg(MENELAUS_VCORE_CTRL4, rval);
+	ret = menelaus_write_reg(m, MENELAUS_VCORE_CTRL4, rval);
 	if (ret < 0)
 		goto out;
-	if (!the_menelaus->vcore_hw_mode) {
-		val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
+	if (!m->vcore_hw_mode) {
+		val = menelaus_read_reg(m, MENELAUS_VCORE_CTRL1);
 		/* HW mode, turn OFF byte comparator */
 		val |= (VCORE_CTRL1_HW_NSW | VCORE_CTRL1_BYP_COMP);
-		ret = menelaus_write_reg(MENELAUS_VCORE_CTRL1, val);
-		the_menelaus->vcore_hw_mode = 1;
+		ret = menelaus_write_reg(m, MENELAUS_VCORE_CTRL1, val);
+		m->vcore_hw_mode = 1;
 	}
 	msleep(1);
 out:
-	mutex_unlock(&the_menelaus->lock);
+	mutex_unlock(&m->lock);
 	return ret;
 }
 
@@ -608,15 +618,16 @@ static const struct menelaus_vtg_value vmem_values[] = {
 
 int menelaus_set_vmem(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vmem_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vmem_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vmem_values, ARRAY_SIZE(vmem_values));
+	val = menelaus_get_vtg_value(m, mV, vmem_values, ARRAY_SIZE(vmem_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vmem_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vmem_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vmem);
 
@@ -637,15 +648,16 @@ static const struct menelaus_vtg_value vio_values[] = {
 
 int menelaus_set_vio(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vio_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vio_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vio_values, ARRAY_SIZE(vio_values));
+	val = menelaus_get_vtg_value(m, mV, vio_values, ARRAY_SIZE(vio_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vio_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vio_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vio);
 
@@ -678,6 +690,7 @@ static const struct menelaus_vtg vdcdc3_vtg = {
 
 int menelaus_set_vdcdc(int dcdc, unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	const struct menelaus_vtg *vtg;
 	int val;
 
@@ -689,13 +702,13 @@ int menelaus_set_vdcdc(int dcdc, unsigned int mV)
 		vtg = &vdcdc3_vtg;
 
 	if (mV == 0)
-		return menelaus_set_voltage(vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vdcdc_values,
+	val = menelaus_get_vtg_value(m, mV, vdcdc_values,
 				     ARRAY_SIZE(vdcdc_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(vtg, mV, val, 0x03);
+	return menelaus_set_voltage(m, vtg, mV, val, 0x03);
 }
 
 static const struct menelaus_vtg_value vmmc_values[] = {
@@ -715,15 +728,16 @@ static const struct menelaus_vtg vmmc_vtg = {
 
 int menelaus_set_vmmc(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vmmc_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vmmc_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vmmc_values, ARRAY_SIZE(vmmc_values));
+	val = menelaus_get_vtg_value(m, mV, vmmc_values, ARRAY_SIZE(vmmc_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vmmc_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vmmc_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vmmc);
 
@@ -745,37 +759,41 @@ static const struct menelaus_vtg vaux_vtg = {
 
 int menelaus_set_vaux(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vaux_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vaux_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vaux_values, ARRAY_SIZE(vaux_values));
+	val = menelaus_get_vtg_value(m, mV, vaux_values, ARRAY_SIZE(vaux_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vaux_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vaux_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vaux);
 
 int menelaus_get_slot_pin_states(void)
 {
-	return menelaus_read_reg(MENELAUS_MCT_PIN_ST);
+	struct menelaus_chip *m = the_menelaus;
+
+	return menelaus_read_reg(m, MENELAUS_MCT_PIN_ST);
 }
 EXPORT_SYMBOL(menelaus_get_slot_pin_states);
 
 int menelaus_set_regulator_sleep(int enable, u32 val)
 {
+	struct menelaus_chip *m = the_menelaus;
+	struct i2c_client *c = m->client;
 	int t, ret;
-	struct i2c_client *c = the_menelaus->client;
 
-	mutex_lock(&the_menelaus->lock);
-	ret = menelaus_write_reg(MENELAUS_SLEEP_CTRL2, val);
+	mutex_lock(&m->lock);
+	ret = menelaus_write_reg(m, MENELAUS_SLEEP_CTRL2, val);
 	if (ret < 0)
 		goto out;
 
 	dev_dbg(&c->dev, "regulator sleep configuration: %02x\n", val);
 
-	ret = menelaus_read_reg(MENELAUS_GPIO_CTRL);
+	ret = menelaus_read_reg(m, MENELAUS_GPIO_CTRL);
 	if (ret < 0)
 		goto out;
 	t = (GPIO_CTRL_SLPCTLEN | GPIO3_DIR_INPUT);
@@ -783,9 +801,9 @@ int menelaus_set_regulator_sleep(int enable, u32 val)
 		ret |= t;
 	else
 		ret &= ~t;
-	ret = menelaus_write_reg(MENELAUS_GPIO_CTRL, ret);
+	ret = menelaus_write_reg(m, MENELAUS_GPIO_CTRL, ret);
 out:
-	mutex_unlock(&the_menelaus->lock);
+	mutex_unlock(&m->lock);
 	return ret;
 }
 
@@ -793,25 +811,25 @@ out:
 
 static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 {
-	struct menelaus_chip *menelaus = _menelaus;
-	void (*handler)(struct menelaus_chip *menelaus);
+	struct menelaus_chip *m = _menelaus;
+	void (*handler)(struct menelaus_chip *m);
 	unsigned long isr;
 	unsigned long i;
 
-	isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
-			& ~menelaus->mask2) << 8;
-	isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
-		& ~menelaus->mask1;
+	isr = (menelaus_read_reg(m, MENELAUS_INT_STATUS2)
+			& ~m->mask2) << 8;
+	isr |= menelaus_read_reg(m, MENELAUS_INT_STATUS1)
+		& ~m->mask1;
 
 	for_each_set_bit(i, &isr, 16) {
-		mutex_lock(&menelaus->lock);
-		menelaus_disable_irq(i);
-		menelaus_ack_irq(i);
-		handler = menelaus->handlers[i];
+		mutex_lock(&m->lock);
+		menelaus_disable_irq(m, i);
+		menelaus_ack_irq(m, i);
+		handler = m->handlers[i];
 		if (handler)
-			handler(menelaus);
-		menelaus_enable_irq(i);
-		mutex_unlock(&menelaus->lock);
+			handler(m);
+		menelaus_enable_irq(m, i);
+		mutex_unlock(&m->lock);
 	}
 
 	return IRQ_HANDLED;
@@ -839,11 +857,12 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 
 #define RTC_HR_PM		(1 << 7)
 
-static void menelaus_to_time(char *regs, struct rtc_time *t)
+static void menelaus_to_time(struct menelaus_chip *m,
+		char *regs, struct rtc_time *t)
 {
 	t->tm_sec = bcd2bin(regs[0]);
 	t->tm_min = bcd2bin(regs[1]);
-	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
+	if (m->rtc_control & RTC_CTRL_MODE12) {
 		t->tm_hour = bcd2bin(regs[2] & 0x1f) - 1;
 		if (regs[2] & RTC_HR_PM)
 			t->tm_hour += 12;
@@ -854,19 +873,20 @@ static void menelaus_to_time(char *regs, struct rtc_time *t)
 	t->tm_year = bcd2bin(regs[5]) + 100;
 }
 
-static int time_to_menelaus(struct rtc_time *t, int regnum)
+static int time_to_menelaus(struct menelaus_chip *m,
+		struct rtc_time *t, int regnum)
 {
 	int	hour, status;
 
-	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_sec));
+	status = menelaus_write_reg(m, regnum++, bin2bcd(t->tm_sec));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_min));
+	status = menelaus_write_reg(m, regnum++, bin2bcd(t->tm_min));
 	if (status < 0)
 		goto fail;
 
-	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
+	if (m->rtc_control & RTC_CTRL_MODE12) {
 		hour = t->tm_hour + 1;
 		if (hour > 12)
 			hour = RTC_HR_PM | bin2bcd(hour - 12);
@@ -874,31 +894,32 @@ static int time_to_menelaus(struct rtc_time *t, int regnum)
 			hour = bin2bcd(hour);
 	} else
 		hour = bin2bcd(t->tm_hour);
-	status = menelaus_write_reg(regnum++, hour);
+	status = menelaus_write_reg(m, regnum++, hour);
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_mday));
+	status = menelaus_write_reg(m, regnum++, bin2bcd(t->tm_mday));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_mon + 1));
+	status = menelaus_write_reg(m, regnum++, bin2bcd(t->tm_mon + 1));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_year - 100));
+	status = menelaus_write_reg(m, regnum++, bin2bcd(t->tm_year - 100));
 	if (status < 0)
 		goto fail;
 
 	return 0;
 fail:
-	dev_err(&the_menelaus->client->dev, "rtc write reg %02x, err %d\n",
+	dev_err(&m->client->dev, "rtc write reg %02x, err %d\n",
 			--regnum, status);
 	return status;
 }
 
 static int menelaus_read_time(struct device *dev, struct rtc_time *t)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	struct i2c_msg	msg[2];
 	char		regs[7];
 	int		status;
@@ -916,13 +937,13 @@ static int menelaus_read_time(struct device *dev, struct rtc_time *t)
 	msg[1].len = sizeof(regs);
 	msg[1].buf = regs;
 
-	status = i2c_transfer(the_menelaus->client->adapter, msg, 2);
+	status = i2c_transfer(m->client->adapter, msg, 2);
 	if (status != 2) {
 		dev_err(dev, "%s error %d\n", "read", status);
 		return -EIO;
 	}
 
-	menelaus_to_time(regs, t);
+	menelaus_to_time(m, regs, t);
 	t->tm_wday = bcd2bin(regs[6]);
 
 	return 0;
@@ -930,23 +951,24 @@ static int menelaus_read_time(struct device *dev, struct rtc_time *t)
 
 static int menelaus_set_time(struct device *dev, struct rtc_time *t)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	int		status;
 
 	/* write date and time registers */
-	status = time_to_menelaus(t, MENELAUS_RTC_SEC);
+	status = time_to_menelaus(m, t, MENELAUS_RTC_SEC);
 	if (status < 0)
 		return status;
-	status = menelaus_write_reg(MENELAUS_RTC_WKDAY, bin2bcd(t->tm_wday));
+	status = menelaus_write_reg(m, MENELAUS_RTC_WKDAY, bin2bcd(t->tm_wday));
 	if (status < 0) {
-		dev_err(&the_menelaus->client->dev, "rtc write reg %02x "
+		dev_err(&m->client->dev, "rtc write reg %02x "
 				"err %d\n", MENELAUS_RTC_WKDAY, status);
 		return status;
 	}
 
 	/* now commit the write */
-	status = menelaus_write_reg(MENELAUS_RTC_UPDATE, RTC_UPDATE_EVERY);
+	status = menelaus_write_reg(m, MENELAUS_RTC_UPDATE, RTC_UPDATE_EVERY);
 	if (status < 0)
-		dev_err(&the_menelaus->client->dev, "rtc commit time, err %d\n",
+		dev_err(&m->client->dev, "rtc commit time, err %d\n",
 				status);
 
 	return 0;
@@ -954,6 +976,7 @@ static int menelaus_set_time(struct device *dev, struct rtc_time *t)
 
 static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	struct i2c_msg	msg[2];
 	char		regs[6];
 	int		status;
@@ -971,15 +994,15 @@ static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 	msg[1].len = sizeof(regs);
 	msg[1].buf = regs;
 
-	status = i2c_transfer(the_menelaus->client->adapter, msg, 2);
+	status = i2c_transfer(m->client->adapter, msg, 2);
 	if (status != 2) {
 		dev_err(dev, "%s error %d\n", "alarm read", status);
 		return -EIO;
 	}
 
-	menelaus_to_time(regs, &w->time);
+	menelaus_to_time(m, regs, &w->time);
 
-	w->enabled = !!(the_menelaus->rtc_control & RTC_CTRL_AL_EN);
+	w->enabled = !!(m->rtc_control & RTC_CTRL_AL_EN);
 
 	/* NOTE we *could* check if actually pending... */
 	w->pending = 0;
@@ -989,30 +1012,31 @@ static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 
 static int menelaus_set_alarm(struct device *dev, struct rtc_wkalrm *w)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	int		status;
 
-	if (the_menelaus->client->irq <= 0 && w->enabled)
+	if (m->client->irq <= 0 && w->enabled)
 		return -ENODEV;
 
 	/* clear previous alarm enable */
-	if (the_menelaus->rtc_control & RTC_CTRL_AL_EN) {
-		the_menelaus->rtc_control &= ~RTC_CTRL_AL_EN;
-		status = menelaus_write_reg(MENELAUS_RTC_CTRL,
-				the_menelaus->rtc_control);
+	if (m->rtc_control & RTC_CTRL_AL_EN) {
+		m->rtc_control &= ~RTC_CTRL_AL_EN;
+		status = menelaus_write_reg(m, MENELAUS_RTC_CTRL,
+				m->rtc_control);
 		if (status < 0)
 			return status;
 	}
 
 	/* write alarm registers */
-	status = time_to_menelaus(&w->time, MENELAUS_RTC_AL_SEC);
+	status = time_to_menelaus(m, &w->time, MENELAUS_RTC_AL_SEC);
 	if (status < 0)
 		return status;
 
 	/* enable alarm if requested */
 	if (w->enabled) {
-		the_menelaus->rtc_control |= RTC_CTRL_AL_EN;
-		status = menelaus_write_reg(MENELAUS_RTC_CTRL,
-				the_menelaus->rtc_control);
+		m->rtc_control |= RTC_CTRL_AL_EN;
+		status = menelaus_write_reg(m, MENELAUS_RTC_CTRL,
+				m->rtc_control);
 	}
 
 	return status;
@@ -1030,44 +1054,45 @@ static void menelaus_rtc_update_work(struct menelaus_chip *m)
 
 static int menelaus_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	int	status;
 
-	if (the_menelaus->client->irq <= 0)
+	if (m->client->irq <= 0)
 		return -ENOIOCTLCMD;
 
 	switch (cmd) {
 	/* alarm IRQ */
 	case RTC_AIE_ON:
-		if (the_menelaus->rtc_control & RTC_CTRL_AL_EN)
+		if (m->rtc_control & RTC_CTRL_AL_EN)
 			return 0;
-		the_menelaus->rtc_control |= RTC_CTRL_AL_EN;
+		m->rtc_control |= RTC_CTRL_AL_EN;
 		break;
 	case RTC_AIE_OFF:
-		if (!(the_menelaus->rtc_control & RTC_CTRL_AL_EN))
+		if (!(m->rtc_control & RTC_CTRL_AL_EN))
 			return 0;
-		the_menelaus->rtc_control &= ~RTC_CTRL_AL_EN;
+		m->rtc_control &= ~RTC_CTRL_AL_EN;
 		break;
 	/* 1/second "update" IRQ */
 	case RTC_UIE_ON:
-		if (the_menelaus->uie)
+		if (m->uie)
 			return 0;
-		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
-		status = menelaus_add_irq_work(MENELAUS_RTCTMR_IRQ,
+		status = menelaus_remove_irq_work(m, MENELAUS_RTCTMR_IRQ);
+		status = menelaus_add_irq_work(m, MENELAUS_RTCTMR_IRQ,
 				menelaus_rtc_update_work);
 		if (status == 0)
-			the_menelaus->uie = 1;
+			m->uie = 1;
 		return status;
 	case RTC_UIE_OFF:
-		if (!the_menelaus->uie)
+		if (!m->uie)
 			return 0;
-		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
+		status = menelaus_remove_irq_work(m, MENELAUS_RTCTMR_IRQ);
 		if (status == 0)
-			the_menelaus->uie = 0;
+			m->uie = 0;
 		return status;
 	default:
 		return -ENOIOCTLCMD;
 	}
-	return menelaus_write_reg(MENELAUS_RTC_CTRL, the_menelaus->rtc_control);
+	return menelaus_write_reg(m, MENELAUS_RTC_CTRL, m->rtc_control);
 }
 
 #else
@@ -1092,8 +1117,8 @@ static void menelaus_rtc_alarm_work(struct menelaus_chip *m)
 	local_irq_enable();
 
 	/* then disable it; alarms are oneshot */
-	the_menelaus->rtc_control &= ~RTC_CTRL_AL_EN;
-	menelaus_write_reg(MENELAUS_RTC_CTRL, the_menelaus->rtc_control);
+	m->rtc_control &= ~RTC_CTRL_AL_EN;
+	menelaus_write_reg(m, MENELAUS_RTC_CTRL, m->rtc_control);
 }
 
 static inline void menelaus_rtc_init(struct menelaus_chip *m)
@@ -1101,14 +1126,14 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 	int	alarm = (m->client->irq > 0);
 
 	/* assume 32KDETEN pin is pulled high */
-	if (!(menelaus_read_reg(MENELAUS_OSC_CTRL) & 0x80)) {
+	if (!(menelaus_read_reg(m, MENELAUS_OSC_CTRL) & 0x80)) {
 		dev_dbg(&m->client->dev, "no 32k oscillator\n");
 		return;
 	}
 
 	/* support RTC alarm; it can issue wakeups */
 	if (alarm) {
-		if (menelaus_add_irq_work(MENELAUS_RTCALM_IRQ,
+		if (menelaus_add_irq_work(m, MENELAUS_RTCALM_IRQ,
 				menelaus_rtc_alarm_work) < 0) {
 			dev_err(&m->client->dev, "can't handle RTC alarm\n");
 			return;
@@ -1117,7 +1142,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 	}
 
 	/* be sure RTC is enabled; allow 1/sec irqs; leave 12hr mode alone */
-	m->rtc_control = menelaus_read_reg(MENELAUS_RTC_CTRL);
+	m->rtc_control = menelaus_read_reg(m, MENELAUS_RTC_CTRL);
 	if (!(m->rtc_control & RTC_CTRL_RTC_EN)
 			|| (m->rtc_control & RTC_CTRL_AL_EN)
 			|| (m->rtc_control & RTC_CTRL_EVERY_MASK)) {
@@ -1127,7 +1152,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 		}
 		m->rtc_control &= ~RTC_CTRL_EVERY_MASK;
 		m->rtc_control &= ~RTC_CTRL_AL_EN;
-		menelaus_write_reg(MENELAUS_RTC_CTRL, m->rtc_control);
+		menelaus_write_reg(m, MENELAUS_RTC_CTRL, m->rtc_control);
 	}
 
 	m->rtc = rtc_device_register(DRIVER_NAME,
@@ -1135,12 +1160,12 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 			&menelaus_rtc_ops, THIS_MODULE);
 	if (IS_ERR(m->rtc)) {
 		if (alarm) {
-			menelaus_remove_irq_work(MENELAUS_RTCALM_IRQ);
+			menelaus_remove_irq_work(m, MENELAUS_RTCALM_IRQ);
 			device_init_wakeup(&m->client->dev, 0);
 		}
 		dev_err(&m->client->dev, "can't register RTC: %d\n",
 				(int) PTR_ERR(m->rtc));
-		the_menelaus->rtc = NULL;
+		m->rtc = NULL;
 	}
 }
 
@@ -1160,7 +1185,7 @@ static struct i2c_driver menelaus_i2c_driver;
 static int menelaus_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct menelaus_chip	*menelaus;
+	struct menelaus_chip	*m;
 	int			rev = 0, val;
 	int			err = 0;
 	struct menelaus_platform_data *menelaus_pdata =
@@ -1172,37 +1197,36 @@ static int menelaus_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	menelaus = devm_kzalloc(&client->dev, sizeof(*menelaus), GFP_KERNEL);
-	if (!menelaus)
+	m = devm_kzalloc(&client->dev, sizeof(*m), GFP_KERNEL);
+	if (!m)
 		return -ENOMEM;
 
-	i2c_set_clientdata(client, menelaus);
+	i2c_set_clientdata(client, m);
 
-	the_menelaus = menelaus;
-	menelaus->client = client;
+	the_menelaus = m;
+	m->client = client;
 
 	/* If a true probe check the device */
-	rev = menelaus_read_reg(MENELAUS_REV);
+	rev = menelaus_read_reg(m, MENELAUS_REV);
 	if (rev < 0) {
 		pr_err(DRIVER_NAME ": device not found");
 		return -ENODEV;
 	}
 
 	/* Ack and disable all Menelaus interrupts */
-	menelaus_write_reg(MENELAUS_INT_ACK1, 0xff);
-	menelaus_write_reg(MENELAUS_INT_ACK2, 0xff);
-	menelaus_write_reg(MENELAUS_INT_MASK1, 0xff);
-	menelaus_write_reg(MENELAUS_INT_MASK2, 0xff);
-	menelaus->mask1 = 0xff;
-	menelaus->mask2 = 0xff;
+	menelaus_write_reg(m, MENELAUS_INT_ACK1, 0xff);
+	menelaus_write_reg(m, MENELAUS_INT_ACK2, 0xff);
+	menelaus_write_reg(m, MENELAUS_INT_MASK1, 0xff);
+	menelaus_write_reg(m, MENELAUS_INT_MASK2, 0xff);
+	m->mask1 = 0xff;
+	m->mask2 = 0xff;
 
 	/* Set output buffer strengths */
-	menelaus_write_reg(MENELAUS_MCT_CTRL1, 0x73);
+	menelaus_write_reg(m, MENELAUS_MCT_CTRL1, 0x73);
 
 	if (client->irq > 0) {
 		err = devm_request_threaded_irq(&client->dev, client->irq, NULL,
-				menelaus_irq, IRQF_ONESHOT, DRIVER_NAME,
-				menelaus);
+				menelaus_irq, IRQF_ONESHOT, DRIVER_NAME, m);
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
@@ -1210,17 +1234,17 @@ static int menelaus_probe(struct i2c_client *client,
 		}
 	}
 
-	mutex_init(&menelaus->lock);
+	mutex_init(&m->lock);
 
 	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
 
-	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
+	val = menelaus_read_reg(m, MENELAUS_VCORE_CTRL1);
 	if (val < 0)
 		goto fail;
 	if (val & (1 << 7))
-		menelaus->vcore_hw_mode = 1;
+		m->vcore_hw_mode = 1;
 	else
-		menelaus->vcore_hw_mode = 0;
+		m->vcore_hw_mode = 0;
 
 	if (menelaus_pdata != NULL && menelaus_pdata->late_init != NULL) {
 		err = menelaus_pdata->late_init(&client->dev);
@@ -1228,7 +1252,7 @@ static int menelaus_probe(struct i2c_client *client,
 			goto fail;
 	}
 
-	menelaus_rtc_init(menelaus);
+	menelaus_rtc_init(m);
 
 	return 0;
 fail:
-- 
1.8.4.GIT

