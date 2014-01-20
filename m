Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaATQsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:48:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaATQsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:48:15 -0500
Date: Mon, 20 Jan 2014 08:47:35 -0800
Message-Id: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/kaslr for v3.14
Cc: Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This enables kernel address space randomization for x86.

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-kaslr-for-linus

The head of this tree is da2b6fb990cf782b18952f534ec7323453bc4fc9.

  x86, kaslr: Clarify RANDOMIZE_BASE_MAX_OFFSET (2014-01-14 10:45:56 -0800)

----------------------------------------------------------------
H. Peter Anvin (2):
      x86, boot: Rename get_flags() and check_flags() to *_cpuflags()
      x86, kaslr: Add a circular multiply for better bit diffusion

Kees Cook (10):
      x86, boot: Move CPU flags out of cpucheck
      x86, kaslr: Return location from decompress_kernel
      x86, kaslr: Provide randomness functions
      x86, kaslr: Select random position from e820 maps
      x86, kaslr: Report kernel offset on panic
      x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
      x86/relocs: Add percpu fixup for GNU ld 2.23
      x86, kaslr: Mix entropy sources together as needed
      x86, kaslr: Use char array to gain sizeof sanity
      x86, kaslr: Clarify RANDOMIZE_BASE_MAX_OFFSET

Michael Davidson (1):
      x86, relocs: Add more per-cpu gold special cases

Wei Yongjun (1):
      x86, kaslr: Remove unused including <linux/version.h>

 Documentation/kernel-parameters.txt     |   4 +
 arch/x86/Kconfig                        |  59 +++++-
 arch/x86/boot/Makefile                  |   2 +-
 arch/x86/boot/boot.h                    |  10 +-
 arch/x86/boot/compressed/Makefile       |   2 +-
 arch/x86/boot/compressed/aslr.c         | 316 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/cmdline.c      |   2 +-
 arch/x86/boot/compressed/cpuflags.c     |  12 ++
 arch/x86/boot/compressed/head_32.S      |  10 +-
 arch/x86/boot/compressed/head_64.S      |  16 +-
 arch/x86/boot/compressed/misc.c         |  18 +-
 arch/x86/boot/compressed/misc.h         |  37 +++-
 arch/x86/boot/cpucheck.c                | 100 +---------
 arch/x86/boot/cpuflags.c                | 104 +++++++++++
 arch/x86/boot/cpuflags.h                |  19 ++
 arch/x86/include/asm/archrandom.h       |  21 +++
 arch/x86/include/asm/page_64_types.h    |  15 +-
 arch/x86/include/asm/pgtable_64_types.h |   2 +-
 arch/x86/kernel/cpu/rdrand.c            |  14 --
 arch/x86/kernel/setup.c                 |  26 +++
 arch/x86/mm/init_32.c                   |   3 +
 arch/x86/tools/relocs.c                 |  20 +-
 22 files changed, 654 insertions(+), 158 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736d55fe..773fc4c077b4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1975,6 +1975,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	nokaslr		[X86]
+			Disable kernel base offset ASLR (Address Space
+			Layout Randomization) if built into the kernel.
+
 	noautogroup	Disable scheduler automatic task group creation.
 
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d37745..5c9e19dccf2f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1722,16 +1722,67 @@ config RELOCATABLE
 
 	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
 	  it has been loaded at and the compile time physical address
-	  (CONFIG_PHYSICAL_START) is ignored.
+	  (CONFIG_PHYSICAL_START) is used as the minimum location.
 
-# Relocation on x86-32 needs some additional build support
+config RANDOMIZE_BASE
+	bool "Randomize the address of the kernel image"
+	depends on RELOCATABLE
+	depends on !HIBERNATION
+	default n
+	---help---
+	   Randomizes the physical and virtual address at which the
+	   kernel image is decompressed, as a security feature that
+	   deters exploit attempts relying on knowledge of the location
+	   of kernel internals.
+
+	   Entropy is generated using the RDRAND instruction if it is
+	   supported. If RDTSC is supported, it is used as well. If
+	   neither RDRAND nor RDTSC are supported, then randomness is
+	   read from the i8254 timer.
+
+	   The kernel will be offset by up to RANDOMIZE_BASE_MAX_OFFSET,
+	   and aligned according to PHYSICAL_ALIGN. Since the kernel is
+	   built using 2GiB addressing, and PHYSICAL_ALGIN must be at a
+	   minimum of 2MiB, only 10 bits of entropy is theoretically
+	   possible. At best, due to page table layouts, 64-bit can use
+	   9 bits of entropy and 32-bit uses 8 bits.
+
+	   If unsure, say N.
+
+config RANDOMIZE_BASE_MAX_OFFSET
+	hex "Maximum kASLR offset allowed" if EXPERT
+	depends on RANDOMIZE_BASE
+	range 0x0 0x20000000 if X86_32
+	default "0x20000000" if X86_32
+	range 0x0 0x40000000 if X86_64
+	default "0x40000000" if X86_64
+	---help---
+	  The lesser of RANDOMIZE_BASE_MAX_OFFSET and available physical
+	  memory is used to determine the maximal offset in bytes that will
+	  be applied to the kernel when kernel Address Space Layout
+	  Randomization (kASLR) is active. This must be a multiple of
+	  PHYSICAL_ALIGN.
+
+	  On 32-bit this is limited to 512MiB by page table layouts. The
+	  default is 512MiB.
+
+	  On 64-bit this is limited by how the kernel fixmap page table is
+	  positioned, so this cannot be larger than 1GiB currently. Without
+	  RANDOMIZE_BASE, there is a 512MiB to 1.5GiB split between kernel
+	  and modules. When RANDOMIZE_BASE_MAX_OFFSET is above 512MiB, the
+	  modules area will shrink to compensate, up to the current maximum
+	  1GiB to 1GiB split. The default is 1GiB.
+
+	  If unsure, leave at the default value.
+
+# Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-	depends on X86_32 && RELOCATABLE
+	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
 
 config PHYSICAL_ALIGN
 	hex "Alignment value to which kernel should be aligned"
