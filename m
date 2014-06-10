Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaFJTxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaFJTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 061/160] ext4: move ext4_update_i_disksize() into mpage_map_and_submit_extent()
Date: Tue, 10 Jun 2014 12:45:01 -0700
Message-Id: <1402429600-20477-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 622cad1325e404598fe3b148c3fa640dbaabc235 upstream.

The function ext4_update_i_disksize() is used in only one place, in
the function mpage_map_and_submit_extent().  Move its code to simplify
the code paths, and also move the call to ext4_mark_inode_dirty() into
the i_data_sem's critical region, to be consistent with all of the
other places where we update i_disksize.  That way, we also keep the
raw_inode's i_disksize protected, to avoid the following race:

      CPU #1                                 CPU #2

   down_write(&i_data_sem)
   Modify i_disk_size
   up_write(&i_data_sem)
                                        down_write(&i_data_sem)
                                        Modify i_disk_size
                                        Copy i_disk_size to on-disk inode
                                        up_write(&i_data_sem)
   Copy i_disk_size to on-disk inode

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/ext4.h  | 17 -----------------
 fs/ext4/inode.c | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d3a534f..3a603a8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2462,23 +2462,6 @@ static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
-/*
- * Update i_disksize after writeback has been started. Races with truncate
- * are avoided by checking i_size under i_data_sem.
- */
-static inline void ext4_wb_update_i_disksize(struct inode *inode, loff_t newsize)
-{
-	loff_t i_size;
-
-	down_write(&EXT4_I(inode)->i_data_sem);
-	i_size = i_size_read(inode);
-	if (newsize > i_size)
-		newsize = i_size;
-	if (newsize > EXT4_I(inode)->i_disksize)
-		EXT4_I(inode)->i_disksize = newsize;
-	up_write(&EXT4_I(inode)->i_data_sem);
-}
-
 struct ext4_group_info {
 	unsigned long   bb_state;
 	struct rb_root  bb_free_root;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8ccbe9a..4fafd09 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2242,13 +2242,23 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			return err;
 	} while (map->m_len);
 
-	/* Update on-disk size after IO is submitted */
+	/*
+	 * Update on-disk size after IO is submitted.  Races with
+	 * truncate are avoided by checking i_size under i_data_sem.
+	 */
 	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
 	if (disksize > EXT4_I(inode)->i_disksize) {
 		int err2;
-
-		ext4_wb_update_i_disksize(inode, disksize);
+		loff_t i_size;
+
+		down_write(&EXT4_I(inode)->i_data_sem);
+		i_size = i_size_read(inode);
+		if (disksize > i_size)
+			disksize = i_size;
+		if (disksize > EXT4_I(inode)->i_disksize)
+			EXT4_I(inode)->i_disksize = disksize;
 		err2 = ext4_mark_inode_dirty(handle, inode);
+		up_write(&EXT4_I(inode)->i_data_sem);
 		if (err2)
 			ext4_error(inode->i_sb,
 				   "Failed to mark inode %lu dirty",
-- 
1.9.1

