Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3GXWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3GXWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/36] enclosure: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:16 -0700
Message-Id: <1374703539-9705-14-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the enclosure class code to use
the correct field.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/enclosure.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fcac8..0e8df41a 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -239,7 +239,7 @@ static void enclosure_component_release(struct device *dev)
 	put_device(dev->parent);
 }
 
-static const struct attribute_group *enclosure_groups[];
+static const struct attribute_group *enclosure_component_groups[];
 
 /**
  * enclosure_component_register - add a particular component to an enclosure
@@ -282,7 +282,7 @@ enclosure_component_register(struct enclosure_device *edev,
 		dev_set_name(cdev, "%u", number);
 
 	cdev->release = enclosure_component_release;
-	cdev->groups = enclosure_groups;
+	cdev->groups = enclosure_component_groups;
 
 	err = device_register(cdev);
 	if (err) {
@@ -365,25 +365,26 @@ EXPORT_SYMBOL_GPL(enclosure_remove_device);
  * sysfs pieces below
  */
 
-static ssize_t enclosure_show_components(struct device *cdev,
-					 struct device_attribute *attr,
-					 char *buf)
+static ssize_t components_show(struct device *cdev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct enclosure_device *edev = to_enclosure_device(cdev);
 
 	return snprintf(buf, 40, "%d\n", edev->components);
 }
+static DEVICE_ATTR_RO(components);
 
-static struct device_attribute enclosure_attrs[] = {
-	__ATTR(components, S_IRUGO, enclosure_show_components, NULL),
-	__ATTR_NULL
+static struct attribute *enclosure_class_attrs[] = {
+	&dev_attr_components.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(enclosure_class);
 
 static struct class enclosure_class = {
 	.name			= "enclosure",
 	.owner			= THIS_MODULE,
 	.dev_release		= enclosure_release,
-	.dev_attrs		= enclosure_attrs,
+	.dev_groups		= enclosure_class_groups,
 };
 
 static const char *const enclosure_status [] = {
@@ -536,15 +537,7 @@ static struct attribute *enclosure_component_attrs[] = {
 	&dev_attr_type.attr,
 	NULL
 };
-
-static struct attribute_group enclosure_group = {
-	.attrs = enclosure_component_attrs,
-};
-
-static const struct attribute_group *enclosure_groups[] = {
-	&enclosure_group,
-	NULL
-};
+ATTRIBUTE_GROUPS(enclosure_component);
 
 static int __init enclosure_init(void)
 {
-- 
1.8.3.rc0.20.gb99dd2e

