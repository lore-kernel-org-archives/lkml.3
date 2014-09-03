Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaICWVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:21:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920AbaICWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.16 099/125] ext4: fix same-dir rename when inline data directory overflows
Date: Wed,  3 Sep 2014 15:07:36 -0700
Message-Id: <20140903220626.668757149@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d80d448c6c5bdd32605b78a60fe8081d82d4da0f upstream.

When performing a same-directory rename, it's possible that adding or
setting the new directory entry will cause the directory to overflow
the inline data area, which causes the directory to be converted to an
extent-based directory.  Under this circumstance it is necessary to
re-read the directory when deleting the old dirent because the "old
directory" context still points to i_block in the inode table, which
is now an extent tree root!  The delete fails with an FS error, and
the subsequent fsck complains about incorrect link counts and
hardlinked directories.

Test case (originally found with flat_dir_test in the metadata_csum
test program):

# mkfs.ext4 -O inline_data /dev/sda
# mount /dev/sda /mnt
# mkdir /mnt/x
# touch /mnt/x/changelog.gz /mnt/x/copyright /mnt/x/README.Debian
# sync
# for i in /mnt/x/*; do mv $i $i.longer; done
# ls -la /mnt/x/
total 0
-rw-r--r-- 1 root root 0 Aug 25 12:03 changelog.gz.longer
-rw-r--r-- 1 root root 0 Aug 25 12:03 copyright
-rw-r--r-- 1 root root 0 Aug 25 12:03 copyright.longer
-rw-r--r-- 1 root root 0 Aug 25 12:03 README.Debian.longer

(Hey!  Why are there four files now??)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3147,7 +3147,8 @@ static int ext4_find_delete_entry(handle
 	return retval;
 }
 
-static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent)
+static void ext4_rename_delete(handle_t *handle, struct ext4_renament *ent,
+			       int force_reread)
 {
 	int retval;
 	/*
@@ -3159,7 +3160,8 @@ static void ext4_rename_delete(handle_t
 	if (le32_to_cpu(ent->de->inode) != ent->inode->i_ino ||
 	    ent->de->name_len != ent->dentry->d_name.len ||
 	    strncmp(ent->de->name, ent->dentry->d_name.name,
-		    ent->de->name_len)) {
+		    ent->de->name_len) ||
+	    force_reread) {
 		retval = ext4_find_delete_entry(handle, ent->dir,
 						&ent->dentry->d_name);
 	} else {
@@ -3210,6 +3212,7 @@ static int ext4_rename(struct inode *old
 		.dentry = new_dentry,
 		.inode = new_dentry->d_inode,
 	};
+	int force_reread;
 	int retval;
 
 	dquot_initialize(old.dir);
@@ -3271,6 +3274,15 @@ static int ext4_rename(struct inode *old
 		if (retval)
 			goto end_rename;
 	}
+	/*
+	 * If we're renaming a file within an inline_data dir and adding or
+	 * setting the new dirent causes a conversion from inline_data to
+	 * extents/blockmap, we need to force the dirent delete code to
+	 * re-read the directory, or else we end up trying to delete a dirent
+	 * from what is now the extent tree root (or a block map).
+	 */
+	force_reread = (new.dir->i_ino == old.dir->i_ino &&
+			ext4_test_inode_flag(new.dir, EXT4_INODE_INLINE_DATA));
 	if (!new.bh) {
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
 		if (retval)
@@ -3281,6 +3293,9 @@ static int ext4_rename(struct inode *old
 		if (retval)
 			goto end_rename;
 	}
+	if (force_reread)
+		force_reread = !ext4_test_inode_flag(new.dir,
+						     EXT4_INODE_INLINE_DATA);
 
 	/*
 	 * Like most other Unix systems, set the ctime for inodes on a
@@ -3292,7 +3307,7 @@ static int ext4_rename(struct inode *old
 	/*
 	 * ok, that's it
 	 */
-	ext4_rename_delete(handle, &old);
+	ext4_rename_delete(handle, &old, force_reread);
 
 	if (new.inode) {
 		ext4_dec_count(handle, new.inode);


