Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab3AONAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:00:51 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34614 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3AOM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/26] mfd: ab8500-debugfs: Keep count of IRQs in debugfs
Date: Tue, 15 Jan 2013 12:55:51 +0000
Message-Id: <1358254566-12419-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch adds a counter to the sysfs file dynamically created
by debugfs. It also fixes an array index error.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Reviewed-by: Mattias NILSSON <mattias.i.nilsson@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   77 +++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index b3ddc23..03eacf1 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -23,6 +23,10 @@ static u32 debug_address;
 
 static int irq_first;
 static int irq_last;
+static u32 irq_count[AB8500_NR_IRQS];
+
+static struct device_attribute *dev_attr[AB8500_NR_IRQS];
+static char *event_name[AB8500_NR_IRQS];
 
 /**
  * struct ab8500_reg_range
@@ -364,12 +368,15 @@ static irqreturn_t ab8500_debug_handler(int irq, void *data)
 {
 	char buf[16];
 	struct kobject *kobj = (struct kobject *)data;
+	unsigned int irq_abb = irq - irq_first;
 
+	if (irq_abb < AB8500_NR_IRQS)
+		irq_count[irq_abb]++;
 	/*
 	 * This makes it possible to use poll for events (POLLPRI | POLLERR)
-	 * from userspace on sysfs file named irq-<nr>
+	 * from userspace on sysfs file named <irq-nr>
 	 */
-	sprintf(buf, "irq-%d", irq);
+	sprintf(buf, "%d", irq);
 	sysfs_notify(kobj, NULL, buf);
 
 	return IRQ_HANDLED;
@@ -555,19 +562,26 @@ static int ab8500_subscribe_unsubscribe_open(struct inode *inode,
 }
 
 /*
- * This function is used for all interrupts and will always print
- * the same string. It is however this file sysfs_notify called on.
- * Userspace should read this file and then poll. When an event occur
+ * Userspace should use poll() on this file. When an event occur
  * the blocking poll will be released.
  */
 static ssize_t show_irq(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "irq\n");
-}
+	unsigned long name;
+	unsigned int irq_index;
+	int err;
 
-static struct device_attribute *dev_attr[AB8500_NR_IRQS];
-static char *event_name[AB8500_NR_IRQS];
+	err = strict_strtoul(attr->attr.name, 0, &name);
+	if (err)
+		return err;
+
+	irq_index = name - irq_first;
+	if (irq_index >= AB8500_NR_IRQS)
+		return -EINVAL;
+	else
+		return sprintf(buf, "%u\n", irq_count[irq_index]);
+}
 
 static ssize_t ab8500_subscribe_write(struct file *file,
 				      const char __user *user_buf,
@@ -578,6 +592,7 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 	int buf_size;
 	unsigned long user_val;
 	int err;
+	unsigned int irq_index;
 
 	/* Get userspace string and assure termination */
 	buf_size = min(count, (sizeof(buf)-1));
@@ -597,19 +612,23 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 		return -EINVAL;
 	}
 
+	irq_index = user_val - irq_first;
+	if (irq_index >= AB8500_NR_IRQS)
+		return -EINVAL;
+
 	/*
-	 * This will create a sysfs file named irq-<nr> which userspace can
+	 * This will create a sysfs file named <irq-nr> which userspace can
 	 * use to select or poll and get the AB8500 events
 	 */
-	dev_attr[user_val] = kmalloc(sizeof(struct device_attribute),
-				     GFP_KERNEL);
-	event_name[user_val] = kmalloc(buf_size, GFP_KERNEL);
-	sprintf(event_name[user_val], "irq-%lu", user_val);
-	dev_attr[user_val]->show = show_irq;
-	dev_attr[user_val]->store = NULL;
-	dev_attr[user_val]->attr.name = event_name[user_val];
-	dev_attr[user_val]->attr.mode = S_IRUGO;
-	err = sysfs_create_file(&dev->kobj, &dev_attr[user_val]->attr);
+	dev_attr[irq_index] = kmalloc(sizeof(struct device_attribute),
+		GFP_KERNEL);
+	event_name[irq_index] = kmalloc(buf_size, GFP_KERNEL);
+	sprintf(event_name[irq_index], "%lu", user_val);
+	dev_attr[irq_index]->show = show_irq;
+	dev_attr[irq_index]->store = NULL;
+	dev_attr[irq_index]->attr.name = event_name[irq_index];
+	dev_attr[irq_index]->attr.mode = S_IRUGO;
+	err = sysfs_create_file(&dev->kobj, &dev_attr[irq_index]->attr);
 	if (err < 0) {
 		printk(KERN_ERR "sysfs_create_file failed %d\n", err);
 		return err;
@@ -621,6 +640,7 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 	if (err < 0) {
 		printk(KERN_ERR "request_threaded_irq failed %d, %lu\n",
                        err, user_val);
+		sysfs_remove_file(&dev->kobj, &dev_attr[irq_index]->attr);
 		return err;
 	}
 
@@ -636,6 +656,7 @@ static ssize_t ab8500_unsubscribe_write(struct file *file,
 	int buf_size;
 	unsigned long user_val;
 	int err;
+	unsigned int irq_index;
 
 	/* Get userspace string and assure termination */
 	buf_size = min(count, (sizeof(buf)-1));
@@ -655,12 +676,20 @@ static ssize_t ab8500_unsubscribe_write(struct file *file,
 		return -EINVAL;
 	}
 
-	free_irq(user_val, &dev->kobj);
-	kfree(event_name[user_val]);
-	kfree(dev_attr[user_val]);
+	irq_index = user_val - irq_first;
+	if (irq_index >= AB8500_NR_IRQS)
+		return -EINVAL;
+
+	/* Set irq count to 0 when unsubscribe */
+	irq_count[irq_index] = 0;
+
+	if (dev_attr[irq_index])
+		sysfs_remove_file(&dev->kobj, &dev_attr[irq_index]->attr);
 
-	if (dev_attr[user_val])
-		sysfs_remove_file(&dev->kobj, &dev_attr[user_val]->attr);
+
+	free_irq(user_val, &dev->kobj);
+	kfree(event_name[irq_index]);
+	kfree(dev_attr[irq_index]);
 
 	return buf_size;
 }
-- 
1.7.9.5

