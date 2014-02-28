Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaB1R4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:56:19 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46252 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaB1Rz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:55:57 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv9 7/7] zram: add lz4 algorithm backend
Date: Fri, 28 Feb 2014 20:52:07 +0300
Message-Id: <1393609927-22090-8-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.359.g5e34a15
In-Reply-To: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce LZ4 compression backend and make it available for selection.
LZ4 support is optional and requires user to set ZRAM_LZ4_COMPRESS
config option. The default compression backend is LZO.

TEST

(x86_64, core i5, 2 cores + 2 hyperthreading, zram disk size 1G,
ext4 file system, 3 compression streams)

iozone -t 3 -R -r 16K -s 60M -I +Z

       Test           LZO           LZ4
----------------------------------------------
  Initial write   1642744.62    1317005.09
        Rewrite   2498980.88    1800645.16
           Read   3957026.38    5877043.75
        Re-read   3950997.38    5861847.00
   Reverse Read   2937114.56    5047384.00
    Stride read   2948163.19    4929587.38
    Random read   3292692.69    4880793.62
 Mixed workload   1545602.62    3502940.38
   Random write   2448039.75    1758786.25
         Pwrite   1670051.03    1338329.69
          Pread   2530682.00    5097177.62
         Fwrite   3232085.62    3275942.56
          Fread   6306880.25    6645271.12

So on my system LZ4 is slower in write-only tests, while it performs
better in read-only and mixed (reads + writes) tests.

Official LZ4 benchmarks available here http://code.google.com/p/lz4/
(linux kernel uses revision r90).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/Kconfig     | 10 +++++++++
 drivers/block/zram/Makefile    |  2 ++
 drivers/block/zram/zcomp.c     |  6 ++++++
 drivers/block/zram/zcomp_lz4.c | 47 ++++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp_lz4.h | 17 +++++++++++++++
 5 files changed, 82 insertions(+)
 create mode 100644 drivers/block/zram/zcomp_lz4.c
 create mode 100644 drivers/block/zram/zcomp_lz4.h

diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 3450be8..6489c0f 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -15,6 +15,16 @@ config ZRAM
 
 	  See zram.txt for more information.
 
+config ZRAM_LZ4_COMPRESS
+	bool "Enable LZ4 algorithm support"
+	depends on ZRAM
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	default n
+	help
+	  This option enables LZ4 compression algorithm support. Compression
+	  algorithm can be changed using `comp_algorithm' device attribute.
+
 config ZRAM_DEBUG
 	bool "Compressed RAM block device debug support"
 	depends on ZRAM
diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index 757c6a5..be0763f 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -1,3 +1,5 @@
 zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
 
+zram-$(CONFIG_ZRAM_LZ4_COMPRESS) += zcomp_lz4.o
+
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index aad533a..d591903 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -15,6 +15,9 @@
 
 #include "zcomp.h"
 #include "zcomp_lzo.h"
+#ifdef CONFIG_ZRAM_LZ4_COMPRESS
+#include "zcomp_lz4.h"
+#endif
 
 /*
  * single zcomp_strm backend
@@ -41,6 +44,9 @@ struct zcomp_strm_multi {
 
 static struct zcomp_backend *backends[] = {
 	&zcomp_lzo,
+#ifdef CONFIG_ZRAM_LZ4_COMPRESS
+	&zcomp_lz4,
+#endif
 	NULL
 };
 
diff --git a/drivers/block/zram/zcomp_lz4.c b/drivers/block/zram/zcomp_lz4.c
new file mode 100644
index 0000000..f2afb7e
--- /dev/null
+++ b/drivers/block/zram/zcomp_lz4.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/lz4.h>
+
+#include "zcomp_lz4.h"
+
+static void *zcomp_lz4_create(void)
+{
+	return kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void zcomp_lz4_destroy(void *private)
+{
+	kfree(private);
+}
+
+static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
+		size_t *dst_len, void *private)
+{
+	/* return  : Success if return 0 */
+	return lz4_compress(src, PAGE_SIZE, dst, dst_len, private);
+}
+
+static int zcomp_lz4_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst)
+{
+	size_t dst_len = PAGE_SIZE;
+	/* return  : Success if return 0 */
+	return lz4_decompress_unknownoutputsize(src, src_len, dst, &dst_len);
+}
+
+struct zcomp_backend zcomp_lz4 = {
+	.compress = zcomp_lz4_compress,
+	.decompress = zcomp_lz4_decompress,
+	.create = zcomp_lz4_create,
+	.destroy = zcomp_lz4_destroy,
+	.name = "lz4",
+};
diff --git a/drivers/block/zram/zcomp_lz4.h b/drivers/block/zram/zcomp_lz4.h
new file mode 100644
index 0000000..60613fb
--- /dev/null
+++ b/drivers/block/zram/zcomp_lz4.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_LZ4_H_
+#define _ZCOMP_LZ4_H_
+
+#include "zcomp.h"
+
+extern struct zcomp_backend zcomp_lz4;
+
+#endif /* _ZCOMP_LZ4_H_ */
-- 
1.9.0.359.g5e34a15

