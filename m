Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbaLIMfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:35:43 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43622 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaLIMfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:35:41 -0500
Date: Tue, 9 Dec 2014 13:35:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot tree changes for v3.19
Message-ID: <20141209123536.GA29240@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   # HEAD: 97b67ae559947f1e208439a1bf6a734da3087006 x86-64: Use RIP-relative addressing for most per-CPU accesses

This tree contains a bootable images documentation update plus 
three slightly misplaced x86/asm percpu changes/optimizations.

 Thanks,

	Ingo

------------------>
Jan Beulich (3):
      x86: Convert a few more per-CPU items to read-mostly ones
      x86-64: Handle PC-relative relocations on per-CPU data
      x86-64: Use RIP-relative addressing for most per-CPU accesses

Kees Cook (1):
      x86, boot: Document intermediates more clearly


 arch/x86/boot/compressed/Makefile | 12 ++++++++
 arch/x86/boot/compressed/misc.c   | 14 ++++++++-
 arch/x86/include/asm/percpu.h     | 61 +++++++++++++++++++++++++++++----------
 arch/x86/include/asm/processor.h  |  4 +--
 arch/x86/kernel/setup_percpu.c    |  2 +-
 arch/x86/kernel/smpboot.c         |  2 +-
 arch/x86/kernel/vmlinux.lds.S     |  2 ++
 arch/x86/tools/relocs.c           | 36 +++++++++++++++++------
 8 files changed, 103 insertions(+), 30 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 704f58aa79cd..8a3918180a9e 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -3,6 +3,18 @@
 #
 # create a compressed vmlinux image from the original vmlinux
 #
+# vmlinuz is:
+#	decompression code (*.o)
+#	asm globals (piggy.S), including:
+#		vmlinux.bin.(gz|bz2|lzma|...)
+#
+# vmlinux.bin is:
+#	vmlinux stripped of debugging and comments
+# vmlinux.bin.all is:
+#	vmlinux.bin + vmlinux.relocs
+# vmlinux.bin.(gz|bz2|lzma|...) is:
+#	(see scripts/Makefile.lib size_append)
+#	compressed vmlinux.bin.all + u32 size of vmlinux.bin.all
 
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 57ab74df7eea..644abd767c12 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -260,7 +260,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 
 	/*
 	 * Process relocations: 32 bit relocations first then 64 bit after.
-	 * Two sets of binary relocations are added to the end of the kernel
+	 * Three sets of binary relocations are added to the end of the kernel
 	 * before compression. Each relocation table entry is the kernel
 	 * address of the location which needs to be updated stored as a
 	 * 32-bit value which is sign extended to 64 bits.
@@ -270,6 +270,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * kernel bits...
 	 * 0 - zero terminator for 64 bit relocations
 	 * 64 bit relocation repeated
+	 * 0 - zero terminator for inverse 32 bit relocations
+	 * 32 bit inverse relocation repeated
 	 * 0 - zero terminator for 32 bit relocations
 	 * 32 bit relocation repeated
 	 *
@@ -286,6 +288,16 @@ static void handle_relocations(void *output, unsigned long output_len)
 		*(uint32_t *)ptr += delta;
 	}
 #ifdef CONFIG_X86_64
+	while (*--reloc) {
+		long extended = *reloc;
+		extended += map;
+
+		ptr = (unsigned long)extended;
+		if (ptr < min_addr || ptr > max_addr)
+			error("inverse 32-bit relocation outside of kernel!\n");
+
+		*(int32_t *)ptr -= delta;
+	}
 	for (reloc--; *reloc; reloc--) {
 		long extended = *reloc;
 		extended += map;
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index fd472181a1d0..e0ba66ca68c6 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -64,7 +64,7 @@
 #define __percpu_prefix		""
 #endif
 
-#define __percpu_arg(x)		__percpu_prefix "%P" #x
+#define __percpu_arg(x)		__percpu_prefix "%" #x
 
 /*
  * Initialized pointers to per-cpu variables needed for the boot
@@ -179,29 +179,58 @@ do {									\
 	}								\
 } while (0)
 
-#define percpu_from_op(op, var, constraint)		\
+#define percpu_from_op(op, var)				\
 ({							\
 	typeof(var) pfo_ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
 		    : "=q" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
 		break;					\
 	case 2:						\
 		asm(op "w "__percpu_arg(1)",%0"		\
 		    : "=r" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
 		break;					\
 	case 4:						\
 		asm(op "l "__percpu_arg(1)",%0"		\
 		    : "=r" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
 		break;					\
 	case 8:						\
 		asm(op "q "__percpu_arg(1)",%0"		\
 		    : "=r" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+	pfo_ret__;					\
+})
+
+#define percpu_stable_op(op, var)			\
+({							\
+	typeof(var) pfo_ret__;				\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_arg(P1)",%0"	\
+		    : "=q" (pfo_ret__)			\
+		    : "p" (&(var)));			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_arg(P1)",%0"	\
+		    : "=r" (pfo_ret__)			\
+		    : "p" (&(var)));			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_arg(P1)",%0"	\
+		    : "=r" (pfo_ret__)			\
+		    : "p" (&(var)));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(P1)",%0"	\
+		    : "=r" (pfo_ret__)			\
+		    : "p" (&(var)));			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
@@ -359,11 +388,11 @@ do {									\
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
-#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
+#define this_cpu_read_stable(var)	percpu_stable_op("mov", var)
 
-#define raw_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define raw_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define raw_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_1(pcp)		percpu_from_op("mov", pcp)
+#define raw_cpu_read_2(pcp)		percpu_from_op("mov", pcp)
+#define raw_cpu_read_4(pcp)		percpu_from_op("mov", pcp)
 
 #define raw_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define raw_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -381,9 +410,9 @@ do {									\
 #define raw_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
 #define raw_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
 
-#define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define this_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_read_1(pcp)		percpu_from_op("mov", pcp)
+#define this_cpu_read_2(pcp)		percpu_from_op("mov", pcp)
+#define this_cpu_read_4(pcp)		percpu_from_op("mov", pcp)
 #define this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -435,7 +464,7 @@ do {									\
  * 32 bit must fall back to generic operations.
  */
 #ifdef CONFIG_X86_64
