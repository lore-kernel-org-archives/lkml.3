Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbaGYRiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935317AbaGYRiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:38:15 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 5/5] gfs2: Add xreaddir file operation and supporting functions
Date: Fri, 25 Jul 2014 12:38:08 -0500
Message-Id: <1406309888-10749-6-git-send-email-adas@redhat.com>
In-Reply-To: <1406309888-10749-1-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support in GFS2 for the xgetdents syscall by
implementing the xreaddir file operation.

GFS2 uses vbufs (buffer backed by a vector of pages) to store
intermediate data like dirents, stat info and extended attribute
keys/values to eventually bundle them into a container structure
to return to the user.

Signed-off-by: Abhi Das <adas@redhat.com>
---
 fs/gfs2/Makefile     |    3 +-
 fs/gfs2/dir.c        |   80 ++--
 fs/gfs2/dir.h        |   13 +-
 fs/gfs2/export.c     |    2 +-
 fs/gfs2/file.c       |   17 +-
 fs/gfs2/incore.h     |    6 +
 fs/gfs2/inode.c      |    3 +-
 fs/gfs2/inode.h      |    5 +
 fs/gfs2/ops_fstype.c |    4 +
 fs/gfs2/sys.c        |   26 +-
 fs/gfs2/util.c       |    9 +
 fs/gfs2/xattr.c      |   27 +-
 fs/gfs2/xattr.h      |   23 ++
 fs/gfs2/xreaddir.c   | 1024 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/gfs2/xreaddir.h   |   84 +++++
 15 files changed, 1260 insertions(+), 66 deletions(-)
 create mode 100644 fs/gfs2/xreaddir.c
 create mode 100644 fs/gfs2/xreaddir.h

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 8612820..da8253b 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -4,7 +4,8 @@ gfs2-y := acl.o bmap.o dir.o xattr.o glock.o \
 	glops.o log.o lops.o main.o meta_io.o \
 	aops.o dentry.o export.o file.o \
 	ops_fstype.o inode.o quota.o \
-	recovery.o rgrp.o super.o sys.o trans.o util.o
+	recovery.o rgrp.o super.o sys.o \
+	trans.o util.o xreaddir.o
 
 gfs2-$(CONFIG_GFS2_FS_LOCKING_DLM) += lock_dlm.o
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1a349f9..21f5926 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -74,15 +74,13 @@
 #include "trans.h"
 #include "bmap.h"
 #include "util.h"
+#include "xreaddir.h"
 
 #define IS_LEAF     1 /* Hashed (leaf) directory */
 #define IS_DINODE   2 /* Linear (stuffed dinode block) directory */
 
 #define MAX_RA_BLOCKS 32 /* max read-ahead blocks */
 
-#define gfs2_disk_hash2offset(h) (((u64)(h)) >> 1)
-#define gfs2_dir_offset2hash(p) ((u32)(((u64)(p)) << 1))
-
 struct qstr gfs2_qdot __read_mostly;
 struct qstr gfs2_qdotdot __read_mostly;
 
@@ -1185,17 +1183,13 @@ out_kfree:
  *   lt: returns -1
  *   eq: returns 0
  */
-
-static int compare_dents(const void *a, const void *b)
+int compare_dents_i(const struct gfs2_dirent *dent_a,
+		  const struct gfs2_dirent *dent_b)
 {
-	const struct gfs2_dirent *dent_a, *dent_b;
 	u32 hash_a, hash_b;
 	int ret = 0;
 
-	dent_a = *(const struct gfs2_dirent **)a;
 	hash_a = be32_to_cpu(dent_a->de_hash);
-
-	dent_b = *(const struct gfs2_dirent **)b;
 	hash_b = be32_to_cpu(dent_b->de_hash);
 
 	if (hash_a > hash_b)
@@ -1217,6 +1211,12 @@ static int compare_dents(const void *a, const void *b)
 	return ret;
 }
 
+int compare_dents(const void *a, const void *b)
+{
+	return compare_dents_i(*(const struct gfs2_dirent **)a,
+			       *(const struct gfs2_dirent **)b);
+}
+
 /**
  * do_filldir_main - read out directory entries
  * @dip: The GFS2 inode
@@ -1234,13 +1234,14 @@ static int compare_dents(const void *a, const void *b)
  */
 
 static int do_filldir_main(struct gfs2_inode *dip, struct dir_context *ctx,
-			   const struct gfs2_dirent **darr, u32 entries,
-			   int *copied)
+			   struct gfs2_xrdir_ctx *xc, const struct gfs2_dirent **darr,
+			   u32 entries, int *copied)
 {
 	const struct gfs2_dirent *dent, *dent_next;
 	u64 off, off_next;
+	u64 *dst_pos = xc ? &xc->xc_offset : &ctx->pos;
 	unsigned int x, y;
-	int run = 0;
+	int run = 0, error = 0;
 
 	sort(darr, entries, sizeof(struct gfs2_dirent *), compare_dents, NULL);
 
@@ -1256,29 +1257,39 @@ static int do_filldir_main(struct gfs2_inode *dip, struct dir_context *ctx,
 			dent_next = darr[y];
 			off_next = be32_to_cpu(dent_next->de_hash);
 			off_next = gfs2_disk_hash2offset(off_next);
-
-			if (off < ctx->pos)
+			if (off < *dst_pos)
 				continue;
-			ctx->pos = off;
+
+			*dst_pos = off;
 
 			if (off_next == off) {
-				if (*copied && !run)
+				if (*copied && !run) {
+					if (xc)
+						gfs2_xrdir_partial_collect(xc);
 					return 1;
+				}
 				run = 1;
 			} else
 				run = 0;
 		} else {
-			if (off < ctx->pos)
+			if (off < *dst_pos)
 				continue;
-			ctx->pos = off;
+			*dst_pos = off;
 		}
 
-		if (!dir_emit(ctx, (const char *)(dent + 1),
-				be16_to_cpu(dent->de_name_len),
-				be64_to_cpu(dent->de_inum.no_addr),
-				be16_to_cpu(dent->de_type)))
-			return 1;
-
+		if (xc) {
+			error = gfs2_xrdir_collect_dents(dent, off, xc);
+			if (error) {
+				gfs2_xrdir_partial_collect(xc);
+				return 1;
+			}
+		} else {
+			if (!dir_emit(ctx, (const char *)(dent + 1),
+				      be16_to_cpu(dent->de_name_len),
+				      be64_to_cpu(dent->de_inum.no_addr),
+				      be16_to_cpu(dent->de_type)))
+				return 1;
+		}
 		*copied = 1;
 	}
 
@@ -1286,8 +1297,7 @@ static int do_filldir_main(struct gfs2_inode *dip, struct dir_context *ctx,
 	   do_filldir fxn, we get the next entry instead of the last one in the
 	   current leaf */
 
-	ctx->pos++;
-
+	(*dst_pos)++;
 	return 0;
 }
 
@@ -1311,8 +1321,8 @@ static void gfs2_free_sort_buffer(void *ptr)
 }
 
 static int gfs2_dir_read_leaf(struct inode *inode, struct dir_context *ctx,
-			      int *copied, unsigned *depth,
-			      u64 leaf_no)
+			      struct gfs2_xrdir_ctx *xc, int *copied,
+			      unsigned *depth, u64 leaf_no)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1389,7 +1399,7 @@ static int gfs2_dir_read_leaf(struct inode *inode, struct dir_context *ctx,
 	} while(lfn);
 
 	BUG_ON(entries2 != entries);
-	error = do_filldir_main(ip, ctx, darr, entries, copied);
+	error = do_filldir_main(ip, ctx, xc, darr, entries, copied);
 out_free:
 	for(i = 0; i < leaf; i++)
 		brelse(larr[i]);
@@ -1454,7 +1464,7 @@ static void gfs2_dir_readahead(struct inode *inode, unsigned hsize, u32 index,
  */
 
 static int dir_e_read(struct inode *inode, struct dir_context *ctx,
-		      struct file_ra_state *f_ra)
+		      struct gfs2_xrdir_ctx *xc, struct file_ra_state *f_ra)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
 	u32 hsize, len = 0;
