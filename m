Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3GaEQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:57 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34985 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab3GaEQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABTCMM9Fw4BARYmKIIkAQEFJy8jEAgYMTkDGxmID7hqjkKFTAOsUSo
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 09/11] fs: Use RCU lookups for inode cache
Date: Wed, 31 Jul 2013 14:15:48 +1000
Message-Id: <1375244150-27296-10-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Convert inode cache lookups to be protected by RCU locking rather
than the global inode_hash_lock. This will improve scalability of
inode lookup intensive workloads.

Tested w/ ext4 and btrfs on concurrent fsmark/lookup/unlink
workloads only. It removes the inode hash lock from the inode lookup
paths, but does not solve the problem of the inode hash lock being a
bottleneck on the inode cache insert/remove paths.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c | 76 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 33 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 7eea591..810386e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -465,7 +465,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_add_head(&inode->i_hash, b);
+	hlist_add_head_rcu(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -481,7 +481,7 @@ void __remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_del_init(&inode->i_hash);
+	hlist_del_init_rcu(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -776,13 +776,18 @@ static void __wait_on_freeing_inode(struct inode *inode);
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
 				int (*test)(struct inode *, void *),
-				void *data)
+				void *data, bool locked)
 {
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, head, i_hash) {
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(inode, head, i_hash) {
 		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_sb != sb) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -792,13 +797,20 @@ repeat:
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			rcu_read_unlock();
+			if (locked)
+				spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
+			if (locked)
+				spin_lock(&inode_hash_lock);
 			goto repeat;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -807,13 +819,19 @@ repeat:
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				     struct hlist_head *head,
+				     unsigned long ino, bool locked)
 {
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, head, i_hash) {
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(inode, head, i_hash) {
 		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_ino != ino) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -823,13 +841,20 @@ repeat:
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			rcu_read_unlock();
+			if (locked)
+				spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
+			if (locked)
+				spin_lock(&inode_hash_lock);
 			goto repeat;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -984,9 +1009,7 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
-	spin_unlock(&inode_hash_lock);
+	inode = find_inode(sb, head, test, data, false);
 
 	if (inode) {
 		wait_on_inode(inode);
@@ -998,8 +1021,7 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		struct inode *old;
 
 		spin_lock(&inode_hash_lock);
-		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, head, test, data, true);
 		if (!old) {
 			if (set(inode, data))
 				goto set_failed;
@@ -1054,9 +1076,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
+	inode = find_inode_fast(sb, head, ino, false);
 	if (inode) {
 		wait_on_inode(inode);
 		return inode;
@@ -1067,8 +1087,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 		struct inode *old;
 
 		spin_lock(&inode_hash_lock);
-		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, head, ino, true);
 		if (!old) {
 			inode->i_ino = ino;
 			spin_lock(&inode->i_lock);
@@ -1110,14 +1129,15 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 	struct hlist_head *b = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	hlist_for_each_entry(inode, b, i_hash) {
-		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(inode, b, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb &&
+		    !inode_unhashed(inode)) {
+			rcu_read_unlock();
 			return 0;
 		}
 	}
-	spin_unlock(&inode_hash_lock);
+	rcu_read_unlock();
 
 	return 1;
 }
@@ -1198,13 +1218,8 @@ struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
-	struct inode *inode;
-
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
-	spin_unlock(&inode_hash_lock);
 
-	return inode;
+	return find_inode(sb, head, test, data, false);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1249,10 +1264,7 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
-
+	inode = find_inode_fast(sb, head, ino, false);
 	if (inode)
 		wait_on_inode(inode);
 	return inode;
@@ -1696,10 +1708,8 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;
-- 
1.8.3.2

