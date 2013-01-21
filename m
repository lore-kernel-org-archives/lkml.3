Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3AUME4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:56 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44230 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3AUMEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Cedric Madianga <cedric.madianga@stericsson.com>
Subject: [PATCH 17/24] ab8500-fg-deepdebug: Create Deep Debug interface
Date: Mon, 21 Jan 2013 12:03:53 +0000
Message-Id: <1358769840-4763-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

This patch creates "fg" debugfs directory under existing ab8500
directory to access fuel gauge test services from userspace
(HATS framework).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Cedric Madianga <cedric.madianga@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg_deepdebug.c |  873 ++++++++++++++++++++++++++++++++++-
 1 file changed, 871 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_fg_deepdebug.c b/drivers/power/ab8500_fg_deepdebug.c
index 8845de6..37c5f12 100644
--- a/drivers/power/ab8500_fg_deepdebug.c
+++ b/drivers/power/ab8500_fg_deepdebug.c
@@ -11,13 +11,28 @@
  */
 
 #include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 #include <linux/power_supply.h>
+#include <linux/kobject.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
+#include <linux/slab.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/delay.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
+#include <linux/mfd/abx500.h>
 #include <linux/time.h>
+#include <linux/completion.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/ux500_deepdebug.h>
+#include <linux/uaccess.h>
 
 #include "ab8500_fg.h"
 
@@ -725,8 +740,8 @@ int ab8500_fg_test_get_nconv_accu_nb_sample(struct ab8500_fg *di, u8 *val)
  */
 int ab8500_fg_test_read_nconv_accu_sample(struct ab8500_fg *di)
 {
-	int ret;
-	int nb_sample;
+	int ret = 0;
+	u8 nb_sample;
 	u8 low_data, med_data, high_data;
 
 	/* Get nb sample to average */
@@ -807,6 +822,858 @@ int ab8500_fg_test_read_nconv_accu_sample_to_uA(struct ab8500_fg *di, int val)
 	return val * QLSB_NANO_AMP_HOURS_X10;
 }
 
