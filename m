Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3HUALw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:11:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab3HUALu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:11:50 -0400
Date: Tue, 20 Aug 2013 17:11:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: bgrt: take advantage of binary sysfs groups
Message-ID: <20130821001149.GA16350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

Attribute groups now can handle binary sysfs attributes, so clean up the
code here by using a binary attribute array.  This saves us the extra
call to create the binary attribute at saves 6 lines overall.

Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
 I can take this in my driver-core tree if someone from ACPI acks it,
 otherwise, feel free to take it through the ACPI trees instead, just
 let me know.

 drivers/acpi/bgrt.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index be603995..7a4128d9 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -51,20 +51,14 @@ static ssize_t show_yoffset(struct device *dev,
 }
 static DEVICE_ATTR(yoffset, S_IRUGO, show_yoffset, NULL);
 
-static ssize_t show_image(struct file *file, struct kobject *kobj,
+static ssize_t image_read(struct file *file, struct kobject *kobj,
 	       struct bin_attribute *attr, char *buf, loff_t off, size_t count)
 {
 	memcpy(buf, attr->private + off, count);
 	return count;
 }
 
-static struct bin_attribute image_attr = {
-	.attr = {
-		.name = "image",
-		.mode = S_IRUGO,
-	},
-	.read = show_image,
-};
+static BIN_ATTR_RO(image, 0);	/* size gets filled in later */
 
 static struct attribute *bgrt_attributes[] = {
 	&dev_attr_version.attr,
@@ -75,8 +69,14 @@ static struct attribute *bgrt_attributes[] = {
 	NULL,
 };
 
+static struct bin_attribute *bgrt_bin_attributes[] = {
+	&bin_attr_image,
+	NULL,
+};
+
 static struct attribute_group bgrt_attribute_group = {
 	.attrs = bgrt_attributes,
+	.bin_attrs = bgrt_bin_attributes,
 };
 
 static int __init bgrt_init(void)
@@ -87,8 +87,8 @@ static int __init bgrt_init(void)
 		return -ENODEV;
 
 	sysfs_bin_attr_init(&image_attr);
-	image_attr.private = bgrt_image;
-	image_attr.size = bgrt_image_size;
+	bin_attr_image.private = bgrt_image;
+	bin_attr_image.size = bgrt_image_size;
 
 	bgrt_kobj = kobject_create_and_add("bgrt", acpi_kobj);
 	if (!bgrt_kobj)
@@ -98,14 +98,8 @@ static int __init bgrt_init(void)
 	if (ret)
 		goto out_kobject;
 
-	ret = sysfs_create_bin_file(bgrt_kobj, &image_attr);
-	if (ret)
-		goto out_group;
-
 	return 0;
 
-out_group:
-	sysfs_remove_group(bgrt_kobj, &bgrt_attribute_group);
 out_kobject:
 	kobject_put(bgrt_kobj);
 	return ret;
