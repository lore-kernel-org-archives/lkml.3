Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3HUWrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:47:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3HUWpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH 09/11] w1: slaves: w1_ds2780: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:45:03 -0700
Message-Id: <1377125105-25388-9-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the sysfs file creation/removal to the w1 core by using the
.groups field, saving code in the slave driver.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds2780.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2780.c b/drivers/w1/slaves/w1_ds2780.c
index 0cd7a27b..50e85f79 100644
--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -89,22 +89,28 @@ int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
 }
 EXPORT_SYMBOL(w1_ds2780_eeprom_cmd);
 
-static ssize_t w1_ds2780_read_bin(struct file *filp,
-				  struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr, char *buf,
+			     loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	return w1_ds2780_io(dev, buf, off, count, 0);
 }
 
-static struct bin_attribute w1_ds2780_bin_attr = {
-	.attr = {
-		.name = "w1_slave",
-		.mode = S_IRUGO,
-	},
-	.size = DS2780_DATA_SIZE,
-	.read = w1_ds2780_read_bin,
+static BIN_ATTR_RO(w1_slave, DS2780_DATA_SIZE);
+
+static struct bin_attribute *w1_ds2780_bin_attrs[] = {
+	&bin_attr_w1_slave,
+	NULL,
+};
+
+static const struct attribute_group w1_ds2780_group = {
+	.bin_attrs = w1_ds2780_bin_attrs,
+};
+
+static const struct attribute_group *w1_ds2780_groups[] = {
+	&w1_ds2780_group,
+	NULL,
 };
 
 static DEFINE_IDA(bat_ida);
@@ -132,16 +138,10 @@ static int w1_ds2780_add_slave(struct w1_slave *sl)
 	if (ret)
 		goto pdev_add_failed;
 
-	ret = sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
-	if (ret)
-		goto bin_attr_failed;
-
 	dev_set_drvdata(&sl->dev, pdev);
 
 	return 0;
 
-bin_attr_failed:
-	platform_device_del(pdev);
 pdev_add_failed:
 	platform_device_put(pdev);
 pdev_alloc_failed:
@@ -157,12 +157,12 @@ static void w1_ds2780_remove_slave(struct w1_slave *sl)
 
 	platform_device_unregister(pdev);
 	ida_simple_remove(&bat_ida, id);
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
 }
 
 static struct w1_family_ops w1_ds2780_fops = {
 	.add_slave    = w1_ds2780_add_slave,
 	.remove_slave = w1_ds2780_remove_slave,
+	.groups       = w1_ds2780_groups,
 };
 
 static struct w1_family w1_ds2780_family = {
-- 
1.8.3.rc0.20.gb99dd2e

