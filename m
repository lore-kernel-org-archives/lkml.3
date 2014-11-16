Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaKPJH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:07:59 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48079 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaKPJHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:07:49 -0500
Date: Sun, 16 Nov 2014 10:07:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20141116090743.GA19172@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 0cafa3e714fa34af100c575ada31d52caea20957 Merge tag 'microcode_fixes_for_3.18' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp into x86/urgent

Microcode fixes, a Xen fix and a KASLR boot loading fix with 
certain memory layouts.

 Thanks,

	Ingo

------------------>
Boris Ostrovsky (1):
      x86/core, x86/xen/smp: Use 'die_complete' completion when taking CPU down

Borislav Petkov (3):
      x86, microcode, AMD: Fix early ucode loading on 32-bit
      x86, microcode: Fix accessing dis_ucode_ldr on 32-bit
      x86, microcode, AMD: Fix ucode patch stashing on 32-bit

Junjie Mao (1):
      x86, kaslr: Prevent .bss from overlaping initrd


 arch/x86/boot/compressed/Makefile          |  4 +++-
 arch/x86/boot/compressed/head_32.S         |  5 +++--
 arch/x86/boot/compressed/head_64.S         |  5 ++++-
 arch/x86/boot/compressed/misc.c            | 13 +++++++++---
 arch/x86/boot/compressed/mkpiggy.c         |  9 ++++++--
 arch/x86/include/asm/smp.h                 |  1 +
 arch/x86/kernel/cpu/microcode/amd_early.c  | 33 +++++++++++++++++++-----------
 arch/x86/kernel/cpu/microcode/core_early.c |  2 +-
 arch/x86/kernel/smpboot.c                  | 15 ++++++++++----
 arch/x86/tools/calc_run_size.pl            | 30 +++++++++++++++++++++++++++
 arch/x86/xen/smp.c                         |  3 +++
 11 files changed, 94 insertions(+), 26 deletions(-)
 create mode 100644 arch/x86/tools/calc_run_size.pl

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 704f58aa79cd..be1e07d4b596 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -76,8 +76,10 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
+RUN_SIZE = $(shell objdump -h vmlinux | \
+	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
 quiet_cmd_mkpiggy = MKPIGGY $@
-      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
+      cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
 
 targets += piggy.S
 $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index cbed1407a5cd..1d7fbbcc196d 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -207,7 +207,8 @@ ENDPROC(startup_32)
  * Do the decompression, and jump to the new kernel..
  */
 				/* push arguments for decompress_kernel: */
-	pushl	$z_output_len	/* decompressed length */
+	pushl	$z_run_size	/* size of kernel with .bss and .brk */
+	pushl	$z_output_len	/* decompressed length, end of relocs */
 	leal	z_extract_offset_negative(%ebx), %ebp
 	pushl	%ebp		/* output address */
 	pushl	$z_input_len	/* input_len */
@@ -217,7 +218,7 @@ ENDPROC(startup_32)
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	decompress_kernel /* returns kernel location in %eax */
-	addl	$24, %esp
+	addl	$28, %esp
 
 /*
  * Jump to the decompressed kernel.
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2884e0c3e8a5..6b1766c6c082 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -402,13 +402,16 @@ ENDPROC(efi64_stub_entry)
  * Do the decompression, and jump to the new kernel..
  */
 	pushq	%rsi			/* Save the real mode argument */
+	movq	$z_run_size, %r9	/* size of kernel with .bss and .brk */
+	pushq	%r9
 	movq	%rsi, %rdi		/* real mode address */
 	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
 	leaq	input_data(%rip), %rdx  /* input_data */
 	movl	$z_input_len, %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
-	movq	$z_output_len, %r9	/* decompressed length */
+	movq	$z_output_len, %r9	/* decompressed length, end of relocs */
 	call	decompress_kernel	/* returns kernel location in %rax */
+	popq	%r9
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 57ab74df7eea..30dd59a9f0b4 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -358,7 +358,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
-				  unsigned long output_len)
+				  unsigned long output_len,
+				  unsigned long run_size)
 {
 	real_mode = rmode;
 
@@ -381,8 +382,14 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
-	output = choose_kernel_location(input_data, input_len,
-					output, output_len);
+	/*
+	 * The memory hole needed for the kernel is the larger of either
+	 * the entire decompressed kernel plus relocation table, or the
+	 * entire decompressed kernel plus .bss and .brk sections.
+	 */
+	output = choose_kernel_location(input_data, input_len, output,
+					output_len > run_size ? output_len
+							      : run_size);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index b669ab65bf6c..d8222f213182 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -36,11 +36,13 @@ int main(int argc, char *argv[])
 	uint32_t olen;
 	long ilen;
 	unsigned long offs;
+	unsigned long run_size;
 	FILE *f = NULL;
 	int retval = 1;
 
-	if (argc < 2) {
-		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
+	if (argc < 3) {
+		fprintf(stderr, "Usage: %s compressed_file run_size\n",
+				argv[0]);
 		goto bail;
 	}
 
@@ -74,6 +76,7 @@ int main(int argc, char *argv[])
 	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
 	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
 	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
+	run_size = atoi(argv[2]);
 
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
 	printf(".globl z_input_len\n");
@@ -85,6 +88,8 @@ int main(int argc, char *argv[])
 	/* z_extract_offset_negative allows simplification of head_32.S */
 	printf(".globl z_extract_offset_negative\n");
 	printf("z_extract_offset_negative = -0x%lx\n", offs);
+	printf(".globl z_run_size\n");
+	printf("z_run_size = %lu\n", run_size);
 
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 8cd27e08e23c..8cd1cc3bc835 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -150,6 +150,7 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 }
 
 void cpu_disable_common(void);
+void cpu_die_common(unsigned int cpu);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 7aa1acc79789..06674473b0e6 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -108,12 +108,13 @@ static size_t compute_container_size(u8 *data, u32 total_size)
  * load_microcode_amd() to save equivalent cpu table and microcode patches in
  * kernel heap memory.
  */
-static void apply_ucode_in_initrd(void *ucode, size_t size)
+static void apply_ucode_in_initrd(void *ucode, size_t size, bool save_patch)
 {
 	struct equiv_cpu_entry *eq;
 	size_t *cont_sz;
 	u32 *header;
 	u8  *data, **cont;
+	u8 (*patch)[PATCH_MAX_SIZE];
 	u16 eq_id = 0;
 	int offset, left;
 	u32 rev, eax, ebx, ecx, edx;
@@ -123,10 +124,12 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
 	cont_sz = (size_t *)__pa_nodebug(&container_size);
 	cont	= (u8 **)__pa_nodebug(&container);
+	patch	= (u8 (*)[PATCH_MAX_SIZE])__pa_nodebug(&amd_ucode_patch);
 #else
 	new_rev = &ucode_new_rev;
 	cont_sz = &container_size;
 	cont	= &container;
+	patch	= &amd_ucode_patch;
 #endif
 
 	data   = ucode;
@@ -213,9 +216,9 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 				rev = mc->hdr.patch_id;
 				*new_rev = rev;
 
-				/* save ucode patch */
-				memcpy(amd_ucode_patch, mc,
-				       min_t(u32, header[1], PATCH_MAX_SIZE));
+				if (save_patch)
+					memcpy(patch, mc,
+					       min_t(u32, header[1], PATCH_MAX_SIZE));
 			}
 		}
 
