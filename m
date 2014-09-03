Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbaICW0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:26:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbaICW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:26:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.16 095/125] ext4: move i_size,i_disksize update routines to helper function
Date: Wed,  3 Sep 2014 15:07:32 -0700
Message-Id: <20140903220626.530454688@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 4631dbf677ded0419fee35ca7408285dabfaef1a upstream.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h    |   16 ++++++++++++++++
 fs/ext4/extents.c |   17 ++++-------------
 fs/ext4/inode.c   |   34 ++++++++--------------------------
 3 files changed, 28 insertions(+), 39 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2453,6 +2453,22 @@ static inline void ext4_update_i_disksiz
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
+/* Update i_size, i_disksize. Requires i_mutex to avoid races with truncate */
+static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
+{
+	int changed = 0;
+
+	if (newsize > inode->i_size) {
+		i_size_write(inode, newsize);
+		changed = 1;
+	}
+	if (newsize > EXT4_I(inode)->i_disksize) {
+		ext4_update_i_disksize(inode, newsize);
+		changed |= 2;
+	}
+	return changed;
+}
+
 struct ext4_group_info {
 	unsigned long   bb_state;
 	struct rb_root  bb_free_root;
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4838,12 +4838,8 @@ static long ext4_zero_range(struct file
 	}
 
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-
 	if (new_size) {
-		if (new_size > i_size_read(inode))
-			i_size_write(inode, new_size);
-		if (new_size > EXT4_I(inode)->i_disksize)
-			ext4_update_i_disksize(inode, new_size);
+		ext4_update_inode_size(inode, new_size);
 	} else {
 		/*
 		* Mark that we allocate beyond EOF so the subsequent truncate
@@ -4885,7 +4881,6 @@ long ext4_fallocate(struct file *file, i
 	int ret = 0;
 	int flags;
 	ext4_lblk_t lblk;
-	struct timespec tv;
 	unsigned int blkbits = inode->i_blkbits;
 
 	/* Return error if mode is not supported */
@@ -4944,15 +4939,11 @@ long ext4_fallocate(struct file *file, i
 	if (IS_ERR(handle))
 		goto out;
 
-	tv = inode->i_ctime = ext4_current_time(inode);
+	inode->i_ctime = ext4_current_time(inode);
 
 	if (new_size) {
-		if (new_size > i_size_read(inode)) {
-			i_size_write(inode, new_size);
-			inode->i_mtime = tv;
-		}
-		if (new_size > EXT4_I(inode)->i_disksize)
-			ext4_update_i_disksize(inode, new_size);
+		if (ext4_update_inode_size(inode, new_size) & 0x1)
+			inode->i_mtime = inode->i_ctime;
 	} else {
 		/*
 		* Mark that we allocate beyond EOF so the subsequent truncate
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1092,27 +1092,11 @@ static int ext4_write_end(struct file *f
 	} else
 		copied = block_write_end(file, mapping, pos,
 					 len, copied, page, fsdata);
-
 	/*
-	 * No need to use i_size_read() here, the i_size
-	 * cannot change under us because we hole i_mutex.
-	 *
-	 * But it's important to update i_size while still holding page lock:
+	 * it's important to update i_size while still holding page lock:
 	 * page writeout could otherwise come in and zero beyond i_size.
 	 */
-	if (pos + copied > inode->i_size) {
-		i_size_write(inode, pos + copied);
-		i_size_changed = 1;
-	}
-
-	if (pos + copied > EXT4_I(inode)->i_disksize) {
-		/* We need to mark inode dirty even if
-		 * new_i_size is less that inode->i_size
-		 * but greater than i_disksize. (hint delalloc)
-		 */
-		ext4_update_i_disksize(inode, (pos + copied));
-		i_size_changed = 1;
-	}
+	i_size_changed = ext4_update_inode_size(inode, pos + copied);
 	unlock_page(page);
 	page_cache_release(page);
 
@@ -1160,7 +1144,7 @@ static int ext4_journalled_write_end(str
 	int ret = 0, ret2;
 	int partial = 0;
 	unsigned from, to;
-	loff_t new_i_size;
+	int size_changed = 0;
 
 	trace_ext4_journalled_write_end(inode, pos, len, copied);
 	from = pos & (PAGE_CACHE_SIZE - 1);
@@ -1183,20 +1167,18 @@ static int ext4_journalled_write_end(str
 		if (!partial)
 			SetPageUptodate(page);
 	}
-	new_i_size = pos + copied;
-	if (new_i_size > inode->i_size)
-		i_size_write(inode, pos+copied);
+	size_changed = ext4_update_inode_size(inode, pos + copied);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
-	if (new_i_size > EXT4_I(inode)->i_disksize) {
-		ext4_update_i_disksize(inode, new_i_size);
+	unlock_page(page);
+	page_cache_release(page);
+
+	if (size_changed) {
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		if (!ret)
 			ret = ret2;
 	}
 
-	unlock_page(page);
-	page_cache_release(page);
 	if (pos + len > inode->i_size && ext4_can_truncate(inode))
 		/* if we have allocated more blocks and copied
 		 * less. We will have blocks allocated outside


