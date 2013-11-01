Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3KAAvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:51:00 -0400
Received: from science.horizon.com ([71.41.210.146]:58569 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753678Ab3KAAu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:50:59 -0400
Date: 31 Oct 2013 20:50:56 -0400
Message-ID: <20131101005056.21134.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jack@suse.cz, linux@horizon.com
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk
In-Reply-To: <20131031204330.GA18566@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to wanting to stick with 3.11.x baseline, as opposed to whatever you
based your diff on, I had to amend the last hunk slightly.  Included
just FYI.

Compiled, rebooting now.  It may take some days to get a
bug report.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4bbbf13b..e6f0d6b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4734,6 +4734,7 @@ do_more:
 	if (err)
 		goto error_return;
 
+	might_sleep();
 	if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
 		struct ext4_free_data *new_entry;
 		/*
@@ -4741,6 +4742,7 @@ do_more:
 		 * be used until this transaction is committed
 		 */
 	retry:
+		might_sleep();
 		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
 		if (!new_entry) {
 			/*
@@ -4756,6 +4758,7 @@ do_more:
 		new_entry->efd_count = count_clusters;
 		new_entry->efd_tid = handle->h_transaction->t_tid;
 
+		might_sleep();
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
@@ -4773,7 +4776,7 @@ do_more:
 					 err);
 		}
 
-
+		might_sleep();
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
 		mb_free_blocks(inode, &e4b, bit, count_clusters);
@@ -4785,6 +4788,7 @@ do_more:
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
+	might_sleep();
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
