Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3IJOQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:16:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48699 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3IJOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:16:13 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v6] fat: additions to support fat_fallocate
Date: Tue, 10 Sep 2013 23:15:52 +0900
Message-Id: <1378822553-2587-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

v6: In v3 of the patch we released the allocated clutsers in
fat_file_release on the basis of d_count. Moving this from fat_file_release
to fat_evict_inode and on the basis of i_count , so that allocated
clusters are released at the last refrence of the inode when inode
evicts from memory .

In case of direct IO , writting in fallocated area fall back to
buffered write.

Support for fibmap is also added for fallocated region
by modifying fat_bmap to map cluster in case of read request
for a block in fallocated region.

v5: change to avoid compilation warning:
  fs/fat/inode.c: In function 'fat_zero_falloc_area':
>> fs/fat/inode.c:169:11: warning: comparison of distinct pointer
types lacks a cast [enabled by default]

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
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/cache.c |   16 +++++++++--
 fs/fat/file.c  |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/inode.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 171 insertions(+), 4 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 91ad9e1..06cb903 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -312,6 +312,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
 	int cluster, offset;
+	loff_t i_size = i_size_read(inode);
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -323,11 +324,19 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 		return 0;
 	}
 
-	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	last_block = (i_size + (blocksize - 1)) >> blocksize_bits;
 	if (sector >= last_block) {
-		if (!create)
-			return 0;
+		if (!create) {
+			/*
+ 			 * to map cluster in case of read request
+			 * for a block in fallocated region
+ 			 */
+  			if (MSDOS_I(inode)->mmu_private >
+				round_up(i_size, sb->s_blocksize))
+				goto out_map_cluster;
 
+			return 0;
+		}
 		/*
 		 * ->mmu_private can access on only allocation path.
 		 * (caller must hold ->i_mutex)
@@ -338,6 +347,7 @@ int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 			return 0;
 	}
 
+out_map_cluster:
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
 	cluster = fat_bmap_cluster(inode, cluster);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 33711ff..a3abc56 100644
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
@@ -182,6 +185,7 @@ const struct file_operations fat_file_operations = {
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate      = fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -220,6 +224,87 @@ out:
 	return err;
 }
 
+/*
+ * Preallocate space for a file. This implements fat's fallocate file
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset. If FALLOC_FL_KEEP_SIZE is set
+ * we just allocate clusters without zeroing them out. Otherwise we
+ * allocate and zero out clusters via an expanding truncate.
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
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3134d1e..3bd6e73 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -152,16 +152,67 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
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
+		unsigned offset;
+		size_t bytes;
+		void *fsdata;
+
+		offset = (curpos & (PAGE_CACHE_SIZE - 1));
+		bytes = PAGE_CACHE_SIZE - offset;
+		bytes = min(bytes, count);
+
+		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
+				AOP_FLAG_UNINTERRUPTIBLE,
+				&page, &fsdata);
+		if (err)
+			break;
+
+		zero_user(page, offset, bytes);
+
+		err = pagecache_write_end(NULL, mapping, curpos, bytes, bytes,
+				page, fsdata);
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
+	struct inode *inode = mapping->host;
+	struct super_block *sb = inode->i_sb;
+	loff_t i_size = i_size_read(inode);
+
+	if (MSDOS_I(inode)->mmu_private > round_up(i_size, sb->s_blocksize)
+			&& pos > i_size) {
+		err = fat_zero_falloc_area(file, mapping, pos);
+		if (err) {
+			fat_msg(sb, KERN_ERR,
+				"Error (%d) zeroing fallocated area", err);
+			return err;
+		}
+	}
 
 	*pagep = NULL;
 	err = cont_write_begin(file, mapping, pos, len, flags,
 				pagep, fsdata, fat_get_block,
-				&MSDOS_I(mapping->host)->mmu_private);
+				&MSDOS_I(inode)->mmu_private);
 	if (err < 0)
 		fat_write_failed(mapping, pos + len);
 	return err;
@@ -205,6 +256,14 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		loff_t size = offset + iov_iter_count(iter);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
+		/*
+ 		 * In case of writing in fallocated region, return 0 and
+ 		 * fallback to buffered write.
+ 		 */
+		if (MSDOS_I(inode)->mmu_private >
+			round_up(i_size_read(inode), inode->i_sb->s_blocksize))
+			return 0;
+
 	}
 
 	/*
@@ -488,6 +547,19 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 
 static void fat_evict_inode(struct inode *inode)
 {
+
+	struct super_block *sb = inode->i_sb;
+
+	/*
+	 * Release unwritten fallocated blocks on file release.
+	 * Do this only when the inode evict and i_count becomes 0.
+	 */
+	mutex_lock(&inode->i_mutex);
+	if (round_up(inode->i_size, sb->s_blocksize) <
+	    MSDOS_I(inode)->mmu_private && atomic_read(&inode->i_count) == 0)
+		fat_truncate_blocks(inode, inode->i_size);
+	mutex_unlock(&inode->i_mutex);
+
 	truncate_inode_pages(&inode->i_data, 0);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
-- 
1.7.9.5

