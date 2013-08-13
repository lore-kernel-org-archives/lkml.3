Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3HMQAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:00:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab3HMP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:43 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IBCEscL1MsUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=m57pyX20GrgA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=khv4F37eS3-CuV05wT4A:9 a=jeBq3FmKZ4MA:10 a=a_kMUQSG4sR1bfpb:21 a=-P-CEvOuz2njd4Vf:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155831.463086307@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [50/88] UBIFS: prepare to fix a horrid bug
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0050-UBIFS-prepare-to-fix-a-horrid-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 33f1a63ae84dfd9ad298cf275b8f1887043ced36 ]

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

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ubifs/dir.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index c95681c..63799a7 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -349,15 +349,16 @@ static unsigned int vfs_dent_type(uint8_t type)
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
@@ -365,15 +366,15 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
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
@@ -389,7 +390,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			goto out;
 		}
 
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -397,17 +398,16 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
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
 
@@ -419,7 +419,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			     ubifs_inode(dir)->creat_sqnum);
 
 		nm.len = le16_to_cpu(dent->nlen);
-		over = filldir(dirent, dent->name, nm.len, file->f_pos,
+		over = filldir(dirent, dent->name, nm.len, pos,
 			       le64_to_cpu(dent->inum),
 			       vfs_dent_type(dent->type));
 		if (over)
@@ -435,7 +435,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		}
 
 		kfree(file->private_data);
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 		cond_resched();
 	}
-- 
1.7.10.4


