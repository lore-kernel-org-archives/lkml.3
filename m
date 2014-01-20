Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaATEe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:34:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50245 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaATEen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:34:43 -0500
From: Satish Patel <satish.patel@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>
CC: Satish Patel <satish.patel@ti.com>
Subject: [PATCH v2 2/5] misc: tda8026: Add NXP TDA8026 PHY driver
Date: Mon, 20 Jan 2014 10:03:51 +0530
Message-ID: <1390192434-19386-3-git-send-email-satish.patel@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TDA8026 is a SmartCard PHY from NXP.

The PHY interfaces with the main processor over the
I2C interface and acts as a slave device.

The driver also exposes the phy interface
(defined@include/linux/sc_phy.h) for SmartCard controller.
Controller uses this interface to communicate with smart card
inserted to the phy's slot.

Note: gpio irq is not validated as I do not have device with that.
I have validated interrupt with dedicated interrupt line on my device.

Signed-off-by: Satish Patel <satish.patel@ti.com>
---
 Documentation/devicetree/bindings/misc/tda8026.txt |   19 +
 drivers/misc/Kconfig                               |    7 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/tda8026.c                             | 1255 ++++++++++++++++++++
 4 files changed, 1282 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/tda8026.txt
 create mode 100644 drivers/misc/tda8026.c

