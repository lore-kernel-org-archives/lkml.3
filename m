Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3AONAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:00:19 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47573 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3AOM4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        carriere etienne <etienne.carriere@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/26] mfd: ab8500-debugfs: Formated access AB8500 registers from debugfs entry
Date: Tue, 15 Jan 2013 12:55:53 +0000
Message-Id: <1358254566-12419-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: carriere etienne <etienne.carriere@stericsson.com>

Add debugfs entry ab8500/hwreg to read/write bit-field in AB8500 registers.
Check the debugfs entries usage from heading comments in ab8500-debugfs.c

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: carriere etienne <etienne.carriere@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |  388 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 336 insertions(+), 52 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 4f36907..78a8e0c 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -4,6 +4,72 @@
  * Author: Mattias Wallin <mattias.wallin@stericsson.com> for ST-Ericsson.
  * License Terms: GNU General Public License v2
  */
+/*
+ * AB8500 register access
+ * ======================
+ *
+ * read:
+ * # echo BANK  >  <debugfs>/ab8500/register-bank
+ * # echo ADDR  >  <debugfs>/ab8500/register-address
+ * # cat <debugfs>/ab8500/register-value
+ *
+ * write:
+ * # echo BANK  >  <debugfs>/ab8500/register-bank
+ * # echo ADDR  >  <debugfs>/ab8500/register-address
+ * # echo VALUE >  <debugfs>/ab8500/register-value
+ *
+ * read all registers from a bank:
+ * # echo BANK  >  <debugfs>/ab8500/register-bank
+ * # cat <debugfs>/ab8500/all-bank-register
+ *
+ * BANK   target AB8500 register bank
+ * ADDR   target AB8500 register address
+ * VALUE  decimal or 0x-prefixed hexadecimal
+ *
+ *
+ * User Space notification on AB8500 IRQ
+ * =====================================
+ *
+ * Allows user space entity to be notified when target AB8500 IRQ occurs.
+ * When subscribed, a sysfs entry is created in ab8500.i2c platform device.
+ * One can pool this file to get target IRQ occurence information.
+ *
+ * subscribe to an AB8500 IRQ:
+ * # echo IRQ  >  <debugfs>/ab8500/irq-subscribe
+ *
+ * unsubscribe from an AB8500 IRQ:
+ * # echo IRQ  >  <debugfs>/ab8500/irq-unsubscribe
+ *
+ *
+ * AB8500 register formated read/write access
+ * ==========================================
+ *
+ * Read:  read data, data>>SHIFT, data&=MASK, output data
+ *        [0xABCDEF98] shift=12 mask=0xFFF => 0x00000CDE
+ * Write: read data, data &= ~(MASK<<SHIFT), data |= (VALUE<<SHIFT), write data
+ *        [0xABCDEF98] shift=12 mask=0xFFF value=0x123 => [0xAB123F98]
+ *
+ * Usage:
+ * # echo "CMD [OPTIONS] BANK ADRESS [VALUE]" > $debugfs/ab8500/hwreg
+ *
+ * CMD      read      read access
+ *          write     write access
+ *
+ * BANK     target reg bank
+ * ADDRESS  target reg address
+ * VALUE    (write) value to be updated
+ *
+ * OPTIONS
+ *  -d|-dec            (read) output in decimal
+ *  -h|-hexa           (read) output in 0x-hexa (default)
+ *  -l|-w|-b           32bit (default), 16bit or 8bit reg access
+ *  -m|-mask MASK      0x-hexa mask (default 0xFFFFFFFF)
+ *  -s|-shift SHIFT    bit shift value (read:left, write:right)
+ *  -o|-offset OFFSET  address offset to add to ADDRESS value
+ *
+ * Warning: bit shift operation is applied to bit-mask.
+ * Warning: bit shift direction depends on read or right command.
+ */
 
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
@@ -18,6 +84,11 @@
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 
+#ifdef CONFIG_DEBUG_FS
+#include <linux/string.h>
+#include <linux/ctype.h>
+#endif
+
 static u32 debug_bank;
 static u32 debug_address;
 
@@ -52,6 +123,25 @@ struct ab8500_prcmu_ranges {
 	const struct ab8500_reg_range *range;
 };
 
