Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbaEMKMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:12:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933740AbaEMKL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/182] ext4: fix jbd2 warning under heavy xattr load
Date: Tue, 13 May 2014 11:27:49 +0200
Message-Id: <cf7fe5263adcd131119192714b95d47bbf0c5b64.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ec4cb1aa2b7bae18dd8164f2e9c7c51abcf61280 upstream.

When heavily exercising xattr code the assertion that
jbd2_journal_dirty_metadata() shouldn't return error was triggered:

WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1237
jbd2_journal_dirty_metadata+0x1ba/0x260()

CPU: 0 PID: 8877 Comm: ceph-osd Tainted: G    W 3.10.0-ceph-00049-g68d04c9 #1
Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
 ffffffff81a1d3c8 ffff880214469928 ffffffff816311b0 ffff880214469968
 ffffffff8103fae0 ffff880214469958 ffff880170a9dc30 ffff8802240fbe80
 0000000000000000 ffff88020b366000 ffff8802256e7510 ffff880214469978
Call Trace:
 [<ffffffff816311b0>] dump_stack+0x19/0x1b
 [<ffffffff8103fae0>] warn_slowpath_common+0x70/0xa0
 [<ffffffff8103fb2a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81267c2a>] jbd2_journal_dirty_metadata+0x1ba/0x260
 [<ffffffff81245093>] __ext4_handle_dirty_metadata+0xa3/0x140
 [<ffffffff812561f3>] ext4_xattr_release_block+0x103/0x1f0
 [<ffffffff81256680>] ext4_xattr_block_set+0x1e0/0x910
 [<ffffffff8125795b>] ext4_xattr_set_handle+0x38b/0x4a0
 [<ffffffff810a319d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81257b32>] ext4_xattr_set+0xc2/0x140
 [<ffffffff81258547>] ext4_xattr_user_set+0x47/0x50
 [<ffffffff811935ce>] generic_setxattr+0x6e/0x90
 [<ffffffff81193ecb>] __vfs_setxattr_noperm+0x7b/0x1c0
 [<ffffffff811940d4>] vfs_setxattr+0xc4/0xd0
 [<ffffffff8119421e>] setxattr+0x13e/0x1e0
 [<ffffffff811719c7>] ? __sb_start_write+0xe7/0x1b0
 [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
 [<ffffffff8118c65c>] ? fget_light+0x3c/0x130
 [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
 [<ffffffff8118f1f8>] ? __mnt_want_write+0x58/0x70
 [<ffffffff811946be>] SyS_fsetxattr+0xbe/0x100
 [<ffffffff816407c2>] system_call_fastpath+0x16/0x1b

The reason for the warning is that buffer_head passed into
jbd2_journal_dirty_metadata() didn't have journal_head attached. This is
caused by the following race of two ext4_xattr_release_block() calls:

CPU1                                CPU2
ext4_xattr_release_block()          ext4_xattr_release_block()
lock_buffer(bh);
/* False */
if (BHDR(bh)->h_refcount == cpu_to_le32(1))
} else {
  le32_add_cpu(&BHDR(bh)->h_refcount, -1);
  unlock_buffer(bh);
                                    lock_buffer(bh);
                                    /* True */
                                    if (BHDR(bh)->h_refcount == cpu_to_le32(1))
                                      get_bh(bh);
                                      ext4_free_blocks()
                                        ...
                                        jbd2_journal_forget()
                                          jbd2_journal_unfile_buffer()
                                          -> JH is gone
  error = ext4_handle_dirty_xattr_block(handle, inode, bh);
  -> triggers the warning

We fix the problem by moving ext4_handle_dirty_xattr_block() under the
buffer lock. Sadly this cannot be done in nojournal mode as that
function can call sync_dirty_buffer() which would deadlock. Luckily in
nojournal mode the race is harmless (we only dirty already freed buffer)
and thus for nojournal mode we leave the dirtying outside of the buffer
lock.

Reported-by: Sage Weil <sage@inktank.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/xattr.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1423c4816a47..298e9c8da364 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -517,8 +517,8 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 }
 
 /*
- * Release the xattr block BH: If the reference count is > 1, decrement
- * it; otherwise free the block.
+ * Release the xattr block BH: If the reference count is > 1, decrement it;
+ * otherwise free the block.
  */
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
@@ -538,16 +538,31 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		if (ce)
 			mb_cache_entry_free(ce);
 		get_bh(bh);
+		unlock_buffer(bh);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
-		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
+		/*
+		 * Beware of this ugliness: Releasing of xattr block references
+		 * from different inodes can race and so we have to protect
+		 * from a race where someone else frees the block (and releases
+		 * its journal_head) before we are done dirtying the buffer. In
+		 * nojournal mode this race is harmless and we actually cannot
+		 * call ext4_handle_dirty_xattr_block() with locked buffer as
+		 * that function can call sync_dirty_buffer() so for that case
+		 * we handle the dirtying after unlocking the buffer.
+		 */
+		if (ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		unlock_buffer(bh);
-		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
+		if (!ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
-- 
1.9.3