diff --git a/Documentation/devicetree/bindings/misc/tda8026.txt b/Documentation/devicetree/bindings/misc/tda8026.txt
new file mode 100644
index 0000000..f115c9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/tda8026.txt
@@ -0,0 +1,19 @@
+TDA8026 smart card slot interface
+
+This is an i2c based smart card interface device forming the electrical
+interface between a microcontroller and smart cards. This device supports
+asynchronous cards (micro controller-based IC cards) as well as synchronous
+cards (mainly memory cards)
+
+Required properties:
+- compatible: "nxp,tda8026"
+- shutdown-gpio = GPIO pin mapping for SDWNN pin
+- reg = i2c interface address
+
+
+Example:
+tda8026: tda8026@48 {
+		 compatible = "nxp,tda8026";
+		 reg = <0x48>;
+		 shutdown-gpio = <&gpio5 19 GPIO_ACTIVE_HIGH>;/* Bank5, pin19 */
+	 };
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a3e291d..bb94a6f 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,13 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config NXP_TDA8026_PHY
+        tristate "NXP PHY Driver for Smart Card PHY"
+        depends on I2C=y
+        help
+          If you say yes here you get support for the TDA8026 Smart card PHY
+	  with I2C interface.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f45473e..24374dd 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
+obj-$(CONFIG_NXP_TDA8026_PHY)	+= tda8026.o
diff --git a/drivers/misc/tda8026.c b/drivers/misc/tda8026.c
new file mode 100644
index 0000000..6a77686
--- /dev/null
+++ b/drivers/misc/tda8026.c
@@ -0,0 +1,1255 @@
+/*
+ * tda8026.c - TDA8026 PHY driver for NXP Smart card PHY
+ *
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/notifier.h>
+#include <linux/sc_phy.h>
+#include <linux/of_gpio.h>
+#include <linux/of_device.h>
+#include <linux/delay.h>
+
+#define TDA8026_MAX_SLOTS		(5)
+#define TDA8026_NUM_SAM_SLOTS		(4)
+#define TDA8026_USERCARD_SLOT		(1)
+
+#define TDA8026_CSB_ADDR		(0x24)
+#define TDA8026_REG0_ADDR		(0x20)
+#define TDA8026_REG1_ADDR		(0x21)
+#define TDA8026_SLEWRATE_ADDR		(0x20)
+#define TDA8026_PRODVER_ADDR		(0x20)
+#define TDA8026_INTSTAT_ADDR		(0x21)
+
+#define TDA8026_PHY_PRODUCT_VERSION	(0xC2)
+
+/* CSB register values */
+#define TDA8026_CSB_PV_INTSTAT_VAL	(0x0)
+#define TDA8026_CSB_SLEWRATE_VAL	(0x6)
+
+/* Slot REG0 read mode bit fields */
+#define TDA8026_REG0_ACTIVE_MASK	(0x80)
+#define TDA8026_REG0_EARLY_MASK		(0x40)
+#define TDA8026_REG0_MUTE_MASK		(0x20)
+#define TDA8026_REG0_PROT_MASK		(0x10)
+#define TDA8026_REG0_SUPL_MASK		(0x08)
+#define TDA8026_REG0_CLKSW_MASK		(0x04)
+#define TDA8026_REG0_PREL_MASK		(0x02)
+#define TDA8026_REG0_PRES_MASK		(0x01)
+
+/* Slot REG0 write mode bit fields */
+#define TDA8026_REG0_VCC1V8_MASK	(0x80)
+#define TDA8026_REG0_IOEN_MASK		(0x40)
+
+#define TDA8026_REG0_REG10_MASK		(0x30)
+#define TDA8026_REG0_REG10_SHIFT	(4)
+#define TDA8026_REG0_REG10_CFG_VAL	(0x0)
+#define TDA8026_REG0_REG10_D_VAL	(0x1)
+#define TDA8026_REG0_REG10_CMSB_VAL	(0x2)
+#define TDA8026_REG0_REG10_CLSB_VAL	(0x3)
+
+#define TDA8026_REG0_PDWN_MASK		(0x08)
+#define TDA8026_REG0_5V3VN_MASK		(0x04)
+#define TDA8026_REG0_WARM_RESET_MASK	(0x02)
+#define TDA8026_REG0_START_MASK		(0x01)
+
+/* Slot REG1 CFG bit fields REG[1:0] = 00b */
+#define TDA8026_REG1CFG_CFGP2_MASK	(0x80)
+#define TDA8026_REG1CFG_RSTIN_MASK	(0x40)
+#define TDA8026_REG1CFG_C8_MASK		(0x20)
+#define TDA8026_REG1CFG_C4_MASK		(0x10)
+#define TDA8026_REG1CFG_CLKPD_MASK	(0x0C)
+#define TDA8026_REG1CFG_CLKPD_SHIFT	(2)
+#define TDA8026_REG1CFG_CLKDIV_MASK	(0x03)
+#define TDA8026_REG1CFG_CLKDIV_SHIFT	(0)
+
+/* Slew rate register bit fields */
+#define TDA8026_SR_CLKSR_SLOT0_MASK	0x0C
+#define TDA8026_SR_CLKSR_SLOT0_SHIFT	0x2
+#define TDA8026_SR_IOSR_SLOT0_MASK	0x3
+#define TDA8026_SR_IOSR_SLOT0_SHIFT	0x0
+
+#define TDA8026_SR_CLKSR_SLOT2TO5_MASK	0xC0
+#define TDA8026_SR_CLKSR_SLOT2TO5_SHIFT	0x6
+#define TDA8026_SR_IOSR_SLOT2TO5_MASK	0x30
+#define TDA8026_SR_IOSR_SLOT2TO5_SHIFT	0x4
+
+#define TDA8026_MIN_EARLY_CYCLE    (200)
+
+struct tda8026 {
+	/* device pointer */
+	struct device *dev;
+
+	/* For device IO interfaces: I2C or SPI */
+	void *control_data;
+	/* Store a shadow of Slot Register 0 as it cannot be read */
+	u8 reg0[TDA8026_MAX_SLOTS];
+	int irq;
+	int notify;
+	int shutdown_gpio;
+	int enable;
+};
+
+static BLOCKING_NOTIFIER_HEAD(tda8026_notifier_list);
+
+static int tda8026_i2c_read(struct tda8026 *tda8026, u8 reg,
+		int bytes, u8 *dest)
+{
+	struct i2c_client *i2c = tda8026->control_data;
+	struct i2c_msg xfer;
+	int ret;
+
+	/* We need to read from the slave address itself, as there
+	 * is no separate register to be accessed in TDA8026
+	 */
+
+	xfer.addr = reg;
+	xfer.flags = I2C_M_RD;
+	xfer.len = bytes;
+	xfer.buf = dest;
+
+	ret = i2c_transfer(i2c->adapter, &xfer, 1);
+	if (ret < 0)
+		dev_err(tda8026->dev, "Read [0x%x] Error %d\n", reg, ret);
+
+	return ret;
+}
+
+static int tda8026_i2c_write(struct tda8026 *tda8026, u8 reg,
+		int bytes, u8 *src)
+{
+	struct i2c_client *i2c = tda8026->control_data;
+	struct i2c_msg xfer;
+	int ret;
+
+	/* We have to write to the slave address itself, as
+	 * there is no separate register to be accessed in TDA8026
+	 */
+	xfer.addr = reg;
+	xfer.flags = 0;
+	xfer.len = bytes;
+	xfer.buf = src;
+
+	ret = i2c_transfer(i2c->adapter, &xfer, 1);
+	if (ret < 0)
+		dev_err(tda8026->dev, "Write [0x%x] Error %d\n", reg, ret);
+
+	return ret;
+}
+
+/* put the phy in shutdown mode, which in turn deactivate
+ * all the cards in the slot and card pins are forced to 0V
+ */
+static inline void tda8026_disable(struct tda8026 *tda8026)
+{
+	dev_dbg(tda8026->dev, "tda8026_disable!!!!");
+	tda8026->enable = 0;
+	if (gpio_is_valid(tda8026->shutdown_gpio))
+		gpio_set_value(tda8026->shutdown_gpio, 0);
+}
+
+/* exit from shutdown mode */
+static inline void tda8026_enable(struct tda8026 *tda8026)
+{
+	dev_dbg(tda8026->dev, "tda8026_enable!!!!");
+	tda8026->enable = 1;
+	if (gpio_is_valid(tda8026->shutdown_gpio))
+		gpio_set_value(tda8026->shutdown_gpio, 1);
+	/* Added dealy to stabilized phy state after pulling shutdown line */
+	mdelay(100);
+}
+
+/*
+ * Select the card slot to communicate with the card
+ * Note that card slots are numbered from 0 in software.
+ * However TDA8026 PHY numbers the slot starting 1.
+ */
+static inline int tda8026_select_slot(struct tda8026 *tda8026, u8 slot)
+{
+	int ret = 0;
+
+	/* In SW slot starts from 0, in TDA8026 it starts from 1 */
+	slot = slot + 1;
+	ret = tda8026_i2c_write(tda8026, TDA8026_CSB_ADDR, 1, &slot);
+
+	return ret;
+}
+
+static int tda8026_clear_interrupts(struct tda8026 *tda8026)
+{
+	u8 val;
+	u8 status;
+	int ret = 0;
+
+	/* Select the Interrupt register bank */
+	val = TDA8026_CSB_PV_INTSTAT_VAL;
+	tda8026_i2c_write(tda8026, TDA8026_CSB_ADDR, 1, &val);
+
+	/* Read the interrupt status which will tell us the slot */
+	ret = tda8026_i2c_read(tda8026, TDA8026_INTSTAT_ADDR, 1, &status);
+	if (ret < 0)
+		return ret;
+
+	for (val = 1; val > TDA8026_MAX_SLOTS; val++) {
+		/* Program the slot number to the CSB register */
+		ret = tda8026_i2c_write(tda8026, TDA8026_CSB_ADDR, 1, &val);
+		if (ret < 0)
+			return ret;
+
+		ret = tda8026_i2c_read(tda8026, TDA8026_REG0_ADDR, 1, &status);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+/*
+ * TDA8026 PHY IRQ handler
+ */
+static irqreturn_t tda8026_irq(int irq, void *irq_data)
+{
+	struct sc_phy *phy_tda8026 = (struct sc_phy *)irq_data;
+	struct tda8026 *tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+	u8 slot;
+	u8 val;
+	u8 status;
+	int ret = 0;
+	int action = 0;
+
+	dev_dbg(tda8026->dev, "tda8026_irq!!");
+
+	if (tda8026->enable == 0) {
+		dev_dbg(tda8026->dev, "phy is disable not serving interrputs!!");
+		/* when, phy is in shutdown mode, it can detect the card insert
+		 * event. But if phy is not enable (i.e.) there is no consumer
+		 * of phy then just enable phy, clear the interrupt and disable
+		 * again
+		 */
+		tda8026_enable(tda8026);
+		tda8026_clear_interrupts(tda8026);
+		tda8026_disable(tda8026);
+		return IRQ_HANDLED;
+	}
+
+	/* Select the Interrupt register bank */
+	val = TDA8026_CSB_PV_INTSTAT_VAL;
+	tda8026_i2c_write(tda8026, TDA8026_CSB_ADDR, 1, &val);
+
+	/* Read the interrupt status which will tell us the slot */
+	ret = tda8026_i2c_read(tda8026, TDA8026_INTSTAT_ADDR, 1, &status);
+	if (ret < 0)
+		return IRQ_HANDLED;
+
+
+	/* find out for which slot interrupt has occur */
+	slot = 0;
+	while (val == 0 && slot < TDA8026_MAX_SLOTS) {
+		val = status & (1 << slot);
+		slot++;
+	}
+
+	if (slot > TDA8026_MAX_SLOTS) {
+		dev_err(tda8026->dev, "invalid slot interrput");
+		return IRQ_HANDLED;
+	}
+
+	/* Program the slot number to the CSB register */
+	ret = tda8026_i2c_write(tda8026, TDA8026_CSB_ADDR, 1, &slot);
+	if (ret < 0)
+		return IRQ_HANDLED;
+
+	/* Now read the slot reg0 to find out the cause of interrupt
+	 * Note that IRQ is raised only when one of the SUPL, PROT,
+	 * MUTE and EARLY bits are set to logic 1.
+	 */
+	ret = tda8026_i2c_read(tda8026, TDA8026_REG0_ADDR, 1, &status);
+	if (ret < 0)
+		return IRQ_HANDLED;
+
+	if (slot < 3) {
+		/* slot 1 and slot 2 can be used for user card, it can raise
+		 * interrupt for card insert and remove.Other slot are for SAM
+		 * modules. They are either always present or alwyas absent
+		 */
+		if (status & TDA8026_REG0_PREL_MASK) {
+			if (status & TDA8026_REG0_PRES_MASK) {
+				dev_dbg(tda8026->dev, "card is inserted");
+				action |= SC_PHY_CARD_INSERTED;
+			} else {
+				dev_dbg(tda8026->dev, "card is removed");
+				action |= SC_PHY_CARD_REMOVED;
+			}
+		}
+	}
+
+	if (status & (TDA8026_REG0_EARLY_MASK | TDA8026_REG0_MUTE_MASK)) {
+		dev_dbg(tda8026->dev, "CARD EARLY INTERRUPT\n");
+		action |= SC_PHY_CARD_ATR_TIMEOUT;
+	}
+
+	if (status & TDA8026_REG0_PROT_MASK) {
+		dev_dbg(tda8026->dev, "CARD OVERHEAT/OVERLOAD INTERRUPT\n");
+		action |= SC_PHY_CARD_OVERHEAT;
+	}
+
+	if (action != 0x0 && tda8026->notify) {
+		/* add slot information. Pass slot-1 as for controller slot
+		 * starts from 0,1,2.. */
+		action |= ((slot-1) << SC_PHY_NOTIFICATION_SLOT_SHIFT);
+
+		/* notify action */
+		blocking_notifier_call_chain(&tda8026_notifier_list, action,
+					     phy_tda8026->notify_data);
+	}
+	return IRQ_HANDLED;
+}
+
+/*
+ * PDWN bit is set/cleared to apply CLKPD[1:0] bit clock settings to
+ * the clock pin for the selected card slot.
+ */
+static int tda8026_pwdn(struct tda8026 *tda8026, u8 slot, int state)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+
+	if (state)
+		reg0 |= TDA8026_REG0_PDWN_MASK;
+	else
+		reg0 &= ~(TDA8026_REG0_PDWN_MASK);
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Set the card supply voltage.
+ * TDA PHY supports supply voltage of 1.8V, 3V and 5V.
+ */
+static int tda8026_set_voltage(struct tda8026 *tda8026, u8 slot, int voltage)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+
+	reg0 &= ~(TDA8026_REG0_VCC1V8_MASK | TDA8026_REG0_5V3VN_MASK);
+
+	switch (voltage) {
+	case SC_PHY_1_8V:
+		reg0 |= TDA8026_REG0_VCC1V8_MASK;
+	break;
+
+	case SC_PHY_5V:
+		reg0 |= TDA8026_REG0_5V3VN_MASK;
+	break;
+
+	case SC_PHY_3V:
+	default:
+	break;
+	}
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Enable the I/O line by setting I/OEN bit of slot's main address register.
+ * The I/O line should be enabled prior to card activation.
+ */
+static int tda8026_io_enable(struct tda8026 *tda8026, u8 slot)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 |= TDA8026_REG0_IOEN_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Disable the I/O line by clearing I/OEN bit of slot's main address register.
+ * The I/O line can be disabled post card activation.
+ */
+static int tda8026_io_disable(struct tda8026 *tda8026, u8 slot)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 &= ~(TDA8026_REG0_IOEN_MASK);
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Sets the mute counter in C[15:8] and C[7:0] register
+ * Write Reg[1:0] = 11 to select C[7:0] register
+ * Write Reg[1:0] = 10 to select C[15:8] register
+ */
+static int tda8026_set_atr_mute_time(struct tda8026 *tda8026, u8 slot,
+		int mute_counter)
+{
+	u8 reg0;
+	u8 mute_counter_high = (mute_counter & 0xFF00) >> 8;
+	u8 mute_counter_low = mute_counter & 0xFF;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 |=  TDA8026_REG0_REG10_CLSB_VAL << TDA8026_REG0_REG10_SHIFT;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	/* Write the mute counter value in C[7:0] LSB register */
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1,
+			&mute_counter_low);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 |=  TDA8026_REG0_REG10_CMSB_VAL << TDA8026_REG0_REG10_SHIFT;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	/* Write the mute counter value in C[15:8] MSB register */
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1,
+			&mute_counter_high);
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
+}
+
+/*
+ * Sets the ATR early time counter.
+ * Write Reg[1:0] = 01 to select D register
+ */
+static int tda8026_set_atr_early_time(struct tda8026 *tda8026, u8 slot,
+		int early_counter)
+{
+	u8 reg0;
+	int ret = 0;
+	u8 counter = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 |= TDA8026_REG0_REG10_D_VAL << TDA8026_REG0_REG10_SHIFT;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	/* Write the early atr counter value in D register */
+	counter = (early_counter - TDA8026_MIN_EARLY_CYCLE) & 0xFF;
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1, &counter);
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
+}
+
+static int tda8026_set_rstpin(struct tda8026 *tda8026, u8 slot, int state)
+{
+	u8 reg0 = 0;
+	u8 reg1 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	/* Write Reg[1:0] = 00 to select CONFIG register */
+	reg0 = tda8026->reg0[slot];
+	reg0 &= ~TDA8026_REG0_REG10_MASK;
+	reg0 |= (TDA8026_REG0_REG10_CFG_VAL << TDA8026_REG0_REG10_SHIFT) &
+		TDA8026_REG0_REG10_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	/* Read the Reg1 value */
+	ret = tda8026_i2c_read(tda8026, TDA8026_REG1_ADDR, 1,
+			&reg1);
+	if (ret < 0)
+		return ret;
+
+	if (state)
+		reg1 |= TDA8026_REG1CFG_RSTIN_MASK;
+	else
+		reg1 &= ~TDA8026_REG1CFG_RSTIN_MASK;
+
+	/* Write the Reset value to the register  */
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1, &reg1);
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
+}
+
+/*
+ * Activate the card by setting START bit of slot's main register.
+ * Voltage selction and enabling of I/O lines should be done prior
+ * to activating the card.
+ */
+static int tda8026_activate_card(struct sc_phy *phy_tda8026, u8 slot)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+
+	/* if PHY is used then RSTIN should be 1 for async cards,
+	 * currently this is applicable only for TDA8026
+	 */
+	tda8026_set_rstpin(tda8026, slot, 1);
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 |= TDA8026_REG0_START_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Deactivate the card by clearing the START bit of slot's main register
+ * We implement normal de-activation here.
+ * On clearing the START bit with normal deactivation, automatic
+ * deactivation is initiated and performaed by TDA8026.
+ */
+static int tda8026_deactivate_card(struct sc_phy *phy_tda8026, u8 slot)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 &= ~(TDA8026_REG0_START_MASK);
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Warm reset is initiated by setting the WARM bit of slot's main register
+ */
+static int tda8026_warm_reset(struct sc_phy *phy_tda8026, u8 slot)
+{
+	u8 reg0 = 0;
+	int ret = 0;
+
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+
+	/* See section 6.5 in TDA app note */
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 |= TDA8026_REG0_WARM_RESET_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	return 0;
+}
+
+/*
+ * Read and return the TDA8026 PHY product version
+ */
+static int tda8026_get_provider_version(struct tda8026 *tda8026)
+{
+	u8 val;
+	u8 version = 0;
+	int ret = 0;
+
+	/* Select Product version bank i.e Write CSB = 00 */
+	val = TDA8026_CSB_PV_INTSTAT_VAL;
+	ret = tda8026_i2c_write(tda8026, TDA8026_CSB_ADDR, 1, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = tda8026_i2c_read(tda8026, TDA8026_PRODVER_ADDR, 1, &version);
+	if (ret < 0)
+		return ret;
+	else
+		dev_info(tda8026->dev, "Product Version = %x\n", version);
+
+	return version;
+}
+
+
+/*
+ * Set/reset the C4/C8 Pin
+ * Write Reg[1:0] = 00 to select CONFIG register
+ */
+static int tda8026_set_c4c8(struct tda8026 *tda8026, u8 slot, int state, int pin)
+{
+	u8 reg0 = 0;
+	u8 reg1 = 0;
+	int ret = 0;
+	int mask = 0;
+
+	if (slot != 0) {
+		/* C4/C8 pin value valid only for slot 1 */
+		return -EINVAL;
+	} else {
+		ret = tda8026_select_slot(tda8026, slot);
+		if (ret < 0)
+			return ret;
+
+		reg0 = tda8026->reg0[slot];
+		reg0 &= ~TDA8026_REG0_REG10_MASK;
+		reg0 |= (TDA8026_REG0_REG10_CFG_VAL <<
+				TDA8026_REG0_REG10_SHIFT) &
+			TDA8026_REG0_REG10_MASK;
+
+		ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+		if (ret < 0)
+			return ret;
+		else if (ret == 1)
+			tda8026->reg0[slot] = reg0;
+
+		ret = tda8026_i2c_read(tda8026, TDA8026_REG1_ADDR, 1,
+				&reg1);
+		if (ret < 0)
+			return ret;
+		if (pin == SC_PHY_PIN_C8)
+			mask = TDA8026_REG1CFG_C8_MASK;
+		else if (pin == SC_PHY_PIN_C4)
+			mask = TDA8026_REG1CFG_C4_MASK;
+		else
+			return -EINVAL;
+
+		if (state)
+			reg1 |= mask;
+		else
+			reg1 &= ~mask;
+
+		ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1,
+				&reg1);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * Get the state of C4/C8 pin (high/low)
+ * Write Reg[1:0] = 00 to select CONFIG register
+ */
+static int tda8026_get_c4c8(struct tda8026 *tda8026, u8 slot, int pin)
+{
+	u8 reg0 = 0;
+	u8 reg1 = 0;
+	int ret = 0;
+	int mask = 0;
+
+	if (slot != 0) {
+		/* C4/C8 pin value valid only for slot 1 */
+		return -EINVAL;
+	} else {
+		ret = tda8026_select_slot(tda8026, slot);
+		if (ret < 0)
+			return ret;
+
+		reg0 = tda8026->reg0[slot];
+		reg0 &= ~TDA8026_REG0_REG10_MASK;
+		reg0 |= (TDA8026_REG0_REG10_CFG_VAL <<
+				TDA8026_REG0_REG10_SHIFT) &
+			TDA8026_REG0_REG10_MASK;
+
+		ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+		if (ret < 0)
+			return ret;
+		else if (ret == 1)
+			tda8026->reg0[slot] = reg0;
+
+		ret = tda8026_i2c_read(tda8026, TDA8026_REG1_ADDR, 1,
+				&reg1);
+		if (ret < 0)
+			return ret;
+
+		if (pin == SC_PHY_PIN_C8)
+			mask = TDA8026_REG1CFG_C8_MASK;
+		else if (pin == SC_PHY_PIN_C4)
+			mask = TDA8026_REG1CFG_C4_MASK;
+		else
+			return -EINVAL;
+
+		return (reg1 &= mask) ? 1 : 0;
+	}
+	return 0;
+}
+
+/*
+ * Set card clock
+ * Applicable only for synchronous mode
+ */
+static int tda8026_set_cardclk(struct tda8026 *tda8026, u8 slot,
+		int config)
+{
+	u8 reg0 = 0;
+	u8 reg1 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 &= ~TDA8026_REG0_REG10_MASK;
+	reg0 |= (TDA8026_REG0_REG10_CFG_VAL << TDA8026_REG0_REG10_SHIFT) &
+		TDA8026_REG0_REG10_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	ret = tda8026_i2c_read(tda8026, TDA8026_REG1_ADDR, 1, &reg1);
+	if (ret < 0)
+		return ret;
+
+	reg1 &= ~(TDA8026_REG1CFG_CLKPD_MASK);
+	reg1 |= (config << TDA8026_REG1CFG_CLKPD_SHIFT) &
+		TDA8026_REG1CFG_CLKPD_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1, &reg1);
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
+}
+
+/*
+ * Set the CLKDIV[1:0] bits.
+ * CLKDIV[1:0] bits define the card clock frequency
+ * Write Reg[1:0] = 00 to select CONFIG register
+ */
+static int tda8026_set_clkdiv(struct tda8026 *tda8026, u8 slot, int div)
+{
+	u8 reg0 = 0;
+	u8 reg1 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 &= ~TDA8026_REG0_REG10_MASK;
+	reg0 |= (TDA8026_REG0_REG10_CFG_VAL << TDA8026_REG0_REG10_SHIFT) &
+		TDA8026_REG0_REG10_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	ret = tda8026_i2c_read(tda8026, TDA8026_REG1_ADDR, 1, &reg1);
+	if (ret < 0)
+		return ret;
+
+	reg1 &= ~(TDA8026_REG1CFG_CLKDIV_MASK);
+	reg1 |= (div << TDA8026_REG1CFG_CLKDIV_SHIFT) &
+		TDA8026_REG1CFG_CLKDIV_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG1_ADDR, 1, &reg1);
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
+}
+
+/*
+ * Get the CLKDIV[1:0] bits.
+ * CLKDIV[1:0] bits define the card clock frequency
+ * Write Reg[1:0] = 00 to select CONFIG register
+ */
+static int tda8026_get_clkdiv(struct tda8026 *tda8026, u8 slot)
+{
+	u8 reg0 = 0;
+	u8 reg1 = 0;
+	int ret = 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	reg0 = tda8026->reg0[slot];
+	reg0 &= ~TDA8026_REG0_REG10_MASK;
+	reg0 |= (TDA8026_REG0_REG10_CFG_VAL << TDA8026_REG0_REG10_SHIFT) &
+		TDA8026_REG0_REG10_MASK;
+
+	ret = tda8026_i2c_write(tda8026, TDA8026_REG0_ADDR, 1, &reg0);
+	if (ret < 0)
+		return ret;
+	else if (ret == 1)
+		tda8026->reg0[slot] = reg0;
+
+	ret = tda8026_i2c_read(tda8026, TDA8026_REG1_ADDR, 1, &reg1);
+	if (ret < 0)
+		return ret;
+
+	ret = reg1 & TDA8026_REG1CFG_CLKDIV_MASK;
+
+	return ret;
+}
+
+/*
+ * Check if card is present in the slot.
+ */
+static int tda8026_card_present(struct tda8026 *tda8026, u8 slot)
+{
+	int present = 0;
+	int ret = 0;
+	u8 status = 0;
+
+	if (tda8026->enable == 0)
+		return 0;
+
+	ret = tda8026_select_slot(tda8026, slot);
+	if (ret < 0)
+		return ret;
+
+	ret = tda8026_i2c_read(tda8026, TDA8026_REG0_ADDR, 1, &status);
+	if (ret < 0)
+		return ret;
+
+	if (status & TDA8026_REG0_PRES_MASK)
+		present = 1;
+
+	return present;
+}
+
+/**
+ * tda8026_register_notify - register a notifier callback whenever a card
+ * event happens
+ * @nb: pointer to the notifier block for the callback events.
+ */
+static int tda8026_register_notify(struct sc_phy *phy_tda8026,
+		struct	notifier_block *nb, void *data)
+{
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	phy_tda8026->notify_data = data;
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+	blocking_notifier_chain_register(&tda8026_notifier_list, nb);
+	tda8026->notify = 1;
+	return 0;
+}
+
+/**
+ * tda8026_unregister_notify - unregister a notifier callback
+ * event happens
+ * @nb: pointer to the notifier block for the callback events.
+ */
+static int tda8026_unregister_notify(struct sc_phy *phy_tda8026,
+		struct	notifier_block *nb)
+{
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+	blocking_notifier_chain_unregister(&tda8026_notifier_list, nb);
+	tda8026->notify = 0;
+	return 0;
+}
+
+static int tda8026_set_config(struct sc_phy *phy_tda8026, u8 slot, enum
+		sc_phy_config attr, int value)
+{
+	int ret = 0;
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+	switch (attr) {
+	case SC_PHY_CARD_SUPPLY_VOLTAGE:
+		ret = tda8026_set_voltage(tda8026, slot, value);
+		break;
+
+	case SC_PHY_ATR_MUTE_TIME:
+		ret = tda8026_set_atr_mute_time(tda8026, slot, value);
+		break;
+
+	case SC_PHY_ATR_EARLY_TIME:
+		ret = tda8026_set_atr_early_time(tda8026, slot, value);
+		break;
+
+	case SC_PHY_CARD_MODE:
+		if (value == SC_PHY_SYNC) {
+			/* set clkdiv to zero, rst pin to low and pwdn bit to
+			 * logic 0
+			 */
+			tda8026_set_clkdiv(tda8026, slot, 0);
+			tda8026_set_rstpin(tda8026, slot, 0);
+			tda8026_pwdn(tda8026, slot, 0);
+		} else {
+			/* Nothing to do, default mode is async */
+		}
+		break;
+
+	case SC_PHY_IO:
+		if (value)
+			ret = tda8026_io_enable(tda8026, slot);
+		else
+			ret = tda8026_io_disable(tda8026, slot);
+		break;
+
+	case SC_PHY_PIN_RST:
+		ret = tda8026_set_rstpin(tda8026, slot, value);
+		break;
+
+	case SC_PHY_CLKDIV:
+		ret = tda8026_set_clkdiv(tda8026, slot, value);
+		break;
+
+	case SC_PHY_MODE:
+		if (value == SC_PHY_ACTIVE)
+			tda8026_enable(tda8026);
+		else if (value == SC_PHY_SHUTDOWN)
+			tda8026_disable(tda8026);
+		else
+			ret = -EINVAL;
+		break;
+
+	case SC_PHY_PIN_C4:
+		ret = tda8026_set_c4c8(tda8026, slot, value, SC_PHY_PIN_C4);
+		break;
+
+	case SC_PHY_PIN_C8:
+		ret = tda8026_set_c4c8(tda8026, slot, value, SC_PHY_PIN_C8);
+		break;
+
+	case SC_PHY_PIN_CLK:
+		ret = tda8026_set_cardclk(tda8026, slot, value);
+		break;
+
+	default:
+		ret = -EINVAL;
+		dev_err(phy_tda8026->dev, "operation not supported:%d", attr);
+		break;
+	}
+	return ret;
+}
+
+static int tda8026_get_config(struct sc_phy *phy_tda8026, u8 slot, enum
+		sc_phy_config attr)
+{
+	int ret = -1;
+	struct tda8026 *tda8026;
+
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+	switch (attr) {
+	case SC_PHY_CARD_PRESENCE:
+		ret = tda8026_card_present(tda8026, slot);
+	break;
+
+	case SC_PHY_VERSION:
+		ret = tda8026_get_provider_version(tda8026);
+	break;
+
+	case SC_PHY_CLKDIV:
+		ret = tda8026_get_clkdiv(tda8026, slot);
+	break;
+
+	case SC_PHY_PIN_C4:
+		ret = tda8026_get_c4c8(tda8026, slot, SC_PHY_PIN_C4);
+	break;
+
+	case SC_PHY_PIN_C8:
+		ret = tda8026_get_c4c8(tda8026, slot, SC_PHY_PIN_C8);
+	break;
+
+	default:
+		ret = -EINVAL;
+		dev_err(phy_tda8026->dev, "operation not supported:%d", attr);
+	break;
+	}
+	return ret;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id tda8026_id_table[];
+#endif
+
+static int tda8026_parse_dt(struct device *dev, struct tda8026 *pdata)
+{
+	struct device_node *np = dev->of_node;
+	int ret = 0;
+
+	pdata->shutdown_gpio = of_get_named_gpio(np, "shutdown-gpio", 0);
+	if (!gpio_is_valid(pdata->shutdown_gpio)) {
+		dev_err(dev, "Failed to get shutdown gpio\n");
+		return -EINVAL;
+	}
+
+	ret = devm_gpio_request_one(dev, pdata->shutdown_gpio,
+			GPIOF_DIR_OUT, "shutdown_gpio");
+	if (ret) {
+		dev_err(dev, "Failed to request shutdown_gpio\n");
+		return ret;
+	}
+	return 0;
+}
+
+static int tda8026_i2c_probe(struct i2c_client *i2c,
+		const struct i2c_device_id *id)
+{
+	int ret = 0;
+	struct sc_phy *phy_tda8026;
+	struct tda8026 *pdata;
+
+	struct device *dev = &i2c->dev;
+	struct device_node *np = dev->of_node;
+
+	if (np == NULL)
+		return -EINVAL;
+
+	pdata = devm_kzalloc(dev, sizeof(struct tda8026), GFP_KERNEL);
+	if (pdata == NULL)
+		return -ENOMEM;
+
+	phy_tda8026 = devm_kzalloc(dev, sizeof(struct sc_phy), GFP_KERNEL);
+	if (phy_tda8026 == NULL)
+		return -ENOMEM;
+
+	ret = tda8026_parse_dt(dev, pdata);
+	if (ret != 0)
+		return ret;
+
+	i2c_set_clientdata(i2c, phy_tda8026);
+	phy_tda8026->dev = &i2c->dev;
+
+	phy_tda8026->pdata = (void *)pdata;
+	pdata->control_data = i2c;
+	pdata->irq = i2c->irq;
+	pdata->dev = phy_tda8026->dev;
+	pdata->notify = 0;
+
+	if (pdata->irq == 0) {
+		return -EINVAL;
+	}
+	ret = devm_request_threaded_irq(dev, pdata->irq, NULL, tda8026_irq,
+			IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+			"tda8026", phy_tda8026);
+	if (ret < 0) {
+		dev_err(phy_tda8026->dev, "can't get irq %d err %d\n",
+			pdata->irq, ret);
+		return ret;
+	}
+
+	/* enable phy */
+	tda8026_enable(pdata);
+
+	tda8026_clear_interrupts(pdata);
+	phy_tda8026->set_config	= tda8026_set_config;
+	phy_tda8026->get_config	= tda8026_get_config;
+	phy_tda8026->activate_card	= tda8026_activate_card;
+	phy_tda8026->deactivate_card	= tda8026_deactivate_card;
+	phy_tda8026->warm_reset	= tda8026_warm_reset;
+	phy_tda8026->register_notify	= tda8026_register_notify;
+	phy_tda8026->unregister_notify	= tda8026_unregister_notify;
+
+	/* disable phy */
+	tda8026_disable(pdata);
+
+	return 0;
+}
+
+static int tda8026_i2c_remove(struct i2c_client *i2c)
+{
+	struct sc_phy *phy_tda8026;
+	struct tda8026 *tda8026;
+	int action = 0;
+
+	phy_tda8026 = i2c_get_clientdata(i2c);
+	if (phy_tda8026 == NULL)
+		return -EINVAL;
+
+	tda8026	= (struct tda8026 *)phy_tda8026->pdata;
+
+	/* notify action */
+	action = SC_PHY_REMOVED;
+	blocking_notifier_call_chain(&tda8026_notifier_list, action,
+				     phy_tda8026->notify_data);
+	tda8026->notify = 0;
+
+	/* enable shutdown mode */
+	tda8026_disable(tda8026);
+
+	return 0;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id tda8026_id_table[] = {
+	{ .compatible = "nxp,tda8026" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tda8026_id_table);
+#endif
+
+static const struct i2c_device_id tda8026_i2c_id[] = {
+	{"tda8026", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tda8026_i2c_id);
+
+static struct i2c_driver tda8026_i2c_driver = {
+	.driver = {
+		.name = "tda8026",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(tda8026_id_table),
+	},
+	.probe = tda8026_i2c_probe,
+	.remove = tda8026_i2c_remove,
+	.id_table = tda8026_i2c_id,
+};
+static int __init tda8026_i2c_init(void)
+{
+	int ret;
+	ret = i2c_add_driver(&tda8026_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register TDA8026 I2C driver: %d\n", ret);
+	return ret;
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(tda8026_i2c_init);
+
+static void __exit tda8026_i2c_exit(void)
+{
+	i2c_del_driver(&tda8026_i2c_driver);
+}
+module_exit(tda8026_i2c_exit);
+
+MODULE_AUTHOR("Maulik Mankad <maulik@ti.com>");
+MODULE_DESCRIPTION("TDA8026 Smart Card NXP PHY driver");
+MODULE_LICENSE("GPL");
-- 
1.7.1

