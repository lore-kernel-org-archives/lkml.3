Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3HVW6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:58:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56759 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3HVW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:57:05 -0400
Message-Id: <46db5901fe4d04d09cee8fd81ea1c62068ee9503.1377202730.git.joshc@codeaurora.org>
In-Reply-To: <cover.1377202730.git.joshc@codeaurora.org>
References: <cover.1377202730.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Fri, 9 Aug 2013 13:37:09 -0700
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH RFC v2 2/5] spmi: Linux driver framework for SPMI
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
 drivers/spmi/Kconfig            |   9 +
 drivers/spmi/Makefile           |   4 +
 drivers/spmi/spmi-dbgfs.c       | 580 ++++++++++++++++++++++++++++++++++++++++
 drivers/spmi/spmi-dbgfs.h       |  25 ++
 drivers/spmi/spmi.c             | 491 ++++++++++++++++++++++++++++++++++
 include/linux/mod_devicetable.h |   8 +
 include/linux/spmi.h            | 355 ++++++++++++++++++++++++
 9 files changed, 1475 insertions(+)
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-dbgfs.c
 create mode 100644 drivers/spmi/spmi-dbgfs.h
 create mode 100644 drivers/spmi/spmi.c
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
index 0000000..9d78ec9
--- /dev/null
+++ b/drivers/spmi/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for kernel SPMI framework.
+#
+obj-$(CONFIG_SPMI)	+= spmi.o spmi-dbgfs.o
diff --git a/drivers/spmi/spmi-dbgfs.c b/drivers/spmi/spmi-dbgfs.c
new file mode 100644
index 0000000..8b6f0e3
--- /dev/null
+++ b/drivers/spmi/spmi-dbgfs.c
@@ -0,0 +1,580 @@
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
+			dev_err(&sdev->dev,
+				"SPMI read failed, err = %d\n", ret);
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
+			dev_err(&sdev->dev,
+				"SPMI write failed, err = %d\n", ret);
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
+	struct spmi_device *sdev = trans->sdev;
+	u32 offset = trans->offset;
+
+	/* Make a copy of the user data */
+	char *kbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	if (copy_from_user(kbuf, buf, count)) {
+		ret = -EFAULT;
+		goto free_buf;
+	}
+
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
+		dev_err(&sdev->dev, "SPMI write failed, err = %zu\n", ret);
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
+	struct spmi_device *sdev = trans->sdev;
+	struct spmi_log_buffer *log = trans->log;
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
+	if (copy_to_user(buf, &log->data[log->rpos], len))
+		return -EFAULT;
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
+void spmi_dfs_controller_add(struct spmi_controller *ctrl)
+{
+	ctrl->dfs_dir = debugfs_create_dir(dev_name(&ctrl->dev),
+					   spmi_debug_root);
+	WARN_ON(!ctrl->dfs_dir);
+
+	dev_dbg(&ctrl->dev, "adding debug entries for spmi controller\n");
+}
+
+void spmi_dfs_controller_remove(struct spmi_controller *ctrl)
+{
+	debugfs_remove_recursive(ctrl->dfs_dir);
+}
+
+void spmi_dfs_device_add(struct spmi_device *sdev)
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
+void spmi_dfs_device_remove(struct spmi_device *sdev)
+{
+	dev_dbg(&sdev->dev, "Deleting device\n");
+	debugfs_remove_recursive(sdev->dfs_dir);
+}
+
+void __exit spmi_dfs_exit(void)
+{
+	debugfs_remove_recursive(spmi_debug_root);
+}
+
+void __init spmi_dfs_init(void)
+{
+	struct dentry *help;
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
index 0000000..d3162fb
--- /dev/null
+++ b/drivers/spmi/spmi-dbgfs.h
@@ -0,0 +1,25 @@
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
+struct spmi_controller;
+struct spmi_device;
+
+void __init spmi_dfs_init(void);
+void __exit spmi_dfs_exit(void);
+void spmi_dfs_controller_add(struct spmi_controller *ctrl);
+void spmi_dfs_controller_remove(struct spmi_controller *ctrl);
+void spmi_dfs_device_add(struct spmi_device *sdev);
+void spmi_dfs_device_remove(struct spmi_device *sdev);
+
+#endif /* _SPMI_DBGFS_H */
diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
new file mode 100644
index 0000000..c3da65e
--- /dev/null
+++ b/drivers/spmi/spmi.c
@@ -0,0 +1,491 @@
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
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/spmi.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+
+#include "spmi-dbgfs.h"
+
+static DEFINE_MUTEX(ctrl_idr_lock);
+static DEFINE_IDR(ctrl_idr);
+
+static void spmi_dev_release(struct device *dev)
+{
+	struct spmi_device *sdev = to_spmi_device(dev);
+	spmi_dfs_device_remove(sdev);
+	kfree(sdev);
+}
+
+static struct device_type spmi_dev_type = {
+	.release	= spmi_dev_release,
+};
+
+static void spmi_ctrl_release(struct device *dev)
+{
+	struct spmi_controller *ctrl = to_spmi_controller(dev);
+	spmi_dfs_controller_remove(ctrl);
+	mutex_lock(&ctrl_idr_lock);
+	idr_remove(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&ctrl_idr_lock);
+	kfree(ctrl);
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
+int spmi_device_add(struct spmi_device *sdev)
+{
+	struct spmi_controller *ctrl = sdev->ctrl;
+	int err;
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
+	spmi_dfs_device_add(sdev);
+
+	dev_dbg(&sdev->dev, "device %s registered\n", dev_name(&sdev->dev));
+
+err_device_add:
+	return err;
+}
+EXPORT_SYMBOL_GPL(spmi_device_add);
+
+void spmi_device_remove(struct spmi_device *sdev)
+{
+	device_unregister(&sdev->dev);
+}
+EXPORT_SYMBOL_GPL(spmi_device_remove);
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
+struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl)
+{
+	struct spmi_device *sdev;
+
+	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!sdev)
+		return NULL;
+
+	sdev->ctrl = ctrl;
+	device_initialize(&sdev->dev);
+	sdev->dev.parent = &ctrl->dev;
+	sdev->dev.bus = &spmi_bus_type;
+	sdev->dev.type = &spmi_dev_type;
+	return sdev;
+}
+EXPORT_SYMBOL_GPL(spmi_device_alloc);
+
+struct spmi_controller *spmi_controller_alloc(struct device *parent,
+					      size_t size)
+{
+	struct spmi_controller *ctrl;
+	int id;
+
+	if (WARN_ON(!parent))
+		return NULL;
+
+	ctrl = kzalloc(sizeof(*ctrl) + size, GFP_KERNEL);
+	if (!ctrl)
+		return NULL;
+
+	device_initialize(&ctrl->dev);
+	ctrl->dev.type = &spmi_ctrl_type;
+	ctrl->dev.bus = &spmi_bus_type;
+	ctrl->dev.parent = parent;
+	ctrl->dev.of_node = parent->of_node;
+	spmi_controller_set_drvdata(ctrl, &ctrl[1]);
+
+	idr_preload(GFP_KERNEL);
+	mutex_lock(&ctrl_idr_lock);
+	id = idr_alloc(&ctrl_idr, ctrl, 0, 0, GFP_NOWAIT);
+	mutex_unlock(&ctrl_idr_lock);
+	idr_preload_end();
+
+	if (id < 0) {
+		dev_err(parent,
+			"unable to allocate SPMI controller identifier.\n");
+		spmi_controller_put(ctrl);
+		return NULL;
+	}
+
+	ctrl->nr = id;
+	dev_set_name(&ctrl->dev, "spmi-%d", id);
+
+	dev_dbg(&ctrl->dev, "allocated controller 0x%p id %d\n", ctrl, id);
+	return ctrl;
+}
+EXPORT_SYMBOL_GPL(spmi_controller_alloc);
+
+static int of_spmi_register_devices(struct spmi_controller *ctrl)
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
+		sdev = spmi_device_alloc(ctrl);
+		if (!sdev)
+			continue;
+
+		sdev->dev.of_node = node;
+		sdev->usid = (u8) usid;
+
+		err = spmi_device_add(sdev);
+		if (err) {
+			dev_err(&sdev->dev,
+				"failure adding device. status %d\n", err);
+			spmi_device_put(sdev);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+int spmi_controller_add(struct spmi_controller *ctrl)
+{
+	int ret;
+
+	/* Can't register until after driver model init */
+	if (WARN_ON(!spmi_bus_type.p))
+		return -EAGAIN;
+
+	ret = device_add(&ctrl->dev);
+	if (ret)
+		return ret;
+
+	spmi_dfs_controller_add(ctrl);
+
+	if (IS_ENABLED(CONFIG_OF))
+		of_spmi_register_devices(ctrl);
+
+	dev_dbg(&ctrl->dev, "spmi-%d registered: dev:%p\n",
+		ctrl->nr, &ctrl->dev);
+
+	return 0;
+};
+EXPORT_SYMBOL_GPL(spmi_controller_add);
+
+/* Remove a device associated with a controller */
+static int spmi_ctrl_remove_device(struct device *dev, void *data)
+{
+	struct spmi_device *spmidev = to_spmi_device(dev);
+	if (dev->type == &spmi_dev_type)
+		spmi_device_remove(spmidev);
+	return 0;
+}
+
+/**
+ * spmi_controller_remove: Controller tear-down.
+ * @ctrl: controller to be removed.
+ *
+ * Controller added with the above API is torn down using this API.
+ */
+int spmi_controller_remove(struct spmi_controller *ctrl)
+{
+	int dummy;
+
+	if (!ctrl)
+		return -EINVAL;
+
+	dummy = device_for_each_child(&ctrl->dev, NULL,
+				      spmi_ctrl_remove_device);
+	device_unregister(&ctrl->dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spmi_controller_remove);
+
+int spmi_driver_register(struct spmi_driver *drv)
+{
+	drv->driver.bus = &spmi_bus_type;
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
diff --git a/include/linux/spmi.h b/include/linux/spmi.h
new file mode 100644
index 0000000..8b9c232
--- /dev/null
+++ b/include/linux/spmi.h
@@ -0,0 +1,355 @@
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
+static inline void *spmi_device_get_drvdata(const struct spmi_device *sdev)
+{
+	return dev_get_drvdata(&sdev->dev);
+}
+
+static inline void spmi_device_set_drvdata(struct spmi_device *sdev, void *data)
+{
+	dev_set_drvdata(&sdev->dev, data);
+}
+
+/**
+ * spmi_controller_alloc: Allocate a new SPMI controller
+ * @ctrl: associated controller
+ *
+ * Caller is responsible for either calling spmi_device_add() to add the
+ * newly allocated controller, or calling spmi_device_put() to discard it.
+ */
+struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl);
+
+static inline void spmi_device_put(struct spmi_device *sdev)
+{
+	if (sdev)
+		put_device(&sdev->dev);
+}
+
+/**
+ * spmi_device_add: add a device previously constructed via spmi_device_alloc()
+ * @sdev: spmi_device to be added
+ */
+int spmi_device_add(struct spmi_device *sdev);
+
+/**
+ * spmi_device_remove: remove a device
+ * @sdev: spmi_device to be removed
+ */
+void spmi_device_remove(struct spmi_device *sdev);
+
+/**
+ * struct spmi_controller: interface to the SPMI master controller
+ * @dev: Driver model representation of the device.
+ * @nr: board-specific number identifier for this controller/bus
+ * @cmd: sends a non-data command sequence on the SPMI bus.
+ * @read_cmd: sends a register read command sequence on the SPMI bus.
+ * @write_cmd: sends a register write command sequence on the SPMI bus.
+ * @dfs_dir: dentry for controller directory in debugfs
+ */
+struct spmi_controller {
+	struct device		dev;
+	unsigned int		nr;
+	int	(*cmd)(struct spmi_controller *ctrl, u8 opcode, u8 sid);
+	int	(*read_cmd)(struct spmi_controller *ctrl, u8 opcode,
+			    u8 sid, u16 addr, u8 bc, u8 *buf);
+	int	(*write_cmd)(struct spmi_controller *ctrl, u8 opcode,
+			     u8 sid, u16 addr, u8 bc, u8 *buf);
+#if CONFIG_DEBUG_FS
+	struct dentry		*dfs_dir;
+#endif
+};
+#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)
+
+static inline
+void *spmi_controller_get_drvdata(const struct spmi_controller *ctrl)
+{
+	return dev_get_drvdata(&ctrl->dev);
+}
+
+static inline void spmi_controller_set_drvdata(struct spmi_controller *ctrl,
+					       void *data)
+{
+	dev_set_drvdata(&ctrl->dev, data);
+}
+
+/**
+ * spmi_controller_alloc: Allocate a new SPMI controller
+ * @parent: parent device
+ * @size: size of private data
+ *
+ * Caller is responsible for either calling spmi_controller_add() to add the
+ * newly allocated controller, or calling spmi_controller_put() to discard it.
+ */
+struct spmi_controller *spmi_controller_alloc(struct device *parent,
+					      size_t size);
+
+static inline void spmi_controller_put(struct spmi_controller *ctrl)
+{
+	if (ctrl)
+		put_device(&ctrl->dev);
+}
+
+/**
+ * spmi_controller_add: Controller bring-up.
+ * @ctrl: controller to be registered.
+ *
+ * Register a controller previously allocated via spmi_controller_alloc() with
+ * the SPMI core
+ */
+int spmi_controller_add(struct spmi_controller *ctrl);
+
+/**
+ * spmi_controller_remove: Controller tear-down.
+ *
+ * Remove a SPMI controller.
+ */
+int spmi_controller_remove(struct spmi_controller *ctrl);
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
+	struct device_driver driver;
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
+int spmi_driver_register(struct spmi_driver *sdrv);
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
+ * spmi_register_read() - register read
+ * @sdev: SPMI device
+ * @addr: slave register address (5-bit address).
+ * @buf: buffer to be populated with data from the Slave.
+ *
+ * Reads 1 byte of data from a Slave device register.
+ */
+int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf);
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
+int spmi_ext_register_read(struct spmi_device *sdev, u8 addr, u8 *buf,
+			   size_t len);
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
+int spmi_ext_register_readl(struct spmi_device *sdev, u16 addr, u8 *buf,
+			    size_t len);
+
+/**
+ * spmi_register_write() - register write
+ * @sdev: SPMI device
+ * @addr: slave register address (5-bit address).
+ * @buf: buffer containing the data to be transferred to the Slave.
+ *
+ * Writes 1 byte of data to a Slave device register.
+ */
+int spmi_register_write(struct spmi_device *sdev, u8 addr, u8 *buf);
+
+/**
+ * spmi_register_zero_write() - register zero write
+ * @sdev: SPMI device
+ * @data: the data to be written to register 0 (7-bits).
+ *
+ * Writes data to register 0 of the Slave device.
+ */
+int spmi_register_zero_write(struct spmi_device *sdev, u8 data);
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
+int spmi_ext_register_write(struct spmi_device *sdev, u8 addr, u8 *buf,
+			    size_t len);
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
+int spmi_ext_register_writel(struct spmi_device *sdev, u16 addr,
+			     u8 *buf, size_t len);
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
+int spmi_command_reset(struct spmi_device *sdev);
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
+int spmi_command_sleep(struct spmi_device *sdev);
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
+int spmi_command_wakeup(struct spmi_device *sdev);
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
+int spmi_command_shutdown(struct spmi_device *sdev);
+
+#endif
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


