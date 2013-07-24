Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3GXWGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3GXWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 05/36] dma: convert dma_devclass to use dev_groups
Date: Wed, 24 Jul 2013 15:05:08 -0700
Message-Id: <1374703539-9705-6-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the dma dma_devclass code to use
the correct field.

Cc: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Dan and Vinod, feel free to apply this to your trees, or ACK it and I can take
it through mine.

 drivers/dma/dmaengine.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9e56745f..99af4db5 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -87,7 +87,8 @@ static struct dma_chan *dev_to_dma_chan(struct device *dev)
 	return chan_dev->chan;
 }
 
-static ssize_t show_memcpy_count(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t memcpy_count_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
 	struct dma_chan *chan;
 	unsigned long count = 0;
@@ -106,9 +107,10 @@ static ssize_t show_memcpy_count(struct device *dev, struct device_attribute *at
 
 	return err;
 }
+static DEVICE_ATTR_RO(memcpy_count);
 
-static ssize_t show_bytes_transferred(struct device *dev, struct device_attribute *attr,
-				      char *buf)
+static ssize_t bytes_transferred_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
 {
 	struct dma_chan *chan;
 	unsigned long count = 0;
@@ -127,8 +129,10 @@ static ssize_t show_bytes_transferred(struct device *dev, struct device_attribut
 
 	return err;
 }
+static DEVICE_ATTR_RO(bytes_transferred);
 
-static ssize_t show_in_use(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t in_use_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
 	struct dma_chan *chan;
 	int err;
@@ -143,13 +147,15 @@ static ssize_t show_in_use(struct device *dev, struct device_attribute *attr, ch
 
 	return err;
 }
+static DEVICE_ATTR_RO(in_use);
 
-static struct device_attribute dma_attrs[] = {
-	__ATTR(memcpy_count, S_IRUGO, show_memcpy_count, NULL),
-	__ATTR(bytes_transferred, S_IRUGO, show_bytes_transferred, NULL),
-	__ATTR(in_use, S_IRUGO, show_in_use, NULL),
-	__ATTR_NULL
+static struct attribute *dma_dev_attrs[] = {
+	&dev_attr_memcpy_count.attr,
+	&dev_attr_bytes_transferred.attr,
+	&dev_attr_in_use.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(dma_dev);
 
 static void chan_dev_release(struct device *dev)
 {
@@ -167,7 +173,7 @@ static void chan_dev_release(struct device *dev)
 
 static struct class dma_devclass = {
 	.name		= "dma",
-	.dev_attrs	= dma_attrs,
+	.dev_groups	= dma_dev_groups,
 	.dev_release	= chan_dev_release,
 };
 
-- 
1.8.3.rc0.20.gb99dd2e

