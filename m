Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3HaW40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 18:56:26 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51803 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3HaW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 18:56:25 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging: dgrp: Convert to use device_create_with_groups
Date: Sat, 31 Aug 2013 15:56:06 -0700
Message-Id: <1377989766-7462-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device_create_with_groups to create sysfs attributes together with device.
Also create class attribute together with class registration.
This simplifies the code and ensures that attribute files exist when udev
events are generated.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
I suspect that the 'register_with_sysfs' attribute exists to work around
the problem solved with this patch. It doesn't make much sense otherwise.
Can it be removed ?

Compile tested only.

 drivers/staging/dgrp/dgrp_sysfs.c |   97 +++++++++++++++----------------------
 1 file changed, 39 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index 8cee9c8..b65fa83 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -31,7 +31,6 @@
 #define SERIAL_TYPE_XPRINT      3
 
 
-static struct class *dgrp_class;
 static struct device *dgrp_class_nodes_dev;
 static struct device *dgrp_class_global_settings_dev;
 
@@ -41,8 +40,17 @@ static ssize_t dgrp_class_version_show(struct class *class,
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", DIGI_VERSION);
 }
-static CLASS_ATTR(driver_version, 0400, dgrp_class_version_show, NULL);
 
+struct class_attribute dgrp_class_attrs[] = {
+	__ATTR(driver_version, 0400, dgrp_class_version_show, NULL),
+	{ }
+};
+
+static struct class dgrp_class = {
+	.owner = THIS_MODULE,
+	.name = "digi_realport",
+	.class_attrs = dgrp_class_attrs,
+};
 
 static ssize_t dgrp_class_register_with_sysfs_show(struct device *c,
 						   struct device_attribute *attr,
@@ -83,51 +91,41 @@ static struct attribute_group dgrp_global_settings_attribute_group = {
 	.attrs = dgrp_sysfs_global_settings_entries,
 };
 
-
+static const struct attribute_group *dgrp_global_settings_attribute_groups[] = {
+	&dgrp_global_settings_attribute_group,
+	NULL
+};
 
 int dgrp_create_class_sysfs_files(void)
 {
-	int ret = 0;
+	int ret;
 	int max_majors = 1U << (32 - MINORBITS);
 
-	dgrp_class = class_create(THIS_MODULE, "digi_realport");
-	if (IS_ERR(dgrp_class))
-		return PTR_ERR(dgrp_class);
-	ret = class_create_file(dgrp_class, &class_attr_driver_version);
+	ret = class_register(&dgrp_class);
 	if (ret)
-		goto err_class;
+		return ret;
 
-	dgrp_class_global_settings_dev = device_create(dgrp_class, NULL,
-		MKDEV(0, max_majors + 1), NULL, "driver_settings");
+	dgrp_class_global_settings_dev =
+	  device_create_with_groups(&dgrp_class, NULL, MKDEV(0, max_majors + 1),
+				    NULL, dgrp_global_settings_attribute_groups,
+				    "driver_settings");
 	if (IS_ERR(dgrp_class_global_settings_dev)) {
 		ret = PTR_ERR(dgrp_class_global_settings_dev);
-		goto err_file;
-	}
-	ret = sysfs_create_group(&dgrp_class_global_settings_dev->kobj,
-		&dgrp_global_settings_attribute_group);
-	if (ret) {
-		pr_alert("%s: failed to create sysfs global settings device attributes.\n",
-			__func__);
-		goto err_dev1;
+		goto err_class;
 	}
 
-	dgrp_class_nodes_dev = device_create(dgrp_class, NULL,
+	dgrp_class_nodes_dev = device_create(&dgrp_class, NULL,
 		MKDEV(0, max_majors + 2), NULL, "nodes");
 	if (IS_ERR(dgrp_class_nodes_dev)) {
 		ret = PTR_ERR(dgrp_class_nodes_dev);
-		goto err_group;
+		goto err_dev1;
 	}
 
 	return 0;
-err_group:
-	sysfs_remove_group(&dgrp_class_global_settings_dev->kobj,
-		&dgrp_global_settings_attribute_group);
 err_dev1:
-	device_destroy(dgrp_class, MKDEV(0, max_majors + 1));
-err_file:
-	class_remove_file(dgrp_class, &class_attr_driver_version);
+	device_destroy(&dgrp_class, MKDEV(0, max_majors + 1));
 err_class:
-	class_destroy(dgrp_class);
+	class_unregister(&dgrp_class);
 	return ret;
 }
 
@@ -140,14 +138,9 @@ void dgrp_remove_class_sysfs_files(void)
 	list_for_each_entry(nd, &nd_struct_list, list)
 		dgrp_remove_node_class_sysfs_files(nd);
 
-	sysfs_remove_group(&dgrp_class_global_settings_dev->kobj,
-		&dgrp_global_settings_attribute_group);
-
-	class_remove_file(dgrp_class, &class_attr_driver_version);
-
-	device_destroy(dgrp_class, MKDEV(0, max_majors + 1));
-	device_destroy(dgrp_class, MKDEV(0, max_majors + 2));
-	class_destroy(dgrp_class);
+	device_destroy(&dgrp_class, MKDEV(0, max_majors + 1));
+	device_destroy(&dgrp_class, MKDEV(0, max_majors + 2));
+	class_unregister(&dgrp_class);
 }
 
 static ssize_t dgrp_node_state_show(struct device *c,
@@ -261,10 +254,13 @@ static struct attribute_group dgrp_node_attribute_group = {
 	.attrs = dgrp_sysfs_node_entries,
 };
 
+static const struct attribute_group *dgrp_node_attribute_groups[] = {
+	&dgrp_node_attribute_group,
+	NULL
+};
 
 void dgrp_create_node_class_sysfs_files(struct nd_struct *nd)
 {
-	int ret;
 	char name[10];
 
 	if (nd->nd_ID)
@@ -272,32 +268,17 @@ void dgrp_create_node_class_sysfs_files(struct nd_struct *nd)
 	else
 		sprintf(name, "node%ld", nd->nd_major);
 
-	nd->nd_class_dev = device_create(dgrp_class, dgrp_class_nodes_dev,
-		MKDEV(0, nd->nd_major), NULL, "%s", name);
-
-	ret = sysfs_create_group(&nd->nd_class_dev->kobj,
-				 &dgrp_node_attribute_group);
-
-	if (ret) {
-		pr_alert("%s: failed to create sysfs node device attributes.\n",
-			__func__);
-		sysfs_remove_group(&nd->nd_class_dev->kobj,
-				   &dgrp_node_attribute_group);
-		return;
-	}
-
-	dev_set_drvdata(nd->nd_class_dev, nd);
-
+	nd->nd_class_dev =
+	  device_create_with_groups(&dgrp_class, dgrp_class_nodes_dev,
+				    MKDEV(0, nd->nd_major), nd,
+				    dgrp_node_attribute_groups,
+				    "%s", name);
 }
 
-
 void dgrp_remove_node_class_sysfs_files(struct nd_struct *nd)
 {
 	if (nd->nd_class_dev) {
-		sysfs_remove_group(&nd->nd_class_dev->kobj,
-				   &dgrp_node_attribute_group);
-
-		device_destroy(dgrp_class, MKDEV(0, nd->nd_major));
+		device_destroy(&dgrp_class, MKDEV(0, nd->nd_major));
 		nd->nd_class_dev = NULL;
 	}
 }
-- 
1.7.9.7

