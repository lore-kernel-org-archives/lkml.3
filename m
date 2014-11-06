Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaKFWn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaKFWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 069/162] ext4: fix reservation overflow in ext4_da_write_begin
Date: Thu,  6 Nov 2014 14:35:33 -0800
Message-Id: <1415313426-9622-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a4c4f38..37a8c8b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2638,6 +2638,20 @@ static int ext4_nonda_switch(struct super_block *sb)
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
@@ -2688,7 +2702,8 @@ retry_grab:
 	 * of file which has an already mapped buffer.
 	 */
 retry_journal:
-	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, 1);
+	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
+				ext4_da_write_credits(inode, pos, len));
 	if (IS_ERR(handle)) {
 		page_cache_release(page);
 		return PTR_ERR(handle);
-- 
1.9.1

