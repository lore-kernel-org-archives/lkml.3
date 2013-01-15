Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3AOM4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:44 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62536 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3AOM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:41 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/26] mfd: ab8500-debugfs: Provide a means for a user subscribe to IRQs
Date: Tue, 15 Jan 2013 12:55:49 +0000
Message-Id: <1358254566-12419-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow users to subscribe to and view IRQ events live from debugfs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |  197 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index c4cb806..71df8e4 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -11,6 +11,9 @@
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/kobject.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
@@ -18,6 +21,9 @@
 static u32 debug_bank;
 static u32 debug_address;
 
+static int irq_first;
+static int irq_last;
+
 /**
  * struct ab8500_reg_range
  * @first: the first address of the range
@@ -354,6 +360,21 @@ static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 };
 
+static irqreturn_t ab8500_debug_handler(int irq, void *data)
+{
+	char buf[16];
+	struct kobject *kobj = (struct kobject *)data;
+
+	/*
+	 * This makes it possible to use poll for events (POLLPRI | POLLERR)
+	 * from userspace on sysfs file named irq-<nr>
+	 */
+	sprintf(buf, "irq-%d", irq);
+	sysfs_notify(kobj, NULL, buf);
+
+	return IRQ_HANDLED;
+}
+
 static int ab8500_registers_print(struct seq_file *s, void *p)
 {
 	struct device *dev = s->private;
@@ -519,6 +540,130 @@ static ssize_t ab8500_val_write(struct file *file,
 	return count;
 }
 
+static int ab8500_subscribe_unsubscribe_print(struct seq_file *s, void *p)
+{
+	seq_printf(s, "%d\n", irq_first);
+
+	return 0;
+}
+
+static int ab8500_subscribe_unsubscribe_open(struct inode *inode,
+					     struct file *file)
+{
+	return single_open(file, ab8500_subscribe_unsubscribe_print,
+			   inode->i_private);
+}
+
+/*
+ * This function is used for all interrupts and will always print
+ * the same string. It is however this file sysfs_notify called on.
+ * Userspace should read this file and then poll. When an event occur
+ * the blocking poll will be released.
+ */
+static ssize_t show_irq(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "irq\n");
+}
+
+static struct device_attribute *dev_attr[AB8500_NR_IRQS];
+static char *event_name[AB8500_NR_IRQS];
+
+static ssize_t ab8500_subscribe_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_val;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_val);
+	if (err)
+		return -EINVAL;
+	if (user_val < irq_first) {
+		dev_err(dev, "debugfs error input < %d\n", irq_first);
+		return -EINVAL;
+	}
+	if (user_val > irq_last) {
+		dev_err(dev, "debugfs error input > %d\n", irq_last);
+		return -EINVAL;
+	}
+
+	/*
+	 * This will create a sysfs file named irq-<nr> which userspace can
+	 * use to select or poll and get the AB8500 events
+	 */
+	dev_attr[user_val] = kmalloc(sizeof(struct device_attribute),
+				     GFP_KERNEL);
+	event_name[user_val] = kmalloc(buf_size, GFP_KERNEL);
+	sprintf(event_name[user_val], "irq-%lu", user_val);
+	dev_attr[user_val]->show = show_irq;
+	dev_attr[user_val]->store = NULL;
+	dev_attr[user_val]->attr.name = event_name[user_val];
+	dev_attr[user_val]->attr.mode = S_IRUGO;
+	err = sysfs_create_file(&dev->kobj, &dev_attr[user_val]->attr);
+	if (err < 0) {
+		printk(KERN_ERR "sysfs_create_file failed %d\n", err);
+		return err;
+	}
+
+	err = request_threaded_irq(user_val, NULL, ab8500_debug_handler,
+				   0, "ab8500-debug", &dev->kobj);
+	if (err < 0) {
+		printk(KERN_ERR "request_threaded_irq failed %d, %lu\n",
+                       err, user_val);
+		return err;
+	}
+
+	return buf_size;
+}
+
+static ssize_t ab8500_unsubscribe_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_val;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_val);
+	if (err)
+		return -EINVAL;
+	if (user_val < irq_first) {
+		dev_err(dev, "debugfs error input < %d\n", irq_first);
+		return -EINVAL;
+	}
+	if (user_val > irq_last) {
+		dev_err(dev, "debugfs error input > %d\n", irq_last);
+		return -EINVAL;
+	}
+
+	free_irq(user_val, &dev->kobj);
+	kfree(event_name[user_val]);
+	kfree(dev_attr[user_val]);
+
+	if (dev_attr[user_val])
+		sysfs_remove_file(&dev->kobj, &dev_attr[user_val]->attr);
+
+	return buf_size;
+}
+
 static const struct file_operations ab8500_bank_fops = {
 	.open = ab8500_bank_open,
 	.write = ab8500_bank_write,
@@ -546,17 +691,51 @@ static const struct file_operations ab8500_val_fops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct file_operations ab8500_subscribe_fops = {
+	.open = ab8500_subscribe_unsubscribe_open,
+	.write = ab8500_subscribe_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations ab8500_unsubscribe_fops = {
+	.open = ab8500_subscribe_unsubscribe_open,
+	.write = ab8500_unsubscribe_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static struct dentry *ab8500_dir;
 static struct dentry *ab8500_reg_file;
 static struct dentry *ab8500_bank_file;
 static struct dentry *ab8500_address_file;
 static struct dentry *ab8500_val_file;
+static struct dentry *ab8500_subscribe_file;
+static struct dentry *ab8500_unsubscribe_file;
 
 static int __devinit ab8500_debug_probe(struct platform_device *plf)
 {
 	debug_bank = AB8500_MISC;
 	debug_address = AB8500_REV_REG & 0x00FF;
 
+	irq_first = platform_get_irq_byname(plf, "IRQ_FIRST");
+	if (irq_first < 0) {
+		dev_err(&plf->dev, "First irq not found, err %d\n",
+			irq_first);
+		return irq_first;
+	}
+
+	irq_last = platform_get_irq_byname(plf, "IRQ_LAST");
+	if (irq_last < 0) {
+		dev_err(&plf->dev, "Last irq not found, err %d\n",
+			irq_last);
+		return irq_last;
+	}
+
 	ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
 	if (!ab8500_dir)
 		goto exit_no_debugfs;
@@ -582,8 +761,26 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	if (!ab8500_val_file)
 		goto exit_destroy_address;
 
+	ab8500_subscribe_file =
+		debugfs_create_file("irq-subscribe",
+				    (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
+				    &ab8500_subscribe_fops);
+	if (!ab8500_subscribe_file)
+		goto exit_destroy_val;
+
+	ab8500_unsubscribe_file =
+		debugfs_create_file("irq-unsubscribe",
+				    (S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
+				    &ab8500_unsubscribe_fops);
+	if (!ab8500_unsubscribe_file)
+		goto exit_destroy_subscribe;
+
 	return 0;
 
+exit_destroy_subscribe:
+	debugfs_remove(ab8500_subscribe_file);
+exit_destroy_val:
+	debugfs_remove(ab8500_val_file);
 exit_destroy_address:
 	debugfs_remove(ab8500_address_file);
 exit_destroy_bank:
-- 
1.7.9.5

