Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaAMRLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:11:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52838 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaAMQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/208] Btrfs: do not run snapshot-aware defragment on error
Date: Mon, 13 Jan 2014 15:57:33 +0000
Message-Id: <1389628849-1614-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/inode.c | 47 ++++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8220491..5a4bc34 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2452,10 +2452,23 @@ out_unlock:
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
@@ -2498,16 +2511,11 @@ static void relink_file_extents(struct new_sa_defrag_extent *new)
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
@@ -2517,7 +2525,7 @@ record_old_file_extents(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct old_sa_defrag_extent *old, *tmp;
+	struct old_sa_defrag_extent *old;
 	struct new_sa_defrag_extent *new;
 	int ret;
 
@@ -2565,7 +2573,7 @@ record_old_file_extents(struct inode *inode,
 		if (slot >= btrfs_header_nritems(l)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
-				goto out_free_list;
+				goto out_free_path;
 			else if (ret > 0)
 				break;
 			continue;
@@ -2594,7 +2602,7 @@ record_old_file_extents(struct inode *inode,
 
 		old = kmalloc(sizeof(*old), GFP_NOFS);
 		if (!old)
-			goto out_free_list;
+			goto out_free_path;
 
 		offset = max(new->file_pos, key.offset);
 		end = min(new->file_pos + new->len, key.offset + num_bytes);
@@ -2616,15 +2624,10 @@ next:
 
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
 
@@ -2776,8 +2779,14 @@ out:
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
-- 
1.8.3.2

