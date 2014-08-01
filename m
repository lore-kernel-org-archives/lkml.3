Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaHASM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:12:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52677 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbaHASMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:12:55 -0400
From: Richard Yao <ryao@gentoo.org>
To: kernel@gentoo.org
Cc: mthode@mthode.org, michael@fds-team.de, drobbins@funtoo.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] vfs: Respect MS_RDONLY at bind mount creation
Date: Fri,  1 Aug 2014 14:12:24 -0400
Message-Id: <1406916744-6634-2-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406916744-6634-1-git-send-email-ryao@gentoo.org>
References: <1406916744-6634-1-git-send-email-ryao@gentoo.org>
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
 fs/namespace.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 182bc41..0d23525 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1827,11 +1827,12 @@ static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
  * do loopback mount.
  */
 static int do_loopback(struct path *path, const char *old_name,
-				int recurse)
+				unsigned long flags)
 {
 	struct path old_path;
-	struct mount *mnt = NULL, *old, *parent;
+	struct mount *mnt = NULL, *old, *parent, *m;
 	struct mountpoint *mp;
+	int recurse = flags & MS_REC;
 	int err;
 	if (!old_name || !*old_name)
 		return -EINVAL;
@@ -1871,6 +1872,10 @@ static int do_loopback(struct path *path, const char *old_name,
 		goto out2;
 	}
 
+	if (flags & MS_RDONLY)
+		for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
+			mnt_make_readonly(m);
+
 	mnt->mnt.mnt_flags &= ~MNT_LOCKED;
 
 	err = graft_tree(mnt, parent, mp);
@@ -2444,7 +2449,8 @@ long do_mount(const char *dev_name, const char *dir_name,
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&path, dev_name, flags & MS_REC);
+		retval = do_loopback(&path, dev_name, flags & (MS_REC |
+							       MS_RDONLY));
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)
-- 
1.8.5.5

