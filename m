Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3JCGSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:18:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41548 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3JCGSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:18:17 -0400
Date: Thu, 03 Oct 2013 07:18:16 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 05/17] fold mntfree() into mntput_no_expire()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcEq-00088P-90@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |   39 ++++++++++++++++-----------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 41663dd..f00d9f6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -872,28 +872,6 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	return ERR_PTR(err);
 }
 
-static inline void mntfree(struct mount *mnt)
-{
-	struct vfsmount *m = &mnt->mnt;
-	struct super_block *sb = m->mnt_sb;
-
-	/*
-	 * This probably indicates that somebody messed
-	 * up a mnt_want/drop_write() pair.  If this
-	 * happens, the filesystem was probably unable
-	 * to make r/w->r/o transitions.
-	 */
-	/*
-	 * The locking used to deal with mnt_count decrement provides barriers,
-	 * so mnt_get_writers() below is safe.
-	 */
-	WARN_ON(mnt_get_writers(mnt));
-	fsnotify_vfsmount_delete(m);
-	dput(m->mnt_root);
-	free_vfsmnt(mnt);
-	deactivate_super(sb);
-}
-
 static void mntput_no_expire(struct mount *mnt)
 {
 put_again:
@@ -929,7 +907,22 @@ put_again:
 
 	list_del(&mnt->mnt_instance);
 	br_write_unlock(&vfsmount_lock);
-	mntfree(mnt);
+
+	/*
+	 * This probably indicates that somebody messed
+	 * up a mnt_want/drop_write() pair.  If this
+	 * happens, the filesystem was probably unable
+	 * to make r/w->r/o transitions.
+	 */
+	/*
+	 * The locking used to deal with mnt_count decrement provides barriers,
+	 * so mnt_get_writers() below is safe.
+	 */
+	WARN_ON(mnt_get_writers(mnt));
+	fsnotify_vfsmount_delete(&mnt->mnt);
+	dput(mnt->mnt.mnt_root);
+	deactivate_super(mnt->mnt.mnt_sb);
+	free_vfsmnt(mnt);
 }
 
 void mntput(struct vfsmount *mnt)
-- 
1.7.2.5