@@ -246,7 +249,7 @@ void __init load_ucode_amd_bsp(void)
 	*data = cp.data;
 	*size = cp.size;
 
-	apply_ucode_in_initrd(cp.data, cp.size);
+	apply_ucode_in_initrd(cp.data, cp.size, true);
 }
 
 #ifdef CONFIG_X86_32
@@ -263,7 +266,7 @@ void load_ucode_amd_ap(void)
 	size_t *usize;
 	void **ucode;
 
-	mc = (struct microcode_amd *)__pa(amd_ucode_patch);
+	mc = (struct microcode_amd *)__pa_nodebug(amd_ucode_patch);
 	if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
 		__apply_microcode_amd(mc);
 		return;
@@ -275,7 +278,7 @@ void load_ucode_amd_ap(void)
 	if (!*ucode || !*usize)
 		return;
 
-	apply_ucode_in_initrd(*ucode, *usize);
+	apply_ucode_in_initrd(*ucode, *usize, false);
 }
 
 static void __init collect_cpu_sig_on_bsp(void *arg)
@@ -339,7 +342,7 @@ void load_ucode_amd_ap(void)
 		 * AP has a different equivalence ID than BSP, looks like
 		 * mixed-steppings silicon so go through the ucode blob anew.
 		 */
-		apply_ucode_in_initrd(ucode_cpio.data, ucode_cpio.size);
+		apply_ucode_in_initrd(ucode_cpio.data, ucode_cpio.size, false);
 	}
 }
 #endif
