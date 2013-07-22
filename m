Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3GVC3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 22:29:19 -0400
Received: from mdfmta010.mxout.tbr.inty.net ([91.221.168.51]:56983 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754928Ab3GVC3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 22:29:15 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-embedded@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 2/2] Squashfs: Add LZ4 compression configuration option
Date: Mon, 22 Jul 2013 03:21:03 +0100
Message-Id: <1374459663-15363-3-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
References: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the glue code, and also update the documentation.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 Documentation/filesystems/squashfs.txt |    8 ++++----
 fs/squashfs/Kconfig                    |   15 +++++++++++++++
 fs/squashfs/Makefile                   |    1 +
 fs/squashfs/decompressor.c             |    7 +++++++
 fs/squashfs/decompressor.h             |    4 ++++
 5 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/squashfs.txt b/Documentation/filesystems/squashfs.txt
index 403c090..e5274f8 100644
--- a/Documentation/filesystems/squashfs.txt
+++ b/Documentation/filesystems/squashfs.txt
@@ -2,10 +2,10 @@ SQUASHFS 4.0 FILESYSTEM
 =======================
 
 Squashfs is a compressed read-only filesystem for Linux.
-It uses zlib/lzo/xz compression to compress files, inodes and directories.
-Inodes in the system are very small and all blocks are packed to minimise
-data overhead. Block sizes greater than 4K are supported up to a maximum
-of 1Mbytes (default block size 128K).
+It uses zlib, lz4, lzo, or xz compression to compress files, inodes and
+directories.  Inodes in the system are very small and all blocks are packed to
+minimise data overhead. Block sizes greater than 4K are supported up to a
+maximum of 1Mbytes (default block size 128K).
 
 Squashfs is intended for general read-only filesystem use, for archival
 use (i.e. in cases where a .tar.gz file may be used), and in constrained
diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index c70111e..257f934 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -48,6 +48,21 @@ config SQUASHFS_ZLIB
 
 	  If unsure, say Y.
 
+config SQUASHFS_LZ4
+	bool "Include support for LZ4 compressed file systems"
+	depends on SQUASHFS
+	select LZ4_DECOMPRESS
+	help
+	  Saying Y here includes support for reading Squashfs file systems
+	  compressed with LZ4 compression.  LZ4 compression is mainly
+	  aimed at embedded systems with slower CPUs where the overheads
+	  of zlib are too high.
+
+	  LZ4 is not the standard compression used in Squashfs and so most
+	  file systems will be readable without selecting this option.
+
+	  If unsure, say N.
+
 config SQUASHFS_LZO
 	bool "Include support for LZO compressed file systems"
 	depends on SQUASHFS
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index 110b047..4a80ca7 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_SQUASHFS) += squashfs.o
 squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
 squashfs-y += namei.o super.o symlink.o decompressor.o
 squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
+squashfs-$(CONFIG_SQUASHFS_LZ4) += lz4_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index 3f6271d..ae60211 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -40,6 +40,12 @@ static const struct squashfs_decompressor squashfs_lzma_unsupported_comp_ops = {
 	NULL, NULL, NULL, LZMA_COMPRESSION, "lzma", 0
 };
 
+#ifndef CONFIG_SQUASHFS_LZ4
+static const struct squashfs_decompressor squashfs_lz4_comp_ops = {
+	NULL, NULL, NULL, LZ4_COMPRESSION, "lz4", 0
+};
+#endif
+
 #ifndef CONFIG_SQUASHFS_LZO
 static const struct squashfs_decompressor squashfs_lzo_comp_ops = {
 	NULL, NULL, NULL, LZO_COMPRESSION, "lzo", 0
@@ -64,6 +70,7 @@ static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
 
 static const struct squashfs_decompressor *decompressor[] = {
 	&squashfs_zlib_comp_ops,
+	&squashfs_lz4_comp_ops,
 	&squashfs_lzo_comp_ops,
 	&squashfs_xz_comp_ops,
 	&squashfs_lzma_unsupported_comp_ops,
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 330073e..a9fbdd2 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -52,6 +52,10 @@ static inline int squashfs_decompress(struct squashfs_sb_info *msblk,
 extern const struct squashfs_decompressor squashfs_xz_comp_ops;
 #endif
 
+#ifdef CONFIG_SQUASHFS_LZ4
+extern const struct squashfs_decompressor squashfs_lz4_comp_ops;
+#endif
+
 #ifdef CONFIG_SQUASHFS_LZO
 extern const struct squashfs_decompressor squashfs_lzo_comp_ops;
 #endif
-- 
1.7.10.4

