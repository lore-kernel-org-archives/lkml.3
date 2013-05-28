Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab3E1IrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:47:20 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:45011 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933595Ab3E1IrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:47:18 -0400
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Cc: cui.yunfeng@zte.com.cn, wang.bo116@zte.com.cn,
        LKML <linux-kernel@vger.kernel.org>, liu.dong3@zte.com.cn,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        deng.chao1@zte.com.cn
Subject: [PATCH] [RFC]UBIFS: NFS exportfs support
MIME-Version: 1.0
X-KeepSent: 62E14AEF:618F88B0-48257B79:002FEE5B;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 6.5.6 March 06, 2007
Message-ID: <OF62E14AEF.618F88B0-ON48257B79.002FEE5B-48257B79.0030C86E@zte.com.cn>
From: deng.chao1@zte.com.cn
Date: Tue, 28 May 2013 16:46:55 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-05-28 16:46:37,
	Serialize complete at 2013-05-28 16:46:37
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse02.zte.com.cn r4S8ko62024448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBIfs hasn't supported exporting via NFS yet. The main reason, i think, is 
that UBIfs does not store parent inode number information for each inode 
in flash media directly.The information is a must for the callback 
"get_parent" which is one of the exportfs mandatory callbacks.
To solve this, i plan to use the member "padding1" of "struct 
ubifs_ino_node" to store the information in flash media.(you can see 
struct ubifs_ino_node's statement in "ubifs-media.h".)
The change of the format in flash media obviously will bring compatibilty 
problem. But it is lucky that the "padding1" was reserved for future in 
the first place on purpose.
The compatibilty problem only takes place under this circumstance: to use 
this patch to export the UBIfs via NFS when the UBIfs has already run in 
the flash media, the flash image the UBIfs has already made in the media 
must be discarded.
We may need such a user space tool to transform the old flash image: read 
all files out and re-write them back to flash, so that the UBIfs can 
replace the zeos in "padding1" with parent inode number.
Also, mkfs.ubifs in mtd-utils needs some changes to company this patch.
If this patch is ok, i will post the patch for mkfs.ubifs later.

Signed-off-by: deng chao<deng.chao1 at zte.com.cn>
---
>From e6e30165fd3afa493b5f5f6a7b4d7e6677d95668 Mon Sep 17 00:00:00 2001
From: dengchao <deng.chao1@zte.com.cn>
Date: Tue, 28 May 2013 16:02:33 +0000
Subject: [PATCH] "UBIFS:NFS exportfs support"

---
 linux-3.10-rc3/fs/ubifs/dir.c         |    2 +
 linux-3.10-rc3/fs/ubifs/journal.c     |    2 +-
 linux-3.10-rc3/fs/ubifs/super.c       |   51 
+++++++++++++++++++++++++++++++++
 linux-3.10-rc3/fs/ubifs/ubifs-media.h |    4 +-
 linux-3.10-rc3/fs/ubifs/ubifs.h       |    2 +
 5 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/linux-3.10-rc3/fs/ubifs/dir.c b/linux-3.10-rc3/fs/ubifs/dir.c
index de08c92..73a994e 100755
--- a/linux-3.10-rc3/fs/ubifs/dir.c
+++ b/linux-3.10-rc3/fs/ubifs/dir.c
@@ -166,6 +166,7 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, 
const struct inode *dir,
         * purpose of rebuilding the index.
         */
        ui->creat_sqnum = ++c->max_sqnum;
+       ui->parent_ino = dir->i_ino;
        spin_unlock(&c->cnt_lock);
        return inode;
 }
