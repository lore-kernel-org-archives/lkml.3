Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbaLLHB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:01:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51704 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758421AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.282889638@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 007/164] ext4: check EA value offset when loading
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/xattr.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -144,14 +144,28 @@ ext4_listxattr(struct dentry *dentry, ch
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
 
@@ -163,7 +177,8 @@ ext4_xattr_check_block(struct buffer_hea
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1))
 		return -EIO;
-	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size);
+	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
+				       bh->b_data);
 	return error;
 }
 
@@ -276,7 +291,7 @@ ext4_xattr_ibody_get(struct inode *inode
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(entry, end);
+	error = ext4_xattr_check_names(entry, end, entry);
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
@@ -403,7 +418,7 @@ ext4_xattr_ibody_list(struct dentry *den
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(IFIRST(header), end);
+	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_list_entries(dentry, IFIRST(header),
@@ -914,7 +929,8 @@ ext4_xattr_ibody_find(struct inode *inod
 	is->s.here = is->s.first;
 	is->s.end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
-		error = ext4_xattr_check_names(IFIRST(header), is->s.end);
+		error = ext4_xattr_check_names(IFIRST(header), is->s.end,
+					       IFIRST(header));
 		if (error)
 			return error;
 		/* Find the named attribute. */

