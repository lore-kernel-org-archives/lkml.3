Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3CODYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:24:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55798 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3CODYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:24:47 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Thu, 14 Mar 2013 22:24:43 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 1/2] fs: sysfs: Add support for devm_ functions
Date: Thu, 14 Mar 2013 20:24:46 -0700
Message-Id: <1363317887-24009-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for
devm_sysfs_create_file
devm_sysfs_remove_file
devm_sysfs_create_group
devm_sysfs_remove_group

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 fs/sysfs/file.c       |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/group.c      |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |   30 ++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 602f56d..d8f4631 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/limits.h>
+#include <linux/device.h>
 #include <asm/uaccess.h>
 
 #include "sysfs.h"
@@ -589,6 +590,40 @@ int sysfs_create_files(struct kobject *kobj, const struct attribute **ptr)
 	return err;
 }
 
+struct sysfs_devres {
+	struct list_head node;
+	const struct attribute *attr;
+};
+
+static void devm_sysfs_file_release(struct device *dev, void *res)
+{
+	struct sysfs_devres *devres = res;
+
+	sysfs_remove_file(&dev->kobj, devres->attr);
+}
+
+int devm_sysfs_create_file(struct device *dev, const struct attribute *attr)
+{
+	struct sysfs_devres *devres;
+	int ret;
+
+	devres = devres_alloc(devm_sysfs_file_release, sizeof(*devres),
+			      GFP_KERNEL);
+	if (!devres)
+		return -ENOMEM;
+
+	devres->attr = attr;
+
+	ret = sysfs_create_file(&dev->kobj, attr);
+	if (!ret)
+		devres_add(dev, devres);
+	else
+		devres_free(devres);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_sysfs_create_file);
+
 /**
  * sysfs_add_file_to_group - add an attribute file to a pre-existing group.
  * @kobj: object we're acting for.
@@ -678,6 +713,22 @@ void sysfs_remove_files(struct kobject * kobj, const struct attribute **ptr)
 		sysfs_remove_file(kobj, ptr[i]);
 }
 
+static int devm_sysfs_device_match(struct device *dev, void *res, void *data)
+{
+	struct sysfs_devres *devres = res;
+
+	return devres->attr == data;
+}
+
+void devm_sysfs_remove_file(struct device *dev, const struct attribute *attr)
+{
+	WARN_ON(devres_destroy(dev, devm_sysfs_file_release,
+			       devm_sysfs_device_match, (void *)attr));
+
+	sysfs_remove_file(&dev->kobj, attr);
+}
+EXPORT_SYMBOL_GPL(devm_sysfs_remove_file);
+
 /**
  * sysfs_remove_file_from_group - remove an attribute file from a group.
  * @kobj: object we're acting for.
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index aec3d5c..a0b8f95 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -13,6 +13,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/err.h>
+#include <linux/device.h>
 #include "sysfs.h"
 
 
@@ -104,6 +105,41 @@ int sysfs_create_group(struct kobject *kobj,
 	return internal_create_group(kobj, 0, grp);
 }
 
+struct sysfs_devres {
+	struct list_head node;
+	const struct attribute_group *grp;
+};
+
+static void devm_sysfs_group_release(struct device *dev, void *res)
+{
+	struct sysfs_devres *devres = res;
+
+	sysfs_remove_group(&dev->kobj, devres->grp);
+}
+
+int devm_sysfs_create_group(struct device *dev,
+			    const struct attribute_group *grp)
+{
+	struct sysfs_devres *devres;
+	int ret;
+
+	devres = devres_alloc(devm_sysfs_group_release, sizeof(*devres),
+			      GFP_KERNEL);
+	if (!devres)
+		return -ENOMEM;
+
+	devres->grp = grp;
+
+	ret = sysfs_create_group(&dev->kobj, grp);
+	if (!ret)
+		devres_add(dev, devres);
+	else
+		devres_free(devres);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_sysfs_create_group);
+
 /**
  * sysfs_update_group - given a directory kobject, update an attribute group
  * @kobj:	The kobject to update the group on
@@ -152,6 +188,23 @@ void sysfs_remove_group(struct kobject * kobj,
 	sysfs_put(sd);
 }
 
+static int devm_sysfs_device_match(struct device *dev, void *res, void *data)
+{
+	struct sysfs_devres *devres = res;
+
+	return devres->grp == data;
+}
+
+void devm_sysfs_remove_group(struct device *dev,
+			     const struct attribute_group *grp)
+{
+	WARN_ON(devres_destroy(dev, devm_sysfs_group_release,
+			       devm_sysfs_device_match, (void *)grp));
+
+	sysfs_remove_group(&dev->kobj, grp);
+}
+EXPORT_SYMBOL_GPL(devm_sysfs_remove_group);
+
 /**
  * sysfs_merge_group - merge files into a pre-existing attribute group.
  * @kobj:	The kobject containing the group.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index e2cee22..df0fa5a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 
 struct kobject;
+struct device;
 struct module;
 enum kobj_ns_type;
 
@@ -142,11 +143,14 @@ int __must_check sysfs_move_dir(struct kobject *kobj,
 
 int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
+int __must_check devm_sysfs_create_file(struct device *dev,
+				   const struct attribute *attr);
 int __must_check sysfs_create_files(struct kobject *kobj,
 				   const struct attribute **attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj,
 				  const struct attribute *attr, umode_t mode);
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
+void devm_sysfs_remove_file(struct device *dev, const struct attribute *attr);
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr);
 
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
@@ -169,10 +173,14 @@ void sysfs_delete_link(struct kobject *dir, struct kobject *targ,
 
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
+int __must_check devm_sysfs_create_group(struct device *dev,
+					 const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
 		       const struct attribute_group *grp);
 void sysfs_remove_group(struct kobject *kobj,
 			const struct attribute_group *grp);
+void devm_sysfs_remove_group(struct device *dev,
+			     const struct attribute_group *grp);
 int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
@@ -230,6 +238,12 @@ static inline int sysfs_create_file(struct kobject *kobj,
 	return 0;
 }
 
+static inline int devm_sysfs_create_file(struct device *dev,
+					 const struct attribute *attr)
+{
+	return 0;
+}
+
 static inline int sysfs_create_files(struct kobject *kobj,
 				    const struct attribute **attr)
 {
@@ -247,6 +261,11 @@ static inline void sysfs_remove_file(struct kobject *kobj,
 {
 }
 
+static inline void devm_sysfs_remove_file(struct device *dev,
+					  const struct attribute *attr)
+{
+}
+
 static inline void sysfs_remove_files(struct kobject *kobj,
 				     const struct attribute **attr)
 {
@@ -297,6 +316,12 @@ static inline int sysfs_create_group(struct kobject *kobj,
 	return 0;
 }
 
+static inline int devm_sysfs_create_group(struct device *dev,
+					  const struct attribute_group *grp)
+{
+	return 0;
+}
+
 static inline int sysfs_update_group(struct kobject *kobj,
 				const struct attribute_group *grp)
 {
@@ -308,6 +333,11 @@ static inline void sysfs_remove_group(struct kobject *kobj,
 {
 }
 
+static inline void devm_sysfs_remove_group(struct device *dev,
+					   const struct attribute_group *grp)
+{
+}
+
 static inline int sysfs_add_file_to_group(struct kobject *kobj,
 		const struct attribute *attr, const char *group)
 {
-- 
1.7.9.7

