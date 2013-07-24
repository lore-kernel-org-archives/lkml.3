Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3GXWGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3GXWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/36] bsr: convert bsr_class to use dev_groups
Date: Wed, 24 Jul 2013 15:05:06 -0700
Message-Id: <1374703539-9705-4-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the bsr bsr_class code to use
the correct field.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/bsr.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 97467053..0671e45d 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -95,6 +95,7 @@ bsr_size_show(struct device *dev, struct device_attribute *attr, char *buf)
 	struct bsr_dev *bsr_dev = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", bsr_dev->bsr_bytes);
 }
+static DEVICE_ATTR_RO(bsr_size);
 
 static ssize_t
 bsr_stride_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -102,20 +103,23 @@ bsr_stride_show(struct device *dev, struct device_attribute *attr, char *buf)
 	struct bsr_dev *bsr_dev = dev_get_drvdata(dev);
 	return sprintf(buf, "%u\n", bsr_dev->bsr_stride);
 }
+static DEVICE_ATTR_RO(bsr_stride);
 
 static ssize_t
-bsr_len_show(struct device *dev, struct device_attribute *attr, char *buf)
+bsr_length_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct bsr_dev *bsr_dev = dev_get_drvdata(dev);
 	return sprintf(buf, "%llu\n", bsr_dev->bsr_len);
 }
+static DEVICE_ATTR_RO(bsr_length);
 
-static struct device_attribute bsr_dev_attrs[] = {
-	__ATTR(bsr_size, S_IRUGO, bsr_size_show, NULL),
-	__ATTR(bsr_stride, S_IRUGO, bsr_stride_show, NULL),
-	__ATTR(bsr_length, S_IRUGO, bsr_len_show, NULL),
-	__ATTR_NULL
+static struct attribute *bsr_dev_attrs[] = {
+	&dev_attr_bsr_size.attr,
+	&dev_attr_bsr_stride.attr,
+	&dev_attr_bsr_length.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(bsr_dev);
 
 static int bsr_mmap(struct file *filp, struct vm_area_struct *vma)
 {
@@ -308,7 +312,7 @@ static int __init bsr_init(void)
 		ret = PTR_ERR(bsr_class);
 		goto out_err_1;
 	}
-	bsr_class->dev_attrs = bsr_dev_attrs;
+	bsr_class->dev_groups = bsr_dev_groups;
 
 	ret = alloc_chrdev_region(&bsr_dev, 0, BSR_MAX_DEVS, "bsr");
 	bsr_major = MAJOR(bsr_dev);
-- 
1.8.3.rc0.20.gb99dd2e

