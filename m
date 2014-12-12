Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbaLLGVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:21:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51873 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759499AbaLLGRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:18 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andreas Dilger" <adilger@dilger.ca>,
        "Eric Sandeen" <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.35475982@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 057/164] ext4: fix reservation overflow in
 ext4_da_write_begin
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - ext4_journal_start() doesn't have a type parameter
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2409,6 +2409,20 @@ static int ext4_nonda_switch(struct supe
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
@@ -2435,7 +2449,8 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle = ext4_journal_start(inode, 1);
+	handle = ext4_journal_start(inode,
+				ext4_da_write_credits(inode, pos, len));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;

