Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3KNIi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:38:56 -0500
Received: from mail.abilis.ch ([195.70.19.74]:17249 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3KNIiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:38:54 -0500
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Pavel Roskin <proski@gnu.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 2/2] x86: Add support for uncompressed kernel images
Date: Thu, 14 Nov 2013 09:38:16 +0100
Message-Id: <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20131114083247.GB9687@ab42.lan>
References: <20131114083247.GB9687@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 arch/x86/Kconfig                  |  1 +
 arch/x86/boot/compressed/Makefile | 14 ++++++------
 arch/x86/boot/compressed/misc.c   |  4 ++++
 lib/decompress_copy.c             | 47 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 7 deletions(-)
 create mode 100644 lib/decompress_copy.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..2a32df9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -61,6 +61,7 @@ config X86
 	select USER_STACKTRACE_SUPPORT
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DMA_API_DEBUG
+	select HAVE_KERNEL_UNCOMPRESSED
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index dcd90df..f65e444 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -67,16 +67,16 @@ $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
 $(obj)/vmlinux.bin.lz4: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lz4)
 
-suffix-$(CONFIG_KERNEL_GZIP)	:= gz
-suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
-suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
-suffix-$(CONFIG_KERNEL_XZ)	:= xz
-suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
-suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
+suffix-$(CONFIG_KERNEL_GZIP)	:= .gz
+suffix-$(CONFIG_KERNEL_BZIP2)	:= .bz2
+suffix-$(CONFIG_KERNEL_LZMA)	:= .lzma
+suffix-$(CONFIG_KERNEL_XZ)	:= .xz
+suffix-$(CONFIG_KERNEL_LZO) 	:= .lzo
+suffix-$(CONFIG_KERNEL_LZ4) 	:= .lz4
 
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
 
 targets += piggy.S
-$(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
+$(obj)/piggy.S: $(obj)/vmlinux.bin$(suffix-y) $(obj)/mkpiggy FORCE
 	$(call if_changed,mkpiggy)
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 434f077..c210314 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -149,6 +149,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlz4.c"
 #endif
 
+#ifdef CONFIG_KERNEL_UNCOMPRESSED
+#include "../../../../lib/decompress_copy.c"
+#endif
+
 static void scroll(void)
 {
 	int i;
diff --git a/lib/decompress_copy.c b/lib/decompress_copy.c
new file mode 100644
index 0000000..8a41090
--- /dev/null
+++ b/lib/decompress_copy.c
@@ -0,0 +1,47 @@
+#include <linux/decompress/mm.h>
+
+#define NOZIP_BUFSZ (16 * 1024)
+STATIC int INIT nozip(unsigned char *buf, int len,
+			int(*fill)(void*, unsigned int),
+			int(*flush)(void*, unsigned int),
+			unsigned char *outbuf,
+			int *pos,
+			void(*error)(char *x))
+{
+	char *b;
+
+	if (buf)
+		b = buf;
+	else
+		b = malloc(NOZIP_BUFSZ);
+
+	if (!b) {
+		error("Out of memory while allocating buffer");
+		return -1;
+	}
+
+	if (flush) {
+		if (!len)
+			len = fill(b, NOZIP_BUFSZ);
+
+		len = flush(b, len);
+	} else {
+		if (!len)
+			len = fill(outbuf, NOZIP_BUFSZ);
+		else {
+			int i;
+			for (i = 0; i < len; i++)
+				outbuf[i] = b[i];
+		}
+	}
+
+	if (pos)
+		*pos = len;
+
+	if (!buf)
+		free(b);
+
+	return 0;
+}
+
+#define decompress nozip
-- 
1.8.4

