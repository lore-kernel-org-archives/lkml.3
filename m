Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3HPSKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:10:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39856 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3HPSKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:10:09 -0400
Message-Id: <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
In-Reply-To: <cover.1376596224.git.joshc@codeaurora.org>
References: <cover.1376596224.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Fri, 9 Aug 2013 13:37:09 -0700
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenneth Heitke <kheitke@codeaurora.org>

System Power Management Interface (SPMI) is a specification
developed by the MIPI (Mobile Industry Process Interface) Alliance
optimized for the real time control of Power Management ICs (PMIC).

SPMI is a two-wire serial interface that supports up to 4 master
devices and up to 16 logical slaves.

The framework supports message APIs, multiple busses (1 controller
per bus) and multiple clients/slave devices per controller.

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/Kconfig                 |   2 +
 drivers/Makefile                |   1 +
 drivers/of/Kconfig              |   6 +
 drivers/of/Makefile             |   1 +
 drivers/of/of_spmi.c            |  74 +++++
 drivers/spmi/Kconfig            |   9 +
 drivers/spmi/Makefile           |   7 +
 drivers/spmi/spmi-dbgfs.c       | 591 ++++++++++++++++++++++++++++++++++++++++
 drivers/spmi/spmi-dbgfs.h       |  37 +++
 drivers/spmi/spmi.c             | 449 ++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h |   8 +
 include/linux/of_spmi.h         |  37 +++
 include/linux/spmi.h            | 337 +++++++++++++++++++++++
 13 files changed, 1559 insertions(+)
 create mode 100644 drivers/of/of_spmi.c
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-dbgfs.c
 create mode 100644 drivers/spmi/spmi-dbgfs.h
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/linux/of_spmi.h
 create mode 100644 include/linux/spmi.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index aa43b91..2b35420 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/spmi/Kconfig"
+
 source "drivers/hsi/Kconfig"
 
 source "drivers/pps/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index ab93de8..5c250df 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_TARGET_CORE)	+= target/
 obj-$(CONFIG_MTD)		+= mtd/
 obj-$(CONFIG_SPI)		+= spi/
+obj-$(CONFIG_SPMI)		+= spmi/
 obj-y				+= hsi/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 80e5c13..916b0c1 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -76,6 +76,12 @@ config OF_PCI_IRQ
 	help
 	  OpenFirmware PCI IRQ routing helpers
 
