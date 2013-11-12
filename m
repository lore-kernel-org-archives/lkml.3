Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3KLTnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:43:32 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:34769 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab3KLTmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:42 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org
Subject: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
Date: Tue, 12 Nov 2013 20:42:25 +0100
Message-Id: <1384285347-13506-16-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the microblaze-specific __fdt_blob section, and start using
.dtb.init.rodata from <asm-generic/sections.h> for built-in DTBs, like
most other DT enabled architectures.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: devicetree@vger.kernel.org
---
Untested, but the resulting vmlinux after "make simpleImage.system" looks
sane.

QUESTION: The padding of the DTB is gone, is this OK?

TODO: Start using the DTB logic in scripts/Makefile.lib instead of
      arch/microblaze/boot/dts/linked_dtb.S

 arch/microblaze/boot/Makefile          |    2 +-
 arch/microblaze/boot/dts/linked_dtb.S  |    2 +-
 arch/microblaze/include/asm/sections.h |    4 +---
 arch/microblaze/kernel/head.S          |    2 +-
 arch/microblaze/kernel/setup.c         |    4 ++--
 arch/microblaze/kernel/vmlinux.lds.S   |    8 --------
 6 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 8e211cc28dac..e4a99a22dab8 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -23,7 +23,7 @@ quiet_cmd_cp = CP      $< $@$2
 
 quiet_cmd_strip = STRIP   $@
 	cmd_strip = $(STRIP) -K microblaze_start -K _end -K __log_buf \
-				-K _fdt_start vmlinux -o $@
+				-K __dtb_start vmlinux -o $@
 
 UIMAGE_LOADADDR = $(CONFIG_KERNEL_BASE_ADDR)
 
diff --git a/arch/microblaze/boot/dts/linked_dtb.S b/arch/microblaze/boot/dts/linked_dtb.S
index 23345af3721f..bfc53b5795aa 100644
--- a/arch/microblaze/boot/dts/linked_dtb.S
+++ b/arch/microblaze/boot/dts/linked_dtb.S
@@ -1,2 +1,2 @@
-.section __fdt_blob,"a"
+.section .dtb.init.rodata,"a"
 .incbin "arch/microblaze/boot/dts/system.dtb"
diff --git a/arch/microblaze/include/asm/sections.h b/arch/microblaze/include/asm/sections.h
index 1b281d3ea734..fb8ab0ba03fc 100644
--- a/arch/microblaze/include/asm/sections.h
+++ b/arch/microblaze/include/asm/sections.h
@@ -16,8 +16,6 @@
 # ifndef __ASSEMBLY__
 extern char _ssbss[], _esbss[];
 extern unsigned long __ivt_start[], __ivt_end[];
-
-extern u32 _fdt_start[], _fdt_end[];
-
 # endif /* !__ASSEMBLY__ */
+
 #endif /* _ASM_MICROBLAZE_SECTIONS_H */
diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
index 817b7eec95b6..6108889f0025 100644
--- a/arch/microblaze/kernel/head.S
+++ b/arch/microblaze/kernel/head.S
@@ -94,7 +94,7 @@ big_endian:
 	bnei	r11, no_fdt_arg			/* No - get out of here */
 _prepare_copy_fdt:
 	or	r11, r0, r0 /* incremment */
-	ori	r4, r0, TOPHYS(_fdt_start)
+	ori	r4, r0, TOPHYS(__dtb_start)
 	ori	r3, r0, (0x8000 - 4)
 _copy_fdt:
 	lw	r12, r7, r11 /* r12 = r7 + r11 */
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 603e22fec6d5..a4534f584be0 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -136,7 +136,7 @@ void __init machine_early_init(const char *cmdline, unsigned int ram,
 	lockdep_init();
 
 /* initialize device tree for usage in early_printk */
-	early_init_devtree(_fdt_start);
+	early_init_devtree(&__dtb_start);
 
 #ifdef CONFIG_EARLY_PRINTK
 	setup_early_printk(NULL);
@@ -152,7 +152,7 @@ void __init machine_early_init(const char *cmdline, unsigned int ram,
 	if (fdt)
 		pr_info("FDT at 0x%08x\n", fdt);
 	else
-		pr_info("Compiled-in FDT at %p\n", _fdt_start);
+		pr_info("Compiled-in FDT at %p\n", &__dtb_start);
 
 #ifdef CONFIG_MTD_UCLINUX
 	pr_info("Found romfs @ 0x%08x (0x%08x)\n",
diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
index 936d01a689d7..2659e70984a3 100644
--- a/arch/microblaze/kernel/vmlinux.lds.S
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -40,14 +40,6 @@ SECTIONS {
 		_etext = . ;
 	}
 
-	. = ALIGN (4) ;
-	__fdt_blob : AT(ADDR(__fdt_blob) - LOAD_OFFSET) {
-		_fdt_start = . ;		/* place for fdt blob */
-		*(__fdt_blob) ;			/* Any link-placed DTB */
-	        . = _fdt_start + 0x8000;	/* Pad up to 32kbyte */
-		_fdt_end = . ;
-	}
-
 	. = ALIGN(16);
 	RODATA
 	EXCEPTION_TABLE(16)
-- 
1.7.9.5

