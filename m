Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3GJUFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:05:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3GJUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:05:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: oliver+list@schinagl.nl, linux@roeck-us.net, khali@linux-fr.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/6] sysfs: add support for binary attributes in groups
Date: Wed, 10 Jul 2013 13:05:13 -0700
Message-Id: <1373486714-14531-6-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

groups should be able to support binary attributes, just like it
supports "normal" attributes.  This lets us only handle one type of
structure, groups, throughout the driver core and subsystems, making
binary attributes a "full fledged" part of the driver model, and not
something just "tacked on".

Reported-by: Oliver Schinagl <oliver+list@schinagl.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/group.c      | 18 ++++++++++++++++--
 include/linux/sysfs.h |  4 ++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index aec3d5c..d8d8a8f 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -20,16 +20,19 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			 const struct attribute_group *grp)
 {
 	struct attribute *const* attr;
-	int i;
+	struct bin_attribute *const* bin_attr;
 
-	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
+	for (attr = grp->attrs; *attr; attr++)
 		sysfs_hash_and_remove(dir_sd, NULL, (*attr)->name);
+	for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++)
+		sysfs_remove_bin_file(kobj, *bin_attr);
 }
 
 static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 			const struct attribute_group *grp, int update)
 {
 	struct attribute *const* attr;
+	struct bin_attribute *const* bin_attr;
 	int error = 0, i;
 
 	for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
@@ -52,6 +55,17 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
 	}
 	if (error)
 		remove_files(dir_sd, kobj, grp);
+
+	for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
+		if (update)
+			sysfs_remove_bin_file(kobj, *bin_attr);
+		error = sysfs_create_bin_file(kobj, *bin_attr);
+		if (error)
+			break;
+	}
+	if (error)
+		remove_files(dir_sd, kobj, grp);
+
 	return error;
 }
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index d50a96b..2c3b6a3 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -21,6 +21,7 @@
 
 struct kobject;
 struct module;
+struct bin_attribute;
 enum kobj_ns_type;
 
 struct attribute {
@@ -59,10 +60,9 @@ struct attribute_group {
 	umode_t			(*is_visible)(struct kobject *,
 					      struct attribute *, int);
 	struct attribute	**attrs;
+	struct bin_attribute	**bin_attrs;
 };
 
-
-
 /**
  * Use these macros to make defining attributes easier. See include/linux/device.h
  * for examples..
-- 
1.8.3.rc0.20.gb99dd2e

