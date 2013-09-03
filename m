Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab3ICSZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:25:47 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:58796 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3ICSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:25:45 -0400
Date: Tue, 3 Sep 2013 20:25:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/kaslr change for v3.12
Message-ID: <20130903182541.GA31033@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-kaslr-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-kaslr-for-linus

   HEAD: a02150610776f66b40257624822a879311592bb2 x86, relocs: Move ELF relocation handling to C

This tree contains a single change, ELF relocation handling in C - one of 
the kernel randomization patches that makes sense even without 
randomization present upstream.

 Thanks,

	Ingo

------------------>
Kees Cook (1):
      x86, relocs: Move ELF relocation handling to C


 arch/x86/Kconfig                     |  8 +++-
 arch/x86/Makefile                    |  8 ++--
 arch/x86/boot/compressed/head_32.S   | 31 ++-------------
 arch/x86/boot/compressed/head_64.S   |  1 +
 arch/x86/boot/compressed/misc.c      | 77 +++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/page_32_types.h |  2 +
 arch/x86/include/asm/page_64_types.h |  5 ---
 arch/x86/include/asm/page_types.h    |  5 +++
 8 files changed, 97 insertions(+), 40 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..8002668 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1716,9 +1716,10 @@ config X86_NEED_RELOCS
 	depends on X86_32 && RELOCATABLE
 
 config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned" if X86_32
+	hex "Alignment value to which kernel should be aligned"
 	default "0x1000000"
-	range 0x2000 0x1000000
+	range 0x2000 0x1000000 if X86_32
+	range 0x200000 0x1000000 if X86_64
 	---help---
 	  This value puts the alignment restrictions on physical address
 	  where kernel is loaded and run from. Kernel is compiled for an
@@ -1736,6 +1737,9 @@ config PHYSICAL_ALIGN
 	  end result is that kernel runs from a physical address meeting
 	  above alignment restrictions.
 
+	  On 32-bit this value must be a multiple of 0x2000. On 64-bit
+	  this value must be a multiple of 0x200000.
+
 	  Don't change this unless you know what you are doing.
 
 config HOTPLUG_CPU
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 07639c6..41250fb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -16,6 +16,10 @@ endif
 # e.g.: obj-y += foo_$(BITS).o
 export BITS
 
+ifdef CONFIG_X86_NEED_RELOCS
+        LDFLAGS_vmlinux := --emit-relocs
+endif
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
@@ -25,10 +29,6 @@ ifeq ($(CONFIG_X86_32),y)
         KBUILD_AFLAGS += $(biarch)
         KBUILD_CFLAGS += $(biarch)
 
-        ifdef CONFIG_RELOCATABLE
-                LDFLAGS_vmlinux := --emit-relocs
-        endif
-
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1e3184f..5d6f689 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -181,8 +181,9 @@ relocated:
 /*
  * Do the decompression, and jump to the new kernel..
  */
-	leal	z_extract_offset_negative(%ebx), %ebp
 				/* push arguments for decompress_kernel: */
+	pushl	$z_output_len	/* decompressed length */
+	leal	z_extract_offset_negative(%ebx), %ebp
 	pushl	%ebp		/* output address */
 	pushl	$z_input_len	/* input_len */
 	leal	input_data(%ebx), %eax
@@ -191,33 +192,7 @@ relocated:
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	decompress_kernel
-	addl	$20, %esp
-
-#if CONFIG_RELOCATABLE
-/*
- * Find the address of the relocations.
- */
-	leal	z_output_len(%ebp), %edi
-
-/*
- * Calculate the delta between where vmlinux was compiled to run
- * and where it was actually loaded.
- */
-	movl	%ebp, %ebx
-	subl	$LOAD_PHYSICAL_ADDR, %ebx
-	jz	2f	/* Nothing to be done if loaded at compiled addr. */
-/*
- * Process relocations.
- */
-
-1:	subl	$4, %edi
-	movl	(%edi), %ecx
-	testl	%ecx, %ecx
-	jz	2f
-	addl	%ebx, -__PAGE_OFFSET(%ebx, %ecx)
-	jmp	1b
-2:
-#endif
+	addl	$24, %esp
 
 /*
  * Jump to the decompressed kernel.
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 06e71c2..c337422 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -338,6 +338,7 @@ relocated:
 	leaq	input_data(%rip), %rdx  /* input_data */
 	movl	$z_input_len, %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