@@ -1465,7 +1475,7 @@ static int dir_e_read(struct inode *inode, struct dir_context *ctx,
 	unsigned depth = 0;
 
 	hsize = 1 << dip->i_depth;
-	hash = gfs2_dir_offset2hash(ctx->pos);
+	hash = gfs2_dir_offset2hash(xc ? xc->xc_offset : ctx->pos);
 	index = hash >> (32 - dip->i_depth);
 
 	if (dip->i_hash_cache == NULL)
@@ -1477,7 +1487,7 @@ static int dir_e_read(struct inode *inode, struct dir_context *ctx,
 	gfs2_dir_readahead(inode, hsize, index, f_ra);
 
 	while (index < hsize) {
-		error = gfs2_dir_read_leaf(inode, ctx,
+		error = gfs2_dir_read_leaf(inode, ctx, xc,
 					   &copied, &depth,
 					   be64_to_cpu(lp[index]));
 		if (error)
@@ -1493,7 +1503,7 @@ static int dir_e_read(struct inode *inode, struct dir_context *ctx,
 }
 
 int gfs2_dir_read(struct inode *inode, struct dir_context *ctx,
-		  struct file_ra_state *f_ra)
+		  struct gfs2_xrdir_ctx *xc, struct file_ra_state *f_ra)
 {
 	struct gfs2_inode *dip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1507,7 +1517,7 @@ int gfs2_dir_read(struct inode *inode, struct dir_context *ctx,
 		return 0;
 
 	if (dip->i_diskflags & GFS2_DIF_EXHASH)
-		return dir_e_read(inode, ctx, f_ra);
+		return dir_e_read(inode, ctx, xc, f_ra);
 
 	if (!gfs2_is_stuffed(dip)) {
 		gfs2_consist_inode(dip);
@@ -1539,7 +1549,7 @@ int gfs2_dir_read(struct inode *inode, struct dir_context *ctx,
 			error = -EIO;
 			goto out;
 		}
-		error = do_filldir_main(dip, ctx, darr,
+		error = do_filldir_main(dip, ctx, xc, darr,
 					dip->i_entries, &copied);
 out:
 		kfree(darr);
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 126c65d..8d40590 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -12,6 +12,10 @@
 
 #include <linux/dcache.h>
 #include <linux/crc32.h>
+#include "util.h"
+
+#define gfs2_disk_hash2offset(h) (((u64)(h)) >> 1)
+#define gfs2_dir_offset2hash(p) ((u32)(((u64)(p)) << 1))
 
 struct inode;
 struct gfs2_inode;
@@ -25,6 +29,13 @@ struct gfs2_diradd {
 	struct buffer_head *bh;
 };
 
+typedef int (*process_dent_t)(const struct gfs2_dirent *, loff_t, void *, filldir_t);
+extern int compare_dents_i(const struct gfs2_dirent *dent_a,
+			   const struct gfs2_dirent *dent_b);
+extern int foreach_dent(u64 *offset, void *opaque, filldir_t filldir,
+			const struct gfs2_dirent **darr, u32 entries,
+			int *copied, process_dent_t pd_fn);
+ 
 extern struct inode *gfs2_dir_search(struct inode *dir,
 				     const struct qstr *filename,
 				     bool fail_on_exist);
@@ -40,7 +51,7 @@ static inline void gfs2_dir_no_add(struct gfs2_diradd *da)
 }
 extern int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry);
 extern int gfs2_dir_read(struct inode *inode, struct dir_context *ctx,
-			 struct file_ra_state *f_ra);
+			 struct gfs2_xrdir_ctx *xc, struct file_ra_state *f_ra);
 extern int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 			  const struct gfs2_inode *nip, unsigned int new_type);
 
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 8b9b377..1f5085d 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -114,7 +114,7 @@ static int gfs2_get_name(struct dentry *parent, char *name,
 	if (error)
 		return error;
 
-	error = gfs2_dir_read(dir, &gnfd.ctx, &f_ra);
+	error = gfs2_dir_read(dir, &gnfd.ctx, NULL, &f_ra);
 
 	gfs2_glock_dq_uninit(&gh);
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 26b3f95..d2d7561f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -16,6 +16,8 @@
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 #include <linux/mount.h>
+#include <linux/stat.h>
+#include <linux/sort.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/falloc.h>
@@ -40,6 +42,7 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
+#include "xreaddir.h"
 
 /**
  * gfs2_llseek - seek to a location in a file
@@ -100,7 +103,7 @@ static int gfs2_readdir(struct file *file, struct dir_context *ctx)
 	if (error)
 		return error;
 
-	error = gfs2_dir_read(dir, ctx, &file->f_ra);
+	error = gfs2_dir_read(dir, ctx, NULL, &file->f_ra);
 
 	gfs2_glock_dq_uninit(&d_gh);
 
@@ -562,8 +565,13 @@ int gfs2_open_common(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	mutex_init(&fp->f_fl_mutex);
-
 	gfs2_assert_warn(GFS2_SB(inode), !file->private_data);
+
+	if (S_ISDIR(inode->i_mode)) {
+		ret = gfs2_xrdir_ctx_init(fp, GFS2_SB(inode));
+		if (ret)
+			return ret;
+	}
 	file->private_data = fp;
 	return 0;
 }
@@ -617,6 +625,9 @@ static int gfs2_release(struct inode *inode, struct file *file)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 
+	if (S_ISDIR(ip->i_inode.i_mode))
+		gfs2_xrdir_ctx_uninit((struct gfs2_file *)file->private_data);
+
 	kfree(file->private_data);
 	file->private_data = NULL;
 
@@ -1075,6 +1086,7 @@ const struct file_operations gfs2_file_fops = {
 
 const struct file_operations gfs2_dir_fops = {
 	.iterate	= gfs2_readdir,
+	.xreaddir       = gfs2_xreaddir,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
@@ -1105,6 +1117,7 @@ const struct file_operations gfs2_file_fops_nolock = {
 
 const struct file_operations gfs2_dir_fops_nolock = {
 	.iterate	= gfs2_readdir,
+	.xreaddir       = gfs2_xreaddir,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 67d310c..f86b6d3 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -414,6 +414,7 @@ static inline struct gfs2_sbd *GFS2_SB(const struct inode *inode)
 struct gfs2_file {
 	struct mutex f_fl_mutex;
 	struct gfs2_holder f_fl_gh;
+	struct gfs2_xrdir_ctx *f_xrctx;
 };
 
 struct gfs2_revoke_replay {
@@ -570,6 +571,8 @@ struct gfs2_tune {
 	unsigned int gt_complain_secs;
 	unsigned int gt_statfs_quantum;
 	unsigned int gt_statfs_slow;
+	unsigned int gt_max_vb_pages; /* Max pages to utilize for vector-page buffers */
+	unsigned int gt_max_xrdir_dents; /* Maximum dents to process per collect cycle (conserves memory) */
 };
 
 enum {
@@ -812,6 +815,9 @@ struct gfs2_sbd {
 	struct dentry *debugfs_dentry_glocks;
 	struct dentry *debugfs_dentry_glstats;
 	struct dentry *debugfs_dentry_sbstats;
+
+	/* Vector Pages accounting */
+	atomic_t sd_vb_page_count;
 };
 
 static inline void gfs2_glstats_inc(struct gfs2_glock *gl, int which)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e62e594..46c3602 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1833,7 +1833,8 @@ static int gfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		}
 	}
 
-	generic_fillattr(inode, stat);
+	gfs2_getattr_i(ip, stat);
+
 	if (unlock)
 		gfs2_glock_dq_uninit(&gh);
 	else if (frozen_root && atomic_dec_and_test(&sdp->sd_frozen_root))
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index ba4d949..665f508 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -93,6 +93,11 @@ err:
 	return -EIO;
 }
 
+static inline void gfs2_getattr_i(struct gfs2_inode *ip, struct kstat *stat)
+{
+	generic_fillattr(&ip->i_inode, stat);
+}
+
 extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
 				       u64 no_addr, u64 no_formal_ino,
 				       int non_block);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index bc564c0..2d541ba 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -60,6 +60,8 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_new_files_jdata = 0;
 	gt->gt_max_readahead = 1 << 18;
 	gt->gt_complain_secs = 10;
+	gt->gt_max_vb_pages = 65536;
+	gt->gt_max_xrdir_dents = 25000;
 }
 
 static struct gfs2_sbd *init_sbd(struct super_block *sb)
@@ -135,6 +137,8 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	atomic_set(&sdp->sd_frozen_root, 0);
 	init_waitqueue_head(&sdp->sd_frozen_root_wait);
 
+	atomic_set(&sdp->sd_vb_page_count, 0);
+
 	return sdp;
 }
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 3ab566b..279aa86 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -548,8 +548,8 @@ static ssize_t quota_scale_store(struct gfs2_sbd *sdp, const char *buf,
 	return len;
 }
 
