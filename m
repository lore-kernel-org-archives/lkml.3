Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3GAMTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:19:32 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51696 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3GAMTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:19:31 -0400
From: Dong Fang <yp.fangdong@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Fang <yp.fangdong@gmail.com>
Subject: [PATCH] vfs: remove the unnecessrary code of fs/inode.c
Date: Mon,  1 Jul 2013 08:19:03 -0400
Message-Id: <1372681143-23465-1-git-send-email-yp.fangdong@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions, such as find_inode_fast() and find_inode(), iget_lock() and
iget5_lock(), insert_inode_locked() and insert_inode_locked4(), almost have
the same code.

Signed-off-by: Dong Fang <yp.fangdong@gmail.com>
---
 fs/inode.c |  134 ++++++++++++------------------------------------------------
 1 files changed, 26 insertions(+), 108 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 00d5fc3..847eee9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -790,6 +790,22 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 }
 
 static void __wait_on_freeing_inode(struct inode *inode);
+
+
+static int test_ino(struct inode *inode, void *data)
+{
+	unsigned long ino = *(unsigned long *) data;
+	return inode->i_ino == ino;
+}
+
+static int set_ino(struct inode *inode, void *data)
+{
+	inode->i_ino = *(unsigned long *) data;
+	return 0;
+}
+
+
+
 /*
  * Called with the inode lock held.
  */
@@ -829,28 +845,7 @@ repeat:
 static struct inode *find_inode_fast(struct super_block *sb,
 				struct hlist_head *head, unsigned long ino)
 {
-	struct inode *inode = NULL;
-
-repeat:
-	hlist_for_each_entry(inode, head, i_hash) {
-		spin_lock(&inode->i_lock);
-		if (inode->i_ino != ino) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		if (inode->i_sb != sb) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
-			__wait_on_freeing_inode(inode);
-			goto repeat;
-		}
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
-		return inode;
-	}
-	return NULL;
+	return find_inode(sb, head, test_ino, (void *)&ino);
 }
 
 /*
@@ -1073,50 +1068,7 @@ EXPORT_SYMBOL(iget5_locked);
  */
 struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
-	struct inode *inode;
-
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
-	if (inode) {
-		wait_on_inode(inode);
-		return inode;
-	}
-
-	inode = alloc_inode(sb);
-	if (inode) {
-		struct inode *old;
-
-		spin_lock(&inode_hash_lock);
-		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
-		if (!old) {
-			inode->i_ino = ino;
-			spin_lock(&inode->i_lock);
-			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode->i_lock);
-			inode_sb_list_add(inode);
-			spin_unlock(&inode_hash_lock);
-
-			/* Return the locked inode with I_NEW set, the
-			 * caller is responsible for filling in the contents
-			 */
-			return inode;
-		}
-
-		/*
-		 * Uhhuh, somebody else created the same inode under
-		 * us. Use the old inode instead of the one we just
-		 * allocated.
-		 */
-		spin_unlock(&inode_hash_lock);
-		destroy_inode(inode);
-		inode = old;
-		wait_on_inode(inode);
-	}
-	return inode;
+	return iget5_locked(sb, ino, test_ino, set_ino, (void *)&ino);
 }
 EXPORT_SYMBOL(iget_locked);
 
@@ -1281,48 +1233,6 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 }
 EXPORT_SYMBOL(ilookup);
 
-int insert_inode_locked(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-	ino_t ino = inode->i_ino;
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
-
-	while (1) {
-		struct inode *old = NULL;
-		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, head, i_hash) {
-			if (old->i_ino != ino)
-				continue;
-			if (old->i_sb != sb)
-				continue;
-			spin_lock(&old->i_lock);
-			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
-				spin_unlock(&old->i_lock);
-				continue;
-			}
-			break;
-		}
-		if (likely(!old)) {
-			spin_lock(&inode->i_lock);
-			inode->i_state |= I_NEW;
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_hash_lock);
-			return 0;
-		}
-		__iget(old);
-		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_hash_lock);
-		wait_on_inode(old);
-		if (unlikely(!inode_unhashed(old))) {
-			iput(old);
-			return -EBUSY;
-		}
-		iput(old);
-	}
-}
-EXPORT_SYMBOL(insert_inode_locked);
-
 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
@@ -1366,6 +1276,14 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 }
 EXPORT_SYMBOL(insert_inode_locked4);
 
+int insert_inode_locked(struct inode *inode)
+{
+	unsigned long ino = inode->i_ino;
+	return insert_inode_locked4(inode, ino, test_ino, (void *)&ino);
+}
+EXPORT_SYMBOL(insert_inode_locked);
+
+
 
 int generic_delete_inode(struct inode *inode)
 {
-- 
1.7.1

