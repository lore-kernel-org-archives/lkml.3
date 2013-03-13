Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3CMOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:19:30 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48707 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:16:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 4/9] vfs: introduce clone_private_mount()
Date: Wed, 13 Mar 2013 15:16:28 +0100
Message-Id: <1363184193-1796-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Overlayfs needs a private clone of the mount, so create a function for
this and export to modules.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |   18 ++++++++++++++++++
 include/linux/mount.h |    3 +++
 2 files changed, 21 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 50ca17d..9791b4e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1399,6 +1399,24 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	release_mounts(&umount_list);
 }
 
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
+	if (!new_mnt)
+		return ERR_PTR(-ENOMEM);
+
+	return &new_mnt->mnt;
+}
+EXPORT_SYMBOL_GPL(clone_private_mount);
+
 int iterate_mounts(int (*f)(struct vfsmount *, void *), void *arg,
 		   struct vfsmount *root)
 {
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..344a262 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -66,6 +66,9 @@ extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
+struct path;
+extern struct vfsmount *clone_private_mount(struct path *path);
+
 struct file_system_type;
 extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 				      int flags, const char *name,
-- 
1.7.10.4

