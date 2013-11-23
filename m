Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3KWWWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:22:54 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:64720 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3KWWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:22:37 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/41] sysfs, kernfs: introduce kernfs_create_link()
Date: Sat, 23 Nov 2013 17:21:50 -0500
Message-Id: <1385245346-856-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385245346-856-1-git-send-email-tj@kernel.org>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out kernfs symlink interface - kernfs_create_link() - which
takes and returns sysfs_dirents, from sysfs_do_create_link_sd().
sysfs_do_create_link_sd() now just determines the parent and target
sysfs_dirents and invokes the new interface and handles dup warning.

This patch doesn't introduce behavior changes.

v2: Dummy implementation for !CONFIG_SYSFS updated to return -ENOSYS.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/symlink.c     | 76 ++++++++++++++++++++++++++++++--------------------
 include/linux/kernfs.h |  9 ++++++
 2 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 71583fc..41138e9 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -21,14 +21,48 @@
 
 #include "sysfs.h"
 
+/**
+ * kernfs_create_link - create a symlink
+ * @parent: directory to create the symlink in
+ * @name: name of the symlink
+ * @target: target node for the symlink to point to
+ *
+ * Returns the created node on success, ERR_PTR() value on error.
+ */
+struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
+					const char *name,
+					struct sysfs_dirent *target)
+{
+	struct sysfs_dirent *sd;
+	struct sysfs_addrm_cxt acxt;
+	int error;
+
+	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	if (!sd)
+		return ERR_PTR(-ENOMEM);
+
+	if (parent->s_flags & SYSFS_FLAG_NS)
+		sd->s_ns = target->s_ns;
+	sd->s_symlink.target_sd = target;
+	sysfs_get(target);	/* ref owned by symlink */
+
+	sysfs_addrm_start(&acxt);
+	error = __sysfs_add_one(&acxt, sd, parent);
+	sysfs_addrm_finish(&acxt);
+
+	if (!error)
+		return sd;
+
+	sysfs_put(sd);
+	return ERR_PTR(error);
+}
+
+
 static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 				   struct kobject *target,
 				   const char *name, int warn)
 {
-	struct sysfs_dirent *target_sd = NULL;
-	struct sysfs_dirent *sd = NULL;
-	struct sysfs_addrm_cxt acxt;
-	int error;
+	struct sysfs_dirent *sd, *target_sd = NULL;
 
 	BUG_ON(!name || !parent_sd);
 
@@ -42,36 +76,18 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 		target_sd = sysfs_get(target->sd);
 	spin_unlock(&sysfs_symlink_target_lock);
 
-	error = -ENOENT;
 	if (!target_sd)
-		goto out_put;
+		return -ENOENT;
 
-	error = -ENOMEM;
-	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
-	if (!sd)
-		goto out_put;
-
-	if (parent_sd->s_flags & SYSFS_FLAG_NS)
-		sd->s_ns = target_sd->s_ns;
-	sd->s_symlink.target_sd = target_sd;
-	target_sd = NULL;	/* reference is now owned by the symlink */
-
-	sysfs_addrm_start(&acxt);
-	if (warn)
-		error = sysfs_add_one(&acxt, sd, parent_sd);
-	else
-		error = __sysfs_add_one(&acxt, sd, parent_sd);
-	sysfs_addrm_finish(&acxt);
-
-	if (error)
-		goto out_put;
+	sd = kernfs_create_link(parent_sd, name, target_sd);
+	sysfs_put(target_sd);
 
-	return 0;
+	if (!IS_ERR(sd))
+		return 0;
 
- out_put:
-	sysfs_put(target_sd);
-	sysfs_put(sd);
-	return error;
+	if (warn && PTR_ERR(sd) == -EEXIST)
+		sysfs_warn_dup(parent_sd, name);
+	return PTR_ERR(sd);
 }
 
 /**
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 83e151a..fe6290d 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -8,17 +8,26 @@
 #define __LINUX_KERNFS_H
 
 #include <linux/kernel.h>
+#include <linux/err.h>
 
 struct sysfs_dirent;
 
 #ifdef CONFIG_SYSFS
 
+struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
+					const char *name,
+					struct sysfs_dirent *target);
 void kernfs_remove(struct sysfs_dirent *sd);
 int kernfs_remove_by_name_ns(struct sysfs_dirent *parent, const char *name,
 			     const void *ns);
 
 #else	/* CONFIG_SYSFS */
 
+static inline struct sysfs_dirent *
+kernfs_create_link(struct sysfs_dirent *parent, const char *name,
+		   struct sysfs_dirent *target)
+{ return ERR_PTR(-ENOSYS); }
+
 static inline void kernfs_remove(struct sysfs_dirent *sd) { }
 
 static inline int kernfs_remove_by_name_ns(struct sysfs_dirent *parent,
-- 
1.8.4.2