-	default "0x1000000"
+	default "0x200000"
 	range 0x2000 0x1000000 if X86_32
 	range 0x200000 0x1000000 if X86_64
 	---help---
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 379814bc41e3..0da2e37b37c3 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -20,7 +20,7 @@ targets		:= vmlinux.bin setup.bin setup.elf bzImage
 targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
 subdir-		:= compressed
 
-setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpucheck.o
+setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpuflags.o cpucheck.o
 setup-y		+= early_serial_console.o edd.o header.o main.o mca.o memory.o
 setup-y		+= pm.o pmjump.o printf.o regs.o string.o tty.o video.o
 setup-y		+= video-mode.o version.o
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index ef72baeff484..50f8c5e0f37e 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -26,9 +26,8 @@
 #include <asm/boot.h>
 #include <asm/setup.h>
 #include "bitops.h"
-#include <asm/cpufeature.h>
-#include <asm/processor-flags.h>
 #include "ctype.h"
+#include "cpuflags.h"
 
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
@@ -307,14 +306,7 @@ static inline int cmdline_find_option_bool(const char *option)
 	return __cmdline_find_option_bool(cmd_line_ptr, option);
 }
 
-
 /* cpu.c, cpucheck.c */
-struct cpu_features {
-	int level;		/* Family, or 64 for x86-64 */
-	int model;
-	u32 flags[NCAPINTS];
-};
-extern struct cpu_features cpu;
 int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index dcd90df10ab4..ae8b5dbbd8c5 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -27,7 +27,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
