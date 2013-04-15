Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3DOMMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:12:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37340 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3DOMMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:12:06 -0400
Message-ID: <516BEE8B.5010409@ti.com>
Date: Mon, 15 Apr 2013 17:41:55 +0530
From: x0172184 <x0172184@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "BAJWA, MEHAR" <mehar.bajwa@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Navada Kanyana, Mukund" <navada@ti.com>,
        "liam.r.girdwood@intel.com" <liam.r.girdwood@intel.com>
Subject: Re: [PATCH: v2]: Mfd-Initial-support-for-Texas-Instruments-AIC-family-Codecs
References: <511DFF8A.1080801@ti.com> <7506746A41B00D4598AF8BB18AB156933E9116F8@DBDE01.ent.ti.com> <20130405155151.GG17363@zurbaran>
In-Reply-To: <20130405155151.GG17363@zurbaran>
Content-Type: multipart/mixed;
	boundary="------------070502050800080402020601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------070502050800080402020601
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On Friday 05 April 2013 09:21 PM, Samuel Ortiz wrote:
> Hi Mehar,
>
> On Sun, Feb 17, 2013 at 05:15:38AM +0000, BAJWA, MEHAR wrote:
>> Hi Samuel,
>>      I am re-sending the MFD support for AIC family of Audio CODECs
>> from Texas Instruments. The patch was tested on mfd-for-linus-3.8-1.
>> I would like to request that this be considered for inclusion in the kernel
>> at the next available window. Could you please let me know if you have
>> any comments/recommendations for this patch. We would like to work on it
>> and get it up-streamed.
> The patch looks good to me, but I'd like it to be splitted in several pieces.
> You can probably place the core, the irq, the spi and the i2c pieces in their
> own patches.
>
> Cheers,
> Samuel.
>
Hi Samuel,
     Thanks for your comments. As suggested by you, I am sending
individual patches as version 2.

Regards,
Mehar

--------------070502050800080402020601
Content-Type: text/x-patch;
	name="0001-mfd-Initial-support-for-Texas-Instruments-AIC-family.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-mfd-Initial-support-for-Texas-Instruments-AIC-family.pa";
	filename*1="tch"

>From 767b98b6a6ab08b2c0e22c4d0b16a17d1eeadf5d Mon Sep 17 00:00:00 2001
From: Mehar Bajwa <mehar.bajwa@ti.com>
Date: Fri, 12 Apr 2013 15:24:40 +0530
Subject: [PATCH 1/4] mfd: Initial support for Texas Instruments AIC family of CODECs

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


--------------070502050800080402020601
Content-Type: text/x-patch;
	name="0002-mfd-Interrupt-handling-support-for-AIC-family.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
	filename="0002-mfd-Interrupt-handling-support-for-AIC-family.patch"

>From 64df2769d1a817d2c257a6a72fad820a0116abb0 Mon Sep 17 00:00:00 2001
From: Mehar Bajwa <mehar.bajwa@ti.com>
Date: Fri, 12 Apr 2013 15:38:45 +0530
Subject: [PATCH 2/4] mfd: Interrupt handling support for AIC family

This provides Interrupt handling features for common interface
to series of low power AIC audio CODECS.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig                     |   13 ++
 drivers/mfd/Makefile                    |    1 +
 drivers/mfd/tlv320aic-irq.c             |  234 +++++++++++++++++++++++++++++++
 include/linux/mfd/tlv320aic-core.h      |   49 ++++++-
 include/linux/mfd/tlv320aic-registers.h |   57 ++++++++
 5 files changed, 348 insertions(+), 6 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-irq.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 629d374..3019897 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -58,6 +58,19 @@ config MFD_AIC
 	  you have to select individual components like codec device
 	  to use AIC features.
 
+menu "AIC Interface Drivers"
+	depends on MFD_AIC
+
+config MFD_AIC_IRQ
+	bool "Support of IRQ for AIC"
+	depends on MFD_AIC
+	help
+	  Say yes here if you want support of IRQ for Texas Instruments
+	  AIC codec family.
+	  You have to select individual components like codec device
+	  under the corresponding menus.
+endmenu
+
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
 	 ---help---
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b975c94..3b39454 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
 obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
