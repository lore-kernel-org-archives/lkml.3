Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3ITUco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:32:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3ITUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 21/93] ext4: fix lost truncate due to race with writeback
Date: Fri, 20 Sep 2013 13:08:16 -0700
Message-Id: <1379707768-1804-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 90e775b71ac4e685898c7995756fe58c135adaa6 upstream.

The following race can lead to a loss of i_disksize update from truncate
thus resulting in a wrong inode size if the inode size isn't updated
again before inode is reclaimed:

ext4_setattr()				mpage_map_and_submit_extent()
  EXT4_I(inode)->i_disksize = attr->ia_size;
  ...					  ...
					  disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT
					  /* False because i_size isn't
					   * updated yet */
					  if (disksize > i_size_read(inode))
					  /* True, because i_disksize is
					   * already truncated */
					  if (disksize > EXT4_I(inode)->i_disksize)
					    /* Overwrite i_disksize
					     * update from truncate */
					    ext4_update_i_disksize()
  i_size_write(inode, attr->ia_size);

For other places updating i_disksize such race cannot happen because
i_mutex prevents these races. Writeback is the only place where we do
not hold i_mutex and we cannot grab it there because of lock ordering.

We fix the race by doing both i_disksize and i_size update in truncate
atomically under i_data_sem and in mpage_map_and_submit_extent() we move
the check against i_size under i_data_sem as well.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/ext4.h  | 24 ++++++++++++++++++++----
 fs/ext4/inode.c | 17 ++++++++++++-----
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bbcd6a0..a4903ff 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2341,16 +2341,32 @@ do {								\
 #define EXT4_FREECLUSTERS_WATERMARK 0
 #endif
 
+/* Update i_disksize. Requires i_mutex to avoid races with truncate */
 static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
 {
-	/*
-	 * XXX: replace with spinlock if seen contended -bzzz
-	 */
+	WARN_ON_ONCE(S_ISREG(inode->i_mode) &&
+		     !mutex_is_locked(&inode->i_mutex));
+	down_write(&EXT4_I(inode)->i_data_sem);
+	if (newsize > EXT4_I(inode)->i_disksize)
+		EXT4_I(inode)->i_disksize = newsize;
+	up_write(&EXT4_I(inode)->i_data_sem);
+}
+
+/*
+ * Update i_disksize after writeback has been started. Races with truncate
+ * are avoided by checking i_size under i_data_sem.
+ */
+static inline void ext4_wb_update_i_disksize(struct inode *inode, loff_t newsize)
+{
+	loff_t i_size;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
+	i_size = i_size_read(inode);
+	if (newsize > i_size)
+		newsize = i_size;
 	if (newsize > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = newsize;
 	up_write(&EXT4_I(inode)->i_data_sem);
-	return ;
 }
 
 struct ext4_group_info {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 158145b..fe1fada 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1666,10 +1666,8 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	 * Update on-disk size along with block allocation.
 	 */
 	disksize = ((loff_t) next + blks) << mpd->inode->i_blkbits;
-	if (disksize > i_size_read(mpd->inode))
-		disksize = i_size_read(mpd->inode);
 	if (disksize > EXT4_I(mpd->inode)->i_disksize) {
-		ext4_update_i_disksize(mpd->inode, disksize);
+		ext4_wb_update_i_disksize(mpd->inode, disksize);
 		err = ext4_mark_inode_dirty(handle, mpd->inode);
 		if (err)
 			ext4_error(mpd->inode->i_sb,
@@ -4449,18 +4447,27 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
 			}
+			down_write(&EXT4_I(inode)->i_data_sem);
 			EXT4_I(inode)->i_disksize = attr->ia_size;
 			rc = ext4_mark_inode_dirty(handle, inode);
 			if (!error)
 				error = rc;
+			/*
+			 * We have to update i_size under i_data_sem together
+			 * with i_disksize to avoid races with writeback code
+			 * running ext4_wb_update_i_disksize().
+			 */
+			if (!error)
+				i_size_write(inode, attr->ia_size);
+			up_write(&EXT4_I(inode)->i_data_sem);
 			ext4_journal_stop(handle);
 			if (error) {
 				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		}
+		} else
+			i_size_write(inode, attr->ia_size);
 
-		i_size_write(inode, attr->ia_size);
 		/*
 		 * Blocks are going to be removed from the inode. Wait
 		 * for dio in flight.  Temporarily disable
-- 
1.8.1.2