-	$(obj)/piggy.o
+	$(obj)/piggy.o $(obj)/cpuflags.o $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
new file mode 100644
index 000000000000..90a21f430117
--- /dev/null
+++ b/arch/x86/boot/compressed/aslr.c
@@ -0,0 +1,316 @@
+#include "misc.h"
+
+#ifdef CONFIG_RANDOMIZE_BASE
+#include <asm/msr.h>
+#include <asm/archrandom.h>
+#include <asm/e820.h>
+
+#include <generated/compile.h>
+#include <linux/module.h>
+#include <linux/uts.h>
+#include <linux/utsname.h>
+#include <generated/utsrelease.h>
+
+/* Simplified build-specific string for starting entropy. */
+static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
+
+#define I8254_PORT_CONTROL	0x43
+#define I8254_PORT_COUNTER0	0x40
+#define I8254_CMD_READBACK	0xC0
+#define I8254_SELECT_COUNTER0	0x02
+#define I8254_STATUS_NOTREADY	0x40
+static inline u16 i8254(void)
+{
+	u16 status, timer;
+
+	do {
+		outb(I8254_PORT_CONTROL,
+		     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
+		status = inb(I8254_PORT_COUNTER0);
+		timer  = inb(I8254_PORT_COUNTER0);
+		timer |= inb(I8254_PORT_COUNTER0) << 8;
+	} while (status & I8254_STATUS_NOTREADY);
+
+	return timer;
+}
+
+static unsigned long rotate_xor(unsigned long hash, const void *area,
+				size_t size)
+{
+	size_t i;
+	unsigned long *ptr = (unsigned long *)area;
+
+	for (i = 0; i < size / sizeof(hash); i++) {
+		/* Rotate by odd number of bits and XOR. */
+		hash = (hash << ((sizeof(hash) * 8) - 7)) | (hash >> 7);
+		hash ^= ptr[i];
+	}
+
+	return hash;
+}
+
+/* Attempt to create a simple but unpredictable starting entropy. */
+static unsigned long get_random_boot(void)
+{
+	unsigned long hash = 0;
+
+	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	hash = rotate_xor(hash, real_mode, sizeof(*real_mode));
+
+	return hash;
+}
+
+static unsigned long get_random_long(void)
+{
+#ifdef CONFIG_X86_64
+	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
+#else
+	const unsigned long mix_const = 0x3f39e593UL;
+#endif
+	unsigned long raw, random = get_random_boot();
+	bool use_i8254 = true;
+
+	debug_putstr("KASLR using");
+
+	if (has_cpuflag(X86_FEATURE_RDRAND)) {
+		debug_putstr(" RDRAND");
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
+	}
+
+	if (has_cpuflag(X86_FEATURE_TSC)) {
+		debug_putstr(" RDTSC");
+		rdtscll(raw);
+
+		random ^= raw;
+		use_i8254 = false;
+	}
+
+	if (use_i8254) {
+		debug_putstr(" i8254");
+		random ^= i8254();
+	}
+
+	/* Circular multiply for better bit diffusion */
+	asm("mul %3"
+	    : "=a" (random), "=d" (raw)
+	    : "a" (random), "rm" (mix_const));
+	random += raw;
+
+	debug_putstr("...\n");
+
+	return random;
+}
+
+struct mem_vector {
+	unsigned long start;
+	unsigned long size;
+};
+
+#define MEM_AVOID_MAX 5
+struct mem_vector mem_avoid[MEM_AVOID_MAX];
+
+static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
+{
+	/* Item at least partially before region. */
+	if (item->start < region->start)
+		return false;
+	/* Item at least partially after region. */
+	if (item->start + item->size > region->start + region->size)
+		return false;
+	return true;
+}
+
+static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
+{
+	/* Item one is entirely before item two. */
+	if (one->start + one->size <= two->start)
+		return false;
+	/* Item one is entirely after item two. */
+	if (one->start >= two->start + two->size)
+		return false;
+	return true;
+}
+
+static void mem_avoid_init(unsigned long input, unsigned long input_size,
+			   unsigned long output, unsigned long output_size)
+{
+	u64 initrd_start, initrd_size;
+	u64 cmd_line, cmd_line_size;
+	unsigned long unsafe, unsafe_len;
+	char *ptr;
+
+	/*
+	 * Avoid the region that is unsafe to overlap during
+	 * decompression (see calculations at top of misc.c).
+	 */
+	unsafe_len = (output_size >> 12) + 32768 + 18;
+	unsafe = (unsigned long)input + input_size - unsafe_len;
+	mem_avoid[0].start = unsafe;
+	mem_avoid[0].size = unsafe_len;
+
+	/* Avoid initrd. */
+	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
+	initrd_start |= real_mode->hdr.ramdisk_image;
+	initrd_size  = (u64)real_mode->ext_ramdisk_size << 32;
+	initrd_size |= real_mode->hdr.ramdisk_size;
+	mem_avoid[1].start = initrd_start;
+	mem_avoid[1].size = initrd_size;
+
+	/* Avoid kernel command line. */
+	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
+	cmd_line |= real_mode->hdr.cmd_line_ptr;
+	/* Calculate size of cmd_line. */
+	ptr = (char *)(unsigned long)cmd_line;
+	for (cmd_line_size = 0; ptr[cmd_line_size++]; )
+		;
+	mem_avoid[2].start = cmd_line;
+	mem_avoid[2].size = cmd_line_size;
+
+	/* Avoid heap memory. */
+	mem_avoid[3].start = (unsigned long)free_mem_ptr;
+	mem_avoid[3].size = BOOT_HEAP_SIZE;
+
+	/* Avoid stack memory. */
+	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
+	mem_avoid[4].size = BOOT_STACK_SIZE;
+}
+
+/* Does this memory vector overlap a known avoided area? */
+bool mem_avoid_overlap(struct mem_vector *img)
+{
+	int i;
+
+	for (i = 0; i < MEM_AVOID_MAX; i++) {
+		if (mem_overlaps(img, &mem_avoid[i]))
+			return true;
+	}
+
+	return false;
+}
+
+unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET / CONFIG_PHYSICAL_ALIGN];
+unsigned long slot_max = 0;
+
+static void slots_append(unsigned long addr)
+{
+	/* Overflowing the slots list should be impossible. */
+	if (slot_max >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
+			CONFIG_PHYSICAL_ALIGN)
+		return;
+
+	slots[slot_max++] = addr;
+}
+
+static unsigned long slots_fetch_random(void)
+{
+	/* Handle case of no slots stored. */
+	if (slot_max == 0)
+		return 0;
+
+	return slots[get_random_long() % slot_max];
+}
+
+static void process_e820_entry(struct e820entry *entry,
+			       unsigned long minimum,
+			       unsigned long image_size)
+{
+	struct mem_vector region, img;
+
+	/* Skip non-RAM entries. */
+	if (entry->type != E820_RAM)
+		return;
+
+	/* Ignore entries entirely above our maximum. */
+	if (entry->addr >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		return;
+
+	/* Ignore entries entirely below our minimum. */
+	if (entry->addr + entry->size < minimum)
+		return;
+
+	region.start = entry->addr;
+	region.size = entry->size;
+
+	/* Potentially raise address to minimum location. */
+	if (region.start < minimum)
+		region.start = minimum;
+
+	/* Potentially raise address to meet alignment requirements. */
+	region.start = ALIGN(region.start, CONFIG_PHYSICAL_ALIGN);
+
+	/* Did we raise the address above the bounds of this e820 region? */
+	if (region.start > entry->addr + entry->size)
+		return;
+
+	/* Reduce size by any delta from the original address. */
+	region.size -= region.start - entry->addr;
+
+	/* Reduce maximum size to fit end of image within maximum limit. */
+	if (region.start + region.size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		region.size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - region.start;
+
+	/* Walk each aligned slot and check for avoided areas. */
+	for (img.start = region.start, img.size = image_size ;
+	     mem_contains(&region, &img) ;
+	     img.start += CONFIG_PHYSICAL_ALIGN) {
+		if (mem_avoid_overlap(&img))
+			continue;
+		slots_append(img.start);
+	}
+}
+
+static unsigned long find_random_addr(unsigned long minimum,
+				      unsigned long size)
+{
+	int i;
+	unsigned long addr;
+
+	/* Make sure minimum is aligned. */
+	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
+
+	/* Verify potential e820 positions, appending to slots list. */
+	for (i = 0; i < real_mode->e820_entries; i++) {
+		process_e820_entry(&real_mode->e820_map[i], minimum, size);
+	}
+
+	return slots_fetch_random();
+}
+
+unsigned char *choose_kernel_location(unsigned char *input,
+				      unsigned long input_size,
+				      unsigned char *output,
+				      unsigned long output_size)
+{
+	unsigned long choice = (unsigned long)output;
+	unsigned long random;
+
+	if (cmdline_find_option_bool("nokaslr")) {
+		debug_putstr("KASLR disabled...\n");
+		goto out;
+	}
+
+	/* Record the various known unsafe memory ranges. */
+	mem_avoid_init((unsigned long)input, input_size,
+		       (unsigned long)output, output_size);
+
+	/* Walk e820 and find a random address. */
+	random = find_random_addr(choice, output_size);
+	if (!random) {
+		debug_putstr("KASLR could not find suitable E820 region...\n");
+		goto out;
+	}
+
+	/* Always enforce the minimum. */
+	if (random < choice)
+		goto out;
+
+	choice = random;
+out:
+	return (unsigned char *)choice;
+}
+
+#endif /* CONFIG_RANDOMIZE_BASE */
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index bffd73b45b1f..b68e3033e6b9 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -1,6 +1,6 @@
 #include "misc.h"
 
-#ifdef CONFIG_EARLY_PRINTK
+#if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE
 
 static unsigned long fs;
 static inline void set_fs(unsigned long seg)
diff --git a/arch/x86/boot/compressed/cpuflags.c b/arch/x86/boot/compressed/cpuflags.c
new file mode 100644
index 000000000000..aa313466118b
--- /dev/null
+++ b/arch/x86/boot/compressed/cpuflags.c
@@ -0,0 +1,12 @@
+#ifdef CONFIG_RANDOMIZE_BASE
+
+#include "../cpuflags.c"
+
+bool has_cpuflag(int flag)
+{
+	get_cpuflags();
+
+	return test_bit(flag, cpu.flags);
+}
+
+#endif
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 5d6f6891b188..9116aac232c7 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -117,9 +117,11 @@ preferred_addr:
 	addl    %eax, %ebx
 	notl	%eax
 	andl    %eax, %ebx
-#else
-	movl	$LOAD_PHYSICAL_ADDR, %ebx
+	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
+	jge	1f
 #endif
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
+1:
 
 	/* Target address to relocate to for decompression */
 	addl	$z_extract_offset, %ebx
@@ -191,14 +193,14 @@ relocated:
 	leal	boot_heap(%ebx), %eax
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
-	call	decompress_kernel
+	call	decompress_kernel /* returns kernel location in %eax */
 	addl	$24, %esp
 
 /*
  * Jump to the decompressed kernel.
  */
 	xorl	%ebx, %ebx
-	jmp	*%ebp
+	jmp	*%eax
 
 /*
  * Stack and heap for uncompression
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c337422b575d..c5c1ae0997e7 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -94,9 +94,11 @@ ENTRY(startup_32)
 	addl	%eax, %ebx
 	notl	%eax
 	andl	%eax, %ebx
-#else
-	movl	$LOAD_PHYSICAL_ADDR, %ebx
+	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
+	jge	1f
 #endif
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
+1:
 
 	/* Target address to relocate to for decompression */
 	addl	$z_extract_offset, %ebx
@@ -269,9 +271,11 @@ preferred_addr:
 	addq	%rax, %rbp
 	notq	%rax
 	andq	%rax, %rbp
-#else
-	movq	$LOAD_PHYSICAL_ADDR, %rbp
+	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
+	jge	1f
 #endif
+	movq	$LOAD_PHYSICAL_ADDR, %rbp
+1:
 
 	/* Target address to relocate to for decompression */
 	leaq	z_extract_offset(%rbp), %rbx
@@ -339,13 +343,13 @@ relocated:
 	movl	$z_input_len, %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
 	movq	$z_output_len, %r9	/* decompressed length */
-	call	decompress_kernel
+	call	decompress_kernel	/* returns kernel location in %rax */
 	popq	%rsi
 
 /*
  * Jump to the decompressed kernel.
  */
-	jmp	*%rbp
+	jmp	*%rax
 
 	.code32
 no_longmode:
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 434f077d2c4d..196eaf373a06 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -112,14 +112,8 @@ struct boot_params *real_mode;		/* Pointer to real-mode data */
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
 
-#ifdef CONFIG_X86_64
-#define memptr long
-#else
-#define memptr unsigned
-#endif
-
-static memptr free_mem_ptr;
-static memptr free_mem_end_ptr;
+memptr free_mem_ptr;
+memptr free_mem_end_ptr;
 
 static char *vidmem;
 static int vidport;
@@ -395,7 +389,7 @@ static void parse_elf(void *output)
 	free(phdrs);
 }
 
-asmlinkage void decompress_kernel(void *rmode, memptr heap,
+asmlinkage void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
@@ -422,6 +416,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	output = choose_kernel_location(input_data, input_len,
+					output, output_len);
+
+	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
 		error("Destination address inappropriately aligned");
 #ifdef CONFIG_X86_64
@@ -441,5 +439,5 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	parse_elf(output);
 	handle_relocations(output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
-	return;
+	return output;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 674019d8e235..24e3e569a13c 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -23,7 +23,15 @@
 #define BOOT_BOOT_H
 #include "../ctype.h"
 
+#ifdef CONFIG_X86_64
+#define memptr long
+#else
+#define memptr unsigned
+#endif
+
 /* misc.c */
+extern memptr free_mem_ptr;
+extern memptr free_mem_end_ptr;
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
 void __putstr(const char *s);
 #define error_putstr(__x)  __putstr(__x)
@@ -39,23 +47,40 @@ static inline void debug_putstr(const char *s)
 
 #endif
 
-#ifdef CONFIG_EARLY_PRINTK
-
+#if CONFIG_EARLY_PRINTK || CONFIG_RANDOMIZE_BASE
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
+#endif
 
-/* early_serial_console.c */
-extern int early_serial_base;
-void console_init(void);
 
+#if CONFIG_RANDOMIZE_BASE
+/* aslr.c */
+unsigned char *choose_kernel_location(unsigned char *input,
+				      unsigned long input_size,
+				      unsigned char *output,
+				      unsigned long output_size);
+/* cpuflags.c */
+bool has_cpuflag(int flag);
 #else
+static inline
+unsigned char *choose_kernel_location(unsigned char *input,
+				      unsigned long input_size,
+				      unsigned char *output,
+				      unsigned long output_size)
+{
+	return output;
+}
+#endif
 
+#ifdef CONFIG_EARLY_PRINTK
 /* early_serial_console.c */
+extern int early_serial_base;
+void console_init(void);
+#else
 static const int early_serial_base;
 static inline void console_init(void)
 { }
-
 #endif
 
 #endif
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4d3ff037201f..100a9a10076a 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -28,8 +28,6 @@
 #include <asm/required-features.h>
 #include <asm/msr-index.h>
 
-struct cpu_features cpu;
-static u32 cpu_vendor[3];
 static u32 err_flags[NCAPINTS];
 
 static const int req_level = CONFIG_X86_MINIMUM_CPU_FAMILY;
@@ -69,92 +67,8 @@ static int is_transmeta(void)
 	       cpu_vendor[2] == A32('M', 'x', '8', '6');
 }
 
-static int has_fpu(void)
-{
-	u16 fcw = -1, fsw = -1;
-	u32 cr0;
-
-	asm("movl %%cr0,%0" : "=r" (cr0));
-	if (cr0 & (X86_CR0_EM|X86_CR0_TS)) {
-		cr0 &= ~(X86_CR0_EM|X86_CR0_TS);
-		asm volatile("movl %0,%%cr0" : : "r" (cr0));
-	}
-
-	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
-		     : "+m" (fsw), "+m" (fcw));
-
-	return fsw == 0 && (fcw & 0x103f) == 0x003f;
-}
-
-static int has_eflag(u32 mask)
-{
-	u32 f0, f1;
-
-	asm("pushfl ; "
-	    "pushfl ; "
-	    "popl %0 ; "
-	    "movl %0,%1 ; "
-	    "xorl %2,%1 ; "
-	    "pushl %1 ; "
-	    "popfl ; "
-	    "pushfl ; "
-	    "popl %1 ; "
-	    "popfl"
-	    : "=&r" (f0), "=&r" (f1)
-	    : "ri" (mask));
-
-	return !!((f0^f1) & mask);
-}
-
-static void get_flags(void)
-{
-	u32 max_intel_level, max_amd_level;
-	u32 tfms;
-
-	if (has_fpu())
-		set_bit(X86_FEATURE_FPU, cpu.flags);
-
-	if (has_eflag(X86_EFLAGS_ID)) {
-		asm("cpuid"
-		    : "=a" (max_intel_level),
-		      "=b" (cpu_vendor[0]),
-		      "=d" (cpu_vendor[1]),
-		      "=c" (cpu_vendor[2])
-		    : "a" (0));
-
-		if (max_intel_level >= 0x00000001 &&
-		    max_intel_level <= 0x0000ffff) {
-			asm("cpuid"
-			    : "=a" (tfms),
-			      "=c" (cpu.flags[4]),
-			      "=d" (cpu.flags[0])
-			    : "a" (0x00000001)
-			    : "ebx");
-			cpu.level = (tfms >> 8) & 15;
-			cpu.model = (tfms >> 4) & 15;
-			if (cpu.level >= 6)
-				cpu.model += ((tfms >> 16) & 0xf) << 4;
-		}
-
-		asm("cpuid"
-		    : "=a" (max_amd_level)
-		    : "a" (0x80000000)
-		    : "ebx", "ecx", "edx");
-
-		if (max_amd_level >= 0x80000001 &&
-		    max_amd_level <= 0x8000ffff) {
-			u32 eax = 0x80000001;
-			asm("cpuid"
-			    : "+a" (eax),
-			      "=c" (cpu.flags[6]),
-			      "=d" (cpu.flags[1])
-			    : : "ebx");
-		}
-	}
-}
-
 /* Returns a bitmask of which words we have error bits in */
-static int check_flags(void)
+static int check_cpuflags(void)
 {
 	u32 err;
 	int i;
@@ -187,8 +101,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 	if (has_eflag(X86_EFLAGS_AC))
 		cpu.level = 4;
 
-	get_flags();
-	err = check_flags();
+	get_cpuflags();
+	err = check_cpuflags();
 
 	if (test_bit(X86_FEATURE_LM, cpu.flags))
 		cpu.level = 64;
@@ -207,8 +121,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		eax &= ~(1 << 15);
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
-		get_flags();	/* Make sure it really did something */
-		err = check_flags();
+		get_cpuflags();	/* Make sure it really did something */
+		err = check_cpuflags();
 	} else if (err == 0x01 &&
 		   !(err_flags[0] & ~(1 << X86_FEATURE_CX8)) &&
 		   is_centaur() && cpu.model >= 6) {
@@ -223,7 +137,7 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
 		set_bit(X86_FEATURE_CX8, cpu.flags);
-		err = check_flags();
+		err = check_cpuflags();
 	} else if (err == 0x01 && is_transmeta()) {
 		/* Transmeta might have masked feature bits in word 0 */
 
@@ -238,7 +152,7 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		    : : "ecx", "ebx");
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
-		err = check_flags();
+		err = check_cpuflags();
 	}
 
 	if (err_flags_ptr)
diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
new file mode 100644
index 000000000000..a9fcb7cfb241
--- /dev/null
+++ b/arch/x86/boot/cpuflags.c
@@ -0,0 +1,104 @@
+#include <linux/types.h>
+#include "bitops.h"
+
+#include <asm/processor-flags.h>
+#include <asm/required-features.h>
+#include <asm/msr-index.h>
+#include "cpuflags.h"
+
+struct cpu_features cpu;
+u32 cpu_vendor[3];
+
+static bool loaded_flags;
+
+static int has_fpu(void)
+{
+	u16 fcw = -1, fsw = -1;
+	unsigned long cr0;
+
+	asm volatile("mov %%cr0,%0" : "=r" (cr0));
+	if (cr0 & (X86_CR0_EM|X86_CR0_TS)) {
+		cr0 &= ~(X86_CR0_EM|X86_CR0_TS);
+		asm volatile("mov %0,%%cr0" : : "r" (cr0));
+	}
+
+	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
+		     : "+m" (fsw), "+m" (fcw));
+
+	return fsw == 0 && (fcw & 0x103f) == 0x003f;
+}
+
+int has_eflag(unsigned long mask)
+{
+	unsigned long f0, f1;
+
+	asm volatile("pushf	\n\t"
+		     "pushf	\n\t"
+		     "pop %0	\n\t"
+		     "mov %0,%1	\n\t"
+		     "xor %2,%1	\n\t"
+		     "push %1	\n\t"
+		     "popf	\n\t"
+		     "pushf	\n\t"
+		     "pop %1	\n\t"
+		     "popf"
+		     : "=&r" (f0), "=&r" (f1)
+		     : "ri" (mask));
+
+	return !!((f0^f1) & mask);
+}
+
+/* Handle x86_32 PIC using ebx. */
+#if defined(__i386__) && defined(__PIC__)
+# define EBX_REG "=r"
+#else
+# define EBX_REG "=b"
+#endif
+
+static inline void cpuid(u32 id, u32 *a, u32 *b, u32 *c, u32 *d)
+{
+	asm volatile(".ifnc %%ebx,%3 ; movl  %%ebx,%3 ; .endif	\n\t"
+		     "cpuid					\n\t"
+		     ".ifnc %%ebx,%3 ; xchgl %%ebx,%3 ; .endif	\n\t"
+		    : "=a" (*a), "=c" (*c), "=d" (*d), EBX_REG (*b)
+		    : "a" (id)
+	);
+}
+
+void get_cpuflags(void)
+{
+	u32 max_intel_level, max_amd_level;
+	u32 tfms;
+	u32 ignored;
+
+	if (loaded_flags)
+		return;
+	loaded_flags = true;
+
+	if (has_fpu())
+		set_bit(X86_FEATURE_FPU, cpu.flags);
+
+	if (has_eflag(X86_EFLAGS_ID)) {
+		cpuid(0x0, &max_intel_level, &cpu_vendor[0], &cpu_vendor[2],
+		      &cpu_vendor[1]);
+
+		if (max_intel_level >= 0x00000001 &&
+		    max_intel_level <= 0x0000ffff) {
+			cpuid(0x1, &tfms, &ignored, &cpu.flags[4],
+			      &cpu.flags[0]);
+			cpu.level = (tfms >> 8) & 15;
+			cpu.model = (tfms >> 4) & 15;
+			if (cpu.level >= 6)
+				cpu.model += ((tfms >> 16) & 0xf) << 4;
+		}
+
+		cpuid(0x80000000, &max_amd_level, &ignored, &ignored,
+		      &ignored);
+
+		if (max_amd_level >= 0x80000001 &&
+		    max_amd_level <= 0x8000ffff) {
+			cpuid(0x80000001, &ignored, &ignored, &cpu.flags[6],
+			      &cpu.flags[1]);
+		}
+	}
+}
diff --git a/arch/x86/boot/cpuflags.h b/arch/x86/boot/cpuflags.h
new file mode 100644
index 000000000000..ea97697e51e4
--- /dev/null
+++ b/arch/x86/boot/cpuflags.h
@@ -0,0 +1,19 @@
+#ifndef BOOT_CPUFLAGS_H
+#define BOOT_CPUFLAGS_H
+
+#include <asm/cpufeature.h>
+#include <asm/processor-flags.h>
+
+struct cpu_features {
+	int level;		/* Family, or 64 for x86-64 */
+	int model;
+	u32 flags[NCAPINTS];
+};
+
+extern struct cpu_features cpu;
+extern u32 cpu_vendor[3];
+
+int has_eflag(unsigned long mask);
+void get_cpuflags(void);
+
+#endif
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index 0d9ec770f2f8..e6a92455740e 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -39,6 +39,20 @@
 
 #ifdef CONFIG_ARCH_RANDOM
 