+obj-$(CONFIG_MFD_AIC_IRQ)	+= tlv320aic-irq.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-irq.c b/drivers/mfd/tlv320aic-irq.c
new file mode 100644
index 0000000..e299495
--- /dev/null
+++ b/drivers/mfd/tlv320aic-irq.c
@@ -0,0 +1,234 @@
+/*
+ * tlv320aic-irq.c  --  Interrupt controller support for
+ *			 TI TLV320AIC family
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+#include <linux/mfd/tlv320aic-registers.h>
+
+#include <linux/delay.h>
+
+struct aic_irq_data {
+	int mask;
+	int status;
+};
+
+static struct aic_irq_data aic_irqs[] = {
+	{
+	 .mask = AIC_HEADSET_IN_M,
+	 .status = AIC_HEADSET_PLUG_UNPLUG_INT,
+	 },
+	{
+	 .mask = AIC_BUTTON_PRESS_M,
+	 .status = AIC_BUTTON_PRESS_INT,
+	 },
+	{
+	 .mask = AIC_DAC_DRC_THRES_M,
+	 .status = AIC_LEFT_DRC_THRES_INT | AIC_RIGHT_DRC_THRES_INT,
+	 },
+	{
+	 .mask = AIC_AGC_NOISE_M,
+	 .status = AIC_LEFT_AGC_NOISE_INT | AIC_RIGHT_AGC_NOISE_INT,
+	 },
+	{
+	 .mask = AIC_OVER_CURRENT_M,
+	 .status = AIC_LEFT_OUTPUT_DRIVER_OVERCURRENT_INT
+	 | AIC_RIGHT_OUTPUT_DRIVER_OVERCURRENT_INT,
+	 },
+	{
+	 .mask = AIC_OVERFLOW_M,
+	 .status =
+	 AIC_LEFT_DAC_OVERFLOW_INT | AIC_RIGHT_DAC_OVERFLOW_INT |
+	 AIC_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT |
+	 AIC_LEFT_ADC_OVERFLOW_INT | AIC_RIGHT_ADC_OVERFLOW_INT |
+	 AIC_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT,
+	 },
+	{
+	 .mask = AIC_SPK_OVERCURRENT_M,
+	 .status = AIC_SPK_OVER_CURRENT_INT,
+	 },
+
+};
+
+static void aic_irq_lock(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&aic->irq_lock);
+}
+
+static void aic_irq_sync_unlock(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+
+	/* write back to hardware any change in irq mask */
+	if (aic->irq_masks_cur != aic->irq_masks_cache) {
+		aic->irq_masks_cache = aic->irq_masks_cur;
+		aic_reg_write(aic, AIC_INT1_CNTL,
+				  aic->irq_masks_cur);
+	}
+
+	mutex_unlock(&aic->irq_lock);
+}
+
+
+static void aic_irq_enable(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+	struct aic_irq_data *irq_data = &aic_irqs[data->hwirq];
+	aic->irq_masks_cur |= irq_data->mask;
+}
+
+static void aic_irq_disable(struct irq_data *data)
+{
+	struct aic *aic = irq_data_get_irq_chip_data(data);
+	struct aic_irq_data *irq_data = &aic_irqs[data->hwirq];
+
+	aic->irq_masks_cur &= ~irq_data->mask;
+}
+
+static struct irq_chip aic_irq_chip = {
+	.name = "tlv320aic",
+	.irq_bus_lock = aic_irq_lock,
+	.irq_bus_sync_unlock = aic_irq_sync_unlock,
+	.irq_enable = aic_irq_enable,
+	.irq_disable = aic_irq_disable
+};
+
+static irqreturn_t aic_irq_thread(int irq, void *data)
+{
+	struct aic *aic = data;
+	u8 status[4];
+
+	/* Reading sticky bit registers acknowledges
+		the interrupt to the device */
+	aic_bulk_read(aic, AIC_INT_STICKY_FLAG1, 4, status);
+
+	/* report  */
+	if (status[2] & aic_irqs[AIC_IRQ_HEADSET_DETECT].status)
+		handle_nested_irq(aic->irq_base);
+	if (status[2] & aic_irqs[AIC_IRQ_BUTTON_PRESS].status)
+		handle_nested_irq(aic->irq_base + 1);
+	if (status[2] & aic_irqs[AIC_IRQ_DAC_DRC].status)
+		handle_nested_irq(aic->irq_base + 2);
+	if (status[3] & aic_irqs[AIC_IRQ_AGC_NOISE].status)
+		handle_nested_irq(aic->irq_base + 3);
+	if (status[2] & aic_irqs[AIC_IRQ_OVER_CURRENT].status)
+		handle_nested_irq(aic->irq_base + 4);
+	if (status[0] & aic_irqs[AIC_IRQ_OVERFLOW_EVENT].status)
+		handle_nested_irq(aic->irq_base + 5);
+	if (status[3] & aic_irqs[AIC_IRQ_SPEAKER_OVER_TEMP].status)
+		handle_nested_irq(aic->irq_base + 6);
+
+	return IRQ_HANDLED;
+}
+
+static int aic_irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw)
+{
+	struct aic *aic = h->host_data;
+
+	irq_set_chip_data(virq, aic);
+	irq_set_chip_and_handler(virq, &aic_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static const struct irq_domain_ops aic_domain_ops = {
+	.map    = aic_irq_map,
+	.xlate  = irq_domain_xlate_twocell,
+};
+
+int aic_irq_init(struct aic *aic)
+{
+	int ret;
+
+	mutex_init(&aic->irq_lock);
+
+	/* mask the individual interrupt sources */
+	aic->irq_masks_cur = 0x0;
+	aic->irq_masks_cache = 0x0;
+	aic_reg_write(aic, AIC_INT1_CNTL, 0x0);
+
+	if (!aic->irq) {
+		dev_warn(aic->dev, "no interrupt specified\n");
+		aic->irq_base = 0;
+		return 0;
+	}
+	if (aic->irq_base) {
+		aic->domain = irq_domain_add_legacy(aic->dev->of_node,
+					ARRAY_SIZE(aic_irqs),
+					aic->irq_base, 0,
+					&aic_domain_ops, aic);
+	} else {
+		aic->domain = irq_domain_add_linear(aic->dev->of_node,
+					ARRAY_SIZE(aic_irqs),
+					&aic_domain_ops, aic);
+		/* initiallizing irq_base from irq_domain*/
+	}
+	if (!aic->domain) {
+		dev_err(aic->dev, "Failed to create IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	aic->irq_base = irq_create_mapping(aic->domain, 0);
+
+	ret = request_threaded_irq(aic->irq, NULL, aic_irq_thread,
+				   IRQF_ONESHOT,
+				   "tlv320aic", aic);
+	if (ret < 0) {
+		dev_err(aic->dev, "failed to request IRQ %d: %d\n",
+			aic->irq, ret);
+		return ret;
+	}
+	irq_set_irq_type(aic->irq, IRQF_TRIGGER_RISING);
+
+	return 0;
+}
+EXPORT_SYMBOL(aic_irq_init);
+
+void aic_irq_exit(struct aic *aic)
+{
+	if (aic->irq)
+		free_irq(aic->irq, aic);
+}
+EXPORT_SYMBOL(aic_irq_exit);
+MODULE_AUTHOR("Mukund navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_DESCRIPTION("Interrupt controller support for TI TLV320AIC family");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tlv320aic-core.h b/include/linux/mfd/tlv320aic-core.h
index 60d7146..66a46fb 100644
--- a/include/linux/mfd/tlv320aic-core.h
+++ b/include/linux/mfd/tlv320aic-core.h
@@ -23,12 +23,22 @@
 #ifndef __MFD_AIC_CORE_H__
 #define __MFD_AIC_CORE_H__
 
+#include <linux/interrupt.h>
 #include <linux/mfd/core.h>
+#include <linux/irqdomain.h>
 
 enum aic_type {
 	TLV320AIC3262 = 0,
 };
 
+#define AIC_IRQ_HEADSET_DETECT		0
+#define AIC_IRQ_BUTTON_PRESS		1
+#define AIC_IRQ_DAC_DRC			2
+#define AIC_IRQ_AGC_NOISE		3
+#define AIC_IRQ_OVER_CURRENT		4
+#define AIC_IRQ_OVERFLOW_EVENT		5
+#define AIC_IRQ_SPEAKER_OVER_TEMP	6
+
 union aic_reg_union {
 	struct aic_reg {
 		u8 offset;
@@ -93,19 +103,46 @@ struct aic {
 	u8 page_no;
 };
 
+static inline int aic_request_irq(struct aic *aic, int irq,
+				      irq_handler_t handler,
+				      unsigned long irqflags, const char *name,
+				      void *data)
+{
+	irq = irq_create_mapping(aic->domain, irq);
+	if (irq < 0) {
+		dev_err(aic->dev,
+			"Mapping hardware interrupt failed %d\n", irq);
+		return irq;
+	}
+
+	return request_threaded_irq(irq, NULL, handler,
+				    irqflags, name, data);
+}
+
+static inline int aic_free_irq(struct aic *aic, int irq, void *data)
+{
+	if (!aic->irq_base)
+		return -EINVAL;
+
+	free_irq(aic->irq_base + irq, data);
+	return 0;
+}
+
 /* Device I/O API */
 int aic_reg_read(struct aic *aic, unsigned int reg);
 int aic_reg_write(struct aic *aic, unsigned int reg,
-		      unsigned char val);
+			unsigned char val);
 int aic_set_bits(struct aic *aic, unsigned int reg,
-		     unsigned char mask, unsigned char val);
+			unsigned char mask, unsigned char val);
 int aic_bulk_read(struct aic *aic, unsigned int reg,
-		      int count, u8 *buf);
+			int count, u8 *buf);
 int aic_bulk_write(struct aic *aic, unsigned int reg,
-		       int count, const u8 *buf);
+			int count, const u8 *buf);
 int aic_wait_bits(struct aic *aic, unsigned int reg,
-		      unsigned char mask, unsigned char val, int delay,
-		      int counter);
+			unsigned char mask, unsigned char val, int delay,
+			int counter);
+int aic_irq_init(struct aic *aic);
+void aic_irq_exit(struct aic *aic);
 int aic_device_init(struct aic *aic);
 void aic_device_exit(struct aic *aic);
 
diff --git a/include/linux/mfd/tlv320aic-registers.h b/include/linux/mfd/tlv320aic-registers.h
index 8b56532..c940fae 100644
--- a/include/linux/mfd/tlv320aic-registers.h
+++ b/include/linux/mfd/tlv320aic-registers.h
@@ -28,5 +28,62 @@
 								offset)
 
 #define AIC_RESET			AIC_MAKE_REG(0, 0, 1)
+#define AIC_REV_PG_ID			AIC_MAKE_REG(0, 0, 2)
+#define AIC_INT_STICKY_FLAG1		AIC_MAKE_REG(0, 0, 42)
+#define AIC_INT_STICKY_FLAG2		AIC_MAKE_REG(0, 0, 44)
+#define AIC_INT_STICKY_FLAG3		AIC_MAKE_REG(0, 0, 45)
+#define AIC_INT1_CNTL			AIC_MAKE_REG(0, 0, 48)
+#define AIC_INT2_CNTL			AIC_MAKE_REG(0, 0, 49)
+#define AIC_INT_FMT			AIC_MAKE_REG(0, 0, 51)
 #define AIC_DEVICE_ID			AIC_MAKE_REG(0, 0, 125)
+
+/*
+ *  B0_P0_R2 (0x000002) – Revision ID register.
+ */
+#define AIC_REV_M			(0b01110000)
+#define AIC_REV_S			(0b00000100)
+#define AIC_PG_M			(0b00000111)
+#define AIC_PG_S			(0b00000000)
+/*
+ * B0_P0_R42 (0x00002a) – Interrupt Status 1
+ */
+#define AIC_LEFT_DAC_OVERFLOW_INT		0x80
+#define AIC_RIGHT_DAC_OVERFLOW_INT		0x40
+#define AIC_MINIDSP_D_BARREL_SHIFT_OVERFLOW_INT	0x20
+#define AIC_LEFT_ADC_OVERFLOW_INT		0x08
+#define AIC_RIGHT_ADC_OVERFLOW_INT		0x04
+#define AIC_MINIDSP_A_BARREL_SHIFT_OVERFLOW_INT	0x02
+/*
+ * B0_P0_R44 (0x00002c) - Interrupt Status 2
+ */
+#define AIC_LEFT_OUTPUT_DRIVER_OVERCURRENT_INT	0x80
+#define AIC_RIGHT_OUTPUT_DRIVER_OVERCURRENT_INT	0x40
+#define AIC_BUTTON_PRESS_INT			0x20
+#define AIC_HEADSET_PLUG_UNPLUG_INT		0x10
+#define AIC_LEFT_DRC_THRES_INT			0x08
+#define AIC_RIGHT_DRC_THRES_INT			0x04
+#define AIC_MINIDSP_D_STD_INT			0x02
+#define AIC_MINIDSP_D_AUX_INT			0x01
+/*
+ * B0_P0_R45 (0x00002d) - Interrupt Status 3
+ */
+#define AIC_SPK_OVER_CURRENT_INT		0x80
+#define AIC_LEFT_AGC_NOISE_INT			0x40
+#define AIC_RIGHT_AGC_NOISE_INT			0x20
+#define AIC_MINIDSP_A_STD_INT			0x10
+#define AIC_MINIDSP_A_AUX_INT			0x08
+#define AIC_LEFT_ADC_DC_DATA_AVAILABLE_INT	0x04
+#define AIC_RIGHT_ADC_DC_DATA_AVAILABLE_INT	0x02
+#define AIC_CP_SHORT_CIRCUIT_INT		0x01
+/*
+ * B0_P0_R48 (0x000030) - Interrupt Control 1
+ */
+#define AIC_HEADSET_IN_M			0x80
+#define AIC_BUTTON_PRESS_M			0x40
+#define AIC_DAC_DRC_THRES_M			0x20
+#define AIC_AGC_NOISE_M				0x10
+#define AIC_OVER_CURRENT_M			0x08
+#define AIC_OVERFLOW_M				0x04
+#define AIC_SPK_OVERCURRENT_M			0x02
+#define AIC_CP_SHORT_CIRCUIT_M			0x02
 #endif
-- 
1.7.0.4


--------------070502050800080402020601
Content-Type: text/x-patch;
	name="0003-mfd-I2C-interface-with-AIC-platform.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0003-mfd-I2C-interface-with-AIC-platform.patch"

>From cc75a5308791e50ae5cb9bc97168ecf81f0db795 Mon Sep 17 00:00:00 2001
From: Mehar Bajwa <mehar.bajwa@ti.com>
Date: Fri, 12 Apr 2013 15:42:15 +0530
Subject: [PATCH 3/4] mfd: I2C interface with AIC platform

Texas Instruments TLV320AIC family of audio SoC
core functionality controlled via I2C. This driver
provides common support for accessing the device.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig         |   12 +++++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/tlv320aic-i2c.c |   98 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3019897..40eb328 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -64,11 +64,23 @@ menu "AIC Interface Drivers"
 config MFD_AIC_IRQ
 	bool "Support of IRQ for AIC"
 	depends on MFD_AIC
+	default y
 	help
 	  Say yes here if you want support of IRQ for Texas Instruments
 	  AIC codec family.
 	  You have to select individual components like codec device
 	  under the corresponding menus.
+
+config MFD_AIC_I2C
+	bool "AIC I2C Interface"
+	select REGMAP_I2C
+	depends on MFD_AIC
+	depends on I2C
+	help
+	  Support for the Texas Instruments TLV320AIC family of audio SoC
+	  core functionality controlled via I2C. This driver provides common
+	  support for accessing the device, additional drivers must be enabled
+	  in order to use the functionality of the device.
 endmenu
 
 config MFD_SM501
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3b39454..1e2c96a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
 obj-$(CONFIG_MFD_AIC_IRQ)	+= tlv320aic-irq.o
+obj-$(CONFIG_MFD_AIC_I2C)	+= tlv320aic-i2c.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-i2c.c b/drivers/mfd/tlv320aic-i2c.c
new file mode 100644
index 0000000..18987b1
--- /dev/null
+++ b/drivers/mfd/tlv320aic-i2c.c
@@ -0,0 +1,98 @@
+/*
+ * tlv320aic-i2c.c  -- driver for TLV320AIC Codecs Family
+ *
+ * Author:	Mukund Navada <navada@ti.com>
+ *		Mehar Bajwa <mehar.bajwa@ti.com>
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
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+
+struct regmap_config aic_i2c_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.cache_type = REGCACHE_NONE,
+};
+
+static int aic_i2c_probe(struct i2c_client *i2c,
+					  const struct i2c_device_id *id)
+{
+	struct aic *aic;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	regmap_config = &aic_i2c_regmap;
+
+	aic = devm_kzalloc(&i2c->dev, sizeof(*aic), GFP_KERNEL);
+	if (aic == NULL)
+		return -ENOMEM;
+
+	aic->regmap = devm_regmap_init_i2c(i2c, regmap_config);
+
+	if (IS_ERR(aic->regmap)) {
+		ret = PTR_ERR(aic->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	aic->type = id->driver_data;
+	aic->dev = &i2c->dev;
+	aic->irq = i2c->irq;
+
+	return aic_device_init(aic);
+}
+
+static int aic_i2c_remove(struct i2c_client *i2c)
+{
+	struct aic *aic = dev_get_drvdata(&i2c->dev);
+
+	aic_device_exit(aic);
+	return 0;
+}
+
+static const struct i2c_device_id aic_i2c_id[] = {
+	{"tlv320aic3262", TLV320AIC3262},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, aic_i2c_id);
+
+static struct i2c_driver aic_i2c_driver = {
+	.driver = {
+		.name	= "tlv320aic",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aic_i2c_probe,
+	.remove		= aic_i2c_remove,
+	.id_table	= aic_i2c_id,
+};
+
+module_i2c_driver(aic_i2c_driver);
+
+MODULE_DESCRIPTION("TLV320AIC I2C bus interface");
+MODULE_AUTHOR("Mukund Navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4


--------------070502050800080402020601
Content-Type: text/x-patch;
	name="0004-mfd-SPI-interface-with-AIC-platform.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0004-mfd-SPI-interface-with-AIC-platform.patch"

>From 5ff43c8a4da33b481f6554efaae3f5de0c4b6693 Mon Sep 17 00:00:00 2001
From: Mehar Bajwa <mehar.bajwa@ti.com>
Date: Fri, 12 Apr 2013 15:44:24 +0530
Subject: [PATCH 4/4] mfd: SPI interface with AIC platform

Texas Instruments TLV320AIC family of audio SoC
core functionality controlled via SPI. This driver
provides common support for accessing the device.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig         |   11 +++++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/tlv320aic-spi.c |   97 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-spi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 40eb328..b1d6269 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -81,6 +81,17 @@ config MFD_AIC_I2C
 	  core functionality controlled via I2C. This driver provides common
 	  support for accessing the device, additional drivers must be enabled
 	  in order to use the functionality of the device.
+
+config MFD_AIC_SPI
+	bool "AIC SPI Interface"
+	select REGMAP_SPI
+	depends on MFD_AIC
+	depends on SPI_MASTER
+	help
+	  Support for the Texas Instruments TLV320AIC family of audio SoC
+	  core functionality controlled via SPI.  This driver provides common
+	  support for accessing the device, additional drivers must be enabled
+	  in order to use the functionality of the device.
 endmenu
 
 config MFD_SM501
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 1e2c96a..dfdcfa2 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
 obj-$(CONFIG_MFD_AIC_IRQ)	+= tlv320aic-irq.o
 obj-$(CONFIG_MFD_AIC_I2C)	+= tlv320aic-i2c.o
+obj-$(CONFIG_MFD_AIC_SPI)	+= tlv320aic-spi.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-spi.c b/drivers/mfd/tlv320aic-spi.c
new file mode 100644
index 0000000..2faeb40
--- /dev/null
+++ b/drivers/mfd/tlv320aic-spi.c
@@ -0,0 +1,97 @@
+/*
+ * tlv320aic-spi.c  -- driver for TLV320AIC
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *		Mehar Bajwa <mehar.bajwa@ti.com>
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
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+
+struct regmap_config aic_spi_regmap = {
+	.reg_bits = 7,
+	.val_bits = 8,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = 0x1,
+	.pad_bits = 1,
+};
+
+static int tlv320aic_spi_probe(struct spi_device *spi)
+{
+	const struct spi_device_id *id = spi_get_device_id(spi);
+	struct aic *aic;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	regmap_config = &aic_spi_regmap;
+
+	aic = devm_kzalloc(&spi->dev, sizeof(struct aic), GFP_KERNEL);
+	if (aic == NULL)
+		return -ENOMEM;
+
+	aic->regmap = devm_regmap_init_spi(spi, regmap_config);
+	if (IS_ERR(aic->regmap)) {
+		ret = PTR_ERR(aic->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	aic->type = id->driver_data;
+	aic->dev = &spi->dev;
+	aic->irq = spi->irq;
+
+	return aic_device_init(aic);
+}
+
+static int tlv320aic_spi_remove(struct spi_device *spi)
+{
+	struct aic *aic = dev_get_drvdata(&spi->dev);
+	aic_device_exit(aic);
+	return 0;
+}
+
+static const struct spi_device_id aic_spi_ids[] = {
+	{"tlv320aic3262", TLV320AIC3262},
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, aic_spi_ids);
+
+static struct spi_driver tlv320aic_spi_driver = {
+	.driver = {
+		.name	= "tlv320aic",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tlv320aic_spi_probe,
+	.remove		= tlv320aic_spi_remove,
+	.id_table	= aic_spi_ids,
+};
+
+module_spi_driver(tlv320aic_spi_driver);
+
+MODULE_DESCRIPTION("TLV320AIC SPI bus interface");
+MODULE_AUTHOR("Mukund Navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4


--------------070502050800080402020601--
