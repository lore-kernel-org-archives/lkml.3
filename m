Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3HUUfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:35:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3HUUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:35:07 -0400
Date: Wed, 21 Aug 2013 13:35:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: add sysfs_create/remove_groups()
Message-ID: <20130821203506.GA1663@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

These functions are being open-coded in 3 different places in the driver
core, and other driver subsystems will want to start doing this as well,
so move it to the sysfs core to keep it all in one place, where we know
it is written properly.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/bus.c    |   23 +---------------------
 drivers/base/core.c   |   22 +--------------------
 drivers/base/driver.c |   22 +--------------------
 fs/sysfs/group.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |    4 +++
 5 files changed, 62 insertions(+), 61 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -884,32 +884,13 @@ static void bus_remove_attrs(struct bus_
 static int bus_add_groups(struct bus_type *bus,
 			  const struct attribute_group **groups)
 {
-	int error = 0;
-	int i;
-
-	if (groups) {
-		for (i = 0; groups[i]; i++) {
-			error = sysfs_create_group(&bus->p->subsys.kobj,
-						   groups[i]);
-			if (error) {
-				while (--i >= 0)
-					sysfs_remove_group(&bus->p->subsys.kobj,
-							   groups[i]);
-				break;
-			}
-		}
-	}
-	return error;
+	return sysfs_create_groups(&bus->p->subsys.kobj, groups);
 }
 
 static void bus_remove_groups(struct bus_type *bus,
 			      const struct attribute_group **groups)
 {
-	int i;
-
-	if (groups)
-		for (i = 0; groups[i]; i++)
-			sysfs_remove_group(&bus->p->subsys.kobj, groups[i]);
+	sysfs_remove_groups(&bus->p->subsys.kobj, groups);
 }
 
 static void klist_devices_get(struct klist_node *n)
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -493,31 +493,13 @@ static void device_remove_bin_attributes
 
 int device_add_groups(struct device *dev, const struct attribute_group **groups)
 {
-	int error = 0;
-	int i;
-
-	if (groups) {
-		for (i = 0; groups[i]; i++) {
-			error = sysfs_create_group(&dev->kobj, groups[i]);
-			if (error) {
-				while (--i >= 0)
-					sysfs_remove_group(&dev->kobj,
-							   groups[i]);
-				break;
-			}
-		}
-	}
-	return error;
+	return sysfs_create_groups(&dev->kobj, groups);
 }
 
 void device_remove_groups(struct device *dev,
 			  const struct attribute_group **groups)
 {
-	int i;
-
-	if (groups)
-		for (i = 0; groups[i]; i++)
-			sysfs_remove_group(&dev->kobj, groups[i]);
+	sysfs_remove_groups(&dev->kobj, groups);
 }
 
 static int device_add_attrs(struct device *dev)
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -126,31 +126,13 @@ EXPORT_SYMBOL_GPL(driver_remove_file);
 int driver_add_groups(struct device_driver *drv,
 		      const struct attribute_group **groups)
 {
-	int error = 0;
-	int i;
-
-	if (groups) {
-		for (i = 0; groups[i]; i++) {
-			error = sysfs_create_group(&drv->p->kobj, groups[i]);
-			if (error) {
-				while (--i >= 0)
-					sysfs_remove_group(&drv->p->kobj,
-							   groups[i]);
-				break;
-			}
-		}
-	}
-	return error;
+	return sysfs_create_groups(&drv->p->kobj, groups);
 }
 
 void driver_remove_groups(struct device_driver *drv,
 			  const struct attribute_group **groups)
 {
-	int i;
-
-	if (groups)
-		for (i = 0; groups[i]; i++)
-			sysfs_remove_group(&drv->p->kobj, groups[i]);
+	sysfs_remove_groups(&drv->p->kobj, groups);
 }
 
 /**
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -131,6 +131,39 @@ int sysfs_create_group(struct kobject *k
 }
 
 /**
+ * sysfs_create_groups - given a directory kobject, create a bunch of attribute groups
+ * @kobj:	The kobject to create the group on
+ * @groups:	The attribute groups to create, NULL terminated
+ *
+ * This function creates a bunch of attribute groups.  If an error occurs when
+ * creating a group, all previously created groups will be removed, unwinding
+ * everything back to the original state when this function was called.
+ * It will explicitly warn and error if any of the attribute files being
+ * created already exist.
+ *
+ * Returns 0 on success or error.
+ */
+int sysfs_create_groups(struct kobject *kobj,
+			const struct attribute_group **groups)
+{
+	int error = 0;
+	int i;
+
+	if (!groups)
+		return 0;
+
+	for (i = 0; groups[i]; i++) {
+		error = sysfs_create_group(kobj, groups[i]);
+		if (error) {
+			while (--i >= 0)
+				sysfs_remove_group(kobj, groups[i]);
+			break;
+		}
+	}
+	return error;
+}
+
+/**
  * sysfs_update_group - given a directory kobject, update an attribute group
  * @kobj:	The kobject to update the group on
  * @grp:	The attribute group to update
@@ -179,6 +212,25 @@ void sysfs_remove_group(struct kobject *
 }
 
 /**
+ * sysfs_remove_groups - remove a list of groups
+ *
+ * kobj:	The kobject for the groups to be removed from
+ * groups:	NULL terminated list of groups to be removed
+ *
+ * If groups is not NULL, the all groups will be removed from the kobject
+ */
+void sysfs_remove_groups(struct kobject *kobj,
+			 const struct attribute_group **groups)
+{
+	int i;
+
+	if (!groups)
+		return;
+	for (i = 0; groups[i]; i++)
+		sysfs_remove_group(kobj, groups[i]);
+}
+
+/**
  * sysfs_merge_group - merge files into a pre-existing attribute group.
  * @kobj:	The kobject containing the group.
  * @grp:	The files to create and the attribute group they belong to.
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -215,10 +215,14 @@ void sysfs_delete_link(struct kobject *d
 
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
+int __must_check sysfs_create_groups(struct kobject *kobj,
+				     const struct attribute_group **groups);
 int sysfs_update_group(struct kobject *kobj,
 		       const struct attribute_group *grp);
 void sysfs_remove_group(struct kobject *kobj,
 			const struct attribute_group *grp);
+void sysfs_remove_groups(struct kobject *kobj,
+			 const struct attribute_group **groups);
 int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