@@ -1080,6 +1081,7 @@ static int ubifs_rename(struct inode *old_dir, 
struct dentry *old_dentry,
        if (err)
                goto out_cancel;
 
+       old_inode_ui->parent_ino = new_dir->i_ino;
        unlock_3_inodes(old_dir, new_dir, new_inode);
        ubifs_release_budget(c, &req);
 
diff --git a/linux-3.10-rc3/fs/ubifs/journal.c 
b/linux-3.10-rc3/fs/ubifs/journal.c
index afaad07..db93987 100755
--- a/linux-3.10-rc3/fs/ubifs/journal.c
+++ b/linux-3.10-rc3/fs/ubifs/journal.c
@@ -66,7 +66,6 @@
  */
 static inline void zero_ino_node_unused(struct ubifs_ino_node *ino)
 {
-       memset(ino->padding1, 0, 4);
        memset(ino->padding2, 0, 26);
 }
 
@@ -480,6 +479,7 @@ static void pack_inode(struct ubifs_info *c, struct 
ubifs_ino_node *ino,
        ino->xattr_cnt   = cpu_to_le32(ui->xattr_cnt);
        ino->xattr_size  = cpu_to_le32(ui->xattr_size);
        ino->xattr_names = cpu_to_le32(ui->xattr_names);
+       ino->parent_ino = cpu_to_le32(ui->parent_ino);
        zero_ino_node_unused(ino);
 
        /*
diff --git a/linux-3.10-rc3/fs/ubifs/super.c 
b/linux-3.10-rc3/fs/ubifs/super.c
index f21acf0..b89afb2 100755
--- a/linux-3.10-rc3/fs/ubifs/super.c
+++ b/linux-3.10-rc3/fs/ubifs/super.c
@@ -150,6 +150,7 @@ struct inode *ubifs_iget(struct super_block *sb, 
unsigned long inum)
        ui->synced_i_size = ui->ui_size = inode->i_size;
 
        ui->xattr = (ui->flags & UBIFS_XATTR_FL) ? 1 : 0;
+       ui->parent_ino = le32_to_cpu(ino->parent_ino);
 
        err = validate_inode(c, inode);
        if (err)
@@ -2002,6 +2003,55 @@ static struct ubifs_info *alloc_ubifs_info(struct 
ubi_volume_desc *ubi)
        return c;
 }
 
+static struct inode *ubifs_nfs_get_inode(struct super_block *sb, uint64_t 
ino,
+                                        uint32_t generation)
+{
+/*
+ * Note, since UBIFS does re-use inode numbers at the moment, we do not 
check
+ * the generation number in this function.
+ */
+       struct inode *inode;
+       inode = ubifs_iget(sb, ino);
+       if (IS_ERR(inode)) {
+               if (PTR_ERR(inode) == -ENOENT)
+                       return ERR_PTR(-ESTALE);
+               return ERR_CAST(inode);
+       }
+       return inode;
+}
+
+static struct dentry *ubifs_fh_to_dentry(struct super_block *sb,
+       struct fid *fid, int fh_len, int fh_type)
+{
+       return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+                                       ubifs_nfs_get_inode);
+}
+
+static struct dentry *ubifs_fh_to_parent(struct super_block *sb,
+       struct fid *fid, int fh_len, int fh_type)
+{
+       return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+                                       ubifs_nfs_get_inode);
+}
+
+static struct dentry *ubifs_get_parent(struct dentry *child)
+{
+       struct ubifs_inode *ui;
+       unsigned long pino;
+
+       ui = ubifs_inode(child->d_inode);
+       pino = ui->parent_ino;
+       return d_obtain_alias(ubifs_iget(child->d_inode->i_sb, pino));
+}
+
+
+static struct export_operations ubifs_export_ops = {
+       .fh_to_dentry = ubifs_fh_to_dentry,
+       .fh_to_parent = ubifs_fh_to_parent,
+       .get_parent = ubifs_get_parent,
+};
+
+
 static int ubifs_fill_super(struct super_block *sb, void *data, int 
silent)
 {
        struct ubifs_info *c = sb->s_fs_info;
@@ -2047,6 +2097,7 @@ static int ubifs_fill_super(struct super_block *sb, 
void *data, int silent)
        if (c->max_inode_sz > MAX_LFS_FILESIZE)
                sb->s_maxbytes = c->max_inode_sz = MAX_LFS_FILESIZE;
        sb->s_op = &ubifs_super_operations;
+       sb->s_export_op = &ubifs_export_ops;
 
        mutex_lock(&c->umount_mutex);
        err = mount_ubifs(c);
diff --git a/linux-3.10-rc3/fs/ubifs/ubifs-media.h 
b/linux-3.10-rc3/fs/ubifs/ubifs-media.h
index e24380c..8d03fd3 100755
--- a/linux-3.10-rc3/fs/ubifs/ubifs-media.h
+++ b/linux-3.10-rc3/fs/ubifs/ubifs-media.h
@@ -472,7 +472,7 @@ union ubifs_dev_desc {
  * @data_len: inode data length
  * @xattr_cnt: count of extended attributes this inode has
  * @xattr_size: summarized size of all extended attributes in bytes
- * @padding1: reserved for future, zeroes
+ * @parent_ino: the inode's parent inode number(for nfs exportfs)
  * @xattr_names: sum of lengths of all extended attribute names belonging 
to
  *               this inode
  * @compr_type: compression type used for this inode
@@ -506,7 +506,7 @@ struct ubifs_ino_node {
        __le32 data_len;
        __le32 xattr_cnt;
        __le32 xattr_size;
-       __u8 padding1[4]; /* Watch 'zero_ino_node_unused()' if changing! 
*/
+       __le32 parent_ino;
        __le32 xattr_names;
        __le16 compr_type;
        __u8 padding2[26]; /* Watch 'zero_ino_node_unused()' if changing! 
*/
diff --git a/linux-3.10-rc3/fs/ubifs/ubifs.h 
b/linux-3.10-rc3/fs/ubifs/ubifs.h
index b2babce..5b46085 100755
--- a/linux-3.10-rc3/fs/ubifs/ubifs.h
+++ b/linux-3.10-rc3/fs/ubifs/ubifs.h
@@ -339,6 +339,7 @@ struct ubifs_gced_idx_leb {
  * @creat_sqnum: sequence number at time of creation
  * @del_cmtno: commit number corresponding to the time the inode was 
deleted,
  *             protected by @c->commit_sem;
+ * @parent_ino: the inode's parent inode number(for nfs exportfs)
  * @xattr_size: summarized size of all extended attributes in bytes
  * @xattr_cnt: count of extended attributes this inode has
  * @xattr_names: sum of lengths of all extended attribute names belonging 
to
@@ -394,6 +395,7 @@ struct ubifs_inode {
        struct inode vfs_inode;
        unsigned long long creat_sqnum;
        unsigned long long del_cmtno;
+       unsigned long parent_ino;
        unsigned int xattr_size;
        unsigned int xattr_cnt;
        unsigned int xattr_names;
-- 
1.7.1
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
