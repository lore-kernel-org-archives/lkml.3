Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3JVABf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 20:01:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:41405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3JVAB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 20:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422609622"
Message-ID: <5265C0C8.10609@linux.intel.com>
Date: Mon, 21 Oct 2013 17:03:20 -0700
From: Bin Gao <bin.gao@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/misc: add rawio framework driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rawio provides a framework to read/write registers from a bus, including
pci, i2c, I/O device(memory mapped), etc. based on debug fs.
Rawio bus drivers implement the read/write operation on a specific bus
on top of the rawio framework driver.
They are designed to help device driver and kernel debugging on
embedded systems.

Signed-off-by: Bin Gao <bin.gao@intel.com>
---
 drivers/misc/Kconfig        |   1 +
 drivers/misc/Makefile       |   1 +
 drivers/misc/rawio/Kconfig  |  21 ++
 drivers/misc/rawio/Makefile |   1 +
 drivers/misc/rawio/rawio.c  | 514
++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rawio.h       |  78 +++++++
 6 files changed, 616 insertions(+)
 create mode 100644 drivers/misc/rawio/Kconfig
 create mode 100644 drivers/misc/rawio/Makefile
 create mode 100644 drivers/misc/rawio/rawio.c
 create mode 100644 include/linux/rawio.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..1afbe4e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -537,4 +537,5 @@ source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