@@ -347,7 +350,9 @@ void load_ucode_amd_ap(void)
 int __init save_microcode_in_initrd_amd(void)
 {
 	unsigned long cont;
+	int retval = 0;
 	enum ucode_state ret;
+	u8 *cont_va;
 	u32 eax;
 
 	if (!container)
@@ -355,13 +360,15 @@ int __init save_microcode_in_initrd_amd(void)
 
 #ifdef CONFIG_X86_32
 	get_bsp_sig();
-	cont = (unsigned long)container;
+	cont	= (unsigned long)container;
+	cont_va = __va(container);
 #else
 	/*
 	 * We need the physical address of the container for both bitness since
 	 * boot_params.hdr.ramdisk_image is a physical address.
 	 */
-	cont = __pa(container);
+	cont    = __pa(container);
+	cont_va = container;
 #endif
 
 	/*
@@ -372,6 +379,8 @@ int __init save_microcode_in_initrd_amd(void)
 	if (relocated_ramdisk)
 		container = (u8 *)(__va(relocated_ramdisk) +
 			     (cont - boot_params.hdr.ramdisk_image));
+	else
+		container = cont_va;
 
 	if (ucode_new_rev)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
@@ -382,7 +391,7 @@ int __init save_microcode_in_initrd_amd(void)
 
 	ret = load_microcode_amd(eax, container, container_size);
 	if (ret != UCODE_OK)
-		return -EINVAL;
+		retval = -EINVAL;
 
 	/*
 	 * This will be freed any msec now, stash patches for the current
@@ -391,5 +400,5 @@ int __init save_microcode_in_initrd_amd(void)
 	container = NULL;
 	container_size = 0;
 
-	return 0;
+	return retval;
 }
diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
index 5f28a64e71ea..2c017f242a78 100644
--- a/arch/x86/kernel/cpu/microcode/core_early.c
+++ b/arch/x86/kernel/cpu/microcode/core_early.c
@@ -124,7 +124,7 @@ void __init load_ucode_bsp(void)
 static bool check_loader_disabled_ap(void)
 {
 #ifdef CONFIG_X86_32
-	return __pa_nodebug(dis_ucode_ldr);
+	return *((bool *)__pa_nodebug(&dis_ucode_ldr));
 #else
 	return dis_ucode_ldr;
 #endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4d2128ac70bd..668d8f2a8781 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1303,10 +1303,14 @@ static void __ref remove_cpu_from_maps(int cpu)
 	numa_remove_cpu(cpu);
 }
 
+static DEFINE_PER_CPU(struct completion, die_complete);
+
 void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
 
+	init_completion(&per_cpu(die_complete, smp_processor_id()));
+
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
@@ -1316,8 +1320,6 @@ void cpu_disable_common(void)
 	fixup_irqs();
 }
 
-static DEFINE_PER_CPU(struct completion, die_complete);
-
 int native_cpu_disable(void)
 {
 	int ret;
@@ -1327,16 +1329,21 @@ int native_cpu_disable(void)
 		return ret;
 
 	clear_local_APIC();
-	init_completion(&per_cpu(die_complete, smp_processor_id()));
 	cpu_disable_common();
 
 	return 0;
 }
 
+void cpu_die_common(unsigned int cpu)
+{
+	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+}
+
 void native_cpu_die(unsigned int cpu)
 {
 	/* We don't do anything here: idle task is faking death itself. */
-	wait_for_completion_timeout(&per_cpu(die_complete, cpu), HZ);
+
+	cpu_die_common(cpu);
 
 	/* They ack this in play_dead() by setting CPU_DEAD */
 	if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
new file mode 100644
index 000000000000..0b0b124d3ece
--- /dev/null
+++ b/arch/x86/tools/calc_run_size.pl
@@ -0,0 +1,30 @@
+#!/usr/bin/perl
+#
+# Calculate the amount of space needed to run the kernel, including room for
+# the .bss and .brk sections.
+#
+# Usage:
+# objdump -h a.out | perl calc_run_size.pl
+use strict;
+
+my $mem_size = 0;
+my $file_offset = 0;
+
+my $sections=" *[0-9]+ \.(?:bss|brk) +";
+while (<>) {
+	if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
+		my $size = hex($1);
+		my $offset = hex($2);
+		$mem_size += $size;
+		if ($file_offset == 0) {
+			$file_offset = $offset;
+		} elsif ($file_offset != $offset) {
+			die ".bss and .brk lack common file offset\n";
+		}
+	}
+}
+
+if ($file_offset == 0) {
+	die "Never found .bss or .brk file offset\n";
+}
+printf("%d\n", $mem_size + $file_offset);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8650cdb53209..4c071aeb8417 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -510,6 +510,9 @@ static void xen_cpu_die(unsigned int cpu)
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
+
+	cpu_die_common(cpu);
+
 	xen_smp_intr_free(cpu);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
