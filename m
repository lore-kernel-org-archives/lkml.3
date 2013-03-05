Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3CELs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:48:58 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54257 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3CELr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:47:58 -0500
X-AuditID: 9c93016f-b7b46ae000000e4b-53-5135db6d722a
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org
Cc: Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [PATCH v3 -next 2/5] lib: Add support for LZ4-compressed kernel
Date: Tue,  5 Mar 2013 20:47:33 +0900
Message-Id: <1362484056-9778-3-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for extracting LZ4-compressed kernel images,
as well as LZ4-compressed ramdisk images in the kernel boot process.

This depends on the patch below
decompressor: Add LZ4 decompressor module

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>

v2:
- Clean up code
- Use lz4_decompress() for LZ4-compressed kernel during boot-process
v3:
- Use an inline function instead of macro to prevent double evaluation
- Add LZ4 description and note for uncompressed chunk size
---
 include/linux/decompress/unlz4.h |  10 +++
 init/Kconfig                     |  17 +++-
 lib/Kconfig                      |   7 ++
 lib/Makefile                     |   2 +
 lib/decompress.c                 |   5 ++
 lib/decompress_unlz4.c           | 187 +++++++++++++++++++++++++++++++++++++++
 lib/lz4/Makefile                 |   1 +
 lib/lz4/lz4_decompress.c         |   2 +-
 scripts/Makefile.lib             |   5 ++
 usr/Kconfig                      |   9 ++
 10 files changed, 243 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/decompress/unlz4.h
 create mode 100644 lib/decompress_unlz4.c
 create mode 100644 lib/lz4/Makefile

diff --git a/include/linux/decompress/unlz4.h b/include/linux/decompress/unlz4.h
new file mode 100644
index 0000000..d5b68bf
--- /dev/null
+++ b/include/linux/decompress/unlz4.h
@@ -0,0 +1,10 @@
+#ifndef DECOMPRESS_UNLZ4_H
+#define DECOMPRESS_UNLZ4_H
+
+int unlz4(unsigned char *inbuf, int len,
+	int(*fill)(void*, unsigned int),
+	int(*flush)(void*, unsigned int),
+	unsigned char *output,
+	int *pos,
+	void(*error)(char *x));
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index be8b7f5..fc8eb1f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -133,10 +133,13 @@ config HAVE_KERNEL_XZ
 config HAVE_KERNEL_LZO
 	bool
 
+config HAVE_KERNEL_LZ4
+	bool
+
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -203,6 +206,18 @@ config KERNEL_LZO
 	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
+config KERNEL_LZ4
+	bool "LZ4"
+	depends on HAVE_KERNEL_LZ4
+	help
+	  LZ4 is an LZ77-type compressor with a fixed, byte-oriented encoding.
+	  A preliminary version of LZ4 de/compression tool is available at
+	  <https://code.google.com/p/lz4/>.
+
+	  Its compression ratio is worse than LZO. The size of the kernel
+	  is about 8% bigger than LZO. But the decompression speed is
+	  faster than LZO.
+
 endchoice
 
 config DEFAULT_HOSTNAME
diff --git a/lib/Kconfig b/lib/Kconfig
index 75cdb77..b108047 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -189,6 +189,9 @@ config LZO_COMPRESS
 config LZO_DECOMPRESS
 	tristate
 
+config LZ4_DECOMPRESS
+	tristate
+
 source "lib/xz/Kconfig"
 
 #
@@ -213,6 +216,10 @@ config DECOMPRESS_LZO
 	select LZO_DECOMPRESS
 	tristate
 
+config DECOMPRESS_LZ4
+	select LZ4_DECOMPRESS
+	tristate
+
 #
 # Generic allocator support is selected if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 02ed6c0..c2073bf 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
 obj-$(CONFIG_BCH) += bch.o
 obj-$(CONFIG_LZO_COMPRESS) += lzo/
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
+obj-$(CONFIG_LZ4_DECOMPRESS) += lz4/
 obj-$(CONFIG_XZ_DEC) += xz/
 obj-$(CONFIG_RAID6_PQ) += raid6/
 