+source "drivers/misc/rawio/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..3bc116b 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_RAWIO)		+= rawio/
diff --git a/drivers/misc/rawio/Kconfig b/drivers/misc/rawio/Kconfig
new file mode 100644
index 0000000..fd4272e
--- /dev/null
+++ b/drivers/misc/rawio/Kconfig
@@ -0,0 +1,21 @@
+#
+# rawio utility drivers
+#
+
+menuconfig RAWIO
+	tristate "Debug fs based raw io device read/write framework "
+	depends on DEBUG_FS
+	default no
+	help
+	  This option enables support for reading or writing registers/memory
+	  region in a io device via debug fs.
+	  With this option and related rawio driver options enabled, you could
+	  read configuration space of a PCI device, registers of a memory
+	  mapped or port mapped device, registers of a i2c device, etc.
+	  This is the just the framework driver. You need enable more
+	  options to support specific device types.
+
+	  To compile this driver as a module, choose M: the module will
+	  be called rawio.
+
+	  If you are not sure, say N here.
diff --git a/drivers/misc/rawio/Makefile b/drivers/misc/rawio/Makefile
new file mode 100644
index 0000000..c21453c
--- /dev/null
+++ b/drivers/misc/rawio/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_RAWIO)		+= rawio.o
diff --git a/drivers/misc/rawio/rawio.c b/drivers/misc/rawio/rawio.c
new file mode 100644
index 0000000..a05b493
--- /dev/null
+++ b/drivers/misc/rawio/rawio.c
@@ -0,0 +1,514 @@
+/*
+ * rawio.c - a debugfs based framework for reading/writing registers
+ * from a I/O device.
+ * With pluggable rawio drivers, it can support PCI devices, I2C devices,
+ * memory mapped I/O devices, etc.
+ * It's designed for helping debug Linux device drivers on embedded
system or
+ * SoC platforms.
+ *
+ * Copyright (c) 2013 Bin Gao <bin.gao@intel.com>
+ *
+ * This file is released under the GPLv2
+ *
+ *
+ * Two files are created in debugfs root folder: rawio_cmd and
rawio_output.
+ * To read or write via the rawio debugfs interface, first echo a rawio
+ * command to the file rawio_cmd, then cat the file rawio_output:
+ * $ echo "<rawio command>" > /sys/kernel/debug/rawio_cmd
+ * $ cat /sys/kernel/debug/rawio_output
+ * The cat command is required for both read and write operations.
+ * For details of rawio command format, see specific rawio drivers.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/rawio.h>
+
+#define SHOW_NUM_PER_LINE	(32 / active_width)
+#define LINE_WIDTH		32
+#define IS_WHITESPACE(c)	((c) == ' ' || (c) == '\t' || (c) == '\n')
+
+static struct dentry *rawio_cmd_dentry, *rawio_output_dentry;
+static char rawio_cmd_buf[RAWIO_CMD_LEN], rawio_err_buf[RAWIO_ERR_LEN + 1];
+static DEFINE_MUTEX(rawio_lock);
+static LIST_HEAD(rawio_driver_head);
+static struct rawio_driver *active_driver;
+static enum width active_width;
+static enum ops active_ops;
+static u64 args_val[RAWIO_ARGS_MAX];
+static u8 args_postfix[RAWIO_ARGS_MAX];
+static int num_args_val;
+
+static void store_value(u64 *where, void *value, enum type type)
+{
+	switch (type) {
+	case TYPE_U8:
+		*(u8 *)where = *(u8 *)value;
+		break;
+	case TYPE_U16:
+		*(u16 *)where = *(u16 *)value;
+		break;
+	case TYPE_U32:
+		*(u32 *)where = *(u32 *)value;
+		break;
+	case TYPE_U64:
+		*where = *(u64 *)value;
+		break;
+	case TYPE_S8:
+		*(s8 *)where = *(s8 *)value;
+		break;
+	case TYPE_S16:
+		*(s16 *)where = *(s16 *)value;
+		break;
+	case TYPE_S32:
+		*(s32 *)where = *(s32 *)value;
+		break;
+	case TYPE_S64:
+		*(s64 *)where = *(s64 *)value;
+		break;
+	default:
+		break;
+	}
+}
+
+int rawio_register_driver(struct rawio_driver *driver)
+{
+	mutex_lock(&rawio_lock);
+	list_add_tail(&driver->list, &rawio_driver_head);
+	mutex_unlock(&rawio_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rawio_register_driver);
+
+int rawio_unregister_driver(struct rawio_driver *driver)
+{
+	mutex_lock(&rawio_lock);
+	list_del(&driver->list);
+	mutex_unlock(&rawio_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rawio_unregister_driver);
+
+void rawio_err(const char *fmt, ...)
+{
+	va_list args;
+	va_start(args, fmt);
+	vsnprintf(rawio_err_buf, RAWIO_ERR_LEN, fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(rawio_err);
+
+static int parse_arguments(char *input, char **args)
+{
+	int count, located;
+	char *p = input;
+	int input_len = strlen(input);
+
+	count = 0;
+	located = 0;
+	while (*p != 0) {
+		if (p - input >= input_len)
+			break;
+
+		/* Locate the first character of a argument */
+		if (!IS_WHITESPACE(*p)) {
+			if (!located) {
+				located = 1;
+				args[count++] = p;
+				if (count > RAWIO_ARGS_MAX)
+					break;
+			}
+		} else {
+			if (located) {
+				*p = 0;
+				located = 0;
+			}
+		}
+		p++;
+	}
+
+	return count;
+}
+
+static int parse_driver_args(struct rawio_driver *driver, char **arg_list,
+		int num_args, enum ops ops, u64 *arg_val, u8 *postfix)
+{
+	int i;
+	size_t str_len;
+	enum type type;
+	u64 value;
+	char *str;
+	char *args_postfix;
+
+	for (i = 0; i < num_args; i++) {
+		switch (ops) {
+		case OPS_RD:
+			type = driver->args_rd_types[i];
+			args_postfix = driver->args_rd_postfix;
+			break;
+		case OPS_WR:
+			type = driver->args_wr_types[i];
+			args_postfix = driver->args_wr_postfix;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (args_postfix[i]) {
+			str = (char *) arg_list[i];
+			str_len = strlen(str);
+			if (str[str_len - 1] == args_postfix[i]) {
+				postfix[i] = 1;
+				str[str_len - 1] = 0;
+			} else {
+				postfix[i] = 0;
+			}
+		}
+
+		if (kstrtou64(arg_list[i], 0, &value))
+				goto failed;
+		store_value(arg_val + i, &value, type);
+	}
+
+	return 0;
+
+failed:
+	snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+		"invalid argument %s, usage:\n", arg_list[i]);
+	strncat(rawio_err_buf, driver->help, RAWIO_ERR_LEN -
+					strlen(rawio_err_buf));
+	return -EINVAL;
+}
+
+static struct rawio_driver *find_driver(const char *name)
+{
+	struct rawio_driver *driver;
+
+	mutex_lock(&rawio_lock);
+	list_for_each_entry(driver, &rawio_driver_head, list) {
+		if (!strncmp(driver->name, name, strlen(name))) {
+			mutex_unlock(&rawio_lock);
+			return driver;
+		}
+	}
+	mutex_unlock(&rawio_lock);
+
+	return NULL;
+}
+
+static ssize_t rawio_cmd_write(struct file *file, const char __user *buf,
+				size_t len, loff_t *offset)
+{
+	char cmd[RAWIO_CMD_LEN];
+	char *arg_list[RAWIO_ARGS_MAX];
+	int num_args;
+	enum ops ops;
+	enum width width;
+	struct rawio_driver *driver;
+
+	rawio_err_buf[0] = 0;
+
+	if (len >= RAWIO_CMD_LEN) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN, "command is too long.\n"
+					"max allowed command length is %d\n",
+							RAWIO_CMD_LEN);
+		goto done;
+	}
+
+	if (copy_from_user(cmd, buf, len)) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"copy_from_user() failed.\n");
+		goto done;
+	}
+	cmd[len] = 0;
+
+	rawio_cmd_buf[0] = 0;
+	strncpy(rawio_cmd_buf, cmd, len);
+	rawio_cmd_buf[len] = 0;
+
+	num_args = parse_arguments(cmd, arg_list);
+	if (num_args < RAWIO_ARGS_MIN) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"invalid command(too few arguments)\n");
+		goto done;
+	}
+	if (num_args > RAWIO_ARGS_MAX) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"invalid command(too many arguments)\n");
+		goto done;
+	}
+
+	/* arg 0: ops(read/write) and width (8/16/32/64 bit) */
+	if (arg_list[0][0] == 'r')
+		ops = OPS_RD;
+	else if (arg_list[0][0] == 'w')
+		ops = OPS_WR;
+	else {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"invalid operation: %c, only r and w are supported\n",
+							 arg_list[0][0]);
+		goto done;
+	}
+
+	if (strlen(arg_list[0]) >= 3) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"invalid bus width: %s, only 1 2 4 8 are supported\n",
+							 arg_list[0] + 1);
+		goto done;
+	}
+
+	if (strlen(arg_list[0]) == 1)
+		width = WIDTH_DEFAULT;
+	else {
+		switch (arg_list[0][1]) {
+		case '1':
+			width = WIDTH_1;
+			break;
+		case '2':
+			width = WIDTH_2;
+			break;
+		case '4':
+			width = WIDTH_4;
+			break;
+		case '8':
+			width = WIDTH_8;
+			break;
+		default:
+			snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+				"invalid bus width: %c, only 1 2 4 8 are supported\n",
+								arg_list[0][1]);
+			goto done;
+		}
+	}
+
+	/* arg1: driver name */
+	driver = find_driver(arg_list[1]);
+	if (!driver) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"unsupported driver type: %s\n", arg_list[1]);
+		goto done;
+	}
+
+	if (width == WIDTH_DEFAULT)
+		width = driver->default_width;
+
+	if (!(width & driver->supported_width)) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"unsupported driver width: %s\n", arg_list[0]);
+		goto done;
+	}
+
+	/* arg2, ..., argn: driver specific arguments */
+	num_args = num_args - 2;
+	if (((ops == OPS_RD) && (num_args > driver->args_rd_max_num)) ||
+		((ops == OPS_WR) && (num_args > driver->args_wr_max_num))) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"too many arguments, usage:\n");
+		strncat(rawio_err_buf, driver->help, RAWIO_ERR_LEN -
+						strlen(rawio_err_buf));
+		goto done;
+	}
+	if (((ops == OPS_RD) && (num_args < driver->args_rd_min_num)) ||
+		((ops == OPS_WR) && (num_args < driver->args_wr_min_num))) {
+		snprintf(rawio_err_buf, RAWIO_ERR_LEN,
+			"too few arguments, usage:\n");
+		strncat(rawio_err_buf, driver->help, RAWIO_ERR_LEN -
+						strlen(rawio_err_buf));
+		goto done;
+	}
+
+	if (parse_driver_args(driver, arg_list + 2, num_args, ops,
+				args_val, args_postfix))
+		goto done;
+
+	active_driver = driver;
+	active_width = width;
+	active_ops = ops;
+	num_args_val = num_args;
+done:
+	return len;
+}
+
+static int rawio_output_show(struct seq_file *s, void *unused)
+{
+	u32 start, end, start_nature, end_nature;
+	int ret, i, comp1, comp2, output_len;
+	void *output;
+	char seq_buf[16];
+
+	mutex_lock(&rawio_lock);
+
+	if (strlen(rawio_err_buf) > 0) {
+		seq_puts(s, rawio_err_buf);
+		mutex_unlock(&rawio_lock);
+		return 0;
+	}
+
+	active_driver->s = s;
+
+	if (active_ops == OPS_WR) {
+		ret = active_driver->ops->write(active_driver, active_width,
+				args_val, args_postfix, num_args_val);
+		if (ret)
+			seq_puts(s, rawio_err_buf);
+		else
+			seq_puts(s, "write succeeded.\n");
+
+		mutex_unlock(&rawio_lock);
+		return 0;
+	}
+
+	if (active_driver->ops->read_and_show) {
+		ret = active_driver->ops->read_and_show(active_driver,
+			active_width, args_val, args_postfix, num_args_val);
+		if (ret)
+			seq_puts(s, rawio_err_buf);
+		mutex_unlock(&rawio_lock);
+		return 0;
+	}
+
+	ret = active_driver->ops->read(active_driver, active_width, args_val,
+			args_postfix, num_args_val, &output, &output_len);
+	if (ret) {
+		seq_puts(s, rawio_err_buf);
+		mutex_unlock(&rawio_lock);
+		return 0;
+	}
+
+	start_nature = (u32)args_val[active_driver->addr_pos];
+	start = (start_nature / LINE_WIDTH) * LINE_WIDTH;
+	end_nature = start_nature + (output_len - 1) * active_width;
+	end = (end_nature / LINE_WIDTH + 1) * LINE_WIDTH - active_width;
+	comp1 = (start_nature - start) / active_width;
+	comp2 = (end - end_nature) / active_width;
+
+	mutex_unlock(&rawio_lock);
+
+	for (i = 0; i < comp1 + comp2 + output_len; i++) {
+		if ((i % SHOW_NUM_PER_LINE) == 0) {
+			snprintf(seq_buf, sizeof(seq_buf), "[%08x]",
+						(u32)start + i * 4);
+			seq_puts(s, seq_buf);
+		}
+		if (i < comp1 || i >= output_len + comp1) {
+			switch (active_width) {
+			case WIDTH_8:
+				seq_puts(s, " ****************");
+				break;
+			case WIDTH_4:
+				seq_puts(s, " ********");
+				break;
+			case WIDTH_2:
+				seq_puts(s, " ****");
+				break;
+			case WIDTH_1:
+				seq_puts(s, " **");
+				break;
+			default:
+				break;
+			}
+		} else {
+			switch (active_width) {
+			case WIDTH_8:
+				snprintf(seq_buf, sizeof(seq_buf), "[%016llx]",
+					*((u64 *)output + i - comp1));
+				seq_puts(s, seq_buf);
+				break;
+			case WIDTH_4:
+				snprintf(seq_buf, sizeof(seq_buf), " %08x",
+					*((u32 *)output + i - comp1));
+				seq_puts(s, seq_buf);
+				break;
+			case WIDTH_2:
+				snprintf(seq_buf, sizeof(seq_buf), " %04x",
+					*((u16 *)output + i - comp1));
+				seq_puts(s, seq_buf);
+				break;
+			case WIDTH_1:
+				snprintf(seq_buf, sizeof(seq_buf), " %02x",
+					*((u8 *)output + i - comp1));
+				seq_puts(s, seq_buf);
+				break;
+			default:
+				break;
+			}
+		}
+
+		if ((i + 1) % SHOW_NUM_PER_LINE == 0)
+			seq_puts(s, "\n");
+	}
+
+	kfree(output);
+	return 0;
+}
+
+static int rawio_cmd_show(struct seq_file *s, void *unused)
+{
+	seq_puts(s, rawio_cmd_buf);
+	return 0;
+}
+
+static int rawio_cmd_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rawio_cmd_show, NULL);
+}
+
+static const struct file_operations rawio_cmd_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rawio_cmd_open,
+	.read		= seq_read,
+	.write		= rawio_cmd_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int rawio_output_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rawio_output_show, NULL);
+}
+
+static const struct file_operations rawio_output_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rawio_output_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init rawio_init(void)
+{
+	rawio_cmd_dentry = debugfs_create_file("rawio_cmd",
+		S_IFREG | S_IRUGO | S_IWUSR, NULL, NULL, &rawio_cmd_fops);
+	rawio_output_dentry = debugfs_create_file("rawio_output",
+		S_IFREG | S_IRUGO, NULL, NULL, &rawio_output_fops);
+	if (!rawio_cmd_dentry || !rawio_output_dentry) {
+		pr_err("rawio: can't create debugfs node\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+module_init(rawio_init);
+
+static void __exit rawio_exit(void)
+{
+	debugfs_remove(rawio_cmd_dentry);
+	debugfs_remove(rawio_output_dentry);
+}
+module_exit(rawio_exit);
+
+MODULE_DESCRIPTION("Raw IO read/write utility framework driver");
+MODULE_VERSION("1.0");
+MODULE_AUTHOR("Bin Gao <bin.gao@intel.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/rawio.h b/include/linux/rawio.h
new file mode 100644
index 0000000..8f62851
--- /dev/null
+++ b/include/linux/rawio.h
@@ -0,0 +1,78 @@
+#ifndef RAWIO_H
+#define RAWIO_H
+
+#define RAWIO_DRVNAME_LEN	8
+#define RAWIO_ERR_LEN		256
+#define RAWIO_CMD_LEN		96
+#define RAWIO_HELP_LEN		128
+#define RAWIO_ARGS_MIN		3
+#define RAWIO_ARGS_MAX		10
+
+enum type {
+	TYPE_STR = 0,
+	TYPE_U8,
+	TYPE_U16,
+	TYPE_U32,
+	TYPE_U64,
+	TYPE_S8,
+	TYPE_S16,
+	TYPE_S32,
+	TYPE_S64,
+};
+
+/* read/write width: 1, 2, 4 or 8 bytes */
+enum width {
+	WIDTH_DEFAULT = 0,
+	WIDTH_1 = 1,
+	WIDTH_2 = 2,
+	WIDTH_4 = 4,
+	WIDTH_8 = 8,
+};
+
+enum ops {
+	OPS_RD = 1,	/* read */
+	OPS_WR,		/* write */
+};
+
+struct rawio_driver {
+	struct list_head list;
+	char name[RAWIO_DRVNAME_LEN];
+
+	int args_rd_max_num; /* max args for read(including optional args) */
+	enum type args_rd_types[RAWIO_ARGS_MAX]; /* type of each arg */
+	int args_rd_min_num; /* min args for read */
+	char args_rd_postfix[RAWIO_ARGS_MAX]; /* read args postfix */
+
+	int args_wr_max_num; /* max args for write(including optional args) */
+	enum type args_wr_types[RAWIO_ARGS_MAX]; /* type of each arg */
+	int args_wr_min_num; /* min args for write */
+	char args_wr_postfix[RAWIO_ARGS_MAX]; /* write args postfix */
+
+	/* index of argument that specifies the register or memory address */
+	int addr_pos;
+
+	unsigned int supported_width;
+	enum width default_width;
+	char help[RAWIO_HELP_LEN];
+	struct rawio_ops *ops;
+	struct seq_file *s;
+};
+
+struct rawio_ops {
+	/* driver reads io device and returns the data to framework */
+	int (*read) (struct rawio_driver *drv, int width,
+		u64 *input, u8 *postfix, int input_num,
+		void **output, int *output_num);
+	/* driver reads io device and shows the data */
+	int (*read_and_show) (struct rawio_driver *drv, int width,
+		u64 *input, u8 *postfix, int input_num);
+	/* driver writes data passed from framework to io device */
+	int (*write) (struct rawio_driver *driver, int width,
+		u64 *input, u8 *postfix, int input_num);
+};
+
+int rawio_register_driver(struct rawio_driver *drv);
+int rawio_unregister_driver(struct rawio_driver *drv);
+void rawio_err(const char *fmt, ...);
+
+#endif
-- 
1.8.1.2

