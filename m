Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab3IFEDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:03:20 -0400
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:47142 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750730Ab3IFEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:03:14 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 5/5] Squashfs: add corruption check for type in squashfs_readdir()
Date: Fri,  6 Sep 2013 04:54:41 +0100
Message-Id: <1378439682-12830-6-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
References: <1378439682-12830-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We read the type field from disk.  This value should be sanity
checked for correctness to avoid an out of bounds access when
reading the squashfs_filetype_table array.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/dir.c         | 7 +++++--
 fs/squashfs/squashfs_fs.h | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index bd7155b..d8c2d74 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -112,8 +112,8 @@ static int squashfs_readdir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	u64 block = squashfs_i(inode)->start + msblk->directory_table;
-	int offset = squashfs_i(inode)->offset, length, type, err;
-	unsigned int inode_number, dir_count, size;
+	int offset = squashfs_i(inode)->offset, length, err;
+	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire;
 
@@ -206,6 +206,9 @@ static int squashfs_readdir(struct file *file, struct dir_context *ctx)
 				((short) le16_to_cpu(dire->inode_number));
 			type = le16_to_cpu(dire->type);
 
+			if (type > SQUASHFS_MAX_DIR_TYPE)
+				goto failed_read;
+
 			if (!dir_emit(ctx, dire->name, size,
 					inode_number,
 					squashfs_filetype_table[type]))
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 9e2349d..4b2beda 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -87,7 +87,7 @@
 #define SQUASHFS_COMP_OPTS(flags)		SQUASHFS_BIT(flags, \
 						SQUASHFS_COMP_OPT)
 
-/* Max number of types and file types */
+/* Inode types including extended types */
 #define SQUASHFS_DIR_TYPE		1
 #define SQUASHFS_REG_TYPE		2
 #define SQUASHFS_SYMLINK_TYPE		3
@@ -103,6 +103,9 @@
 #define SQUASHFS_LFIFO_TYPE		13
 #define SQUASHFS_LSOCKET_TYPE		14
 
+/* Max type value stored in directory entry */
+#define SQUASHFS_MAX_DIR_TYPE		7
+
 /* Xattr types */
 #define SQUASHFS_XATTR_USER             0
 #define SQUASHFS_XATTR_TRUSTED          1
-- 
1.8.3.2