+/* Instead of arch_get_random_long() when alternatives haven't run. */
+static inline int rdrand_long(unsigned long *v)
+{
+	int ok;
+	asm volatile("1: " RDRAND_LONG "\n\t"
+		     "jc 2f\n\t"
+		     "decl %0\n\t"
+		     "jnz 1b\n\t"
+		     "2:"
+		     : "=r" (ok), "=a" (*v)
+		     : "0" (RDRAND_RETRY_LOOPS));
+	return ok;
+}
+
 #define GET_RANDOM(name, type, rdrand, nop)			\
 static inline int name(type *v)					\
 {								\
@@ -68,6 +82,13 @@ GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP3);
 
 #endif /* CONFIG_X86_64 */
 
+#else
+
+static inline int rdrand_long(unsigned long *v)
+{
+	return 0;
+}
+
 #endif  /* CONFIG_ARCH_RANDOM */
 
 extern void x86_init_rdrand(struct cpuinfo_x86 *c);
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 43dcd804ebd5..8de6d9cf3b95 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -39,9 +39,18 @@
 #define __VIRTUAL_MASK_SHIFT	47
 
 /*
- * Kernel image size is limited to 512 MB (see level2_kernel_pgt in
- * arch/x86/kernel/head_64.S), and it is mapped here:
+ * Kernel image size is limited to 1GiB due to the fixmap living in the
+ * next 1GiB (see level2_kernel_pgt in arch/x86/kernel/head_64.S). Use
+ * 512MiB by default, leaving 1.5GiB for modules once the page tables
+ * are fully set up. If kernel ASLR is configured, it can extend the
+ * kernel page table mapping, reducing the size of the modules area.
  */