-static ssize_t tune_set(struct gfs2_sbd *sdp, unsigned int *field,
-			int check_zero, const char *buf, size_t len)
+static ssize_t tune_set(struct gfs2_sbd *sdp, unsigned int *field, int check_zero,
+			unsigned int min, unsigned int max, const char *buf, size_t len)
 {
 	struct gfs2_tune *gt = &sdp->sd_tune;
 	unsigned int x;
@@ -562,6 +562,12 @@ static ssize_t tune_set(struct gfs2_sbd *sdp, unsigned int *field,
 	if (check_zero && !x)
 		return -EINVAL;
 
+	if (min && x < min)
+		return -EINVAL;
+
+	if (max && x > max)
+		return -EINVAL;
+
 	spin_lock(&gt->gt_spin);
 	*field = x;
 	spin_unlock(&gt->gt_spin);
@@ -578,13 +584,21 @@ static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                   \
 }                                                                             \
 TUNE_ATTR_3(name, name##_show, store)
 
-#define TUNE_ATTR(name, check_zero)                                           \
+#define TUNE_ATTR(name, check_zero)                                                \
+static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)     \
+{                                                                                  \
+	return tune_set(sdp, &sdp->sd_tune.gt_##name, check_zero, 0, 0, buf, len); \
+}                                                                                  \
+TUNE_ATTR_2(name, name##_store)
+
+#define TUNE_ATTR_B(name, min, max)                                           \
 static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)\
 {                                                                             \
-	return tune_set(sdp, &sdp->sd_tune.gt_##name, check_zero, buf, len);  \
+	return tune_set(sdp, &sdp->sd_tune.gt_##name, 0, min, max, buf, len); \
 }                                                                             \
 TUNE_ATTR_2(name, name##_store)
 
+
 TUNE_ATTR(quota_warn_period, 0);
 TUNE_ATTR(quota_quantum, 0);
 TUNE_ATTR(max_readahead, 0);
@@ -593,6 +607,8 @@ TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
+TUNE_ATTR_B(max_vb_pages, 32, 8388608); /* total capacity can be 128K to 32G bytes */
+TUNE_ATTR(max_xrdir_dents, 0);
 
 static struct attribute *tune_attrs[] = {
 	&tune_attr_quota_warn_period.attr,
@@ -603,6 +619,8 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_statfs_quantum.attr,
 	&tune_attr_quota_scale.attr,
 	&tune_attr_new_files_jdata.attr,
+	&tune_attr_max_vb_pages.attr,
+	&tune_attr_max_xrdir_dents.attr,
 	NULL,
 };
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 2c1aee3..793f69e 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -301,6 +301,9 @@ static int vp_extend(struct vp_ctx *vpx, int size)
 {
 	struct gfs2_sbd *sdp = vpx->vp_sdp;
 
+	if ((gfs2_tune_get(sdp, gt_max_vb_pages)
+	     - atomic_read(&sdp->sd_vb_page_count)) < size)
+		goto out;
 	/* first make room for more pointers */
 	if (size <= 0)
 		return -EINVAL;
@@ -317,6 +320,7 @@ static int vp_extend(struct vp_ctx *vpx, int size)
 		goto out;
 
 	vpx->vp_size += size;
+	atomic_add(size, &sdp->sd_vb_page_count);
 	return 0;
 out:
 	return -ENOMEM;
@@ -328,6 +332,9 @@ int vp_init(struct gfs2_sbd *sdp, struct vbuf *vb, int init_cap)
 	struct vp_ctx *vpx;
 
 	cap = DIV_ROUND_UP(init_cap, PAGE_SIZE);
+	if ((gfs2_tune_get(sdp, gt_max_vb_pages)
+	     - atomic_read(&sdp->sd_vb_page_count)) < cap)
+		goto out;
 
 	vpx = kmalloc(sizeof(struct vp_ctx), GFP_KERNEL);
 	if (vpx == NULL)
@@ -344,6 +351,7 @@ int vp_init(struct gfs2_sbd *sdp, struct vbuf *vb, int init_cap)
 
 	vpx->vp_baseptr = vpx->vp_top = page_address(vpx->vp_pages[0]);
 	vpx->vp_sdp = sdp;
+	atomic_add(cap, &sdp->sd_vb_page_count);
 	vb->v_ptr = vpx->vp_baseptr;
 	vb->v_opaque = vpx;
 
@@ -373,6 +381,7 @@ void vp_uninit(struct vbuf *vb)
 
 	vp_free_pages(vpx);
 	kfree(vpx->vp_pages);
+	atomic_sub(vpx->vp_size, &vpx->vp_sdp->sd_vb_page_count);
 	kfree(vpx);
 	vb->v_ptr = vb->v_opaque = NULL;
 }
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 0b81f78..f156b21 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
+#include <linux/sort.h>
 #include <linux/xattr.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/posix_acl_xattr.h>
@@ -19,6 +20,7 @@
 #include "gfs2.h"
 #include "incore.h"
 #include "acl.h"
+#include "dir.h"
 #include "xattr.h"
 #include "glock.h"
 #include "inode.h"
@@ -27,6 +29,7 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
+#include "xreaddir.h"
 
 /**
  * ea_calc_size - returns the acutal number of bytes the request will take up
@@ -72,10 +75,6 @@ static int ea_check_size(struct gfs2_sbd *sdp, unsigned int nsize, size_t dsize)
 	return 0;
 }
 
-typedef int (*ea_call_t) (struct gfs2_inode *ip, struct buffer_head *bh,
-			  struct gfs2_ea_header *ea,
-			  struct gfs2_ea_header *prev, void *private);
-
 static int ea_foreach_i(struct gfs2_inode *ip, struct buffer_head *bh,
 			ea_call_t ea_call, void *data)
 {
@@ -113,7 +112,7 @@ fail:
 	return -EIO;
 }
 
-static int ea_foreach(struct gfs2_inode *ip, ea_call_t ea_call, void *data)
+int ea_foreach(struct gfs2_inode *ip, ea_call_t ea_call, void *data)
 {
 	struct buffer_head *bh, *eabh;
 	__be64 *eablk, *end;
@@ -374,28 +373,14 @@ static int ea_list_i(struct gfs2_inode *ip, struct buffer_head *bh,
 		return 0;
 
 	if (er->er_data_len) {
-		char *prefix = NULL;
+		char prefix[9];
 		unsigned int l = 0;
 		char c = 0;
 
 		if (ei->ei_size + ea_size > er->er_data_len)
 			return -ERANGE;
 
-		switch (ea->ea_type) {
-		case GFS2_EATYPE_USR:
-			prefix = "user.";
-			l = 5;
-			break;
-		case GFS2_EATYPE_SYS:
-			prefix = "system.";
-			l = 7;
-			break;
-		case GFS2_EATYPE_SECURITY:
-			prefix = "security.";
-			l = 9;
-			break;
-		}
-
+		l = ea_prefix(ea, prefix, 9);
 		BUG_ON(l == 0);
 
 		memcpy(er->er_data + ei->ei_size, prefix, l);
diff --git a/fs/gfs2/xattr.h b/fs/gfs2/xattr.h
index d392f83..c09f090 100644
--- a/fs/gfs2/xattr.h
+++ b/fs/gfs2/xattr.h
@@ -10,6 +10,8 @@
 #ifndef __EATTR_DOT_H__
 #define __EATTR_DOT_H__
 
+#include "dir.h"
+
 struct gfs2_inode;
 struct iattr;
 
@@ -53,9 +55,30 @@ struct gfs2_ea_location {
 	struct gfs2_ea_header *el_prev;
 };
 
+static __inline__ int ea_prefix(struct gfs2_ea_header *ea, char *buf, int size)
+{
+	BUG_ON(size < 9);
+	switch (ea->ea_type) {
+	case GFS2_EATYPE_USR:
+		strncpy(buf, "user.", 5);
+		return 5;
+	case GFS2_EATYPE_SYS:
+		strncpy(buf, "system.", 7);
+		return 7;
+	case GFS2_EATYPE_SECURITY:
+		strncpy(buf, "security.", 9);
+		return 9;
+	}
+	return 0;
+}
+
 extern int __gfs2_xattr_set(struct inode *inode, const char *name,
 			    const void *value, size_t size,
 			    int flags, int type);
+typedef int (*ea_call_t) (struct gfs2_inode *ip, struct buffer_head *bh,
+			  struct gfs2_ea_header *ea,
+			  struct gfs2_ea_header *prev, void *private);
+extern int ea_foreach(struct gfs2_inode *ip, ea_call_t ea_call, void *data);
 extern ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size);
 extern int gfs2_ea_dealloc(struct gfs2_inode *ip);
 
diff --git a/fs/gfs2/xreaddir.c b/fs/gfs2/xreaddir.c
new file mode 100644
index 0000000..44e0232
--- /dev/null
+++ b/fs/gfs2/xreaddir.c
@@ -0,0 +1,1024 @@
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/buffer_head.h>
+#include <linux/pagemap.h>
+#include <linux/uio.h>
+#include <linux/blkdev.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/stat.h>
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
+#include "xattr.h"
+#include "xreaddir.h"
+
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
+/*
+ * Compare the inode blocks of two entries
+ */
+int ctx_compare_dent_iblks(void *opaque, const void *a, const void *b)
+{
+	struct gfs2_xrdir_ctx *xc = opaque;
+	const struct gfs2_xdirent *a_vb_p = *(struct gfs2_xdirent **)a;
+	const struct gfs2_xdirent *b_vb_p = *(struct gfs2_xdirent **)b;
+	u64 a_blkno, b_blkno;
+
+	vp_read(&xc->xc_dirents, &a_blkno, &a_vb_p->x_ino, sizeof(u64));
+	vp_read(&xc->xc_dirents, &b_blkno, &b_vb_p->x_ino, sizeof(u64));
+
+	if (a_blkno > b_blkno)
+		return 1;
+	else
+		return -1;
+}
+
+/*
+ * Compare the xattr blocks of two entries
+ */
+int ctx_compare_dent_eablks(void *opaque, const void *a, const void *b)
+{
+	struct gfs2_xrdir_ctx *xc = opaque;
+	const struct gfs2_xdirent *a_vb_p = *(struct gfs2_xdirent **)a;
+	const struct gfs2_xdirent *b_vb_p = *(struct gfs2_xdirent **)b;
+	u64 a_blkno, b_blkno;
+
+	vp_read(&xc->xc_dirents, &a_blkno, &a_vb_p->x_eablk, sizeof(u64));
+	vp_read(&xc->xc_dirents, &b_blkno, &b_vb_p->x_eablk, sizeof(u64));
+
+	if (a_blkno > b_blkno)
+		return 1;
+	else
+		return -1;
+}
+
+/*
+ * Compare two entries based on their hash value
+ */
+int ctx_compare_dents(void *opaque, const void *a, const void *b)
+{
+	struct gfs2_xrdir_ctx *xc = opaque;
+	const struct gfs2_xdirent *a_vb_p = *(struct gfs2_xdirent **)a;
+	const struct gfs2_xdirent *b_vb_p = *(struct gfs2_xdirent **)b;
+	u32 a_hash, b_hash;
+	int ret = 0;
+
+	vp_read(&xc->xc_dirents, &a_hash, &a_vb_p->x_hash, sizeof(u32));
+	vp_read(&xc->xc_dirents, &b_hash, &b_vb_p->x_hash, sizeof(u32));
+
+	if (a_hash > b_hash)
+		ret = 1;
+	else if (a_hash < b_hash)
+		ret = -1;
+	else {
+		unsigned int len_a, len_b;
+		vp_read(&xc->xc_dirents, &len_a, &a_vb_p->x_namelen, sizeof(unsigned int));
+		vp_read(&xc->xc_dirents, &len_b, &b_vb_p->x_namelen, sizeof(unsigned int));
+
+		if (len_a > len_b)
+			ret = 1;
+		else if (len_a < len_b)
+			ret = -1;
+		else {
+			char *a, *b, *buf;
+			buf = kmalloc(len_a * 2, GFP_KERNEL);
+			if (buf == NULL) {
+				ret = 0;
+				goto out;
+			}
+			a = buf;
+			b = buf + len_a;
+
+			vp_read(&xc->xc_dirents, a, a_vb_p->x_name, len_a);
+			vp_read(&xc->xc_dirents, b, b_vb_p->x_name, len_b);
+
+			ret = memcmp(a, b, len_a);
+
+			kfree(buf);
+		}
+	}
+out:
+	return ret;
+}
+
+void gfs2_xrdir_ctx_uninit(struct gfs2_file *fp)
+{
+	struct gfs2_xrdir_ctx *xc;
+
+	if (!fp || !fp->f_xrctx)
+		return;
+
+	xc = fp->f_xrctx;
+	if (xc->xc_vb_dptrs)
+		kfree(xc->xc_vb_dptrs);
+	vp_uninit(&xc->xc_xattr_values);
+	vp_uninit(&xc->xc_xattr_keys);
+	vp_uninit(&xc->xc_dirents);
+	kfree(xc);
+	fp->f_xrctx = NULL;
+}
+
+int gfs2_xrdir_ctx_init(struct gfs2_file *fp, struct gfs2_sbd *sdp)
+{
+	struct gfs2_xrdir_ctx *xc;
+	if (!fp)
+		return -EINVAL;
+
+	BUG_ON(fp->f_xrctx != NULL);
+
+	xc = kzalloc(sizeof(struct gfs2_xrdir_ctx), GFP_KERNEL);
+	if (xc == NULL)
+		return -ENOMEM;
+
+	if (vp_init(sdp, &xc->xc_dirents, 1) ||
+	    vp_init(sdp, &xc->xc_xattr_keys, 1) ||
+	    vp_init(sdp, &xc->xc_xattr_values, 1)) {
+		gfs2_xrdir_ctx_uninit(fp);
+		kfree(xc);
+		return -ENOMEM;
+	}
+	xc->xc_flags |= XC_FL_ALLOCATED;
+	fp->f_xrctx = xc;
+
+	return 0;
+}
+
+/*
+ * There was an error while collecting entries.
+ * Figure out what happened and twiddle flags
+ * appropriately.
+ */
+void gfs2_xrdir_partial_collect(struct gfs2_xrdir_ctx *xc)
+{
+	if (xc->xc_flags & XC_FL_GATHER_PART_INT ||
+	    xc->xc_flags & XC_FL_ERROR)
+	  return;
+
+	/*
+	 * We encountered a hash collision situation. We've read
+	 * entries in hash order up to the point (not including)
+	 * the colliding hashes. Setting XC_FL_HASH_COLL denotes
+	 * that. Also setting XC_FL_HASH_COLL_NXT so we know
+	 * that the next time we collect entries, the hash
+	 * colliding entries will be part of the collection
+	 */
+	xc->xc_flags |= (XC_FL_HASH_COLL | XC_FL_HASH_COLL_NXT);
+	xc->xc_flags |= (XC_FL_GATHER_PARTS | XC_FL_GATHER_PART_INT);
+	xc->xc_hash_coll_off = xc->xc_offset;
+
+	return;
+}
+
+/*
+ * We have run out of memory while collecting entries and
+ * don't have a single entry to return to the user. We deal
+ * with such a situation by halving the number of dents we
+ * tried to read last time and returning -EAGAIN to the user
+ * so we can have a go at it again
+ */
+static int gfs2_xrdir_handle_oom(struct gfs2_xrdir_ctx *xc)
+{
+	/* next time, only try half the number of dents */
+	xc->xc_dent_cap = DIV_ROUND_UP(xc->xc_count, 2);
+	/* clear out some flags */
+	xc->xc_flags &= ~(XC_FL_ERROR_OOM | XC_FL_ERROR);
+	xc->xc_flags &= ~XC_FL_GATHER_PART_INT;
+	/* In an oom situation, we're going to re-read fewer
+	 * entries from the same collection. This may or may
+	 * not hit the hash collision we recorded (if any).
+	 * So, we reset the relevant flags */
+	xc->xc_flags &= ~(XC_FL_HASH_COLL | XC_FL_HASH_COLL_NXT);
+	xc->xc_hash_coll_off = 0;
+
+	return -EAGAIN;
+}
+
+static int gfs2_xrdir_collect_errcheck(struct gfs2_xrdir_ctx *xc, int error)
+{
+	if (error < 0) { /* If we're out of memory */
+		if (error == -ENOMEM)
+			xc->xc_flags |= XC_FL_ERROR_OOM;
+		xc->xc_flags |= XC_FL_ERROR;
+		return error;
+	} else {
+		if ((xc->xc_dent_cap && xc->xc_count >= xc->xc_dent_cap) ||
+		    (xc->xc_dent_memcap && vp_get_size(&xc->xc_dirents) 
+		     >= xc->xc_dent_memcap)) {
+			/* We hit one of our limits, flag and return */
+			xc->xc_flags |= XC_FL_GATHER_PARTS;
+			xc->xc_flags |= XC_FL_GATHER_PART_INT;
+			return -EOVERFLOW;
+		}
+		return 0;
+	}
+}
+
+/*
+ * To reduce disk-seeking, we collect all the info in stages.
+ * In each stage, we access relevant disk blocks in order
+ * by pre-sorting the entries correspondingly.
+ *
+ * 1. Collect entry info (name, ino, type, offset) etc for all the
+ *    entries. Obtained by reading the directory inode
+ * 2. Collect stat info for all the entries. Obtained by reading
+ *    the file inode blocks.
+ * 3. Collect xattr info for all the entries. Obtained by reading
+ *    the eattr block of each inode.
+ *
+ * With this scheme of collecting data, we don't know what the final
+ * size of a dirent would be ahead of time. gfs2_xrdir_estimate_dent_memcap()
+ * attempts to guess the size. Right now it statically computes and
+ * reserves a fixed percentage of available space for entry+stat info
+ * and xattr info based on what data is requested by the user.
+ *
+ * TODO: Make this dynamic. Analyse the directory being processed
+ * and use observed ratios to improve throughput.
+ */
+static u64 gfs2_xrdir_estimate_dent_memcap(struct gfs2_sbd *sdp,
+					   struct gfs2_xrdir_ctx *xc)
+{
+	u64 avail;
+	int perc = 80;
+	unsigned int mask = xc->xc_xattr_mask;
+
+	avail = (gfs2_tune_get(sdp, gt_max_vb_pages) +
+		 vp_get_page_count(&xc->xc_dirents) +
+		 vp_get_page_count(&xc->xc_xattr_keys) +
+		 vp_get_page_count(&xc->xc_xattr_values) -
+		 atomic_read(&sdp->sd_vb_page_count)) * PAGE_SIZE;
+	if ((mask & XSTAT_XATTR_ALL) && (mask & XSTAT_XATTR_VALUES))
+		perc = 50;
+
+	return (avail * perc) / 100;
+}
+
+/*
+ * We setup the xreaddir context before every collect run
+ */
+static int gfs2_xrdir_ctx_setup(struct file *file, struct gfs2_xrdir_ctx *xc,
+				unsigned int flags, unsigned int mask)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
+
+	if (!(xc->xc_flags & XC_FL_GATHER_PARTS)) {
+		/*
+		 * We only update flags and mask once per readdirplus
+		 * initiation. If there are multiple parts, use the
+		 * same values as initialized at the start
+		 */
+		xc->xc_xst_flags = flags;
+		xc->xc_xattr_mask = mask;
+		xc->xc_offset = file->f_pos;
+	}
+
+	/*
+	 * Set limits for this part based on how much memory is available
+	 * or how many entries per cycle as defined by sysfs file.
+	 * If dent_cap established in a previous run, leave it alone
+	 */
+	xc->xc_dent_cap = xc->xc_dent_cap ? xc->xc_dent_cap : 
+		gfs2_tune_get(sdp, gt_max_xrdir_dents);
+	xc->xc_dent_memcap = gfs2_xrdir_estimate_dent_memcap(sdp, xc);
+
+	xc->xc_dent_valid = 0;
+	xc->xc_count = 0;
+	xc->xc_next_dent = NULL;
+	kfree(xc->xc_vb_dptrs);
+	xc->xc_vb_dptrs = NULL;
+	vp_reset(&xc->xc_dirents);
+	vp_reset(&xc->xc_xattr_keys);
+	vp_reset(&xc->xc_xattr_values);
+
+	return 0;
+}
+
+/*
+ * Add a gfs2_dirent to the xreaddir context
+ */
+int gfs2_xrdir_collect_dents(const struct gfs2_dirent *dent, loff_t off,
+			     struct gfs2_xrdir_ctx *xc)
+{
+	struct gfs2_xdirent *x;
+	u64 x_ino;
+	u32 x_hash;
+	u8 x_valid = 0;
+	char x_type;
+	unsigned int x_xattr_count, x_namelen;
+	const void *nullptr = NULL;
+	int error = 0;
+
+	if (gfs2_dirent_dot_or_dotdot(dent))
+		return 0;
+
+	if (xc->xc_next_dent == NULL)
+		xc->xc_next_dent = xc->xc_dirents.v_ptr;
+	x = xc->xc_next_dent;
+	vp_memset(&xc->xc_dirents, x, 0, sizeof(struct gfs2_xdirent));
+
+	/*
+	 * If we know that we're encountering hash-colliding
+	 * entries this time around, we read only these in
+	 * and nothing else
+	 */
+	if (xc->xc_flags & XC_FL_HASH_COLL_NXT &&
+	    off != xc->xc_hash_coll_off) {
+		/*
+		 * setting dent_cap to how many we've read in
+		 * so we don't read anymore
+		 */
+		xc->xc_dent_cap = xc->xc_count;
+		xc->xc_flags &= ~XC_FL_HASH_COLL_NXT;
+		/*
+		 * xc_offset will get incremented to read
+		 * at the next offset when everything
+		 * is written out properly this cycle
+		 */
+		xc->xc_offset = xc->xc_hash_coll_off;
+		xc->xc_hash_coll_off = 0;
+		goto err_check;
+	}
+
+	/* Copy the dirent contents */
+	x_ino = be64_to_cpu(dent->de_inum.no_addr);
+	x_hash = be32_to_cpu(dent->de_hash);
+	x_type = be16_to_cpu(dent->de_type);
+	x_xattr_count = 0;
+	x_namelen = be16_to_cpu(dent->de_name_len);
+
+	error = vp_write(&xc->xc_dirents, &x->x_ino, &x_ino, sizeof(x->x_ino));
+	if (error != sizeof(x->x_ino)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_hash, &x_hash, sizeof(x->x_hash));
+	if (error != sizeof(x->x_hash)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_valid, &x_valid, sizeof(x->x_valid));
+	if (error != sizeof(x->x_valid)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_type, &x_type, sizeof(x->x_type));
+	if (error != sizeof(x->x_type)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_xattr_count, &x_xattr_count,
+			 sizeof(x->x_xattr_count));
+	if (error != sizeof(x->x_xattr_count)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_vb_xattr_arr_ptr, &nullptr,
+			 sizeof(x->x_vb_xattr_arr_ptr));
+	if (error != sizeof(x->x_vb_xattr_arr_ptr)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_namelen, &x_namelen,
+			 sizeof(x->x_namelen));
+	if (error != sizeof(x->x_namelen)) goto err_check;
+
+	error = vp_write(&xc->xc_dirents, &x->x_name, (char*)(dent + 1), x_namelen);
+	if (error != x_namelen) goto err_check;
+
+	xc->xc_next_dent = x->x_name + x_namelen;
+	xc->xc_count++;
+	error = 0;
+err_check:
+	return gfs2_xrdir_collect_errcheck(xc, error);
+}
+
+/*
+ * Create the array of pointers that point to all the
+ * collected entries within the xc_dirents vbuf.
+ */
+static int gfs2_xrdir_create_dptrs(struct gfs2_xrdir_ctx *xc)
+{
+	int i;
+	unsigned int namelen;
+	struct gfs2_xdirent *x = NULL;
+
+	BUG_ON(xc->xc_vb_dptrs || xc->xc_count == 0);
+
+	/* allocate the dirent pointers */
+	xc->xc_vb_dptrs = kmalloc(sizeof(struct gfs2_xdirent *) * xc->xc_count,
+				  GFP_KERNEL);
+	if (xc->xc_vb_dptrs == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < xc->xc_count; i++) {
+		if (!x)
+			x = xc->xc_dirents.v_ptr;
+		xc->xc_vb_dptrs[i] = x;
+		vp_read(&xc->xc_dirents, &namelen, &x->x_namelen,
+			sizeof(x->x_namelen));
+		/* 
+		 * reclen is sizeof(struct gfs2_xdirent) + x_namelen.
+		 * see struct gfs2_xdirent for more info
+		 */
+		x = (void *)x->x_name + namelen;
+	}
+	return 0;
+}
+
+static int gfs2_xrdir_collect_xstat(struct gfs2_xrdir_ctx *xc)
+{
+	int i;
+	struct kstat st;
+
+	for (i = 0; i < xc->xc_count; i++) {
+		struct gfs2_xdirent *x_vb_p = xc->xc_vb_dptrs[i];
+		struct gfs2_inode *ip;
+
+		vp_read(&xc->xc_dirents, &ip, &x_vb_p->x_ip, sizeof(struct gfs2_inode *));
+		gfs2_getattr_i(ip, &st);
+
+		vp_write(&xc->xc_dirents, &x_vb_p->x_kstat, &st, sizeof(struct kstat));
+		vp_write(&xc->xc_dirents, &x_vb_p->x_eablk, &ip->i_eattr, 
+			 sizeof(x_vb_p->x_eablk));
+	}
+	return 0;
+}
+
+static inline int xattr_requested(char type, unsigned int mask)
+{
+	if ((type == GFS2_EATYPE_USR) && (mask & XSTAT_XATTR_USER))
+		return 1;
+	if ((type == GFS2_EATYPE_SYS) && (mask & XSTAT_XATTR_SYSTEM))
+		return 1;
+	if ((type == GFS2_EATYPE_SECURITY) && (mask & XSTAT_XATTR_SECURITY))
+		return 1;
+	return 0;
+}
+
+static int gfs2_xrdir_xattr_list_i(struct gfs2_inode *ip, 
+				   struct buffer_head *bh,
+				   struct gfs2_ea_header *ea,
+				   struct gfs2_ea_header *prev, void *private)
+{
+	struct gfs2_xdir_ctx_bndle *bundle = private;
+	struct gfs2_xrdir_ctx *xc = bundle->xcb_xc;
+	struct gfs2_xdirent *x = bundle->xcb_xd;
+	struct gfs2_xd_xattr *xtr;
+	char prefix[9];
+	unsigned int l = 0, xtr_count, namlen, reclen;
+	void *p;
+
+	if (!xattr_requested(ea->ea_type, xc->xc_xattr_mask))
+		return 0;
+
+	if (ea->ea_type == GFS2_EATYPE_UNUSED)
+		return 0;
+
+	l = ea_prefix(ea, prefix, 9);
+	BUG_ON(l == 0);
+
+	xtr = vp_get_top(&xc->xc_xattr_keys);
+	/*
+	 * Only certain vp_XXX ops can trip -ENOMEM where we might be extending
+	 * the vbuf. We ignore the error code of other ops.
+	 */
+	if (vp_memset(&xc->xc_xattr_keys, xtr, 0, 
+		      sizeof(struct gfs2_xd_xattr)) == -ENOMEM)
+		goto set_oom;
+
+	/* if mask says don't do values, skip the following lines */
+	if (GFS2_EA_DATA_LEN(ea) > 0 && (xc->xc_xattr_mask & XSTAT_XATTR_VALUES)) {
+		void *valptr = vp_get_top(&xc->xc_xattr_values);
+		unsigned long len = GFS2_EA_DATA_LEN(ea);
+
+		vp_write(&xc->xc_xattr_keys, &xtr->xa_value_len,
+			 &len, sizeof(xtr->xa_value_len));
+		vp_write(&xc->xc_xattr_keys, &xtr->xa_vb_value_ptr, &valptr,
+			 sizeof(void*));
+		vp_read(&xc->xc_xattr_keys, &p, &xtr->xa_vb_value_ptr,
+			sizeof(void*));
+		if (vp_append(&xc->xc_xattr_values, GFS2_EA2DATA(ea), len)
+		    == -ENOMEM)
+			goto set_oom;
+	}
+
+	namlen = l + ea->ea_name_len;
+	vp_write(&xc->xc_xattr_keys, &xtr->xa_keylen, &namlen,
+		 sizeof(xtr->xa_keylen));
+	if (vp_write(&xc->xc_xattr_keys, xtr->xa_keyname, &prefix, l) == -ENOMEM)
+		goto set_oom;
+	if (vp_write(&xc->xc_xattr_keys, xtr->xa_keyname + l, 
+		     GFS2_EA2NAME(ea), namlen) == -ENOMEM)
+		goto set_oom;
+
+	/* gfs2_xd_xattr.xa_keyname[1] has an extra byte */
+	reclen = (xtr->xa_keyname + l + namlen) - (char *)xtr;
+	vp_write(&xc->xc_xattr_keys, &xtr->xa_reclen, &reclen,
+		 sizeof(xtr->xa_reclen));
+
+	vp_read(&xc->xc_dirents, &xtr_count, &x->x_xattr_count,
+		sizeof(x->x_xattr_count));
+	xtr_count++;
+	vp_write(&xc->xc_dirents, &x->x_xattr_count, &xtr_count,
+		 sizeof(x->x_xattr_count));
+
+	return 0;
+set_oom:
+	xc->xc_flags |= XC_FL_ERROR_OOM;
+	return -ENOMEM;
+}
+
+int gfs2_xrdir_collect_xattrs(struct gfs2_xrdir_ctx *xc)
+{
+	int error = 0, i;
+
+	for (i = 0; i < xc->xc_count; i++) {
+		struct gfs2_xdirent *xtop, *x_vb_p = xc->xc_vb_dptrs[i];
+		struct gfs2_inode *ip;
+		struct gfs2_xdir_ctx_bndle bundle;
+		u8 valid = 1;
+
+		vp_read(&xc->xc_dirents, &ip, &x_vb_p->x_ip,
+			sizeof(struct gfs2_inode *));
+
+		if (!ip->i_eattr || !(xc->xc_xattr_mask & XSTAT_XATTR_ALL))
+			goto mark_valid;
+
+		bundle.xcb_xc = xc;
+		bundle.xcb_xd = x_vb_p;
+
+		xtop = vp_get_top(&xc->xc_xattr_keys);
+		vp_write(&xc->xc_dirents, &x_vb_p->x_vb_xattr_arr_ptr, &xtop,
+			 sizeof(struct gfs2_xd_xattr*));
+
+		error = ea_foreach(ip, gfs2_xrdir_xattr_list_i, &bundle);
+		if (error)
+			break;
+	mark_valid:
+		/* Read the xattrs for this dent, so mark it as valid */
+		vp_write(&xc->xc_dirents, &x_vb_p->x_valid, &valid,
+			 sizeof(x_vb_p->x_valid));
+		xc->xc_dent_valid++;
+	}
+	return error;
+}
+
+static int gfs2_xrdir_collect_extra_info(struct gfs2_xrdir_ctx *xc,
+					 struct gfs2_inode *dip)
+{
+	int error = -ENOMEM, i;
+	struct gfs2_holder *ghs;
+
+	/* First sort the dents according to inode blk order for stat */
+	ctx_sort(xc, xc->xc_vb_dptrs, xc->xc_count, sizeof(void *),
+		 ctx_compare_dent_iblks, NULL);
+	
+	/* Lookup all the inodes for stat info */
+	for (i = 0; i < xc->xc_count; i++) {
+		struct gfs2_xdirent *x_vb_p = xc->xc_vb_dptrs[i];
+		u64 ino;
+		struct inode *inode;
+		struct gfs2_inode *ip, *nullptr = NULL;
+	
+		vp_read(&xc->xc_dirents, &ino, &x_vb_p->x_ino,
+			sizeof(x_vb_p->x_ino));
+
+		inode = gfs2_lookup_by_inum(GFS2_SB(&dip->i_inode), ino, NULL,
+					    GFS2_BLKST_DINODE);
+		if (IS_ERR(inode)) {
+			vp_write(&xc->xc_dirents, &ip, &nullptr,
+				 sizeof(struct gfs2_inode *));
+			error = -1;
+			goto iput_iarr;
+		}
+		ip = GFS2_I(inode);
+		vp_write(&xc->xc_dirents, &x_vb_p->x_ip, &ip,
+			 sizeof(struct gfs2_inode *));
+	}
+
+	/* lock all inodes */
+	ghs = kcalloc(xc->xc_count, sizeof(struct gfs2_holder), GFP_NOFS);
+	if (!ghs)
+		goto iput_iarr;
+	for (i = 0; i < xc->xc_count; i++) {
+		struct gfs2_xdirent *x_vb_p = xc->xc_vb_dptrs[i];
+		struct gfs2_inode *ip;
+
+		vp_read(&xc->xc_dirents, &ip, &x_vb_p->x_ip,
+			sizeof(struct gfs2_inode *));
+		gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, ghs + i);
+	}
+
+	error = gfs2_glock_nq_m(xc->xc_count, ghs);
+	if (error)
+		goto free_ghs;
+
+	if (gfs2_xrdir_collect_xstat(xc))
+		goto free_ghs;
+
+	/* Sort the dents according to eattr blk order */
+	ctx_sort(xc, xc->xc_vb_dptrs, xc->xc_count, sizeof(void *),
+		 ctx_compare_dent_eablks, NULL);
+
+	error = gfs2_xrdir_collect_xattrs(xc);
+
+	for (i = 0; i < xc->xc_count; i++)
+		gfs2_glock_dq_uninit(&ghs[i]);
+free_ghs:
+	kfree(ghs);
+iput_iarr:
+	for (i = 0; i < xc->xc_count; i++) {
+		struct gfs2_xdirent *x_vb_p = xc->xc_vb_dptrs[i];
+		struct gfs2_inode *ip;
+
+		vp_read(&xc->xc_dirents, &ip, &x_vb_p->x_ip,
+			sizeof(struct gfs2_inode *));
+		if (ip)
+			iput(&ip->i_inode);
+	}
+	/* Sort the pointers back to dent order */
+	ctx_sort(xc, xc->xc_vb_dptrs, xc->xc_count, sizeof(void *),
+		 ctx_compare_dents, NULL);
+
+	if (error == -ENOMEM) {
+		/*
+		 * If at least one dent has been collected in full,
+		 * void -ENOMEM
+		 * We shuffled the order of dents multiple times while
+		 * retrieving stat and xattrs, so we have to ensure that
+		 * at least the first dent in the final ordering is valid
+		 * in order to be able to return at least 1 entry. This
+		 * is because we need to preserve the order (hash order)
+		 * when we return the dents to the user. XXX: OR DO WE??
+		 */
+		struct gfs2_xdirent *x_vb_p = xc->xc_vb_dptrs[0];
+		u8 valid;
+		vp_read(&xc->xc_dirents, &valid, &x_vb_p->x_valid,
+			sizeof(x_vb_p->x_valid));
+
+		if (valid)
+			error = 0;
+		else {
+			u32 hash;
+			vp_read(&xc->xc_dirents, &hash, &x_vb_p->x_hash,
+				sizeof(hash));
+			xc->xc_offset = gfs2_disk_hash2offset(hash);
+		}
+	}
+	if (!error)
+		xc->xc_flags |= XC_FL_DATA_AVAIL;
+	
+	return error;
+}
+
+static int gfs2_xrdir_to_user_xattrs(struct gfs2_xrdir_ctx *xc,
+				     struct gfs2_xdirent *x, 
+				     struct gfs2_xd_xattr *xdx_vb_p,
+				     struct xdirent_xattr __user *xx,
+				     size_t count, size_t *bytes, char *tempbuf)
+{
+	struct gfs2_xd_xattr xdx;
+	int attrcount = 0, error = -EINVAL;
+	
+	while (attrcount < x->x_xattr_count) {
+		vp_read(&xc->xc_xattr_keys, &xdx, xdx_vb_p,
+			sizeof(struct gfs2_xd_xattr));
+
+		if ((count - *bytes) < 
+		    (sizeof(struct xdirent_xattr) + 
+		     xdx.xa_keylen + xdx.xa_value_len)) {
+			error = -EOVERFLOW;
+			goto out;
+		}
+
+		if (__put_user(xdx.xa_value_len, &xx->xa_value_len))
+			goto out;
+
+		vp_read(&xc->xc_xattr_keys, tempbuf, xdx_vb_p->xa_keyname,
+			xdx.xa_keylen);
+
+		if (copy_to_user(xx->xa_name_val, tempbuf, xdx.xa_keylen))
+			goto out;
+		if (__put_user(0, xx->xa_name_val + xdx.xa_keylen))
+			goto out;
+
+		if ((xc->xc_xattr_mask & XSTAT_XATTR_VALUES) &&
+		    xdx.xa_vb_value_ptr) {
+			vp_read(&xc->xc_xattr_values, tempbuf, xdx.xa_vb_value_ptr,
+				xdx.xa_value_len);
+
+			if (copy_to_user(xx->xa_name_val + xdx.xa_keylen + 1, tempbuf,
+					 xdx.xa_value_len))
+				goto out;
+		}
+
+		xx = (struct xdirent_xattr __user *)
+			((char *)xx + sizeof(xx->xa_value_len)
+			 + xdx.xa_keylen + 1 + xdx.xa_value_len);
+		xdx_vb_p = (void*) xdx_vb_p + xdx.xa_reclen;
+
+		*bytes += sizeof(struct xdirent_xattr) + xdx.xa_keylen +
+			xdx.xa_value_len;
+		attrcount++;
+	}
+	error = 0;
+out:
+	return error;
+}
+
+static int gfs2_xrdir_to_user_vars(struct gfs2_xrdir_ctx *xc,
+				   struct gfs2_xdirent *x,
+				   struct gfs2_xdirent *x_vb_p,
+				   struct linux_xdirent __user *lxd,
+				   size_t count, size_t *bytes)
+{
+	int error = -EINVAL;
+	char *tempbuf = NULL;
+	struct xdirent_blob __user *xblob;
+	struct xdirent_xattr __user *xx;
+	struct gfs2_xd_xattr *xdx_vb_p;
+
+	tempbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!tempbuf) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	xblob = &lxd->xd_blob;
+
+	/* copy all the variable length fields */
+	if ((count - *bytes) < x->x_namelen) {
+		error = -EOVERFLOW;
+		goto free;
+	}
+
+	vp_read(&xc->xc_dirents, tempbuf, x_vb_p->x_name, x->x_namelen);
+
+	if (copy_to_user(xblob->xb_blob, tempbuf, x->x_namelen))
+		goto free;
+	if (__put_user(0, xblob->xb_blob + x->x_namelen))
+		goto free;
+
+	*bytes += x->x_namelen;
+	error = 0;
+
+	if ((xc->xc_xattr_mask & XSTAT_XATTR_ALL) &&
+		lxd->xd_blob.xb_xattr_count) {
+		xx = (struct xdirent_xattr __user *)
+			(xblob->xb_blob + x->x_namelen + 1);
+		xdx_vb_p = x->x_vb_xattr_arr_ptr;
+
+		error = gfs2_xrdir_to_user_xattrs(xc, x, xdx_vb_p, xx,
+						  count, bytes, tempbuf);
+	}
+free:
+	kfree(tempbuf);
+out:
+	return error;
+}
+
+static int gfs2_xrdir_to_user_fixed(struct gfs2_xrdir_ctx *xc,
+				    struct gfs2_xdirent *x,
+				    struct gfs2_xdirent *x_vb_p,
+				    struct linux_xdirent __user *lxd, 
+				    size_t count, size_t *bytes)
+{
+	struct xdirent_blob __user *xblob;
+	int error = -EINVAL;
+
+	vp_read(&xc->xc_dirents, x, x_vb_p, sizeof(struct gfs2_xdirent));
+
+	if ((count - *bytes) < sizeof(struct linux_xdirent)) {
+		error = -EOVERFLOW;
+		goto out;
+	}
+
+	if (__put_user(x->x_ino, &lxd->xd_ino))
+		goto out;
+	if (__put_user(x->x_type, &lxd->xd_type))
+		goto out;
+	if (__put_user(0, &lxd->xd_off))
+		goto out;
+
+	error = xstat_set_result(&x->x_kstat, &lxd->xd_stat);
+	if (error)
+		goto out;
+
+	xblob = &lxd->xd_blob;
+
+	error = -EINVAL;
+	if (__put_user(x->x_xattr_count, &xblob->xb_xattr_count))
+		goto out;
+
+	/* copied all the fixed size fields */
+	*bytes += sizeof(struct linux_xdirent);
+	error = 0;
+out:
+	return error;
+}
+
+static size_t gfs2_xrdir_to_user(struct gfs2_xrdir_ctx *xc, void __user *buf,
+				 size_t count)
+{
+	size_t error = -EINVAL, bytes = 0, bytes_bef = 0;
+	int i, skip = 1, written = 0;
+	struct gfs2_xdirent x, *x_vb_p;
+	struct linux_xdirent __user *lxd = buf;
+	u8 valid;
+
+	if (!(xc->xc_flags & XC_FL_DATA_AVAIL))
+		goto out;
+
+	for (i = 0; i < xc->xc_count; i++) {
+		u32 hash;
+		x_vb_p = xc->xc_vb_dptrs[i];
+		vp_read(&xc->xc_dirents, &hash, &x_vb_p->x_hash, sizeof(hash));
+
+		if (skip && xc->xc_vb_dptrs[i] != xc->xc_next_dent)
+			continue;
+		skip = 0;
+		vp_read(&xc->xc_dirents, &valid, &x_vb_p->x_valid,
+			sizeof(x_vb_p->x_valid));
+		if (!valid)
+			break;
+
+		/* This will fill up x from x_vb_p and subsequently lxd from x */
+		error = gfs2_xrdir_to_user_fixed(xc, &x, x_vb_p, lxd, count,
+						 &bytes);
+		if (error) {
+			if (error == -EOVERFLOW)
+				goto overflow;
+			goto out;
+		}
+
+		error = gfs2_xrdir_to_user_vars(xc, &x, x_vb_p, lxd, count,
+						&bytes);
+		if (error) {
+			u64 ino;
+			vp_read(&xc->xc_dirents, &ino, &x_vb_p->x_ino, sizeof(ino));
+			if (error == -EOVERFLOW)
+				goto overflow;
+			goto out;
+		}
+
+		if (__put_user(bytes - bytes_bef, &lxd->xd_reclen))
+			goto out;
+
+		lxd = (void *)lxd + (bytes - bytes_bef);
+		xc->xc_next_dent = xc->xc_vb_dptrs[i+1];
+		written++;
+		bytes_bef = bytes;
+	}
+overflow:
+	if (written) {
+		if (!valid) {
+			u32 hash;
+			x_vb_p = xc->xc_vb_dptrs[i];
+			vp_read(&xc->xc_dirents, &hash, &x_vb_p->x_hash,
+				sizeof(hash));
+			/*
+			 * Some of the entries we collected were incomplete,
+			 * so we only wrote the ones that were complete. For
+			 * next time, we'll only try to collect half the 
+			 * number of entries. This will also invalidate the
+			 * assumption that we'll encounter hash-colliding
+			 * entries in the next pass
+			 */
+			xc->xc_offset = gfs2_disk_hash2offset(hash);
+			xc->xc_flags &= ~(XC_FL_GATHER_PART_INT |
+					  XC_FL_DATA_AVAIL |
+					  XC_FL_HASH_COLL |
+					  XC_FL_HASH_COLL_NXT);
+			xc->xc_hash_coll_off = 0;
+			xc->xc_dent_cap = DIV_ROUND_UP(xc->xc_count, 2);
+		} else {
+			/*
+			 * If we didn't overflow the user buffer, we
+			 * have written out all the collected dents to
+			 * the user buffer
+			 */
+			if (error != -EOVERFLOW) {
+				xc->xc_flags &= ~(XC_FL_GATHER_PART_INT |
+						  XC_FL_DATA_AVAIL);
+				xc->xc_dent_cap = 0;
+				if (!(xc->xc_flags & XC_FL_HASH_COLL))
+					xc->xc_offset++;
+			}
+		}
+	}
+	if (!written && !skip) {
+		error = -EOVERFLOW;
+		goto out;
+	}
+	error = bytes_bef;
+out:
+	return error;
+}
+
+/**
+ * gfs2_xreaddir - GFS2's implementation of xreaddir functionality
+ * @file  : The directory to xreaddir
+ * @flags : flags used by xstat
+ * @mask  : field mask for xstat and xattrs
+ * @buf   : User buffer to fill data into
+ * @count : Size of the user buffer in bytes
+ *
+ * Collect extended information (xstat, xattrs) about the dents in the
+ * given directory and fill them into the user buf passed in.
+ *
+ * Returns: 0       if successful.
+ *          -EAGAIN if the user should retry.
+ *          -ve values for other errors
+ */
+
+size_t gfs2_xreaddir(struct file *file, unsigned int flags, unsigned int mask,
+			    void __user *buf, size_t count)
+{
+	struct gfs2_xrdir_ctx *xc = ((struct gfs2_file *)
+				     file->private_data)->f_xrctx;
+	size_t error = 0;
+	struct inode *dir = file->f_mapping->host;
+	struct gfs2_inode *dip = GFS2_I(dir);
+	struct gfs2_holder d_gh;
+
+	if (xc->xc_flags & XC_FL_DATA_AVAIL) {
+		error = gfs2_xrdir_to_user(xc, buf, count);
+		file->f_pos = xc->xc_offset;
+		return error;
+	}
+
+	error = gfs2_xrdir_ctx_setup(file, xc, flags, mask);
+	if (error)
+		goto out;
+
+	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
+	error = gfs2_glock_nq(&d_gh);
+	if (error) {
+		gfs2_holder_uninit(&d_gh);
+		goto out;
+	}
+
+	xc->xc_flags &= ~XC_FL_HASH_COLL;
+	error = gfs2_dir_read(dir, NULL, xc, &file->f_ra);
+	if (error) {
+		if (xc->xc_flags & XC_FL_ERROR_OOM)
+			error = gfs2_xrdir_handle_oom(xc);
+		goto uninit;
+	}
+
+	if (xc->xc_count == 0)
+		goto uninit;
+	
+	if (!(xc->xc_flags & XC_FL_GATHER_PARTS))
+		xc->xc_flags |= XC_FL_GATHER_FULL;
+	else if (!(xc->xc_flags & XC_FL_GATHER_PART_INT))
+		xc->xc_flags |= XC_FL_GATHER_PART_END;
+
+	error = gfs2_xrdir_create_dptrs(xc);
+	if (error) {
+		if (error == -ENOMEM)
+			error = gfs2_xrdir_handle_oom(xc);
+		goto uninit;
+	}
+
+	error = gfs2_xrdir_collect_extra_info(xc, dip);
+	if (error) {
+		if (error == -ENOMEM)
+			error = gfs2_xrdir_handle_oom(xc);
+		goto uninit;
+	}
+
+	xc->xc_next_dent = xc->xc_vb_dptrs[0];
+	error = gfs2_xrdir_to_user(xc, buf, count);
+
+	file->f_pos = xc->xc_offset;
+uninit:
+	if (xc->xc_flags & XC_FL_HASH_COLL && !(xc->xc_flags & XC_FL_DATA_AVAIL))
+		xc->xc_flags &= ~XC_FL_HASH_COLL;
+
+	gfs2_glock_dq_uninit(&d_gh);
+out:
+	return error;
+}
diff --git a/fs/gfs2/xreaddir.h b/fs/gfs2/xreaddir.h
new file mode 100644
index 0000000..ea6c82c
--- /dev/null
+++ b/fs/gfs2/xreaddir.h
@@ -0,0 +1,84 @@
+#ifndef __XREADDIR_H__
+#define __XREADDIR_H__
+
+struct gfs2_xd_xattr {
+	unsigned int   xa_reclen;
+	void          *xa_vb_value_ptr;
+	unsigned long  xa_value_len;
+	unsigned int   xa_keylen;
+	char           __pad[7];
+	char           xa_keyname[1];
+};
+
+struct gfs2_xdirent {
+	u32                      x_hash;
+	u8                       x_valid;
+	struct gfs2_inode       *x_ip;
+	u64                      x_ino;
+	u64                      x_eablk;
+	char                     x_type;
+	struct kstat             x_kstat;
+	unsigned int             x_xattr_count;
+	void                    *x_vb_xattr_arr_ptr;
+	unsigned int             x_namelen;
+	char                     x_name[1];
+};
+
+#define XC_FL_ALLOCATED                 0x00000001
+#define XC_FL_GATHER_FULL               0x00000002
+#define XC_FL_GATHER_PARTS              0x00000004
+#define XC_FL_GATHER_PART_INT           0x00000008
+#define XC_FL_GATHER_PART_END           0x00000010
+#define XC_FL_HASH_COLL                 0x00000020
+#define XC_FL_HASH_COLL_NXT             0x00000040
+#define XC_FL_ERROR_OOM                 0x00000080
+#define XC_FL_ERROR                     0x00000100
+#define XC_FL_DATA_AVAIL                0x00000200
+#define XC_FL_PRINTOK                   0x10000000
+
+/*
+ * readdir ctx
+ */
+struct gfs2_xrdir_ctx {
+	u32                   xc_flags;           /* XC_FL_XXXX */
+	u64                   xc_dent_memcap;     /* mem limit per collect */
+	u32                   xc_dent_cap;        /* # dent limit per collect */
+	u32                   xc_dent_valid;      /* # valid dents collected */
+	u32                   xc_xattr_mask;      /* XSTAT_XATTR_XXX see stat.h*/
+	u32                   xc_xst_flags;       /* XSTAT_XXX see stat.h */
+	loff_t                xc_offset;          /* offset of next dent */
+	unsigned long         xc_count;           /* # dents collected */
+	loff_t                xc_hash_coll_off;   /* last hash collision offset */
+	void                 *xc_next_dent;       /* next dent to write out */
+	void                **xc_vb_dptrs;        /* ptrs to dents in xc_dirents */
+	struct vbuf           xc_dirents;         /* temp storage for dents */
+	struct vbuf           xc_xattr_keys;      /* xattr keys for dents */
+	struct vbuf           xc_xattr_values;    /* corresponding values */
+};
+
+/*
+ * Ugly struct to blob together these two
+ * structs. Only used in one place to 
+ * retrieve extended attributes.
+ * This is so that we don't have to change
+ * the prototypes of all the existing
+ * xattr handling functions to accept an
+ * extra arg.
+ */
+struct gfs2_xdir_ctx_bndle {
+	struct gfs2_xrdir_ctx *xcb_xc;
+	struct gfs2_xdirent   *xcb_xd;
+};
+
+extern size_t gfs2_xreaddir(struct file *file, unsigned int flags,
+			    unsigned int mask, void __user *buf,
+			    size_t count);
+extern int gfs2_xrdir_collect_dents(const struct gfs2_dirent *dent, loff_t off,
+				    struct gfs2_xrdir_ctx *xc);
+extern void gfs2_xrdir_partial_collect(struct gfs2_xrdir_ctx *xc);
+extern int gfs2_xrdir_collect_xattrs(struct gfs2_xrdir_ctx *xc);
+
+extern int gfs2_xrdir_ctx_init(struct gfs2_file *fp, struct gfs2_sbd *sdp);
+extern void gfs2_xrdir_ctx_uninit(struct gfs2_file *fp);
+
+#endif /* __XREADDIR_H_ */
-- 
1.8.1.4