-#define raw_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_8(pcp)			percpu_from_op("mov", pcp)
 #define raw_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
 #define raw_cpu_add_8(pcp, val)			percpu_add_op((pcp), val)
 #define raw_cpu_and_8(pcp, val)			percpu_to_op("and", (pcp), val)
@@ -444,7 +473,7 @@ do {									\
 #define raw_cpu_xchg_8(pcp, nval)		percpu_xchg_op(pcp, nval)
 #define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
-#define this_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_read_8(pcp)			percpu_from_op("mov", pcp)
 #define this_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
 #define this_cpu_add_8(pcp, val)		percpu_add_op((pcp), val)
 #define this_cpu_and_8(pcp, val)		percpu_to_op("and", (pcp), val)
@@ -522,7 +551,7 @@ static inline int x86_this_cpu_variable_test_bit(int nr,
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec794732..3aeb31cc0511 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -127,7 +127,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 	u32			microcode;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+};
 
 #define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
@@ -151,7 +151,7 @@ extern __u32			cpu_caps_cleared[NCAPINTS];
 extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
-DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
 #else
 #define cpu_info		boot_cpu_data
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5cdff0357746..e4fcb87ba7a6 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -30,7 +30,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 #define BOOT_PERCPU_OFFSET 0
 #endif
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4d2128ac70bd..a03ec604ceed 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -99,7 +99,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 
 /* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 49edf2dd3613..00bf300fd846 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -186,6 +186,8 @@ SECTIONS
 	 * start another segment - init.
 	 */
 	PERCPU_VADDR(INTERNODE_CACHE_BYTES, 0, :percpu)
+	ASSERT(SIZEOF(.data..percpu) < CONFIG_PHYSICAL_START,
+	       "per-CPU data too large - increase CONFIG_PHYSICAL_START")
 #endif
 
 	INIT_TEXT_SECTION(PAGE_SIZE)
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index a5efb21d5228..0c2fae8d929d 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -20,7 +20,10 @@ struct relocs {
 
 static struct relocs relocs16;
 static struct relocs relocs32;
+#if ELF_BITS == 64
+static struct relocs relocs32neg;
 static struct relocs relocs64;
+#endif
 
 struct section {
 	Elf_Shdr       shdr;
@@ -762,11 +765,16 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 
 	switch (r_type) {
 	case R_X86_64_NONE:
+		/* NONE can be ignored. */
+		break;
+
 	case R_X86_64_PC32:
 		/*
-		 * NONE can be ignored and PC relative relocations don't
-		 * need to be adjusted.
+		 * PC relative relocations don't need to be adjusted unless
+		 * referencing a percpu symbol.
 		 */
+		if (is_percpu_sym(sym, symname))
+			add_reloc(&relocs32neg, offset);
 		break;
 
 	case R_X86_64_32:
@@ -986,7 +994,10 @@ static void emit_relocs(int as_text, int use_real_mode)
 	/* Order the relocations for more efficient processing */
 	sort_relocs(&relocs16);
 	sort_relocs(&relocs32);
+#if ELF_BITS == 64
+	sort_relocs(&relocs32neg);
 	sort_relocs(&relocs64);
+#endif
 
 	/* Print the relocations */
 	if (as_text) {
@@ -1007,14 +1018,21 @@ static void emit_relocs(int as_text, int use_real_mode)
 		for (i = 0; i < relocs32.count; i++)
 			write_reloc(relocs32.offset[i], stdout);
 	} else {
-		if (ELF_BITS == 64) {
-			/* Print a stop */
-			write_reloc(0, stdout);
+#if ELF_BITS == 64
+		/* Print a stop */
+		write_reloc(0, stdout);
 
-			/* Now print each relocation */
-			for (i = 0; i < relocs64.count; i++)
-				write_reloc(relocs64.offset[i], stdout);
-		}
+		/* Now print each relocation */
+		for (i = 0; i < relocs64.count; i++)
+			write_reloc(relocs64.offset[i], stdout);
+
+		/* Print a stop */
+		write_reloc(0, stdout);
+
+		/* Now print each inverse 32-bit relocation */
+		for (i = 0; i < relocs32neg.count; i++)
+			write_reloc(relocs32neg.offset[i], stdout);
+#endif
 
 		/* Print a stop */
 		write_reloc(0, stdout);
