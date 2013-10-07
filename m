Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3JGG40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:56:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3JGG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:56:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH 08/11] rapidio: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:47 -0700
Message-Id: <1381128950-28125-9-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the rapidio bus code to use the
correct field.

Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Matt and Alexandre, I can take this through my driver-core tree if you
like, just let me know what would be the easiest for you.

 drivers/rapidio/rio-driver.c |  2 +-
 drivers/rapidio/rio-sysfs.c  | 38 ++++++++++++++++++++++++--------------
 drivers/rapidio/rio.h        |  2 +-
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 2be2d24..c9ae692 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -223,7 +223,7 @@ struct device rio_bus = {
 struct bus_type rio_bus_type = {
 	.name = "rapidio",
 	.match = rio_match_bus,
-	.dev_attrs = rio_dev_attrs,
+	.dev_groups = rio_dev_groups,
 	.bus_groups = rio_bus_groups,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 795a477..e0221c6 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -27,6 +27,7 @@ field##_show(struct device *dev, struct device_attribute *attr, char *buf)			\
 									\
 	return sprintf(buf, format_string, rdev->field);		\
 }									\
+static DEVICE_ATTR_RO(field);
 
 rio_config_attr(did, "0x%04x\n");
 rio_config_attr(vid, "0x%04x\n");
@@ -54,6 +55,7 @@ static ssize_t routes_show(struct device *dev, struct device_attribute *attr, ch
 
 	return (str - buf);
 }
+static DEVICE_ATTR_RO(routes);
 
 static ssize_t lprev_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
@@ -63,6 +65,7 @@ static ssize_t lprev_show(struct device *dev,
 	return sprintf(buf, "%s\n",
 			(rdev->prev) ? rio_name(rdev->prev) : "root");
 }
+static DEVICE_ATTR_RO(lprev);
 
 static ssize_t lnext_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
@@ -83,6 +86,7 @@ static ssize_t lnext_show(struct device *dev,
 
 	return str - buf;
 }
+static DEVICE_ATTR_RO(lnext);
 
 static ssize_t modalias_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
@@ -92,23 +96,29 @@ static ssize_t modalias_show(struct device *dev,
 	return sprintf(buf, "rapidio:v%04Xd%04Xav%04Xad%04X\n",
 		       rdev->vid, rdev->did, rdev->asm_vid, rdev->asm_did);
 }
+static DEVICE_ATTR_RO(modalias);
+
+static struct attribute *rio_dev_attrs[] = {
+	&dev_attr_did.attr,
+	&dev_attr_vid.attr,
+	&dev_attr_device_rev.attr,
+	&dev_attr_asm_did.attr,
+	&dev_attr_asm_vid.attr,
+	&dev_attr_asm_rev.attr,
+	&dev_attr_lprev.attr,
+	&dev_attr_destid.attr,
+	&dev_attr_modalias.attr,
+	NULL,
+};
 
-struct device_attribute rio_dev_attrs[] = {
-	__ATTR_RO(did),
-	__ATTR_RO(vid),
-	__ATTR_RO(device_rev),
-	__ATTR_RO(asm_did),
-	__ATTR_RO(asm_vid),
-	__ATTR_RO(asm_rev),
-	__ATTR_RO(lprev),
-	__ATTR_RO(destid),
-	__ATTR_RO(modalias),
-	__ATTR_NULL,
+static const struct attribute_group rio_dev_group = {
+	.attrs = rio_dev_attrs,
 };
 
-static DEVICE_ATTR(routes, S_IRUGO, routes_show, NULL);
-static DEVICE_ATTR(lnext, S_IRUGO, lnext_show, NULL);
-static DEVICE_ATTR(hopcount, S_IRUGO, hopcount_show, NULL);
+const struct attribute_group *rio_dev_groups[] = {
+	&rio_dev_group,
+	NULL,
+};
 
 static ssize_t
 rio_read_config(struct file *filp, struct kobject *kobj,
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index 57d2ad0..5f99d22 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -48,7 +48,7 @@ extern struct rio_mport *rio_find_mport(int mport_id);
 extern int rio_mport_scan(int mport_id);
 
 /* Structures internal to the RIO core code */
-extern struct device_attribute rio_dev_attrs[];
+extern const struct attribute_group *rio_dev_groups[];
 extern const struct attribute_group *rio_bus_groups[];
 
 #define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
-- 
1.8.4.6.g82e253f.dirty

