Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3BZGZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:25:02 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59225 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3BZGY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:24:57 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-72-512c553609e3
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org
Cc: Nicolas Pitre <nico@fluxnic.net>, Nitin Gupta <nitingupta910@gmail.com>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com, Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [RFC PATCH v2 4/4] x86: Add support for LZ4-compressed kernel
Date: Tue, 26 Feb 2013 15:24:30 +0900
Message-Id: <1361859870-15751-5-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch integrates the LZ4 decompression code to the x86 pre-boot code.
And it depends on two patchs below

lib: Add support for LZ4-compressed kernel
decompressor: Add LZ4 decompressor module

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
---
 arch/x86/Kconfig                  | 1 +
 arch/x86/boot/compressed/Makefile | 5 ++++-
 arch/x86/boot/compressed/misc.c   | 4 ++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 225543b..ab916fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -63,6 +63,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZ4
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 8a84501..c275db5 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4 head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -64,12 +64,15 @@ $(obj)/vmlinux.bin.xz: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,xzkern)
 $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzo)
+$(obj)/vmlinux.bin.lz4: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,lz4)
 
 suffix-$(CONFIG_KERNEL_GZIP)	:= gz
 suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
 suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
+suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 88f7ff6..166a0a8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -145,6 +145,10 @@ static int lines, cols;
 #include "../../../../lib/decompress_unlzo.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZ4
+#include "../../../../lib/decompress_unlz4.c"
+#endif
+
 static void scroll(void)
 {
 	int i;
-- 
1.8.1.1

