Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab3GQWzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836Ab3GQWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, Josef Bacik <jbacik@fusionio.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 113/145] Btrfs: fix unlock after free on rewinded tree blocks
Date: Wed, 17 Jul 2013 15:47:25 -0700
Message-Id: <1374101277-7915-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schmidt <list.btrfs@jan-o-sch.net>

commit 47fb091fb787420cd195e66f162737401cce023f upstream.

When tree_mod_log_rewind decides to make a copy of the current tree buffer
for its modifications, it subsequently freed the buffer before unlocking it.
Obviously, those operations are required in reverse order.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/ctree.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ce1c169..f28b330 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1189,6 +1189,13 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 	btrfs_set_header_nritems(eb, n);
 }
 
+/*
+ * Called with eb read locked. If the buffer cannot be rewinded, the same buffer
+ * is returned. If rewind operations happen, a fresh buffer is returned. The
+ * returned buffer is always read-locked. If the returned buffer is not the
+ * input buffer, the lock on the input buffer is released and the input buffer
+ * is freed (its refcount is decremented).
+ */
 static struct extent_buffer *
 tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		    u64 time_seq)
@@ -1222,8 +1229,11 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 	}
 
 	extent_buffer_get(eb_rewin);
+	btrfs_tree_read_unlock(eb);
 	free_extent_buffer(eb);
 
+	extent_buffer_get(eb_rewin);
+	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
 		BTRFS_NODEPTRS_PER_BLOCK(fs_info->fs_root));
@@ -2800,15 +2810,9 @@ again:
 				btrfs_clear_path_blocking(p, b,
 							  BTRFS_READ_LOCK);
 			}
+			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
 			p->locks[level] = BTRFS_READ_LOCK;
 			p->nodes[level] = b;
-			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
-			if (b != p->nodes[level]) {
-				btrfs_tree_unlock_rw(p->nodes[level],
-						     p->locks[level]);
-				p->locks[level] = 0;
-				p->nodes[level] = b;
-			}
 		} else {
 			p->slots[level] = slot;
 			unlock_up(p, level, lowest_unlock, 0, NULL);
-- 
1.8.1.2

