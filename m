Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaBWRGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 12:06:46 -0500
Received: from sh.osrg.net ([192.16.179.4]:42806 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaBWRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 12:06:42 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/3] nilfs2: verify metadata sizes read from disk
Date: Mon, 24 Feb 2014 01:58:41 +0900
Message-Id: <1393174721-27246-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1393174721-27246-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1393174721-27246-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Mon, 24 Feb 2014 02:06:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to check sizes of on-disk data of metadata files such as
inode size, segment usage size, DAT entry size, and checkpoint size.
Although these sizes are read from disk, the current implementation
doesn't check them.

If these sizes are not sane on disk, it can cause out-of-range access
to metadata or memory access overrun on metadata block buffers due to
overflow in sundry calculations.

Both lower limit and upper limit of metadata sizes are verified to
prevent these issues.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c        |   12 ++++++++++++
 fs/nilfs2/dat.c           |   12 ++++++++++++
 fs/nilfs2/sufile.c        |   12 ++++++++++++
 fs/nilfs2/the_nilfs.c     |   10 ++++++++++
 include/linux/nilfs2_fs.h |    8 ++++++++
 5 files changed, 54 insertions(+)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index deaa3d3..0d58075 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -942,6 +942,18 @@ int nilfs_cpfile_read(struct super_block *sb, size_t cpsize,
 	struct inode *cpfile;
 	int err;
 
+	if (cpsize > sb->s_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: too large checkpoint size: %zu bytes.\n",
+		       cpsize);
+		return -EINVAL;
+	} else if (cpsize < NILFS_MIN_CHECKPOINT_SIZE) {
+		printk(KERN_ERR
+		       "NILFS: too small checkpoint size: %zu bytes.\n",
+		       cpsize);
+		return -EINVAL;
+	}
+
 	cpfile = nilfs_iget_locked(sb, NULL, NILFS_CPFILE_INO);
 	if (unlikely(!cpfile))
 		return -ENOMEM;
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index fa0f803..0d5fada 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -484,6 +484,18 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	struct nilfs_dat_info *di;
 	int err;
 
+	if (entry_size > sb->s_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: too large DAT entry size: %zu bytes.\n",
+		       entry_size);
+		return -EINVAL;
+	} else if (entry_size < NILFS_MIN_DAT_ENTRY_SIZE) {
+		printk(KERN_ERR
+		       "NILFS: too small DAT entry size: %zu bytes.\n",
+		       entry_size);
+		return -EINVAL;
+	}
+
 	dat = nilfs_iget_locked(sb, NULL, NILFS_DAT_INO);
 	if (unlikely(!dat))
 		return -ENOMEM;
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 84e384d..2a869c3 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1169,6 +1169,18 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 	void *kaddr;
 	int err;
 
+	if (susize > sb->s_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: too large segment usage size: %zu bytes.\n",
+		       susize);
+		return -EINVAL;
+	} else if (susize < NILFS_MIN_SEGMENT_USAGE_SIZE) {
+		printk(KERN_ERR
+		       "NILFS: too small segment usage size: %zu bytes.\n",
+		       susize);
+		return -EINVAL;
+	}
+
 	sufile = nilfs_iget_locked(sb, NULL, NILFS_SUFILE_INO);
 	if (unlikely(!sufile))
 		return -ENOMEM;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 94c451c..8ba8229 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -399,6 +399,16 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 		return -EINVAL;
 
 	nilfs->ns_inode_size = le16_to_cpu(sbp->s_inode_size);
+	if (nilfs->ns_inode_size > nilfs->ns_blocksize) {
+		printk(KERN_ERR "NILFS: too large inode size: %d bytes.\n",
+		       nilfs->ns_inode_size);
+		return -EINVAL;
+	} else if (nilfs->ns_inode_size < NILFS_MIN_INODE_SIZE) {
+		printk(KERN_ERR "NILFS: too small inode size: %d bytes.\n",
+		       nilfs->ns_inode_size);
+		return -EINVAL;
+	}
+
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 1fb465f..ff3fea3 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -82,6 +82,8 @@ struct nilfs_inode {
 	__le32	i_pad;
 };
 
+#define NILFS_MIN_INODE_SIZE		128
+
 /**
  * struct nilfs_super_root - structure of super root
  * @sr_sum: check sum
@@ -482,6 +484,8 @@ struct nilfs_dat_entry {
 	__le64 de_rsv;
 };
 
+#define NILFS_MIN_DAT_ENTRY_SIZE	32
+
 /**
  * struct nilfs_snapshot_list - snapshot list
  * @ssl_next: next checkpoint number on snapshot list
@@ -520,6 +524,8 @@ struct nilfs_checkpoint {
 	struct nilfs_inode cp_ifile_inode;
 };
 
+#define NILFS_MIN_CHECKPOINT_SIZE	(64 + NILFS_MIN_INODE_SIZE)
+
 /* checkpoint flags */
 enum {
 	NILFS_CHECKPOINT_SNAPSHOT,
@@ -615,6 +621,8 @@ struct nilfs_segment_usage {
 	__le32 su_flags;
 };
 
+#define NILFS_MIN_SEGMENT_USAGE_SIZE	16
+
 /* segment usage flag */
 enum {
 	NILFS_SEGMENT_USAGE_ACTIVE,
-- 
1.7.9.3

