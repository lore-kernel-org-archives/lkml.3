Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3LRVMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:12:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3LRVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.10 78/78] Btrfs: do not run snapshot-aware defragment on error
Date: Wed, 18 Dec 2013 13:11:46 -0800
Message-Id: <20131218211114.100373369@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 6f519564d7d978c00351d9ab6abac3deeac31621 upstream.

If something wrong happens in write endio, running snapshot-aware defragment
can end up with undefined results, maybe a crash, so we should avoid it.

In order to share similar code, this also adds a helper to free the struct for
snapshot-aware defrag.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   47 ++++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2419,10 +2419,23 @@ out_unlock:
 	return ret;
 }
 
+static void free_sa_defrag_extent(struct new_sa_defrag_extent *new)
+{
+	struct old_sa_defrag_extent *old, *tmp;
+
+	if (!new)
+		return;
+
+	list_for_each_entry_safe(old, tmp, &new->head, list) {
+		list_del(&old->list);
+		kfree(old);
+	}
+	kfree(new);
+}
+
 static void relink_file_extents(struct new_sa_defrag_extent *new)
 {
 	struct btrfs_path *path;
-	struct old_sa_defrag_extent *old, *tmp;
 	struct sa_defrag_extent_backref *backref;
 	struct sa_defrag_extent_backref *prev = NULL;
 	struct inode *inode;
@@ -2465,16 +2478,11 @@ static void relink_file_extents(struct n
 	kfree(prev);
 
 	btrfs_free_path(path);
-
-	list_for_each_entry_safe(old, tmp, &new->head, list) {
-		list_del(&old->list);
-		kfree(old);
-	}
 out:
+	free_sa_defrag_extent(new);
+
 	atomic_dec(&root->fs_info->defrag_running);
 	wake_up(&root->fs_info->transaction_wait);
-
-	kfree(new);
 }
 
 static struct new_sa_defrag_extent *
@@ -2484,7 +2492,7 @@ record_old_file_extents(struct inode *in
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct old_sa_defrag_extent *old, *tmp;
+	struct old_sa_defrag_extent *old;
 	struct new_sa_defrag_extent *new;
 	int ret;
 
@@ -2532,7 +2540,7 @@ record_old_file_extents(struct inode *in
 		if (slot >= btrfs_header_nritems(l)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
-				goto out_free_list;
+				goto out_free_path;
 			else if (ret > 0)
 				break;
 			continue;
@@ -2561,7 +2569,7 @@ record_old_file_extents(struct inode *in
 
 		old = kmalloc(sizeof(*old), GFP_NOFS);
 		if (!old)
-			goto out_free_list;
+			goto out_free_path;
 
 		offset = max(new->file_pos, key.offset);
 		end = min(new->file_pos + new->len, key.offset + num_bytes);
@@ -2583,15 +2591,10 @@ next:
 
 	return new;
 
-out_free_list:
-	list_for_each_entry_safe(old, tmp, &new->head, list) {
-		list_del(&old->list);
-		kfree(old);
-	}
 out_free_path:
 	btrfs_free_path(path);
 out_kfree:
-	kfree(new);
+	free_sa_defrag_extent(new);
 	return NULL;
 }
 
@@ -2743,8 +2746,14 @@ out:
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
 	/* for snapshot-aware defrag */
-	if (new)
-		relink_file_extents(new);
+	if (new) {
+		if (ret) {
+			free_sa_defrag_extent(new);
+			atomic_dec(&root->fs_info->defrag_running);
+		} else {
+			relink_file_extents(new);
+		}
+	}
 
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);


