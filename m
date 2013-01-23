Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3AWR4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:56:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52130 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab3AWR4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:56:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [Update][PATCH 4/5] sysfs: Functions for adding/removing symlinks to/from attribute groups
Date: Wed, 23 Jan 2013 19:00:54 +0100
Message-ID: <1511541.AH8DLsNQJH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1551140.kO91IOVbjI@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <2760421.6nE3tkh92K@vostro.rjw.lan> <1551140.kO91IOVbjI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The most convenient way to expose ACPI power resources lists of a
device is to put symbolic links to sysfs directories representing
those resources into special attribute groups in the device's sysfs
directory.  For this purpose, it is necessary to be able to add
symbolic links to attribute groups.

For this reason, add sysfs helper functions for adding/removing
symbolic links to/from attribute groups, sysfs_add_link_to_group()
and sysfs_remove_link_from_group(), respectively.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 fs/sysfs/group.c      |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/symlink.c    |   45 ++++++++++++++++++++++++++++++++-------------
 fs/sysfs/sysfs.h      |    2 ++
 include/linux/sysfs.h |    4 ++++
 4 files changed, 80 insertions(+), 13 deletions(-)

Index: linux-pm/fs/sysfs/group.c
===================================================================
--- linux-pm.orig/fs/sysfs/group.c
+++ linux-pm/fs/sysfs/group.c
@@ -205,6 +205,48 @@ void sysfs_unmerge_group(struct kobject
 }
 EXPORT_SYMBOL_GPL(sysfs_unmerge_group);
 
+/**
+ * sysfs_add_link_to_group - add a symlink to an attribute group.
+ * @kobj:	The kobject containing the group.
+ * @group_name:	The name of the group.
+ * @target:	The target kobject of the symlink to create.
+ * @link_name:	The name of the symlink to create.
+ */
+int sysfs_add_link_to_group(struct kobject *kobj, const char *group_name,
+			    struct kobject *target, const char *link_name)
+{
+	struct sysfs_dirent *dir_sd;
+	int error = 0;
+
+	dir_sd = sysfs_get_dirent(kobj->sd, NULL, group_name);
+	if (!dir_sd)
+		return -ENOENT;
+
+	error = sysfs_create_link_sd(dir_sd, target, link_name);
+	sysfs_put(dir_sd);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_add_link_to_group);
+
+/**
+ * sysfs_remove_link_from_group - remove a symlink from an attribute group.
+ * @kobj:	The kobject containing the group.
+ * @group_name:	The name of the group.
+ * @link_name:	The name of the symlink to remove.
+ */
+void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
+				  const char *link_name)
+{
+	struct sysfs_dirent *dir_sd;
+
+	dir_sd = sysfs_get_dirent(kobj->sd, NULL, group_name);
+	if (dir_sd) {
+		sysfs_hash_and_remove(dir_sd, NULL, link_name);
+		sysfs_put(dir_sd);
+	}
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_link_from_group);
 
 EXPORT_SYMBOL_GPL(sysfs_create_group);
 EXPORT_SYMBOL_GPL(sysfs_update_group);
Index: linux-pm/fs/sysfs/symlink.c
===================================================================
--- linux-pm.orig/fs/sysfs/symlink.c
+++ linux-pm/fs/sysfs/symlink.c
@@ -21,26 +21,17 @@
 
 #include "sysfs.h"
 
-static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
-				const char *name, int warn)
+static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
+				   struct kobject *target,
+				   const char *name, int warn)
 {
-	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
 	struct sysfs_addrm_cxt acxt;
 	enum kobj_ns_type ns_type;
 	int error;
 
-	BUG_ON(!name);
-
-	if (!kobj)
-		parent_sd = &sysfs_root;
-	else
-		parent_sd = kobj->sd;
-
-	error = -EFAULT;
-	if (!parent_sd)
-		goto out_put;
+	BUG_ON(!name || !parent_sd);
 
 	/* target->sd can go away beneath us but is protected with
 	 * sysfs_assoc_lock.  Fetch target_sd from it.
@@ -96,6 +87,34 @@ static int sysfs_do_create_link(struct k
 }
 
 /**
+ *	sysfs_create_link_sd - create symlink to a given object.
+ *	@sd:		directory we're creating the link in.
+ *	@target:	object we're pointing to.
+ *	@name:		name of the symlink.
+ */
+int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
+			 const char *name)
+{
+	return sysfs_do_create_link_sd(sd, target, name, 1);
+}
+
+static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
+				const char *name, int warn)
+{
+	struct sysfs_dirent *parent_sd = NULL;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	if (!parent_sd)
+		return -EFAULT;
+
+	return sysfs_do_create_link_sd(parent_sd, target, name, warn);
+}
+
+/**
  *	sysfs_create_link - create symlink between two objects.
  *	@kobj:	object whose directory we're creating the link in.
  *	@target:	object we're pointing to.
Index: linux-pm/include/linux/sysfs.h
===================================================================
--- linux-pm.orig/include/linux/sysfs.h
+++ linux-pm/include/linux/sysfs.h
@@ -181,6 +181,10 @@ int sysfs_merge_group(struct kobject *ko
 		       const struct attribute_group *grp);
 void sysfs_unmerge_group(struct kobject *kobj,
 		       const struct attribute_group *grp);
+int sysfs_add_link_to_group(struct kobject *kobj, const char *group_name,
+			    struct kobject *target, const char *link_name);
+void sysfs_remove_link_from_group(struct kobject *kobj, const char *group_name,
+				  const char *link_name);
 
 void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
 void sysfs_notify_dirent(struct sysfs_dirent *sd);
Index: linux-pm/fs/sysfs/sysfs.h
===================================================================
--- linux-pm.orig/fs/sysfs/sysfs.h
+++ linux-pm/fs/sysfs/sysfs.h
@@ -240,3 +240,5 @@ void unmap_bin_file(struct sysfs_dirent
  * symlink.c
  */
 extern const struct inode_operations sysfs_symlink_inode_operations;
+int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
+			 const char *name);

