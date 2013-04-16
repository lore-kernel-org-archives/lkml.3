Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3DPNnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:43:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35787 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934991Ab3DPNnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:43:51 -0400
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
CC: <liam.r.girdwood@intel.com>, <navada@ti.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH V2 1/4] mfd: Initial support for Texas Instruments AIC family of CODECs
Date: Tue, 16 Apr 2013 19:13:36 +0530
Message-ID: <1366119816-9719-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial support for Texas Instruments's AIC CODEC device.

The AIC platform provides common interface to series of low power audio CODECS.
This MFD core driver instantiates subdevices that help in supporting range
of features provided by AIC family of devices

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig                     |   13 +
 drivers/mfd/Makefile                    |    1 +
 drivers/mfd/tlv320aic-core.c            |  462 +++++++++++++++++++++++++++++++
 include/linux/mfd/tlv320aic-core.h      |  112 ++++++++
 include/linux/mfd/tlv320aic-registers.h |   32 +++
 5 files changed, 620 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-core.c
 create mode 100644 include/linux/mfd/tlv320aic-core.h
 create mode 100644 include/linux/mfd/tlv320aic-registers.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..629d374 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -45,6 +45,19 @@ config MFD_88PM805
 	  components like codec device, headset/Mic device under the
 	  corresponding menus.
 
+config MFD_AIC
+	bool "Support for Texas Instruments TLV320AIC platform"
+	select REGMAP
+	select MFD_CORE
+	help
+	  Say yes here if you want support for Texas Instruments AIC audio
+	  codec.
+	  You have to select individual I2C or SPI depending on
+	  AIC interfacing with platform. To enable IRQ handling
+	  facilities select IRQ component under corresponding menus.
+	  you have to select individual components like codec device
+	  to use AIC features.
+
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
 	 ---help---
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..b975c94 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
 obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
+obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-core.c b/drivers/mfd/tlv320aic-core.c
new file mode 100644
index 0000000..4b8a424
--- /dev/null
+++ b/drivers/mfd/tlv320aic-core.c
@@ -0,0 +1,462 @@
+/*
+ * tlv320aic-core.c  -- driver for TLV320AIC
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/machine.h>
+#include <linux/gpio.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+#include <linux/mfd/tlv320aic-registers.h>
+/**
+ * set_aic_book: change book which we have to write/read to.
+ *
+ * @aic: Device to write/read to.
+ * @book: Book to write/read to.
+ */
+int set_aic_book(struct aic *aic, int book)
+{
+	int ret = 0;
+	u8 page_buf[] = { 0x0, 0x0 };
+	u8 book_buf[] = { 0x7f, 0x0 };
+
+	ret = regmap_write(aic->regmap, page_buf[0], page_buf[1]);
+
+	if (ret < 0)
+		return ret;
+	book_buf[1] = book;
+	ret = regmap_write(aic->regmap, book_buf[0], book_buf[1]);
+
+	if (ret < 0)
+		return ret;
+	aic->book_no = book;
+	aic->page_no = 0;
+
+	return ret;
+}
+
+/**
+ * set_aic_page: change page which we have to write/read to.
+ *
+ * @aic: Device to write/read to.
+ * @page: Book to write/read to.
+ */
+int set_aic_page(struct aic *aic, int page)
+{
+	int ret = 0;
+	u8 page_buf[] = { 0x0, 0x0 };
+
+	page_buf[1] = page;
+	ret = regmap_write(aic->regmap, page_buf[0], page_buf[1]);
+
+	if (ret < 0)
+		return ret;
+	aic->page_no = page;
+	return ret;
+}
+/**
+ * aic_reg_read: Read a single TLV320AIC register.
+ *
+ * @aic: Device to read from.
+ * @reg: Register to read.
+ */
+int aic_reg_read(struct aic *aic, unsigned int reg)
+{
+	unsigned int val;
+	int ret;
+	union aic_reg_union *aic_reg = (union aic_reg_union *) &reg;
+	u8 book, page, offset;
+
+	page = aic_reg->aic_register.page;
+	book = aic_reg->aic_register.book;
+	offset = aic_reg->aic_register.offset;
+
+	mutex_lock(&aic->io_lock);
+	if (aic->book_no != book) {
+		ret = set_aic_book(aic, book);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+
+	if (aic->page_no != page) {
+		ret = set_aic_page(aic, page);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_read(aic->regmap, offset, &val);
+	mutex_unlock(&aic->io_lock);
+
+	if (ret < 0)
+		return ret;
+	else
+		return val;
+}
+EXPORT_SYMBOL_GPL(aic_reg_read);
+
+/**
+ * aic_bulk_read: Read multiple TLV320AIC registers
+ *
+ * @aic: Device to read from
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to fill.  The data will be returned big endian.
+ */
+int aic_bulk_read(struct aic *aic, unsigned int reg,
+		      int count, u8 *buf)
+{
+	int ret;
+	union aic_reg_union *aic_reg = (union aic_reg_union *) &reg;
+	u8 book, page, offset;
+
+	page = aic_reg->aic_register.page;
+	book = aic_reg->aic_register.book;
+	offset = aic_reg->aic_register.offset;
+
+	mutex_lock(&aic->io_lock);
+	if (aic->book_no != book) {
+		ret = set_aic_book(aic, book);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+
+	if (aic->page_no != page) {
+		ret = set_aic_page(aic, page);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_bulk_read(aic->regmap, offset, buf, count);
+	mutex_unlock(&aic->io_lock);
+		return ret;
+}
+EXPORT_SYMBOL_GPL(aic_bulk_read);
+
+/**
+ * aic_reg_write: Write a single TLV320AIC register.
+ *
+ * @aic: Device to write to.
+ * @reg: Register to write to.
+ * @val: Value to write.
+ */
+int aic_reg_write(struct aic *aic, unsigned int reg,
+		      unsigned char val)
+{
+	union aic_reg_union *aic_reg = (union aic_reg_union *) &reg;
+	int ret = 0;
+	u8 page, book, offset;
+
+	page = aic_reg->aic_register.page;
+	book = aic_reg->aic_register.book;
+	offset = aic_reg->aic_register.offset;
+
+	mutex_lock(&aic->io_lock);
+	if (book != aic->book_no) {
+		ret = set_aic_book(aic, book);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	if (page != aic->page_no) {
+		ret = set_aic_page(aic, page);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_write(aic->regmap, offset, val);
+	mutex_unlock(&aic->io_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(aic_reg_write);
+
+/**
+ * aic_bulk_write: Write multiple TLV320AIC registers
+ *
+ * @aic: Device to write to
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to write from.  Data must be big-endian formatted.
+ */
+int aic_bulk_write(struct aic *aic, unsigned int reg,
+		       int count, const u8 *buf)
+{
+	union aic_reg_union *aic_reg = (union aic_reg_union *) &reg;
+	int ret = 0;
+	u8 page, book, offset;
+
+	page = aic_reg->aic_register.page;
+	book = aic_reg->aic_register.book;
+	offset = aic_reg->aic_register.offset;
+
+	mutex_lock(&aic->io_lock);
+	if (book != aic->book_no) {
+		ret = set_aic_book(aic, book);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	if (page != aic->page_no) {
+		ret = set_aic_page(aic, page);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_raw_write(aic->regmap, offset, buf, count);
+	mutex_unlock(&aic->io_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic_bulk_write);
+
+/**
+ * aic_set_bits: Set the value of a bitfield in a TLV320AIC register
+ *
+ * @aic: Device to write to.
+ * @reg: Register to write to.
+ * @mask: Mask of bits to set.
+ * @val: Value to set (unshifted)
+ */
+int aic_set_bits(struct aic *aic, unsigned int reg,
+		     unsigned char mask, unsigned char val)
+{
+	union aic_reg_union *aic_reg = (union aic_reg_union *) &reg;
+	int ret = 0;
+	u8 page, book, offset;
+
+	page = aic_reg->aic_register.page;
+	book = aic_reg->aic_register.book;
+	offset = aic_reg->aic_register.offset;
+
+	mutex_lock(&aic->io_lock);
+	if (book != aic->book_no) {
+		ret = set_aic_book(aic, book);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	if (page != aic->page_no) {
+		ret = set_aic_page(aic, page);
+		if (ret < 0) {
+			mutex_unlock(&aic->io_lock);
+			return ret;
+		}
+	}
+	ret = regmap_update_bits(aic->regmap, offset, mask, val);
+	mutex_unlock(&aic->io_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(aic_set_bits);
+
+/**
+ * aic_wait_bits: wait for a value of a bitfield in a TLV320AIC register
+ *
+ * @aic: Device to write to.
+ * @reg: Register to write to.
+ * @mask: Mask of bits to set.
+ * @val: Value to set (unshifted)
+ * @sleep: delay value in each iteration in micro seconds
+ * @count: iteration count for timeout
+ */
+int aic_wait_bits(struct aic *aic, unsigned int reg,
+		      unsigned char mask, unsigned char val, int sleep,
+		      int counter)
+{
+	int status;
+	int timeout = sleep * counter;
+
+	status = aic_reg_read(aic, reg);
+	while (((status & mask) != val) && counter) {
+		usleep_range(sleep, sleep + 500);
+		status = aic_reg_read(aic, reg);
+		counter--;
+	};
+	if (!counter)
+		dev_err(aic->dev,
+			"wait_bits timedout (%d millisecs). lastval 0x%x\n",
+			timeout, status);
+	return counter;
+}
+EXPORT_SYMBOL_GPL(aic_wait_bits);
+
+static struct mfd_cell aic3262_devs[] = {
+	{
+	.name = "tlv320aic3262-codec",
+	},
+	{
+	.name = "tlv320aic3262-gpio",
+	},
+	{
+	.name = "tlv320aic3262-extcon",
+	}
+};
+
+
+/**
+ * Instantiate the generic non-control parts of the device.
+ */
+int aic_device_init(struct aic *aic)
+{
+	const char *devname;
+	int ret, irq_no;
+	u8 reset = 1;
+
+	mutex_init(&aic->io_lock);
+	dev_set_drvdata(aic->dev, aic);
+
+	if (dev_get_platdata(aic->dev))
+		memcpy(&aic->pdata, dev_get_platdata(aic->dev),
+			sizeof(aic->pdata));
+
+	/* GPIO reset for TLV320AIC codec */
+	if (gpio_is_valid(aic->pdata.gpio_reset)) {
+		ret = gpio_request_one(aic->pdata.gpio_reset,
+					GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+					"aic-reset-pin");
+		if (ret != 0) {
+			dev_err(aic->dev, "not able to acquire gpio\n");
+			goto err_return;
+		}
+	}
+
+	/* run the codec through software reset */
+	ret = aic_reg_write(aic, AIC_RESET, reset);
+	if (ret < 0) {
+		dev_err(aic->dev, "Could not write to AIC register\n");
+		goto err_return;
+	}
+
+	usleep_range(10000, 10500);
+
+	ret = aic_reg_read(aic, AIC_DEVICE_ID);
+	if (ret < 0) {
+		dev_err(aic->dev, "Failed to read ID register\n");
+		goto err_return;
+	}
+
+	switch (ret) {
+	case 3:
+		devname = "TLV320AIC3262";
+		if (aic->type != TLV320AIC3262)
+			dev_warn(aic->dev, "Device registered as type %d\n",
+				 aic->type);
+		aic->type = TLV320AIC3262;
+		break;
+	default:
+		dev_err(aic->dev, "Device is not a TLV320AIC");
+		ret = -EINVAL;
+		goto err_return;
+	}
+
+	dev_info(aic->dev, "%s\n", devname);
+
+	/*If naudint is gpio convert it to irq number */
+	if (aic->pdata.gpio_irq == 1) {
+		aic->irq = gpio_to_irq(aic->pdata.naudint_irq);
+		gpio_request(aic->pdata.naudint_irq, "aic-gpio-irq");
+		gpio_direction_input(aic->pdata.naudint_irq);
+	} else {
+		aic->irq = aic->pdata.naudint_irq;
+	}
+
+	for (irq_no = 0; irq_no < aic->pdata.num_gpios; irq_no++) {
+		aic_reg_write(aic, aic->pdata.gpio_defaults[irq_no].reg,
+			aic->pdata.gpio_defaults[irq_no].value);
+	}
+#ifdef CONFIG_MFD_AIC_IRQ
+	if (aic->irq) {
+		ret = aic_irq_init(aic);
+		if (ret < 0)
+			goto err_irq;
+	}
+#endif
+	switch (aic->type) {
+	case TLV320AIC3262:
+		ret = mfd_add_devices(aic->dev, -1, aic3262_devs,
+				ARRAY_SIZE(aic3262_devs), NULL,
+				0, aic->domain);
+		break;
+	default:
+		dev_err(aic->dev, "unable to recognize codec\n");
+		break;
+	}
+	if (ret != 0) {
+		dev_err(aic->dev, "Failed to add children: %d\n", ret);
+		goto err_mfd;
+	}
+	dev_info(aic->dev, "aic_device_init added mfd devices\n");
+
+	return 0;
+
+err_mfd:
+#ifdef CONFIG_MFD_AIC_IRQ
+	aic_irq_exit(aic);
+err_irq:
+#endif
+	if (aic->pdata.gpio_irq)
+		gpio_free(aic->pdata.naudint_irq);
+err_return:
+
+	if (aic->pdata.gpio_reset)
+		gpio_free(aic->pdata.gpio_reset);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic_device_init);
+
+void aic_device_exit(struct aic *aic)
+{
+
+	mfd_remove_devices(aic->dev);
+#ifdef CONFIG_MFD_AIC_IRQ
+	aic_irq_exit(aic);
+#endif
+	if (aic->pdata.gpio_irq)
+		gpio_free(aic->pdata.naudint_irq);
+	if (aic->pdata.gpio_reset)
+		gpio_free(aic->pdata.gpio_reset);
+
+}
+EXPORT_SYMBOL_GPL(aic_device_exit);
+
+MODULE_AUTHOR("Mukund Navada <navada@ti.comm>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_DESCRIPTION("Core support for the TLV320AIC audio CODEC");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tlv320aic-core.h b/include/linux/mfd/tlv320aic-core.h
new file mode 100644
index 0000000..60d7146
--- /dev/null
+++ b/include/linux/mfd/tlv320aic-core.h
@@ -0,0 +1,112 @@
+/*
+ * MFD driver for AIC family
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __MFD_AIC_CORE_H__
+#define __MFD_AIC_CORE_H__
+
+#include <linux/mfd/core.h>
+
+enum aic_type {
+	TLV320AIC3262 = 0,
+};
+
+union aic_reg_union {
+	struct aic_reg {
+		u8 offset;
+		u8 page;
+		u8 book;
+		u8 reserved;
+	} aic_register;
+	unsigned int aic_register_int;
+};
+
+/****************************             ************************************/
+
+struct aic_gpio_setup {
+	unsigned int reg;
+	u8 value;
+};
+
+/**
+ * Platform data for aic family device.
+ *
+ * @audio_mclk1: MCLK1 frequency in Hz
+ * @audio_mclk2: MCLK2 frequency in Hz
+ * @gpio_irq: whether AIC interrupts the host AP on a GPIO pin
+ *		of AP
+ * @gpio_reset: is the codec being reset by a gpio [host] pin,
+ *		if yes provide the number.
+ * @num_gpios: number of gpio pins on this device
+ * @gpio_defaults: all gpio configuration
+ * @naudint_irq: audio interrupt number
+ * @irq_base: base of chained interrupt handler
+ */
+struct aic_pdata {
+	unsigned int audio_mclk1;
+	unsigned int audio_mclk2;
+	unsigned int gpio_irq;	/* whether AIC interrupts the host AP on */
+				/* a GPIO pin of AP */
+	unsigned int gpio_reset;/* is the codec being reset by a gpio*/
+				/* [host] pin, if yes provide the number. */
+	int num_gpios;
+	/* all gpio configuration */
+	struct aic_gpio_setup *gpio_defaults;
+	int naudint_irq;	/* audio interrupt */
+	unsigned int irq_base;
+};
+
+struct aic {
+	struct mutex io_lock;
+	struct mutex irq_lock;
+	enum aic_type type;
+	struct device *dev;
+	struct regmap *regmap;
+	struct aic_pdata pdata;
+	void *control_data;
+	unsigned int irq;
+	unsigned int irq_base;
+	struct irq_domain *domain;
+	u8 irq_masks_cur;
+	u8 irq_masks_cache;
+	/* Used over suspend/resume */
+	bool suspended;
+	u8 book_no;
+	u8 page_no;
+};
+
+/* Device I/O API */
+int aic_reg_read(struct aic *aic, unsigned int reg);
+int aic_reg_write(struct aic *aic, unsigned int reg,
+		      unsigned char val);
+int aic_set_bits(struct aic *aic, unsigned int reg,
+		     unsigned char mask, unsigned char val);
+int aic_bulk_read(struct aic *aic, unsigned int reg,
+		      int count, u8 *buf);
+int aic_bulk_write(struct aic *aic, unsigned int reg,
+		       int count, const u8 *buf);
+int aic_wait_bits(struct aic *aic, unsigned int reg,
+		      unsigned char mask, unsigned char val, int delay,
+		      int counter);
+int aic_device_init(struct aic *aic);
+void aic_device_exit(struct aic *aic);
+
+#endif /* End of __MFD_AIC_CORE_H__ */
diff --git a/include/linux/mfd/tlv320aic-registers.h b/include/linux/mfd/tlv320aic-registers.h
new file mode 100644
index 0000000..8b56532
--- /dev/null
+++ b/include/linux/mfd/tlv320aic-registers.h
@@ -0,0 +1,32 @@
+/*
+ * tlv320aic-registers: Register bits for AIC codecs
+ *
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *              Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __MFD_AIC_REGISTERS_H__
+#define __MFD_AIC_REGISTERS_H__
+#define AIC_MAKE_REG(book, page, offset)	(unsigned int)((book << 16) | \
+								(page << 8) | \
+								offset)
+
+#define AIC_RESET			AIC_MAKE_REG(0, 0, 1)
+#define AIC_DEVICE_ID			AIC_MAKE_REG(0, 0, 125)
+#endif
-- 
1.7.0.4