@@ -80,6 +81,7 @@ lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
 lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 lib-$(CONFIG_DECOMPRESS_XZ) += decompress_unxz.o
 lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
+lib-$(CONFIG_DECOMPRESS_LZ4) += decompress_unlz4.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff --git a/lib/decompress.c b/lib/decompress.c
index 31a8042..c70810e 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -11,6 +11,7 @@
 #include <linux/decompress/unxz.h>
 #include <linux/decompress/inflate.h>
 #include <linux/decompress/unlzo.h>
+#include <linux/decompress/unlz4.h>
 
 #include <linux/types.h>
 #include <linux/string.h>
@@ -31,6 +32,9 @@
 #ifndef CONFIG_DECOMPRESS_LZO
 # define unlzo NULL
 #endif
+#ifndef CONFIG_DECOMPRESS_LZ4
+# define unlz4 NULL
+#endif
 
 struct compress_format {
 	unsigned char magic[2];
@@ -45,6 +49,7 @@ static const struct compress_format compressed_formats[] __initdata = {
 	{ {0x5d, 0x00}, "lzma", unlzma },
 	{ {0xfd, 0x37}, "xz", unxz },
 	{ {0x89, 0x4c}, "lzo", unlzo },
+	{ {0x02, 0x21}, "lz4", unlz4 },
 	{ {0, 0}, NULL, NULL }
 };
 
diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
new file mode 100644
index 0000000..3e67cfa
--- /dev/null
+++ b/lib/decompress_unlz4.c
@@ -0,0 +1,187 @@
+/*
+ * Wrapper for decompressing LZ4-compressed kernel, initramfs, and initrd
+ *
+ * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef STATIC
+#define PREBOOT
+#include "lz4/lz4_decompress.c"
+#else
+#include <linux/decompress/unlz4.h>
+#endif
+#include <linux/types.h>
+#include <linux/lz4.h>
+#include <linux/decompress/mm.h>
+#include <linux/compiler.h>
+
+#include <asm/unaligned.h>
+
+/*
+ * Note: Uncompressed chunk size is used in the compressor side
+ * (userspace side for compression).
+ * It is hardcoded because there is not proper way to extract it
+ * from the binary stream which is generated by the preliminary
+ * version of LZ4 tool so far.
+ */
+#define LZ4_DEFAULT_UNCOMPRESSED_CHUNK_SIZE (8 << 20)
+#define ARCHIVE_MAGICNUMBER 0x184C2102
+
+STATIC inline int INIT unlz4(u8 *input, int in_len,
+				int (*fill) (void *, unsigned int),
+				int (*flush) (void *, unsigned int),
+				u8 *output, int *posp,
+				void (*error) (char *x))
+{
+	int ret = -1;
+	size_t chunksize = 0;
+	size_t uncomp_chunksize = LZ4_DEFAULT_UNCOMPRESSED_CHUNK_SIZE;
+	u8 *inp;
+	u8 *inp_start;
+	u8 *outp;
+	int size = in_len;
+#ifdef PREBOOT
+	size_t out_len = get_unaligned_le32(input + in_len);
+#endif
+	size_t dest_len;
+
+
+	if (output) {
+		outp = output;
+	} else if (!flush) {
+		error("NULL output pointer and no flush function provided");
+		goto exit_0;
+	} else {
+		outp = large_malloc(uncomp_chunksize);
+		if (!outp) {
+			error("Could not allocate output buffer");
+			goto exit_0;
+		}
+	}
+
+	if (input && fill) {
+		error("Both input pointer and fill function provided,");
+		goto exit_1;
+	} else if (input) {
+		inp = input;
+	} else if (!fill) {
+		error("NULL input pointer and missing fill function");
+		goto exit_1;
+	} else {
+		inp = large_malloc(lz4_compressbound(uncomp_chunksize));
+		if (!inp) {
+			error("Could not allocate input buffer");
+			goto exit_1;
+		}
+	}
+	inp_start = inp;
+
+	if (posp)
+		*posp = 0;
+
+	if (fill)
+		fill(inp, 4);
+
+	chunksize = get_unaligned_le32(inp);
+	if (chunksize == ARCHIVE_MAGICNUMBER) {
+		inp += 4;
+		size -= 4;
+	} else {
+		error("invalid header");
+		goto exit_2;
+	}
+
+	if (posp)
+		*posp += 4;
+
+	for (;;) {
+
+		if (fill)
+			fill(inp, 4);
+
+		chunksize = get_unaligned_le32(inp);
+		if (chunksize == ARCHIVE_MAGICNUMBER) {
+			inp += 4;
+			size -= 4;
+			if (posp)
+				*posp += 4;
+			continue;
+		}
+		inp += 4;
+		size -= 4;
+
+		if (posp)
+			*posp += 4;
+
+		if (fill) {
+			if (chunksize > lz4_compressbound(uncomp_chunksize)) {
+				error("chunk length is longer than allocated");
+				goto exit_2;
+			}
+			fill(inp, chunksize);
+		}
+#ifdef PREBOOT
+		if (out_len >= uncomp_chunksize) {
+			dest_len = uncomp_chunksize;
+			out_len -= dest_len;
+		} else
+			dest_len = out_len;
+		ret = lz4_decompress(inp, &chunksize, outp, dest_len);
+#else
+		dest_len = uncomp_chunksize;
+		ret = lz4_decompress_unknownoutputsize(inp, chunksize, outp,
+				&dest_len);
+#endif
+		if (ret < 0) {
+			error("Decoding failed");
+			goto exit_2;
+		}
+
+		if (flush && flush(outp, dest_len) != dest_len)
+			goto exit_2;
+		if (output)
+			outp += dest_len;
+		if (posp)
+			*posp += chunksize;
+
+		size -= chunksize;
+
+		if (size == 0)
+			break;
+		else if (size < 0) {
+			error("data corrupted");
+			goto exit_2;
+		}
+
+		inp += chunksize;
+		if (fill)
+			inp = inp_start;
+	}
+
+	ret = 0;
+exit_2:
+	if (!input)
+		large_free(inp_start);
+exit_1:
+	if (!output)
+		large_free(outp);
+exit_0:
+	return ret;
+}
+
+#ifdef PREBOOT
+STATIC int INIT decompress(unsigned char *buf, int in_len,
+			      int(*fill)(void*, unsigned int),
+			      int(*flush)(void*, unsigned int),
+			      unsigned char *output,
+			      int *posp,
+			      void(*error)(char *x)
+	)
+{
+	return unlz4(buf, in_len - 4, fill, flush, output, posp, error);
+}
+#endif
diff --git a/lib/lz4/Makefile b/lib/lz4/Makefile
new file mode 100644
index 0000000..7f548c6
--- /dev/null
+++ b/lib/lz4/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_LZ4_DECOMPRESS) += lz4_decompress.o
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index dcc8975..d3414ea 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -1,7 +1,7 @@
 /*
  * LZ4 Decompressor for Linux kernel
  *
- * Copyright (C) 2013 LG Electronics Co., Ltd. (http://www.lge.com/)
+ * Copyright (C) 2013, LG Electronics, Kyungsik Lee <kyungsik.lee@lge.com>
  *
  * Based on LZ4 implementation by Yann Collet.
  *
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index bdf42fd..a21a5ad 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -307,6 +307,11 @@ cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
 
+quiet_cmd_lz4 = LZ4     $@
+cmd_lz4 = (cat $(filter-out FORCE,$^) | \
+	lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
+
 # U-Boot mkimage
 # ---------------------------------------------------------------------------
 
diff --git a/usr/Kconfig b/usr/Kconfig
index 085872b..642f503 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -90,6 +90,15 @@ config RD_LZO
 	  Support loading of a LZO encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
+config RD_LZ4
+	bool "Support initial ramdisks compressed using LZ4" if EXPERT
+	default !EXPERT
+	depends on BLK_DEV_INITRD
+	select DECOMPRESS_LZ4
+	help
+	  Support loading of a LZ4 encoded initial ramdisk or cpio buffer
+	  If unsure, say N.
+
 choice
 	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
 	help
-- 
1.8.1.1

