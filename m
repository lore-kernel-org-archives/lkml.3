Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3K0TKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:10:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58774 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab3K0TIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 07/13] mfd: menelaus: limit the usage of the_menelaus
Date: Wed, 27 Nov 2013 13:06:51 -0600
Message-ID: <1385579217-20127-8-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1385579217-20127-1-git-send-email-balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pass a menelaus_chip pointer as argument to most
functions so we can minimize the usage of the
global the_menelaus pointer.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 265 ++++++++++++++++++++++++++-----------------------
 1 file changed, 142 insertions(+), 123 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 4c51e4b..8796e5e 100644
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
@@ -204,11 +204,11 @@ static int menelaus_enable_irq(struct menelaus_chip *m, int irq)
 	if (irq > 7) {
 		irq -= 8;
 		m->mask2 &= ~(1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK2,
+		return menelaus_write_reg(m, MENELAUS_INT_MASK2,
 				m->mask2);
 	} else {
 		m->mask1 &= ~(1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK1,
+		return menelaus_write_reg(m, MENELAUS_INT_MASK1,
 				m->mask1);
 	}
 }
@@ -218,11 +218,11 @@ static int menelaus_disable_irq(struct menelaus_chip *m, int irq)
 	if (irq > 7) {
 		irq -= 8;
 		m->mask2 |= (1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK2,
+		return menelaus_write_reg(m, MENELAUS_INT_MASK2,
 				m->mask2);
 	} else {
 		m->mask1 |= (1 << irq);
-		return menelaus_write_reg(MENELAUS_INT_MASK1,
+		return menelaus_write_reg(m, MENELAUS_INT_MASK1,
 				m->mask1);
 	}
 }
@@ -230,9 +230,9 @@ static int menelaus_disable_irq(struct menelaus_chip *m, int irq)
 static int menelaus_ack_irq(struct menelaus_chip *m, int irq)
 {
 	if (irq > 7)
-		return menelaus_write_reg(MENELAUS_INT_ACK2, 1 << (irq - 8));
+		return menelaus_write_reg(m, MENELAUS_INT_ACK2, 1 << (irq - 8));
 	else
-		return menelaus_write_reg(MENELAUS_INT_ACK1, 1 << irq);
+		return menelaus_write_reg(m, MENELAUS_INT_ACK1, 1 << irq);
 }
 
 /* Adds a handler for an interrupt. Does not run in interrupt context */
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
@@ -458,14 +463,15 @@ struct menelaus_vtg_value {
 static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
 				int vtg_val, int mode)
 {
+	struct menelaus_chip *m = the_menelaus;
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
@@ -475,13 +481,13 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
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
@@ -533,8 +539,9 @@ static const struct menelaus_vtg_value vcore_values[] = {
 
 int menelaus_set_vcore_sw(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
+	struct i2c_client *c = m->client;
 	int val, ret;
-	struct i2c_client *c = the_menelaus->client;
 
 	val = menelaus_get_vtg_value(mV, vcore_values,
 				     ARRAY_SIZE(vcore_values));
@@ -544,11 +551,11 @@ int menelaus_set_vcore_sw(unsigned int mV)
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
@@ -556,8 +563,9 @@ int menelaus_set_vcore_sw(unsigned int mV)
 
 int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
 {
+	struct menelaus_chip *m = the_menelaus;
+	struct i2c_client *c = m->client;
 	int fval, rval, val, ret;
-	struct i2c_client *c = the_menelaus->client;
 
 	rval = menelaus_get_vtg_value(roof_mV, vcore_values,
 				      ARRAY_SIZE(vcore_values));
@@ -571,23 +579,23 @@ int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
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
 
@@ -759,23 +767,26 @@ EXPORT_SYMBOL(menelaus_set_vaux);
 
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
@@ -783,9 +794,9 @@ int menelaus_set_regulator_sleep(int enable, u32 val)
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
 
@@ -798,9 +809,9 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 	unsigned long isr;
 	unsigned long i;
 
-	isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
+	isr = (menelaus_read_reg(m, MENELAUS_INT_STATUS2)
 			& ~m->mask2) << 8;
-	isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
+	isr |= menelaus_read_reg(m, MENELAUS_INT_STATUS1)
 		& ~m->mask1;
 
 	for_each_set_bit(i, &isr, 16) {
@@ -841,9 +852,11 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 
 static void menelaus_to_time(char *regs, struct rtc_time *t)
 {
+	struct menelaus_chip *m = the_menelaus;
+
 	t->tm_sec = bcd2bin(regs[0]);
 	t->tm_min = bcd2bin(regs[1]);
-	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
+	if (m->rtc_control & RTC_CTRL_MODE12) {
 		t->tm_hour = bcd2bin(regs[2] & 0x1f) - 1;
 		if (regs[2] & RTC_HR_PM)
 			t->tm_hour += 12;
@@ -856,17 +869,18 @@ static void menelaus_to_time(char *regs, struct rtc_time *t)
 
 static int time_to_menelaus(struct rtc_time *t, int regnum)
 {
+	struct menelaus_chip *m = the_menelaus;
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
@@ -874,31 +888,32 @@ static int time_to_menelaus(struct rtc_time *t, int regnum)
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
@@ -916,7 +931,7 @@ static int menelaus_read_time(struct device *dev, struct rtc_time *t)
 	msg[1].len = sizeof(regs);
 	msg[1].buf = regs;
 
-	status = i2c_transfer(the_menelaus->client->adapter, msg, 2);
+	status = i2c_transfer(m->client->adapter, msg, 2);
 	if (status != 2) {
 		dev_err(dev, "%s error %d\n", "read", status);
 		return -EIO;
@@ -930,23 +945,24 @@ static int menelaus_read_time(struct device *dev, struct rtc_time *t)
 
 static int menelaus_set_time(struct device *dev, struct rtc_time *t)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	int		status;
 
 	/* write date and time registers */
 	status = time_to_menelaus(t, MENELAUS_RTC_SEC);
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
@@ -954,6 +970,7 @@ static int menelaus_set_time(struct device *dev, struct rtc_time *t)
 
 static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 {
+	struct menelaus_chip *m = dev_get_drvdata(dev);
 	struct i2c_msg	msg[2];
 	char		regs[6];
 	int		status;
@@ -971,7 +988,7 @@ static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 	msg[1].len = sizeof(regs);
 	msg[1].buf = regs;
 
-	status = i2c_transfer(the_menelaus->client->adapter, msg, 2);
+	status = i2c_transfer(m->client->adapter, msg, 2);
 	if (status != 2) {
 		dev_err(dev, "%s error %d\n", "alarm read", status);
 		return -EIO;
@@ -979,7 +996,7 @@ static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 
 	menelaus_to_time(regs, &w->time);
 
-	w->enabled = !!(the_menelaus->rtc_control & RTC_CTRL_AL_EN);
+	w->enabled = !!(m->rtc_control & RTC_CTRL_AL_EN);
 
 	/* NOTE we *could* check if actually pending... */
 	w->pending = 0;
@@ -989,16 +1006,17 @@ static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 
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
@@ -1010,9 +1028,9 @@ static int menelaus_set_alarm(struct device *dev, struct rtc_wkalrm *w)
 
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
@@ -1030,44 +1048,45 @@ static void menelaus_rtc_update_work(struct menelaus_chip *m)
 
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
 		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
 		status = menelaus_add_irq_work(MENELAUS_RTCTMR_IRQ,
 				menelaus_rtc_update_work);
 		if (status == 0)
-			the_menelaus->uie = 1;
+			m->uie = 1;
 		return status;
 	case RTC_UIE_OFF:
-		if (!the_menelaus->uie)
+		if (!m->uie)
 			return 0;
 		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
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
@@ -1092,8 +1111,8 @@ static void menelaus_rtc_alarm_work(struct menelaus_chip *m)
 	local_irq_enable();
 
 	/* then disable it; alarms are oneshot */
-	the_menelaus->rtc_control &= ~RTC_CTRL_AL_EN;
-	menelaus_write_reg(MENELAUS_RTC_CTRL, the_menelaus->rtc_control);
+	m->rtc_control &= ~RTC_CTRL_AL_EN;
+	menelaus_write_reg(m, MENELAUS_RTC_CTRL, m->rtc_control);
 }
 
 static inline void menelaus_rtc_init(struct menelaus_chip *m)
@@ -1101,7 +1120,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 	int	alarm = (m->client->irq > 0);
 
 	/* assume 32KDETEN pin is pulled high */
-	if (!(menelaus_read_reg(MENELAUS_OSC_CTRL) & 0x80)) {
+	if (!(menelaus_read_reg(m, MENELAUS_OSC_CTRL) & 0x80)) {
 		dev_dbg(&m->client->dev, "no 32k oscillator\n");
 		return;
 	}
@@ -1117,7 +1136,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 	}
 
 	/* be sure RTC is enabled; allow 1/sec irqs; leave 12hr mode alone */
-	m->rtc_control = menelaus_read_reg(MENELAUS_RTC_CTRL);
+	m->rtc_control = menelaus_read_reg(m, MENELAUS_RTC_CTRL);
 	if (!(m->rtc_control & RTC_CTRL_RTC_EN)
 			|| (m->rtc_control & RTC_CTRL_AL_EN)
 			|| (m->rtc_control & RTC_CTRL_EVERY_MASK)) {
@@ -1127,7 +1146,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 		}
 		m->rtc_control &= ~RTC_CTRL_EVERY_MASK;
 		m->rtc_control &= ~RTC_CTRL_AL_EN;
-		menelaus_write_reg(MENELAUS_RTC_CTRL, m->rtc_control);
+		menelaus_write_reg(m, MENELAUS_RTC_CTRL, m->rtc_control);
 	}
 
 	m->rtc = rtc_device_register(DRIVER_NAME,
@@ -1140,7 +1159,7 @@ static inline void menelaus_rtc_init(struct menelaus_chip *m)
 		}
 		dev_err(&m->client->dev, "can't register RTC: %d\n",
 				(int) PTR_ERR(m->rtc));
-		the_menelaus->rtc = NULL;
+		m->rtc = NULL;
 	}
 }
 
@@ -1160,7 +1179,7 @@ static struct i2c_driver menelaus_i2c_driver;
 static int menelaus_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct menelaus_chip	*menelaus;
+	struct menelaus_chip	*m;
 	int			rev = 0, val;
 	int			err = 0;
 	struct menelaus_platform_data *menelaus_pdata =
@@ -1172,36 +1191,36 @@ static int menelaus_probe(struct i2c_client *client,
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
 		err = request_threaded_irq(client->irq, NULL, menelaus_irq,
-				IRQF_ONESHOT, DRIVER_NAME, menelaus);
+				IRQF_ONESHOT, DRIVER_NAME, m);
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
@@ -1209,17 +1228,17 @@ static int menelaus_probe(struct i2c_client *client,
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
@@ -1227,19 +1246,19 @@ static int menelaus_probe(struct i2c_client *client,
 			goto fail;
 	}
 
-	menelaus_rtc_init(menelaus);
+	menelaus_rtc_init(m);
 
 	return 0;
 fail:
-	free_irq(client->irq, menelaus);
+	free_irq(client->irq, m);
 	return err;
 }
 
 static int menelaus_remove(struct i2c_client *client)
 {
-	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
+	struct menelaus_chip	*m = i2c_get_clientdata(client);
 
-	free_irq(client->irq, menelaus);
+	free_irq(client->irq, m);
 	the_menelaus = NULL;
 	return 0;
 }
-- 
1.8.4.GIT

