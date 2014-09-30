Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaI3Aex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:34:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39187 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbaI3Aeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:34:50 -0400
From: Richard Yao <ryao@gentoo.org>
To: viro@zeniv.linux.org.uk
Cc: kernel@gentoo.org, mthode@mthode.org, michael@fds-team.de,
        drobbins@funtoo.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Yao <ryao@gentoo.org>
Subject: [PATCH] vfs: Respect MS_RDONLY at bind mount creation
Date: Mon, 29 Sep 2014 20:34:41 -0400
Message-Id: <1412037281-25960-2-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1412037281-25960-1-git-send-email-ryao@gentoo.org>
References: <1412037281-25960-1-git-send-email-ryao@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`mount -o bind,ro ...` suffers from a silent failure where the readonly
flag is ignored. The bind mount will be created rw whenever the target
is rw. Users typically workaround this by remounting readonly, but that
does not work when you want to define readonly bind mounts in fstab.
This is a major annoyance when dealing with recursive bind mounts
because the userland mount command does not expose the option to
recursively remount a subtree as readonly.

Signed-off-by: Richard Yao <ryao@gentoo.org>
---
 fs/namespace.c | 20 ++++++++++++++++----
 fs/pnode.h     | 17 +++++++++--------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ef42d9b..5299742 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -942,6 +942,14 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	if (flag & CL_MAKE_SHARED)
 		set_mnt_shared(mnt);
 
+	/*
+	 * We set the flag directly because the mount point is not yet visible.
+	 * This means there are no writers that require the checks in
+	 * mnt_make_readonly().
+	 */
+	if (flag & CL_MAKE_RDONLY)
+		mnt->mnt.mnt_flags |= MNT_READONLY;
+
 	/* stick the duplicate mount on the same expiry list
 	 * as the original if that was on one */
 	if (flag & CL_EXPIRE) {
@@ -1847,11 +1855,13 @@ static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
  * do loopback mount.
  */
 static int do_loopback(struct path *path, const char *old_name,
-				int recurse)
+				unsigned long flags)
 {
 	struct path old_path;
 	struct mount *mnt = NULL, *old, *parent;
 	struct mountpoint *mp;
+	int recurse = flags & MS_REC;
+	int clflags = (flags & MS_RDONLY) ? CL_MAKE_RDONLY : 0;
 	int err;
 	if (!old_name || !*old_name)
 		return -EINVAL;
@@ -1882,9 +1892,10 @@ static int do_loopback(struct path *path, const char *old_name,
 		goto out2;
 
 	if (recurse)
-		mnt = copy_tree(old, old_path.dentry, CL_COPY_MNT_NS_FILE);
+		mnt = copy_tree(old, old_path.dentry, CL_COPY_MNT_NS_FILE |
+			clflags);
 	else
-		mnt = clone_mnt(old, old_path.dentry, 0);
+		mnt = clone_mnt(old, old_path.dentry, clflags);
 
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
@@ -2496,7 +2507,8 @@ long do_mount(const char *dev_name, const char *dir_name,
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&path, dev_name, flags & MS_REC);
+		retval = do_loopback(&path, dev_name, flags & (MS_REC |
+							       MS_RDONLY));
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)
diff --git a/fs/pnode.h b/fs/pnode.h
index 4a24635..326f5be 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -20,14 +20,15 @@
 #define SET_MNT_MARK(m) ((m)->mnt.mnt_flags |= MNT_MARKED)
 #define CLEAR_MNT_MARK(m) ((m)->mnt.mnt_flags &= ~MNT_MARKED)
 
-#define CL_EXPIRE    		0x01
-#define CL_SLAVE     		0x02
-#define CL_COPY_UNBINDABLE	0x04
-#define CL_MAKE_SHARED 		0x08
-#define CL_PRIVATE 		0x10
-#define CL_SHARED_TO_SLAVE	0x20
-#define CL_UNPRIVILEGED		0x40
-#define CL_COPY_MNT_NS_FILE	0x80
+#define CL_EXPIRE		0x001
+#define CL_SLAVE		0x002
+#define CL_COPY_UNBINDABLE	0x004
+#define CL_MAKE_SHARED		0x008
+#define CL_PRIVATE		0x010
+#define CL_SHARED_TO_SLAVE	0x020
+#define CL_UNPRIVILEGED		0x040
+#define CL_COPY_MNT_NS_FILE	0x080
+#define CL_MAKE_RDONLY		0x100
 
 #define CL_COPY_ALL		(CL_COPY_UNBINDABLE | CL_COPY_MNT_NS_FILE)
 
-- 
1.8.5.5

