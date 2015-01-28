Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbbA1ETW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:19:22 -0500
Received: from mail.kernel.org ([198.145.29.136]:38723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761499AbbA1ETI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:19:08 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 059/177] ext4: check EA value offset when loading
Date: Wed, 28 Jan 2015 12:08:05 +0800
Message-Id: <1422418236-12852-118-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/xattr.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5743e9d..96455e6 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -144,14 +144,28 @@ ext4_listxattr(struct dentry *dentry, char *buffer, size_t size)
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
 
@@ -161,7 +175,8 @@ ext4_xattr_check_block(struct buffer_head *bh)
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1))
 		return -EIO;
-	return ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size);
+	return ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
+				      bh->b_data);
 }
 
 static inline int
@@ -274,7 +289,7 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(entry, end);
+	error = ext4_xattr_check_names(entry, end, entry);
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
@@ -402,7 +417,7 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(IFIRST(header), end);
+	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_list_entries(dentry, IFIRST(header),
@@ -914,7 +929,8 @@ ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
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
1.9.1

