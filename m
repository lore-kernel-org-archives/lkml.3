Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3CELsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:48:03 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64529 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3CELsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:48:00 -0500
X-AuditID: 9c93016f-b7b46ae000000e4b-60-5135db6ea337
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
Subject: [PATCH v3 -next 3/5] arm: Add support for LZ4-compressed kernel
Date: Tue,  5 Mar 2013 20:47:34 +0900
Message-Id: <1362484056-9778-4-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch integrates the LZ4 decompression code to the arm pre-boot code.
And it depends on two patchs below

lib: Add support for LZ4-compressed kernel
decompressor: Add LZ4 decompressor module

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>

v2:
- Apply CFLAGS, -Os to decompress.o to improve decompress
  performance during boot-up process
---
 arch/arm/Kconfig                      | 1 +
 arch/arm/boot/compressed/.gitignore   | 1 +
 arch/arm/boot/compressed/Makefile     | 6 +++++-
 arch/arm/boot/compressed/decompress.c | 4 ++++
 arch/arm/boot/compressed/piggy.lz4.S  | 6 ++++++
 5 files changed, 17 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/compressed/piggy.lz4.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..0f9b363 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -38,6 +38,7 @@ config ARM
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_LZ4
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_XZ
diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index f79a08e..47279aa 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -6,6 +6,7 @@ piggy.gzip
 piggy.lzo
 piggy.lzma
 piggy.xzkern
+piggy.lz4
 vmlinux
 vmlinux.lds
 
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 5cad8a6..2249d52 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -24,6 +24,9 @@ endif
 AFLAGS_head.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
 HEAD	= head.o
 OBJS	+= misc.o decompress.o
+ifeq ($(CONFIG_KERNEL_LZ4),y)
+CFLAGS_decompress.o := -Os
+endif
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
 
 # string library code (-Os is enforced to keep it much smaller)
@@ -88,6 +91,7 @@ suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
 suffix_$(CONFIG_KERNEL_LZMA) = lzma
 suffix_$(CONFIG_KERNEL_XZ)   = xzkern
+suffix_$(CONFIG_KERNEL_LZ4)  = lz4
 
 # Borrowed libfdt files for the ATAG compatibility mode
 
@@ -112,7 +116,7 @@ targets       := vmlinux vmlinux.lds \
 		 font.o font.c head.o misc.o $(OBJS)
 
 # Make sure files are removed during clean
-extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
+extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz4 \
 		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
diff --git a/arch/arm/boot/compressed/decompress.c b/arch/arm/boot/compressed/decompress.c
index 9deb56a..a95f071 100644
--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -53,6 +53,10 @@ extern char * strstr(const char * s1, const char *s2);
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZ4
+#include "../../../../lib/decompress_unlz4.c"
+#endif
+
 int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x))
 {
 	return decompress(input, len, NULL, NULL, output, NULL, error);
diff --git a/arch/arm/boot/compressed/piggy.lz4.S b/arch/arm/boot/compressed/piggy.lz4.S
new file mode 100644
index 0000000..3d9a575
--- /dev/null
+++ b/arch/arm/boot/compressed/piggy.lz4.S
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/arm/boot/compressed/piggy.lz4"
+	.globl	input_data_end
+input_data_end:
-- 
1.8.1.1

