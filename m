Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaEJPIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:08:46 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:35445 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755931AbaEJPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:08:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgbAKNAblNXQCSg/2dsb2JhbABZgwaDPakYBAEBAQEBAQUBmhUCAoETF3SCUxMcIxiBAiQTiEUB0F+FVoh8hEcBA48liiIBkweDODs
Date: Sat, 10 May 2014 17:08:38 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, tytso <tytso@mit.edu>
Subject: [PATCH 1/1] FS/EXT4: use generic kvfree
Message-Id: <20140510170838.5d684f9af146ebe69ce6bbc0@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ext4_kvfree and use generic one added in

39f1f78d53b9bcb
("nick kvfree() from apparmor")

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc:  Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ext4.h    |  1 -
 fs/ext4/mballoc.c |  7 ++++---
 fs/ext4/resize.c  |  7 ++++---
 fs/ext4/super.c   | 20 ++++++--------------
 4 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 66946aa..d525025 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2203,7 +2203,6 @@ extern int ext4_superblock_csum_verify(struct super_block *sb,
 extern void ext4_superblock_csum_set(struct super_block *sb);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
-extern void ext4_kvfree(void *ptr);
 extern int ext4_alloc_flex_bg_array(struct super_block *sb,
 				    ext4_group_t ngroup);
 extern const char *ext4_decode_error(struct super_block *sb, int errno,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c8238a2..19b8b0b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <trace/events/ext4.h>
+#include <linux/mm.h>
 
 #ifdef CONFIG_EXT4_DEBUG
 ushort ext4_mballoc_debug __read_mostly;
@@ -2346,7 +2347,7 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 	if (sbi->s_group_info) {
 		memcpy(new_groupinfo, sbi->s_group_info,
 		       sbi->s_group_info_size * sizeof(*sbi->s_group_info));
-		ext4_kvfree(sbi->s_group_info);
+		kvfree(sbi->s_group_info);
 	}
 	sbi->s_group_info = new_groupinfo;
 	sbi->s_group_info_size = size / sizeof(*sbi->s_group_info);
@@ -2483,7 +2484,7 @@ err_freebuddy:
 		kfree(sbi->s_group_info[i]);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
-	ext4_kvfree(sbi->s_group_info);
+	kvfree(sbi->s_group_info);
 	return -ENOMEM;
 }
 
@@ -2698,7 +2699,7 @@ int ext4_mb_release(struct super_block *sb)
 			EXT4_DESC_PER_BLOCK_BITS(sb);
 		for (i = 0; i < num_meta_group_infos; i++)
 			kfree(sbi->s_group_info[i]);
-		ext4_kvfree(sbi->s_group_info);
+		kvfree(sbi->s_group_info);
 	}
 	kfree(sbi->s_mb_offsets);
 	kfree(sbi->s_mb_maxs);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f3b84cd..06821ef 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -13,6 +13,7 @@
 
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 
 #include "ext4_jbd2.h"
 
@@ -848,7 +849,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	n_group_desc[gdb_num] = gdb_bh;
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
-	ext4_kvfree(o_group_desc);
+	kvfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
 	err = ext4_handle_dirty_super(handle, sb);
@@ -858,7 +859,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	return err;
 
 exit_inode:
-	ext4_kvfree(n_group_desc);
+	kvfree(n_group_desc);
 	brelse(iloc.bh);
 exit_dind:
 	brelse(dind);
@@ -901,7 +902,7 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	n_group_desc[gdb_num] = gdb_bh;
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
-	ext4_kvfree(o_group_desc);
+	kvfree(o_group_desc);
 	err = ext4_journal_get_write_access(handle, gdb_bh);
 	if (unlikely(err))
 		brelse(gdb_bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6f9e6fa..8e12c3d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -43,6 +43,7 @@
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/mm.h>
 
 #include "ext4.h"
 #include "ext4_extents.h"	/* Needed for trace points definition */
@@ -179,15 +180,6 @@ void *ext4_kvzalloc(size_t size, gfp_t flags)
 	return ret;
 }
 
-void ext4_kvfree(void *ptr)
-{
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
-
-}
-
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
 {
@@ -814,8 +806,8 @@ static void ext4_put_super(struct super_block *sb)
 
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
-	ext4_kvfree(sbi->s_group_desc);
-	ext4_kvfree(sbi->s_flex_groups);
+	kvfree(sbi->s_group_desc);
+	kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1969,7 +1961,7 @@ int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 		memcpy(new_groups, sbi->s_flex_groups,
 		       (sbi->s_flex_groups_allocated *
 			sizeof(struct flex_groups)));
-		ext4_kvfree(sbi->s_flex_groups);
+		kvfree(sbi->s_flex_groups);
 	}
 	sbi->s_flex_groups = new_groups;
 	sbi->s_flex_groups_allocated = size / sizeof(struct flex_groups);
@@ -4224,7 +4216,7 @@ failed_mount3:
 	ext4_es_unregister_shrinker(sbi);
 	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
-		ext4_kvfree(sbi->s_flex_groups);
+		kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -4237,7 +4229,7 @@ failed_mount2a:
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
-	ext4_kvfree(sbi->s_group_desc);
+	kvfree(sbi->s_group_desc);
 failed_mount:
 	ext4_ext_release(sb);
 	if (sbi->s_chksum_driver)
-- 
1.8.4.5
