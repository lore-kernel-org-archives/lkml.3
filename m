Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaF3MMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51985 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 022/181] Btrfs: fix tracking of orphan inode count
Date: Mon, 30 Jun 2014 13:50:43 +0200
Message-Id: <f19eb84ed2054bf749e702251b40cbbc954b1077.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe David Borba Manana <fdmanana@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 703c88e035242202e3ab48fcbbbe0a7bc62fb7bb upstream.

In inode.c:btrfs_orphan_add() if we failed to insert the orphan
item, we would return without decrementing the orphan count that
we just incremented before attempting the insertion, leaving the
orphan inode count wrong.

In inode.c:btrfs_orphan_del(), we were decrementing the inode
orphan count if the bit BTRFS_INODE_ORPHAN_META_RESERVED was set,
which is logically wrong because it should be decremented if the
bit BTRFS_INODE_HAS_ORPHAN_ITEM was set - after all we increment
the count when we set the bit BTRFS_INODE_HAS_ORPHAN_ITEM elsewhere.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/inode.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3d03d2e0849c..250ed4ef6b91 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2978,6 +2978,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret) {
+			atomic_dec(&root->orphan_inodes);
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 					  &BTRFS_I(inode)->runtime_flags);
@@ -3027,14 +3028,16 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 		release_rsv = 1;
 	spin_unlock(&root->orphan_lock);
 
-	if (trans && delete_item)
-		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
-
-	if (release_rsv) {
-		btrfs_orphan_release_metadata(inode);
+	if (delete_item) {
 		atomic_dec(&root->orphan_inodes);
+		if (trans)
+			ret = btrfs_del_orphan_item(trans, root,
+						    btrfs_ino(inode));
 	}
 
+	if (release_rsv)
+		btrfs_orphan_release_metadata(inode);
+
 	return ret;
 }
 
-- 
2.0.0

