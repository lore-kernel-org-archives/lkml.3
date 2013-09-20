Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3ITUPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3ITUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 20/93] ext4: simplify truncation code in ext4_setattr()
Date: Fri, 20 Sep 2013 13:08:15 -0700
Message-Id: <1379707768-1804-21-git-send-email-kamal@canonical.com>
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

commit 5208386c501276df18fee464e21d3c58d2d79517 upstream.

Merge conditions in ext4_setattr() handling inode size changes, also
move ext4_begin_ordered_truncate() call somewhat earlier because it
simplifies error recovery in case of failure. Also add error handling in
case i_disksize update fails.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ kamal: backport to 3.8 (no ext4_journal_start context info) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 108 +++++++++++++++++++++++++-------------------------------
 1 file changed, 49 insertions(+), 59 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1ec8761..158145b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4422,7 +4422,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		ext4_journal_stop(handle);
 	}
 
-	if (attr->ia_valid & ATTR_SIZE) {
+	if (attr->ia_valid & ATTR_SIZE && attr->ia_size != inode->i_size) {
+		handle_t *handle;
+		loff_t oldsize = inode->i_size;
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4430,72 +4432,60 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
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
-		handle = ext4_journal_start(inode, 3);
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
-				handle = ext4_journal_start(inode, 3);
-				if (IS_ERR(handle)) {
-					ext4_orphan_del(NULL, inode);
+				if (error)
 					goto err_out;
-				}
-				ext4_orphan_del(handle, inode);
-				orphan = 0;
-				ext4_journal_stop(handle);
+			}
+			handle = ext4_journal_start(inode, 3);
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
 
-	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size != inode->i_size) {
-			loff_t oldsize = inode->i_size;
-
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
-- 
1.8.1.2

