Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaH1R05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:26:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48541 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaH1R0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:26:55 -0400
From: rtg.canonical@gmail.com
X-Google-Original-From: tim.gardner@canonical.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3] fs: namespace: suppress 'may be used uninitialized' warnings
Date: Thu, 28 Aug 2014 11:26:03 -0600
Message-Id: <1409246763-5096-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140828143243.GH18016@ZenIV.linux.org.uk>
References: <20140828143243.GH18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

The gcc version 4.9.1 compiler complains Even though it isn't possible for
these variables to not get initialized before they are used.

fs/namespace.c: In function ‘SyS_mount’:
fs/namespace.c:2720:8: warning: ‘kernel_dev’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2699:8: note: ‘kernel_dev’ was declared here
  char *kernel_dev;
        ^
fs/namespace.c:2720:8: warning: ‘kernel_type’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2697:8: note: ‘kernel_type’ was declared here
  char *kernel_type;
        ^

Fix the warnings by simplifying copy_mount_string() as suggested by Al Viro.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

V1 - use of the uninitialized_var() macro rejected.
V2 - assign automatic variables an initial value.
V3 - minor surgery to simplify copy_mount_string(), thereby removing all doubt as to whether
     these variables are uninitialized.

 fs/compat.c    | 10 ++++++----
 fs/internal.h  |  2 +-
 fs/namespace.c | 26 ++++++++------------------
 3 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 66d3d3c..6205c24 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -797,8 +797,9 @@ COMPAT_SYSCALL_DEFINE5(mount, const char __user *, dev_name,
 	struct filename *dir;
 	int retval;
 
-	retval = copy_mount_string(type, &kernel_type);
-	if (retval < 0)
+	kernel_type = copy_mount_string(type);
+	retval = PTR_ERR(kernel_type);
+	if (IS_ERR(kernel_type))
 		goto out;
 
 	dir = getname(dir_name);
@@ -806,8 +807,9 @@ COMPAT_SYSCALL_DEFINE5(mount, const char __user *, dev_name,
 	if (IS_ERR(dir))
 		goto out1;
 
-	retval = copy_mount_string(dev_name, &kernel_dev);
-	if (retval < 0)
+	kernel_dev = copy_mount_string(dev_name);
+	retval = PTR_ERR(kernel_dev);
+	if (IS_ERR(kernel_dev))
 		goto out2;
 
 	retval = copy_mount_options(data, &data_page);
diff --git a/fs/internal.h b/fs/internal.h
index e325b4f..bd4ac19 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -51,7 +51,7 @@ extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
  * namespace.c
  */
 extern int copy_mount_options(const void __user *, unsigned long *);
-extern int copy_mount_string(const void __user *, char **);
+extern char *copy_mount_string(const void __user *);
 
 extern struct vfsmount *lookup_mnt(struct path *);
 extern int finish_automount(struct vfsmount *, struct path *);
diff --git a/fs/namespace.c b/fs/namespace.c
index a01c773..152c972 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2390,21 +2390,9 @@ int copy_mount_options(const void __user * data, unsigned long *where)
 	return 0;
 }
 
-int copy_mount_string(const void __user *data, char **where)
+char *copy_mount_string(const void __user *data)
 {
-	char *tmp;
-
-	if (!data) {
-		*where = NULL;
-		return 0;
-	}
-
-	tmp = strndup_user(data, PAGE_SIZE);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
-	*where = tmp;
-	return 0;
+	return data ? strndup_user(data, PAGE_SIZE) : NULL;
 }
 
 /*
@@ -2670,8 +2658,9 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	char *kernel_dev;
 	unsigned long data_page;
 
-	ret = copy_mount_string(type, &kernel_type);
-	if (ret < 0)
+	kernel_type = copy_mount_string(type);
+	ret = PTR_ERR(kernel_type);
+	if (IS_ERR(kernel_type))
 		goto out_type;
 
 	kernel_dir = getname(dir_name);
@@ -2680,8 +2669,9 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 		goto out_dir;
 	}
 
-	ret = copy_mount_string(dev_name, &kernel_dev);
-	if (ret < 0)
+	kernel_dev = copy_mount_string(dev_name);
+	ret = PTR_ERR(kernel_dev);
+	if (IS_ERR(kernel_dev))
 		goto out_dev;
 
 	ret = copy_mount_options(data, &data_page);
-- 
2.1.0

