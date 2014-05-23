Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaEWJro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:47:44 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57230 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaEWJoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:44:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 04/13] vfs: introduce clone_private_mount()
Date: Fri, 23 May 2014 11:43:34 +0200
Message-Id: <1400838223-30844-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Overlayfs needs a private clone of the mount, so create a function for
this and export to modules.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        | 27 +++++++++++++++++++++++++++
 include/linux/mount.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 182bc41cd887..9ad57948f527 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1550,6 +1550,33 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	namespace_unlock();
 }
 
+/**
+ * clone_private_mount - create a private clone of a path
+ *
+ * This creates a new vfsmount, which will be the clone of @path.  The new will
+ * not be attached anywhere in the namespace and will be private (i.e. changes
+ * to the originating mount won't be propagated into this).
+ *
+ * Release with mntput().
+ */
+struct vfsmount *clone_private_mount(struct path *path)
+{
+	struct mount *old_mnt = real_mount(path->mnt);
+	struct mount *new_mnt;
+
+	if (IS_MNT_UNBINDABLE(old_mnt))
+		return ERR_PTR(-EINVAL);
+
+	down_read(&namespace_sem);
+	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
+	up_read(&namespace_sem);
+	if (IS_ERR(new_mnt))
+		return ERR_CAST(new_mnt);
+
+	return &new_mnt->mnt;
+}
+EXPORT_SYMBOL_GPL(clone_private_mount);
+
 int iterate_mounts(int (*f)(struct vfsmount *, void *), void *arg,
 		   struct vfsmount *root)
 {
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 839bac270904..31617fcfac8c 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -74,6 +74,9 @@ extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
+struct path;
+extern struct vfsmount *clone_private_mount(struct path *path);
+
 struct file_system_type;
 extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 				      int flags, const char *name,
-- 
1.8.1.4