+/*
+ * DebugFS interface
+ */
+
+#define AB8500_FG_NAME_STRING "fg"
+
+static int ab8500_fg_test_algorithm_en_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	bool status;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	status = ab8500_fg_test_is_algorithm_en(di);
+
+	return seq_printf(s, "%d\n", status);
+}
+
+static int ab8500_fg_test_algorithm_en_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_algorithm_en_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_algorithm_en_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev;
+	struct ab8500_fg *di;
+	unsigned long user_enable;
+	bool enable;
+	int err;
+
+	dev = ((struct seq_file *)(file->private_data))->private;
+	if (!dev)
+		return -ENOMEM;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	err = kstrtoul_from_user(user_buf, count, 0, &user_enable);
+	if (err)
+		return -EINVAL;
+
+	if ((user_enable == 0) || (user_enable == 1)) {
+		enable = (bool) user_enable;
+		err = ab8500_fg_test_algorithm_en(di, enable);
+		if (err)
+			return err;
+	} else {
+		dev_err(di->dev, "Wrong input\n"
+				"Enter 0 => Disable Gas Gauge test mode\n"
+				"Enter 1 => Enable Gas Gauge test mode\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static const struct file_operations ab8500_fg_test_algorithm_en_fops = {
+	.open = ab8500_fg_test_algorithm_en_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_algorithm_en_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_en_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	bool status;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	status = ab8500_fg_test_is_en(di);
+
+	return seq_printf(s, "%d\n", status);
+}
+
+static int ab8500_fg_test_en_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_fg_test_en_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_en_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev;
+	struct ab8500_fg *di;
+	unsigned long user_enable;
+	bool enable;
+	int err;
+
+	dev = ((struct seq_file *)(file->private_data))->private;
+	if (!dev)
+		return -ENOMEM;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	err = kstrtoul_from_user(user_buf, count, 0, &user_enable);
+	if (err)
+		return -EINVAL;
+
+	if ((user_enable == 0) || (user_enable == 1)) {
+		enable = (bool) user_enable;
+		err = ab8500_fg_test_en(di, enable);
+		if (err)
+			return err;
+	} else {
+		dev_err(di->dev, "Wrong input\n"
+				"Enter 0 => Disable Gas Gauge\n"
+				"Enter 1 => Enable Gas Gauge\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static const struct file_operations ab8500_fg_test_en_fops = {
+	.open = ab8500_fg_test_en_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_en_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_cc_int_n_avg_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_get_cc_int_n_avg(di);
+	if (result < 0)
+		return result;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_cc_int_n_avg_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_cc_int_n_avg_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_cc_int_n_avg_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct ab8500_fg *di;
+	char buf[32];
+	int buf_size;
+	unsigned long user_cc_int_n_avg;
+	u8 cc_int_n_avg;
+	int err;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_cc_int_n_avg);
+	if (err)
+		return -EINVAL;
+
+	cc_int_n_avg = (u8) user_cc_int_n_avg;
+	err = ab8500_fg_test_set_cc_int_n_avg(di, cc_int_n_avg);
+	if (err)
+		return err;
+
+	return buf_size;
+}
+
+static const struct file_operations ab8500_fg_test_cc_int_n_avg_fops = {
+	.open = ab8500_fg_test_cc_int_n_avg_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_cc_int_n_avg_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_int_calib_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_int_calib(di);
+	if (result < 0)
+		return result;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_int_calib_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_fg_test_int_calib_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_fg_test_int_calib_fops = {
+	.open = ab8500_fg_test_int_calib_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_soft_calib_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_soft_calib(di);
+	if (result < 0)
+		return result;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_soft_calib_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_soft_calib_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_fg_test_soft_calib_fops = {
+	.open = ab8500_fg_test_soft_calib_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_soft_offset_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int ret;
+	u8 result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	ret = ab8500_fg_test_get_cc_soft_offset(di, &result);
+	if (ret < 0)
+		return ret;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_soft_offset_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_soft_offset_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_soft_offset_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct ab8500_fg *di;
+	char buf[32];
+	int buf_size;
+	unsigned long user_val;
+	u8 val;
+	int err;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_val);
+	if (err)
+		return -EINVAL;
+
+	val = (u8) user_val;
+	err = ab8500_fg_test_set_cc_soft_offset(di, val);
+	if (err)
+		return err;
+
+	return buf_size;
+}
+
+static const struct file_operations ab8500_fg_test_soft_offset_fops = {
+	.open = ab8500_fg_test_soft_offset_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_soft_offset_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+
+static int ab8500_fg_test_rst_accu_sample_counter_print(struct seq_file *s,
+	void *p)
+{
+	struct ab8500_fg *di;
+	int result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_get_rst_accu_sample_counter(di);
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_rst_accu_sample_counter_open(struct inode *inode,
+	struct file *file)
+{
+	return single_open(file, ab8500_fg_test_rst_accu_sample_counter_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_rst_accu_sample_counter_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev;
+	struct ab8500_fg *di;
+	char buf[32];
+	int buf_size;
+	unsigned long user_enable;
+	bool enable;
+	int err;
+
+	dev = ((struct seq_file *)(file->private_data))->private;
+	if (!dev)
+		return -ENOMEM;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_enable);
+	if (err)
+		return -EINVAL;
+	if ((user_enable == 0) || (user_enable == 1)) {
+		enable = (bool) user_enable;
+		err = ab8500_fg_test_set_rst_accu_sample_counter(di, enable);
+		if (err)
+			return err;
+	} else {
+		dev_err(di->dev, "Wrong input\n"
+				"Enter 0. => Disable Reset Acc\n"
+				"Enter 1. => Enable Reset Acc\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_fg_test_rst_accu_sample_fops = {
+	.open = ab8500_fg_test_rst_accu_sample_counter_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_rst_accu_sample_counter_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_cc_mux_offset_print(struct seq_file *s,
+	void *p)
+{
+	struct ab8500_fg *di;
+	int result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_get_cc_mux_offset(di);
+	if (result < 0)
+		return result;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_cc_mux_offset_open(struct inode *inode,
+	struct file *file)
+{
+	return single_open(file, ab8500_fg_test_cc_mux_offset_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_cc_mux_offset_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev;
+	struct ab8500_fg *di;
+	char buf[32];
+	int buf_size;
+	unsigned long user_enable;
+	bool enable;
+	int err;
+
+	dev = ((struct seq_file *)(file->private_data))->private;
+	if (!dev)
+		return -ENOMEM;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_enable);
+	if (err)
+		return -EINVAL;
+	if ((user_enable == 0) || (user_enable == 1)) {
+		enable = (bool) user_enable;
+		err = ab8500_fg_test_set_cc_mux_offset(di, enable);
+		if (err)
+			return err;
+	} else {
+		dev_err(di->dev, "Wrong input\n"
+				"Enter 0. => Manual offset\n"
+				"Enter 1. => Internal offset\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_fg_test_cc_mux_offset_fops = {
+	.open = ab8500_fg_test_cc_mux_offset_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_cc_mux_offset_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_read_sample_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int result, cc_sample_calibrate, cc_sample_calibrate_uA;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_read_sample(di);
+	if (result < 0)
+		return result;
+
+	cc_sample_calibrate = ab8500_fg_test_sample_calibrate(di, result);
+	if (cc_sample_calibrate < 0)
+		return cc_sample_calibrate;
+
+	cc_sample_calibrate_uA = ab8500_fg_test_sample_calibrate_to_uA(di,
+			cc_sample_calibrate);
+
+	return seq_printf(s, "0x%X,%d,%d\n", result, cc_sample_calibrate,
+			cc_sample_calibrate_uA);
+}
+
+static int ab8500_fg_test_read_sample_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_read_sample_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_fg_test_read_sample_fops = {
+	.open = ab8500_fg_test_read_sample_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_get_nconv_accu_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int ret, nconv_accu_uA;
+	u8 val;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	ret = ab8500_fg_test_get_nconv_accu(di, &val);
+	if (ret < 0)
+		return ret;
+
+	nconv_accu_uA = ab8500_fg_test_get_nconv_accu_to_uA(di, (int)val);
+
+	return seq_printf(s, "%d,%d\n", val, nconv_accu_uA);
+}
+
+static int ab8500_fg_test_get_nconv_accu_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_get_nconv_accu_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_fg_test_get_nconv_accu_fops = {
+	.open = ab8500_fg_test_get_nconv_accu_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_rst_nconv_accu_print(struct seq_file *s,
+	void *p)
+{
+	struct ab8500_fg *di;
+	int result;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_get_rst_nconv_accu(di);
+	if (result < 0)
+		return result;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_rst_nconv_accu_open(struct inode *inode,
+	struct file *file)
+{
+	return single_open(file, ab8500_fg_test_rst_nconv_accu_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_rst_nconv_accu_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev;
+	struct ab8500_fg *di;
+	char buf[32];
+	int buf_size;
+	unsigned long user_enable;
+	bool enable;
+	int err;
+
+	dev = ((struct seq_file *)(file->private_data))->private;
+	if (!dev)
+		return -ENOMEM;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_enable);
+	if (err)
+		return -EINVAL;
+	if ((user_enable == 0) || (user_enable == 1)) {
+		enable = (bool) user_enable;
+		err = ab8500_fg_test_set_rst_nconv_accu(di, enable);
+		if (err)
+			return err;
+	} else {
+		dev_err(di->dev, "Wrong input\n"
+				"Enter 0. => Disable Reset Acc\n"
+				"Enter 1. => Enable Reset Acc\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_fg_test_rst_nconv_accu_fops = {
+	.open = ab8500_fg_test_rst_nconv_accu_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_rst_nconv_accu_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_nconv_accu_nb_sample_print(struct seq_file *s,
+	void *p)
+{
+	struct ab8500_fg *di;
+	u8 result;
+	int ret;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	ret = ab8500_fg_test_get_nconv_accu_nb_sample(di, &result);
+	if (ret < 0)
+		return ret;
+
+	return seq_printf(s, "%d\n", result);
+}
+
+static int ab8500_fg_test_nconv_accu_nb_sample_open(struct inode *inode,
+	struct file *file)
+{
+	return single_open(file, ab8500_fg_test_nconv_accu_nb_sample_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_fg_test_nconv_accu_nb_sample_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct ab8500_fg *di;
+	char buf[32];
+	int buf_size;
+	unsigned long user_nb_sample;
+	u8 nb_sample;
+	int err;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_nb_sample);
+	if (err)
+		return -EINVAL;
+
+	nb_sample = (u8) user_nb_sample;
+	err = ab8500_fg_test_set_nconv_accu_nb_sample(di, nb_sample);
+	if (err)
+		return err;
+
+	return buf_size;
+}
+
+static const struct file_operations ab8500_fg_test_nconv_accu_nb_sample_fops = {
+	.open = ab8500_fg_test_nconv_accu_nb_sample_open,
+	.read = seq_read,
+	.write = ab8500_fg_test_nconv_accu_nb_sample_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_fg_test_nconv_accu_sample_print(struct seq_file *s, void *p)
+{
+	struct ab8500_fg *di;
+	int result, nconv_accu_sample_uA;
+
+	di = ab8500_fg_get();
+	if (!di)
+		return -ENOMEM;
+
+	result = ab8500_fg_test_read_nconv_accu_sample(di);
+	if (result < 0)
+		return result;
+
+	nconv_accu_sample_uA = ab8500_fg_test_read_nconv_accu_sample_to_uA(di,
+			result);
+
+	return seq_printf(s, "0x%X,%d\n", result, nconv_accu_sample_uA);
+}
+
+static int ab8500_fg_test_nconv_accu_sample_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_fg_test_nconv_accu_sample_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_fg_test_nconv_accu_sample_fops = {
+	.open = ab8500_fg_test_nconv_accu_sample_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static struct dentry *ab8500_fg_dir;
+
+int ab8500_bm_deepdebug_probe(struct ddbg_service *data,
+		struct dentry *parent)
+{
+	struct dentry *file;
+	struct dentry *dir;
+	int ret = -ENOMEM;
+
+	ab8500_fg_dir = debugfs_create_dir(AB8500_FG_NAME_STRING,
+		parent);
+	if (!ab8500_fg_dir)
+		goto err;
+
+	file = debugfs_create_file("fg_algo_enable", (S_IRUGO | S_IWUGO),
+		ab8500_fg_dir, data, &ab8500_fg_test_algorithm_en_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("fg_enable", (S_IRUGO | S_IWUGO),
+		ab8500_fg_dir, data, &ab8500_fg_test_en_fops);
+	if (!file)
+		goto err;
+
+	dir = debugfs_create_dir("internal_calibration", ab8500_fg_dir);
+	if (!dir)
+		goto err;
+
+	file = debugfs_create_file("cc_int_n_avg", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_cc_int_n_avg_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_int_offset", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_int_calib_fops);
+	if (!file)
+		goto err;
+
+	dir = debugfs_create_dir("software_calibration", ab8500_fg_dir);
+	if (!dir)
+		goto err;
+
+	file = debugfs_create_file("cc_sample_conv", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_soft_calib_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_soft_offset", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_soft_offset_fops);
+	if (!file)
+		goto err;
+
+	dir = debugfs_create_dir("cc_one_sample", ab8500_fg_dir);
+	if (!dir)
+		goto err;
+
+	file = debugfs_create_file("cc_rst_accu_sample", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_rst_accu_sample_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_mux_offset", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_cc_mux_offset_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_one_sample", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_read_sample_fops);
+	if (!file)
+		goto err;
+	file = debugfs_create_file("cc_nconv_accu", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_get_nconv_accu_fops);
+	if (!file)
+		goto err;
+
+	dir = debugfs_create_dir("read_n_samples", ab8500_fg_dir);
+	if (!dir)
+		goto err;
+
+	file = debugfs_create_file("cc_rst_nconv_accu", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_rst_nconv_accu_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_mux_offset", (S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_cc_mux_offset_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_nb_samples_to_average",
+		(S_IRUGO | S_IWUGO),
+		dir, data, &ab8500_fg_test_nconv_accu_nb_sample_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("cc_retrieve_samples", (S_IRUGO | S_IWUGO),
+	    dir, data, &ab8500_fg_test_nconv_accu_sample_fops);
+	if (!file)
+		goto err;
+
+	return 0;
+
+err:
+	if (ab8500_fg_dir)
+		debugfs_remove_recursive(ab8500_fg_dir);
+	pr_err("failed to create debugfs entries.\n");
+
+	return ret;
+}
+
+static struct ddbg_service ab8500_fg_ddbg_services = {
+	.name = AB8500_FG_NAME_STRING,
+	.probe = ab8500_bm_deepdebug_probe,
+};
+
+/*
+ * Initialization
+ */
+
 void __devinit ab8500_fg_test_init(struct ab8500_fg *di)
 {
 	/* Initialize objects need for test purpose. */
@@ -819,5 +1686,7 @@ void __devinit ab8500_fg_test_init(struct ab8500_fg *di)
 	init_completion(&di->test.nconv_accu_complete);
 	init_completion(&di->test.cc_int_calib_complete);
 	mutex_init(&di->test.lock);
+
+	deep_debug_service_access_register(&ab8500_fg_ddbg_services);
 }
 
-- 
1.7.9.5

