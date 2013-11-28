Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab3K1Bza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 20:55:30 -0500
Received: from meizuMX.meizu.com ([119.147.165.253]:5674 "EHLO
	MZ-Mail04.meizu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753338Ab3K1Bz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 20:55:27 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 20:55:26 EST
From: <falcon@meizu.com>
To: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: [RFC PATCH] ARM: compressed: Move ramdisk forward to reserve more memory for kernel image
Date: Thu, 28 Nov 2013 09:52:15 +0800
Message-ID: <1385603535-24391-1-git-send-email-falcon@meizu.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.179]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

During the booting of an embedded Linux system, before decompressing the kernel
image, the bootloader(E.g. Uboot) loads the compressed kernel image and ramdisk
image into two contiguous memory spaces, these two memory spaces are fixed
after the Uboot is released, as a result, the maximum size of the
(decompressed) kernel image is limited by the size of the reserved memory space
(the difference of the two contiguous memory addresses).

If want more functions or some debug options, the decompressed kernel image may
be bigger and may overwrite the followed ramdisk mage and result in kernel boot
failure for missing a valid ramdisk.

To fix up this issue, before decompressing the kernel image, this option moves
the loaded ramdisk image forward with a configurable offset and reserve more
memory for the decompressed kernel image.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/arm/boot/compressed/Makefile       |    2 +-
 arch/arm/boot/compressed/misc.c         |    7 ++--
 arch/arm/boot/compressed/move_ramdisk.c |   58 +++++++++++++++++++++++++++++++
 usr/Kconfig                             |   29 ++++++++++++++++
 4 files changed, 93 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/compressed/move_ramdisk.c

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index e7190bb..c215918 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -23,7 +23,7 @@ endif
 
 AFLAGS_head.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
 HEAD	= head.o
-OBJS	+= misc.o decompress.o
+OBJS	+= misc.o decompress.o move_ramdisk.o
 ifeq ($(CONFIG_DEBUG_UNCOMPRESS),y)
 OBJS	+= debug.o
 endif
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 31bd43b..27bac3c 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -22,7 +22,8 @@ unsigned int __machine_arch_type;
 #include <linux/types.h>
 #include <linux/linkage.h>
 
-static void putstr(const char *ptr);
+extern void move_ramdisk(void);
+extern void putstr(const char *ptr);
 extern void error(char *x);
 
 #include CONFIG_UNCOMPRESS_INCLUDE
@@ -83,7 +84,7 @@ static void icedcc_putc(int ch)
 #define putc(ch)	icedcc_putc(ch)
 #endif
 
-static void putstr(const char *ptr)
+void putstr(const char *ptr)
 {
 	char c;
 
@@ -144,6 +145,8 @@ decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
 
 	arch_decomp_setup();
 
+	move_ramdisk();
+
 	putstr("Uncompressing Linux...");
 	ret = do_decompress(input_data, input_data_end - input_data,
 			    output_data, error);
diff --git a/arch/arm/boot/compressed/move_ramdisk.c b/arch/arm/boot/compressed/move_ramdisk.c
new file mode 100644
index 0000000..4b7ecfc
--- /dev/null
+++ b/arch/arm/boot/compressed/move_ramdisk.c
@@ -0,0 +1,58 @@
+/*
+ * move_ramdisk.c
+ *
+ * Author: Wu Zhangjin, wuzhangjin@gmail.com, December 2013
+ * Copyright: (C) 2013 TinyLab.org
+ *
+ * Please get help of MOVE_RAMDISK from usr/Kconfig.
+ */
+
+#include <asm/setup.h>
+#include <asm/memory.h>
+#include <asm/string.h>
+
+/* The tag address, may need to be changed for your board, see PHYS_OFFSET, atag_offset */
+#define TAG_BASE_ADDR		(PLAT_PHYS_OFFSET + 0x100)
+
+#define MOVE_RAMDISK_OFFSET	(CONFIG_MOVE_RAMDISK_OFFSET_M * 1024 * 1024)
+#define tag_next(t)	((struct tag *)((__u32 *)(t) + (t)->hdr.size))
+
+extern void putstr(const char *ptr);
+
+void move_ramdisk(void)
+{
+#ifdef CONFIG_MOVE_RAMDISK
+	struct tag *tags = (struct tag *)(TAG_BASE_ADDR);
+	__u32 start, size;
+	int found = 0;
+
+	putstr("Searching ramdisk ...\n");
+	if (tags->hdr.tag == ATAG_CORE) {
+		putstr("Found tags ...\n");
+		for (tags = tag_next(tags); tags->hdr.size; tags = tag_next(tags)) {
+			if (tags->hdr.tag == ATAG_INITRD2) {
+				putstr("Found initrd2 tag ...\n");
+				found = 1;
+				break;
+			} else if (tags->hdr.tag == ATAG_INITRD) {
+				putstr("Found initrd tag ...\n");
+				found = 1;
+				break;
+			} else if (tags->hdr.tag == ATAG_RAMDISK) {
+				putstr("Found ramdisk tag ...\n");
+				found = 1;
+				break;
+			}
+		}
+		if (found) {
+			start = tags->u.initrd.start;
+			size = tags->u.initrd.size;
+			tags->u.initrd.start = start + MOVE_RAMDISK_OFFSET;
+			putstr("Moving ramdisk forward ...\n");
+			memcpy((char *)tags->u.initrd.start, (char *)start, size);
+		}
+	} else {
+		putstr("No tag found ...\n");
+	}
+#endif
+}
diff --git a/usr/Kconfig b/usr/Kconfig
index 642f503..bd39418 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -175,3 +175,32 @@ config INITRAMFS_COMPRESSION_LZO
 	  (both compression and decompression) is the fastest.
 
 endchoice
+
+config MOVE_RAMDISK
+	bool "Move ramdisk forward to reserve more memory for kernel image"
+	depends on ARM
+	help
+	  During the booting of an embedded Linux system, before decompressing
+	  the kernel image, the bootloader(E.g. Uboot) loads the compressed
+	  kernel image and ramdisk into two contiguous memory spaces, these two
+	  memory spaces are fixed after the Uboot is released, as a result, the
+	  maximum size of the decompressed kernel image is limited by the size
+	  of the reserved memory space (the difference of the two contiguous
+	  memory addresses).
+
+	  If want more functions or some debug options, the decompressed kernel
+	  image may be bigger and may overwrite the followed ramdisk and result
+	  in kernel boot failure for missing a valid ramdisk.
+
+	  To fix up this issue, before decompressing the kernel image, this
+	  option moves the loaded ramdisk image forward with a configurable
+	  offset and reserve more memory for the decompressed kernel image.
+
+config MOVE_RAMDISK_OFFSET_M
+	int "Set the move offset of ramdisk (in Mbytes)"
+	range 5 100
+	default "20"
+	depends on MOVE_RAMDISK
+	help
+	  Specify the move offset of the ramdisk, if want a bigger kernel, please
+	  Increase this size.
-- 
1.7.10.4

