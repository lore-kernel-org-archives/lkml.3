Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaKHNaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:30:06 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39661 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaKHN3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:29:47 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-32-545e1ac7abfa
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v4 1/1] misc: st32fwu: Add stm32 upgrade protocol handling
Date: Sat, 08 Nov 2014 14:29:12 +0100
Message-id: <1415453352-14842-2-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415453352-14842-1-git-send-email-k.wrona@samsung.com>
References: <1415453352-14842-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Vd3jUnEhBjf+iln8nXSM3WLjjPWs
	FgdXLmOyeNC0isni1LL9TBa7/r9htjjb9IbdYt6RdywWl3fNYXPg9Pj9axKjx85Zd9k9PnyM
	89i0qpPNo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDJefLnLXNA6h7Fi2pzjjA2Mc2u6GDk5
	JARMJA7MmcQOYYtJXLi3nq2LkYtDSGApo8SC/inMEE4fk8TdN22sIFVsAuoSzTsWgyVEQKr6
	bl9iA0kwC2xllNi6zxbEFhbwkjj+qI8FxGYRUJU4u/86mM0r4CyxpG0KUxcjB9A6BYk5k2xA
	wpwCLhJXP+4FGyMEVLKhdxrzBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCgu7r
	Dsalx6wOMQpwMCrx8L6YFBsixJpYVlyZe4hRgoNZSYS39zxQiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA6P0itUvtnGqy7/YKXw0n4s7KMgz/83KHecP79wsGr6riGH6xNW//zwvPvVdm/8K1/Mt
	XXGRLwxnr2hiU3BQW6P24fLeiRVmpz5OYD/gu0sq5h335+oJG9TY/dmNZFqv5QW+j+v9e/l0
	2Jv6TTz2+50PSt969yZ2OleC4eYFbIoPKw+cnX29pCFKiaU4I9FQi7moOBEAz7GAyxgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds stm32 bootloader protocol handling.

SPI transfers are done using DMA safe buffer which is allocated once per
spi upgrade life cycle. Now it supports only SPI bus but it looks that UART
or I2C are quite similar and it can be used as start platform for implementing
their handling.

It was tested on STM32F401 MCU.

Change-Id: I5e5b441310c897ff822e65041531d80ea0e7426c
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/Kconfig               |    1 +
 drivers/misc/Makefile              |    1 +
 drivers/misc/stm32fwu/Kconfig      |    6 +
 drivers/misc/stm32fwu/Makefile     |    1 +
 drivers/misc/stm32fwu/stm32_core.c |  403 ++++++++++++++++++++++++++++++++++++
 drivers/misc/stm32fwu/stm32_core.h |   81 ++++++++
 drivers/misc/stm32fwu/stm32_spi.c  |  108 ++++++++++
 include/linux/stm32fwu.h           |   49 +++++
 8 files changed, 650 insertions(+)
 create mode 100644 drivers/misc/stm32fwu/Kconfig
 create mode 100644 drivers/misc/stm32fwu/Makefile
 create mode 100644 drivers/misc/stm32fwu/stm32_core.c
 create mode 100644 drivers/misc/stm32fwu/stm32_core.h
 create mode 100644 drivers/misc/stm32fwu/stm32_spi.c
 create mode 100644 include/linux/stm32fwu.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index bbeb451..b2e68c1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -528,4 +528,5 @@ source "drivers/misc/mic/Kconfig"
 source "drivers/misc/genwqe/Kconfig"
 source "drivers/misc/echo/Kconfig"
 source "drivers/misc/cxl/Kconfig"
