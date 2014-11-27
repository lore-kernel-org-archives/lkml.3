Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaK0TE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:04:56 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:60861 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbaK0TEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:04:54 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: texstar@gmail.com, martin@mvath.de, guanx.bac@gmail.com, bruno@wolff.to,
        dave@vasilevsky.ca, szycha@gmail.com, blyons@students.naropa.edu,
        tokiclover@gmail.com, afm404@gmail.com, hugochevrain@gmail.com,
        Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 2/2 V2] Squashfs: Add LZ4 compression configuration option
Date: Thu, 27 Nov 2014 19:04:29 +0000
Message-Id: <1417115069-6688-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the glue code, and also update the documentation.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---

V2 patch: when porting the code to the latest -rc I forgot to update the
case where CONFIG_SQUASHFS_LZ4 is not defined, leading to a build error.

Trivial change:

+#ifndef CONFIG_SQUASHFS_LZ4
+static const struct squashfs_decompressor squashfs_lz4_comp_ops = {
+	NULL, NULL, NULL, LZ4_COMPRESSION, "lz4", 0

should be

+#ifndef CONFIG_SQUASHFS_LZ4
+static const struct squashfs_decompressor squashfs_lz4_comp_ops = {
+	NULL, NULL, NULL, NULL, LZ4_COMPRESSION, "lz4", 0

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
index b6fa865..ffb093e 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -120,6 +120,21 @@ config SQUASHFS_ZLIB
 
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
index 4132520..246a6f3 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -11,6 +11,7 @@ squashfs-$(CONFIG_SQUASHFS_DECOMP_SINGLE) += decompressor_single.o
 squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI) += decompressor_multi.o
 squashfs-$(CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU) += decompressor_multi_percpu.o
 squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
+squashfs-$(CONFIG_SQUASHFS_LZ4) += lz4_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index ac22fe7..e9034bf 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -41,6 +41,12 @@ static const struct squashfs_decompressor squashfs_lzma_unsupported_comp_ops = {
 	NULL, NULL, NULL, NULL, LZMA_COMPRESSION, "lzma", 0
 };
 
+#ifndef CONFIG_SQUASHFS_LZ4
+static const struct squashfs_decompressor squashfs_lz4_comp_ops = {
+	NULL, NULL, NULL, NULL, LZ4_COMPRESSION, "lz4", 0
+};
+#endif
+
 #ifndef CONFIG_SQUASHFS_LZO
 static const struct squashfs_decompressor squashfs_lzo_comp_ops = {
 	NULL, NULL, NULL, NULL, LZO_COMPRESSION, "lzo", 0
@@ -65,6 +71,7 @@ static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
 
 static const struct squashfs_decompressor *decompressor[] = {
 	&squashfs_zlib_comp_ops,
+	&squashfs_lz4_comp_ops,
 	&squashfs_lzo_comp_ops,
 	&squashfs_xz_comp_ops,
 	&squashfs_lzma_unsupported_comp_ops,
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index af09853..a25713c 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -46,6 +46,10 @@ static inline void *squashfs_comp_opts(struct squashfs_sb_info *msblk,
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

