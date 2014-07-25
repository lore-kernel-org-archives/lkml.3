Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935373AbaGYRlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935162AbaGYRhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:37:40 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 2/2] gfs2: GFS2's implementation of the dir_readahead file operation
Date: Fri, 25 Jul 2014 12:37:31 -0500
Message-Id: <1406309851-10628-3-git-send-email-adas@redhat.com>
In-Reply-To: <1406309851-10628-1-git-send-email-adas@redhat.com>
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to GFS2 for the dirreadahead system call.

There's a hard limit (128K) on the number of inodes that can be
readahead at one time. There's also a memory cap on the number of
inode numbers we collect. We readahead whatever number of inodes
we have collected until the first of these two caps is hit.

Readahead is done in two stages. In the intial stage, the
directory is read through and all the inode numbers of its entries
are collected. In the second stage, readaheads are performed
asynchronously using workqueues, so the syscall can return to the
user at this stage.
Subsequent getdents calls on the directory and stat calls on the
inodes will have the time-consuming lookups already done for them
and will therefore be quick.

Signed-off-by: Abhi Das <adas@redhat.com>
---
 fs/gfs2/Makefile        |   3 +-
 fs/gfs2/dir.c           |  49 +++++++++---
 fs/gfs2/dir.h           |  15 ++++
 fs/gfs2/dir_readahead.c | 209 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/gfs2/file.c          |   2 +
 fs/gfs2/main.c          |  10 ++-
 fs/gfs2/super.c         |   1 +
 7 files changed, 274 insertions(+), 15 deletions(-)
 create mode 100644 fs/gfs2/dir_readahead.c

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 8612820..2765c83 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -4,7 +4,8 @@ gfs2-y := acl.o bmap.o dir.o xattr.o glock.o \
 	glops.o log.o lops.o main.o meta_io.o \
 	aops.o dentry.o export.o file.o \
 	ops_fstype.o inode.o quota.o \
-	recovery.o rgrp.o super.o sys.o trans.o util.o
+	recovery.o rgrp.o super.o sys.o trans.o \
+	dir_readahead.o util.o
 
 gfs2-$(CONFIG_GFS2_FS_LOCKING_DLM) += lock_dlm.o
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1a349f9..f068763 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1217,6 +1217,20 @@ static int compare_dents(const void *a, const void *b)
 	return ret;
 }
 
+static int gfs2_dirent_dot_or_dotdot(const struct gfs2_dirent *dent)
+{
+	const char *name = (char *)(dent + 1);
+
+	if (be16_to_cpu(dent->de_type) == DT_DIR) {
+		if (be16_to_cpu(dent->de_name_len) == 1 && name[0] == '.')
+			return 1;
+		if (be16_to_cpu(dent->de_name_len) == 2 &&
+		    strncmp(name, "..", 2) == 0)
+			return 1;
+	}
+	return 0;   
+}
+
 /**
  * do_filldir_main - read out directory entries
  * @dip: The GFS2 inode
@@ -1262,8 +1276,12 @@ static int do_filldir_main(struct gfs2_inode *dip, struct dir_context *ctx,
 			ctx->pos = off;
 
 			if (off_next == off) {
-				if (*copied && !run)
+				if (*copied && !run) {
+					struct gfs2_dir_ra *d_ra = ctx->opaque;
+					if (d_ra)
+						set_bit(RA_FL_HASHCOLL, &d_ra->flags);
 					return 1;
+				}
 				run = 1;
 			} else
 				run = 0;
@@ -1273,11 +1291,18 @@ static int do_filldir_main(struct gfs2_inode *dip, struct dir_context *ctx,
 			ctx->pos = off;
 		}
 
-		if (!dir_emit(ctx, (const char *)(dent + 1),
-				be16_to_cpu(dent->de_name_len),
-				be64_to_cpu(dent->de_inum.no_addr),
-				be16_to_cpu(dent->de_type)))
-			return 1;
+		if (ctx->actor) {
+			if (!dir_emit(ctx, (const char *)(dent + 1),
+				      be16_to_cpu(dent->de_name_len),
+				      be64_to_cpu(dent->de_inum.no_addr),
+				      be16_to_cpu(dent->de_type)))
+				return 1;
+		} else { /* we were called by dir_readahead */
+			if (gfs2_dirent_dot_or_dotdot(dent))
+				continue;
+			if (collect_inode_blocks(ctx, be64_to_cpu(dent->de_inum.no_addr)))
+				return 1;
+		}
 
 		*copied = 1;
 	}