+config OF_SPMI
+	def_tristate SPMI
+	depends on SPMI
+	help
+	  OpenFirmware SPMI bus accessors
+
 config OF_MTD
 	depends on MTD
 	def_bool y
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 1f9c0c4..5486614 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_OF_SELFTEST) += selftest.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
+obj-$(CONFIG_OF_SPMI)	+= of_spmi.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
diff --git a/drivers/of/of_spmi.c b/drivers/of/of_spmi.c
new file mode 100644
index 0000000..fca19c5
--- /dev/null
+++ b/drivers/of/of_spmi.c
@@ -0,0 +1,74 @@
+/* Copyright (c) 2012,2013 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/spmi.h>
+#include <linux/of_spmi.h>
+
+int of_spmi_register_devices(struct spmi_controller *ctrl)
+{
+	struct device_node *node;
+	int err;
+
+	dev_dbg(&ctrl->dev, "of_spmi_register_devices\n");
+
+	if (!ctrl->dev.of_node)
+		return -ENODEV;
+
+	dev_dbg(&ctrl->dev, "looping through children\n");
+
+	for_each_available_child_of_node(ctrl->dev.of_node, node) {
+		struct spmi_device *sdev;
+		u32 usid;
+
+		dev_dbg(&ctrl->dev, "adding child %s\n", node->full_name);
+
+		err = of_property_read_u32(node, "reg", &usid);
+		if (err) {
+			dev_err(&ctrl->dev,
+				"node %s does not have 'reg' property\n",
+				node->full_name);
+			continue;
+		}
+
+		if (usid > 0xFF) {
+			dev_err(&ctrl->dev,
+				"invalid usid on node %s\n",
+				node->full_name);
+			continue;
+		}
+
+		dev_dbg(&ctrl->dev, "read usid %02x\n", usid);
+
+		sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+		if (!sdev)
+			continue;
+
+		sdev->dev.of_node = node;
+		sdev->usid = (u8) usid;
+		spmi_device_initialize(sdev);
+		err = spmi_controller_add_device(ctrl, sdev);
+		if (err) {
+			dev_err(&sdev->dev,
+				"failure adding device. status %d\n", err);
+			continue;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(of_spmi_register_devices);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
new file mode 100644
index 0000000..a03835f
--- /dev/null
+++ b/drivers/spmi/Kconfig
@@ -0,0 +1,9 @@
+#
+# SPMI driver configuration
+#
+menuconfig SPMI
+	bool "SPMI support"
+	help
+	  SPMI (System Power Management Interface) is a two-wire
+	  serial interface between baseband and application processors
+	  and Power Management Integrated Circuits (PMIC).
diff --git a/drivers/spmi/Makefile b/drivers/spmi/Makefile
new file mode 100644
index 0000000..ef96afd
--- /dev/null
+++ b/drivers/spmi/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for kernel SPMI framework.
+#
+obj-$(CONFIG_SPMI)	+= spmi-core.o
+
+spmi-core-y			+= spmi.o
+spmi-core-$(CONFIG_DEBUG_FS)	+= spmi-dbgfs.o
diff --git a/drivers/spmi/spmi-dbgfs.c b/drivers/spmi/spmi-dbgfs.c
new file mode 100644
index 0000000..5ca0a44
--- /dev/null
+++ b/drivers/spmi/spmi-dbgfs.c
@@ -0,0 +1,591 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#define pr_fmt(fmt) "%s:%d: " fmt, __func__, __LINE__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/debugfs.h>
+#include <linux/spmi.h>
+#include <linux/ctype.h>
+#include "spmi-dbgfs.h"
+
+#define ADDR_LEN	 6	/* 5 byte address + 1 space character */
+#define CHARS_PER_ITEM	 3	/* Format is 'XX ' */
+#define ITEMS_PER_LINE	16	/* 16 data items per line */
+#define MAX_LINE_LENGTH	(ADDR_LEN + (ITEMS_PER_LINE * CHARS_PER_ITEM) + 1)
+
+#define MAX_REG_PER_TRANSACTION	(8)
+
+static const mode_t DFS_MODE = S_IRUSR | S_IWUSR;
+
+/* Log buffer */
+struct spmi_log_buffer {
+	u32 rpos;	/* Current 'read' position in buffer */
+	u32 wpos;	/* Current 'write' position in buffer */
+	u32 len;	/* Length of the buffer */
+	char data[0];	/* Log buffer */
+};
+
+/* SPMI transaction parameters */
+struct spmi_trans {
+	u32 cnt;	/* Number of bytes to read */
+	u32 addr;	/* 20-bit address: SID + PID + Register offset */
+	u32 offset;	/* Offset of last read data */
+	bool raw_data;	/* Set to true for raw data dump */
+	struct spmi_device *sdev;
+	struct spmi_log_buffer *log; /* log buffer */
+};
+
+static char dbgfs_help[] =
+	"SPMI Debug-FS support\n"
+	"\n"
+	"Hierarchy schema:\n"
+	"/sys/kernel/debug/spmi\n"
+	"       /help                -- Static help text\n"
+	"       /spmi-0              -- Directory for SPMI bus 0\n"
+	"       /spmi-0/0-1          -- Directory for SPMI device '0-1'\n"
+	"       /spmi-0/0-1/address  -- Starting register for reads or writes\n"
+	"       /spmi-0/0-1/count    -- Number of registers to read (only used for reads)\n"
+	"       /spmi-0/0-1/data     -- Initiates the SPMI read (formatted output)\n"
+	"       /spmi-0/0-1/data_raw -- Initiates the SPMI raw read or write\n"
+	"       /spmi-n              -- Directory for SPMI bus n\n"
+	"\n"
+	"To perform SPMI read or write transactions, you need to first write the\n"
+	"address of the slave device register to the 'address' file.  For read\n"
+	"transactions, the number of bytes to be read needs to be written to the\n"
+	"'count' file.\n"
+	"\n"
+	"The 'address' file specifies the 20-bit address of a slave device register.\n"
+	"The upper 4 bits 'address[19..16]' specify the slave identifier (SID) for\n"
+	"the slave device.  The lower 16 bits specify the slave register address.\n"
+	"\n"
+	"Reading from the 'data' file will initiate a SPMI read transaction starting\n"
+	"from slave register 'address' for 'count' number of bytes.\n"
+	"\n"
+	"Writing to the 'data' file will initiate a SPMI write transaction starting\n"
+	"from slave register 'address'.  The number of registers written to will\n"
+	"match the number of bytes written to the 'data' file.\n"
+	"\n"
+	"Example: Read 4 bytes starting at register address 0x1234 for SID 2\n"
+	"\n"
+	"echo 0x21234 > address\n"
+	"echo 4 > count\n"
+	"cat data\n"
+	"\n"
+	"Example: Write 3 bytes starting at register address 0x1008 for SID 1\n"
+	"\n"
+	"echo 0x11008 > address\n"
+	"echo 0x01 0x02 0x03 > data\n"
+	"\n"
+	"Note that the count file is not used for writes.  Since 3 bytes are\n"
+	"written to the 'data' file, then 3 bytes will be written across the\n"
+	"SPMI bus.\n\n";
+
+static struct debugfs_blob_wrapper spmi_debug_help = {
+	.data	= dbgfs_help,
+	.size	= sizeof(dbgfs_help),
+};
+
+static struct dentry *spmi_debug_root;
+
+static int spmi_device_dfs_open(struct spmi_device *sdev, struct file *file)
+{
+	struct spmi_log_buffer *log;
+	struct spmi_trans *trans;
+
+	size_t logbufsize = SZ_4K;
+
+	/* Per file "transaction" data */
+	trans = kzalloc(sizeof(*trans), GFP_KERNEL);
+	if (!trans)
+		return -ENOMEM;
+
+	log = kzalloc(logbufsize, GFP_KERNEL);
+	if (!log) {
+		kfree(trans);
+		return -ENOMEM;
+	}
+
+	log->rpos = 0;
+	log->wpos = 0;
+	log->len = logbufsize - sizeof(*log);
+
+	trans->log = log;
+	trans->cnt = sdev->dfs_cnt;
+	trans->addr = sdev->dfs_addr;
+	trans->sdev = sdev;
+	trans->offset = trans->addr;
+
+	file->private_data = trans;
+	return 0;
+}
+
+static int spmi_device_dfs_data_open(struct inode *inode, struct file *file)
+{
+	struct spmi_device *sdev = inode->i_private;
+	return spmi_device_dfs_open(sdev, file);
+}
+
+static int spmi_device_dfs_raw_data_open(struct inode *inode, struct file *file)
+{
+	struct spmi_device *sdev = inode->i_private;
+	struct spmi_trans *trans;
+	int rc;
+
+	rc = spmi_device_dfs_open(sdev, file);
+	trans = file->private_data;
+	trans->raw_data = true;
+	return rc;
+}
+
+static int spmi_device_dfs_close(struct inode *inode, struct file *file)
+{
+	struct spmi_trans *trans = file->private_data;
+	kfree(trans->log);
+	kfree(trans);
+	return 0;
+}
+
+/**
+ * spmi_read_data: reads data across the SPMI bus
+ * @ctrl: The SPMI controller
+ * @buf: buffer to store the data read.
+ * @offset: SPMI address offset to start reading from.
+ * @cnt: The number of bytes to read.
+ *
+ * Returns 0 on success, otherwise returns error code from SPMI driver.
+ */
+static int
+spmi_read_data(struct spmi_device *sdev, uint8_t *buf, int offset, int cnt)
+{
+	int ret = 0;
+	int len;
+	uint16_t addr;
+
+	while (cnt > 0) {
+		addr = offset & 0xFFFF;
+		len = min(cnt, MAX_REG_PER_TRANSACTION);
+
+		ret = spmi_ext_register_readl(sdev, addr, buf, len);
+		if (ret < 0) {
+			pr_err("SPMI read failed, err = %d\n", ret);
+			goto done;
+		}
+
+		cnt -= len;
+		buf += len;
+		offset += len;
+	}
+
+done:
+	return ret;
+}
+
+/**
+ * spmi_write_data: writes data across the SPMI bus
+ * @ctrl: The SPMI controller
+ * @buf: data to be written.
+ * @offset: SPMI address offset to start writing to.
+ * @cnt: The number of bytes to write.
+ *
+ * Returns 0 on success, otherwise returns error code from SPMI driver.
+ */
+static int
+spmi_write_data(struct spmi_device *sdev, uint8_t *buf, int offset, int cnt)
+{
+	int ret = 0;
+	int len;
+	uint16_t addr;
+
+	while (cnt > 0) {
+		addr = offset & 0xFFFF;
+		len = min(cnt, MAX_REG_PER_TRANSACTION);
+
+		ret = spmi_ext_register_writel(sdev, addr, buf, len);
+		if (ret < 0) {
+			pr_err("SPMI write failed, err = %d\n", ret);
+			goto done;
+		}
+
+		cnt -= len;
+		buf += len;
+		offset += len;
+	}
+
+done:
+	return ret;
+}
+
+/**
+ * print_to_log: format a string and place into the log buffer
+ * @log: The log buffer to place the result into.
+ * @fmt: The format string to use.
+ * @...: The arguments for the format string.
+ *
+ * The return value is the number of characters written to @log buffer
+ * not including the trailing '\0'.
+ */
+static int print_to_log(struct spmi_log_buffer *log, const char *fmt, ...)
+{
+	va_list args;
+	int cnt;
+	char *buf = &log->data[log->wpos];
+	size_t size = log->len - log->wpos;
+
+	va_start(args, fmt);
+	cnt = vscnprintf(buf, size, fmt, args);
+	va_end(args);
+
+	log->wpos += cnt;
+	return cnt;
+}
+
+/**
+ * write_next_line_to_log: Writes a single "line" of data into the log buffer
+ * @trans: Pointer to SPMI transaction data.
+ * @offset: SPMI address offset to start reading from.
+ * @pcnt: Pointer to 'cnt' variable.  Indicates the number of bytes to read.
+ *
+ * The 'offset' is a 20-bits SPMI address which includes a 4-bit slave id (SID),
+ * an 8-bit peripheral id (PID), and an 8-bit peripheral register address.
+ *
+ * On a successful read, the pcnt is decremented by the number of data
+ * bytes read across the SPMI bus.  When the cnt reaches 0, all requested
+ * bytes have been read.
+ */
+static int
+write_next_line_to_log(struct spmi_trans *trans, int offset, size_t *pcnt)
+{
+	int i, j;
+	u8  data[ITEMS_PER_LINE];
+	struct spmi_log_buffer *log = trans->log;
+
+	int cnt = 0;
+	int padding = offset % ITEMS_PER_LINE;
+	int items_to_read = min(ARRAY_SIZE(data) - padding, *pcnt);
+	int items_to_log = min(ITEMS_PER_LINE, padding + items_to_read);
+
+	/* Buffer needs enough space for an entire line */
+	if ((log->len - log->wpos) < MAX_LINE_LENGTH)
+		goto done;
+
+	/* Read the desired number of "items" */
+	if (spmi_read_data(trans->sdev, data, offset, items_to_read))
+		goto done;
+
+	*pcnt -= items_to_read;
+
+	/* Each line starts with the aligned offset (20-bit address) */
+	cnt = print_to_log(log, "%5.5X ", offset & 0xffff0);
+	if (cnt == 0)
+		goto done;
+
+	/* If the offset is unaligned, add padding to right justify items */
+	for (i = 0; i < padding; ++i) {
+		cnt = print_to_log(log, "-- ");
+		if (cnt == 0)
+			goto done;
+	}
+
+	/* Log the data items */
+	for (j = 0; i < items_to_log; ++i, ++j) {
+		cnt = print_to_log(log, "%2.2X ", data[j]);
+		if (cnt == 0)
+			goto done;
+	}
+
+	/* If the last character was a space, then replace it with a newline */
+	if (log->wpos > 0 && log->data[log->wpos - 1] == ' ')
+		log->data[log->wpos - 1] = '\n';
+
+done:
+	return cnt;
+}
+
+/**
+ * write_raw_data_to_log: Writes a single "line" of data into the log buffer
+ * @trans: Pointer to SPMI transaction data.
+ * @offset: SPMI address offset to start reading from.
+ * @pcnt: Pointer to 'cnt' variable.  Indicates the number of bytes to read.
+ *
+ * The 'offset' is a 20-bits SPMI address which includes a 4-bit slave id (SID),
+ * an 8-bit peripheral id (PID), and an 8-bit peripheral register address.
+ *
+ * On a successful read, the pcnt is decremented by the number of data
+ * bytes read across the SPMI bus.  When the cnt reaches 0, all requested
+ * bytes have been read.
+ */
+static int
+write_raw_data_to_log(struct spmi_trans *trans, int offset, size_t *pcnt)
+{
+	u8  data[16];
+	struct spmi_log_buffer *log = trans->log;
+
+	int i;
+	int cnt = 0;
+	int items_to_read = min(ARRAY_SIZE(data), *pcnt);
+
+	/* Buffer needs enough space for an entire line */
+	if ((log->len - log->wpos) < 80)
+		goto done;
+
+	/* Read the desired number of "items" */
+	if (spmi_read_data(trans->sdev, data, offset, items_to_read))
+		goto done;
+
+	*pcnt -= items_to_read;
+
+	/* Log the data items */
+	for (i = 0; i < items_to_read; ++i) {
+		cnt = print_to_log(log, "0x%2.2X ", data[i]);
+		if (cnt == 0)
+			goto done;
+	}
+
+	/* If the last character was a space, then replace it with a newline */
+	if (log->wpos > 0 && log->data[log->wpos - 1] == ' ')
+		log->data[log->wpos - 1] = '\n';
+
+done:
+	return cnt;
+}
+
+/**
+ * get_log_data - reads data across the SPMI bus and saves to the log buffer
+ * @trans: Pointer to SPMI transaction data.
+ *
+ * Returns the number of "items" read or SPMI error code for read failures.
+ */
+static int get_log_data(struct spmi_trans *trans)
+{
+	int cnt;
+	int last_cnt;
+	int items_read;
+	int total_items_read = 0;
+	u32 offset = trans->offset;
+	size_t item_cnt = trans->cnt;
+	struct spmi_log_buffer *log = trans->log;
+	int (*write_to_log)(struct spmi_trans *, int, size_t *);
+
+	if (item_cnt == 0)
+		return 0;
+
+	if (trans->raw_data)
+		write_to_log = write_raw_data_to_log;
+	else
+		write_to_log = write_next_line_to_log;
+
+	/* Reset the log buffer 'pointers' */
+	log->wpos = log->rpos = 0;
+
+	/* Keep reading data until the log is full */
+	do {
+		last_cnt = item_cnt;
+		cnt = write_to_log(trans, offset, &item_cnt);
+		items_read = last_cnt - item_cnt;
+		offset += items_read;
+		total_items_read += items_read;
+	} while (cnt && item_cnt > 0);
+
+	/* Adjust the transaction offset and count */
+	trans->cnt = item_cnt;
+	trans->offset += total_items_read;
+
+	return total_items_read;
+}
+
+static ssize_t spmi_device_dfs_reg_write(struct file *file,
+					 const char __user *buf,
+					 size_t count, loff_t *ppos)
+{
+	int bytes_read;
+	int data;
+	int pos = 0;
+	int cnt = 0;
+	u8  *values;
+	size_t ret = 0;
+
+	struct spmi_trans *trans = file->private_data;
+	u32 offset = trans->offset;
+
+	/* Make a copy of the user data */
+	char *kbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	ret = copy_from_user(kbuf, buf, count);
+	if (ret == count) {
+		pr_err("failed to copy data from user\n");
+		ret = -EFAULT;
+		goto free_buf;
+	}
+
+	count -= ret;
+	*ppos += count;
+	kbuf[count] = '\0';
+
+	/* Override the text buffer with the raw data */
+	values = kbuf;
+
+	/* Parse the data in the buffer.  It should be a string of numbers */
+	while (sscanf(kbuf + pos, "%i%n", &data, &bytes_read) == 1) {
+		pos += bytes_read;
+		values[cnt++] = data & 0xff;
+	}
+
+	if (!cnt)
+		goto free_buf;
+
+	/* Perform the SPMI write(s) */
+	ret = spmi_write_data(trans->sdev, values, offset, cnt);
+
+	if (ret) {
+		pr_err("SPMI write failed, err = %zu\n", ret);
+	} else {
+		ret = count;
+		trans->offset += cnt;
+	}
+
+free_buf:
+	kfree(kbuf);
+	return ret;
+}
+
+static ssize_t spmi_device_dfs_reg_read(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct spmi_trans *trans = file->private_data;
+	struct spmi_log_buffer *log = trans->log;
+	size_t ret;
+	size_t len;
+
+	/* Is the the log buffer empty */
+	if (log->rpos >= log->wpos) {
+		if (get_log_data(trans) <= 0)
+			return 0;
+	}
+
+	len = min(count, (size_t) log->wpos - log->rpos);
+
+	ret = copy_to_user(buf, &log->data[log->rpos], len);
+	if (ret == len) {
+		pr_err("error copy SPMI register values to user\n");
+		return -EFAULT;
+	}
+
+	/* 'ret' is the number of bytes not copied */
+	len -= ret;
+
+	*ppos += len;
+	log->rpos += len;
+	return len;
+}
+
+static const struct file_operations spmi_dfs_reg_fops = {
+	.open		= spmi_device_dfs_data_open,
+	.release	= spmi_device_dfs_close,
+	.read		= spmi_device_dfs_reg_read,
+	.write		= spmi_device_dfs_reg_write,
+};
+
+static const struct file_operations spmi_dfs_raw_data_fops = {
+	.open		= spmi_device_dfs_raw_data_open,
+	.release	= spmi_device_dfs_close,
+	.read		= spmi_device_dfs_reg_read,
+	.write		= spmi_device_dfs_reg_write,
+};
+
+void spmi_dfs_add_controller(struct spmi_controller *ctrl)
+{
+	ctrl->dfs_dir = debugfs_create_dir(dev_name(&ctrl->dev),
+					   spmi_debug_root);
+	WARN_ON(!ctrl->dfs_dir);
+
+	dev_dbg(&ctrl->dev, "adding debug entries for spmi controller\n");
+}
+
+void spmi_dfs_del_controller(struct spmi_controller *ctrl)
+{
+	debugfs_remove_recursive(ctrl->dfs_dir);
+}
+
+void spmi_dfs_add_device(struct spmi_device *sdev)
+{
+	struct dentry *file;
+
+	dev_dbg(&sdev->dev, "adding debugfs entries for spmi device\n");
+
+	sdev->dfs_dir = debugfs_create_dir(dev_name(&sdev->dev),
+					   sdev->ctrl->dfs_dir);
+	if (WARN_ON(!sdev->dfs_dir))
+		return;
+
+	sdev->dfs_cnt  = 1;
+
+	file = debugfs_create_u32("count", DFS_MODE, sdev->dfs_dir,
+				  &sdev->dfs_cnt);
+	if (WARN_ON(!file))
+		goto err_remove_fs;
+
+	file = debugfs_create_x32("address", DFS_MODE, sdev->dfs_dir,
+				  &sdev->dfs_addr);
+	if (WARN_ON(!file))
+		goto err_remove_fs;
+
+	file = debugfs_create_file("data", DFS_MODE, sdev->dfs_dir, sdev,
+				   &spmi_dfs_reg_fops);
+	if (WARN_ON(!file))
+		goto err_remove_fs;
+
+	file = debugfs_create_file("data_raw", DFS_MODE, sdev->dfs_dir,
+				   sdev, &spmi_dfs_raw_data_fops);
+	if (WARN_ON(!file))
+		goto err_remove_fs;
+
+	return;
+
+err_remove_fs:
+	debugfs_remove_recursive(sdev->dfs_dir);
+}
+
+void spmi_dfs_del_device(struct spmi_device *sdev)
+{
+	dev_dbg(&sdev->dev, "Deleting device\n");
+	debugfs_remove_recursive(sdev->dfs_dir);
+}
+
+void __exit spmi_dfs_exit(void)
+{
+	pr_debug("de-initializing spmi debugfs ...");
+	debugfs_remove_recursive(spmi_debug_root);
+}
+
+void __init spmi_dfs_init(void)
+{
+	struct dentry *help;
+
+	pr_debug("creating SPMI debugfs file-system\n");
+
+	spmi_debug_root = debugfs_create_dir("spmi", NULL);
+
+	help = debugfs_create_blob("help", S_IRUGO, spmi_debug_root,
+				   &spmi_debug_help);
+
+	WARN_ON(!spmi_debug_root || !help);
+}
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/spmi/spmi-dbgfs.h b/drivers/spmi/spmi-dbgfs.h
new file mode 100644
index 0000000..896bb5a
--- /dev/null
+++ b/drivers/spmi/spmi-dbgfs.h
@@ -0,0 +1,37 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _SPMI_DBGFS_H
+#define _SPMI_DBGFS_H
+
+#include <linux/spmi.h>
+#include <linux/debugfs.h>
+
+#ifdef CONFIG_DEBUG_FS
+
+extern void __init spmi_dfs_init(void);
+extern void __exit spmi_dfs_exit(void);
+extern void spmi_dfs_add_controller(struct spmi_controller *ctrl);
+extern void spmi_dfs_del_controller(struct spmi_controller *ctrl);
+extern void spmi_dfs_add_device(struct spmi_device *sdev);
+extern void spmi_dfs_del_device(struct spmi_device *sdev);
+
+#else
+
+static inline void __init spmi_dfs_init(void) { }
+static inline void __exit spmi_dfs_exit(void) { }
+static inline void spmi_dfs_add_controller(struct spmi_controller *ctrl) { }
+static inline void spmi_dfs_del_controller(struct spmi_controller *ctrl) { }
+static inline void spmi_dfs_add_device(struct spmi_device *sdev) { }
+static inline void spmi_dfs_del_device(struct spmi_device *sdev) { }
+#endif
+
+#endif /* _SPMI_DBGFS_H */
diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
new file mode 100644
index 0000000..3bbcc63
--- /dev/null
+++ b/drivers/spmi/spmi.c
@@ -0,0 +1,449 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/spmi.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+
+#include "spmi-dbgfs.h"
+
+static DEFINE_MUTEX(board_lock);
+static DEFINE_IDR(ctrl_idr);
+
+static void spmi_dev_release(struct device *dev)
+{
+	struct spmi_device *spmidev = to_spmi_device(dev);
+	kfree(spmidev);
+}
+
+static struct device_type spmi_dev_type = {
+	.release	= spmi_dev_release,
+};
+
+static void spmi_ctrl_release(struct device *dev)
+{
+	struct spmi_controller *ctrl = to_spmi_controller(dev);
+	complete(&ctrl->dev_released);
+}
+
+static struct device_type spmi_ctrl_type = {
+	.release	= spmi_ctrl_release,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int spmi_pm_suspend(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm)
+		return pm_generic_suspend(dev);
+	else
+		return 0;
+}
+
+static int spmi_pm_resume(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm)
+		return pm_generic_resume(dev);
+	else
+		return 0;
+}
+#else
+#define spmi_pm_suspend		NULL
+#define spmi_pm_resume		NULL
+#endif
+
+static const struct dev_pm_ops spmi_pm_ops = {
+	.suspend	= spmi_pm_suspend,
+	.resume		= spmi_pm_resume,
+	SET_RUNTIME_PM_OPS(
+		pm_generic_suspend,
+		pm_generic_resume,
+		pm_generic_runtime_idle
+	)
+};
+
+static int spmi_device_match(struct device *dev, struct device_driver *drv)
+{
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
+	if (drv->name)
+		return strncmp(dev_name(dev), drv->name,
+			       SPMI_NAME_SIZE) == 0;
+
+	return 0;
+}
+
+/* Remove a device associated with a controller */
+static int spmi_ctrl_remove_device(struct device *dev, void *data)
+{
+	struct spmi_device *spmidev = to_spmi_device(dev);
+	struct spmi_controller *ctrl = data;
+
+	if (dev->type == &spmi_dev_type && spmidev->ctrl == ctrl)
+		spmi_remove_device(spmidev);
+
+	return 0;
+}
+
+int spmi_controller_add_device(struct spmi_controller *ctrl,
+			       struct spmi_device *sdev)
+{
+	int err;
+
+	sdev->ctrl = ctrl;
+	sdev->dev.parent = &ctrl->dev;
+
+	dev_set_name(&sdev->dev, "%d-%02x", ctrl->nr, sdev->usid);
+
+	err = device_add(&sdev->dev);
+	if (err < 0) {
+		dev_err(&sdev->dev, "Can't add %s, status %d\n",
+			dev_name(&sdev->dev), err);
+		goto err_device_add;
+	}
+
+	spmi_dfs_add_device(sdev);
+
+	dev_dbg(&sdev->dev, "device %s registered\n", dev_name(&sdev->dev));
+
+err_device_add:
+	return err;
+}
+EXPORT_SYMBOL_GPL(spmi_controller_add_device);
+
+void spmi_remove_device(struct spmi_device *sdev)
+{
+	device_unregister(&sdev->dev);
+}
+EXPORT_SYMBOL_GPL(spmi_remove_device);
+
+static inline int
+spmi_cmd(struct spmi_controller *ctrl, u8 opcode, u8 sid)
+{
+	if (!ctrl || !ctrl->cmd || ctrl->dev.type != &spmi_ctrl_type)
+		return -EINVAL;
+
+	return ctrl->cmd(ctrl, opcode, sid);
+}
+
+static inline int spmi_read_cmd(struct spmi_controller *ctrl,
+				u8 opcode, u8 sid, u16 addr, u8 bc, u8 *buf)
+{
+	if (!ctrl || !ctrl->read_cmd || ctrl->dev.type != &spmi_ctrl_type)
+		return -EINVAL;
+
+	return ctrl->read_cmd(ctrl, opcode, sid, addr, bc, buf);
+}
+
+static inline int spmi_write_cmd(struct spmi_controller *ctrl,
+				 u8 opcode, u8 sid, u16 addr, u8 bc, u8 *buf)
+{
+	if (!ctrl || !ctrl->write_cmd || ctrl->dev.type != &spmi_ctrl_type)
+		return -EINVAL;
+
+	return ctrl->write_cmd(ctrl, opcode, sid, addr, bc, buf);
+}
+
+/*
+ * register read/write: 5-bit address, 1 byte of data
+ * extended register read/write: 8-bit address, up to 16 bytes of data
+ * extended register read/write long: 16-bit address, up to 8 bytes of data
+ */
+
+int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf)
+{
+	/* 5-bit register address */
+	if (addr > 0x1F)
+		return -EINVAL;
+
+	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_READ, sdev->usid, addr, 0,
+			     buf);
+}
+EXPORT_SYMBOL_GPL(spmi_register_read);
+
+int spmi_ext_register_read(struct spmi_device *sdev, u8 addr, u8 *buf,
+			   size_t len)
+{
+	/* 8-bit register address, up to 16 bytes */
+	if (len == 0 || len > 16)
+		return -EINVAL;
+
+	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_EXT_READ, sdev->usid, addr,
+			     len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_read);
+
+int spmi_ext_register_readl(struct spmi_device *sdev, u16 addr, u8 *buf,
+			    size_t len)
+{
+	/* 16-bit register address, up to 8 bytes */
+	if (len == 0 || len > 8)
+		return -EINVAL;
+
+	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_EXT_READL, sdev->usid, addr,
+			     len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_readl);
+
+int spmi_register_write(struct spmi_device *sdev, u8 addr, u8 *buf)
+{
+	/* 5-bit register address */
+	if (addr > 0x1F)
+		return -EINVAL;
+
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_WRITE, sdev->usid, addr, 0,
+			      buf);
+}
+EXPORT_SYMBOL_GPL(spmi_register_write);
+
+int spmi_register_zero_write(struct spmi_device *sdev, u8 data)
+{
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_ZERO_WRITE, sdev->usid, 0,
+			      0, &data);
+}
+EXPORT_SYMBOL_GPL(spmi_register_zero_write);
+
+int spmi_ext_register_write(struct spmi_device *sdev, u8 addr, u8 *buf,
+			    size_t len)
+{
+	/* 8-bit register address, up to 16 bytes */
+	if (len == 0 || len > 16)
+		return -EINVAL;
+
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_EXT_WRITE, sdev->usid, addr,
+			      len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_write);
+
+int spmi_ext_register_writel(struct spmi_device *sdev, u16 addr, u8 *buf,
+			     size_t len)
+{
+	/* 4-bit Slave Identifier, 16-bit register address, up to 8 bytes */
+	if (len == 0 || len > 8)
+		return -EINVAL;
+
+	return spmi_write_cmd(sdev->ctrl, SPMI_CMD_EXT_WRITEL, sdev->usid,
+			      addr, len - 1, buf);
+}
+EXPORT_SYMBOL_GPL(spmi_ext_register_writel);
+
+int spmi_command_reset(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_RESET, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_reset);
+
+int spmi_command_sleep(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_SLEEP, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_sleep);
+
+int spmi_command_wakeup(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_WAKEUP, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_wakeup);
+
+int spmi_command_shutdown(struct spmi_device *sdev)
+{
+	return spmi_cmd(sdev->ctrl, SPMI_CMD_SHUTDOWN, sdev->usid);
+}
+EXPORT_SYMBOL_GPL(spmi_command_shutdown);
+
+static int spmi_drv_probe(struct device *dev)
+{
+	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
+	int err = 0;
+
+	if (sdrv->probe)
+		err = sdrv->probe(to_spmi_device(dev));
+
+	return err;
+}
+
+static int spmi_drv_remove(struct device *dev)
+{
+	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
+	int err = 0;
+
+	if (sdrv->remove)
+		err = sdrv->remove(to_spmi_device(dev));
+
+	return err;
+}
+
+static void spmi_drv_shutdown(struct device *dev)
+{
+	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
+
+	if (sdrv->shutdown)
+		sdrv->shutdown(to_spmi_device(dev));
+}
+
+static struct bus_type spmi_bus_type = {
+	.name		= "spmi",
+	.match		= spmi_device_match,
+	.pm		= &spmi_pm_ops,
+	.probe		= spmi_drv_probe,
+	.remove		= spmi_drv_remove,
+	.shutdown	= spmi_drv_shutdown,
+};
+
+/**
+ * spmi_device_initialize: initialize a new SPMI device.
+ * @sdev: device which is to be initialized
+ *
+ * Caller is responsible to call spmi_controller_add_device() on the returned
+ * spmi_device.
+ */
+void spmi_device_initialize(struct spmi_device *sdev)
+{
+	sdev->dev.bus = &spmi_bus_type;
+	sdev->dev.type = &spmi_dev_type;
+	device_initialize(&sdev->dev);
+}
+EXPORT_SYMBOL_GPL(spmi_device_initialize);
+
+static int spmi_register_controller(struct spmi_controller *ctrl)
+{
+	int ret;
+
+	/* Can't register until after driver model init */
+	if (WARN_ON(!spmi_bus_type.p)) {
+		ret = -EAGAIN;
+		goto exit;
+	}
+
+	dev_set_name(&ctrl->dev, "spmi-%d", ctrl->nr);
+	ctrl->dev.bus = &spmi_bus_type;
+	ctrl->dev.type = &spmi_ctrl_type;
+	ret = device_register(&ctrl->dev);
+	if (ret)
+		goto exit;
+
+	spmi_dfs_add_controller(ctrl);
+
+	dev_dbg(&ctrl->dev, "Bus spmi-%d registered: dev:%p\n",
+		ctrl->nr, &ctrl->dev);
+
+	return 0;
+
+exit:
+	mutex_lock(&board_lock);
+	idr_remove(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&board_lock);
+	return ret;
+}
+
+int spmi_add_controller(struct spmi_controller *ctrl)
+{
+	int id;
+
+	pr_debug("adding controller for bus %d (0x%p)\n", ctrl->nr, ctrl);
+
+	if (((int)ctrl->nr) < 0) {
+		pr_err("invalid bus identifier %d\n", ctrl->nr);
+		return -EINVAL;
+	}
+
+	idr_preload(GFP_KERNEL);
+	mutex_lock(&board_lock);
+	id = idr_alloc(&ctrl_idr, ctrl, ctrl->nr, ctrl->nr + 1, GFP_NOWAIT);
+	mutex_unlock(&board_lock);
+	idr_preload_end();
+
+	if (id < 0) {
+		pr_err(
+		   "idr_alloc(start:%d end:%d):%d at spmi_add_controller()\n",
+		   ctrl->nr, ctrl->nr, id);
+		return id;
+	}
+
+	return spmi_register_controller(ctrl);
+};
+EXPORT_SYMBOL_GPL(spmi_add_controller);
+
+/**
+ * spmi_del_controller: Controller tear-down.
+ * @ctrl: controller to be removed.
+ *
+ * Controller added with the above API is torn down using this API.
+ */
+int spmi_del_controller(struct spmi_controller *ctrl)
+{
+	struct spmi_controller *found;
+
+	if (!ctrl)
+		return -EINVAL;
+
+	/* Check that the ctrl has been added */
+	mutex_lock(&board_lock);
+	found = idr_find(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&board_lock);
+
+	if (found != ctrl)
+		return -EINVAL;
+
+	spmi_dfs_del_controller(ctrl);
+
+	/* Remove all the clients associated with this controller */
+	mutex_lock(&board_lock);
+	bus_for_each_dev(&spmi_bus_type, NULL, ctrl, spmi_ctrl_remove_device);
+	idr_remove(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&board_lock);
+
+	init_completion(&ctrl->dev_released);
+	device_unregister(&ctrl->dev);
+	wait_for_completion(&ctrl->dev_released);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spmi_del_controller);
+
+int spmi_driver_register(struct spmi_driver *drv)
+{
+	drv->driver.bus = &spmi_bus_type;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(spmi_driver_register);
+
+static void __exit spmi_exit(void)
+{
+	bus_unregister(&spmi_bus_type);
+	spmi_dfs_exit();
+}
+module_exit(spmi_exit);
+
+static int __init spmi_init(void)
+{
+	spmi_dfs_init();
+	return bus_register(&spmi_bus_type);
+}
+postcore_initcall(spmi_init);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("SPMI module");
+MODULE_ALIAS("platform:spmi");
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..677e474 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -432,6 +432,14 @@ struct spi_device_id {
 	kernel_ulong_t driver_data;	/* Data private to the driver */
 };
 
+#define SPMI_NAME_SIZE	32
+#define SPMI_MODULE_PREFIX "spmi:"
+
+struct spmi_device_id {
+	char name[SPMI_NAME_SIZE];
+	kernel_ulong_t driver_data;	/* Data private to the driver */
+};
+
 /* dmi */
 enum dmi_field {
 	DMI_NONE,
diff --git a/include/linux/of_spmi.h b/include/linux/of_spmi.h
new file mode 100644
index 0000000..6965d7d
--- /dev/null
+++ b/include/linux/of_spmi.h
@@ -0,0 +1,37 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _LINUX_OF_SPMI
+#define _LINUX_OF_SPMI
+
+struct spmi_controller;
+
+#ifdef CONFIG_OF_SPMI
+/**
+ * of_spmi_register_devices() - Register devices in the SPMI Device Tree
+ * @ctrl: spmi_controller which devices should be registered to.
+ *
+ * This routine scans the SPMI Device Tree, allocating resources and
+ * creating spmi_devices according to the SPMI bus Device Tree
+ * hierarchy. Details of this hierarchy can be found in
+ * Documentation/devicetree/bindings/spmi. This routine is normally
+ * called from the probe routine of the driver registering as a
+ * spmi_controller.
+ */
+int of_spmi_register_devices(struct spmi_controller *ctrl);
+#else
+static int of_spmi_register_devices(struct spmi_controller *ctrl)
+{
+	return -ENXIO;
+}
+#endif /* CONFIG_OF_SPMI */
+
+#endif
diff --git a/include/linux/spmi.h b/include/linux/spmi.h
new file mode 100644
index 0000000..091d82bf
--- /dev/null
+++ b/include/linux/spmi.h
@@ -0,0 +1,337 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _LINUX_SPMI_H
+#define _LINUX_SPMI_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+
+/* Maximum slave identifier */
+#define SPMI_MAX_SLAVE_ID		16
+
+/* SPMI Commands */
+#define SPMI_CMD_EXT_WRITE		0x00
+#define SPMI_CMD_RESET			0x10
+#define SPMI_CMD_SLEEP			0x11
+#define SPMI_CMD_SHUTDOWN		0x12
+#define SPMI_CMD_WAKEUP			0x13
+#define SPMI_CMD_AUTHENTICATE		0x14
+#define SPMI_CMD_MSTR_READ		0x15
+#define SPMI_CMD_MSTR_WRITE		0x16
+#define SPMI_CMD_TRANSFER_BUS_OWNERSHIP	0x1A
+#define SPMI_CMD_DDB_MASTER_READ	0x1B
+#define SPMI_CMD_DDB_SLAVE_READ		0x1C
+#define SPMI_CMD_EXT_READ		0x20
+#define SPMI_CMD_EXT_WRITEL		0x30
+#define SPMI_CMD_EXT_READL		0x38
+#define SPMI_CMD_WRITE			0x40
+#define SPMI_CMD_READ			0x60
+#define SPMI_CMD_ZERO_WRITE		0x80
+
+/**
+ * Client/device handle (struct spmi_device):
+ *  This is the client/device handle returned when a SPMI device
+ *  is registered with a controller.
+ *  Pointer to this structure is used by client-driver as a handle.
+ *  @dev: Driver model representation of the device.
+ *  @ctrl: SPMI controller managing the bus hosting this device.
+ *  @usid: Unique Slave IDentifier.
+ *  @dfs_dir: dentry for this device in debugfs
+ *  @dfs_cnt: number of bytes to access for a debugfs operation
+ *  @dfs_addr: address to access for a debugfs operation
+ */
+struct spmi_device {
+	struct device		dev;
+	struct spmi_controller	*ctrl;
+	u8			usid;
+
+#if CONFIG_DEBUG_FS
+	struct dentry		*dfs_dir;
+	u32			dfs_cnt;
+	u32			dfs_addr;
+#endif
+};
+#define to_spmi_device(d) container_of(d, struct spmi_device, dev)
+
+static inline void *spmi_device_getdata(const struct spmi_device *sdev)
+{
+	return dev_get_drvdata(&sdev->dev);
+}
+
+static inline void spmi_device_setdata(struct spmi_device *sdev, void *data)
+{
+	dev_set_drvdata(&sdev->dev, data);
+}
+
+static inline void spmi_device_put(struct spmi_device *sdev)
+{
+	if (sdev)
+		put_device(&sdev->dev);
+}
+
+/**
+ * struct spmi_controller: interface to the SPMI master controller
+ * @dev: Driver model representation of the device.
+ * @nr: board-specific number identifier for this controller/bus
+ * @dev_released: completion used during controller teardown
+ * @dfs_dir: dentry for controller directory in debugfs
+ * @cmd: sends a non-data command sequence on the SPMI bus.
+ * @read_cmd: sends a register read command sequence on the SPMI bus.
+ * @write_cmd: sends a register write command sequence on the SPMI bus.
+ */
+struct spmi_controller {
+	struct device		dev;
+	unsigned int		nr;
+	struct completion	dev_released;
+	struct dentry		*dfs_dir;
+	int	(*cmd)(struct spmi_controller *ctrl, u8 opcode, u8 sid);
+	int	(*read_cmd)(struct spmi_controller *ctrl, u8 opcode,
+			    u8 sid, u16 addr, u8 bc, u8 *buf);
+	int	(*write_cmd)(struct spmi_controller *ctrl, u8 opcode,
+			     u8 sid, u16 addr, u8 bc, u8 *buf);
+};
+#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)
+
+static inline void *spmi_get_ctrldata(const struct spmi_controller *ctrl)
+{
+	return dev_get_drvdata(&ctrl->dev);
+}
+
+static inline void spmi_set_ctrldata(struct spmi_controller *ctrl, void *data)
+{
+	dev_set_drvdata(&ctrl->dev, data);
+}
+
+/**
+ * struct spmi_driver: Manage SPMI generic/slave device driver
+ * @driver: SPMI device drivers should initialize name and owner field of
+ *	    this structure
+ * @probe: binds this driver to a SPMI device.
+ * @remove: unbinds this driver from the SPMI device.
+ * @shutdown: standard shutdown callback used during powerdown/halt.
+ * @suspend: standard suspend callback used during system suspend
+ * @resume: standard resume callback used during system resume
+ */
+struct spmi_driver {
+	struct device_driver		driver;
+	int	(*probe)(struct spmi_device *sdev);
+	int	(*remove)(struct spmi_device *sdev);
+	void	(*shutdown)(struct spmi_device *sdev);
+	int	(*suspend)(struct spmi_device *sdev, pm_message_t pmesg);
+	int	(*resume)(struct spmi_device *sdev);
+};
+#define to_spmi_driver(d) container_of(d, struct spmi_driver, driver)
+
+/**
+ * spmi_driver_register: Client driver registration with SPMI framework.
+ * @sdrv: client driver to be associated with client-device.
+ *
+ * This API will register the client driver with the SPMI framework.
+ * It is called from the driver's module-init function.
+ */
+extern int spmi_driver_register(struct spmi_driver *sdrv);
+
+/**
+ * spmi_driver_unregister - reverse effect of spmi_driver_register
+ * @sdrv: the driver to unregister
+ * Context: can sleep
+ */
+static inline void spmi_driver_unregister(struct spmi_driver *sdrv)
+{
+	if (sdrv)
+		driver_unregister(&sdrv->driver);
+}
+
+#define module_spmi_driver(__spmi_driver) \
+	module_driver(__spmi_driver, spmi_driver_register, \
+			spmi_driver_unregister)
+
+/**
+ * spmi_add_controller: Controller bring-up.
+ * @ctrl: controller to be registered.
+ *
+ * A controller is registered with the framework using this API. ctrl->nr is the
+ * desired number with which SPMI framework registers the controller.
+ * Function will return -EBUSY if the number is in use.
+ */
+extern int spmi_add_controller(struct spmi_controller *ctrl);
+
+/**
+ * spmi_del_controller: Controller tear-down.
+ * Controller added with the above API is torn down using this API.
+ */
+extern int spmi_del_controller(struct spmi_controller *ctrl);
+
+/**
+ * spmi_device_initialize - initialize spmi_device
+ * @sdev: spmi_device to be initialized
+ *
+ * Caller is responsible for calling spmi_controller_add_device()
+ */
+extern void spmi_device_initialize(struct spmi_device *sdev);
+
+/**
+ * spmi_controller_add_device: Add spmi_device attached to the given controller
+ * @ctrl: controlling master device
+ * @sdev: spmi_device to be added (registered).
+ */
+extern int spmi_controller_add_device(struct spmi_controller *ctrl,
+				      struct spmi_device *sdev);
+
+/**
+ * spmi_remove_device: remove a device
+ * @sdev: spmi_device to be removed
+ */
+extern void spmi_remove_device(struct spmi_device *sdev);
+
+/**
+ * spmi_register_read() - register read
+ * @sdev: SPMI device
+ * @addr: slave register address (5-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ *
+ * Reads 1 byte of data from a Slave device register.
+ */
+extern int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf);
+
+/**
+ * spmi_ext_register_read() - extended register read
+ * @sdev: SPMI device
+ * @addr: slave register address (8-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ * @len: the request number of bytes to read (up to 16 bytes).
+ *
+ * Reads up to 16 bytes of data from the extended register space on a
+ * Slave device.
+ */
+extern int spmi_ext_register_read(struct spmi_device *sdev, u8 addr, u8 *buf,
+				  size_t len);
+
+/**
+ * spmi_ext_register_readl() - extended register read long
+ * @sdev: SPMI device
+ * @addr: slave register address (16-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ * @len: the request number of bytes to read (up to 8 bytes).
+ *
+ * Reads up to 8 bytes of data from the extended register space on a
+ * Slave device using 16-bit address.
+ */
+extern int spmi_ext_register_readl(struct spmi_device *sdev, u16 addr, u8 *buf,
+				   size_t len);
+
+/**
+ * spmi_register_write() - register write
+ * @sdev: SPMI device
+ * @addr: slave register address (5-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ *
+ * Writes 1 byte of data to a Slave device register.
+ */
+extern int spmi_register_write(struct spmi_device *sdev, u8 addr, u8 *buf);
+
+/**
+ * spmi_register_zero_write() - register zero write
+ * @sdev: SPMI device
+ * @data: the data to be written to register 0 (7-bits).
+ *
+ * Writes data to register 0 of the Slave device.
+ */
+extern int spmi_register_zero_write(struct spmi_device *sdev, u8 data);
+
+/**
+ * spmi_ext_register_write() - extended register write
+ * @sdev: SPMI device
+ * @addr: slave register address (8-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ * @len: the request number of bytes to read (up to 16 bytes).
+ *
+ * Writes up to 16 bytes of data to the extended register space of a
+ * Slave device.
+ */
+extern int spmi_ext_register_write(struct spmi_device *sdev, u8 addr, u8 *buf,
+				   size_t len);
+
+/**
+ * spmi_ext_register_writel() - extended register write long
+ * @sdev: SPMI device
+ * @addr: slave register address (16-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ * @len: the request number of bytes to read (up to 8 bytes).
+ *
+ * Writes up to 8 bytes of data to the extended register space of a
+ * Slave device using 16-bit address.
+ */
+extern int spmi_ext_register_writel(struct spmi_device *sdev, u16 addr,
+				    u8 *buf, size_t len);
+
+/**
+ * spmi_command_reset() - sends RESET command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Reset command initializes the Slave and forces all registers to
+ * their reset values. The Slave shall enter the STARTUP state after
+ * receiving a Reset command.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+extern int spmi_command_reset(struct spmi_device *sdev);
+
+/**
+ * spmi_command_sleep() - sends SLEEP command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Sleep command causes the Slave to enter the user defined SLEEP state.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+extern int spmi_command_sleep(struct spmi_device *sdev);
+
+/**
+ * spmi_command_wakeup() - sends WAKEUP command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Wakeup command causes the Slave to move from the SLEEP state to
+ * the ACTIVE state.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+extern int spmi_command_wakeup(struct spmi_device *sdev);
+
+/**
+ * spmi_command_shutdown() - sends SHUTDOWN command to the specified slave
+ * @sdev: SPMI device
+ *
+ * The Shutdown command causes the Slave to enter the SHUTDOWN state.
+ *
+ * Returns
+ * -EINVAL for invalid slave identifier.
+ * -EPERM if the SPMI transaction is denied due to permission issues.
+ * -EIO if the SPMI transaction fails (parity errors, etc).
+ * -ETIMEDOUT if the SPMI transaction times out.
+ */
+extern int spmi_command_shutdown(struct spmi_device *sdev);
+
+#endif
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


