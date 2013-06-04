Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3FDWvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:51:19 -0400
Received: from 1wt.eu ([62.212.114.60]:35837 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab3FDWoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:02 -0400
Message-Id: <20130604172135.531887065@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 126/184] ext4: fix fdatasync() for files with only i_size
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 changes

From: Jan Kara <jack@suse.cz>

commit b71fc079b5d8f42b2a52743c8d2f1d35d655b1c5 upstream.

Code tracking when transaction needs to be committed on fdatasync(2) forgets
to handle a situation when only inode's i_size is changed. Thus in such
situations fdatasync(2) doesn't force transaction with new i_size to disk
and that can result in wrong i_size after a crash.

Fix the issue by updating inode's i_datasync_tid whenever its size is
updated.

Reported-by: Kristian Nielsen <knielsen@knielsen-hq.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index efe6363..babf448 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5121,6 +5121,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
+	int need_datasync = 0;
 
 	/* For fields not not tracking in the in-memory inode,
 	 * initialise them to zero for new inodes. */
@@ -5169,7 +5170,10 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_file_acl_high =
 			cpu_to_le16(ei->i_file_acl >> 32);
 	raw_inode->i_file_acl_lo = cpu_to_le32(ei->i_file_acl);
-	ext4_isize_set(raw_inode, ei->i_disksize);
+	if (ei->i_disksize != ext4_isize(raw_inode)) {
+		ext4_isize_set(raw_inode, ei->i_disksize);
+		need_datasync = 1;
+	}
 	if (ei->i_disksize > 0x7fffffffULL) {
 		struct super_block *sb = inode->i_sb;
 		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
@@ -5222,7 +5226,7 @@ static int ext4_do_update_inode(handle_t *handle,
 		err = rc;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 
-	ext4_update_inode_fsync_trans(handle, inode, 0);
+	ext4_update_inode_fsync_trans(handle, inode, need_datasync);
 out_brelse:
 	brelse(bh);
 	ext4_std_error(inode->i_sb, err);
-- 
1.7.12.2.21.g234cd45.dirty