@@ -1311,8 +1336,7 @@ static void gfs2_free_sort_buffer(void *ptr)
 }
 
 static int gfs2_dir_read_leaf(struct inode *inode, struct dir_context *ctx,
-			      int *copied, unsigned *depth,
-			      u64 leaf_no)
+			      int *copied, unsigned *depth, u64 leaf_no)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1399,14 +1423,14 @@ out:
 }
 
 /**
- * gfs2_dir_readahead - Issue read-ahead requests for leaf blocks.
+ * gfs2_dir_leaf_ra - Issue read-ahead requests for leaf blocks.
  *
  * Note: we can't calculate each index like dir_e_read can because we don't
  * have the leaf, and therefore we don't have the depth, and therefore we
  * don't have the length. So we have to just read enough ahead to make up
  * for the loss of information.
  */
-static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
+static void gfs2_dir_leaf_ra(struct inode *inode, unsigned hsize, u32 index,
 			       struct file_ra_state *f_ra)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -1474,11 +1498,10 @@ static int dir_e_read(struct inode *inode, struct dir_context *ctx,
 	if (IS_ERR(lp))
 		return PTR_ERR(lp);
 
-	gfs2_dir_readahead(inode, hsize, index, f_ra);
+	gfs2_dir_leaf_ra(inode, hsize, index, f_ra);
 
 	while (index < hsize) {
-		error = gfs2_dir_read_leaf(inode, ctx,
-					   &copied, &depth,
+		error = gfs2_dir_read_leaf(inode, ctx, &copied, &depth,
 					   be64_to_cpu(lp[index]));
 		if (error)
 			break;
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 126c65d..429eea9 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -25,6 +25,21 @@ struct gfs2_diradd {
 	struct buffer_head *bh;
 };
 
+extern struct workqueue_struct *gfs2_dir_ra_wq;
+#define RA_MAX_INOS     131072 /*128K */
+#define RA_FL_HASHCOLL  1
+
+struct gfs2_dir_ra {
+	u64          *inos;
+	size_t        size;
+	size_t        count;
+	unsigned int  req;
+	unsigned long flags;
+};
+
+extern int gfs2_dir_readahead(struct file *file, struct dir_context *ctx,
+				      unsigned int count);
+extern int collect_inode_blocks(struct dir_context *ctx, u64 offset);
 extern struct inode *gfs2_dir_search(struct inode *dir,
 				     const struct qstr *filename,
 				     bool fail_on_exist);
diff --git a/fs/gfs2/dir_readahead.c b/fs/gfs2/dir_readahead.c
new file mode 100644
index 0000000..98888ad
--- /dev/null
+++ b/fs/gfs2/dir_readahead.c
@@ -0,0 +1,209 @@
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/buffer_head.h>
+#include <linux/pagemap.h>
+#include <linux/uio.h>
+#include <linux/blkdev.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/sort.h>
+#include <linux/fs.h>
+#include <linux/gfs2_ondisk.h>
+#include <linux/falloc.h>
+#include <linux/swap.h>
+#include <linux/crc32.h>
+#include <linux/writeback.h>
+#include <asm/uaccess.h>
+#include <linux/dlm.h>
+#include <linux/dlm_plock.h>
+
+#include "gfs2.h"
+#include "incore.h"
+#include "bmap.h"
+#include "dir.h"
+#include "glock.h"
+#include "glops.h"
+#include "inode.h"
+#include "log.h"
+#include "meta_io.h"
+#include "quota.h"
+#include "rgrp.h"
+#include "trans.h"
+#include "util.h"
+
+struct workqueue_struct *gfs2_dir_ra_wq;
+
+static int compare_inos(const void *a, const void *b)
+{
+	u64 ino_a, ino_b;
+
+	ino_a = *(u64 *)a;
+	ino_b = *(u64 *)b;
+
+	if (ino_a > ino_b)
+		return 1;
+	return -1;
+}
+
+static int collect_more(struct gfs2_dir_ra *d_ra)
+{
+	return (d_ra->count < d_ra->req &&
+		(d_ra->count * sizeof(u64)) < d_ra->size);
+}
+
+int collect_inode_blocks(struct dir_context *ctx, u64 ino)
+{
+	struct gfs2_dir_ra *d_ra = (struct gfs2_dir_ra *) ctx->opaque;
+
+	if (!collect_more(d_ra))
+		return 1; /* Collected requested blocks */
+
+	d_ra->inos[d_ra->count++] = ino;
+	return 0;
+}
+
+struct dir_ra_work {
+	struct work_struct work;
+	u64 ino;
+	struct gfs2_sbd *sdp;
+};
+
+static void dir_ra_work_func(struct work_struct *work)
+{
+	struct dir_ra_work *w = container_of(work, struct dir_ra_work, work);
+
+	/* XXX: What to do if sdp disappears by the time we get here? */
+	struct inode *inode = gfs2_lookup_by_inum(w->sdp, w->ino, NULL,
+						  GFS2_BLKST_DINODE);
+	if (IS_ERR(inode)) {
+		fs_err(w->sdp, "can't read in inode at addr:%llu: %ld\n",
+		       w->ino, PTR_ERR(inode));
+	}
+	gfs2_inode_refresh(GFS2_I(inode));
+	iput(inode);
+	kfree(work);
+}
+
+int gfs2_queue_dir_ra(struct dir_context *ctx, struct gfs2_sbd *sdp)
+{
+	int i;
+	struct gfs2_dir_ra *d_ra = (struct gfs2_dir_ra *) ctx->opaque;
+
+	sort(d_ra->inos, d_ra->count, sizeof(u64), compare_inos, NULL);
+
+	for (i=0; i<d_ra->count; i++) {
+		struct dir_ra_work *w;
+
+		w = kmalloc(sizeof(struct dir_ra_work), GFP_NOFS | __GFP_NOWARN);
+		if (!w)
+			break;
+
+		w->ino = d_ra->inos[i];
+		w->sdp = sdp;
+		INIT_WORK(&w->work, dir_ra_work_func);
+		queue_work(gfs2_dir_ra_wq, &w->work);
+	}
+	if (!i)
+		return -ENOMEM;
+	if (i != d_ra->count)
+		ctx->pos = 0; /* Don't know the resume offset for a short RA */
+	return i;
+}
+
+static inline unsigned int compute_ra_bufsize(unsigned int count)
+{
+	unsigned int size = count * (sizeof(u64));
+
+	if (size > KMALLOC_MAX_SIZE)
+		return KMALLOC_MAX_SIZE;
+	if (size < KMALLOC_MIN_SIZE)
+		return KMALLOC_MIN_SIZE;
+
+	return size;
+}
+
+static int init_ra_context(struct gfs2_inode *ip, struct dir_context *ctx,
+			   unsigned int count)
+{
+	unsigned int bufsize;
+	struct gfs2_dir_ra *d_ra = (struct gfs2_dir_ra *) ctx->opaque;
+
+	memset(d_ra, 0, sizeof(struct gfs2_dir_ra));
+	count = count > RA_MAX_INOS ? RA_MAX_INOS : count;
+	count = count > ip->i_entries ? ip->i_entries : count;
+
+	bufsize = compute_ra_bufsize(count);
+	d_ra->inos = kmalloc(bufsize, GFP_NOFS | __GFP_NOWARN);
+	if (!d_ra->inos)
+		return -ENOMEM;
+
+	d_ra->size = bufsize;
+	d_ra->req = count;
+
+	return 0;
+}
+
+static void uninit_ra_context(struct dir_context *ctx)
+{
+	struct gfs2_dir_ra *d_ra;
+
+	if (!ctx || !ctx->opaque)
+		return;
+	d_ra = (struct gfs2_dir_ra *) ctx->opaque;
+	if (d_ra->inos)
+		kfree(d_ra->inos);
+	memset(d_ra, 0, sizeof(struct gfs2_dir_ra));
+}
+/**
+ * gfs2_dir_readahead - GFS2's implementation of readdir readahead
+ * @file  : The directory to be read from
+ * @ctx   : Context contains buffer to collect inode numbers
+ *
+ * Readahead inode disk blocks (and extended attribute blocks if requested)
+ * of every directory entry
+ *
+ * Returns: +ve number: The number of entries for which readahead calls
+ *                      were issued
+ *          -ve values: For error conditions
+ */
+int gfs2_dir_readahead(struct file *file, struct dir_context *ctx, unsigned int count)
+{
+	int error = -EINVAL;
+	struct inode *dir = file->f_mapping->host;
+	struct gfs2_inode *dip = GFS2_I(dir);
+	struct gfs2_holder d_gh;
+	struct gfs2_dir_ra d_ra;
+
+	if (!ctx)
+		goto out;
+
+	ctx->opaque = &d_ra;
+	error = init_ra_context(dip, ctx, count);
+	if (error)
+		goto out;
+
+	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
+	error = gfs2_glock_nq(&d_gh);
+	if (error) {
+		gfs2_holder_uninit(&d_gh);
+		goto uninit;
+	}
+
+retry:
+	error = gfs2_dir_read(dir, ctx, &file->f_ra);
+	if (test_bit(RA_FL_HASHCOLL, &d_ra.flags)) {
+		clear_bit(RA_FL_HASHCOLL, &d_ra.flags);
+		goto retry;
+	}
+
+	/* Pass the collected inos to the workqueues to be read ahead */ 
+	if (d_ra.count)
+		error = gfs2_queue_dir_ra(ctx, GFS2_SB(dir));
+
+	gfs2_glock_dq_uninit(&d_gh);
+uninit:
+	uninit_ra_context(ctx);
+out:
+	return error;
+}
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 26b3f95..6135bb9 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1075,6 +1075,7 @@ const struct file_operations gfs2_file_fops = {
 
 const struct file_operations gfs2_dir_fops = {
 	.iterate	= gfs2_readdir,
+	.dir_readahead  = gfs2_dir_readahead,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
@@ -1105,6 +1106,7 @@ const struct file_operations gfs2_file_fops_nolock = {
 
 const struct file_operations gfs2_dir_fops_nolock = {
 	.iterate	= gfs2_readdir,
+	.dir_readahead  = gfs2_dir_readahead,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 82b6ac8..71e8ce5 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -161,9 +161,14 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_control_wq)
 		goto fail_recovery;
 
+	gfs2_dir_ra_wq = alloc_workqueue("gfs2_dir_ra",
+					 WQ_MEM_RECLAIM | WQ_FREEZABLE, 0);
+	if (!gfs2_dir_ra_wq)
+		goto fail_control;
+
 	gfs2_page_pool = mempool_create_page_pool(64, 0);
 	if (!gfs2_page_pool)
-		goto fail_control;
+		goto fail_ra;
 
 	gfs2_register_debugfs();
 
@@ -171,6 +176,8 @@ static int __init init_gfs2_fs(void)
 
 	return 0;
 
+fail_ra:
+	destroy_workqueue(gfs2_dir_ra_wq);
 fail_control:
 	destroy_workqueue(gfs2_control_wq);
 fail_recovery:
@@ -224,6 +231,7 @@ static void __exit exit_gfs2_fs(void)
 	unregister_filesystem(&gfs2meta_fs_type);
 	destroy_workqueue(gfs_recovery_wq);
 	destroy_workqueue(gfs2_control_wq);
+	destroy_workqueue(gfs2_dir_ra_wq);
 	list_lru_destroy(&gfs2_qd_lru);
 
 	rcu_barrier();
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 669e92e..8654636 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -849,6 +849,7 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	kthread_stop(sdp->sd_quotad_process);
 	kthread_stop(sdp->sd_logd_process);
 
+	flush_workqueue(gfs2_dir_ra_wq);
 	flush_workqueue(gfs2_delete_workqueue);
 	gfs2_quota_sync(sdp->sd_vfs, 0);
 	gfs2_statfs_sync(sdp->sd_vfs, 0);
-- 
1.8.1.4

