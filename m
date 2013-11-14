Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3KNQwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:52:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65264 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab3KNQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:26 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        James Nunez <james.a.nunez@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 31/39] staging/lustre/build: fix 'NULL pointer dereference' errors
Date: Fri, 15 Nov 2013 00:32:54 +0800
Message-Id: <1384446782-13741-32-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'NULL pointer dereference' defects found by Coverity version
6.5.0:
Dereference after null check (FORWARD_NULL)
For instance, Passing null pointer to a function which dereferences
it.
Dereference before null check (REVERSE_INULL)
Null-checking variable suggests that it may be null, but it has
already been dereferenced on all paths leading to the check.
Dereference null return value (NULL_RETURNS)

Lustre-change: http://review.whamcloud.com/5868
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3042
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Signed-off-by: James Nunez <james.a.nunez@intel.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lustre_update.h  |    3 ++-
 drivers/staging/lustre/lustre/llite/dir.c          |   17 ++++++++++++-----
 drivers/staging/lustre/lustre/lov/lov_io.c         |    3 ++-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_update.h b/drivers/staging/lustre/lustre/include/lustre_update.h
index 84defce..3f424af 100644
--- a/drivers/staging/lustre/lustre/include/lustre_update.h
+++ b/drivers/staging/lustre/lustre/include/lustre_update.h
@@ -165,12 +165,13 @@ static inline int update_get_reply_buf(struct update_reply *reply, void **buf,
 	int  result;
 
 	ptr = update_get_buf_internal(reply, index, &size);
+	LASSERT(ptr != NULL);
 	result = *(int *)ptr;
 
 	if (result < 0)
 		return result;
 
-	LASSERT((ptr != NULL && size >= sizeof(int)));
+	LASSERT(size >= sizeof(int));
 	*buf = ptr + sizeof(int);
 	return size - sizeof(int);
 }
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index f52c624..1856701 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -597,23 +597,30 @@ static int ll_readdir(struct file *filp, struct dir_context *ctx)
 	struct inode		*inode	= filp->f_dentry->d_inode;
 	struct ll_file_data	*lfd	= LUSTRE_FPRIVATE(filp);
 	struct ll_sb_info	*sbi	= ll_i2sbi(inode);
+	__u64			pos;
 	int			hash64	= sbi->ll_flags & LL_SBI_64BIT_HASH;
 	int			api32	= ll_need_32bit_api(sbi);
 	int			rc;
 
-	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p) pos %lu/%llu "
+	if (lfd != NULL)
+		pos = lfd->lfd_pos;
+	else
+		pos = 0;
+
+	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p) pos %llu/%llu "
 	       " 32bit_api %d\n", inode->i_ino, inode->i_generation,
-	       inode, (unsigned long)lfd->lfd_pos, i_size_read(inode), api32);
+	       inode, pos, i_size_read(inode), api32);
 
-	if (lfd->lfd_pos == MDS_DIR_END_OFF)
+	if (pos == MDS_DIR_END_OFF)
 		/*
 		 * end-of-file.
 		 */
 		GOTO(out, rc = 0);
 
-	ctx->pos = lfd->lfd_pos;
+	ctx->pos = pos;
 	rc = ll_dir_read(inode, ctx);
-	lfd->lfd_pos = ctx->pos;
+	if (lfd != NULL)
+		lfd->lfd_pos = ctx->pos;
 	if (ctx->pos == MDS_DIR_END_OFF) {
 		if (api32)
 			ctx->pos = LL_DIR_END_OFF_32BIT;
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index 5a6ab70..cdd69232 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -272,10 +272,11 @@ struct lov_io_sub *lov_page_subio(const struct lu_env *env, struct lov_io *lio,
 static int lov_io_subio_init(const struct lu_env *env, struct lov_io *lio,
 			     struct cl_io *io)
 {
-	struct lov_stripe_md *lsm = lio->lis_object->lo_lsm;
+	struct lov_stripe_md *lsm;
 	int result;
 
 	LASSERT(lio->lis_object != NULL);
+	lsm = lio->lis_object->lo_lsm;
 
 	/*
 	 * Need to be optimized, we can't afford to allocate a piece of memory
-- 
1.7.9.5

