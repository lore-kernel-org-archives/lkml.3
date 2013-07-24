Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3GXOK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45808 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab3GXOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.110190861@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [53/85] UBIFS: prepare to fix a horrid bug
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 33f1a63ae84dfd9ad298cf275b8f1887043ced36 upstream.

Al Viro pointed me to the fact that '->readdir()' and '->llseek()' have no
mutual exclusion, which means the 'ubifs_dir_llseek()' can be run while we are
in the middle of 'ubifs_readdir()'.

First of all, this means that 'file->private_data' can be freed while
'ubifs_readdir()' uses it.  But this particular patch does not fix the problem.
This patch is only a preparation, and the fix will follow next.

In this patch we make 'ubifs_readdir()' stop using 'file->f_pos' directly,
because 'file->f_pos' can be changed by '->llseek()' at any point. This may
lead 'ubifs_readdir()' to returning inconsistent data: directory entry names
may correspond to incorrect file positions.

So here we introduce a local variable 'pos', read 'file->f_pose' once at very
the beginning, and then stick to 'pos'. The result of this is that when
'ubifs_dir_llseek()' changes 'file->f_pos' while we are in the middle of
'ubifs_readdir()', the latter "wins".

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/dir.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -357,15 +357,16 @@ static unsigned int vfs_dent_type(uint8_
 static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 {
 	int err, over = 0;
+	loff_t pos = file->f_pos;
 	struct qstr nm;
 	union ubifs_key key;
 	struct ubifs_dent_node *dent;
 	struct inode *dir = file->f_path.dentry->d_inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 
-	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, file->f_pos);
+	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, pos);
 
-	if (file->f_pos > UBIFS_S_KEY_HASH_MASK || file->f_pos == 2)
+	if (pos > UBIFS_S_KEY_HASH_MASK || pos == 2)
 		/*
 		 * The directory was seek'ed to a senseless position or there
 		 * are no more entries.
@@ -373,15 +374,15 @@ static int ubifs_readdir(struct file *fi
 		return 0;
 
 	/* File positions 0 and 1 correspond to "." and ".." */
-	if (file->f_pos == 0) {
+	if (pos == 0) {
 		ubifs_assert(!file->private_data);
 		over = filldir(dirent, ".", 1, 0, dir->i_ino, DT_DIR);
 		if (over)
 			return 0;
-		file->f_pos = 1;
+		file->f_pos = pos = 1;
 	}
 
-	if (file->f_pos == 1) {
+	if (pos == 1) {
 		ubifs_assert(!file->private_data);
 		over = filldir(dirent, "..", 2, 1,
 			       parent_ino(file->f_path.dentry), DT_DIR);
@@ -397,7 +398,7 @@ static int ubifs_readdir(struct file *fi
 			goto out;
 		}
 
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -405,17 +406,16 @@ static int ubifs_readdir(struct file *fi
 	if (!dent) {
 		/*
 		 * The directory was seek'ed to and is now readdir'ed.
-		 * Find the entry corresponding to @file->f_pos or the
-		 * closest one.
+		 * Find the entry corresponding to @pos or the closest one.
 		 */
-		dent_key_init_hash(c, &key, dir->i_ino, file->f_pos);
+		dent_key_init_hash(c, &key, dir->i_ino, pos);
 		nm.name = NULL;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
 			err = PTR_ERR(dent);
 			goto out;
 		}
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -427,7 +427,7 @@ static int ubifs_readdir(struct file *fi
 			     ubifs_inode(dir)->creat_sqnum);
 
 		nm.len = le16_to_cpu(dent->nlen);
-		over = filldir(dirent, dent->name, nm.len, file->f_pos,
+		over = filldir(dirent, dent->name, nm.len, pos,
 			       le64_to_cpu(dent->inum),
 			       vfs_dent_type(dent->type));
 		if (over)
@@ -443,7 +443,7 @@ static int ubifs_readdir(struct file *fi
 		}
 
 		kfree(file->private_data);
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 		cond_resched();
 	}

