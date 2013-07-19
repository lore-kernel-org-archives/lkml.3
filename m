Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737Ab3GSF05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab3GSF0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 50/72] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
Date: Thu, 18 Jul 2013 22:26:07 -0700
Message-Id: <20130719052603.280057926@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1161,8 +1161,8 @@ __tree_mod_log_oldest_root(struct btrfs_
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
@@ -1172,6 +1172,7 @@ __tree_mod_log_rewind(struct extent_buff
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
 
 	n = btrfs_header_nritems(eb);
+	tree_mod_log_read_lock(fs_info);
 	while (tm && tm->seq >= time_seq) {
 		/*
 		 * all the operations are recorded with the operator used for
@@ -1226,6 +1227,7 @@ __tree_mod_log_rewind(struct extent_buff
 		if (tm->index != first_tm->index)
 			break;
 	}
+	tree_mod_log_read_unlock(fs_info);
 	btrfs_set_header_nritems(eb, n);
 }
 
@@ -1274,7 +1276,7 @@ tree_mod_log_rewind(struct btrfs_fs_info
 
 	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
-	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
+	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
 		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
 
@@ -1350,7 +1352,7 @@ get_old_root(struct btrfs_root *root, u6
 		btrfs_set_header_generation(eb, old_generation);
 	}
 	if (tm)
-		__tree_mod_log_rewind(eb, time_seq, tm);
+		__tree_mod_log_rewind(root->fs_info, eb, time_seq, tm);
 	else
 		WARN_ON(btrfs_header_level(eb) != 0);
 	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));


