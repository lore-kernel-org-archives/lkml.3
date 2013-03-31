Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3CaCup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 22:50:45 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36319 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3CaCun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 22:50:43 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4] fat: editions to support fat_fallocate
Date: Sun, 31 Mar 2013 11:50:34 +0900
Message-Id: <1364698234-22145-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Implement preallocation via the fallocate syscall on VFAT partitions.

Change Log:
v4: Rework based on review comments.
Add check in fat_setattr to release fallocated blocks on a truncate

v3: Release preallocated blocks at file release.

With FALLOC_FL_KEEP_SIZE, there is no way to distinguish if the
mismatch between i_size and no. of clusters allocated is a consequence
of fallocate or just plain corruption. When a non fallocate aware (old)
linux fat driver tries to write to such a file, it throws an error.Also,
fsck detects this as inconsistency and truncates the prealloc'd blocks.

To avoid this, as suggested by OGAWA, remove changes that make fallocate
persistent across mounts and restrict lifetime of blocks from
fallocate(2) to file release.

v2: On an area preallocated with FALLOC_FL_KEEP_SIZE, when a seek was
done to an offset beyond i_size, the old (garbage) data was exposed as
we did not zero out the area at allocation time. Added
fat_zero_falloc_area() to fix this.

v1: Reworked an earlier patch of the same name
(https://lkml.org/lkml/2007/12/22/130) to fix some bugs:
 i) Preallocated space was not persistent and was lost on remount. Fixed
it.
 ii) Did not zero out allocated clusters when FALLOC_FL_KEEP_SIZE was set,
thereby speeding up preallocation time.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/file.c  |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fat/inode.c |   53 +++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index b0b632e..7326439 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -17,8 +17,11 @@
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 #include "fat.h"
 
