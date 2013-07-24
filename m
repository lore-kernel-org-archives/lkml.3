Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3GXWGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3GXWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/36] tile: srom: convert srom_class to use dev_groups
Date: Wed, 24 Jul 2013 15:05:07 -0700
Message-Id: <1374703539-9705-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the tile srom_class code to use
the correct field.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tile-srom.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tile-srom.c b/drivers/char/tile-srom.c
index 7faeb1cd..344e97b9 100644
--- a/drivers/char/tile-srom.c
+++ b/drivers/char/tile-srom.c
@@ -279,33 +279,37 @@ loff_t srom_llseek(struct file *file, loff_t offset, int origin)
 	return fixed_size_llseek(file, offset, origin, srom->total_size);
 }
 
-static ssize_t total_show(struct device *dev,
-			  struct device_attribute *attr, char *buf)
+static ssize_t total_size_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct srom_dev *srom = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", srom->total_size);
 }
+static DEVICE_ATTR_RO(total_size);
 
-static ssize_t sector_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
+static ssize_t sector_size_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct srom_dev *srom = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", srom->sector_size);
 }
+static DEVICE_ATTR_RO(sector_size);
 
-static ssize_t page_show(struct device *dev,
-			 struct device_attribute *attr, char *buf)
+static ssize_t page_size_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
 {
 	struct srom_dev *srom = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", srom->page_size);
 }
+static DEVICE_ATTR_RO(page_size);
 
-static struct device_attribute srom_dev_attrs[] = {
-	__ATTR(total_size, S_IRUGO, total_show, NULL),
-	__ATTR(sector_size, S_IRUGO, sector_show, NULL),
-	__ATTR(page_size, S_IRUGO, page_show, NULL),
-	__ATTR_NULL
+static struct attribute srom_dev_attrs[] = {
+	&dev_attr_total_size.attr,
+	&dev_attr_sector_size.attr,
+	&dev_attr_page_size.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(srom_dev);
 
 static char *srom_devnode(struct device *dev, umode_t *mode)
 {
@@ -418,7 +422,7 @@ static int srom_init(void)
 		result = PTR_ERR(srom_class);
 		goto fail_cdev;
 	}
-	srom_class->dev_attrs = srom_dev_attrs;
+	srom_class->dev_groups = srom_dev_groups;
 	srom_class->devnode = srom_devnode;
 
 	/* Do per-partition initialization */
-- 
1.8.3.rc0.20.gb99dd2e