+	movq	$z_output_len, %r9	/* decompressed length */
 	call	decompress_kernel
 	popq	%rsi
 
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 0319c88..434f077 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -271,6 +271,79 @@ static void error(char *x)
 		asm("hlt");
 }
 
+#if CONFIG_X86_NEED_RELOCS
+static void handle_relocations(void *output, unsigned long output_len)
+{
+	int *reloc;
+	unsigned long delta, map, ptr;
+	unsigned long min_addr = (unsigned long)output;
+	unsigned long max_addr = min_addr + output_len;
+
+	/*
+	 * Calculate the delta between where vmlinux was linked to load
+	 * and where it was actually loaded.
+	 */
+	delta = min_addr - LOAD_PHYSICAL_ADDR;
+	if (!delta) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+	debug_putstr("Performing relocations... ");
+
+	/*
+	 * The kernel contains a table of relocation addresses. Those
+	 * addresses have the final load address of the kernel in virtual
+	 * memory. We are currently working in the self map. So we need to
+	 * create an adjustment for kernel memory addresses to the self map.
+	 * This will involve subtracting out the base address of the kernel.
+	 */
+	map = delta - __START_KERNEL_map;
+
+	/*
+	 * Process relocations: 32 bit relocations first then 64 bit after.
+	 * Two sets of binary relocations are added to the end of the kernel
+	 * before compression. Each relocation table entry is the kernel
+	 * address of the location which needs to be updated stored as a
+	 * 32-bit value which is sign extended to 64 bits.
+	 *
+	 * Format is:
+	 *
+	 * kernel bits...
+	 * 0 - zero terminator for 64 bit relocations
+	 * 64 bit relocation repeated
+	 * 0 - zero terminator for 32 bit relocations
+	 * 32 bit relocation repeated
+	 *
+	 * So we work backwards from the end of the decompressed image.
+	 */
+	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
+		int extended = *reloc;
+		extended += map;
+
+		ptr = (unsigned long)extended;
+		if (ptr < min_addr || ptr > max_addr)
+			error("32-bit relocation outside of kernel!\n");
+
+		*(uint32_t *)ptr += delta;
+	}
+#ifdef CONFIG_X86_64
+	for (reloc--; *reloc; reloc--) {
+		long extended = *reloc;
+		extended += map;
+
+		ptr = (unsigned long)extended;
+		if (ptr < min_addr || ptr > max_addr)
+			error("64-bit relocation outside of kernel!\n");
+
+		*(uint64_t *)ptr += delta;
+	}
+#endif
+}
+#else
+static inline void handle_relocations(void *output, unsigned long output_len)
+{ }
+#endif
+
 static void parse_elf(void *output)
 {
 #ifdef CONFIG_X86_64
@@ -325,7 +398,8 @@ static void parse_elf(void *output)
 asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
-				  unsigned char *output)
+				  unsigned char *output,
+				  unsigned long output_len)
 {
 	real_mode = rmode;
 
@@ -365,6 +439,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
+	handle_relocations(output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return;
 }
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index ef17af0..f48b17d 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -15,6 +15,8 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
+#define __START_KERNEL_map	__PAGE_OFFSET
+
 #define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 6c896fb..43dcd80 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -32,11 +32,6 @@
  */
 #define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
 
-#define __PHYSICAL_START	((CONFIG_PHYSICAL_START +	 	\
-				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
-				 ~(CONFIG_PHYSICAL_ALIGN - 1))
-
-#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
 /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 54c9787..f97fbe3 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -33,6 +33,11 @@
 	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
+#define __PHYSICAL_START	ALIGN(CONFIG_PHYSICAL_START, \
+				      CONFIG_PHYSICAL_ALIGN)
+
+#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
+
 #ifdef CONFIG_X86_64
 #include <asm/page_64_types.h>
 #else
