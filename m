Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3HUWp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3HUWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>,
        Mariusz Bialonczyk <manio@skyboo.net>
Subject: [PATCH 04/11] w1: slaves: w1_ds2413.c: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:44:58 -0700
Message-Id: <1377125105-25388-4-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the sysfs file creation/removal to the w1 core by using the
.groups field, saving code in the slave driver.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: Mariusz Bialonczyk <manio@skyboo.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds2413.c | 72 +++++++++++++------------------------------
 1 file changed, 22 insertions(+), 50 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2413.c b/drivers/w1/slaves/w1_ds2413.c
index 85937773..ee28fc1f 100644
--- a/drivers/w1/slaves/w1_ds2413.c
+++ b/drivers/w1/slaves/w1_ds2413.c
@@ -30,10 +30,9 @@ MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2413));
 #define W1_F3A_FUNC_PIO_ACCESS_WRITE       0x5A
 #define W1_F3A_SUCCESS_CONFIRM_BYTE        0xAA
 
-static ssize_t w1_f3a_read_state(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static ssize_t state_read(struct file *filp, struct kobject *kobj,
+			  struct bin_attribute *bin_attr, char *buf, loff_t off,
+			  size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	dev_dbg(&sl->dev,
@@ -66,10 +65,11 @@ static ssize_t w1_f3a_read_state(
 		return 1;
 }
 
-static ssize_t w1_f3a_write_output(
-	struct file *filp, struct kobject *kobj,
-	struct bin_attribute *bin_attr,
-	char *buf, loff_t off, size_t count)
+static BIN_ATTR_RO(state, 1);
+
+static ssize_t output_write(struct file *filp, struct kobject *kobj,
+			    struct bin_attribute *bin_attr, char *buf,
+			    loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	u8 w1_buf[3];
@@ -110,53 +110,25 @@ error:
 	return -EIO;
 }
 
-#define NB_SYSFS_BIN_FILES 2
-static struct bin_attribute w1_f3a_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
-	{
-		.attr = {
-			.name = "state",
-			.mode = S_IRUGO,
-		},
-		.size = 1,
-		.read = w1_f3a_read_state,
-	},
-	{
-		.attr = {
-			.name = "output",
-			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
-		},
-		.size = 1,
-		.write = w1_f3a_write_output,
-	}
+static BIN_ATTR(output, S_IRUGO | S_IWUSR | S_IWGRP, NULL, output_write, 1);
+
+static struct bin_attribute *w1_f3a_bin_attrs[] = {
+	&bin_attr_state,
+	&bin_attr_output,
+	NULL,
 };
 
-static int w1_f3a_add_slave(struct w1_slave *sl)
-{
-	int err = 0;
-	int i;
-
-	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
-		err = sysfs_create_bin_file(
-			&sl->dev.kobj,
-			&(w1_f3a_sysfs_bin_files[i]));
-	if (err)
-		while (--i >= 0)
-			sysfs_remove_bin_file(&sl->dev.kobj,
-				&(w1_f3a_sysfs_bin_files[i]));
-	return err;
-}
+static const struct attribute_group w1_f3a_group = {
+	.bin_attrs = w1_f3a_bin_attrs,
+};
 
-static void w1_f3a_remove_slave(struct w1_slave *sl)
-{
-	int i;
-	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
-		sysfs_remove_bin_file(&sl->dev.kobj,
-			&(w1_f3a_sysfs_bin_files[i]));
-}
+static const struct attribute_group *w1_f3a_groups[] = {
+	&w1_f3a_group,
+	NULL,
+};
 
 static struct w1_family_ops w1_f3a_fops = {
-	.add_slave      = w1_f3a_add_slave,
-	.remove_slave   = w1_f3a_remove_slave,
+	.groups		= w1_f3a_groups,
 };
 
 static struct w1_family w1_family_3a = {
-- 
1.8.3.rc0.20.gb99dd2e