+static long fat_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len);
 static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
 {
 	u32 attr;
@@ -140,6 +143,22 @@ static long fat_generic_compat_ioctl(struct file *filp, unsigned int cmd,
 
 static int fat_file_release(struct inode *inode, struct file *filp)
 {
+
+	struct super_block *sb = inode->i_sb;
+	loff_t mmu_private_ideal;
+
+	/*
+	 * Release unwritten fallocated blocks on file release.
+	 * Do this only when the last open file descriptor is closed.
+	 */
+	mutex_lock(&inode->i_mutex);
+	mmu_private_ideal = round_up(inode->i_size, sb->s_blocksize);
+
+	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
+	    filp->f_dentry->d_count == 1)
+		fat_truncate_blocks(inode, inode->i_size);
+	mutex_unlock(&inode->i_mutex);
+
 	if ((filp->f_mode & FMODE_WRITE) &&
 	     MSDOS_SB(inode->i_sb)->options.flush) {
 		fat_flush_inodes(inode->i_sb, inode, NULL);
@@ -174,6 +193,7 @@ const struct file_operations fat_file_operations = {
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate      = fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -212,6 +232,88 @@ out:
 	return err;
 }
 
+/*
+ * Preallocate space for a file. This implements fat's fallocate file
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset. If FALLOC_FL_KEEP_SIZE is set
+ * we just allocate clusters without zeroing them out. Otherwise we
+ * allocate and zero out clusters via an expanding truncate. The
+ * allocated clusters are freed in fat_file_release().
+ */
+static long fat_fallocate(struct file *file, int mode,
+				loff_t offset, loff_t len)
+{
+	int cluster, fclus, dclus;
+	int nr_cluster; /* Number of clusters to be allocated */
+	loff_t nr_bytes; /* Number of bytes to be allocated*/
+	loff_t free_bytes; /* Unused bytes in the last cluster of file*/
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int err = 0;
+
+	/* No support for hole punch or other fallocate flags. */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&inode->i_mutex);
+	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
+		fat_msg(sb, KERN_ERR,
+			"fat_fallocate(): Blocks already allocated");
+		err = -EINVAL;
+		goto error;
+	}
+
+	if (mode & FALLOC_FL_KEEP_SIZE) {
+		/* First compute the number of clusters to be allocated */
+		if (inode->i_size > 0) {
+			err = fat_get_cluster(inode, FAT_ENT_EOF,
+					      &fclus, &dclus);
+			if (err < 0) {
+				fat_msg(sb, KERN_ERR,
+					"fat_fallocate(): fat_get_cluster() error");
+				goto error;
+			}
+			free_bytes = ((fclus + 1) << sbi->cluster_bits) -
+				     inode->i_size;
+			nr_bytes = offset + len - inode->i_size - free_bytes;
+			MSDOS_I(inode)->mmu_private = (fclus + 1) <<
+						      sbi->cluster_bits;
+		} else
+			nr_bytes = offset + len - inode->i_size;
+
+		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
+			     sbi->cluster_bits;
+
+		/* Start the allocation.We are not zeroing out the clusters */
+		while (nr_cluster-- > 0) {
+			err = fat_alloc_clusters(inode, &cluster, 1);
+			if (err) {
+				fat_msg(sb, KERN_ERR,
+					"fat_fallocate(): fat_alloc_clusters() error");
+				goto error;
+			}
+			err = fat_chain_add(inode, cluster, 1);
+			if (err) {
+				fat_free_clusters(inode, cluster);
+				goto error;
+			}
+			MSDOS_I(inode)->mmu_private += sbi->cluster_size;
+		}
+	} else {
+		/* This is just an expanding truncate */
+		err = fat_cont_expand(inode, (offset + len));
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+				"fat_fallocate(): fat_cont_expand() error");
+		}
+	}
+
+error:
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
 /* Free all clusters after the skip'th cluster. */
 static int fat_free(struct inode *inode, int skip)
 {
@@ -378,6 +480,9 @@ int fat_setattr(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	unsigned int ia_valid;
 	int error;
+	loff_t mmu_private_ideal;
+
+	mmu_private_ideal = round_up(inode->i_size, dentry->d_sb->s_blocksize);
 
 	/* Check for setting the inode time. */
 	ia_valid = attr->ia_valid;
@@ -403,7 +508,8 @@ int fat_setattr(struct dentry *dentry, struct iattr *attr)
 	if (attr->ia_valid & ATTR_SIZE) {
 		inode_dio_wait(inode);
 
-		if (attr->ia_size > inode->i_size) {
+		if (attr->ia_size > inode->i_size &&
+		    MSDOS_I(inode)->mmu_private <= mmu_private_ideal) {
 			error = fat_cont_expand(inode, attr->ia_size);
 			if (error || attr->ia_valid == ATTR_SIZE)
 				goto out;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index dfce656..275221d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -152,11 +152,64 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 	}
 }
 
+static int fat_zero_falloc_area(struct file *file,
+				struct address_space *mapping, loff_t pos)
+{
+	struct page *page;
+	struct inode *inode = mapping->host;
+	loff_t curpos = i_size_read(inode);
+	size_t count = pos - curpos;
+	int err;
+
+	do {
+		unsigned offset, bytes;
+		void *fsdata;
+
+		offset = (curpos & (PAGE_CACHE_SIZE - 1));
+		bytes = PAGE_CACHE_SIZE - offset;
+		bytes = min(bytes, count);
+
+		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
+					AOP_FLAG_UNINTERRUPTIBLE,
+					&page, &fsdata);
+		if (err)
+			break;
+
+		zero_user(page, offset, bytes);
+
+		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
+					page, fsdata);
+		if (err < 0)
+			break;
+		curpos += bytes;
+		count -= bytes;
+		err = 0;
+	} while (count);
+
+	return err;
+}
+
 static int fat_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
 	int err;
+	loff_t mmu_private_ideal, mmu_private_actual;
+	loff_t size;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+
+	size = i_size_read(inode);
+	mmu_private_actual = MSDOS_I(inode)->mmu_private;
+	mmu_private_ideal = round_up(size, sb->s_blocksize);
+	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
+		err = fat_zero_falloc_area(file, mapping, pos);
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+				"Error (%d) zeroing fallocated area", err);
+			return err;
+		}
+	}
 
 	*pagep = NULL;
 	err = cont_write_begin(file, mapping, pos, len, flags,
-- 
1.7.9.5

