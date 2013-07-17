Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab3GQWzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964893Ab3GQWzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 114/145] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
Date: Wed, 17 Jul 2013 15:47:26 -0700
Message-Id: <1374101277-7915-115-git-send-email-kamal@canonical.com>
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

commit f1ca7e98a67da618d8595866e0860308525154da upstream.

We need to hold the tree mod log lock in __tree_mod_log_rewind since we walk
forward in the tree mod entries, otherwise we'll end up with random entries and
trip the BUG_ON() at the front of __tree_mod_log_rewind.  This fixes the panics
people were seeing when running

find /whatever -type f -exec btrfs fi defrag {} \;

Thansk,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/ctree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f28b330..7a11fb7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1122,8 +1122,8 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
  * time_seq).
  */
 static void
-__tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
-		      struct tree_mod_elem *first_tm)
+__tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
+		      u64 time_seq, struct tree_mod_elem *first_tm)
 {
 	u32 n;
 	struct rb_node *next;
@@ -1133,6 +1133,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
 
 	n = btrfs_header_nritems(eb);
+	tree_mod_log_read_lock(fs_info);
 	while (tm && tm->seq >= time_seq) {
 		/*
 		 * all the operations are recorded with the operator used for
@@ -1186,6 +1187,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		if (tm->index != first_tm->index)
 			break;
 	}
+	tree_mod_log_read_unlock(fs_info);
 	btrfs_set_header_nritems(eb, n);
 }
 
@@ -1234,7 +1236,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 
 	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
-	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
+	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
 		BTRFS_NODEPTRS_PER_BLOCK(fs_info->fs_root));
 
@@ -1308,7 +1310,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		btrfs_set_header_generation(eb, old_generation);
 	}
 	if (tm)
-		__tree_mod_log_rewind(eb, time_seq, tm);
+		__tree_mod_log_rewind(root->fs_info, eb, time_seq, tm);
 	else
 		WARN_ON(btrfs_header_level(eb) != 0);
 	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));
-- 
1.8.1.2

