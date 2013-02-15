Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161912Ab3BOM7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:59:00 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:61387 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161901Ab3BOM6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 34/35] mfd: ab8500-debug: Convert to kstrtoul_from_user
Date: Fri, 15 Feb 2013 12:57:05 +0000
Message-Id: <1360933026-30325-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: srinidhi kasagar <srinidhi.kasagar@stericsson.com>

Use kstrtoul_from_user for getting an unsigned long from userspace
which is less error prone.

Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |  100 +++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 70 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 37f595d..8fdc3b1 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1478,7 +1478,6 @@ static ssize_t ab8500_bank_write(struct file *file,
 	unsigned long user_bank;
 	int err;
 
-	/* Get userspace string and assure termination */
 	err = kstrtoul_from_user(user_buf, count, 0, &user_bank);
 	if (err)
 		return err;
@@ -1511,7 +1510,6 @@ static ssize_t ab8500_address_write(struct file *file,
 	unsigned long user_address;
 	int err;
 
-	/* Get userspace string and assure termination */
 	err = kstrtoul_from_user(user_buf, count, 0, &user_address);
 	if (err)
 		return err;
@@ -1521,6 +1519,7 @@ static ssize_t ab8500_address_write(struct file *file,
 		return -EINVAL;
 	}
 	debug_address = user_address;
+
 	return count;
 }
 
@@ -1555,7 +1554,6 @@ static ssize_t ab8500_val_write(struct file *file,
 	unsigned long user_val;
 	int err;
 
-	/* Get userspace string and assure termination */
 	err = kstrtoul_from_user(user_buf, count, 0, &user_val);
 	if (err)
 		return err;
@@ -2417,20 +2415,13 @@ static ssize_t ab8500_gpadc_avg_sample_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_avg_sample;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_avg_sample);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_avg_sample);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if ((user_avg_sample == SAMPLE_1) || (user_avg_sample == SAMPLE_4)
 			|| (user_avg_sample == SAMPLE_8)
 			|| (user_avg_sample == SAMPLE_16)) {
@@ -2440,7 +2431,8 @@ static ssize_t ab8500_gpadc_avg_sample_write(struct file *file,
 			"should be egal to 1, 4, 8 or 16\n");
 		return -EINVAL;
 	}
-	return buf_size;
+
+	return count;
 }
 
 static const struct file_operations ab8500_gpadc_avg_sample_fops = {
@@ -2468,20 +2460,13 @@ static ssize_t ab8500_gpadc_trig_edge_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_trig_edge;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_trig_edge);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_trig_edge);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if ((user_trig_edge == RISING_EDGE)
 			|| (user_trig_edge == FALLING_EDGE)) {
 		trig_edge = (u8) user_trig_edge;
@@ -2491,7 +2476,8 @@ static ssize_t ab8500_gpadc_trig_edge_write(struct file *file,
 			"Enter 1. Falling edge\n");
 		return -EINVAL;
 	}
-	return buf_size;
+
+	return count;
 }
 
 static const struct file_operations ab8500_gpadc_trig_edge_fops = {
@@ -2519,20 +2505,13 @@ static ssize_t ab8500_gpadc_trig_timer_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_trig_timer;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_trig_timer);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_trig_timer);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if ((user_trig_timer >= 0) && (user_trig_timer <= 255)) {
 		trig_timer = (u8) user_trig_timer;
 	} else {
@@ -2540,7 +2519,8 @@ static ssize_t ab8500_gpadc_trig_timer_write(struct file *file,
 			"should be beetween 0 to 255\n");
 		return -EINVAL;
 	}
-	return buf_size;
+
+	return count;
 }
 
 static const struct file_operations ab8500_gpadc_trig_timer_fops = {
@@ -2568,20 +2548,13 @@ static ssize_t ab8500_gpadc_conv_type_write(struct file *file,
 	size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_conv_type;
 	int err;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf) - 1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_conv_type);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_conv_type);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if ((user_conv_type == ADC_SW)
 			|| (user_conv_type == ADC_HW)) {
 		conv_type = (u8) user_conv_type;
@@ -2591,7 +2564,8 @@ static ssize_t ab8500_gpadc_conv_type_write(struct file *file,
 			"Enter 1. ADC HW conversion\n");
 		return -EINVAL;
 	}
-	return buf_size;
+
+	return count;
 }
 
 static const struct file_operations ab8500_gpadc_conv_type_fops = {
@@ -2808,21 +2782,14 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_val;
 	int err;
 	unsigned int irq_index;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_val);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_val);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if (user_val < irq_first) {
 		dev_err(dev, "debugfs error input < %d\n", irq_first);
 		return -EINVAL;
@@ -2842,7 +2809,7 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 	 */
 	dev_attr[irq_index] = kmalloc(sizeof(struct device_attribute),
 		GFP_KERNEL);
-	event_name[irq_index] = kmalloc(buf_size, GFP_KERNEL);
+	event_name[irq_index] = kmalloc(count, GFP_KERNEL);
 	sprintf(event_name[irq_index], "%lu", user_val);
 	dev_attr[irq_index]->show = show_irq;
 	dev_attr[irq_index]->store = NULL;
@@ -2864,7 +2831,7 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 		return err;
 	}
 
-	return buf_size;
+	return count;
 }
 
 static ssize_t ab8500_unsubscribe_write(struct file *file,
@@ -2872,21 +2839,14 @@ static ssize_t ab8500_unsubscribe_write(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct device *dev = ((struct seq_file *)(file->private_data))->private;
-	char buf[32];
-	int buf_size;
 	unsigned long user_val;
 	int err;
 	unsigned int irq_index;
 
-	/* Get userspace string and assure termination */
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
-
-	err = strict_strtoul(buf, 0, &user_val);
+	err = kstrtoul_from_user(user_buf, count, 0, &user_val);
 	if (err)
-		return -EINVAL;
+		return err;
+
 	if (user_val < irq_first) {
 		dev_err(dev, "debugfs error input < %d\n", irq_first);
 		return -EINVAL;
@@ -2911,7 +2871,7 @@ static ssize_t ab8500_unsubscribe_write(struct file *file,
 	kfree(event_name[irq_index]);
 	kfree(dev_attr[irq_index]);
 
-	return buf_size;
+	return count;
 }
 
 /*
-- 
1.7.10.4

