Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaBEUIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:00 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48515 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbaBEUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 169/213] ext3: Fix fdatasync() for files with only i_size changes
Date: Wed, 5 Feb 2014 15:02:04 -0500
Message-ID: <1391630568-49251-170-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 156bddd8e505b295540f3ca0e27dda68cb0d49aa upstream.

Code tracking when transaction needs to be committed on fdatasync(2) forgets
to handle a situation when only inode's i_size is changed. Thus in such
situations fdatasync(2) doesn't force transaction with new i_size to disk
and that can result in wrong i_size after a crash.

Fix the issue by updating inode's i_datasync_tid whenever its size is
updated.

Reported-by: Kristian Nielsen <knielsen@knielsen-hq.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext3/inode.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ea33bdf0a300..f841730b751e 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2959,6 +2959,8 @@ static int ext3_do_update_inode(handle_t *handle,
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
+	__le32 disksize;
 
 again:
 	/* we can't allow multiple procs in here at once, its a bit racey */
@@ -2996,7 +2998,11 @@ again:
 		raw_inode->i_gid_high = 0;
 	}
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
-	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
+	disksize = cpu_to_le32(ei->i_disksize);
+	if (disksize != raw_inode->i_size) {
+		need_datasync = 1;
+		raw_inode->i_size = disksize;
+	}
 	raw_inode->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
 	raw_inode->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
@@ -3012,8 +3018,11 @@ again:
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
 	} else {
-		raw_inode->i_size_high =
-			cpu_to_le32(ei->i_disksize >> 32);
+		disksize = cpu_to_le32(ei->i_disksize >> 32);
+		if (disksize != raw_inode->i_size_high) {
+			raw_inode->i_size_high = disksize;
+			need_datasync = 1;
+		}
 		if (ei->i_disksize > 0x7fffffffULL) {
 			struct super_block *sb = inode->i_sb;
 			if (!EXT3_HAS_RO_COMPAT_FEATURE(sb,
@@ -3066,6 +3075,8 @@ again:
 	ext3_clear_inode_state(inode, EXT3_STATE_NEW);
 
 	atomic_set(&ei->i_sync_tid, handle->h_transaction->t_tid);
+	if (need_datasync)
+		atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
 out_brelse:
 	brelse (bh);
 	ext3_std_error(inode->i_sb, err);
-- 
1.8.5.2

