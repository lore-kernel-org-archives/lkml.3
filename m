Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3GXWKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:10:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3GXWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH 34/36] c2port: convert class code to use bin_attrs in groups
Date: Wed, 24 Jul 2013 15:05:37 -0700
Message-Id: <1374703539-9705-35-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that attribute groups support binary attributes, use them instead of
the dev_bin_attrs field in struct class, as that is going away soon.

Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/c2port/core.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index abe6e251..464419b3 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -856,6 +856,9 @@ static ssize_t c2port_write_flash_data(struct file *filp, struct kobject *kobj,
 
 	return ret;
 }
+/* size is computed at run-time */
+static BIN_ATTR(flash_data, 0644, c2port_read_flash_data,
+		c2port_write_flash_data, 0);
 
 /*
  * Class attributes
@@ -873,19 +876,20 @@ static struct attribute *c2port_attrs[] = {
 	&dev_attr_flash_erase.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(c2port);
-
-static struct bin_attribute c2port_bin_attrs[] = {
-	{
-		.attr	= {
-			.name	= "flash_data",
-			.mode	= 0644
-		},
-		.read	= c2port_read_flash_data,
-		.write	= c2port_write_flash_data,
-		/* .size is computed at run-time */
-	},
-	__ATTR_NULL
+
+static struct bin_attribute *c2port_bin_attrs[] = {
+	&bin_attr_flash_data,
+	NULL,
+};
+
+static const struct attribute_group c2port_group = {
+	.attrs = c2port_attrs,
+	.bin_attrs = c2port_bin_attrs,
+};
+
+static const struct attribute_group *c2port_groups[] = {
+	&c2port_group,
+	NULL,
 };
 
 /*
@@ -918,7 +922,7 @@ struct c2port_device *c2port_device_register(char *name,
 		goto error_idr_alloc;
 	c2dev->id = ret;
 
-	c2port_bin_attrs[0].size = ops->blocks_num * ops->block_size;
+	bin_attr_flash_data.size = ops->blocks_num * ops->block_size;
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 				   "c2port%d", c2dev->id);
@@ -988,7 +992,6 @@ static int __init c2port_init(void)
 		return PTR_ERR(c2port_class);
 	}
 	c2port_class->dev_groups = c2port_groups;
-	c2port_class->dev_bin_attrs = c2port_bin_attrs;
 
 	return 0;
 }
-- 
1.8.3.rc0.20.gb99dd2e

