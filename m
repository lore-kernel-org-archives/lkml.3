Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaCBOJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:09:18 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36648 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaCBOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:09:07 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 2/6] fat: add fat_fallocate operation
Date: Sun,  2 Mar 2014 23:08:57 +0900
Message-Id: <1393769338-3506-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Implement preallocation via the fallocate syscall on VFAT partitions.
This patch is based on an earlier patch of the same name which had some
issues detailed below and did not get accepted.  Refer
https://lkml.org/lkml/2007/12/22/130.

a) The preallocated space was not persistent when the
FALLOC_FL_KEEP_SIZE flag was set. It will deallocate cluster at evict time.

b) There was no need to zero out the clusters when the flag was set
Instead of doing an expanding truncate, just allocate clusters and add
them to the fat chain. This reduces preallocation time.

Compatibility with windows:

There are no issues when FALLOC_FL_KEEP_SIZE is not set because it just
does an expanding truncate.  Thus reading from the preallocated area on
windows returns null until data is written to it.

When a file with preallocated area using the FALLOC_FL_KEEP_SIZE was
written to on windows, the windows driver freed-up the preallocated
clusters and allocated new clusters for the new data.  The freed up
clusters gets reflected in the free space available for the partition
which can be seen from the Volume properties.

The windows chkdsk tool also does not report any errors on a disk
containing files with preallocated space.

And there is also no issue using linux fat fsck.  because discard
preallocated clusters at repair time.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/file.c  | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/inode.c | 22 +++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 0bf0d28..e33c8a2 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -17,8 +17,12 @@
 #include <linux/blkdev.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 #include "fat.h"
 
+static long fat_fallocate(struct file *file, int mode,
+			  loff_t offset, loff_t len);
+
 static int fat_ioctl_get_attributes(struct inode *inode, u32 __user *user_attr)
 {
 	u32 attr;
@@ -182,6 +186,7 @@ const struct file_operations fat_file_operations = {
 #endif
 	.fsync		= fat_file_fsync,
 	.splice_read	= generic_file_splice_read,
+	.fallocate	= fat_fallocate,
 };
 
 static int fat_cont_expand(struct inode *inode, loff_t size)
@@ -220,6 +225,75 @@ out:
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
+			  loff_t offset, loff_t len)
+{
+	int cluster;
+	int nr_cluster; /* Number of clusters to be allocated */
+	loff_t mm_bytes; /* Number of bytes to be allocated for file */
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int err = 0;
+
+	/* No support for hole punch or other fallocate flags. */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	/* No support for dir */
+	if (!S_ISREG(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&inode->i_mutex);
+	if ((offset + len) <= MSDOS_I(inode)->i_disksize)
+		goto error;
+
+	err = inode_newsize_ok(inode, (len + offset));
+	if (err)
+		goto error;
+
+	if (mode & FALLOC_FL_KEEP_SIZE) {
+		/* First compute the number of clusters to be allocated */
+		mm_bytes = offset + len - round_up(MSDOS_I(inode)->i_disksize,
+			sbi->cluster_size);
+		nr_cluster = (mm_bytes + (sbi->cluster_size - 1)) >>
+			sbi->cluster_bits;
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
+			MSDOS_I(inode)->i_disksize += sbi->cluster_size;
+		}
+	} else {
+		/* This is just an expanding truncate */
+		err = fat_cont_expand(inode, (offset + len));
+		if (err)
+			fat_msg(sb, KERN_ERR,
+				"fat_fallocate(): fat_cont_expand() error");
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
index a3b9fe8..ca222ef 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -492,12 +492,34 @@ out:
 
 EXPORT_SYMBOL_GPL(fat_build_inode);
 
+static int __fat_write_inode(struct inode *inode, int wait);
 static void fat_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
+	} else {
+		/* Release unwritten fallocated blocks on inode eviction. */
+		if (MSDOS_I(inode)->i_disksize >
+		    round_up(MSDOS_I(inode)->mmu_private,
+				inode->i_sb->s_blocksize)) {
+			int err;
+			fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
+			/* Fallocate results in updating the i_start/iogstart
+			 * for the zero byte file. So, make it return to
+			 * original state during evict and commit it to avoid
+			 * any corruption on the next access to the cluster
+			 * chain for the file.
+			 */
+			err = __fat_write_inode(inode, inode_needs_sync(inode));
+			if (err) {
+				fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
+				"update on disk inode for unused fallocated "
+				"blocks, inode could be corrupted. Please run "
+				"fsck");
+			}
+		}
 	}
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
1.7.11-rc0