+source "drivers/misc/stm32fwu/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7d5c4cd..88c8999 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
+obj-$(CONFIG_STM32_UPGRADE_PROTOCOL)	+= stm32fwu/
diff --git a/drivers/misc/stm32fwu/Kconfig b/drivers/misc/stm32fwu/Kconfig
new file mode 100644
index 0000000..1484441
--- /dev/null
+++ b/drivers/misc/stm32fwu/Kconfig
@@ -0,0 +1,6 @@
+config STM32_UPGRADE_PROTOCOL
+	tristate "STM32 upgrade protocol support"
+	depends on SPI
+	help
+	  STM32 microcontroller bootloader upgrade protocol.
+	  Say Y if you want to use it.
diff --git a/drivers/misc/stm32fwu/Makefile b/drivers/misc/stm32fwu/Makefile
new file mode 100644
index 0000000..1617530
--- /dev/null
+++ b/drivers/misc/stm32fwu/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_STM32_UPGRADE_PROTOCOL) += stm32_core.o stm32_spi.o
diff --git a/drivers/misc/stm32fwu/stm32_core.c b/drivers/misc/stm32fwu/stm32_core.c
new file mode 100644
index 0000000..4c48cd8
--- /dev/null
+++ b/drivers/misc/stm32fwu/stm32_core.c
@@ -0,0 +1,403 @@
+/*
+ *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/stm32fwu.h>
+#include "stm32_core.h"
+
+static inline int stm32fwu_wait_for_ack(struct stm32fwu_fw *fw, u32 retries)
+{
+	return fw->wait_for_ack(fw, retries);
+}
+
+static inline int stm32fwu_send_cmd(struct stm32fwu_fw *fw, u8 cmd,
+				    u32 timeout)
+{
+	struct stm32fwu_cmd cm = {
+		.cmd = cmd,
+		.neg_cmd = ~cmd,
+		.timeout  = timeout,
+	};
+
+	return fw->send_cmd(fw, &cm);
+}
+
+static inline int stm32fwu_write(struct stm32fwu_fw *fw, const u8 *buf,
+				 u32 len)
+{
+	return fw->write(fw, buf, len);
+}
+
+static inline int stm32fwu_read(struct stm32fwu_fw *fw, u8 *buf, u32 len)
+{
+	return fw->read(fw, buf, len);
+}
+
+static int send_addr(struct stm32fwu_fw *fw, u32 addr)
+{
+	int ret;
+	u8 *buffer = fw->buffer;
+
+	buffer[0] = addr >> 24;
+	buffer[1] = addr >> 16;
+	buffer[2] = addr >> 8;
+	buffer[3] = addr;
+	buffer[4] = buffer[0] ^ buffer[1] ^ buffer[2] ^ buffer[3];
+
+	ret = stm32fwu_write(fw, buffer, STM32FWU_ADDR_LEN);
+	if (ret < 0)
+		return ret;
+
+	return stm32fwu_wait_for_ack(fw, STM32FWU_COMMON_COUNT);
+}
+
+static int fwu_write(struct stm32fwu_fw *fw, u32 addr, const u8 *buffer,
+		     u32 len)
+{
+	u8 *sbuf = fw->buffer;
+	u8 xor = 0;
+	int ret;
+	u32 i, aligned_len = len;
+
+	if (len > STM32FWU_MAX_TRANSFER_SIZE) {
+		dev_err(fw->dev, "More than 256 bytes per transfer\n");
+		return -EINVAL;
+	}
+
+	ret = stm32fwu_send_cmd(fw, STM32FWU_WRITE_MEM_CMD,
+				STM32FWU_CMD_COUNT);
+	if (ret < 0)
+		return ret;
+
+	ret = send_addr(fw, addr);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * the same buffer is used for commands and data so the order really
+	 * matters here
+	 */
+	memcpy(&sbuf[1], buffer, len);
+
+	/*
+	 * Just in case - check if chunk is a multiple of 4
+	 * generally the most of writes will be 256 bytes long.
+	 * I wonder if bootcode should worry about alignment.
+	 * According AN4286 it should be a multiple of 2 but other notes
+	 * say that it should be 4
+	 */
+	if (!IS_ALIGNED(len, 4)) {
+		aligned_len = ALIGN(len, 4);
+		for (i = aligned_len; i > len; --i)
+			sbuf[i] = 0xff;
+	}
+
+	/*
+	 * according AN4286 here is sent 0 < N < 255, it looks like max index,
+	 * not size
+	 */
+	sbuf[0] = aligned_len - 1;
+
+	/* compute checksum */
+	for (i = 0; i < aligned_len + 1; ++i)
+		xor ^= sbuf[i];
+	sbuf[aligned_len + 1] = xor;
+
+	/* NOTE AN4286: in some conditions the master has to wait 1 ms here */
+	usleep_range(1000, 1100);
+
+	ret = stm32fwu_write(fw, sbuf, aligned_len + 2);
+	if (ret < 0)
+		return ret;
+
+	return stm32fwu_wait_for_ack(fw, STM32FWU_COMMON_COUNT);
+}
+
+static int fwu_erase(struct stm32fwu_fw *fw)
+{
+	int ret;
+	u8 *sbuf = fw->buffer;
+
+	ret = stm32fwu_send_cmd(fw, STM32FWU_ERASE_CMD, STM32FWU_CMD_COUNT);
+	if (ret < 0)
+		return ret;
+
+	/* global erase */
+	sbuf[0] = 0xff;
+	sbuf[1] = 0xff;
+	sbuf[2] = 0x00;
+
+	ret = stm32fwu_write(fw, sbuf, STM32FWU_ERASE_CMD_LEN);
+	if (ret < 0)
+		return ret;
+
+	return stm32fwu_wait_for_ack(fw, STM32FWU_ERASE_COUNT);
+}
+
+/**
+ * stm32fwu_get() - gets bootloader information frame
+ * @fw:		fw object.
+ *
+ * Read bootloader information:
+ *
+ * Byte  1 bootloader version (0 < version < 255), example: 0x10 = version 1.0.
+ *
+ * Byte  2 0x00 (Get command)
+ *
+ * Byte  3 0x01 (Get Version)
+ *
+ * Byte  4 0x02 (Get ID)
+ *
+ * Byte  5 0x11 (Read Memory command)
+ *
+ * Byte  6 0x21 (Go command)
+ *
+ * Byte  7 0x31 (Write Memory command)
+ *
+ * Byte  8 0x44 (Erase command)
+ *
+ * Byte  9 0x63 (Write Protect command)
+ *
+ * Byte 10 0x73 (Write Unprotect command)
+ *
+ * Byte 11 0x82 (Readout Protect command)
+ *
+ * Byte 12 0x92 (Readout Unprotect command)
+ *
+ * Return:	read byte count or error code.
+ */
+int stm32fwu_get(struct stm32fwu_fw *fw)
+{
+	int ret, count;
+
+	ret = stm32fwu_send_cmd(fw, STM32FWU_GET_CMD, STM32FWU_CMD_COUNT);
+	if (ret < 0)
+		return ret;
+
+	ret = stm32fwu_read(fw, &fw->buffer[STM32FWU_MAX_BUFFER_SIZE], 1);
+	if (ret < 0)
+		return ret;
+
+	count = fw->buffer[STM32FWU_MAX_BUFFER_SIZE];
+	if (count >= STM32FWU_MAX_TRANSFER_SIZE)
+		return -EINVAL;
+
+	ret = stm32fwu_read(fw, &fw->buffer[STM32FWU_MAX_BUFFER_SIZE], count);
+	if (ret < 0)
+		return ret;
+
+	ret = stm32fwu_wait_for_ack(fw, STM32FWU_COMMON_COUNT);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+EXPORT_SYMBOL(stm32fwu_get);
+
+/**
+ * stm32fwu_get_version() - gets bootloader information frame
+ * @fw:		fw object.
+ *
+ * Return: < 0 - error code, any positive value means success.
+ */
+int stm32fwu_get_version(struct stm32fwu_fw *fw)
+{
+	int ret;
+
+	ret = stm32fwu_send_cmd(fw, STM32FWU_GET_CMD, STM32FWU_CMD_COUNT);
+	if (ret < 0)
+		return ret;
+
+	ret = stm32fwu_read(fw, &fw->buffer[STM32FWU_MAX_BUFFER_SIZE], 1);
+	if (ret < 0)
+		return ret;
+
+	ret = stm32fwu_wait_for_ack(fw, STM32FWU_COMMON_COUNT);
+	if (ret < 0)
+		return ret;
+
+	return fw->buffer[STM32FWU_MAX_BUFFER_SIZE];
+}
+EXPORT_SYMBOL(stm32fwu_get_version);
+
+/**
+ * stm32fwu_send_sync() - sends bootloader synchronization frame
+ * @fw:	fw object.
+ *
+ * It is used during SPI upgrade.
+ *
+ * Return:	if succeed the number of ack waiting cycles or error code.
+ */
+int stm32fwu_send_sync(struct stm32fwu_fw *fw)
+{
+	int ret;
+
+	dev_info(fw->dev, "send sync byte for upgrade\n");
+
+	fw->buffer[0] = STM32FWU_SPI_SOF;
+
+	ret = stm32fwu_write(fw, fw->buffer, 1);
+	if (ret < 0)
+		return ret;
+
+	return  stm32fwu_wait_for_ack(fw, STM32FWU_CMD_COUNT);
+}
+EXPORT_SYMBOL(stm32fwu_send_sync);
+
+/**
+ * stm32fwu_update() - runs all firmware update work
+ * @fw:		fw object.
+ *
+ * Return:	status code < 0 if error.
+ */
+int stm32fwu_update(struct stm32fwu_fw *fw)
+{
+	int ret = 0;
+	u32 pos = 0;
+	u32 fw_addr = STM32FWU_APP_ADDR;
+	u32 block = STM32FWU_MAX_TRANSFER_SIZE;
+	u32 count = 0, err_count = 0, retry_count = 0, remaining = fw->fw_len;
+
+	dev_info(fw->dev, "%s start\n", __func__);
+
+	ret = fwu_erase(fw);
+	if (ret < 0) {
+		dev_err(fw->dev, "%s, fw_erase_stm failed %d\n", __func__,
+			ret);
+		return ret;
+	}
+
+	while (remaining > 0) {
+		if (block > remaining)
+			block = remaining;
+
+		while (retry_count < 3) {
+			ret = fwu_write(fw, fw_addr, fw->fw_data + pos, block);
+			if (ret < 0) {
+				dev_err(fw->dev,
+					"Err %d writing to addr 0x%08X\n", ret,
+					fw_addr);
+				retry_count++;
+				err_count++;
+				continue;
+			}
+			retry_count = 0;
+			break;
+		}
+
+		if (ret < 0) {
+			dev_err(fw->dev,
+				"Writing MEM failed: %d, retry count: %d\n",
+				ret, err_count);
+			return ret;
+		}
+
+		remaining -= block;
+		pos += block;
+		fw_addr += block;
+		if (count++ == 20) {
+			dev_info(fw->dev, "Updated %u bytes / %u bytes\n",
+				 pos, fw->fw_len);
+			count = 0;
+		}
+	}
+
+	dev_info(fw->dev,
+		 "Firmware download success.(%d bytes, retry %d)\n", pos,
+		 err_count);
+
+	ret = stm32fwu_send_cmd(fw, STM32FWU_GO_ADDR_CMD, STM32FWU_CMD_COUNT);
+	if (ret < 0)
+		return ret;
+
+	return send_addr(fw, STM32FWU_APP_ADDR);
+}
+EXPORT_SYMBOL(stm32fwu_update);
+
+/**
+ * stm32fwu_init() - creates firmware upgrade instance
+ * @dev:	Pointer to device.
+ * @iface:	Interface type.
+ * @data:	Pointer to firmware data.
+ * @len:	Length of firmware data in bytes.
+ *
+ * It allocates the place for fwu structure and transfer buffer so it should
+ * be deinitialized by stm32fw_destroy(). Firmware upgrade is simple operation
+ * and it was assumed that it will be called from one context so there is no
+ * locking for fwu functions.
+ *
+ * Return:	Pointer to firmware upgrade structure.
+ */
+struct stm32fwu_fw *stm32fwu_init(struct device *dev,
+				  enum stm32fwu_iface iface, const u8 *data,
+				  u32 len)
+{
+	struct stm32fwu_fw *fw;
+
+	if (iface >= STM32_MAX || iface < 0) {
+		dev_err(dev, "wrong iface type\n");
+		return NULL;
+	}
+
+	fw = devm_kzalloc(dev, sizeof(*fw), GFP_KERNEL);
+	if (fw == NULL)
+		return NULL;
+
+	/* 2 times for tx and rx buffer */
+	fw->buffer = devm_kzalloc(dev, 2 * STM32FWU_MAX_BUFFER_SIZE,
+			     GFP_KERNEL | GFP_DMA);
+	if (fw->buffer == NULL) {
+		devm_kfree(dev, fw);
+		return NULL;
+	}
+
+	fw->dev = dev;
+	fw->fw_len = len;
+	fw->fw_data = data;
+
+	switch (iface) {
+	case STM32_SPI:
+		stm32fwu_spi_init(fw);
+		break;
+	default:
+		pr_err("wrong interface\n");
+		goto _err;
+	}
+
+	return fw;
+_err:
+	devm_kfree(dev, fw->buffer);
+	devm_kfree(dev, fw);
+	return NULL;
+}
+EXPORT_SYMBOL(stm32fwu_init);
+
+/**
+ * stm32fwu_destroy() - cleans up fwu structure and buffer.
+ * @fw:		Pointer to fwu structure.
+ */
+void stm32fwu_destroy(struct stm32fwu_fw *fw)
+{
+	devm_kfree(fw->dev, fw->buffer);
+	devm_kfree(fw->dev, fw);
+}
+EXPORT_SYMBOL(stm32fwu_destroy);
+
+MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
+MODULE_DESCRIPTION("STM32 upgrade protocol");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/stm32fwu/stm32_core.h b/drivers/misc/stm32fwu/stm32_core.h
new file mode 100644
index 0000000..9624327
--- /dev/null
+++ b/drivers/misc/stm32fwu/stm32_core.h
@@ -0,0 +1,81 @@
+/*
+ *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#ifndef _STM32_CORE_H_
+#define _STM32_CORE_H_
+
+#define STM32FWU_ADDR_LEN		5
+#define STM32FWU_ERASE_CMD_LEN		3
+
+/* Protocol */
+#define STM32FWU_SPI_SOF		0x5a
+#define STM32FWU_ACK			0x79
+#define STM32FWU_ACK2			0xf9
+#define STM32FWU_NACK			0x1f
+
+#define STM32FWU_MAX_TRANSFER_SIZE	256
+#define STM32FWU_MAX_BUFFER_SIZE	260
+
+#define STM32FWU_APP_ADDR		0x08000000
+
+/* Retries counts */
+#define STM32FWU_ERASE_COUNT		18000
+#define STM32FWU_CMD_COUNT		30
+#define STM32FWU_COMMON_COUNT		20
+
+/* Commands */
+#define STM32FWU_WRITE_MEM_CMD		0x31
+#define STM32FWU_GO_ADDR_CMD		0x21
+#define STM32FWU_ERASE_CMD		0x44
+#define STM32FWU_GET_CMD		0x00
+#define STM32FWU_GET_VERSION_CMD	0x01
+
+/**
+ * struct stm32fwu_cmd - Upgrade command
+ * @cmd:	Fwu command.
+ * @neg_cmd:	Bit negation of Fwu command used xor'ed in STM.
+ * @timeout:	Number of retries.
+ */
+struct stm32fwu_cmd {
+	u8 cmd;
+	u8 neg_cmd;
+	u32 timeout;
+};
+
+/**
+ * struct stm32fwu_fw - Generic representation for STM32 fw upgrade
+ * @dev:		Pointer to device.
+ * @wait_for_ack:	ACK callback.
+ * @send_cmd:		Command callback.
+ * @write:		Write callback.
+ * @read:		Read callback.
+ * @fw_data:		Pointer to firmware binary.
+ * @fw_len:		The length of fw bin.
+ * @buffer:		Pointer to SPI buffer: should be DMA safe
+ */
+struct stm32fwu_fw {
+	int (*wait_for_ack)(struct stm32fwu_fw *fw, u32 retries);
+	int (*send_cmd)(struct stm32fwu_fw *fw, struct stm32fwu_cmd *cmd);
+	int (*write)(struct stm32fwu_fw *fw, const u8 *buf, u32 len);
+	int (*read)(struct stm32fwu_fw *fw, u8 *buf, u32 len);
+	const u8 *fw_data;
+	u32 fw_len;
+	u8 *buffer;
+	struct device *dev;
+};
+
+void stm32fwu_spi_init(struct stm32fwu_fw *fw);
+
+#endif /*_STM32_CORE_H_ */
diff --git a/drivers/misc/stm32fwu/stm32_spi.c b/drivers/misc/stm32fwu/stm32_spi.c
new file mode 100644
index 0000000..7905baf
--- /dev/null
+++ b/drivers/misc/stm32fwu/stm32_spi.c
@@ -0,0 +1,108 @@
+/*
+ *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/stm32fwu.h>
+#include "stm32_core.h"
+
+static int stm32fwu_spi_write(struct stm32fwu_fw *fw, const u8 *buf, u32 len)
+{
+	struct spi_device *sdev = to_spi_device(fw->dev);
+
+	struct spi_message m;
+	struct spi_transfer t = {
+		.len = len,
+		.tx_buf = buf,
+		.bits_per_word = 8,
+	};
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	return spi_sync(sdev, &m);
+}
+
+static int stm32fwu_spi_read(struct stm32fwu_fw *fw, u8 *buf, u32 len)
+{
+	struct spi_device *sdev = to_spi_device(fw->dev);
+
+	struct spi_message m;
+	struct spi_transfer t = {
+		.len = len,
+		.rx_buf = buf,
+		.bits_per_word = 8,
+	};
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	return spi_sync(sdev, &m);
+}
+
+static int stm32fwu_spi_wait_for_ack(struct stm32fwu_fw *fw, u32 retries)
+{
+	int ret, i = 0;
+	u8 *buf = &fw->buffer[STM32FWU_MAX_BUFFER_SIZE];
+
+	while (i < retries) {
+		ret = stm32fwu_spi_read(fw, buf, 1);
+		if (ret < 0) {
+			dev_err(fw->dev,
+				"firmware upgrade wait for ack fail\n");
+			return ret;
+		}
+
+		if (fw->buffer[STM32FWU_MAX_BUFFER_SIZE] == STM32FWU_ACK ||
+		    fw->buffer[STM32FWU_MAX_BUFFER_SIZE] == STM32FWU_ACK2) {
+			return i;
+		}
+
+		if (fw->buffer[STM32FWU_MAX_BUFFER_SIZE] == STM32FWU_NACK)
+			return -EPROTO;
+
+		usleep_range(1000, 1100);
+		i++;
+	}
+
+	dev_err(fw->dev, "fw ack timeout\n");
+
+	return -ETIMEDOUT;
+}
+
+static int stm32fwu_spi_send_cmd(struct stm32fwu_fw *fw,
+				 struct stm32fwu_cmd *cmd)
+{
+	int ret;
+
+	fw->buffer[0] = STM32FWU_SPI_SOF;
+	fw->buffer[1] = cmd->cmd;
+	fw->buffer[2] = cmd->neg_cmd;
+
+	ret = stm32fwu_spi_write(fw, fw->buffer, 3);
+	if (ret < 0) {
+		dev_err(fw->dev, "fw cmd write fail\n");
+		return ret;
+	}
+
+	return stm32fwu_spi_wait_for_ack(fw, cmd->timeout);
+}
+
+void stm32fwu_spi_init(struct stm32fwu_fw *fw)
+{
+	fw->write = stm32fwu_spi_write;
+	fw->read = stm32fwu_spi_read;
+	fw->wait_for_ack = stm32fwu_spi_wait_for_ack;
+	fw->send_cmd = stm32fwu_spi_send_cmd;
+}
diff --git a/include/linux/stm32fwu.h b/include/linux/stm32fwu.h
new file mode 100644
index 0000000..3084ffd
--- /dev/null
+++ b/include/linux/stm32fwu.h
@@ -0,0 +1,49 @@
+/*
+ *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#ifndef _STM32FWU_H_
+#define _STM32FWU_H_
+
+/**
+ * enum stm32fwu_iface - upgrade interfaces for STM32 MCU's
+ * @STM32_SPI:		SPI interface.
+ * @STM32_MAX:		terminator.
+ */
+enum stm32fwu_iface {
+	STM32_SPI,
+	/*
+	 * Generally for future use, i.e. UART upgrade algorithm looks pretty
+	 * similar.
+	 */
+	STM32_MAX
+};
+
+struct stm32fwu_fw;
+
+struct stm32fwu_fw *stm32fwu_init(struct device *dev,
+				  enum stm32fwu_iface iface, const u8 *data,
+				  u32 len);
+
+void stm32fwu_destroy(struct stm32fwu_fw *fw);
+
+int stm32fwu_send_sync(struct stm32fwu_fw *fw);
+
+int stm32fwu_update(struct stm32fwu_fw *fw);
+
+int stm32fwu_get(struct stm32fwu_fw *fw);
+
+int stm32fwu_get_version(struct stm32fwu_fw *fw);
+
+#endif /* _STM32FWU_H_ */
-- 
1.7.9.5

