Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab3GQW4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991Ab3GQWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 115/145] Btrfs: only do the tree_mod_log_free_eb if this is our last ref
Date: Wed, 17 Jul 2013 15:47:27 -0700
Message-Id: <1374101277-7915-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 7fb7d76f96bfcbea25007d190ba828b18e13d29d upstream.

There is another bug in the tree mod log stuff in that we're calling
tree_mod_log_free_eb every single time a block is cow'ed.  The problem with this
is that if this block is shared by multiple snapshots we will call this multiple
times per block, so if we go to rewind the mod log for this block we'll BUG_ON()
in __tree_mod_log_rewind because we try to rewind a free twice.  We only want to
call tree_mod_log_free_eb if we are actually freeing the block.  With this patch
I no longer hit the panic in __tree_mod_log_rewind.  Thanks,

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/ctree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7a11fb7..d24e546 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1049,7 +1049,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
-		tree_mod_log_free_eb(root->fs_info, buf);
+		if (last_ref)
+			tree_mod_log_free_eb(root->fs_info, buf);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
-- 
1.8.1.2