+/* hwreg- "mask" and "shift" entries ressources */
+struct hwreg_cfg {
+	u32  bank;      /* target bank */
+	u32  addr;      /* target address */
+	uint fmt;       /* format */
+	uint mask;      /* read/write mask, applied before any bit shift */
+	int  shift;     /* bit shift (read:right shift, write:left shift */
+};
+/* fmt bit #0: 0=hexa, 1=dec */
+#define REG_FMT_DEC(c) ((c)->fmt & 0x1)
+#define REG_FMT_HEX(c) (!REG_FMT_DEC(c))
+
+static struct hwreg_cfg hwreg_cfg = {
+	.addr = 0,			/* default: invalid phys addr */
+	.fmt = 0,			/* default: 32bit access, hex output */
+	.mask = 0xFFFFFFFF,	/* default: no mask */
+	.shift = 0,			/* default: no bit shift */
+};
+
 #define AB8500_NAME_STRING "ab8500"
 #define AB8500_NUM_BANKS 22
 
@@ -547,6 +637,203 @@ static ssize_t ab8500_val_write(struct file *file,
 	return count;
 }
 
+/*
+ * - HWREG DB8500 formated routines
+ */
+static int ab8500_hwreg_print(struct seq_file *s, void *d)
+{
+	struct device *dev = s->private;
+	int ret;
+	u8 regvalue;
+
+	ret = abx500_get_register_interruptible(dev,
+		(u8)hwreg_cfg.bank, (u8)hwreg_cfg.addr, &regvalue);
+	if (ret < 0) {
+		dev_err(dev, "abx500_get_reg fail %d, %d\n",
+			ret, __LINE__);
+		return -EINVAL;
+	}
+
+	if (hwreg_cfg.shift >= 0)
+		regvalue >>= hwreg_cfg.shift;
+	else
+		regvalue <<= -hwreg_cfg.shift;
+	regvalue &= hwreg_cfg.mask;
+
+	if (REG_FMT_DEC(&hwreg_cfg))
+		seq_printf(s, "%d\n", regvalue);
+	else
+		seq_printf(s, "0x%02X\n", regvalue);
+	return 0;
+}
+
+static int ab8500_hwreg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_hwreg_print, inode->i_private);
+}
+
+/*
+ * return length of an ASCII numerical value, 0 is string is not a
+ * numerical value.
+ * string shall start at value 1st char.
+ * string can be tailed with \0 or space or newline chars only.
+ * value can be decimal or hexadecimal (prefixed 0x or 0X).
+ */
+static int strval_len(char *b)
+{
+	char *s = b;
+	if ((*s == '0') && ((*(s+1) == 'x') || (*(s+1) == 'X'))) {
+		s += 2;
+		for (; *s && (*s != ' ') && (*s != '\n'); s++) {
+			if (!isxdigit(*s))
+				return 0;
+		}
+	} else {
+		if (*s == '-')
+			s++;
+		for (; *s && (*s != ' ') && (*s != '\n'); s++) {
+			if (!isdigit(*s))
+				return 0;
+		}
+	}
+	return (int) (s-b);
+}
+
+/*
+ * parse hwreg input data.
+ * update global hwreg_cfg only if input data syntax is ok.
+ */
+static ssize_t hwreg_common_write(char *b, struct hwreg_cfg *cfg,
+		struct device *dev)
+{
+	uint write, val = 0;
+	struct hwreg_cfg loc = {
+		.bank = 0,          /* default: invalid phys addr */
+		.addr = 0,          /* default: invalid phys addr */
+		.fmt = 0,           /* default: 32bit access, hex output */
+		.mask = 0xFFFFFFFF, /* default: no mask */
+		.shift = 0,         /* default: no bit shift */
+	};
+
+	/* read or write ? */
+	if (!strncmp(b, "read ", 5)) {
+		write = 0;
+		b += 5;
+	} else if (!strncmp(b, "write ", 6)) {
+		write = 1;
+		b += 6;
+	} else
+		return -EINVAL;
+
+	/* OPTIONS -l|-w|-b -s -m -o */
+	while ((*b == ' ') || (*b == '-')) {
+		if (*(b-1) != ' ') {
+			b++;
+			continue;
+		}
+		if ((!strncmp(b, "-d ", 3)) ||
+				(!strncmp(b, "-dec ", 5))) {
+			b += (*(b+2) == ' ') ? 3 : 5;
+			loc.fmt |= (1<<0);
+		} else if ((!strncmp(b, "-h ", 3)) ||
+				(!strncmp(b, "-hex ", 5))) {
+			b += (*(b+2) == ' ') ? 3 : 5;
+			loc.fmt &= ~(1<<0);
+		} else if ((!strncmp(b, "-m ", 3)) ||
+				(!strncmp(b, "-mask ", 6))) {
+			b += (*(b+2) == ' ') ? 3 : 6;
+			if (strval_len(b) == 0)
+				return -EINVAL;
+			loc.mask = simple_strtoul(b, &b, 0);
+		} else if ((!strncmp(b, "-s ", 3)) ||
+				(!strncmp(b, "-shift ", 7))) {
+			b += (*(b+2) == ' ') ? 3 : 7;
+			if (strval_len(b) == 0)
+				return -EINVAL;
+			loc.shift = simple_strtol(b, &b, 0);
+		} else {
+			return -EINVAL;
+		}
+	}
+	/* get arg BANK and ADDRESS */
+	if (strval_len(b) == 0)
+		return -EINVAL;
+	loc.bank = simple_strtoul(b, &b, 0);
+	while (*b == ' ')
+		b++;
+	if (strval_len(b) == 0)
+		return -EINVAL;
+	loc.addr = simple_strtoul(b, &b, 0);
+
+	if (write) {
+		while (*b == ' ')
+			b++;
+		if (strval_len(b) == 0)
+			return -EINVAL;
+		val = simple_strtoul(b, &b, 0);
+	}
+
+	/* args are ok, update target cfg (mainly for read) */
+	*cfg = loc;
+
+#if ABB_HWREG_DEBUG
+	pr_warn("HWREG request: %s, %s, addr=0x%08X, mask=0x%X, shift=%d
+			value=0x%X\n", (write) ? "write" : "read",
+			REG_FMT_DEC(cfg) ? "decimal" : "hexa",
+			cfg->addr, cfg->mask, cfg->shift, val);
+#endif
+
+	if (write) {
+		u8  regvalue;
+		int ret = abx500_get_register_interruptible(dev,
+			(u8)cfg->bank, (u8)cfg->addr, &regvalue);
+		if (ret < 0) {
+			dev_err(dev, "abx500_get_reg fail %d, %d\n",
+				ret, __LINE__);
+			return -EINVAL;
+		}
+
+		if (cfg->shift >= 0) {
+			regvalue &= ~(cfg->mask << (cfg->shift));
+			val = (val & cfg->mask) << (cfg->shift);
+		} else {
+			regvalue &= ~(cfg->mask >> (-cfg->shift));
+			val = (val & cfg->mask) >> (-cfg->shift);
+		}
+		val = val | regvalue;
+
+		ret = abx500_set_register_interruptible(dev,
+			(u8)cfg->bank, (u8)cfg->addr, (u8)val);
+		if (ret < 0) {
+			pr_err("abx500_set_reg failed %d, %d", ret, __LINE__);
+			return -EINVAL;
+		}
+
+	}
+	return 0;
+}
+
+static ssize_t ab8500_hwreg_write(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[128];
+	int buf_size, ret;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	/* get args and process */
+	ret = hwreg_common_write(buf, &hwreg_cfg, dev);
+	return (ret) ? ret : buf_size;
+}
+
+/*
+ * - irq subscribe/unsubscribe stuff
+ */
 static int ab8500_subscribe_unsubscribe_print(struct seq_file *s, void *p)
 {
 	seq_printf(s, "%d\n", irq_first);
@@ -694,6 +981,10 @@ static ssize_t ab8500_unsubscribe_write(struct file *file,
 	return buf_size;
 }
 
+/*
+ * - several deubgfs nodes fops
+ */
+
 static const struct file_operations ab8500_bank_fops = {
 	.open = ab8500_bank_open,
 	.write = ab8500_bank_write,
@@ -739,16 +1030,20 @@ static const struct file_operations ab8500_unsubscribe_fops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct file_operations ab8500_hwreg_fops = {
+	.open = ab8500_hwreg_open,
+	.write = ab8500_hwreg_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static struct dentry *ab8500_dir;
-static struct dentry *ab8500_reg_file;
-static struct dentry *ab8500_bank_file;
-static struct dentry *ab8500_address_file;
-static struct dentry *ab8500_val_file;
-static struct dentry *ab8500_subscribe_file;
-static struct dentry *ab8500_unsubscribe_file;
 
 static int __devinit ab8500_debug_probe(struct platform_device *plf)
 {
+	struct dentry *file;
 	debug_bank = AB8500_MISC;
 	debug_address = AB8500_REV_REG & 0x00FF;
 
@@ -768,70 +1063,59 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 
 	ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
 	if (!ab8500_dir)
-		goto exit_no_debugfs;
+		goto err;
 
-	ab8500_reg_file = debugfs_create_file("all-bank-registers",
+	file = debugfs_create_file("all-bank-registers",
 		S_IRUGO, ab8500_dir, &plf->dev, &ab8500_registers_fops);
-	if (!ab8500_reg_file)
-		goto exit_destroy_dir;
+	if (!file)
+		goto err;
 
-	ab8500_bank_file = debugfs_create_file("register-bank",
+	file = debugfs_create_file("register-bank",
 		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev, &ab8500_bank_fops);
-	if (!ab8500_bank_file)
-		goto exit_destroy_reg;
+	if (!file)
+		goto err;
 
-	ab8500_address_file = debugfs_create_file("register-address",
+	file = debugfs_create_file("register-address",
 		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
 		&ab8500_address_fops);
-	if (!ab8500_address_file)
-		goto exit_destroy_bank;
+	if (!file)
+		goto err;
 
-	ab8500_val_file = debugfs_create_file("register-value",
+	file = debugfs_create_file("register-value",
 		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev, &ab8500_val_fops);
-	if (!ab8500_val_file)
-		goto exit_destroy_address;
-
-	ab8500_subscribe_file =
-		debugfs_create_file("irq-subscribe",
-				    (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
-				    &ab8500_subscribe_fops);
-	if (!ab8500_subscribe_file)
-		goto exit_destroy_val;
-
-	ab8500_unsubscribe_file =
-		debugfs_create_file("irq-unsubscribe",
-				    (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
-				    &ab8500_unsubscribe_fops);
-	if (!ab8500_unsubscribe_file)
-		goto exit_destroy_subscribe;
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("irq-subscribe",
+		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
+		&ab8500_subscribe_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("irq-unsubscribe",
+		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
+		&ab8500_unsubscribe_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("hwreg",
+		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
+		&ab8500_hwreg_fops);
+	if (!file)
+		goto err;
 
 	return 0;
 
-exit_destroy_subscribe:
-	debugfs_remove(ab8500_subscribe_file);
-exit_destroy_val:
-	debugfs_remove(ab8500_val_file);
-exit_destroy_address:
-	debugfs_remove(ab8500_address_file);
-exit_destroy_bank:
-	debugfs_remove(ab8500_bank_file);
-exit_destroy_reg:
-	debugfs_remove(ab8500_reg_file);
-exit_destroy_dir:
-	debugfs_remove(ab8500_dir);
-exit_no_debugfs:
+err:
+	if (ab8500_dir)
+		debugfs_remove_recursive(ab8500_dir);
 	dev_err(&plf->dev, "failed to create debugfs entries.\n");
 	return -ENOMEM;
 }
 
 static int __devexit ab8500_debug_remove(struct platform_device *plf)
 {
-	debugfs_remove(ab8500_val_file);
-	debugfs_remove(ab8500_address_file);
-	debugfs_remove(ab8500_bank_file);
-	debugfs_remove(ab8500_reg_file);
-	debugfs_remove(ab8500_dir);
-
+	debugfs_remove_recursive(ab8500_dir);
 	return 0;
 }
 
-- 
1.7.9.5

