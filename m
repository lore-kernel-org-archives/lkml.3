Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaKKLJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaKKLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 012/170] ext4: check EA value offset when loading
Date: Tue, 11 Nov 2014 11:06:11 +0000
Message-Id: <1415704129-12709-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a0626e75954078cfacddb00a4545dde821170bc5 upstream.

When loading extended attributes, check each entry's value offset to
make sure it doesn't collide with the entries.

Without this check it is easy to crash the kernel by mounting a
malicious FS containing a file with an EA wherein e_value_offs = 0 and
e_value_size > 0 and then deleting the EA, which corrupts the name
list.

(See the f_ea_value_crash test's FS image in e2fsprogs for an example.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/xattr.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e7387337060c..e1ed962b7738 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -190,14 +190,28 @@ ext4_listxattr(struct dentry *dentry, char *buffer, size_t size)
 }
 
 static int
-ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end)
+ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
+		       void *value_start)
 {
-	while (!IS_LAST_ENTRY(entry)) {
-		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(entry);
+	struct ext4_xattr_entry *e = entry;
+
+	while (!IS_LAST_ENTRY(e)) {
+		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(e);
 		if ((void *)next >= end)
 			return -EIO;
-		entry = next;
+		e = next;
 	}
+
+	while (!IS_LAST_ENTRY(entry)) {
+		if (entry->e_value_size != 0 &&
+		    (value_start + le16_to_cpu(entry->e_value_offs) <
+		     (void *)e + sizeof(__u32) ||
+		     value_start + le16_to_cpu(entry->e_value_offs) +
+		    le32_to_cpu(entry->e_value_size) > end))
+			return -EIO;
+		entry = EXT4_XATTR_NEXT(entry);
+	}
+
 	return 0;
 }
 
@@ -214,7 +228,8 @@ ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
 		return -EIO;
 	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
 		return -EIO;
-	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size);
+	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
+				       bh->b_data);
 	if (!error)
 		set_buffer_verified(bh);
 	return error;
@@ -331,7 +346,7 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(entry, end);
+	error = ext4_xattr_check_names(entry, end, entry);
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
@@ -463,7 +478,7 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(IFIRST(header), end);
+	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_list_entries(dentry, IFIRST(header),
@@ -986,7 +1001,8 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	is->s.here = is->s.first;
 	is->s.end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
-		error = ext4_xattr_check_names(IFIRST(header), is->s.end);
+		error = ext4_xattr_check_names(IFIRST(header), is->s.end,
+					       IFIRST(header));
 		if (error)
 			return error;
 		/* Find the named attribute. */
-- 
2.1.0