-#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
+#define KERNEL_IMAGE_SIZE_DEFAULT      (512 * 1024 * 1024)
+#if defined(CONFIG_RANDOMIZE_BASE) && \
+	CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE_DEFAULT
+#define KERNEL_IMAGE_SIZE   CONFIG_RANDOMIZE_BASE_MAX_OFFSET
+#else
+#define KERNEL_IMAGE_SIZE      KERNEL_IMAGE_SIZE_DEFAULT
+#endif
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 2d883440cb9a..c883bf726398 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -58,7 +58,7 @@ typedef struct { pteval_t pte; } pte_t;
 #define VMALLOC_START    _AC(0xffffc90000000000, UL)
 #define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
-#define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
+#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
diff --git a/arch/x86/kernel/cpu/rdrand.c b/arch/x86/kernel/cpu/rdrand.c
index 88db010845cb..384df5105fbc 100644
--- a/arch/x86/kernel/cpu/rdrand.c
+++ b/arch/x86/kernel/cpu/rdrand.c
@@ -31,20 +31,6 @@ static int __init x86_rdrand_setup(char *s)
 }
 __setup("nordrand", x86_rdrand_setup);
 
-/* We can't use arch_get_random_long() here since alternatives haven't run */
-static inline int rdrand_long(unsigned long *v)
-{
-	int ok;
-	asm volatile("1: " RDRAND_LONG "\n\t"
-		     "jc 2f\n\t"
-		     "decl %0\n\t"
-		     "jnz 1b\n\t"
-		     "2:"
-		     : "=r" (ok), "=a" (*v)
-		     : "0" (RDRAND_RETRY_LOOPS));
-	return ok;
-}
-
 /*
  * Force a reseed cycle; we are architecturally guaranteed a reseed
  * after no more than 512 128-bit chunks of random data.  This also
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de6294b955..1708862fc40d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -824,6 +824,20 @@ static void __init trim_low_memory_range(void)
 }
 	
 /*
+ * Dump out kernel offset information on panic.
+ */
+static int
+dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
+{
+	pr_emerg("Kernel Offset: 0x%lx from 0x%lx "
+		 "(relocation range: 0x%lx-0x%lx)\n",
+		 (unsigned long)&_text - __START_KERNEL, __START_KERNEL,
+		 __START_KERNEL_map, MODULES_VADDR-1);
+
+	return 0;
+}
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
 }
 
 #endif /* CONFIG_X86_32 */
