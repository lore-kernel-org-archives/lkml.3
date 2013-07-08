Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3GHSeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:34:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHSeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:34:21 -0400
Date: Mon, 8 Jul 2013 11:34:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: c2port: use dev_bin_attrs instead of hand-coding it
Message-ID: <20130708183419.GA2535@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Classes support a list of default binary attributes, so use that in the
c2port driver, instead of hand creating and destroying the file, which
is racing with userspace.  Bonus is this removes lines of code.

Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
--
 drivers/misc/c2port/core.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index f32550a..a3b8370 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -867,14 +867,17 @@ static struct device_attribute c2port_attrs[] = {
 	__ATTR_NULL,
 };
 
-static struct bin_attribute c2port_bin_attrs = {
-	.attr	= {
-		.name	= "flash_data",
-		.mode	= 0644
+static struct bin_attribute c2port_bin_attrs[] = {
+	{
+		.attr	= {
+			.name	= "flash_data",
+			.mode	= 0644
+		},
+		.read	= c2port_read_flash_data,
+		.write	= c2port_write_flash_data,
+		/* .size is computed at run-time */
 	},
-	.read	= c2port_read_flash_data,
-	.write	= c2port_write_flash_data,
-	/* .size is computed at run-time */
+	__ATTR_NULL
 };
 
 /*
@@ -907,6 +910,8 @@ struct c2port_device *c2port_device_register(char *name,
 		goto error_idr_alloc;
 	c2dev->id = ret;
 
+	c2port_bin_attrs[0].size = ops->blocks_num * ops->block_size;
+
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 				   "c2port%d", c2dev->id);
 	if (unlikely(IS_ERR(c2dev->dev))) {
@@ -919,12 +924,6 @@ struct c2port_device *c2port_device_register(char *name,
 	c2dev->ops = ops;
 	mutex_init(&c2dev->mutex);
 
-	/* Create binary file */
-	c2port_bin_attrs.size = ops->blocks_num * ops->block_size;
-	ret = device_create_bin_file(c2dev->dev, &c2port_bin_attrs);
-	if (unlikely(ret))
-		goto error_device_create_bin_file;
-
 	/* By default C2 port access is off */
 	c2dev->access = c2dev->flash_access = 0;
 	ops->access(c2dev, 0);
@@ -937,9 +936,6 @@ struct c2port_device *c2port_device_register(char *name,
 
 	return c2dev;
 
-error_device_create_bin_file:
-	device_destroy(c2port_class, 0);
-
 error_device_create:
 	spin_lock_irq(&c2port_idr_lock);
 	idr_remove(&c2port_idr, c2dev->id);
@@ -959,7 +955,6 @@ void c2port_device_unregister(struct c2port_device *c2dev)
 
 	dev_info(c2dev->dev, "C2 port %s removed\n", c2dev->name);
 
-	device_remove_bin_file(c2dev->dev, &c2port_bin_attrs);
 	spin_lock_irq(&c2port_idr_lock);
 	idr_remove(&c2port_idr, c2dev->id);
 	spin_unlock_irq(&c2port_idr_lock);
@@ -985,6 +980,7 @@ static int __init c2port_init(void)
 		return PTR_ERR(c2port_class);
 	}
 	c2port_class->dev_attrs = c2port_attrs;
+	c2port_class->dev_bin_attrs = c2port_bin_attrs;
 
 	return 0;
 }
