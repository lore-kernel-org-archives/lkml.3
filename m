Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbbA1ETu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:19:50 -0500
Received: from mail.kernel.org ([198.145.29.136]:38967 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933857AbbA1ETr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:19:47 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 065/177] ext4: fix reservation overflow in ext4_da_write_begin
Date: Wed, 28 Jan 2015 12:08:17 +0800
Message-Id: <1422418236-12852-130-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 0ff8947fc5f700172b37cbca811a38eb9cb81e08 upstream.

Delalloc write journal reservations only reserve 1 credit,
to update the inode if necessary.  However, it may happen
once in a filesystem's lifetime that a file will cross
the 2G threshold, and require the LARGE_FILE feature to
be set in the superblock as well, if it was not set already.

This overruns the transaction reservation, and can be
demonstrated simply on any ext4 filesystem without the LARGE_FILE
feature already set:

dd if=/dev/zero of=testfile bs=1 seek=2147483646 count=1 \
	conv=notrunc of=testfile
sync
dd if=/dev/zero of=testfile bs=1 seek=2147483647 count=1 \
	conv=notrunc of=testfile

leads to:

EXT4-fs: ext4_do_update_inode:4296: aborting transaction: error 28 in __ext4_handle_dirty_super
EXT4-fs error (device loop0) in ext4_do_update_inode:4301: error 28
EXT4-fs error (device loop0) in ext4_reserve_inode_write:4757: Readonly filesystem
EXT4-fs error (device loop0) in ext4_dirty_inode:4876: error 28
EXT4-fs error (device loop0) in ext4_da_write_end:2685: error 28

Adjust the number of credits based on whether the flag is
already set, and whether the current write may extend past the
LARGE_FILE limit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
[lizf: Backported to 3.4:
 - adjust context
 - ext4_journal_start() has no parameter type]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3598f1..9e9db42 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2408,6 +2408,20 @@ static int ext4_nonda_switch(struct super_block *sb)
 	return 0;
 }
 
+/* We always reserve for an inode update; the superblock could be there too */
+static int ext4_da_write_credits(struct inode *inode, loff_t pos, unsigned len)
+{
+	if (likely(EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				EXT4_FEATURE_RO_COMPAT_LARGE_FILE)))
+		return 1;
+
+	if (pos + len <= 0x7fffffffULL)
+		return 1;
+
+	/* We might need to update the superblock to set LARGE_FILE */
+	return 2;
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
@@ -2434,7 +2448,8 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode,
+				ext4_da_write_credits(inode, pos, len));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
-- 
1.9.1

