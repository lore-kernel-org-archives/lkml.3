Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3GACmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 22:42:37 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50230 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3GACmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 22:42:35 -0400
From: bintian.wang@linaro.org
To: linux-kernel@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>,
        dmitry pervushin <dpervushin@gmail.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bintian Wang <bintian.wang@linaro.org>
Subject: [PATCH RFC] Add FAT_IOCTL_GET_VOLUME_ID
Date: Mon,  1 Jul 2013 10:39:58 +0800
Message-Id: <1372646398-4204-1-git-send-email-bintian.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Lockwood <lockwood@android.com>

This patch, originally from Android kernel, adds vfat directory ioctl command
FAT_IOCTL_GET_VOLUME_ID, with this command we can get the vfat volume ID using
following code:

	ioctl(dirfd(dir), FAT_IOCTL_GET_VOLUME_ID, &volume_ID)

This patch is a modified version of the patch by Mike Lockwood, with changes
from Dmitry Pervushin, who noticed the original patch makes some volume IDs
abiguous with error returns: for example, if volume id is 0xFFFFFDAD, that
matches -ENOIOCTLCMD, we get "FFFFFFFF" from the user space.

So add a parameter to ioctl to get the correct volume ID.

Cc: dmitry pervushin <dpervushin@gmail.com>
Cc: Mike Lockwood <lockwood@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>

Signed-off-by: Bintian Wang <bintian.wang@linaro.org>
---
 fs/fat/dir.c                  |   14 ++++++++++++++
 fs/fat/fat.h                  |    1 +
 fs/fat/inode.c                |    9 +++++++++
 include/uapi/linux/msdos_fs.h |   13 +++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 7a6f02c..4c59108 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -776,12 +776,19 @@ static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 	return ret;
 }
 
+static unsigned int fat_ioctl_volume_id(struct inode *inode)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	return sbi->vol_id;
+}
+
 static long fat_dir_ioctl(struct file *filp, unsigned int cmd,
 			  unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	struct __fat_dirent __user *d1 = (struct __fat_dirent __user *)arg;
 	int short_only, both;
+	unsigned int id;
 
 	switch (cmd) {
 	case VFAT_IOCTL_READDIR_SHORT:
@@ -792,6 +799,9 @@ static long fat_dir_ioctl(struct file *filp, unsigned int cmd,
 		short_only = 0;
 		both = 1;
 		break;
+	case FAT_IOCTL_GET_VOLUME_ID:
+		id = fat_ioctl_volume_id(inode);
+		return copy_to_user((unsigned int *)arg, &id, sizeof(id));
 	default:
 		return fat_generic_ioctl(filp, cmd, arg);
 	}
@@ -822,6 +832,7 @@ static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
 	struct inode *inode = file_inode(filp);
 	struct compat_dirent __user *d1 = compat_ptr(arg);
 	int short_only, both;
+	unsigned int id;
 
 	switch (cmd) {
 	case VFAT_IOCTL_READDIR_SHORT32:
@@ -832,6 +843,9 @@ static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
 		short_only = 0;
 		both = 1;
 		break;
+	case FAT_IOCTL_GET_VOLUME_ID:
+		id = fat_ioctl_volume_id(inode);
+		return copy_to_user((unsigned int *)arg, &id, sizeof(id));
 	default:
 		return fat_generic_ioctl(filp, cmd, (unsigned long)arg);
 	}
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 21664fc..4241e6f 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -86,6 +86,7 @@ struct msdos_sb_info {
 	const void *dir_ops;	      /* Opaque; default directory operations */
 	int dir_per_block;	      /* dir entries per block */
 	int dir_per_block_bits;	      /* log2(dir_per_block) */
+	unsigned int vol_id;		/*volume ID*/
 
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5d4513c..a14dd4c 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1252,6 +1252,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	struct inode *fsinfo_inode = NULL;
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
+	struct fat_boot_bsx *bsx;
 	struct msdos_sb_info *sbi;
 	u16 logical_sector_size;
 	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
@@ -1398,6 +1399,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 			goto out_fail;
 		}
 
+		bsx = (struct fat_boot_bsx *)(bh->b_data + FAT32_BSX_OFFSET);
+
 		fsinfo = (struct fat_boot_fsinfo *)fsinfo_bh->b_data;
 		if (!IS_FSINFO(fsinfo)) {
 			fat_msg(sb, KERN_WARNING, "Invalid FSINFO signature: "
@@ -1413,8 +1416,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		}
 
 		brelse(fsinfo_bh);
+	} else {
+		bsx = (struct fat_boot_bsx *)(bh->b_data + FAT16_BSX_OFFSET);
 	}
 
+	/* interpret volume ID as a little endian 32 bit integer */
+	sbi->vol_id = (((u32)bsx->vol_id[0]) | ((u32)bsx->vol_id[1] << 8) |
+		((u32)bsx->vol_id[2] << 16) | ((u32)bsx->vol_id[3] << 24));
+
 	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
diff --git a/include/uapi/linux/msdos_fs.h b/include/uapi/linux/msdos_fs.h
index f055e58..be142ee 100644
--- a/include/uapi/linux/msdos_fs.h
+++ b/include/uapi/linux/msdos_fs.h
@@ -104,6 +104,8 @@ struct __fat_dirent {
 /* <linux/videotext.h> has used 0x72 ('r') in collision, so skip a few */
 #define FAT_IOCTL_GET_ATTRIBUTES	_IOR('r', 0x10, __u32)
 #define FAT_IOCTL_SET_ATTRIBUTES	_IOW('r', 0x11, __u32)
+/*Android kernel has used 0x12, so we use 0x13*/
+#define FAT_IOCTL_GET_VOLUME_ID		_IOR('r', 0x13, __u32)
 
 struct fat_boot_sector {
 	__u8	ignored[3];	/* Boot strap short or near jump */
@@ -161,6 +163,17 @@ struct fat_boot_fsinfo {
 	__le32   reserved2[4];
 };
 
+struct fat_boot_bsx {
+	__u8     drive;     /* drive number */
+	__u8     reserved1;
+	__u8     signature; /* extended boot signature */
+	__u8     vol_id[4]; /* volume ID */
+	__u8     vol_label[11]; /* volume label */
+	__u8     type[8];   /* file system type */
+};
+#define FAT16_BSX_OFFSET 36 /* offset of fat_boot_bsx in FAT12 and FAT16 */
+#define FAT32_BSX_OFFSET 64 /* offset of fat_boot_bsx in FAT32 */
+
 struct msdos_dir_entry {
 	__u8	name[MSDOS_NAME];/* name and extension */
 	__u8	attr;		/* attribute bits */
-- 
1.7.9.5

