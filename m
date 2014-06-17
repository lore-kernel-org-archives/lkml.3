Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbaFQO31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:29:27 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32881 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932410AbaFQO3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:29:25 -0400
Date: Tue, 17 Jun 2014 15:29:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Nico Pitre <nico@fluxnic.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        linaro-networking@linaro.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8 kernels
Message-ID: <20140617142917.GA31861@n2100.arm.linux.org.uk>
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:27:12PM +0300, Taras Kondratiuk wrote:
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 68c9183..8a80906 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -114,7 +114,7 @@ targets       := vmlinux vmlinux.lds \
>  # Make sure files are removed during clean
>  extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz4 \
>  		 lib1funcs.S ashldi3.S bswapsdi2.S $(libfdt) $(libfdt_hdrs) \
> -		 hyp-stub.S
> +		 hyp-stub.S vmlinux.lds.S
>  
>  ifeq ($(CONFIG_FUNCTION_TRACER),y)
>  ORIG_CFLAGS := $(KBUILD_CFLAGS)
> @@ -199,7 +199,7 @@ CFLAGS_font.o := -Dstatic=
>  $(obj)/font.c: $(FONTC)
>  	$(call cmd,shipped)
>  
> -$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KCONFIG_CONFIG)
> +$(obj)/vmlinux.lds.S: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KCONFIG_CONFIG)
>  	@sed "$(SEDFLAGS)" < $< > $@

Given that we're now passing the linker script through GCC for C
preprocessing, it seems to me that we don't need to do the sed trick
anymore - we can pass TEXTADDR and ZBSSADDR into GCC via definitions
instead, so I've committed this patch after this one.  No changes to
the vmlinux.lds.* file, it's just a pure rename.  Ack?

From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] ARM: Simplify generation of compressed vmlinux.lds file

As we are now using the C preprocessor, we do not need to use sed to
edit constants in this file, and then pass the resulting file through
the C preprocessor.  Instead, rely solely on the C preprocessor to
rewrite TEXT_START and BSS_ADDR.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/boot/compressed/.gitignore     |  1 -
 arch/arm/boot/compressed/Makefile       |  5 +-
 arch/arm/boot/compressed/vmlinux.lds.S  | 90 +++++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/vmlinux.lds.in | 90 ---------------------------------
 4 files changed, 91 insertions(+), 95 deletions(-)
 create mode 100644 arch/arm/boot/compressed/vmlinux.lds.S
 delete mode 100644 arch/arm/boot/compressed/vmlinux.lds.in

diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index 6a26e7bcb714..0714e0334e33 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -10,7 +10,6 @@ piggy.xzkern
 piggy.lz4
 vmlinux
 vmlinux.lds
-vmlinux.lds.S
 
 # borrowed libfdt files
 fdt.c
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 8a8090694d89..46055d5e9414 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -81,7 +81,7 @@ ZTEXTADDR	:= 0
 ZBSSADDR	:= ALIGN(8)
 endif
 
-SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
+CPPFLAGS_vmlinux.lds := -DTEXT_START="$(ZTEXTADDR)" -DBSS_START="$(ZBSSADDR)"
 
 suffix_$(CONFIG_KERNEL_GZIP) = gzip
 suffix_$(CONFIG_KERNEL_LZO)  = lzo
@@ -199,8 +199,5 @@ CFLAGS_font.o := -Dstatic=
 $(obj)/font.c: $(FONTC)
 	$(call cmd,shipped)
 
-$(obj)/vmlinux.lds.S: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KCONFIG_CONFIG)
-	@sed "$(SEDFLAGS)" < $< > $@
-
 $(obj)/hyp-stub.S: $(srctree)/arch/$(SRCARCH)/kernel/hyp-stub.S
 	$(call cmd,shipped)
diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
new file mode 100644
index 000000000000..60162231c7ea
--- /dev/null
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -0,0 +1,90 @@
+/*
+ *  linux/arch/arm/boot/compressed/vmlinux.lds.in
+ *
+ *  Copyright (C) 2000 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_CPU_ENDIAN_BE8
+#define ZIMAGE_MAGIC(x) ( (((x) >> 24) & 0x000000ff) | \
+			  (((x) >>  8) & 0x0000ff00) | \
+			  (((x) <<  8) & 0x00ff0000) | \
+			  (((x) << 24) & 0xff000000) )
+#else
+#define ZIMAGE_MAGIC(x) (x)
+#endif
+
+OUTPUT_ARCH(arm)
+ENTRY(_start)
+SECTIONS
+{
+  /DISCARD/ : {
+    *(.ARM.exidx*)
+    *(.ARM.extab*)
+    /*
+     * Discard any r/w data - this produces a link error if we have any,
+     * which is required for PIC decompression.  Local data generates
+     * GOTOFF relocations, which prevents it being relocated independently
+     * of the text/got segments.
+     */
+    *(.data)
+  }
+
+  . = TEXT_START;
+  _text = .;
+
+  .text : {
+    _start = .;
+    *(.start)
+    *(.text)
+    *(.text.*)
+    *(.fixup)
+    *(.gnu.warning)
+    *(.glue_7t)
+    *(.glue_7)
+  }
+  .rodata : {
+    *(.rodata)
+    *(.rodata.*)
+  }
+  .piggydata : {
+    *(.piggydata)
+  }
+
+  . = ALIGN(4);
+  _etext = .;
+
+  .got.plt		: { *(.got.plt) }
+  _got_start = .;
+  .got			: { *(.got) }
+  _got_end = .;
+
+  /* ensure the zImage file size is always a multiple of 64 bits */
+  /* (without a dummy byte, ld just ignores the empty section) */
+  .pad			: { BYTE(0); . = ALIGN(8); }
+  _edata = .;
+
+  _magic_sig = ZIMAGE_MAGIC(0x016f2818);
+  _magic_start = ZIMAGE_MAGIC(_start);
+  _magic_end = ZIMAGE_MAGIC(_edata);
+
+  . = BSS_START;
+  __bss_start = .;
+  .bss			: { *(.bss) }
+  _end = .;
+
+  . = ALIGN(8);		/* the stack must be 64-bit aligned */
+  .stack		: { *(.stack) }
+
+  .stab 0		: { *(.stab) }
+  .stabstr 0		: { *(.stabstr) }
+  .stab.excl 0		: { *(.stab.excl) }
+  .stab.exclstr 0	: { *(.stab.exclstr) }
+  .stab.index 0		: { *(.stab.index) }
+  .stab.indexstr 0	: { *(.stab.indexstr) }
+  .comment 0		: { *(.comment) }
+}
+
diff --git a/arch/arm/boot/compressed/vmlinux.lds.in b/arch/arm/boot/compressed/vmlinux.lds.in
deleted file mode 100644
index 60162231c7ea..000000000000
--- a/arch/arm/boot/compressed/vmlinux.lds.in
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- *  linux/arch/arm/boot/compressed/vmlinux.lds.in
- *
- *  Copyright (C) 2000 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifdef CONFIG_CPU_ENDIAN_BE8
-#define ZIMAGE_MAGIC(x) ( (((x) >> 24) & 0x000000ff) | \
-			  (((x) >>  8) & 0x0000ff00) | \
-			  (((x) <<  8) & 0x00ff0000) | \
-			  (((x) << 24) & 0xff000000) )
-#else
-#define ZIMAGE_MAGIC(x) (x)
-#endif
-
-OUTPUT_ARCH(arm)
-ENTRY(_start)
-SECTIONS
-{
-  /DISCARD/ : {
-    *(.ARM.exidx*)
-    *(.ARM.extab*)
-    /*
-     * Discard any r/w data - this produces a link error if we have any,
-     * which is required for PIC decompression.  Local data generates
-     * GOTOFF relocations, which prevents it being relocated independently
-     * of the text/got segments.
-     */
-    *(.data)
-  }
-
-  . = TEXT_START;
-  _text = .;
-
-  .text : {
-    _start = .;
-    *(.start)
-    *(.text)
-    *(.text.*)
-    *(.fixup)
-    *(.gnu.warning)
-    *(.glue_7t)
-    *(.glue_7)
-  }
-  .rodata : {
-    *(.rodata)
-    *(.rodata.*)
-  }
-  .piggydata : {
-    *(.piggydata)
-  }
-
-  . = ALIGN(4);
-  _etext = .;
-
-  .got.plt		: { *(.got.plt) }
-  _got_start = .;
-  .got			: { *(.got) }
-  _got_end = .;
-
-  /* ensure the zImage file size is always a multiple of 64 bits */
-  /* (without a dummy byte, ld just ignores the empty section) */
-  .pad			: { BYTE(0); . = ALIGN(8); }
-  _edata = .;
-
-  _magic_sig = ZIMAGE_MAGIC(0x016f2818);
-  _magic_start = ZIMAGE_MAGIC(_start);
-  _magic_end = ZIMAGE_MAGIC(_edata);
-
-  . = BSS_START;
-  __bss_start = .;
-  .bss			: { *(.bss) }
-  _end = .;
-
-  . = ALIGN(8);		/* the stack must be 64-bit aligned */
-  .stack		: { *(.stack) }
-
-  .stab 0		: { *(.stab) }
-  .stabstr 0		: { *(.stabstr) }
-  .stab.excl 0		: { *(.stab.excl) }
-  .stab.exclstr 0	: { *(.stab.exclstr) }
-  .stab.index 0		: { *(.stab.index) }
-  .stab.indexstr 0	: { *(.stab.indexstr) }
-  .comment 0		: { *(.comment) }
-}
-
-- 
1.8.3.1



-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
