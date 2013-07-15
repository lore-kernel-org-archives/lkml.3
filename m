Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3GOO2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:28:41 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57380 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3GOO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:38 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 16/17] staging/lustre/llite: readdir convert to iterate
Date: Mon, 15 Jul 2013 22:27:19 +0800
Message-Id: <1373898440-14208-17-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dir.c          |   45 +++++++++-----------
 .../staging/lustre/lustre/llite/llite_internal.h   |    4 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   13 +++---
 3 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index e2afb97..1084999 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -483,12 +483,11 @@ fail:
 	goto out_unlock;
 }
 
-int ll_dir_read(struct inode *inode, __u64 *_pos, void *cookie,
-		filldir_t filldir)
+int ll_dir_read(struct inode *inode, struct dir_context *ctx)
 {
 	struct ll_inode_info *info       = ll_i2info(inode);
 	struct ll_sb_info    *sbi	= ll_i2sbi(inode);
-	__u64		 pos	= *_pos;
+	__u64		   pos		= ctx->pos;
 	int		   api32      = ll_need_32bit_api(sbi);
 	int		   hash64     = sbi->ll_flags & LL_SBI_64BIT_HASH;
 	struct page	  *page;
@@ -548,12 +547,14 @@ int ll_dir_read(struct inode *inode, __u64 *_pos, void *cookie,
 				fid_le_to_cpu(&fid, &ent->lde_fid);
 				ino = cl_fid_build_ino(&fid, api32);
 				type = ll_dirent_type_get(ent);
+				ctx->pos = lhash;
 				/* For 'll_nfs_get_name_filldir()', it will try
 				 * to access the 'ent' through its 'lde_name',
-				 * so the parameter 'name' for 'filldir()' must
-				 * be part of the 'ent'. */
-				done = filldir(cookie, ent->lde_name, namelen,
-					       lhash, ino, type);
+				 * so the parameter 'name' for 'ctx->actor()'
+				 * must be part of the 'ent'.
+				 */
+				done = !dir_emit(ctx, ent->lde_name,
+						 namelen, ino, type);
 			}
 			next = le64_to_cpu(dp->ldp_hash_end);
 			if (!done) {
@@ -594,50 +595,44 @@ int ll_dir_read(struct inode *inode, __u64 *_pos, void *cookie,
 		}
 	}
 
-	*_pos = pos;
+	ctx->pos = pos;
 	ll_dir_chain_fini(&chain);
 	RETURN(rc);
 }
 
-static int ll_readdir(struct file *filp, void *cookie, filldir_t filldir)
+static int ll_readdir(struct file *filp, struct dir_context *ctx)
 {
 	struct inode		*inode	= filp->f_dentry->d_inode;
 	struct ll_file_data	*lfd	= LUSTRE_FPRIVATE(filp);
 	struct ll_sb_info	*sbi	= ll_i2sbi(inode);
-	__u64			pos	= lfd->lfd_pos;
 	int			hash64	= sbi->ll_flags & LL_SBI_64BIT_HASH;
 	int			api32	= ll_need_32bit_api(sbi);
 	int			rc;
-	struct path		path;
 	ENTRY;
 
 	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p) pos %lu/%llu "
 	       " 32bit_api %d\n", inode->i_ino, inode->i_generation,
-	       inode, (unsigned long)pos, i_size_read(inode), api32);
+	       inode, (unsigned long)lfd->lfd_pos, i_size_read(inode), api32);
 
-	if (pos == MDS_DIR_END_OFF)
+	if (lfd->lfd_pos == MDS_DIR_END_OFF)
 		/*
 		 * end-of-file.
 		 */
 		GOTO(out, rc = 0);
 
-	rc = ll_dir_read(inode, &pos, cookie, filldir);
-	lfd->lfd_pos = pos;
-	if (pos == MDS_DIR_END_OFF) {
+	ctx->pos = lfd->lfd_pos;
+	rc = ll_dir_read(inode, ctx);
+	lfd->lfd_pos = ctx->pos;
+	if (ctx->pos == MDS_DIR_END_OFF) {
 		if (api32)
-			filp->f_pos = LL_DIR_END_OFF_32BIT;
+			ctx->pos = LL_DIR_END_OFF_32BIT;
 		else
-			filp->f_pos = LL_DIR_END_OFF;
+			ctx->pos = LL_DIR_END_OFF;
 	} else {
 		if (api32 && hash64)
-			filp->f_pos = pos >> 32;
-		else
-			filp->f_pos = pos;
+			ctx->pos >>= 32;
 	}
 	filp->f_version = inode->i_version;
-	path.mnt = filp->f_path.mnt;
-	path.dentry = filp->f_dentry;
-	touch_atime(&path);
 
 out:
 	if (!rc)
@@ -1976,7 +1971,7 @@ struct file_operations ll_dir_operations = {
 	.open     = ll_dir_open,
 	.release  = ll_dir_release,
 	.read     = generic_read_dir,
-	.readdir  = ll_readdir,
+	.iterate  = ll_readdir,
 	.unlocked_ioctl   = ll_dir_ioctl,
 	.fsync    = ll_fsync,
 };
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index cbcd118..0534665 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -90,6 +90,7 @@ extern struct file_operations ll_pgcache_seq_fops;
 #define REMOTE_PERM_HASHSIZE 16
 
 struct ll_getname_data {
+	struct dir_context ctx;
 	char	    *lgd_name;      /* points to a buffer with NAME_MAX+1 size */
 	struct lu_fid    lgd_fid;       /* target fid we are looking for */
 	int	      lgd_found;     /* inode matched? */
@@ -679,8 +680,7 @@ extern struct file_operations ll_dir_operations;
 extern struct inode_operations ll_dir_inode_operations;
 struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
 			     struct ll_dir_chain *chain);
-int ll_dir_read(struct inode *inode, __u64 *_pos, void *cookie,
-		filldir_t filldir);
+int ll_dir_read(struct inode *inode, struct dir_context *ctx);
 
 int ll_get_mdt_idx(struct inode *inode);
 /* llite/namei.c */
diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index 28cc41e..f142a1e 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -214,9 +214,12 @@ static int ll_get_name(struct dentry *dentry, char *name,
 		       struct dentry *child)
 {
 	struct inode *dir = dentry->d_inode;
-	struct ll_getname_data lgd;
-	__u64 offset = 0;
 	int rc;
+	struct ll_getname_data lgd = {
+		.lgd_name = name,
+		.lgd_fid = ll_i2info(child->d_inode)->lli_fid,
+		.ctx.actor = ll_nfs_get_name_filldir,
+	};
 	ENTRY;
 
 	if (!dir || !S_ISDIR(dir->i_mode))
@@ -225,12 +228,8 @@ static int ll_get_name(struct dentry *dentry, char *name,
 	if (!dir->i_fop)
 		GOTO(out, rc = -EINVAL);
 
-	lgd.lgd_name = name;
-	lgd.lgd_fid = ll_i2info(child->d_inode)->lli_fid;
-	lgd.lgd_found = 0;
-
 	mutex_lock(&dir->i_mutex);
-	rc = ll_dir_read(dir, &offset, &lgd, ll_nfs_get_name_filldir);
+	rc = ll_dir_read(dir, &lgd.ctx);
 	mutex_unlock(&dir->i_mutex);
 	if (!rc && !lgd.lgd_found)
 		rc = -ENOENT;
-- 
1.7.9.5

