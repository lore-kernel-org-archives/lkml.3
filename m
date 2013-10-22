Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3JVVE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:04:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:20276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab3JVVE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:04:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396956045"
From: Andrew Boie <andrew.p.boie@intel.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mmarek@suse.cz,
        Andrew Boie <andrew.p.boie@intel.com>
Subject: [PATCH 1/1] x86: boot: support minigzip bzImage compression
Date: Tue, 22 Oct 2013 14:07:21 -0700
Message-Id: <1382476041-1115-2-git-send-email-andrew.p.boie@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com>
References: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android OTA system computes very efficient diffs of compressed files
if the deflate() algorithm it has access to is the same version as
used to create the original file. Here we add support for compressing
the kernel with 'minigzip' which uses the deflate() inside zlib.
This is much better than using 'gzip' as that tool has a very old
version of deflate() inside the gzip codebase instead of linking against
zlib.

Signed-off-by: Andrew Boie <andrew.p.boie@intel.com>
---
 arch/x86/Kconfig                  |  1 +
 arch/x86/boot/compressed/Makefile |  3 +++
 arch/x86/boot/compressed/misc.c   |  2 +-
 init/Kconfig                      | 18 +++++++++++++++++-
 scripts/Makefile.lib              |  7 +++++++
 5 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..aa91cef 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -62,6 +62,7 @@ config X86
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_MINIGZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index dcd90df..f000791 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -56,6 +56,8 @@ vmlinux.bin.all-$(CONFIG_X86_NEED_RELOCS) += $(obj)/vmlinux.relocs
 
 $(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,gzip)
+$(obj)/vmlinux.bin.mgz: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,minigzip)
 $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,bzip2)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
@@ -68,6 +70,7 @@ $(obj)/vmlinux.bin.lz4: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lz4)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
+suffix-$(CONFIG_KERNEL_MINIGZIP):= mgz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
 suffix-$(CONFIG_KERNEL_XZ)	:= xz
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 434f077..4e55d32 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -125,7 +125,7 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
-#ifdef CONFIG_KERNEL_GZIP
+#if defined(CONFIG_KERNEL_GZIP) || defined(CONFIG_KERNEL_MINIGZIP)
 #include "../../../../lib/decompress_inflate.c"
 #endif
 
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..818f225 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -100,6 +100,9 @@ config LOCALVERSION_AUTO
 config HAVE_KERNEL_GZIP
 	bool
 
+config HAVE_KERNEL_MINIGZIP
+	bool
+
 config HAVE_KERNEL_BZIP2
 	bool
 
@@ -118,7 +121,7 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_MINIGZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -144,6 +147,19 @@ config KERNEL_GZIP
 	  The old and tried gzip compression. It provides a good balance
 	  between compression ratio and decompression speed.
 
+config KERNEL_MINIGZIP
+	bool "Minigzip"
+	depends on HAVE_KERNEL_MINIGZIP
+	help
+	  Use minigzip to compress the bzImage. This is very similar to gzip
+	  but uses the zlib library to compress, rather than the very old version
+	  of zlib inside the gzip codebase. This is used for Android kernels
+	  so that the same version of the deflate() algorithm is used when
+	  building the kernel and constructing diffs with OTA applypatch, which
+	  uncompresses sections of files that it detects are gzipped before computing
+	  the diffs. If the versions of deflate() are out of alignment the binary
+	  diffs tend to be very large.
+
 config KERNEL_BZIP2
 	bool "Bzip2"
 	depends on HAVE_KERNEL_BZIP2
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 49392ec..deb1bb8 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -240,6 +240,13 @@ quiet_cmd_gzip = GZIP    $@
 cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -n -f -9 > $@) || \
 	(rm -f $@ ; false)
 
+# Minigzip
+# ---------------------------------------------------------------------------
+
+quiet_cmd_minigzip = MINGZIP $@
+cmd_minigzip = (cat $(filter-out FORCE,$^) | minigzip -c -9 > $@) || \
+	(rm -f $@ ; false)
+
 # DTC
 # ---------------------------------------------------------------------------
 
-- 
1.8.3.2

