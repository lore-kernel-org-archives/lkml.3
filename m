Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3LRVQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:16:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3LRVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 113/118] Btrfs: do not run snapshot-aware defragment on error
Date: Wed, 18 Dec 2013 13:12:30 -0800
Message-Id: <20131218211222.657723323@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2367,10 +2367,23 @@ out_unlock:
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
@@ -2413,16 +2426,11 @@ static void relink_file_extents(struct n
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
@@ -2432,7 +2440,7 @@ record_old_file_extents(struct inode *in
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct old_sa_defrag_extent *old, *tmp;
+	struct old_sa_defrag_extent *old;
 	struct new_sa_defrag_extent *new;
 	int ret;
 
@@ -2480,7 +2488,7 @@ record_old_file_extents(struct inode *in
 		if (slot >= btrfs_header_nritems(l)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
-				goto out_free_list;
+				goto out_free_path;
 			else if (ret > 0)
 				break;
 			continue;
@@ -2509,7 +2517,7 @@ record_old_file_extents(struct inode *in
 
 		old = kmalloc(sizeof(*old), GFP_NOFS);
 		if (!old)
-			goto out_free_list;
+			goto out_free_path;
 
 		offset = max(new->file_pos, key.offset);
 		end = min(new->file_pos + new->len, key.offset + num_bytes);
@@ -2531,15 +2539,10 @@ next:
 
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
 
@@ -2710,8 +2713,14 @@ out:
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


