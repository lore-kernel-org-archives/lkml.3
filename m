Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936563Ab3DIBQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:16:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40139 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936057Ab3DIBQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:16:46 -0400
Message-ID: <51636BFC.6040607@gmail.com>
Date: Mon, 08 Apr 2013 20:16:44 -0500
From: Jason Hrycay <jhrycay@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        C.Fries@motorola.com, jason.hrycay@motorola.com
Subject: [PATCH] f2fs: move f2fs_balance_fs from truncate to punch_hole
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Hrycay <jason.hrycay@motorola.com>

Move the f2fs_balance_fs out of the truncate_hole function and only
perform that in punch_hole use case.  The commit:

  ed60b1644e7f7e5dd67d21caf7e4425dff05dad0

intended to do this but moved it into truncate_hole to cover more
cases.  However, a deadlock scenario is possible when deleting an inode
entry under specific conditions:

 f2fs_delete_entry()
     mutex_lock_op(sbi, DENTRY_OPS);
     truncate_hole()
         f2fs_balance_fs()
             mutex_lock(&sbi->gc_mutex);
             f2fs_gc()
                 write_checkpoint()
                     block_operations()
                         mutex_lock_op(sbi, DENTRY_OPS);

Lets move it into the punch_hole case to cover the original intent of
avoiding it during fallocate's expand_inode_data case.

Change-Id: I29f8ea1056b0b88b70ba8652d901b6e8431bb27e
Signed-off-by: Jason Hrycay <jason.hrycay@motorola.com>
---
 fs/f2fs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e031f57..155b362 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -390,8 +390,6 @@ int truncate_hole(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end)
 		struct dnode_of_data dn;
 		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);

-		f2fs_balance_fs(sbi);
-
 		mutex_lock_op(sbi, DATA_TRUNC);
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
@@ -435,6 +433,9 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
 		if (pg_start < pg_end) {
 			struct address_space *mapping = inode->i_mapping;
 			loff_t blk_start, blk_end;
+			struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+			f2fs_balance_fs(sbi);

 			blk_start = pg_start << PAGE_CACHE_SHIFT;
 			blk_end = pg_end << PAGE_CACHE_SHIFT;
-- 1.8.0
