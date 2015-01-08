Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbbAHAto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:49:44 -0500
Received: from mailout.micron.com ([137.201.242.129]:36892 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbAHAtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:49:40 -0500
From: =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?gb2312?B?UWkgV2FuZyDN9cbwIChxaXdhbmcp?= <qiwang@micron.com>,
        =?gb2312?B?RnJhbmsgTGl1IMH1yLogKGZyYW5rbGl1KQ==?= 
	<frankliu@micron.com>,
        =?gb2312?B?TWVsYW5pZSBaaGFuZyDVxdHgIChtZWxhbmllemhhbmcp?= 
	<melaniezhang@micron.com>,
        =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
Subject: [PATCH 1/3] mtd: spi-nand framework
Thread-Topic: [PATCH 1/3] mtd: spi-nand framework
Thread-Index: AQHQKttfVV0FJXvc40m7NN+pymYWc5y1Y6qw
Date: Thu, 8 Jan 2015 00:48:49 +0000
Message-ID: <87F60714EC601C4C83DFF1D2E3D390A04AB404@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21232.000
x-tm-as-result: No--42.418800-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t080nsxN027778

Add framework to support spi nand devices. The code is derived from
parallel nand code.

Signed-off-by: Peter Pan <peterpandong@micron.com>
---
 drivers/mtd/Kconfig                  |    2 +
 drivers/mtd/Makefile                 |    1 +
 drivers/mtd/spi-nand/Kconfig         |    7 +
 drivers/mtd/spi-nand/Makefile        |    2 +
 drivers/mtd/spi-nand/spi-nand-base.c | 2034 ++++++++++++++++++++++++++++++++++
 drivers/mtd/spi-nand/spi-nand-bbt.c  | 1279 +++++++++++++++++++++
 include/linux/mtd/spi-nand.h         |  317 ++++++
 7 files changed, 3642 insertions(+)
 create mode 100644 drivers/mtd/spi-nand/Kconfig
 create mode 100644 drivers/mtd/spi-nand/Makefile
 create mode 100644 drivers/mtd/spi-nand/spi-nand-base.c
 create mode 100644 drivers/mtd/spi-nand/spi-nand-bbt.c
 create mode 100644 include/linux/mtd/spi-nand.h

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 71fea89..444b695 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -323,6 +323,8 @@ source "drivers/mtd/lpddr/Kconfig"
 
 source "drivers/mtd/spi-nor/Kconfig"
 
+source "drivers/mtd/spi-nand/Kconfig"
+
 source "drivers/mtd/ubi/Kconfig"
 
 endif # MTD
diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 99bb9a1..581688f 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -33,4 +33,5 @@ inftl-objs		:= inftlcore.o inftlmount.o
 obj-y		+= chips/ lpddr/ maps/ devices/ nand/ onenand/ tests/
 
 obj-$(CONFIG_MTD_SPI_NOR)	+= spi-nor/
+obj-$(CONFIG_MTD_SPI_NAND)	+= spi-nand/
 obj-$(CONFIG_MTD_UBI)		+= ubi/
diff --git a/drivers/mtd/spi-nand/Kconfig b/drivers/mtd/spi-nand/Kconfig
new file mode 100644
index 0000000..b4da8f5
--- /dev/null
+++ b/drivers/mtd/spi-nand/Kconfig
@@ -0,0 +1,7 @@
+menuconfig MTD_SPI_NAND
+	tristate "SPI-NAND device Support"
+	depends on MTD_NAND && SPI
+	help
+	  This is the framework for the SPI NAND which can be used by the SPI
+	  device drivers and the SPI-NAND device drivers.
+
diff --git a/drivers/mtd/spi-nand/Makefile b/drivers/mtd/spi-nand/Makefile
new file mode 100644
index 0000000..6df6a34
--- /dev/null
+++ b/drivers/mtd/spi-nand/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_MTD_SPI_NAND) += spi-nand-base.o
+obj-$(CONFIG_MTD_SPI_NAND) += spi-nand-bbt.o
diff --git a/drivers/mtd/spi-nand/spi-nand-base.c b/drivers/mtd/spi-nand/spi-nand-base.c
new file mode 100644
index 0000000..4ef5914
--- /dev/null
+++ b/drivers/mtd/spi-nand/spi-nand-base.c
@@ -0,0 +1,2034 @@
+/**
+* spi-nand-base.c
+*
+* Copyright (c) 2009-2014 Micron Technology, Inc.
+*
+* Derived from nand_base.c
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License
+* as published by the Free Software Foundation; either version 2
+* of the License, or (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/spi-nand.h>
+#include <linux/mtd/bbm.h>
+#include <linux/spi/spi.h>
+#include <linux/slab.h>
+
+
+static struct spi_nand_flash spi_nand_table[] = {
+	SPI_NAND_INFO("MT29F2G01AAAED", 0x2C, 0X22, 2048, 64, 64, 2048,
+			SPINAND_NEED_PLANE_SELECT),
+	SPI_NAND_INFO("MT29F4G01AAADD", 0x2C, 0X32, 2048, 64, 64, 4096,
+			SPINAND_NEED_PLANE_SELECT),
+	SPI_NAND_INFO("GD5F 512MiB 1.8V", 0xC8, 0XA4, 4096, 256, 64, 2048,
+			0),
+	SPI_NAND_INFO("GD5F 512MiB 3.3V", 0xC8, 0XB4, 4096, 256, 64, 2048,
+			0),
+	SPI_NAND_INFO("GD5F 256MiB 3.3V", 0xC8, 0XB2, 2048, 128, 64, 2048,
+			0),
+	SPI_NAND_INFO("GD5F 128MiB 3.3V", 0xC8, 0XB1, 2048, 128, 64, 1024,
+			0),
+	{.name = NULL},
+};
+
+static int spi_nand_erase(struct mtd_info *mtd, struct erase_info *einfo);
+
+/**
+ * spi_nand_get_device - [GENERIC] Get chip for selected access
+ * @mtd: MTD device structure
+ * @new_state: the state which is requested
+ *
+ * Get the device and lock it for exclusive access
+ */
+static int spi_nand_get_device(struct mtd_info *mtd, int new_state)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	DECLARE_WAITQUEUE(wait, current);
+
+	/*
+	 * Grab the lock and see if the device is available
+	 */
+	while (1) {
+		spin_lock(&this->chip_lock);
+		if (this->state == FL_READY) {
+			this->state = new_state;
+			spin_unlock(&this->chip_lock);
+			break;
+		}
+		if (new_state == FL_PM_SUSPENDED) {
+			spin_unlock(&this->chip_lock);
+			return (this->state == FL_PM_SUSPENDED) ? 0 : -EAGAIN;
+		}
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		add_wait_queue(&this->wq, &wait);
+		spin_unlock(&this->chip_lock);
+		schedule();
+		remove_wait_queue(&this->wq, &wait);
+	}
+	return 0;
+}
+
+/**
+ * spi_nand_release_device - [GENERIC] release chip
+ * @mtd: MTD device structure
+ *
+ * Deselect, release chip lock and wake up anyone waiting on the device
+ */
+static void spi_nand_release_device(struct mtd_info *mtd)
+{
+	struct spi_nand_chip *this = mtd->priv;
+
+	/* Release the chip */
+	spin_lock(&this->chip_lock);
+	this->state = FL_READY;
+	wake_up(&this->wq);
+	spin_unlock(&this->chip_lock);
+}
+
+/**
+ * __spi_nand_do_read_page - [INTERN] read data from flash to buffer
+ * @mtd: MTD device structure
+ * @page_addr: page address/raw address
+ * @column :column address
+ * @raw: without ecc or not
+ * @corrected: how many bit error corrected
+ *
+ * read a page to buffer pointed by chip->buf
+ */
+static int __spi_nand_do_read_page(struct mtd_info *mtd, u32 page_addr,
+				u32 colunm, bool raw, int *corrected)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	int ret, ecc_error;
+	u8 status;
+
+	/*read data from chip*/
+	memset(chip->buf, 0, chip->page_size + chip->page_spare_size);
+	if (raw) {
+		ret = chip->disable_ecc(chip);
+		if (ret < 0) {
+			pr_debug("disable ecc failed\n");
+			return ret;
+		}
+	}
+	ret = chip->load_page(chip, page_addr);
+	if (ret < 0) {
+		pr_debug("error %d loading page 0x%x to cache\n",
+		ret, page_addr);
+		return ret;
+	}
+	ret = chip->waitfunc(chip, &status);
+	if (ret < 0) {
+		pr_debug("error %d waiting page 0x%x to cache\n",
+			ret, page_addr);
+		return ret;
+	}
+	chip->get_ecc_status(status, corrected, &ecc_error);
+	/*
+	 * If there's an ECC error, print a message and notify MTD
+	 * about it. Then complete the read, to load actual data on
+	 * the buffer (instead of the status result).
+	 */
+	if (ecc_error) {
+		pr_debug("internal ECC error reading page 0x%x\n",
+			page_addr);
+		mtd->ecc_stats.failed++;
+	} else if (*corrected) {
+		mtd->ecc_stats.corrected += *corrected;
+	}
+	/* Get page from the device cache into our internal buffer */
+	ret = chip->read_cache(chip, page_addr, colunm,
+			chip->page_size + chip->page_spare_size - colunm,
+			chip->buf + colunm);
+	if (ret < 0) {
+		pr_debug("error %d reading page 0x%x from cache\n",
+			ret, page_addr);
+		return ret;
+	}
+	if (raw) {
+		ret = chip->enable_ecc(chip);
+		if (ret < 0) {
+			pr_debug("enable ecc failed\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * spi_nand_do_read_page - [INTERN] read a page from flash to buffer
+ * @mtd: MTD device structure
+ * @page_addr: page address/raw address
+ * @raw: without ecc or not
+ * @corrected: how many bit error corrected
+ *
+ * read a page to buffer pointed by chip->buf
+ */
+static int spi_nand_do_read_page(struct mtd_info *mtd, u32 page_addr,
+				bool raw, int *corrected)
+{
+	return __spi_nand_do_read_page(mtd, page_addr, 0, raw, corrected);
+}
+
+/**
+ * spi_nand_do_read_page_oob - [INTERN] read page oob from flash to buffer
+ * @mtd: MTD device structure
+ * @page_addr: page address/raw address
+ * @raw: without ecc or not
+ * @corrected: how many bit error corrected
+ *
+ * read page oob to buffer pointed by chip->oobbuf
+ */
+static int spi_nand_do_read_page_oob(struct mtd_info *mtd, u32 page_addr,
+				bool raw, int *corrected)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+
+	return __spi_nand_do_read_page(mtd, page_addr, chip->page_size,
+					raw, corrected);
+}
+
+
+/**
+ * __spi_nand_do_write_page - [INTERN] write data from buffer to flash
+ * @mtd: MTD device structure
+ * @page_addr: page address/raw address
+ * @column :column address
+ * @raw: without ecc or not
+ *
+ * write data from buffer pointed by chip->buf to flash
+ */
+static int __spi_nand_do_write_page(struct mtd_info *mtd, u32 page_addr,
+				u32 column, bool raw)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	u8 status;
+	bool p_fail = false;
+	int ret = 0;
+
+	if (raw) {
+		ret = chip->disable_ecc(chip);
+		if (ret < 0) {
+			pr_debug("disable ecc failed\n");
+			return ret;
+		}
+	}
+	ret = chip->write_enable(chip);
+	if (ret < 0) {
+		pr_debug("write enable command failed\n");
+		return ret;
+	}
+	/* Store the page to cache */
+	ret = chip->store_cache(chip, page_addr, column,
+			chip->page_size + chip->page_spare_size - column,
+			chip->buf + column);
+	if (ret < 0) {
+		pr_debug("error %d storing page 0x%x to cache\n",
+			ret, page_addr);
+		return ret;
+	}
+	/* Get page from the device cache into our internal buffer */
+	ret = chip->write_page(chip, page_addr);
+	if (ret < 0) {
+		pr_debug("error %d reading page 0x%x from cache\n",
+			ret, page_addr);
+		return ret;
+	}
+	ret = chip->waitfunc(chip, &status);
+	if (ret < 0) {
+		pr_debug("error %d reading page 0x%x from cache\n",
+			ret, page_addr);
+		return ret;
+	}
+	if ((status & STATUS_P_FAIL_MASK) == STATUS_P_FAIL) {
+		pr_debug("program page 0x%x failed\n", page_addr);
+		p_fail = true;
+	}
+	if (raw) {
+		ret = chip->enable_ecc(chip);
+		if (ret < 0) {
+			pr_debug("enable ecc failed\n");
+			return ret;
+		}
+	}
+	if (p_fail)
+		ret = -EIO;
+
+	return ret;
+}
+
+/**
+ * spi_nand_do_write_page - [INTERN] write page from buffer to flash
+ * @mtd: MTD device structure
+ * @page_addr: page address/raw address
+ * @raw: without ecc or not
+ *
+ * write page from buffer pointed by chip->buf to flash
+ */
+static int spi_nand_do_write_page(struct mtd_info *mtd, u32 page_addr,
+				bool raw)
+{
+	return __spi_nand_do_write_page(mtd, page_addr, 0, raw);
+}
+
+/**
+ * spi_nand_do_write_page_oob - [INTERN] write oob from buffer to flash
+ * @mtd: MTD device structure
+ * @page_addr: page address/raw address
+ * @raw: without ecc or not
+ *
+ * write oob from buffer pointed by chip->oobbuf to flash
+ */
+static int spi_nand_do_write_page_oob(struct mtd_info *mtd, u32 page_addr,
+				bool raw)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+
+	return __spi_nand_do_write_page(mtd, page_addr, chip->page_size, raw);
+}
+
+
+/**
+ * spi_nand_transfer_oob - [INTERN] Transfer oob to client buffer
+ * @chip: SPI-NAND device structure
+ * @oob: oob destination address
+ * @ops: oob ops structure
+ * @len: size of oob to transfer
+ */
+static void spi_nand_transfer_oob(struct spi_nand_chip *chip, u8 *oob,
+				  struct mtd_oob_ops *ops, size_t len)
+{
+	switch (ops->mode) {
+
+	case MTD_OPS_PLACE_OOB:
+	case MTD_OPS_RAW:
+		memcpy(oob, chip->oobbuf + ops->ooboffs, len);
+		return;
+
+	case MTD_OPS_AUTO_OOB: {
+		struct nand_oobfree *free = chip->ecclayout->oobfree;
+		uint32_t boffs = 0, roffs = ops->ooboffs;
+		size_t bytes = 0;
+
+		for (; free->length && len; free++, len -= bytes) {
+			/* Read request not from offset 0? */
+			if (unlikely(roffs)) {
+				if (roffs >= free->length) {
+					roffs -= free->length;
+					continue;
+				}
+				boffs = free->offset + roffs;
+				bytes = min_t(size_t, len,
+					      (free->length - roffs));
+				roffs = 0;
+			} else {
+				bytes = min_t(size_t, len, free->length);
+				boffs = free->offset;
+			}
+			memcpy(oob, chip->oobbuf + boffs, bytes);
+			oob += bytes;
+		}
+		return;
+	}
+	default:
+		BUG();
+	}
+}
+
+/**
+ * spi_nand_fill_oob - [INTERN] Transfer client buffer to oob
+ * @chip: SPI-NAND device structure
+ * @oob: oob data buffer
+ * @len: oob data write length
+ * @ops: oob ops structure
+ */
+static void spi_nand_fill_oob(struct spi_nand_chip *chip, uint8_t *oob,
+				size_t len, struct mtd_oob_ops *ops)
+{
+	memset(chip->oobbuf, 0xff, chip->page_spare_size);
+
+	switch (ops->mode) {
+
+	case MTD_OPS_PLACE_OOB:
+	case MTD_OPS_RAW:
+		memcpy(chip->oobbuf + ops->ooboffs, oob, len);
+		return;
+
+	case MTD_OPS_AUTO_OOB: {
+		struct nand_oobfree *free = chip->ecclayout->oobfree;
+		uint32_t boffs = 0, woffs = ops->ooboffs;
+		size_t bytes = 0;
+
+		for (; free->length && len; free++, len -= bytes) {
+			/* Write request not from offset 0? */
+			if (unlikely(woffs)) {
+				if (woffs >= free->length) {
+					woffs -= free->length;
+					continue;
+				}
+				boffs = free->offset + woffs;
+				bytes = min_t(size_t, len,
+					      (free->length - woffs));
+				woffs = 0;
+			} else {
+				bytes = min_t(size_t, len, free->length);
+				boffs = free->offset;
+			}
+			memcpy(chip->oobbuf + boffs, oob, bytes);
+			oob += bytes;
+		}
+		return;
+	}
+	default:
+		BUG();
+	}
+}
+
+/**
+ * spi_nand_do_read_ops - [INTERN] Read data with ECC
+ * @mtd: MTD device structure
+ * @from: offset to read from
+ * @ops: oob ops structure
+ *
+ * Internal function. Called with chip held.
+ */
+static int spi_nand_do_read_ops(struct mtd_info *mtd, loff_t from,
+			  struct mtd_oob_ops *ops)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	int page_addr, page_offset, size;
+	int ret;
+	unsigned int corrected = 0;
+	struct mtd_ecc_stats stats;
+	unsigned int max_bitflips = 0;
+	int readlen = ops->len;
+	int oobreadlen = ops->ooblen;
+	int ooblen = ops->mode == MTD_OPS_AUTO_OOB ?
+		mtd->oobavail : mtd->oobsize;
+
+	/* Do not allow reads past end of device */
+	if (unlikely(from >= mtd->size)) {
+		pr_debug("%s: attempt to read beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+	stats = mtd->ecc_stats;
+
+	page_addr = from >> chip->page_shift;
+
+	/* for main data */
+	page_offset = from & chip->page_mask;
+	ops->retlen = 0;
+
+	/* for oob */
+	if (oobreadlen > 0) {
+		if (unlikely(ops->ooboffs >= ooblen)) {
+			pr_debug("%s: attempt to start read outside oob\n",
+					__func__);
+			return -EINVAL;
+		}
+
+		if (unlikely(ops->ooboffs + oobreadlen >
+		((mtd->size >> chip->page_shift) - (from >> chip->page_shift))
+		* ooblen)) {
+			pr_debug("%s: attempt to read beyond end of device\n",
+					__func__);
+			return -EINVAL;
+		}
+		ooblen -= ops->ooboffs;
+		ops->oobretlen = 0;
+	}
+
+	while (1) {
+		if (page_addr != chip->pagebuf || oobreadlen > 0) {
+			ret = spi_nand_do_read_page(mtd, page_addr,
+					ops->mode == MTD_OPS_RAW, &corrected);
+			if (ret) {
+				pr_debug("error %d reading page 0x%x\n",
+					ret, page_addr);
+				return ret;
+			}
+			chip->pagebuf_bitflips = corrected;
+			chip->pagebuf = page_addr;
+		}
+		max_bitflips = max(max_bitflips, chip->pagebuf_bitflips);
+		size = min(readlen, chip->page_size - page_offset);
+		memcpy(ops->datbuf + ops->retlen,
+			chip->buf + page_offset, size);
+
+		ops->retlen += size;
+		readlen -= size;
+		page_offset = 0;
+
+		if (unlikely(ops->oobbuf)) {
+			size = min(oobreadlen, ooblen);
+			spi_nand_transfer_oob(chip,
+				ops->oobbuf + ops->oobretlen, ops, size);
+
+			ops->oobretlen += size;
+			oobreadlen -= size;
+		}
+		if (!readlen)
+			break;
+
+		page_addr++;
+	}
+
+	if (mtd->ecc_stats.failed - stats.failed)
+		return -EBADMSG;
+
+	return max_bitflips;
+}
+
+/**
+ * spi_nand_do_write_ops - [INTERN] SPI-NAND write with ECC
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @ops: oob operations description structure
+ *
+ */
+static int spi_nand_do_write_ops(struct mtd_info *mtd, loff_t to,
+			 struct mtd_oob_ops *ops)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	int page_addr, page_offset, size;
+	int writelen = ops->len;
+	int oobwritelen = ops->ooblen;
+	int ret;
+	int ooblen = ops->mode == MTD_OPS_AUTO_OOB ?
+		mtd->oobavail : mtd->oobsize;
+
+	/* Do not allow reads past end of device */
+	if (unlikely(to >= mtd->size)) {
+		pr_debug("%s: attempt to write beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	page_addr = to >> chip->page_shift;
+
+	/* for main data */
+	page_offset = to & chip->page_mask;
+	ops->retlen = 0;
+
+	/* for oob */
+	if (oobwritelen > 0) {
+		/* Do not allow write past end of page */
+		if ((ops->ooboffs + oobwritelen) > ooblen) {
+			pr_debug("%s: attempt to write past end of page\n",
+					__func__);
+			return -EINVAL;
+		}
+
+		if (unlikely(ops->ooboffs >= ooblen)) {
+			pr_debug("%s: attempt to start write outside oob\n",
+					__func__);
+			return -EINVAL;
+		}
+
+		if (unlikely(ops->ooboffs + oobwritelen >
+		((mtd->size >> chip->page_shift) - (to >> chip->page_shift))
+			* ooblen)) {
+			pr_debug("%s: attempt to write beyond end of device\n",
+					__func__);
+			return -EINVAL;
+		}
+		ooblen -= ops->ooboffs;
+		ops->oobretlen = 0;
+	}
+
+	chip->pagebuf = -1;
+
+	while (1) {
+		memset(chip->buf, 0xFF,
+			chip->page_size + chip->page_spare_size);
+
+		size = min(writelen, chip->page_size - page_offset);
+		memcpy(chip->buf + page_offset,
+			ops->datbuf + ops->retlen, size);
+
+		ops->retlen += size;
+		writelen -= size;
+		page_offset = 0;
+
+		if (unlikely(ops->oobbuf)) {
+			size = min(oobwritelen, ooblen);
+
+			spi_nand_fill_oob(chip, ops->oobbuf + ops->oobretlen,
+					size, ops);
+
+			ops->oobretlen += size;
+			oobwritelen -= size;
+		}
+		ret = spi_nand_do_write_page(mtd, page_addr,
+				ops->mode == MTD_OPS_RAW);
+		if (ret) {
+			pr_debug("error %d writing page 0x%x\n",
+				ret, page_addr);
+			return ret;
+		}
+		if (!writelen)
+			break;
+		page_addr++;
+	}
+	return 0;
+}
+
+/**
+ * nand_read - [MTD Interface] SPI-NAND read
+ * @mtd: MTD device structure
+ * @from: offset to read from
+ * @len: number of bytes to read
+ * @retlen: pointer to variable to store the number of read bytes
+ * @buf: the databuffer to put data
+ *
+ */
+static int spi_nand_read(struct mtd_info *mtd, loff_t from, size_t len,
+	size_t *retlen, u_char *buf)
+{
+	struct mtd_oob_ops ops = {0};
+	int ret;
+
+	spi_nand_get_device(mtd, FL_READING);
+
+	ops.len = len;
+	ops.datbuf = buf;
+
+
+	ret = spi_nand_do_read_ops(mtd, from, &ops);
+
+	*retlen = ops.retlen;
+
+	spi_nand_release_device(mtd);
+
+	return ret;
+}
+
+/**
+ * spi_nand_write - [MTD Interface] SPI-NAND write
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @len: number of bytes to write
+ * @retlen: pointer to variable to store the number of written bytes
+ * @buf: the data to write
+ *
+ */
+static int spi_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
+	size_t *retlen, const u_char *buf)
+{
+	struct mtd_oob_ops ops = {0};
+	int ret;
+
+	spi_nand_get_device(mtd, FL_WRITING);
+
+	ops.len = len;
+	ops.datbuf = (uint8_t *)buf;
+
+
+	ret =  spi_nand_do_write_ops(mtd, to, &ops);
+
+	*retlen = ops.retlen;
+
+	spi_nand_release_device(mtd);
+
+	return ret;
+}
+
+/**
+ * spi_nand_do_read_oob - [INTERN] SPI-NAND read out-of-band
+ * @mtd: MTD device structure
+ * @from: offset to read from
+ * @ops: oob operations description structure
+ *
+ * SPI-NAND read out-of-band data from the spare area.
+ */
+static int spi_nand_do_read_oob(struct mtd_info *mtd, loff_t from,
+			  struct mtd_oob_ops *ops)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	int page_addr;
+	int corrected = 0;
+	struct mtd_ecc_stats stats;
+	int readlen = ops->ooblen;
+	int len;
+	int ret = 0;
+
+	pr_debug("%s: from = 0x%08Lx, len = %i\n",
+			__func__, (unsigned long long)from, readlen);
+
+	stats = mtd->ecc_stats;
+
+	len = ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail : mtd->oobsize;
+
+	if (unlikely(ops->ooboffs >= len)) {
+		pr_debug("%s: attempt to start read outside oob\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	/* Do not allow reads past end of device */
+	if (unlikely(from >= mtd->size ||
+		     ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
+					(from >> chip->page_shift)) * len)) {
+		pr_debug("%s: attempt to read beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	/* Shift to get page */
+	page_addr = (from >> chip->page_shift);
+	len -= ops->ooboffs;
+	ops->oobretlen = 0;
+
+	while (1) {
+		/*read data from chip*/
+		ret = spi_nand_do_read_page_oob(mtd, page_addr,
+				ops->mode == MTD_OPS_RAW, &corrected);
+		if (ret) {
+			pr_debug("error %d reading page 0x%x\n",
+				ret, page_addr);
+			return ret;
+		}
+		if (page_addr == chip->pagebuf)
+			chip->pagebuf = -1;
+
+		len = min(len, readlen);
+		spi_nand_transfer_oob(chip, ops->oobbuf + ops->oobretlen,
+					ops, len);
+
+		readlen -= len;
+		ops->oobretlen += len;
+		if (!readlen)
+			break;
+
+		page_addr++;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	if (mtd->ecc_stats.failed - stats.failed)
+		return -EBADMSG;
+
+	return  mtd->ecc_stats.corrected - stats.corrected ? -EUCLEAN : 0;
+}
+
+/**
+ * spi_nand_do_write_oob - [MTD Interface] SPI-NAND write out-of-band
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @ops: oob operation description structure
+ *
+ * SPI-NAND write out-of-band.
+ */
+static int spi_nand_do_write_oob(struct mtd_info *mtd, loff_t to,
+			     struct mtd_oob_ops *ops)
+{
+	int page_addr, len, ret;
+	struct spi_nand_chip *chip = mtd->priv;
+	int writelen = ops->ooblen;
+
+	pr_debug("%s: to = 0x%08x, len = %i\n",
+			 __func__, (unsigned int)to, (int)writelen);
+
+	len = ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail : mtd->oobsize;
+
+	/* Do not allow write past end of page */
+	if ((ops->ooboffs + writelen) > len) {
+		pr_debug("%s: attempt to write past end of page\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	if (unlikely(ops->ooboffs >= len)) {
+		pr_debug("%s: attempt to start write outside oob\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	/* Do not allow write past end of device */
+	if (unlikely(to >= mtd->size ||
+		     ops->ooboffs + writelen >
+			((mtd->size >> chip->page_shift) -
+			 (to >> chip->page_shift)) * len)) {
+		pr_debug("%s: attempt to write beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	/* Shift to get page */
+	page_addr = to >> chip->page_shift;
+	/* Invalidate the page cache, if we write to the cached page */
+	if (page_addr == chip->pagebuf)
+		chip->pagebuf = -1;
+
+	spi_nand_fill_oob(chip, ops->oobbuf, writelen, ops);
+
+	ret = spi_nand_do_write_page_oob(mtd, page_addr,
+				ops->mode == MTD_OPS_RAW);
+	if (ret) {
+		pr_debug("error %d writing page 0x%x\n",
+			ret, page_addr);
+		return ret;
+	}
+	ops->oobretlen = writelen;
+
+	return 0;
+}
+
+/**
+ * spi_nand_read_oob - [MTD Interface] SPI-NAND read data and/or out-of-band
+ * @mtd: MTD device structure
+ * @from: offset to read from
+ * @ops: oob operation description structure
+ *
+ * SPI-NAND read data and/or out-of-band data.
+ */
+static int spi_nand_read_oob(struct mtd_info *mtd, loff_t from,
+			struct mtd_oob_ops *ops)
+{
+	int ret = -ENOTSUPP;
+
+	ops->retlen = 0;
+
+	/* Do not allow reads past end of device */
+	if (ops->datbuf && (from + ops->len) > mtd->size) {
+		pr_debug("%s: attempt to read beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	spi_nand_get_device(mtd, FL_READING);
+
+	switch (ops->mode) {
+	case MTD_OPS_PLACE_OOB:
+	case MTD_OPS_AUTO_OOB:
+	case MTD_OPS_RAW:
+		break;
+
+	default:
+		goto out;
+	}
+
+	if (!ops->datbuf)
+		ret = spi_nand_do_read_oob(mtd, from, ops);
+	else
+		ret = spi_nand_do_read_ops(mtd, from, ops);
+
+out:
+	spi_nand_release_device(mtd);
+
+	return ret;
+}
+
+/**
+ * spi_nand_write_oob - [MTD Interface] SPI-NAND write data and/or out-of-band
+ * @mtd: MTD device structure
+ * @to: offset to write to
+ * @ops: oob operation description structure
+ */
+static int spi_nand_write_oob(struct mtd_info *mtd, loff_t to,
+			  struct mtd_oob_ops *ops)
+{
+	int ret = -ENOTSUPP;
+
+	ops->retlen = 0;
+
+	/* Do not allow writes past end of device */
+	if (ops->datbuf && (to + ops->len) > mtd->size) {
+		pr_debug("%s: attempt to write beyond end of device\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	spi_nand_get_device(mtd, FL_WRITING);
+
+	switch (ops->mode) {
+	case MTD_OPS_PLACE_OOB:
+	case MTD_OPS_AUTO_OOB:
+	case MTD_OPS_RAW:
+		break;
+
+	default:
+		goto out;
+	}
+
+	if (!ops->datbuf)
+		ret = spi_nand_do_write_oob(mtd, to, ops);
+	else
+		ret = spi_nand_do_write_ops(mtd, to, ops);
+
+out:
+	spi_nand_release_device(mtd);
+
+	return ret;
+}
+
+/**
+ * spi_nand_block_bad - [INTERN] Check if block at offset is bad
+ * @mtd: MTD device structure
+ * @offs: offset relative to mtd start
+ */
+static int spi_nand_block_bad(struct mtd_info *mtd, loff_t ofs)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	struct mtd_oob_ops ops = {0};
+	u32 block_addr;
+	u8 bad[2] = {0, 0};
+	u8 ret = 0;
+
+	block_addr = ofs >> chip->block_shift;
+	ops.mode = MTD_OPS_PLACE_OOB;
+	ops.ooblen = 2;
+	ops.oobbuf = bad;
+
+	ret = spi_nand_do_read_oob(mtd, block_addr << chip->block_shift, &ops);
+	if (bad[0] != 0xFF || bad[1] != 0xFF)
+		ret =  1;
+
+	return ret;
+
+}
+
+/**
+ * spi_nand_block_checkbad - [GENERIC] Check if a block is marked bad
+ * @mtd: MTD device structure
+ * @ofs: offset from device start
+ * @allowbbt: 1, if its allowed to access the bbt area
+ *
+ * Check, if the block is bad. Either by reading the bad block table or
+ * calling of the scan function.
+ */
+static int spi_nand_block_checkbad(struct mtd_info *mtd, loff_t ofs,
+			       int allowbbt)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+
+	if (!chip->bbt)
+		return spi_nand_block_bad(mtd, ofs);
+
+	/* Return info from the table */
+	return spi_nand_isbad_bbt(mtd, ofs, allowbbt);
+}
+
+/**
+ * spi_nand_block_isbad - [MTD Interface] Check if block at offset is bad
+ * @mtd: MTD device structure
+ * @offs: offset relative to mtd start
+ */
+static int spi_nand_block_isbad(struct mtd_info *mtd, loff_t offs)
+{
+	return spi_nand_block_checkbad(mtd, offs, 0);
+}
+
+/**
+ * spi_nand_block_markbad_lowlevel - mark a block bad
+ * @mtd: MTD device structure
+ * @ofs: offset from device start
+ *
+ * This function performs the generic bad block marking steps (i.e., bad
+ * block table(s) and/or marker(s)). We only allow the hardware driver to
+ * specify how to write bad block markers to OOB (chip->block_markbad).
+ *
+ * We try operations in the following order:
+ *  (1) erase the affected block, to allow OOB marker to be written cleanly
+ *  (2) write bad block marker to OOB area of affected block (unless flag
+ *      NAND_BBT_NO_OOB_BBM is present)
+ *  (3) update the BBT
+ * Note that we retain the first error encountered in (2) or (3), finish the
+ * procedures, and dump the error in the end.
+*/
+static int spi_nand_block_markbad_lowlevel(struct mtd_info *mtd, loff_t ofs)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	struct mtd_oob_ops ops = {0};
+	struct erase_info einfo = {0};
+	u32 block_addr;
+	u8 buf[2] = {0, 0};
+	int res, ret = 0;
+
+	if (!(chip->bbt_options & NAND_BBT_NO_OOB_BBM)) {
+		/*erase bad block before mark bad block*/
+		einfo.mtd = mtd;
+		einfo.addr = ofs;
+		einfo.len = 1UL << chip->block_shift;
+		spi_nand_erase(mtd, &einfo);
+
+		block_addr = ofs >> chip->block_shift;
+		ops.mode = MTD_OPS_PLACE_OOB;
+		ops.ooblen = 2;
+		ops.oobbuf = buf;
+
+		ret = spi_nand_do_write_oob(mtd,
+				block_addr << chip->block_shift, &ops);
+	}
+
+	/* Mark block bad in BBT */
+	if (chip->bbt) {
+		res = spi_nand_markbad_bbt(mtd, ofs);
+		if (!ret)
+			ret = res;
+	}
+
+	if (!ret)
+		mtd->ecc_stats.badblocks++;
+
+	return ret;
+}
+
+/**
+ * spi_nand_block_markbad - [MTD Interface] Mark block at the given offset
+ * as bad
+ * @mtd: MTD device structure
+ * @ofs: offset relative to mtd start
+ */
+static int spi_nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
+{
+	int ret;
+
+	ret = spi_nand_block_isbad(mtd, ofs);
+	if (ret) {
+		/* If it was bad already, return success and do nothing */
+		if (ret > 0)
+			return 0;
+		return ret;
+	}
+
+	return spi_nand_block_markbad_lowlevel(mtd, ofs);
+}
+
+/**
+ * __spi_nand_erase - [INTERN] erase block(s)
+ * @mtd: MTD device structure
+ * @einfo: erase instruction
+ * @allowbbt: allow to access bbt
+ *
+ * Erase one ore more blocks
+ */
+int __spi_nand_erase(struct mtd_info *mtd, struct erase_info *einfo,
+			int allowbbt)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	int page_addr, pages_per_block;
+	loff_t len;
+	u8 status;
+	int ret = 0;
+
+
+	/* check address align on block boundary */
+	if (einfo->addr & (chip->block_size - 1)) {
+		pr_debug("%s: Unaligned address\n", __func__);
+		return -EINVAL;
+	}
+
+	if (einfo->len & (chip->block_size - 1)) {
+		pr_debug("%s: Length not block aligned\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Do not allow erase past end of device */
+	if ((einfo->len + einfo->addr) > chip->size) {
+		pr_debug("%s: Erase past end of device\n", __func__);
+		return -EINVAL;
+	}
+
+	einfo->fail_addr = MTD_FAIL_ADDR_UNKNOWN;
+
+	/* Grab the lock and see if the device is available */
+	spi_nand_get_device(mtd, FL_ERASING);
+
+	pages_per_block = 1 << (chip->block_shift - chip->page_shift);
+	page_addr = einfo->addr >> chip->page_shift;
+	len = einfo->len;
+
+	einfo->state = MTD_ERASING;
+
+	while (len) {
+		/* Check if we have a bad block, we do not erase bad blocks! */
+		if (spi_nand_block_checkbad(mtd, ((loff_t) page_addr) <<
+					chip->page_shift, allowbbt)) {
+			pr_warn("%s: attempt to erase a bad block at page 0x%08x\n",
+				    __func__, page_addr);
+			einfo->state = MTD_ERASE_FAILED;
+			goto erase_exit;
+		}
+		/*
+		 * Invalidate the page cache, if we erase the block which
+		 * contains the current cached page.
+		 */
+		if (page_addr <= chip->pagebuf && chip->pagebuf <
+		    (page_addr + pages_per_block))
+			chip->pagebuf = -1;
+
+		ret = chip->write_enable(chip);
+		if (ret < 0) {
+			pr_debug("write enable command failed\n");
+			einfo->state = MTD_ERASE_FAILED;
+			goto erase_exit;
+		}
+
+		ret = chip->erase_block(chip, page_addr);
+		if (ret < 0) {
+			pr_debug("block erase command failed\n");
+			einfo->state = MTD_ERASE_FAILED;
+			einfo->fail_addr = (loff_t)page_addr
+						<< chip->page_shift;
+			goto erase_exit;
+		}
+		ret = chip->waitfunc(chip, &status);
+		if (ret < 0) {
+			pr_debug("block erase command wait failed\n");
+			einfo->state = MTD_ERASE_FAILED;
+			goto erase_exit;
+		}
+		if ((status & STATUS_E_FAIL_MASK) == STATUS_E_FAIL) {
+			pr_debug("erase block 0x%012llx failed\n",
+				((loff_t) page_addr) << chip->page_shift);
+			einfo->state = MTD_ERASE_FAILED;
+			einfo->fail_addr = (loff_t)page_addr
+						<< chip->page_shift;
+			goto erase_exit;
+		}
+
+		/* Increment page address and decrement length */
+		len -= (1ULL << chip->block_shift);
+		page_addr += pages_per_block;
+	}
+
+	einfo->state = MTD_ERASE_DONE;
+
+erase_exit:
+
+	ret = einfo->state == MTD_ERASE_DONE ? 0 : -EIO;
+
+	spi_nand_release_device(mtd);
+
+	/* Do call back function */
+	if (!ret)
+		mtd_erase_callback(einfo);
+
+	/* Return more or less happy */
+	return ret;
+}
+
+/**
+ * spi_nand_erase - [MTD Interface] erase block(s)
+ * @mtd: MTD device structure
+ * @einfo: erase instruction
+ *
+ * Erase one ore more blocks
+ */
+static int spi_nand_erase(struct mtd_info *mtd, struct erase_info *einfo)
+{
+	return __spi_nand_erase(mtd, einfo, 0);
+}
+
+/**
+ * spi_nand_sync - [MTD Interface] sync
+ * @mtd: MTD device structure
+ *
+ * Sync is actually a wait for chip ready function
+ */
+static void spi_nand_sync(struct mtd_info *mtd)
+{
+	pr_debug("spi_nand_sync: called\n");
+
+	/* Grab the lock and see if the device is available */
+	spi_nand_get_device(mtd, FL_SYNCING);
+
+	/* Release it and go back */
+	spi_nand_release_device(mtd);
+}
+
+/**
+ * spi_nand_suspend - [MTD Interface] Suspend the SPI-NAND flash
+ * @mtd: MTD device structure
+ */
+static int spi_nand_suspend(struct mtd_info *mtd)
+{
+	return spi_nand_get_device(mtd, FL_PM_SUSPENDED);
+}
+
+/**
+ * spi_nand_resume - [MTD Interface] Resume the SPI-NAND flash
+ * @mtd: MTD device structure
+ */
+static void spi_nand_resume(struct mtd_info *mtd)
+{
+	struct spi_nand_chip *this = mtd->priv;
+
+	if (this->state == FL_PM_SUSPENDED)
+		spi_nand_release_device(mtd);
+	else
+		pr_err("%s is not called in suspended state\n:", __func__);
+}
+
+/**
+ * spi_nand_scan_id_table - [INTERN] scan chip info in id table
+ * @chip: SPI-NAND device structure
+ * @id: point to manufacture id and device id
+ */
+static bool spi_nand_scan_id_table(struct spi_nand_chip *chip, u8 *id)
+{
+	struct spi_nand_flash *type = spi_nand_table;
+
+	for (; type->name; type++) {
+		if (id[0] == type->mfr_id && id[1] == type->dev_id) {
+			chip->name = type->name;
+			chip->size = type->page_size * type->pages_per_blk
+					* type->blks_per_chip;
+			chip->block_size = type->page_size
+					* type->pages_per_blk;
+			chip->page_size = type->page_size;
+			chip->page_spare_size = type->page_spare_size;
+			chip->block_shift = ilog2(chip->block_size);
+			chip->page_shift = ilog2(chip->page_size);
+			chip->page_mask = chip->page_size - 1;
+			chip->options = type->options;
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/*
+ * spi_nand_send_cmd - to process a command to send to the SPI-NAND
+ * @spi: spi device structure
+ * @cmd: command structure
+ *
+ *    Set up the command buffer to send to the SPI controller.
+ *    The command buffer has to initialized to 0.
+ */
+int spi_nand_send_cmd(struct spi_device *spi, struct spi_nand_cmd *cmd)
+{
+	struct spi_message message;
+	struct spi_transfer x[4];
+
+	spi_message_init(&message);
+	memset(x, 0, sizeof(x));
+	x[0].len = 1;
+	x[0].tx_buf = &cmd->cmd;
+	spi_message_add_tail(&x[0], &message);
+
+	if (cmd->n_addr) {
+		x[1].len = cmd->n_addr;
+		x[1].tx_buf = cmd->addr;
+		spi_message_add_tail(&x[1], &message);
+	}
+
+	if (cmd->n_tx) {
+		x[2].len = cmd->n_tx;
+		x[2].tx_nbits = cmd->tx_nbits;
+		x[2].tx_buf = cmd->tx_buf;
+		spi_message_add_tail(&x[2], &message);
+	}
+
+	if (cmd->n_rx) {
+		x[3].len = cmd->n_rx;
+		x[3].rx_nbits = cmd->rx_nbits;
+		x[3].rx_buf = cmd->rx_buf;
+		spi_message_add_tail(&x[3], &message);
+	}
+	return spi_sync(spi, &message);
+}
+
+/*
+ * spi_nand_read_status- send command 0x0f to the SPI-NAND status register value
+ * @spi: spi device structure
+ * @status: buffer to store value
+ * Description:
+ *    After read, write, or erase, the Nand device is expected to set the
+ *    busy status.
+ *    This function is to allow reading the status of the command: read,
+ *    write, and erase.
+ *    Once the status turns to be ready, the other status bits also are
+ *    valid status bits.
+ */
+static int spi_nand_read_status(struct spi_device *spi, uint8_t *status)
+{
+	struct spi_nand_cmd cmd = {0};
+	int ret;
+
+	cmd.cmd = SPINAND_CMD_READ_REG;
+	cmd.n_addr = 1;
+	cmd.addr[0] = REG_STATUS;
+	cmd.n_rx = 1;
+	cmd.rx_buf = status;
+
+	ret = spi_nand_send_cmd(spi, &cmd);
+	if (ret < 0)
+		dev_err(&spi->dev, "err: %d read status register\n", ret);
+
+	return ret;
+}
+
+/**
+ * spi_nand_get_otp- send command 0x0f to read the SPI-NAND OTP register
+ * @spi: spi device structure
+ * @opt: buffer to store value
+ * Description:
+ *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
+ *   Enable chip internal ECC, set the bit to 1
+ *   Disable chip internal ECC, clear the bit to 0
+ */
+static int spi_nand_get_otp(struct spi_device *spi, u8 *otp)
+{
+	struct spi_nand_cmd cmd = {0};
+	int ret;
+
+	cmd.cmd = SPINAND_CMD_READ_REG;
+	cmd.n_addr = 1;
+	cmd.addr[0] = REG_OTP;
+	cmd.n_rx = 1;
+	cmd.rx_buf = otp;
+
+	ret = spi_nand_send_cmd(spi, &cmd);
+	if (ret < 0)
+		dev_err(&spi->dev, "error %d get otp\n", ret);
+	return ret;
+}
+
+/**
+ * spi_nand_set_otp- send command 0x1f to write the SPI-NAND OTP register
+ * @spi: spi device structure
+ * @status: buffer stored value
+ * Description:
+ *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
+ *   Enable chip internal ECC, set the bit to 1
+ *   Disable chip internal ECC, clear the bit to 0
+ */
+static int spi_nand_set_otp(struct spi_device *spi, u8 *otp)
+{
+	int ret;
+	struct spi_nand_cmd cmd = {0};
+
+	cmd.cmd = SPINAND_CMD_WRITE_REG,
+	cmd.n_addr = 1,
+	cmd.addr[0] = REG_OTP,
+	cmd.n_tx = 1,
+	cmd.tx_buf = otp,
+
+	ret = spi_nand_send_cmd(spi, &cmd);
+	if (ret < 0)
+		dev_err(&spi->dev, "error %d set otp\n", ret);
+
+	return ret;
+}
+
+/**
+ * spi_nand_enable_ecc- enable internal ECC
+ * @chip: SPI-NAND device structure
+ * Description:
+ *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
+ *   Enable chip internal ECC, set the bit to 1
+ *   Disable chip internal ECC, clear the bit to 0
+ */
+static int spi_nand_enable_ecc(struct spi_nand_chip *chip)
+{
+	struct spi_device *spi = chip->spi;
+	int ret;
+	u8 otp = 0;
+
+	ret = spi_nand_get_otp(spi, &otp);
+	if (ret < 0)
+		return ret;
+
+	if ((otp & OTP_ECC_MASK) == OTP_ECC_ENABLE)
+		return 0;
+
+	otp |= OTP_ECC_ENABLE;
+	ret = spi_nand_set_otp(spi, &otp);
+	if (ret < 0)
+		return ret;
+	return spi_nand_get_otp(spi, &otp);
+}
+
+/**
+ * spi_nand_disable_ecc- disable internal ECC
+ * @chip: SPI-NAND device structure
+ * Description:
+ *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
+ *   Enable chip internal ECC, set the bit to 1
+ *   Disable chip internal ECC, clear the bit to 0
+ */
+static int spi_nand_disable_ecc(struct spi_nand_chip *chip)
+{
+	struct spi_device *spi = chip->spi;
+	int ret;
+	u8 otp = 0;
+
+	ret = spi_nand_get_otp(spi, &otp);
+	if (ret < 0)
+		return ret;
+
+	if ((otp & OTP_ECC_MASK) == OTP_ECC_ENABLE) {
+		otp &= ~OTP_ECC_ENABLE;
+		ret = spi_nand_set_otp(spi, &otp);
+		if (ret < 0)
+			return ret;
+		return spi_nand_get_otp(spi, &otp);
+	} else
+		return 0;
+}
+
+/**
+ * spi_nand_write_enable- send command 0x06 to enable write or erase the
+ * Nand cells
+ * @chip: SPI-NAND device structure
+ * Description:
+ *   Before write and erase the Nand cells, the write enable has to be set.
+ *   After the write or erase, the write enable bit is automatically
+ *   cleared (status register bit 2)
+ *   Set the bit 2 of the status register has the same effect
+ */
+static int spi_nand_write_enable(struct spi_nand_chip *chip)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_WR_ENABLE;
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/*
+ * spi_nand_read_from_cache- send command 0x13 to read data from Nand to cache
+ * @chip: SPI-NAND device structure
+ * @page_addr: page to read
+ */
+static int spi_nand_read_page_to_cache(struct spi_nand_chip *chip,
+					u32 page_addr)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_READ;
+	cmd.n_addr = 3;
+	cmd.addr[0] = (u8)(page_addr >> 16);
+	cmd.addr[1] = (u8)(page_addr >> 8);
+	cmd.addr[2] = (u8)page_addr;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/*
+ * spi_nand_read_from_cache- send command 0x03 to read out the data from the
+ * cache register
+ * Description:
+ *   The read can specify 1 to (page size + spare size) bytes of data read at
+ *   the corresponding locations.
+ *   No tRd delay.
+ */
+int spi_nand_read_from_cache(struct spi_nand_chip *chip, u32 page_addr,
+		u32 column, size_t len, u8 *rbuf)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_READ_RDM;
+	cmd.n_addr = 3;
+	cmd.addr[0] = (u8)(column >> 8);
+	if (chip->options & SPINAND_NEED_PLANE_SELECT)
+		cmd.addr[0] |= (u8)(((page_addr >>
+			(chip->block_shift - chip->page_shift)) & 0x1) << 4);
+	cmd.addr[1] = (u8)column;
+	cmd.addr[2] = 0;
+	cmd.n_rx = len;
+	cmd.rx_buf = rbuf;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/*
+ * spi_nand_read_from_cache_x2- send command 0x3b to read out the data from the
+ * cache register
+ * Description:
+ *   The read can specify 1 to (page size + spare size) bytes of data read at
+ *   the corresponding locations.
+ *   No tRd delay.
+ */
+int spi_nand_read_from_cache_x2(struct spi_nand_chip *chip, u32 page_addr,
+		u32 column, size_t len, u8 *rbuf)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_READ_CACHE_X2;
+	cmd.n_addr = 3;
+	cmd.addr[0] = (u8)(column >> 8);
+	if (chip->options & SPINAND_NEED_PLANE_SELECT)
+		cmd.addr[0] |= (u8)(((page_addr >>
+			(chip->block_shift - chip->page_shift)) & 0x1) << 4);
+	cmd.addr[1] = (u8)column;
+	cmd.addr[2] = 0;
+	cmd.n_rx = len;
+	cmd.rx_nbits = SPI_NBITS_DUAL;
+	cmd.rx_buf = rbuf;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/*
+ * spi_nand_read_from_cache_x4- send command 0x6b to read out the data from the
+ * cache register
+ * Description:
+ *   The read can specify 1 to (page size + spare size) bytes of data read at
+ *   the corresponding locations.
+ *   No tRd delay.
+ */
+int spi_nand_read_from_cache_x4(struct spi_nand_chip *chip, u32 page_addr,
+		u32 column, size_t len, u8 *rbuf)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_READ_CACHE_X4;
+	cmd.n_addr = 3;
+	cmd.addr[0] = (u8)(column >> 8);
+	if (chip->options & SPINAND_NEED_PLANE_SELECT)
+		cmd.addr[0] |= (u8)(((page_addr >>
+			(chip->block_shift - chip->page_shift)) & 0x1) << 4);
+	cmd.addr[1] = (u8)column;
+	cmd.addr[2] = 0;
+	cmd.n_rx = len;
+	cmd.rx_nbits = SPI_NBITS_QUAD;
+	cmd.rx_buf = rbuf;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/*
+ * spi_nand_read_from_cache_snor_protocol- send command 0x03 to read out the
+ * data from the cache register, 0x03 command protocol is same as SPI NOR
+ * read command
+ * Description:
+ *   The read can specify 1 to (page size + spare size) bytes of data read at
+ *   the corresponding locations.
+ *   No tRd delay.
+ */
+int spi_nand_read_from_cache_snor_protocol(struct spi_nand_chip *chip,
+		u32 page_addr, u32 column, size_t len, u8 *rbuf)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_READ_RDM;
+	cmd.n_addr = 3;
+	cmd.addr[0] = 0;
+	cmd.addr[1] = (u8)(column >> 8);
+	if (chip->options & SPINAND_NEED_PLANE_SELECT)
+		cmd.addr[1] |= (u8)(((page_addr >>
+			(chip->block_shift - chip->page_shift)) & 0x1) << 4);
+	cmd.addr[2] = (u8)column;
+	cmd.n_rx = len;
+	cmd.rx_buf = rbuf;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+
+/*
+ * spi_nand_program_data_to_cache--to write a page to cache
+ * @chip: SPI-NAND device structure
+ * @page_addr: page to write
+ * @column: the location to write to the cache
+ * @len: number of bytes to write
+ * wrbuf: buffer held @len bytes
+ *
+ * Description:
+ *   The write command used here is 0x02--indicating that the cache is
+ *   cleared first.
+ *   Since it is writing the data to cache, there is no tPROG time.
+ */
+static int spi_nand_program_data_to_cache(struct spi_nand_chip *chip,
+		u32 page_addr, u32 column, size_t len, u8 *wbuf)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_PROG_PAGE_CLRCACHE;
+	cmd.n_addr = 2;
+	cmd.addr[0] = (u8)(column >> 8);
+	if (chip->options & SPINAND_NEED_PLANE_SELECT)
+		cmd.addr[0] |= (u8)(((page_addr >>
+			(chip->block_shift - chip->page_shift)) & 0x1) << 4);
+	cmd.addr[1] = (u8)column;
+	cmd.n_tx = len;
+	cmd.tx_buf = wbuf;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/**
+ * spi_nand_program_execute--to write a page from cache to the Nand array
+ * @chip: SPI-NAND device structure
+ * @page_addr: the physical page location to write the page.
+ *
+ * Description:
+ *   The write command used here is 0x10--indicating the cache is writing to
+ *   the Nand array.
+ *   Need to wait for tPROG time to finish the transaction.
+ */
+static int spi_nand_program_execute(struct spi_nand_chip *chip, u32 page_addr)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_PROG_PAGE_EXC;
+	cmd.n_addr = 3;
+	cmd.addr[0] = (u8)(page_addr >> 16);
+	cmd.addr[1] = (u8)(page_addr >> 8);
+	cmd.addr[2] = (u8)page_addr;
+
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+
+/**
+ * spi_nand_erase_block_erase--to erase a block
+ * @chip: SPI-NAND device structure
+ * @page_addr: the page to erase.
+ *
+ * Description:
+ *   The command used here is 0xd8--indicating an erase command to erase
+ *   one block
+ *   Need to wait for tERS.
+ */
+static int spi_nand_erase_block(struct spi_nand_chip *chip,
+					u32 page_addr)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_ERASE_BLK;
+	cmd.n_addr = 3;
+	cmd.addr[0] = (u8)(page_addr >> 16);
+	cmd.addr[1] = (u8)(page_addr >> 8);
+	cmd.addr[2] = (u8)page_addr;
+
+	return spi_nand_send_cmd(spi, &cmd);
+}
+
+/**
+ * spi_nand_wait - [DEFAULT] wait until the command is done
+ * @chip: SPI-NAND device structure
+ * @s: buffer to store status register(can be NULL)
+ *
+ * Wait for command done. This applies to erase and program only. Erase can
+ * take up to 400ms and program up to 20ms.
+ */
+static int spi_nand_wait(struct spi_nand_chip *chip, u8 *s)
+{
+	unsigned long timeo = jiffies;
+	u8 status, state = chip->state;
+	int ret = -ETIMEDOUT;
+
+	if (state == FL_ERASING)
+		timeo += msecs_to_jiffies(400);
+	else
+		timeo += msecs_to_jiffies(20);
+
+	while (time_before(jiffies, timeo)) {
+		spi_nand_read_status(chip->spi, &status);
+		if ((status & STATUS_OIP_MASK) == STATUS_READY) {
+			ret = 0;
+			goto out;
+		}
+		cond_resched();
+	}
+out:
+	if (s)
+		*s = status;
+
+	return ret;
+}
+
+
+/*
+ * spi_nand_reset- send RESET command "0xff" to the SPI-NAND.
+ * @chip: SPI-NAND device structure
+ */
+static int spi_nand_reset(struct spi_nand_chip *chip)
+{
+	struct spi_nand_cmd cmd = {0};
+	struct spi_device *spi = chip->spi;
+
+	cmd.cmd = SPINAND_CMD_RESET;
+
+	if (spi_nand_send_cmd(spi, &cmd) < 0)
+		pr_err("spi_nand reset failed!\n");
+
+	/* elapse 1ms before issuing any other command */
+	udelay(1000);
+
+	return 0;
+}
+
+
+/**
+ * spi_nand_lock_block- send write register 0x1f command to the lock/unlock device
+ * @spi: spi device structure
+ * @lock: value to set to block lock register
+ *
+ * Description:
+ *    After power up, all the Nand blocks are locked.  This function allows
+ *    one to unlock the blocks, and so it can be written or erased.
+ */
+static int spi_nand_lock_block(struct spi_device *spi, u8 lock)
+{
+	struct spi_nand_cmd cmd = {0};
+	int ret;
+
+	cmd.cmd = SPINAND_CMD_WRITE_REG;
+	cmd.n_addr = 1;
+	cmd.addr[0] = REG_BLOCK_LOCK;
+	cmd.n_tx = 1;
+	cmd.tx_buf = &lock;
+
+	ret = spi_nand_send_cmd(spi, &cmd);
+	if (ret < 0)
+		dev_err(&spi->dev, "error %d lock block\n", ret);
+
+	return ret;
+}
+
+static u16 onfi_crc16(u16 crc, u8 const *p, size_t len)
+{
+	int i;
+
+	while (len--) {
+		crc ^= *p++ << 8;
+		for (i = 0; i < 8; i++)
+			crc = (crc << 1) ^ ((crc & 0x8000) ? 0x8005 : 0);
+	}
+
+	return crc;
+}
+
+/* Sanitize ONFI strings so we can safely print them */
+static void sanitize_string(uint8_t *s, size_t len)
+{
+	ssize_t i;
+
+	/* Null terminate */
+	s[len - 1] = 0;
+
+	/* Remove non printable chars */
+	for (i = 0; i < len - 1; i++) {
+		if (s[i] < ' ' || s[i] > 127)
+			s[i] = '?';
+	}
+
+	/* Remove trailing spaces */
+	strim(s);
+}
+
+/*
+ * Check if the SPI-NAND chip is ONFI compliant,
+ * returns 1 if it is, 0 otherwise.
+ */
+static bool spi_nand_detect_onfi(struct spi_nand_chip *chip)
+{
+	struct spi_device *spi = chip->spi;
+	struct spi_nand_onfi_params *p;
+	char *buffer;
+	bool ret = true;
+	u8 otp;
+	int i;
+
+	/*FIXME buffer size*/
+	buffer = kmalloc(256*3, GFP_KERNEL);
+	otp = OTP_ENABLE;
+	spi_nand_set_otp(spi, &otp);
+	chip->load_page(chip, 0x01);
+	chip->waitfunc(chip, NULL);
+	spi_nand_read_from_cache(chip, 0x01, 0x00, 256*3, buffer);
+	otp = OTP_ECC_ENABLE;
+	spi_nand_set_otp(spi, &otp);
+
+	p = (struct spi_nand_onfi_params *)buffer;
+	for (i = 0; i < 3; i++, p++) {
+		if (p->sig[0] != 'O' || p->sig[1] != 'N' ||
+				p->sig[2] != 'F' || p->sig[3] != 'I')
+			continue;
+		if (onfi_crc16(ONFI_CRC_BASE, (uint8_t *)p, 254) ==
+				le16_to_cpu(p->crc))
+			break;
+	}
+	if (i == 3) {
+		pr_err("Could not find valid ONFI parameter page; aborting\n");
+		ret = false;
+		goto out;
+	}
+
+	memcpy(&chip->onfi_params, p, sizeof(*p));
+
+	p = &chip->onfi_params;
+
+	sanitize_string(p->manufacturer, sizeof(p->manufacturer));
+	sanitize_string(p->model, sizeof(p->model));
+
+	chip->name = p->model;
+	chip->size = le32_to_cpu(p->byte_per_page) *
+			le32_to_cpu(p->pages_per_block) *
+			le32_to_cpu(p->blocks_per_lun) * p->lun_count;
+	chip->block_size = le32_to_cpu(p->byte_per_page) *
+			le32_to_cpu(p->pages_per_block);
+	chip->page_size = le32_to_cpu(p->byte_per_page);
+	chip->page_spare_size = le16_to_cpu(p->spare_bytes_per_page);
+	chip->block_shift = ilog2(chip->block_size);
+	chip->page_shift = ilog2(chip->page_size);
+	chip->page_mask = chip->page_size - 1;
+	chip->bits_per_cell = p->bits_per_cell;
+	/*FIXME need to find a way to read options from ONFI table*/
+	chip->options = SPINAND_NEED_PLANE_SELECT;
+	if (p->ecc_bits != 0xff) {
+		chip->ecc_strength_ds = p->ecc_bits;
+		chip->ecc_step_ds = 512;
+	}
+
+out:
+	kfree(buffer);
+	return ret;
+}
+
+static void spi_nand_set_defaults(struct spi_nand_chip *chip)
+{
+	struct spi_device *spi = chip->spi;
+
+	if (spi->mode & SPI_RX_QUAD)
+		chip->read_cache = spi_nand_read_from_cache_x4;
+	else if (spi->mode & SPI_RX_DUAL)
+		chip->read_cache = spi_nand_read_from_cache_x2;
+	else
+		chip->read_cache = spi_nand_read_from_cache;
+
+	if (!chip->reset)
+		chip->reset = spi_nand_reset;
+	if (!chip->erase_block)
+		chip->erase_block = spi_nand_erase_block;
+	if (!chip->load_page)
+		chip->load_page = spi_nand_read_page_to_cache;
+	if (!chip->store_cache)
+		chip->store_cache = spi_nand_program_data_to_cache;
+	if (!chip->write_page)
+		chip->write_page = spi_nand_program_execute;
+	if (!chip->write_enable)
+		chip->write_enable = spi_nand_write_enable;
+	if (!chip->waitfunc)
+		chip->waitfunc = spi_nand_wait;
+	if (!chip->enable_ecc)
+		chip->enable_ecc = spi_nand_enable_ecc;
+	if (!chip->disable_ecc)
+		chip->disable_ecc = spi_nand_disable_ecc;
+}
+
+static int spi_nand_check(struct spi_nand_chip *chip)
+{
+	if (!chip->reset)
+		return -ENODEV;
+	if (!chip->read_id)
+		return -ENODEV;
+	if (!chip->load_page)
+		return -ENODEV;
+	if (!chip->read_cache)
+		return -ENODEV;
+	if (!chip->store_cache)
+		return -ENODEV;
+	if (!chip->write_page)
+		return -ENODEV;
+	if (!chip->erase_block)
+		return -ENODEV;
+	if (!chip->waitfunc)
+		return -ENODEV;
+	if (!chip->write_enable)
+		return -ENODEV;
+	if (!chip->get_ecc_status)
+		return -ENODEV;
+	if (!chip->enable_ecc)
+		return -ENODEV;
+	if (!chip->disable_ecc)
+		return -ENODEV;
+	if (!chip->ecclayout)
+		return -ENODEV;
+	return 0;
+}
+
+/**
+ * spi_nand_scan_ident - [SPI-NAND Interface] Scan for the SPI-NAND device
+ * @mtd: MTD device structure
+ *
+ * This is the first phase of the normal spi_nand_scan() function. It reads the
+ * flash ID and sets up MTD fields accordingly.
+ *
+ */
+int spi_nand_scan_ident(struct mtd_info *mtd)
+{
+	int ret;
+	u8 id[SPINAND_MAX_ID_LEN] = {0};
+	struct spi_nand_chip *chip = mtd->priv;
+
+	spi_nand_set_defaults(chip);
+	chip->reset(chip);
+	chip->read_id(chip, id);
+	if (id[0] == 0 && id[1] == 0) {
+		pr_err("SPINAND: read id error! 0x%02x, 0x%02x!\n",
+			id[0], id[1]);
+		return -ENODEV;
+	}
+
+	if (spi_nand_scan_id_table(chip, id))
+		goto ident_done;
+	pr_info("SPI-NAND type mfr_id: %x, dev_id: %x is not in id table.\n",
+				id[0], id[1]);
+
+	if (spi_nand_detect_onfi(chip))
+		goto ident_done;
+
+	return -ENODEV;
+
+ident_done:
+	pr_info("SPI-NAND: %s is found.\n", chip->name);
+
+	chip->mfr_id = id[0];
+	chip->dev_id = id[1];
+
+	chip->buf = kzalloc(chip->page_size + chip->page_spare_size,
+				GFP_KERNEL);
+	if (!chip->buf)
+		return -ENOMEM;
+
+	chip->oobbuf = chip->buf + chip->page_size;
+
+	ret = spi_nand_lock_block(chip->spi, BL_ALL_UNLOCKED);
+	ret = chip->enable_ecc(chip);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(spi_nand_scan_ident);
+
+/**
+ * spi_nand_scan_tail - [SPI-NAND Interface] Scan for the SPI-NAND device
+ * @mtd: MTD device structure
+ *
+ * This is the second phase of the normal spi_nand_scan() function. It fills out
+ * all the uninitialized function pointers with the defaults.
+ */
+int spi_nand_scan_tail(struct mtd_info *mtd)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+	int ret;
+
+	ret = spi_nand_check(chip);
+	if (ret)
+		return ret;
+	/* Initialize state */
+	chip->state = FL_READY;
+	/* Invalidate the pagebuffer reference */
+	chip->pagebuf = -1;
+	chip->bbt_options |= NAND_BBT_USE_FLASH;
+	chip->badblockpos = NAND_LARGE_BADBLOCK_POS;
+
+	init_waitqueue_head(&chip->wq);
+	spin_lock_init(&chip->chip_lock);
+
+	mtd->name = chip->name;
+	mtd->size = chip->size;
+	mtd->erasesize = chip->block_size;
+	mtd->writesize = chip->page_size;
+	mtd->writebufsize = mtd->writesize;
+	mtd->oobsize = chip->page_spare_size;
+	mtd->owner = THIS_MODULE;
+	mtd->type = MTD_NANDFLASH;
+	mtd->flags = MTD_CAP_NANDFLASH;
+	if (!mtd->ecc_strength)
+		mtd->ecc_strength = chip->ecc_strength_ds ?
+					chip->ecc_strength_ds : 1;
+
+	mtd->ecclayout = chip->ecclayout;
+	mtd->oobsize = chip->page_spare_size;
+	mtd->oobavail = chip->ecclayout->oobavail;
+	mtd->_erase = spi_nand_erase;
+	mtd->_point = NULL;
+	mtd->_unpoint = NULL;
+	mtd->_read = spi_nand_read;
+	mtd->_write = spi_nand_write;
+	mtd->_read_oob = spi_nand_read_oob;
+	mtd->_write_oob = spi_nand_write_oob;
+	mtd->_sync = spi_nand_sync;
+	mtd->_lock = NULL;
+	mtd->_unlock = NULL;
+	mtd->_suspend = spi_nand_suspend;
+	mtd->_resume = spi_nand_resume;
+	mtd->_block_isbad = spi_nand_block_isbad;
+	mtd->_block_markbad = spi_nand_block_markbad;
+
+	/* Build bad block table */
+	return spi_nand_default_bbt(mtd);
+}
+EXPORT_SYMBOL_GPL(spi_nand_scan_tail);
+
+/**
+ * spi_nand_scan_ident_release - [SPI-NAND Interface] Free resources
+ * applied by spi_nand_scan_ident
+ * @mtd: MTD device structure
+ */
+int spi_nand_scan_ident_release(struct mtd_info *mtd)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+
+	kfree(chip->buf);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spi_nand_scan_ident_release);
+
+/**
+ * spi_nand_scan_tail_release - [SPI-NAND Interface] Free resources
+ * applied by spi_nand_scan_tail
+ * @mtd: MTD device structure
+ */
+int spi_nand_scan_tail_release(struct mtd_info *mtd)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spi_nand_scan_tail_release);
+
+/**
+ * spi_nand_release - [SPI-NAND Interface] Free resources held by the SPI-NAND
+ * device
+ * @mtd: MTD device structure
+ */
+int spi_nand_release(struct mtd_info *mtd)
+{
+	struct spi_nand_chip *chip = mtd->priv;
+
+	mtd_device_unregister(mtd);
+	kfree(chip->buf);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spi_nand_release);
+
+MODULE_DESCRIPTION("SPI NAND framework");
+MODULE_AUTHOR("Peter Pan<peterpandong@micron.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mtd/spi-nand/spi-nand-bbt.c b/drivers/mtd/spi-nand/spi-nand-bbt.c
new file mode 100644
index 0000000..1a29156
--- /dev/null
+++ b/drivers/mtd/spi-nand/spi-nand-bbt.c
@@ -0,0 +1,1279 @@
+/*
+ *  drivers/mtd/spi_nand_bbt.c
+ *
+ *  Overview:
+ *   Bad block table support for the SPI-NAND driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file is derived from nand_base.c
+ *
+ * TODO:
+ *   share BBT code with parallel nand
+ */
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/bbm.h>
+#include <linux/mtd/spi-nand.h>
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/export.h>
+#include <linux/string.h>
+
+#define BBT_BLOCK_GOOD		0x00
+#define BBT_BLOCK_WORN		0x01
+#define BBT_BLOCK_RESERVED	0x02
+#define BBT_BLOCK_FACTORY_BAD	0x03
+
+#define BBT_ENTRY_MASK		0x03
+#define BBT_ENTRY_SHIFT		2
+
+static int spi_nand_update_bbt(struct mtd_info *mtd, loff_t offs);
+
+static inline uint8_t bbt_get_entry(struct spi_nand_chip *chip, int block)
+{
+	uint8_t entry = chip->bbt[block >> BBT_ENTRY_SHIFT];
+
+	entry >>= (block & BBT_ENTRY_MASK) * 2;
+	return entry & BBT_ENTRY_MASK;
+}
+
+static inline void bbt_mark_entry(struct spi_nand_chip *chip, int block,
+		uint8_t mark)
+{
+	uint8_t msk = (mark & BBT_ENTRY_MASK) << ((block & BBT_ENTRY_MASK) * 2);
+
+	chip->bbt[block >> BBT_ENTRY_SHIFT] |= msk;
+}
+
+static int check_pattern_no_oob(uint8_t *buf, struct nand_bbt_descr *td)
+{
+	if (memcmp(buf, td->pattern, td->len))
+		return -1;
+	return 0;
+}
+
+/**
+ * check_pattern - [GENERIC] check if a pattern is in the buffer
+ * @buf: the buffer to search
+ * @len: the length of buffer to search
+ * @paglen: the pagelength
+ * @td: search pattern descriptor
+ *
+ * Check for a pattern at the given place. Used to search bad block tables and
+ * good / bad block identifiers.
+ */
+static int check_pattern(uint8_t *buf, int len, int paglen,
+			struct nand_bbt_descr *td)
+{
+	if (td->options & NAND_BBT_NO_OOB)
+		return check_pattern_no_oob(buf, td);
+
+	/* Compare the pattern */
+	if (memcmp(buf + paglen + td->offs, td->pattern, td->len))
+		return -1;
+
+	return 0;
+}
+
+/**
+ * check_short_pattern - [GENERIC] check if a pattern is in the buffer
+ * @buf: the buffer to search
+ * @td:	search pattern descriptor
+ *
+ * Check for a pattern at the given place. Used to search bad block tables and
+ * good / bad block identifiers. Same as check_pattern, but no optional empty
+ * check.
+ */
+static int check_short_pattern(uint8_t *buf, struct nand_bbt_descr *td)
+{
+	/* Compare the pattern */
+	if (memcmp(buf + td->offs, td->pattern, td->len))
+		return -1;
+	return 0;
+}
+
+/**
+ * add_marker_len - compute the length of the marker in data area
+ * @td: BBT descriptor used for computation
+ *
+ * The length will be 0 if the marker is located in OOB area.
+ */
+static u32 add_marker_len(struct nand_bbt_descr *td)
+{
+	u32 len;
+
+	if (!(td->options & NAND_BBT_NO_OOB))
+		return 0;
+
+	len = td->len;
+	if (td->options & NAND_BBT_VERSION)
+		len++;
+	return len;
+}
+
+/**
+ * read_bbt - [GENERIC] Read the bad block table starting from page
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @page: the starting page
+ * @num: the number of bbt descriptors to read
+ * @td: the bbt describtion table
+ * @offs: block number offset in the table
+ *
+ * Read the bad block table starting from page.
+ */
+static int read_bbt(struct mtd_info *mtd, uint8_t *buf, int page, int num,
+		struct nand_bbt_descr *td, int offs)
+{
+	int res, ret = 0, i, j, act = 0;
+	struct spi_nand_chip *this = mtd->priv;
+	size_t retlen, len, totlen;
+	loff_t from;
+	int bits = td->options & NAND_BBT_NRBITS_MSK;
+	uint8_t msk = (uint8_t)((1 << bits) - 1);
+	u32 marker_len;
+	int reserved_block_code = td->reserved_block_code;
+
+	totlen = (num * bits) >> 3;
+	marker_len = add_marker_len(td);
+	from = ((loff_t)page) << this->page_shift;
+
+	while (totlen) {
+		len = min(totlen, (size_t)(1 << this->block_shift));
+		if (marker_len) {
+			/*
+			 * In case the BBT marker is not in the OOB area it
+			 * will be just in the first page.
+			 */
+			len -= marker_len;
+			from += marker_len;
+			marker_len = 0;
+		}
+		res = mtd_read(mtd, from, len, &retlen, buf);
+		if (res < 0) {
+			if (mtd_is_eccerr(res)) {
+				pr_info("spi_nand_bbt: ECC error in BBT at 0x%012llx\n",
+					from & ~mtd->writesize);
+				return res;
+			} else if (mtd_is_bitflip(res)) {
+				pr_info("spi_nand_bbt: corrected error in BBT at 0x%012llx\n",
+					from & ~mtd->writesize);
+				ret = res;
+			} else {
+				pr_info("spi_nand_bbt: error reading BBT\n");
+				return res;
+			}
+		}
+
+		/* Analyse data */
+		for (i = 0; i < len; i++) {
+			uint8_t dat = buf[i];
+
+			for (j = 0; j < 8; j += bits, act++) {
+				uint8_t tmp = (dat >> j) & msk;
+
+				if (tmp == msk)
+					continue;
+				if (reserved_block_code &&
+					(tmp == reserved_block_code)) {
+					pr_info("spi_nand_read_bbt: reserved block at 0x%012llx\n",
+						 (loff_t)(offs + act) <<
+						 this->block_shift);
+					bbt_mark_entry(this, offs + act,
+							BBT_BLOCK_RESERVED);
+					mtd->ecc_stats.bbtblocks++;
+					continue;
+				}
+				/*
+				 * Leave it for now, if it's matured we can
+				 * move this message to pr_debug.
+				 */
+				pr_info("spi_nand_read_bbt: bad block at 0x%012llx\n",
+					 (loff_t)(offs + act) <<
+					 this->block_shift);
+				/* Factory marked bad or worn out? */
+				if (tmp == 0)
+					bbt_mark_entry(this, offs + act,
+							BBT_BLOCK_FACTORY_BAD);
+				else
+					bbt_mark_entry(this, offs + act,
+							BBT_BLOCK_WORN);
+				mtd->ecc_stats.badblocks++;
+			}
+		}
+		totlen -= len;
+		from += len;
+	}
+	return ret;
+}
+
+/**
+ * read_abs_bbt - [GENERIC] Read the bad block table starting at a given page
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @td: descriptor for the bad block table
+ * @chip: read the table for a specific chip, -1 read all chips; applies only if
+ *        NAND_BBT_PERCHIP option is set
+ *
+ * Read the bad block table for all chips starting at a given page. We assume
+ * that the bbt bits are in consecutive order.
+ */
+static int read_abs_bbt(struct mtd_info *mtd, uint8_t *buf,
+			struct nand_bbt_descr *td, int chip)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int res = 0;
+
+	res = read_bbt(mtd, buf, td->pages[0],
+			mtd->size >> this->block_shift, td, 0);
+	if (res)
+		return res;
+
+	return 0;
+}
+
+/* BBT marker is in the first page, no OOB */
+static int scan_read_data(struct mtd_info *mtd, uint8_t *buf, loff_t offs,
+			 struct nand_bbt_descr *td)
+{
+	size_t retlen;
+	size_t len;
+
+	len = td->len;
+	if (td->options & NAND_BBT_VERSION)
+		len++;
+
+	return mtd_read(mtd, offs, len, &retlen, buf);
+}
+
+/**
+ * scan_read_oob - [GENERIC] Scan data+OOB region to buffer
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @offs: offset at which to scan
+ * @len: length of data region to read
+ *
+ * Scan read data from data+OOB. May traverse multiple pages, interleaving
+ * page,OOB,page,OOB,... in buf. Completes transfer and returns the "strongest"
+ * ECC condition (error or bitflip). May quit on the first (non-ECC) error.
+ */
+static int scan_read_oob(struct mtd_info *mtd, uint8_t *buf, loff_t offs,
+			 size_t len)
+{
+	struct mtd_oob_ops ops;
+	int res, ret = 0;
+
+	ops.mode = MTD_OPS_PLACE_OOB;
+	ops.ooboffs = 0;
+	ops.ooblen = mtd->oobsize;
+
+	while (len > 0) {
+		ops.datbuf = buf;
+		ops.len = min_t(size_t, len, mtd->writesize);
+		ops.oobbuf = buf + ops.len;
+
+		res = mtd_read_oob(mtd, offs, &ops);
+		if (res) {
+			if (!mtd_is_bitflip_or_eccerr(res))
+				return res;
+			else if (mtd_is_eccerr(res) || !ret)
+				ret = res;
+		}
+
+		buf += mtd->oobsize + mtd->writesize;
+		len -= mtd->writesize;
+		offs += mtd->writesize;
+	}
+	return ret;
+}
+
+static int scan_read(struct mtd_info *mtd, uint8_t *buf, loff_t offs,
+			 size_t len, struct nand_bbt_descr *td)
+{
+	if (td->options & NAND_BBT_NO_OOB)
+		return scan_read_data(mtd, buf, offs, td);
+	else
+		return scan_read_oob(mtd, buf, offs, len);
+}
+
+/* Scan write data with oob to flash */
+static int scan_write_bbt(struct mtd_info *mtd, loff_t offs, size_t len,
+			  uint8_t *buf, uint8_t *oob)
+{
+	struct mtd_oob_ops ops;
+
+	ops.mode = MTD_OPS_PLACE_OOB;
+	ops.ooboffs = 0;
+	ops.ooblen = mtd->oobsize;
+	ops.datbuf = buf;
+	ops.oobbuf = oob;
+	ops.len = len;
+
+	return mtd_write_oob(mtd, offs, &ops);
+}
+
+static u32 bbt_get_ver_offs(struct mtd_info *mtd, struct nand_bbt_descr *td)
+{
+	u32 ver_offs = td->veroffs;
+
+	if (!(td->options & NAND_BBT_NO_OOB))
+		ver_offs += mtd->writesize;
+	return ver_offs;
+}
+
+/**
+ * read_abs_bbts - [GENERIC] Read the bad block table(s) for all chips starting at a given page
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @td: descriptor for the bad block table
+ * @md:	descriptor for the bad block table mirror
+ *
+ * Read the bad block table(s) for all chips starting at a given page. We
+ * assume that the bbt bits are in consecutive order.
+ */
+static void read_abs_bbts(struct mtd_info *mtd, uint8_t *buf,
+			  struct nand_bbt_descr *td, struct nand_bbt_descr *md)
+{
+	struct spi_nand_chip *this = mtd->priv;
+
+	/* Read the primary version, if available */
+	if (td->options & NAND_BBT_VERSION) {
+		scan_read(mtd, buf, (loff_t)td->pages[0] << this->page_shift,
+			      mtd->writesize, td);
+		td->version[0] = buf[bbt_get_ver_offs(mtd, td)];
+		pr_info("Bad block table at page %d, version 0x%02X\n",
+			 td->pages[0], td->version[0]);
+	}
+
+	/* Read the mirror version, if available */
+	if (md && (md->options & NAND_BBT_VERSION)) {
+		scan_read(mtd, buf, (loff_t)md->pages[0] << this->page_shift,
+			      mtd->writesize, md);
+		md->version[0] = buf[bbt_get_ver_offs(mtd, md)];
+		pr_info("Bad block table at page %d, version 0x%02X\n",
+			 md->pages[0], md->version[0]);
+	}
+}
+
+/* Scan a given block partially */
+static int scan_block_fast(struct mtd_info *mtd, struct nand_bbt_descr *bd,
+			   loff_t offs, uint8_t *buf, int numpages)
+{
+	struct mtd_oob_ops ops;
+	int j, ret;
+
+	ops.ooblen = mtd->oobsize;
+	ops.oobbuf = buf;
+	ops.ooboffs = 0;
+	ops.datbuf = NULL;
+	ops.mode = MTD_OPS_PLACE_OOB;
+
+	for (j = 0; j < numpages; j++) {
+		/*
+		 * Read the full oob until read_oob is fixed to handle single
+		 * byte reads for 16 bit buswidth.
+		 */
+		ret = mtd_read_oob(mtd, offs, &ops);
+		/* Ignore ECC errors when checking for BBM */
+		if (ret && !mtd_is_bitflip_or_eccerr(ret))
+			return ret;
+
+		if (check_short_pattern(buf, bd))
+			return 1;
+
+		offs += mtd->writesize;
+	}
+	return 0;
+}
+
+/**
+ * create_bbt - [GENERIC] Create a bad block table by scanning the device
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @bd: descriptor for the good/bad block search pattern
+ * @chip: create the table for a specific chip, -1 read all chips; applies only
+ *        if NAND_BBT_PERCHIP option is set
+ *
+ * Create a bad block table by scanning the device for the given good/bad block
+ * identify pattern.
+ */
+static int create_bbt(struct mtd_info *mtd, uint8_t *buf,
+	struct nand_bbt_descr *bd, int chip)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int i, numblocks, numpages;
+	int startblock;
+	loff_t from;
+
+	pr_info("Scanning device for bad blocks\n");
+
+	if (bd->options & NAND_BBT_SCAN2NDPAGE)
+		numpages = 2;
+	else
+		numpages = 1;
+
+	if (chip == -1) {
+		numblocks = mtd->size >> this->block_shift;
+		startblock = 0;
+		from = 0;
+	} else {
+		numblocks = this->size >> this->block_shift;
+		startblock = chip * numblocks;
+		numblocks += startblock;
+		from = (loff_t)startblock << this->block_shift;
+	}
+
+	if (this->bbt_options & NAND_BBT_SCANLASTPAGE)
+		from += mtd->erasesize - (mtd->writesize * numpages);
+
+	for (i = startblock; i < numblocks; i++) {
+		int ret;
+
+		BUG_ON(bd->options & NAND_BBT_NO_OOB);
+
+		ret = scan_block_fast(mtd, bd, from, buf, numpages);
+		if (ret < 0)
+			return ret;
+
+		if (ret) {
+			bbt_mark_entry(this, i, BBT_BLOCK_FACTORY_BAD);
+			pr_warn("Bad eraseblock %d at 0x%012llx\n",
+				i, (unsigned long long)from);
+			mtd->ecc_stats.badblocks++;
+		}
+
+		from += (1 << this->block_shift);
+	}
+	return 0;
+}
+
+/**
+ * search_bbt - [GENERIC] scan the device for a specific bad block table
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @td: descriptor for the bad block table
+ *
+ * Read the bad block table by searching for a given ident pattern. Search is
+ * preformed either from the beginning up or from the end of the device
+ * downwards. The search starts always at the start of a block. If the option
+ * NAND_BBT_PERCHIP is given, each chip is searched for a bbt, which contains
+ * the bad block information of this chip. This is necessary to provide support
+ * for certain DOC devices.
+ *
+ * The bbt ident pattern resides in the oob area of the first page in a block.
+ */
+static int search_bbt(struct mtd_info *mtd, uint8_t *buf,
+			struct nand_bbt_descr *td)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int i, chips;
+	int startblock, block, dir;
+	int scanlen = mtd->writesize + mtd->oobsize;
+	int bbtblocks;
+	int blocktopage = this->block_shift - this->page_shift;
+
+	/* Search direction top -> down? */
+	if (td->options & NAND_BBT_LASTBLOCK) {
+		startblock = (mtd->size >> this->block_shift) - 1;
+		dir = -1;
+	} else {
+		startblock = 0;
+		dir = 1;
+	}
+
+	chips = 1;
+	bbtblocks = mtd->size >> this->block_shift;
+
+	for (i = 0; i < chips; i++) {
+		/* Reset version information */
+		td->version[i] = 0;
+		td->pages[i] = -1;
+		/* Scan the maximum number of blocks */
+		for (block = 0; block < td->maxblocks; block++) {
+
+			int actblock = startblock + dir * block;
+			loff_t offs = (loff_t)actblock << this->block_shift;
+
+			/* Read first page */
+			scan_read(mtd, buf, offs, mtd->writesize, td);
+			if (!check_pattern(buf, scanlen, mtd->writesize, td)) {
+				td->pages[i] = actblock << blocktopage;
+				if (td->options & NAND_BBT_VERSION) {
+					offs = bbt_get_ver_offs(mtd, td);
+					td->version[i] = buf[offs];
+				}
+				break;
+			}
+		}
+		startblock += this->size >> this->block_shift;
+	}
+	/* Check, if we found a bbt for each requested chip */
+	for (i = 0; i < chips; i++) {
+		if (td->pages[i] == -1)
+			pr_warn("Bad block table not found for chip %d\n", i);
+		else
+			pr_info("Bad block table found at page %d, version 0x%02X\n",
+				td->pages[i], td->version[i]);
+	}
+	return 0;
+}
+
+/**
+ * search_read_bbts - [GENERIC] scan the device for bad block table(s)
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @td: descriptor for the bad block table
+ * @md: descriptor for the bad block table mirror
+ *
+ * Search and read the bad block table(s).
+ */
+static void search_read_bbts(struct mtd_info *mtd, uint8_t *buf,
+			     struct nand_bbt_descr *td,
+			     struct nand_bbt_descr *md)
+{
+	/* Search the primary table */
+	search_bbt(mtd, buf, td);
+
+	/* Search the mirror table */
+	if (md)
+		search_bbt(mtd, buf, md);
+}
+
+/**
+ * write_bbt - [GENERIC] (Re)write the bad block table
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @td: descriptor for the bad block table
+ * @md: descriptor for the bad block table mirror
+ * @chipsel: selector for a specific chip, -1 for all
+ *
+ * (Re)write the bad block table.
+ */
+static int write_bbt(struct mtd_info *mtd, uint8_t *buf,
+		     struct nand_bbt_descr *td, struct nand_bbt_descr *md,
+		     int chipsel)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	struct erase_info einfo;
+	int i, res, chip = 0;
+	int bits, startblock, dir, page, offs, numblocks, sft, sftmsk;
+	int nrchips, pageoffs, ooboffs;
+	uint8_t msk[4];
+	uint8_t rcode = td->reserved_block_code;
+	size_t retlen, len = 0;
+	loff_t to;
+	struct mtd_oob_ops ops;
+
+	ops.ooblen = mtd->oobsize;
+	ops.ooboffs = 0;
+	ops.datbuf = NULL;
+	ops.mode = MTD_OPS_PLACE_OOB;
+
+	if (!rcode)
+		rcode = 0xff;
+	numblocks = (int)(mtd->size >> this->block_shift);
+	nrchips = 1;
+
+	/* Loop through the chips */
+	for (; chip < nrchips; chip++) {
+		/*
+		 * There was already a version of the table, reuse the page
+		 * This applies for absolute placement too, as we have the
+		 * page nr. in td->pages.
+		 */
+		if (td->pages[chip] != -1) {
+			page = td->pages[chip];
+			goto write;
+		}
+
+		/*
+		 * Automatic placement of the bad block table. Search direction
+		 * top -> down?
+		 */
+		if (td->options & NAND_BBT_LASTBLOCK) {
+			startblock = numblocks * (chip + 1) - 1;
+			dir = -1;
+		} else {
+			startblock = chip * numblocks;
+			dir = 1;
+		}
+
+		for (i = 0; i < td->maxblocks; i++) {
+			int block = startblock + dir * i;
+			/* Check, if the block is bad */
+			switch (bbt_get_entry(this, block)) {
+			case BBT_BLOCK_WORN:
+			case BBT_BLOCK_FACTORY_BAD:
+				continue;
+			}
+			page = block <<
+				(this->block_shift - this->page_shift);
+			/* Check, if the block is used by the mirror table */
+			if (!md || md->pages[chip] != page)
+				goto write;
+		}
+		pr_err("No space left to write bad block table\n");
+		return -ENOSPC;
+write:
+
+		/* Set up shift count and masks for the flash table */
+		bits = td->options & NAND_BBT_NRBITS_MSK;
+		msk[2] = ~rcode;
+		switch (bits) {
+		case 1:
+			sft = 3; sftmsk = 0x07; msk[0] = 0x00; msk[1] = 0x01;
+			msk[3] = 0x01;
+			break;
+		case 2:
+			sft = 2; sftmsk = 0x06; msk[0] = 0x00; msk[1] = 0x01;
+			msk[3] = 0x03;
+			break;
+		case 4:
+			sft = 1; sftmsk = 0x04; msk[0] = 0x00; msk[1] = 0x0C;
+			msk[3] = 0x0f;
+			break;
+		case 8:
+			sft = 0; sftmsk = 0x00; msk[0] = 0x00; msk[1] = 0x0F;
+			msk[3] = 0xff;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		to = ((loff_t)page) << this->page_shift;
+
+		/* Must we save the block contents? */
+		if (td->options & NAND_BBT_SAVECONTENT) {
+			/* Make it block aligned */
+			to &= ~((loff_t)((1 << this->block_shift) - 1));
+			len = 1 << this->block_shift;
+			res = mtd_read(mtd, to, len, &retlen, buf);
+			if (res < 0) {
+				if (retlen != len) {
+					pr_info("spi_nand_bbt: error reading block ");
+					pr_info("for writing the bad block table\n");
+					return res;
+				}
+				pr_warn("spi_nand_bbt: ECC error while reading ");
+				pr_warn("block for writing bad block table\n");
+			}
+			/* Read oob data */
+			ops.ooblen = (len >> this->page_shift) * mtd->oobsize;
+			ops.oobbuf = &buf[len];
+			res = mtd_read_oob(mtd, to + mtd->writesize, &ops);
+			if (res < 0 || ops.oobretlen != ops.ooblen)
+				goto outerr;
+
+			/* Calc the byte offset in the buffer */
+			pageoffs = page - (int)(to >> this->page_shift);
+			offs = pageoffs << this->page_shift;
+			/* Preset the bbt area with 0xff */
+			memset(&buf[offs], 0xff, (size_t)(numblocks >> sft));
+			ooboffs = len + (pageoffs * mtd->oobsize);
+
+		} else if (td->options & NAND_BBT_NO_OOB) {
+			ooboffs = 0;
+			offs = td->len;
+			/* The version byte */
+			if (td->options & NAND_BBT_VERSION)
+				offs++;
+			/* Calc length */
+			len = (size_t)(numblocks >> sft);
+			len += offs;
+			/* Make it page aligned! */
+			len = ALIGN(len, mtd->writesize);
+			/* Preset the buffer with 0xff */
+			memset(buf, 0xff, len);
+			/* Pattern is located at the begin of first page */
+			memcpy(buf, td->pattern, td->len);
+		} else {
+			/* Calc length */
+			len = (size_t)(numblocks >> sft);
+			/* Make it page aligned! */
+			len = ALIGN(len, mtd->writesize);
+			/* Preset the buffer with 0xff */
+			memset(buf, 0xff, len +
+			       (len >> this->page_shift) * mtd->oobsize);
+			offs = 0;
+			ooboffs = len;
+			/* Pattern is located in oob area of first page */
+			memcpy(&buf[ooboffs + td->offs], td->pattern, td->len);
+		}
+
+		if (td->options & NAND_BBT_VERSION)
+			buf[ooboffs + td->veroffs] = td->version[chip];
+
+		/* Walk through the memory table */
+		for (i = 0; i < numblocks; i++) {
+			uint8_t dat;
+			int sftcnt = (i << (3 - sft)) & sftmsk;
+
+			dat = bbt_get_entry(this, chip * numblocks + i);
+			/* Do not store the reserved bbt blocks! */
+			buf[offs + (i >> sft)] &= ~(msk[dat] << sftcnt);
+		}
+
+		memset(&einfo, 0, sizeof(einfo));
+		einfo.mtd = mtd;
+		einfo.addr = to;
+		einfo.len = 1 << this->block_shift;
+		res = __spi_nand_erase(mtd, &einfo, 1);
+		if (res < 0)
+			goto outerr;
+
+		res = scan_write_bbt(mtd, to, len, buf,
+				td->options & NAND_BBT_NO_OOB ? NULL :
+				&buf[len]);
+		if (res < 0)
+			goto outerr;
+
+		pr_info("Bad block table written to 0x%012llx, version 0x%02X\n",
+			 (unsigned long long)to, td->version[chip]);
+
+		/* Mark it as used */
+		td->pages[chip] = page;
+	}
+	return 0;
+
+ outerr:
+	pr_warn("spi_nand_bbt: error while writing bad block table %d\n", res);
+	return res;
+}
+
+/**
+ * spi_nand_memory_bbt - [GENERIC] create a memory based bad block table
+ * @mtd: MTD device structure
+ * @bd: descriptor for the good/bad block search pattern
+ *
+ * The function creates a memory based bbt by scanning the device for
+ * manufacturer / software marked good / bad blocks.
+ */
+static inline int spi_nand_memory_bbt(struct mtd_info *mtd,
+				struct nand_bbt_descr *bd)
+{
+	struct spi_nand_chip *this = mtd->priv;
+
+	return create_bbt(mtd, this->buf, bd, -1);
+}
+
+/**
+ * check_create - [GENERIC] create and write bbt(s) if necessary
+ * @mtd: MTD device structure
+ * @buf: temporary buffer
+ * @bd: descriptor for the good/bad block search pattern
+ *
+ * The function checks the results of the previous call to read_bbt and creates
+ * / updates the bbt(s) if necessary. Creation is necessary if no bbt was found
+ * for the chip/device. Update is necessary if one of the tables is missing or
+ * the version nr. of one table is less than the other.
+ */
+static int check_create(struct mtd_info *mtd, uint8_t *buf,
+			struct nand_bbt_descr *bd)
+{
+	int i, chips, writeops, create, chipsel, res, res2;
+	struct spi_nand_chip *this = mtd->priv;
+	struct nand_bbt_descr *td = this->bbt_td;
+	struct nand_bbt_descr *md = this->bbt_md;
+	struct nand_bbt_descr *rd, *rd2;
+
+	chips = 1;
+
+	for (i = 0; i < chips; i++) {
+		writeops = 0;
+		create = 0;
+		rd = NULL;
+		rd2 = NULL;
+		res = res2 = 0;
+		/* Per chip or per device? */
+		chipsel = -1;
+		/* Mirrored table available? */
+		if (md) {
+			if (td->pages[i] == -1 && md->pages[i] == -1) {
+				create = 1;
+				writeops = 0x03;
+			} else if (td->pages[i] == -1) {
+				rd = md;
+				writeops = 0x01;
+			} else if (md->pages[i] == -1) {
+				rd = td;
+				writeops = 0x02;
+			} else if (td->version[i] == md->version[i]) {
+				rd = td;
+				if (!(td->options & NAND_BBT_VERSION))
+					rd2 = md;
+			} else if (((int8_t)(td->version[i] - md->version[i]))
+					> 0) {
+				rd = td;
+				writeops = 0x02;
+			} else {
+				rd = md;
+				writeops = 0x01;
+			}
+		} else {
+			if (td->pages[i] == -1) {
+				create = 1;
+				writeops = 0x01;
+			} else {
+				rd = td;
+			}
+		}
+
+		if (create) {
+			/* Create the bad block table by scanning the device? */
+			if (!(td->options & NAND_BBT_CREATE))
+				continue;
+
+			/* Create the table in memory by scanning the chip(s) */
+			if (!(this->bbt_options & NAND_BBT_CREATE_EMPTY))
+				create_bbt(mtd, buf, bd, chipsel);
+
+			td->version[i] = 1;
+			if (md)
+				md->version[i] = 1;
+		}
+
+		/* Read back first? */
+		if (rd) {
+			res = read_abs_bbt(mtd, buf, rd, chipsel);
+			if (mtd_is_eccerr(res)) {
+				/* Mark table as invalid */
+				rd->pages[i] = -1;
+				rd->version[i] = 0;
+				i--;
+				continue;
+			}
+		}
+		/* If they weren't versioned, read both */
+		if (rd2) {
+			res2 = read_abs_bbt(mtd, buf, rd2, chipsel);
+			if (mtd_is_eccerr(res2)) {
+				/* Mark table as invalid */
+				rd2->pages[i] = -1;
+				rd2->version[i] = 0;
+				i--;
+				continue;
+			}
+		}
+
+		/* Scrub the flash table(s)? */
+		if (mtd_is_bitflip(res) || mtd_is_bitflip(res2))
+			writeops = 0x03;
+
+		/* Update version numbers before writing */
+		if (md) {
+			td->version[i] = max(td->version[i], md->version[i]);
+			md->version[i] = td->version[i];
+		}
+
+		/* Write the bad block table to the device? */
+		if ((writeops & 0x01) && (td->options & NAND_BBT_WRITE)) {
+			res = write_bbt(mtd, buf, td, md, chipsel);
+			if (res < 0)
+				return res;
+		}
+
+		/* Write the mirror bad block table to the device? */
+		if ((writeops & 0x02) && md && (md->options & NAND_BBT_WRITE)) {
+			res = write_bbt(mtd, buf, md, td, chipsel);
+			if (res < 0)
+				return res;
+		}
+	}
+	return 0;
+}
+
+/**
+ * mark_bbt_regions - [GENERIC] mark the bad block table regions
+ * @mtd: MTD device structure
+ * @td: bad block table descriptor
+ *
+ * The bad block table regions are marked as "bad" to prevent accidental
+ * erasures / writes. The regions are identified by the mark 0x02.
+ */
+static void mark_bbt_region(struct mtd_info *mtd, struct nand_bbt_descr *td)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int i, j, chips, block, nrblocks, update;
+	uint8_t oldval;
+
+	chips = 1;
+	nrblocks = (int)(mtd->size >> this->block_shift);
+
+	for (i = 0; i < chips; i++) {
+		if ((td->options & NAND_BBT_ABSPAGE) ||
+		    !(td->options & NAND_BBT_WRITE)) {
+			if (td->pages[i] == -1)
+				continue;
+			block = td->pages[i] >>
+				(this->block_shift - this->page_shift);
+			oldval = bbt_get_entry(this, block);
+			bbt_mark_entry(this, block, BBT_BLOCK_RESERVED);
+			if ((oldval != BBT_BLOCK_RESERVED) &&
+					td->reserved_block_code)
+				spi_nand_update_bbt(mtd, (loff_t)block <<
+						this->block_shift);
+			continue;
+		}
+		update = 0;
+		if (td->options & NAND_BBT_LASTBLOCK)
+			block = ((i + 1) * nrblocks) - td->maxblocks;
+		else
+			block = i * nrblocks;
+		for (j = 0; j < td->maxblocks; j++) {
+			oldval = bbt_get_entry(this, block);
+			bbt_mark_entry(this, block, BBT_BLOCK_RESERVED);
+			if (oldval != BBT_BLOCK_RESERVED)
+				update = 1;
+			block++;
+		}
+		/*
+		 * If we want reserved blocks to be recorded to flash, and some
+		 * new ones have been marked, then we need to update the stored
+		 * bbts.  This should only happen once.
+		 */
+		if (update && td->reserved_block_code)
+			spi_nand_update_bbt(mtd, (loff_t)(block - 1) <<
+					this->block_shift);
+	}
+}
+
+/**
+ * verify_bbt_descr - verify the bad block description
+ * @mtd: MTD device structure
+ * @bd: the table to verify
+ *
+ * This functions performs a few sanity checks on the bad block description
+ * table.
+ */
+static void verify_bbt_descr(struct mtd_info *mtd, struct nand_bbt_descr *bd)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	u32 pattern_len;
+	u32 bits;
+	u32 table_size;
+
+	if (!bd)
+		return;
+
+	pattern_len = bd->len;
+	bits = bd->options & NAND_BBT_NRBITS_MSK;
+
+	BUG_ON((this->bbt_options & NAND_BBT_NO_OOB) &&
+			!(this->bbt_options & NAND_BBT_USE_FLASH));
+	BUG_ON(!bits);
+
+	if (bd->options & NAND_BBT_VERSION)
+		pattern_len++;
+
+	if (bd->options & NAND_BBT_NO_OOB) {
+		BUG_ON(!(this->bbt_options & NAND_BBT_USE_FLASH));
+		BUG_ON(!(this->bbt_options & NAND_BBT_NO_OOB));
+		BUG_ON(bd->offs);
+		if (bd->options & NAND_BBT_VERSION)
+			BUG_ON(bd->veroffs != bd->len);
+		BUG_ON(bd->options & NAND_BBT_SAVECONTENT);
+	}
+
+	table_size = mtd->size >> this->block_shift;
+	table_size >>= 3;
+	table_size *= bits;
+	if (bd->options & NAND_BBT_NO_OOB)
+		table_size += pattern_len;
+	BUG_ON(table_size > (1 << this->block_shift));
+}
+
+/**
+ * spi_nand_scan_bbt - [SPI-NAND Interface] scan, find, read and maybe create
+ * bad block table(s)
+ * @mtd: MTD device structure
+ * @bd: descriptor for the good/bad block search pattern
+ *
+ * The function checks, if a bad block table(s) is/are already available. If
+ * not it scans the device for manufacturer marked good / bad blocks and writes
+ * the bad block table(s) to the selected place.
+ *
+ * The bad block table memory is allocated here. It must be freed by calling
+ * the spi_nand_free_bbt function.
+ */
+int spi_nand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int len, res = 0;
+	uint8_t *buf;
+	struct nand_bbt_descr *td = this->bbt_td;
+	struct nand_bbt_descr *md = this->bbt_md;
+
+	len = mtd->size >> (this->block_shift + 2);
+	/*
+	 * Allocate memory (2bit per block) and clear the memory bad block
+	 * table.
+	 */
+	this->bbt = kzalloc(len, GFP_KERNEL);
+	if (!this->bbt)
+		return -ENOMEM;
+
+	/*
+	 * If no primary table decriptor is given, scan the device to build a
+	 * memory based bad block table.
+	 */
+	if (!td) {
+		res = spi_nand_memory_bbt(mtd, bd);
+		if (res) {
+			pr_err("spi_nand_bbt: can't scan flash and build the RAM-based BBT\n");
+			kfree(this->bbt);
+			this->bbt = NULL;
+		}
+		return res;
+	}
+	verify_bbt_descr(mtd, td);
+	verify_bbt_descr(mtd, md);
+
+	/* Allocate a temporary buffer for one eraseblock incl. oob */
+	len = (1 << this->block_shift);
+	len += (len >> this->page_shift) * mtd->oobsize;
+	buf = vmalloc(len);
+	if (!buf) {
+		kfree(this->bbt);
+		this->bbt = NULL;
+		return -ENOMEM;
+	}
+
+	/* Is the bbt at a given page? */
+	if (td->options & NAND_BBT_ABSPAGE) {
+		read_abs_bbts(mtd, buf, td, md);
+	} else {
+		/* Search the bad block table using a pattern in oob */
+		search_read_bbts(mtd, buf, td, md);
+	}
+
+	res = check_create(mtd, buf, bd);
+
+	/* Prevent the bbt regions from erasing / writing */
+	mark_bbt_region(mtd, td);
+	if (md)
+		mark_bbt_region(mtd, md);
+
+	vfree(buf);
+	return res;
+}
+EXPORT_SYMBOL(spi_nand_scan_bbt);
+
+/**
+ * spi_nand_update_bbt - update bad block table(s)
+ * @mtd: MTD device structure
+ * @offs: the offset of the newly marked block
+ *
+ * The function updates the bad block table(s).
+ */
+static int spi_nand_update_bbt(struct mtd_info *mtd, loff_t offs)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int len, res = 0;
+	int chip, chipsel;
+	uint8_t *buf;
+	struct nand_bbt_descr *td = this->bbt_td;
+	struct nand_bbt_descr *md = this->bbt_md;
+
+	if (!this->bbt || !td)
+		return -EINVAL;
+
+	/* Allocate a temporary buffer for one eraseblock incl. oob */
+	len = (1 << this->block_shift);
+	len += (len >> this->page_shift) * mtd->oobsize;
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	chip = 0;
+	chipsel = -1;
+
+	td->version[chip]++;
+	if (md)
+		md->version[chip]++;
+
+	/* Write the bad block table to the device? */
+	if (td->options & NAND_BBT_WRITE) {
+		res = write_bbt(mtd, buf, td, md, chipsel);
+		if (res < 0)
+			goto out;
+	}
+	/* Write the mirror bad block table to the device? */
+	if (md && (md->options & NAND_BBT_WRITE))
+		res = write_bbt(mtd, buf, md, td, chipsel);
+
+ out:
+	kfree(buf);
+	return res;
+}
+
+/*
+ * Define some generic bad / good block scan pattern which are used
+ * while scanning a device for factory marked good / bad blocks.
+ */
+static uint8_t scan_ff_pattern[] = { 0xff, 0xff };
+
+/* Generic flash bbt descriptors */
+static uint8_t bbt_pattern[] = {'B', 'b', 't', '0' };
+static uint8_t mirror_pattern[] = {'1', 't', 'b', 'B' };
+
+static struct nand_bbt_descr bbt_main_descr = {
+	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
+		| NAND_BBT_2BIT | NAND_BBT_VERSION,
+	.offs =	8,
+	.len = 4,
+	.veroffs = 12,
+	.maxblocks = NAND_BBT_SCAN_MAXBLOCKS,
+	.pattern = bbt_pattern
+};
+
+static struct nand_bbt_descr bbt_mirror_descr = {
+	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
+		| NAND_BBT_2BIT | NAND_BBT_VERSION,
+	.offs =	8,
+	.len = 4,
+	.veroffs = 12,
+	.maxblocks = NAND_BBT_SCAN_MAXBLOCKS,
+	.pattern = mirror_pattern
+};
+
+static struct nand_bbt_descr bbt_main_no_oob_descr = {
+	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
+		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_NO_OOB,
+	.len = 4,
+	.veroffs = 4,
+	.maxblocks = NAND_BBT_SCAN_MAXBLOCKS,
+	.pattern = bbt_pattern
+};
+
+static struct nand_bbt_descr bbt_mirror_no_oob_descr = {
+	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
+		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_NO_OOB,
+	.len = 4,
+	.veroffs = 4,
+	.maxblocks = NAND_BBT_SCAN_MAXBLOCKS,
+	.pattern = mirror_pattern
+};
+
+#define BADBLOCK_SCAN_MASK (~NAND_BBT_NO_OOB)
+/**
+ * spi_nand_create_badblock_pattern - [INTERN] Creates a BBT descriptor structure
+ * @this: SPI-NAND chip to create descriptor for
+ *
+ * This function allocates and initializes a nand_bbt_descr for BBM detection
+ * based on the properties of @this. The new descriptor is stored in
+ * this->badblock_pattern. Thus, this->badblock_pattern should be NULL when
+ * passed to this function.
+ */
+static int spi_nand_create_badblock_pattern(struct spi_nand_chip *this)
+{
+	struct nand_bbt_descr *bd;
+
+	if (this->badblock_pattern) {
+		pr_warn("Bad block pattern already allocated; not replacing\n");
+		return -EINVAL;
+	}
+	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
+	if (!bd)
+		return -ENOMEM;
+	bd->options = this->bbt_options & BADBLOCK_SCAN_MASK;
+	bd->offs = this->badblockpos;
+	bd->len = 1;
+	bd->pattern = scan_ff_pattern;
+	bd->options |= NAND_BBT_DYNAMICSTRUCT;
+	this->badblock_pattern = bd;
+	return 0;
+}
+
+/**
+ * spi_nand_default_bbt - [SPI-NAND Interface] Select a default bad block table for the device
+ * @mtd: MTD device structure
+ *
+ * This function selects the default bad block table support for the device and
+ * calls the spi_nand_scan_bbt function.
+ */
+int spi_nand_default_bbt(struct mtd_info *mtd)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int ret;
+
+	/* Is a flash based bad block table requested? */
+	if (this->bbt_options & NAND_BBT_USE_FLASH) {
+		/* Use the default pattern descriptors */
+		if (!this->bbt_td) {
+			if (this->bbt_options & NAND_BBT_NO_OOB) {
+				this->bbt_td = &bbt_main_no_oob_descr;
+				this->bbt_md = &bbt_mirror_no_oob_descr;
+			} else {
+				this->bbt_td = &bbt_main_descr;
+				this->bbt_md = &bbt_mirror_descr;
+			}
+		}
+	} else {
+		this->bbt_td = NULL;
+		this->bbt_md = NULL;
+	}
+
+	if (!this->badblock_pattern) {
+		ret = spi_nand_create_badblock_pattern(this);
+		if (ret)
+			return ret;
+	}
+
+	return spi_nand_scan_bbt(mtd, this->badblock_pattern);
+}
+
+/**
+ * spi_nand_isbad_bbt - [SPI-NAND Interface] Check if a block is bad
+ * @mtd: MTD device structure
+ * @offs: offset in the device
+ * @allowbbt: allow access to bad block table region
+ */
+int spi_nand_isbad_bbt(struct mtd_info *mtd, loff_t offs, int allowbbt)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int block, res;
+
+	block = (int)(offs >> this->block_shift);
+	res = bbt_get_entry(this, block);
+
+	pr_debug("%s: bbt info for offs 0x%08x: (block %d) 0x%02x\n",
+			__func__, (unsigned int)offs, block, res);
+
+	switch (res) {
+	case BBT_BLOCK_GOOD:
+		return 0;
+	case BBT_BLOCK_WORN:
+		return 1;
+	case BBT_BLOCK_RESERVED:
+		return allowbbt ? 0 : 1;
+	}
+	return 1;
+}
+
+/**
+ * spi_nand_markbad_bbt - [SPI-NAND Interface] Mark a block bad in the BBT
+ * @mtd: MTD device structure
+ * @offs: offset of the bad block
+ */
+int spi_nand_markbad_bbt(struct mtd_info *mtd, loff_t offs)
+{
+	struct spi_nand_chip *this = mtd->priv;
+	int block, ret = 0;
+
+	block = (int)(offs >> this->block_shift);
+
+	/* Mark bad block in memory */
+	bbt_mark_entry(this, block, BBT_BLOCK_WORN);
+
+	/* Update flash-based bad block table */
+	if (this->bbt_options & NAND_BBT_USE_FLASH)
+		ret = spi_nand_update_bbt(mtd, offs);
+
+	return ret;
+}
diff --git a/include/linux/mtd/spi-nand.h b/include/linux/mtd/spi-nand.h
new file mode 100644
index 0000000..e29fd5d
--- /dev/null
+++ b/include/linux/mtd/spi-nand.h
@@ -0,0 +1,317 @@
+/*-
+ *
+ * Copyright (c) 2009-2014 Micron Technology, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Peter Pan <peterpandong@micron.com>
+ *
+ * based on mt29f_spinand.h
+ */
+#ifndef __LINUX_MTD_SPI_NAND_H
+#define __LINUX_MTD_SPI_NAND_H
+
+#include <linux/wait.h>
+#include <linux/spinlock.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/flashchip.h>
+
+
+/*
+ * Standard SPI-NAND flash commands
+ */
+#define SPINAND_CMD_READ			0x13
+#define SPINAND_CMD_READ_RDM			0x03
+#define SPINAND_CMD_PROG_PAGE_CLRCACHE		0x02
+#define SPINAND_CMD_PROG_PAGE			0x84
+#define SPINAND_CMD_PROG_PAGE_EXC		0x10
+#define SPINAND_CMD_ERASE_BLK			0xd8
+#define SPINAND_CMD_WR_ENABLE			0x06
+#define SPINAND_CMD_WR_DISABLE			0x04
+#define SPINAND_CMD_READ_ID			0x9f
+#define SPINAND_CMD_RESET			0xff
+#define SPINAND_CMD_READ_REG			0x0f
+#define SPINAND_CMD_WRITE_REG			0x1f
+#define SPINAND_CMD_READ_CACHE_X2		0x3b
+#define SPINAND_CMD_READ_CACHE_X4		0x6b
+
+/* feature registers */
+#define REG_BLOCK_LOCK			0xa0
+#define REG_OTP				0xb0
+#define REG_STATUS			0xc0/* timing */
+
+/* status */
+#define STATUS_OIP_MASK			0x01
+#define STATUS_READY			(0 << 0)
+#define STATUS_BUSY			(1 << 0)
+
+#define STATUS_E_FAIL_MASK		0x04
+#define STATUS_E_FAIL			(1 << 2)
+
+#define STATUS_P_FAIL_MASK		0x08
+#define STATUS_P_FAIL			(1 << 3)
+
+
+/*OTP register defines*/
+#define OTP_ECC_MASK			0X10
+#define OTP_ECC_ENABLE			0x10
+#define OTP_ENABLE			0x40
+
+
+/* block lock */
+#define BL_ALL_LOCKED      0x38
+#define BL_1_2_LOCKED      0x30
+#define BL_1_4_LOCKED      0x28
+#define BL_1_8_LOCKED      0x20
+#define BL_1_16_LOCKED     0x18
+#define BL_1_32_LOCKED     0x10
+#define BL_1_64_LOCKED     0x08
+#define BL_ALL_UNLOCKED    0
+
+
+
+#define SPI_NAND_MT29F_ECC_MASK		3
+#define SPI_NAND_MT29F_ECC_CORRECTED	1
+#define SPI_NAND_MT29F_ECC_UNCORR	2
+#define SPI_NAND_MT29F_ECC_RESERVED	3
+#define SPI_NAND_MT29F_ECC_SHIFT	4
+
+
+#define SPI_NAND_GD5F_ECC_MASK		7
+#define SPI_NAND_GD5F_ECC_UNCORR	7
+#define SPI_NAND_GD5F_ECC_SHIFT		4
+
+
+
+
+struct spi_nand_onfi_params {
+	/* rev info and features block */
+	/* 'O' 'N' 'F' 'I'  */
+	u8		sig[4];				/*0-3*/
+	__le16		revision;			/*4-5*/
+	__le16		features;			/*6-7*/
+	__le16		opt_cmd;			/*8-9*/
+	u8		reserved0[22];			/*10-31*/
+
+	/* manufacturer information block */
+	char		manufacturer[12];		/*32-43*/
+	char		model[20];			/*44-63*/
+	u8		mfr_id;				/*64*/
+	__le16		date_code;			/*65-66*/
+	u8		reserved1[13];			/*67-79*/
+
+	/* memory organization block */
+	__le32		byte_per_page;			/*80-83*/
+	__le16		spare_bytes_per_page;		/*84*85*/
+	__le32		data_bytes_per_ppage;		/*86-89*/
+	__le16		spare_bytes_per_ppage;		/*90-91*/
+	__le32		pages_per_block;		/*92-95*/
+	__le32		blocks_per_lun;			/*96-99*/
+	u8		lun_count;			/*100*/
+	u8		addr_cycles;			/*101*/
+	u8		bits_per_cell;			/*102*/
+	__le16		bb_per_lun;			/*103-104*/
+	__le16		block_endurance;		/*105-106*/
+	u8		guaranteed_good_blocks;		/*107*/
+	__le16		guaranteed_block_endurance;	/*108-109*/
+	u8		programs_per_page;		/*110*/
+	u8		ppage_attr;			/*111*/
+	u8		ecc_bits;			/*112*/
+	u8		interleaved_bits;		/*113*/
+	u8		interleaved_ops;		/*114*/
+	u8		reserved2[13];			/*115-127*/
+
+	/* electrical parameter block */
+	u8		io_pin_capacitance_max;		/*128*/
+	__le16		timing_mode;			/*129-130*/
+	__le16		program_cache_timing_mode;	/*131-132*/
+	__le16		t_prog;				/*133-134*/
+	__le16		t_bers;				/*135-136*/
+	__le16		t_r;				/*137-138*/
+	__le16		t_ccs;				/*139-140*/
+	u8		reserved3[23];			/*141-163*/
+
+	/* vendor */
+	__le16		vendor_specific_revision;	/*164-165*/
+	u8		vendor_specific[88];		/*166-253*/
+
+	__le16		crc;				/*254-255*/
+} __packed;
+
+#define ONFI_CRC_BASE	0x4F4E
+
+/**
+ * struct spi_nand_chip - SPI-NAND Private Flash Chip Data
+ * @chip_lock:		[INTERN] protection lock
+ * @name:		name of the chip
+ * @wq:			[INTERN] wait queue to sleep on if a SPI-NAND operation
+ *			is in progress used instead of the per chip wait queue
+ *			when a hw controller is available.
+ * @mfr_id:		[BOARDSPECIFIC] manufacture id
+ * @dev_id:		[BOARDSPECIFIC] device id
+ * @state:		[INTERN] the current state of the SPI-NAND device
+ * @spi:		[INTERN] point to spi device structure
+ * @mtd:		[INTERN] point to MTD device structure
+ * @reset:		[REPLACEABLE] function to reset the device
+ * @read_id:		[REPLACEABLE] read manufacture id and device id
+ * @load_page:		[REPLACEABLE] load page from NAND to cache
+ * @read_cache:		[REPLACEABLE] read data from cache
+ * @store_cache:	[REPLACEABLE] write data to cache
+ * @write_page:		[REPLACEABLE] program NAND with cache data
+ * @erase_block:	[REPLACEABLE] erase a given block
+ * @waitfunc:		[REPLACEABLE] wait for ready.
+ * @write_enable:	[REPLACEABLE] set write enable latch
+ * @get_ecc_status:	[REPLACEABLE] get ecc and bitflip status
+ * @enable_ecc:		[REPLACEABLE] enable on-die ecc
+ * @disable_ecc:	[REPLACEABLE] disable on-die ecc
+ * @buf:		[INTERN] buffer for read/write
+ * @oobbuf:		[INTERN] buffer for read/write oob
+ * @pagebuf:		[INTERN] holds the pagenumber which is currently in
+ *			data_buf.
+ * @pagebuf_bitflips:	[INTERN] holds the bitflip count for the page which is
+ *			currently in data_buf.
+ * @size:		[INTERN] the size of chip
+ * @block_size:		[INTERN] the size of eraseblock
+ * @page_size:		[INTERN] the size of page
+ * @page_spare_size:	[INTERN] the size of page oob size
+ * @block_shift:	[INTERN] number of address bits in a eraseblock
+ * @page_shift:		[INTERN] number of address bits in a page (column
+ *			address bits).
+ * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1
+ * @options:		[BOARDSPECIFIC] various chip options. They can partly
+ *			be set to inform nand_scan about special functionality.
+ * @ecc_strength_ds:	[INTERN] ECC correctability from the datasheet.
+ *			Minimum amount of bit errors per @ecc_step_ds guaranteed
+ *			to be correctable. If unknown, set to zero.
+ * @ecc_step_ds:	[INTERN] ECC step required by the @ecc_strength_ds,
+ *                      also from the datasheet. It is the recommended ECC step
+ *			size, if known; if unknown, set to zero.
+ * @bits_per_cell:	[INTERN] number of bits per cell. i.e., 1 means SLC.
+ * @ecclayout:		[BOARDSPECIFIC] ECC layout control structure
+ *			See the defines for further explanation.
+ * @bbt_options:	[INTERN] bad block specific options. All options used
+ *			here must come from bbm.h. By default, these options
+ *			will be copied to the appropriate nand_bbt_descr's.
+ * @bbt:		[INTERN] bad block table pointer
+ * @badblockpos:	[INTERN] position of the bad block marker in the oob
+ *			area.
+ * @bbt_td:		[REPLACEABLE] bad block table descriptor for flash
+ *			lookup.
+ * @bbt_md:		[REPLACEABLE] bad block table mirror descriptor
+ * @badblock_pattern:	[REPLACEABLE] bad block scan pattern used for initial
+ *			bad block scan.
+ * @onfi_params:	[INTERN] holds the ONFI page parameter when ONFI is
+ *			supported, 0 otherwise.
+ */
+
+struct spi_nand_chip {
+	spinlock_t	chip_lock;
+	char		*name;
+	wait_queue_head_t wq;
+	u8		mfr_id;
+	u8		dev_id;
+	flstate_t	state;
+	struct spi_device	*spi;
+	struct mtd_info	*mtd;
+
+	int (*reset)(struct spi_nand_chip *chip);
+	int (*read_id)(struct spi_nand_chip *chip, u8 *id);
+	int (*load_page)(struct spi_nand_chip *chip, unsigned int page_addr);
+	int (*read_cache)(struct spi_nand_chip *chip, unsigned int page_addr,
+		unsigned int page_offset,	size_t length, u8 *read_buf);
+	int (*store_cache)(struct spi_nand_chip *chip, unsigned int page_addr,
+		unsigned int page_offset,	size_t length, u8 *write_buf);
+	int (*write_page)(struct spi_nand_chip *chip, unsigned int page_addr);
+	int (*erase_block)(struct spi_nand_chip *chip, u32 page_addr);
+	int (*waitfunc)(struct spi_nand_chip *chip, u8 *status);
+	int (*write_enable)(struct spi_nand_chip *chip);
+	void (*get_ecc_status)(unsigned int status,
+						unsigned int *corrected,
+						unsigned int *ecc_errors);
+	int (*enable_ecc)(struct spi_nand_chip *chip);
+	int (*disable_ecc)(struct spi_nand_chip *chip);
+
+	u8		*buf;
+	u8		*oobbuf;
+	int		pagebuf;
+	u32		pagebuf_bitflips;
+	u64		size;
+	u32		block_size;
+	u16		page_size;
+	u16		page_spare_size;
+	u8		block_shift;
+	u8		page_shift;
+	u16		page_mask;
+	u32		options;
+	u16		ecc_strength_ds;
+	u16		ecc_step_ds;
+	u8		bits_per_cell;
+	struct nand_ecclayout *ecclayout;
+	u32		bbt_options;
+	u8		*bbt;
+	int		badblockpos;
+	struct nand_bbt_descr *bbt_td;
+	struct nand_bbt_descr *bbt_md;
+	struct nand_bbt_descr *badblock_pattern;
+	struct spi_nand_onfi_params	 onfi_params;
+};
+
+struct spi_nand_flash {
+	char		*name;
+	u8		mfr_id;
+	u8		dev_id;
+	u32		page_size;
+	u32		page_spare_size;
+	u32		pages_per_blk;
+	u32		blks_per_chip;
+	u32		options;
+};
+
+struct spi_nand_cmd {
+	u8		cmd;
+	u32		n_addr;		/* Number of address */
+	u8		addr[3];	/* Reg Offset */
+	u32		n_tx;		/* Number of tx bytes */
+	u8		*tx_buf;	/* Tx buf */
+	u8		tx_nbits;
+	u32		n_rx;		/* Number of rx bytes */
+	u8		*rx_buf;	/* Rx buf */
+	u8		rx_nbits;
+};
+
+#define SPI_NAND_INFO(nm, mid, did, pagesz, sparesz, pg_per_blk,\
+	blk_per_chip, opts)				\
+	{ .name = (nm), .mfr_id = (mid), .dev_id = (did),\
+	.page_size = (pagesz), .page_spare_size = (sparesz),\
+	.pages_per_blk = (pg_per_blk), .blks_per_chip = (blk_per_chip),\
+	.options = (opts) }
+
+#define SPINAND_NEED_PLANE_SELECT	(1 << 0)
+
+#define SPINAND_MFR_MICRON		0x2C
+#define SPINAND_MFR_GIGADEVICE	0xC8
+#define SPINAND_MAX_ID_LEN		2
+
+int spi_nand_send_cmd(struct spi_device *spi, struct spi_nand_cmd *cmd);
+int spi_nand_read_from_cache(struct spi_nand_chip *chip,
+		u32 page_addr, u32 column, size_t len, u8 *rbuf);
+int spi_nand_read_from_cache_snor_protocol(struct spi_nand_chip *chip,
+		u32 page_addr, u32 column, size_t len, u8 *rbuf);
+int spi_nand_scan_ident(struct mtd_info *mtd);
+int spi_nand_scan_tail(struct mtd_info *mtd);
+int spi_nand_scan_ident_release(struct mtd_info *mtd);
+int spi_nand_scan_tail_release(struct mtd_info *mtd);
+int spi_nand_release(struct mtd_info *mtd);
+int __spi_nand_erase(struct mtd_info *mtd, struct erase_info *einfo,
+		int allowbbt);
+int spi_nand_isbad_bbt(struct mtd_info *mtd, loff_t offs, int allowbbt);
+int spi_nand_default_bbt(struct mtd_info *mtd);
+int spi_nand_markbad_bbt(struct mtd_info *mtd, loff_t offs);
+#endif /* __LINUX_MTD_SPI_NAND_H */
-- 
1.9.1
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
