Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3HUWqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:46:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3HUWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH 10/11] w1: slaves: w1_ds2760: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:45:04 -0700
Message-Id: <1377125105-25388-10-git-send-email-gregkh@linuxfoundation.org>
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
 drivers/w1/slaves/w1_ds2760.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 93719d25..65f90dcc 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -97,21 +97,28 @@ int w1_ds2760_recall_eeprom(struct device *dev, int addr)
 	return w1_ds2760_eeprom_cmd(dev, addr, W1_DS2760_RECALL_DATA);
 }
 
-static ssize_t w1_ds2760_read_bin(struct file *filp, struct kobject *kobj,
-				  struct bin_attribute *bin_attr,
-				  char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr, char *buf,
+			     loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	return w1_ds2760_read(dev, buf, off, count);
 }
 
-static struct bin_attribute w1_ds2760_bin_attr = {
-	.attr = {
-		.name = "w1_slave",
-		.mode = S_IRUGO,
-	},
-	.size = DS2760_DATA_SIZE,
-	.read = w1_ds2760_read_bin,
+static BIN_ATTR_RO(w1_slave, DS2760_DATA_SIZE);
+
+static struct bin_attribute *w1_ds2760_bin_attrs[] = {
+	&bin_attr_w1_slave,
+	NULL,
+};
+
+static const struct attribute_group w1_ds2760_group = {
+	.bin_attrs = w1_ds2760_bin_attrs,
+};
+
+static const struct attribute_group *w1_ds2760_groups[] = {
+	&w1_ds2760_group,
+	NULL,
 };
 
 static DEFINE_IDA(bat_ida);
@@ -139,16 +146,10 @@ static int w1_ds2760_add_slave(struct w1_slave *sl)
 	if (ret)
 		goto pdev_add_failed;
 
-	ret = sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
-	if (ret)
-		goto bin_attr_failed;
-
 	dev_set_drvdata(&sl->dev, pdev);
 
 	goto success;
 
-bin_attr_failed:
-	platform_device_del(pdev);
 pdev_add_failed:
 	platform_device_put(pdev);
 pdev_alloc_failed:
@@ -165,12 +166,12 @@ static void w1_ds2760_remove_slave(struct w1_slave *sl)
 
 	platform_device_unregister(pdev);
 	ida_simple_remove(&bat_ida, id);
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
 }
 
 static struct w1_family_ops w1_ds2760_fops = {
 	.add_slave    = w1_ds2760_add_slave,
 	.remove_slave = w1_ds2760_remove_slave,
+	.groups       = w1_ds2760_groups,
 };
 
 static struct w1_family w1_ds2760_family = {
-- 
1.8.3.rc0.20.gb99dd2e

