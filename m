Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3HUWpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3HUWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH 03/11] w1: slaves: w1_ds2408: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:44:57 -0700
Message-Id: <1377125105-25388-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the sysfs file creation/removal to the w1 core by using the
.groups field, saving code in the slave driver.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds2408.c | 174 +++++++++++++-----------------------------
 1 file changed, 52 insertions(+), 122 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index cb8a8e5d..7dfa0e11 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -72,10 +72,9 @@ static int _read_reg(struct w1_slave *sl, u8 address, unsigned char* buf)
 	return 1;
 }
 
-static ssize_t w1_f29_read_state(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t state_read(struct file *filp, struct kobject *kobj,
+			  struct bin_attribute *bin_attr, char *buf, loff_t off,
+			  size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
 		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
@@ -85,10 +84,9 @@ static ssize_t w1_f29_read_state(
 	return _read_reg(kobj_to_w1_slave(kobj), W1_F29_REG_LOGIG_STATE, buf);
 }
 
-static ssize_t w1_f29_read_output(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t output_read(struct file *filp, struct kobject *kobj,
+			   struct bin_attribute *bin_attr, char *buf,
+			   loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
 		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
@@ -99,10 +97,9 @@ static ssize_t w1_f29_read_output(
 					 W1_F29_REG_OUTPUT_LATCH_STATE, buf);
 }
 
-static ssize_t w1_f29_read_activity(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t activity_read(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr, char *buf,
+			     loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
 		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
@@ -113,10 +110,9 @@ static ssize_t w1_f29_read_activity(
 					 W1_F29_REG_ACTIVITY_LATCH_STATE, buf);
 }
 
-static ssize_t w1_f29_read_cond_search_mask(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t cond_search_mask_read(struct file *filp, struct kobject *kobj,
+				     struct bin_attribute *bin_attr, char *buf,
+				     loff_t off, size_t count)
 {
 	dev_dbg(&kobj_to_w1_slave(kobj)->dev,
 		"Reading %s kobj: %p, off: %0#10x, count: %zu, buff addr: %p",
@@ -127,10 +123,10 @@ static ssize_t w1_f29_read_cond_search_mask(
 		W1_F29_REG_COND_SEARCH_SELECT_MASK, buf);
 }
 
-static ssize_t w1_f29_read_cond_search_polarity(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t cond_search_polarity_read(struct file *filp,
+					 struct kobject *kobj,
+					 struct bin_attribute *bin_attr,
+					 char *buf, loff_t off, size_t count)
 {
 	if (count != 1 || off != 0)
 		return -EFAULT;
@@ -138,10 +134,9 @@ static ssize_t w1_f29_read_cond_search_polarity(
 		W1_F29_REG_COND_SEARCH_POL_SELECT, buf);
 }
 
-static ssize_t w1_f29_read_status_control(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t status_control_read(struct file *filp, struct kobject *kobj,
+				   struct bin_attribute *bin_attr, char *buf,
+				   loff_t off, size_t count)
 {
 	if (count != 1 || off != 0)
 		return -EFAULT;
@@ -149,13 +144,9 @@ static ssize_t w1_f29_read_status_control(
 		W1_F29_REG_CONTROL_AND_STATUS, buf);
 }
 
-
-
-
-static ssize_t w1_f29_write_output(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t output_write(struct file *filp, struct kobject *kobj,
+			    struct bin_attribute *bin_attr, char *buf,
+			    loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	u8 w1_buf[3];
@@ -224,10 +215,9 @@ error:
 /**
  * Writing to the activity file resets the activity latches.
  */
-static ssize_t w1_f29_write_activity(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t activity_write(struct file *filp, struct kobject *kobj,
+			      struct bin_attribute *bin_attr, char *buf,
+			      loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	unsigned int retries = W1_F29_RETRIES;
@@ -255,13 +245,9 @@ error:
 	return -EIO;
 }
 
-static ssize_t w1_f29_write_status_control(
-	struct file *filp,
-	struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf,
-	loff_t off,
-	size_t count)
+static ssize_t status_control_write(struct file *filp, struct kobject *kobj,
+				    struct bin_attribute *bin_attr, char *buf,
+				    loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	u8 w1_buf[4];
@@ -330,91 +316,35 @@ out:
 	return res;
 }
 
-static struct bin_attribute w1_f29_sysfs_bin_files[] = {
-	{
-		.attr =	{
-			.name = "state",
-			.mode = S_IRUGO,
-		},
-		.size = 1,
-		.read = w1_f29_read_state,
-	},
-	{
-		.attr =	{
-			.name = "output",
-			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
-		},
-		.size = 1,
-		.read = w1_f29_read_output,
-		.write = w1_f29_write_output,
-	},
-	{
-		.attr =	{
-			.name = "activity",
-			.mode = S_IRUGO,
-		},
-		.size = 1,
-		.read = w1_f29_read_activity,
-		.write = w1_f29_write_activity,
-	},
-	{
-		.attr =	{
-			.name = "cond_search_mask",
-			.mode = S_IRUGO,
-		},
-		.size = 1,
-		.read = w1_f29_read_cond_search_mask,
-	},
-	{
-		.attr =	{
-			.name = "cond_search_polarity",
-			.mode = S_IRUGO,
-		},
-		.size = 1,
-		.read = w1_f29_read_cond_search_polarity,
-	},
-	{
-		.attr =	{
-			.name = "status_control",
-			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
-		},
-		.size = 1,
-		.read = w1_f29_read_status_control,
-		.write = w1_f29_write_status_control,
-	}
+static BIN_ATTR_RO(state, 1);
+static BIN_ATTR_RW(output, 1);
+static BIN_ATTR_RW(activity, 1);
+static BIN_ATTR_RO(cond_search_mask, 1);
+static BIN_ATTR_RO(cond_search_polarity, 1);
+static BIN_ATTR_RW(status_control, 1);
+
+static struct bin_attribute *w1_f29_bin_attrs[] = {
+	&bin_attr_state,
+	&bin_attr_output,
+	&bin_attr_activity,
+	&bin_attr_cond_search_mask,
+	&bin_attr_cond_search_polarity,
+	&bin_attr_status_control,
+	NULL,
 };
 
-static int w1_f29_add_slave(struct w1_slave *sl)
-{
-	int err = 0;
-	int i;
-
-	err = w1_f29_disable_test_mode(sl);
-	if (err)
-		return err;
-
-	for (i = 0; i < ARRAY_SIZE(w1_f29_sysfs_bin_files) && !err; ++i)
-		err = sysfs_create_bin_file(
-			&sl->dev.kobj,
-			&(w1_f29_sysfs_bin_files[i]));
-	if (err)
-		while (--i >= 0)
-			sysfs_remove_bin_file(&sl->dev.kobj,
-				&(w1_f29_sysfs_bin_files[i]));
-	return err;
-}
+static const struct attribute_group w1_f29_group = {
+	.bin_attrs = w1_f29_bin_attrs,
+};
 
-static void w1_f29_remove_slave(struct w1_slave *sl)
-{
-	int i;
-	for (i = ARRAY_SIZE(w1_f29_sysfs_bin_files) - 1; i >= 0; --i)
-		sysfs_remove_bin_file(&sl->dev.kobj,
-			&(w1_f29_sysfs_bin_files[i]));
-}
+static const struct attribute_group *w1_f29_groups[] = {
+	&w1_f29_group,
+	NULL,
+};
 
 static struct w1_family_ops w1_f29_fops = {
-	.add_slave      = w1_f29_add_slave,
-	.remove_slave   = w1_f29_remove_slave,
+	.add_slave      = w1_f29_disable_test_mode,
+	.groups		= w1_f29_groups,
 };
 
 static struct w1_family w1_family_29 = {
-- 
1.8.3.rc0.20.gb99dd2e