+
+static struct notifier_block kernel_offset_notifier = {
+	.notifier_call = dump_kernel_offset
+};
+
+static int __init register_kernel_offset_dumper(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list,
+					&kernel_offset_notifier);
+	return 0;
+}
+__initcall(register_kernel_offset_dumper);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 4287f1ffba7e..5bdc5430597c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -806,6 +806,9 @@ void __init mem_init(void)
 	BUILD_BUG_ON(VMALLOC_START			>= VMALLOC_END);
 #undef high_memory
 #undef __FIXADDR_TOP
+#ifdef CONFIG_RANDOMIZE_BASE
+	BUILD_BUG_ON(CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE);
+#endif
 
 #ifdef CONFIG_HIGHMEM
 	BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index f7bab68a4b83..11f9285a2ff6 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -722,15 +722,25 @@ static void percpu_init(void)
 
 /*
  * Check to see if a symbol lies in the .data..percpu section.
- * For some as yet not understood reason the "__init_begin"
- * symbol which immediately preceeds the .data..percpu section
- * also shows up as it it were part of it so we do an explict
- * check for that symbol name and ignore it.
+ *
+ * The linker incorrectly associates some symbols with the
+ * .data..percpu section so we also need to check the symbol
+ * name to make sure that we classify the symbol correctly.
+ *
+ * The GNU linker incorrectly associates:
+ *	__init_begin
+ *	__per_cpu_load
+ *
+ * The "gold" linker incorrectly associates:
+ *	init_per_cpu__irq_stack_union
+ *	init_per_cpu__gdt_page
  */
 static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 {
 	return (sym->st_shndx == per_cpu_shndx) &&
-		strcmp(symname, "__init_begin");
+		strcmp(symname, "__init_begin") &&
+		strcmp(symname, "__per_cpu_load") &&
+		strncmp(symname, "init_per_cpu_", 13);
 }
 
 
