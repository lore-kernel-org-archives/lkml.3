Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3IYBD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:03:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3IYAQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 057/110] ext4: simplify truncation code in ext4_setattr()
Date: Tue, 24 Sep 2013 17:14:55 -0700
Message-Id: <20130925001329.586190866@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 5208386c501276df18fee464e21d3c58d2d79517 upstream.

Merge conditions in ext4_setattr() handling inode size changes, also
move ext4_begin_ordered_truncate() call somewhat earlier because it
simplifies error recovery in case of failure. Also add error handling in
case i_disksize update fails.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |  109 +++++++++++++++++++++++++-------------------------------
 1 file changed, 49 insertions(+), 60 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4706,7 +4706,9 @@ int ext4_setattr(struct dentry *dentry,
 		ext4_journal_stop(handle);
 	}
 
-	if (attr->ia_valid & ATTR_SIZE) {
+	if (attr->ia_valid & ATTR_SIZE && attr->ia_size != inode->i_size) {
+		handle_t *handle;
+		loff_t oldsize = inode->i_size;
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4714,73 +4716,60 @@ int ext4_setattr(struct dentry *dentry,
 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
 				return -EFBIG;
 		}
-	}
-
-	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE &&
-	    (attr->ia_size < inode->i_size)) {
-		handle_t *handle;
-
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
-		if (IS_ERR(handle)) {
-			error = PTR_ERR(handle);
-			goto err_out;
-		}
-		if (ext4_handle_valid(handle)) {
-			error = ext4_orphan_add(handle, inode);
-			orphan = 1;
-		}
-		EXT4_I(inode)->i_disksize = attr->ia_size;
-		rc = ext4_mark_inode_dirty(handle, inode);
-		if (!error)
-			error = rc;
-		ext4_journal_stop(handle);
-
-		if (ext4_should_order_data(inode)) {
-			error = ext4_begin_ordered_truncate(inode,
+		if (S_ISREG(inode->i_mode) &&
+		    (attr->ia_size < inode->i_size)) {
+			if (ext4_should_order_data(inode)) {
+				error = ext4_begin_ordered_truncate(inode,
 							    attr->ia_size);
-			if (error) {
-				/* Do as much error cleanup as possible */
-				handle = ext4_journal_start(inode,
-							    EXT4_HT_INODE, 3);
-				if (IS_ERR(handle)) {
-					ext4_orphan_del(NULL, inode);
+				if (error)
 					goto err_out;
-				}
-				ext4_orphan_del(handle, inode);
-				orphan = 0;
-				ext4_journal_stop(handle);
+			}
+			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
+			if (IS_ERR(handle)) {
+				error = PTR_ERR(handle);
+				goto err_out;
+			}
+			if (ext4_handle_valid(handle)) {
+				error = ext4_orphan_add(handle, inode);
+				orphan = 1;
+			}
+			EXT4_I(inode)->i_disksize = attr->ia_size;
+			rc = ext4_mark_inode_dirty(handle, inode);
+			if (!error)
+				error = rc;
+			ext4_journal_stop(handle);
+			if (error) {
+				ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
 		}
-	}
-
-	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size != inode->i_size) {
-			loff_t oldsize = inode->i_size;
 
-			i_size_write(inode, attr->ia_size);
-			/*
-			 * Blocks are going to be removed from the inode. Wait
-			 * for dio in flight.  Temporarily disable
-			 * dioread_nolock to prevent livelock.
-			 */
-			if (orphan) {
-				if (!ext4_should_journal_data(inode)) {
-					ext4_inode_block_unlocked_dio(inode);
-					inode_dio_wait(inode);
-					ext4_inode_resume_unlocked_dio(inode);
-				} else
-					ext4_wait_for_tail_page_commit(inode);
-			}
-			/*
-			 * Truncate pagecache after we've waited for commit
-			 * in data=journal mode to make pages freeable.
-			 */
-			truncate_pagecache(inode, oldsize, inode->i_size);
+		i_size_write(inode, attr->ia_size);
+		/*
+		 * Blocks are going to be removed from the inode. Wait
+		 * for dio in flight.  Temporarily disable
+		 * dioread_nolock to prevent livelock.
+		 */
+		if (orphan) {
+			if (!ext4_should_journal_data(inode)) {
+				ext4_inode_block_unlocked_dio(inode);
+				inode_dio_wait(inode);
+				ext4_inode_resume_unlocked_dio(inode);
+			} else
+				ext4_wait_for_tail_page_commit(inode);
 		}
-		ext4_truncate(inode);
+		/*
+		 * Truncate pagecache after we've waited for commit
+		 * in data=journal mode to make pages freeable.
+		 */
+		truncate_pagecache(inode, oldsize, inode->i_size);
 	}
+	/*
+	 * We want to call ext4_truncate() even if attr->ia_size ==
+	 * inode->i_size for cases like truncation of fallocated space
+	 */
+	if (attr->ia_valid & ATTR_SIZE)
+		ext4_truncate(inode);
 
 	if (!rc) {
 		setattr_copy(inode, attr);


