Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbaLIOJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:09:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:48672 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbaLIOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:09:04 -0500
Date: Tue, 9 Dec 2014 15:08:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [GIT pull] x86 mpx support for 3.19
Message-ID: <alpine.DEB.2.11.1412091504490.16275@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-mpx-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mpx-for-linus

This enables support for x86 MPX:

  MPX is a new debug feature for bound checking in user space. It
  requires kernel support to handle the bound tables and decode the
  bound violating instruction in the trap handler.

Thanks,

	tglx

------------------>
Dave Hansen (12):
      x86: Remove arbitrary instruction size limit in instruction decoder
      x86: mpx: Give bndX registers actual names
      x86, mpx: Rename cfg_reg_u and status_reg
      x86, mpx: Add MPX to disabled features
      x86, mpx: Decode MPX instruction to get bound violation information
      x86, mpx: On-demand kernel allocation of bounds tables
      x86, mpx: Cleanup unused bound tables
      fs: Do not include mpx.h in exec.c
      x86 mpx: Change return type of get_reg_offset()
      x86: Cleanly separate use of asm-generic/mm_hooks.h
      mm: Make arch_unmap()/bprm_mm_init() available to all architectures
      asm-generic: Remove asm-generic arch_bprm_mm_init()

Qiaowei Ren (6):
      mpx: Extend siginfo structure to include bound violation information
      mips: Sync struct siginfo with general version
      ia64: Sync struct siginfo with general version
      x86, mpx: Introduce VM_MPX to indicate that a VMA is MPX specific
      x86, mpx: Add MPX-specific mmap interface
      x86, mpx: Add documentation on Intel MPX


 Documentation/x86/intel_mpx.txt            | 234 ++++++++
 arch/ia64/include/uapi/asm/siginfo.h       |   8 +-
 arch/mips/include/uapi/asm/siginfo.h       |   4 +
 arch/s390/include/asm/mmu_context.h        |  11 +
 arch/um/include/asm/mmu_context.h          |  24 +-
 arch/unicore32/include/asm/mmu_context.h   |  11 +
 arch/x86/Kconfig                           |   4 +
 arch/x86/include/asm/disabled-features.h   |   8 +-
 arch/x86/include/asm/insn.h                |  10 +-
 arch/x86/include/asm/mmu_context.h         |  26 +-
 arch/x86/include/asm/mpx.h                 | 103 ++++
 arch/x86/include/asm/paravirt.h            |  16 +-
 arch/x86/include/asm/processor.h           |  33 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |  17 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  25 +-
 arch/x86/kernel/kprobes/core.c             |   8 +-
 arch/x86/kernel/kprobes/opt.c              |   4 +-
 arch/x86/kernel/setup.c                    |   2 +
 arch/x86/kernel/traps.c                    |  85 ++-
 arch/x86/kernel/uprobes.c                  |   2 +-
 arch/x86/lib/insn.c                        |   5 +-
 arch/x86/mm/Makefile                       |   2 +
 arch/x86/mm/mpx.c                          | 928 +++++++++++++++++++++++++++++
 arch/x86/tools/insn_sanity.c               |   2 +-
 arch/x86/tools/test_get_len.c              |   2 +-
 fs/exec.c                                  |   1 +
 fs/proc/task_mmu.c                         |   3 +
 include/asm-generic/mm_hooks.h             |  17 +-
 include/linux/mm.h                         |   6 +
 include/linux/mm_types.h                   |   4 +
 include/uapi/asm-generic/siginfo.h         |   9 +-
 include/uapi/linux/prctl.h                 |   6 +
 kernel/signal.c                            |   4 +
 kernel/sys.c                               |  12 +
 mm/mmap.c                                  |   2 +
 35 files changed, 1591 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/x86/intel_mpx.txt
 create mode 100644 arch/x86/include/asm/mpx.h
 create mode 100644 arch/x86/mm/mpx.c

diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
new file mode 100644
index 000000000000..4472ed2ad921
--- /dev/null
+++ b/Documentation/x86/intel_mpx.txt
@@ -0,0 +1,234 @@
+1. Intel(R) MPX Overview
+========================
+
+Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new capability
+introduced into Intel Architecture. Intel MPX provides hardware features
+that can be used in conjunction with compiler changes to check memory
+references, for those references whose compile-time normal intentions are
+usurped at runtime due to buffer overflow or underflow.
+
+For more information, please refer to Intel(R) Architecture Instruction
+Set Extensions Programming Reference, Chapter 9: Intel(R) Memory Protection
+Extensions.
+
+Note: Currently no hardware with MPX ISA is available but it is always
+possible to use SDE (Intel(R) Software Development Emulator) instead, which
+can be downloaded from
+http://software.intel.com/en-us/articles/intel-software-development-emulator
+
+
+2. How to get the advantage of MPX
+==================================
+
+For MPX to work, changes are required in the kernel, binutils and compiler.
+No source changes are required for applications, just a recompile.
+
+There are a lot of moving parts of this to all work right. The following
+is how we expect the compiler, application and kernel to work together.
+
+1) Application developer compiles with -fmpx. The compiler will add the
+   instrumentation as well as some setup code called early after the app
+   starts. New instruction prefixes are noops for old CPUs.
+2) That setup code allocates (virtual) space for the "bounds directory",
+   points the "bndcfgu" register to the directory and notifies the kernel
+   (via the new prctl(PR_MPX_ENABLE_MANAGEMENT)) that the app will be using
+   MPX.
+3) The kernel detects that the CPU has MPX, allows the new prctl() to
+   succeed, and notes the location of the bounds directory. Userspace is
+   expected to keep the bounds directory at that locationWe note it
+   instead of reading it each time because the 'xsave' operation needed
+   to access the bounds directory register is an expensive operation.
+4) If the application needs to spill bounds out of the 4 registers, it
+   issues a bndstx instruction. Since the bounds directory is empty at
+   this point, a bounds fault (#BR) is raised, the kernel allocates a
+   bounds table (in the user address space) and makes the relevant entry
+   in the bounds directory point to the new table.
+5) If the application violates the bounds specified in the bounds registers,
+   a separate kind of #BR is raised which will deliver a signal with
+   information about the violation in the 'struct siginfo'.
+6) Whenever memory is freed, we know that it can no longer contain valid
+   pointers, and we attempt to free the associated space in the bounds
+   tables. If an entire table becomes unused, we will attempt to free
+   the table and remove the entry in the directory.
+
+To summarize, there are essentially three things interacting here:
+
+GCC with -fmpx:
+ * enables annotation of code with MPX instructions and prefixes
+ * inserts code early in the application to call in to the "gcc runtime"
+GCC MPX Runtime:
+ * Checks for hardware MPX support in cpuid leaf
+ * allocates virtual space for the bounds directory (malloc() essentially)
+ * points the hardware BNDCFGU register at the directory
+ * calls a new prctl(PR_MPX_ENABLE_MANAGEMENT) to notify the kernel to
+   start managing the bounds directories
+Kernel MPX Code:
+ * Checks for hardware MPX support in cpuid leaf
+ * Handles #BR exceptions and sends SIGSEGV to the app when it violates
+   bounds, like during a buffer overflow.
+ * When bounds are spilled in to an unallocated bounds table, the kernel
+   notices in the #BR exception, allocates the virtual space, then
+   updates the bounds directory to point to the new table. It keeps
+   special track of the memory with a VM_MPX flag.
+ * Frees unused bounds tables at the time that the memory they described
+   is unmapped.
+
+
+3. How does MPX kernel code work
+================================
+
+Handling #BR faults caused by MPX
+---------------------------------
+
+When MPX is enabled, there are 2 new situations that can generate
+#BR faults.
+  * new bounds tables (BT) need to be allocated to save bounds.
+  * bounds violation caused by MPX instructions.
+
+We hook #BR handler to handle these two new situations.
+
+On-demand kernel allocation of bounds tables
+--------------------------------------------
+
+MPX only has 4 hardware registers for storing bounds information. If
+MPX-enabled code needs more than these 4 registers, it needs to spill
+them somewhere. It has two special instructions for this which allow
+the bounds to be moved between the bounds registers and some new "bounds
+tables".
+
+#BR exceptions are a new class of exceptions just for MPX. They are
+similar conceptually to a page fault and will be raised by the MPX
+hardware during both bounds violations or when the tables are not
+present. The kernel handles those #BR exceptions for not-present tables
+by carving the space out of the normal processes address space and then
+pointing the bounds-directory over to it.
+
+The tables need to be accessed and controlled by userspace because
+the instructions for moving bounds in and out of them are extremely
+frequent. They potentially happen every time a register points to
+memory. Any direct kernel involvement (like a syscall) to access the
+tables would obviously destroy performance.
+
+Why not do this in userspace? MPX does not strictly require anything in
+the kernel. It can theoretically be done completely from userspace. Here
+are a few ways this could be done. We don't think any of them are practical
+in the real-world, but here they are.
+
+Q: Can virtual space simply be reserved for the bounds tables so that we
+   never have to allocate them?
+A: MPX-enabled application will possibly create a lot of bounds tables in
+   process address space to save bounds information. These tables can take
+   up huge swaths of memory (as much as 80% of the memory on the system)
+   even if we clean them up aggressively. In the worst-case scenario, the
+   tables can be 4x the size of the data structure being tracked. IOW, a
+   1-page structure can require 4 bounds-table pages. An X-GB virtual
+   area needs 4*X GB of virtual space, plus 2GB for the bounds directory.
+   If we were to preallocate them for the 128TB of user virtual address
+   space, we would need to reserve 512TB+2GB, which is larger than the
+   entire virtual address space today. This means they can not be reserved
+   ahead of time. Also, a single process's pre-popualated bounds directory
+   consumes 2GB of virtual *AND* physical memory. IOW, it's completely
+   infeasible to prepopulate bounds directories.
+
+Q: Can we preallocate bounds table space at the same time memory is
+   allocated which might contain pointers that might eventually need
+   bounds tables?
+A: This would work if we could hook the site of each and every memory
+   allocation syscall. This can be done for small, constrained applications.
+   But, it isn't practical at a larger scale since a given app has no
+   way of controlling how all the parts of the app might allocate memory
+   (think libraries). The kernel is really the only place to intercept
+   these calls.
+
+Q: Could a bounds fault be handed to userspace and the tables allocated
+   there in a signal handler intead of in the kernel?
+A: mmap() is not on the list of safe async handler functions and even
+   if mmap() would work it still requires locking or nasty tricks to
+   keep track of the allocation state there.
+
+Having ruled out all of the userspace-only approaches for managing
+bounds tables that we could think of, we create them on demand in
+the kernel.
+
+Decoding MPX instructions
+-------------------------
+
+If a #BR is generated due to a bounds violation caused by MPX.
+We need to decode MPX instructions to get violation address and
+set this address into extended struct siginfo.
+
+The _sigfault feild of struct siginfo is extended as follow:
+
+87		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+88		struct {
+89			void __user *_addr; /* faulting insn/memory ref. */
+90 #ifdef __ARCH_SI_TRAPNO
+91			int _trapno;	/* TRAP # which caused the signal */
+92 #endif
+93			short _addr_lsb; /* LSB of the reported address */
+94			struct {
+95				void __user *_lower;
+96				void __user *_upper;
+97			} _addr_bnd;
+98		} _sigfault;
+
+The '_addr' field refers to violation address, and new '_addr_and'
+field refers to the upper/lower bounds when a #BR is caused.
+
+Glibc will be also updated to support this new siginfo. So user
+can get violation address and bounds when bounds violations occur.
+
+Cleanup unused bounds tables
+----------------------------
+
+When a BNDSTX instruction attempts to save bounds to a bounds directory
+entry marked as invalid, a #BR is generated. This is an indication that
+no bounds table exists for this entry. In this case the fault handler
+will allocate a new bounds table on demand.
+
+Since the kernel allocated those tables on-demand without userspace
+knowledge, it is also responsible for freeing them when the associated
+mappings go away.
+
+Here, the solution for this issue is to hook do_munmap() to check
+whether one process is MPX enabled. If yes, those bounds tables covered
+in the virtual address region which is being unmapped will be freed also.
+
+Adding new prctl commands
+-------------------------
+
+Two new prctl commands are added to enable and disable MPX bounds tables
+management in kernel.
+
+155	#define PR_MPX_ENABLE_MANAGEMENT	43
+156	#define PR_MPX_DISABLE_MANAGEMENT	44
+
+Runtime library in userspace is responsible for allocation of bounds
+directory. So kernel have to use XSAVE instruction to get the base
+of bounds directory from BNDCFG register.
+
+But XSAVE is expected to be very expensive. In order to do performance
+optimization, we have to get the base of bounds directory and save it
+into struct mm_struct to be used in future during PR_MPX_ENABLE_MANAGEMENT
+command execution.
+
+
+4. Special rules
+================
+
+1) If userspace is requesting help from the kernel to do the management
+of bounds tables, it may not create or modify entries in the bounds directory.
+
+Certainly users can allocate bounds tables and forcibly point the bounds
+directory at them through XSAVE instruction, and then set valid bit
+of bounds entry to have this entry valid.  But, the kernel will decline
+to assist in managing these tables.
+
+2) Userspace may not take multiple bounds directory entries and point
+them at the same bounds table.
+
+This is allowed architecturally.  See more information "Intel(R) Architecture
+Instruction Set Extensions Programming Reference" (9.3.4).
+
+However, if users did this, the kernel might be fooled in to unmaping an
+in-use bounds table since it does not recognize sharing.
diff --git a/arch/ia64/include/uapi/asm/siginfo.h b/arch/ia64/include/uapi/asm/siginfo.h
index 4ea6225196bb..bce9bc1a66c4 100644
--- a/arch/ia64/include/uapi/asm/siginfo.h
+++ b/arch/ia64/include/uapi/asm/siginfo.h
@@ -63,6 +63,10 @@ typedef struct siginfo {
 			unsigned int _flags;	/* see below */
 			unsigned long _isr;	/* isr */
 			short _addr_lsb;	/* lsb of faulting address */
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL */
@@ -110,9 +114,9 @@ typedef struct siginfo {
 /*
  * SIGSEGV si_codes
  */
-#define __SEGV_PSTKOVF	(__SI_FAULT|3)	/* paragraph stack overflow */
+#define __SEGV_PSTKOVF	(__SI_FAULT|4)	/* paragraph stack overflow */
 #undef NSIGSEGV
-#define NSIGSEGV	3
+#define NSIGSEGV	4
 
 #undef NSIGTRAP
 #define NSIGTRAP	4
diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
index e81174432bab..d08f83f19db5 100644
--- a/arch/mips/include/uapi/asm/siginfo.h
+++ b/arch/mips/include/uapi/asm/siginfo.h
@@ -92,6 +92,10 @@ typedef struct siginfo {
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
 			short _addr_lsb;
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL, SIGXFSZ (To do ...)	 */
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 3815bfea1b2d..f49b71954654 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -120,4 +120,15 @@ static inline void arch_exit_mmap(struct mm_struct *mm)
 {
 }
 
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif /* __S390_MMU_CONTEXT_H */
diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index aa4a743dc4ab..941527e507f7 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -10,7 +10,26 @@
 #include <asm/mmu.h>
 
 extern void uml_setup_stubs(struct mm_struct *mm);
+/*
+ * Needed since we do not use the asm-generic/mm_hooks.h:
+ */
+static inline void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	uml_setup_stubs(mm);
+}
 extern void arch_exit_mmap(struct mm_struct *mm);
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+/*
+ * end asm-generic/mm_hooks.h functions
+ */
 
 #define deactivate_mm(tsk,mm)	do { } while (0)
 
@@ -41,11 +60,6 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	}
 }
 
-static inline void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
-{
-	uml_setup_stubs(mm);
-}
-
 static inline void enter_lazy_tlb(struct mm_struct *mm, 
 				  struct task_struct *tsk)
 {
diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index ef470a7a3d0f..1cb5220afaf9 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -86,4 +86,15 @@ static inline void arch_dup_mmap(struct mm_struct *oldmm,
 {
 }
 
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a6774ac9..967dfe0ba85e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -248,6 +248,10 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on INTEL_IOMMU && ACPI
 
+config X86_INTEL_MPX
+	def_bool y
+	depends on CPU_SUP_INTEL
+
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 97534a7d38e3..f226df064660 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -10,6 +10,12 @@
  * cpu_feature_enabled().
  */
 
+#ifdef CONFIG_X86_INTEL_MPX
+# define DISABLE_MPX	0
+#else
+# define DISABLE_MPX	(1<<(X86_FEATURE_MPX & 31))
+#endif
+
 #ifdef CONFIG_X86_64
 # define DISABLE_VME		(1<<(X86_FEATURE_VME & 31))
 # define DISABLE_K6_MTRR	(1<<(X86_FEATURE_K6_MTRR & 31))
@@ -34,6 +40,6 @@
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	0
 #define DISABLED_MASK8	0
-#define DISABLED_MASK9	0
+#define DISABLED_MASK9	(DISABLE_MPX)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 48eb30a86062..47f29b1d1846 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -65,6 +65,7 @@ struct insn {
 	unsigned char x86_64;
 
 	const insn_byte_t *kaddr;	/* kernel address of insn to analyze */
+	const insn_byte_t *end_kaddr;	/* kernel address of last insn in buffer */
 	const insn_byte_t *next_byte;
 };
 
@@ -96,7 +97,7 @@ struct insn {
 #define X86_VEX_P(vex)	((vex) & 0x03)		/* VEX3 Byte2, VEX2 Byte1 */
 #define X86_VEX_M_MAX	0x1f			/* VEX3.M Maximum value */
 
-extern void insn_init(struct insn *insn, const void *kaddr, int x86_64);
+extern void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64);
 extern void insn_get_prefixes(struct insn *insn);
 extern void insn_get_opcode(struct insn *insn);
 extern void insn_get_modrm(struct insn *insn);
@@ -115,12 +116,13 @@ static inline void insn_get_attribute(struct insn *insn)
 extern int insn_rip_relative(struct insn *insn);
 
 /* Init insn for kernel text */
-static inline void kernel_insn_init(struct insn *insn, const void *kaddr)
+static inline void kernel_insn_init(struct insn *insn,
+				    const void *kaddr, int buf_len)
 {
 #ifdef CONFIG_X86_64
-	insn_init(insn, kaddr, 1);
+	insn_init(insn, kaddr, buf_len, 1);
 #else /* CONFIG_X86_32 */
-	insn_init(insn, kaddr, 0);
+	insn_init(insn, kaddr, buf_len, 0);
 #endif
 }
 
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 166af2a8e865..be91d5736e08 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -10,9 +10,8 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
+#include <asm/mpx.h>
 #ifndef CONFIG_PARAVIRT
-#include <asm-generic/mm_hooks.h>
-
 static inline void paravirt_activate_mm(struct mm_struct *prev,
 					struct mm_struct *next)
 {
@@ -102,4 +101,27 @@ do {						\
 } while (0)
 #endif
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	paravirt_arch_dup_mmap(oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	paravirt_arch_exit_mmap(mm);
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+		struct vm_area_struct *vma)
+{
+	mpx_mm_init(mm);
+}
+
+static inline void arch_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
+			      unsigned long start, unsigned long end)
+{
+	mpx_notify_unmap(mm, vma, start, end);
+}
+
 #endif /* _ASM_X86_MMU_CONTEXT_H */
diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
new file mode 100644
index 000000000000..a952a13d59a7
--- /dev/null
+++ b/arch/x86/include/asm/mpx.h
@@ -0,0 +1,103 @@
+#ifndef _ASM_X86_MPX_H
+#define _ASM_X86_MPX_H
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+#include <asm/insn.h>
+
+/*
+ * NULL is theoretically a valid place to put the bounds
+ * directory, so point this at an invalid address.
+ */
+#define MPX_INVALID_BOUNDS_DIR	((void __user *)-1)
+#define MPX_BNDCFG_ENABLE_FLAG	0x1
+#define MPX_BD_ENTRY_VALID_FLAG	0x1
+
+#ifdef CONFIG_X86_64
+
+/* upper 28 bits [47:20] of the virtual address in 64-bit used to
+ * index into bounds directory (BD).
+ */
+#define MPX_BD_ENTRY_OFFSET	28
+#define MPX_BD_ENTRY_SHIFT	3
+/* bits [19:3] of the virtual address in 64-bit used to index into
+ * bounds table (BT).
+ */
+#define MPX_BT_ENTRY_OFFSET	17
+#define MPX_BT_ENTRY_SHIFT	5
+#define MPX_IGN_BITS		3
+#define MPX_BD_ENTRY_TAIL	3
+
+#else
+
+#define MPX_BD_ENTRY_OFFSET	20
+#define MPX_BD_ENTRY_SHIFT	2
+#define MPX_BT_ENTRY_OFFSET	10
+#define MPX_BT_ENTRY_SHIFT	4
+#define MPX_IGN_BITS		2
+#define MPX_BD_ENTRY_TAIL	2
+
+#endif
+
+#define MPX_BD_SIZE_BYTES (1UL<<(MPX_BD_ENTRY_OFFSET+MPX_BD_ENTRY_SHIFT))
+#define MPX_BT_SIZE_BYTES (1UL<<(MPX_BT_ENTRY_OFFSET+MPX_BT_ENTRY_SHIFT))
+
+#define MPX_BNDSTA_TAIL		2
+#define MPX_BNDCFG_TAIL		12
+#define MPX_BNDSTA_ADDR_MASK	(~((1UL<<MPX_BNDSTA_TAIL)-1))
+#define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
+#define MPX_BT_ADDR_MASK	(~((1UL<<MPX_BD_ENTRY_TAIL)-1))
+
+#define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
+#define MPX_BNDSTA_ERROR_CODE	0x3
+
+#define MPX_BD_ENTRY_MASK	((1<<MPX_BD_ENTRY_OFFSET)-1)
+#define MPX_BT_ENTRY_MASK	((1<<MPX_BT_ENTRY_OFFSET)-1)
+#define MPX_GET_BD_ENTRY_OFFSET(addr)	((((addr)>>(MPX_BT_ENTRY_OFFSET+ \
+		MPX_IGN_BITS)) & MPX_BD_ENTRY_MASK) << MPX_BD_ENTRY_SHIFT)
+#define MPX_GET_BT_ENTRY_OFFSET(addr)	((((addr)>>MPX_IGN_BITS) & \
+		MPX_BT_ENTRY_MASK) << MPX_BT_ENTRY_SHIFT)
+
+#ifdef CONFIG_X86_INTEL_MPX
+siginfo_t *mpx_generate_siginfo(struct pt_regs *regs,
+				struct xsave_struct *xsave_buf);
+int mpx_handle_bd_fault(struct xsave_struct *xsave_buf);
+static inline int kernel_managing_mpx_tables(struct mm_struct *mm)
+{
+	return (mm->bd_addr != MPX_INVALID_BOUNDS_DIR);
+}
+static inline void mpx_mm_init(struct mm_struct *mm)
+{
+	/*
+	 * NULL is theoretically a valid place to put the bounds
+	 * directory, so point this at an invalid address.
+	 */
+	mm->bd_addr = MPX_INVALID_BOUNDS_DIR;
+}
+void mpx_notify_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
+		      unsigned long start, unsigned long end);
+#else
+static inline siginfo_t *mpx_generate_siginfo(struct pt_regs *regs,
+					      struct xsave_struct *xsave_buf)
+{
+	return NULL;
+}
+static inline int mpx_handle_bd_fault(struct xsave_struct *xsave_buf)
+{
+	return -EINVAL;
+}
+static inline int kernel_managing_mpx_tables(struct mm_struct *mm)
+{
+	return 0;
+}
+static inline void mpx_mm_init(struct mm_struct *mm)
+{
+}
+static inline void mpx_notify_unmap(struct mm_struct *mm,
+				    struct vm_area_struct *vma,
+				    unsigned long start, unsigned long end)
+{
+}
+#endif /* CONFIG_X86_INTEL_MPX */
+
+#endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e1610e29e..32444ae939ca 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -330,13 +330,13 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
 	PVOP_VCALL2(pv_mmu_ops.activate_mm, prev, next);
 }
 
-static inline void arch_dup_mmap(struct mm_struct *oldmm,
-				 struct mm_struct *mm)
+static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
+					  struct mm_struct *mm)
 {
 	PVOP_VCALL2(pv_mmu_ops.dup_mmap, oldmm, mm);
 }
 
-static inline void arch_exit_mmap(struct mm_struct *mm)
+static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 {
 	PVOP_VCALL1(pv_mmu_ops.exit_mmap, mm);
 }
@@ -986,5 +986,15 @@ extern void default_banner(void);
 #endif /* __ASSEMBLY__ */
 #else  /* CONFIG_PARAVIRT */
 # define default_banner x86_init_noop
+#ifndef __ASSEMBLY__
+static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
+					  struct mm_struct *mm)
+{
+}
+
+static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
+{
+}
+#endif /* __ASSEMBLY__ */
 #endif /* !CONFIG_PARAVIRT */
 #endif /* _ASM_X86_PARAVIRT_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec794732..9617a1716813 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -374,13 +374,14 @@ struct lwp_struct {
 	u8 reserved[128];
 };
 
-struct bndregs_struct {
-	u64 bndregs[8];
+struct bndreg {
+	u64 lower_bound;
+	u64 upper_bound;
 } __packed;
 
-struct bndcsr_struct {
-	u64 cfg_reg_u;
-	u64 status_reg;
+struct bndcsr {
+	u64 bndcfgu;
+	u64 bndstatus;
 } __packed;
 
 struct xsave_hdr_struct {
@@ -394,8 +395,8 @@ struct xsave_struct {
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
 	struct lwp_struct lwp;
-	struct bndregs_struct bndregs;
-	struct bndcsr_struct bndcsr;
+	struct bndreg bndreg[4];
+	struct bndcsr bndcsr;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
@@ -953,6 +954,24 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+/* Register/unregister a process' MPX related resource */
+#define MPX_ENABLE_MANAGEMENT(tsk)	mpx_enable_management((tsk))
+#define MPX_DISABLE_MANAGEMENT(tsk)	mpx_disable_management((tsk))
+
+#ifdef CONFIG_X86_INTEL_MPX
+extern int mpx_enable_management(struct task_struct *tsk);
+extern int mpx_disable_management(struct task_struct *tsk);
+#else
+static inline int mpx_enable_management(struct task_struct *tsk)
+{
+	return -EINVAL;
+}
+static inline int mpx_disable_management(struct task_struct *tsk)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_X86_INTEL_MPX */
+
 extern u16 amd_get_nb_id(int cpu);
 
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 46211bcc813e..6a94277525c9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -724,6 +724,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
 	void *kaddr;
+	int size;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -758,11 +759,12 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		return 1;
 	}
 
+	size = ip - to;
 	if (!kernel_ip(ip)) {
-		int size, bytes;
+		int bytes;
 		u8 *buf = this_cpu_read(insn_buffer);
 
-		size = ip - to; /* Must fit our buffer, see above */
+		/* 'size' must fit our buffer, see above */
 		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
 		if (bytes != 0)
 			return 0;
@@ -780,11 +782,20 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 #ifdef CONFIG_X86_64
 		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
 #endif
-		insn_init(&insn, kaddr, is_64bit);
+		insn_init(&insn, kaddr, size, is_64bit);
 		insn_get_length(&insn);
+		/*
+		 * Make sure there was not a problem decoding the
+		 * instruction and getting the length.  This is
+		 * doubly important because we have an infinite
+		 * loop if insn.length=0.
+		 */
+		if (!insn.length)
+			break;
 
 		to += insn.length;
 		kaddr += insn.length;
+		size -= insn.length;
 	} while (to < ip);
 
 	if (to == ip) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 45fa730a5283..58f1a94beaf0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -465,7 +465,7 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 {
 	struct insn insn;
 	void *addr;
-	int bytes, size = MAX_INSN_SIZE;
+	int bytes_read, bytes_left;
 	int ret = X86_BR_NONE;
 	int ext, to_plm, from_plm;
 	u8 buf[MAX_INSN_SIZE];
@@ -493,8 +493,10 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 			return X86_BR_NONE;
 
 		/* may fail if text not present */
-		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
-		if (bytes != 0)
+		bytes_left = copy_from_user_nmi(buf, (void __user *)from,
+						MAX_INSN_SIZE);
+		bytes_read = MAX_INSN_SIZE - bytes_left;
+		if (!bytes_read)
 			return X86_BR_NONE;
 
 		addr = buf;
@@ -505,10 +507,19 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 		 * Ensure we don't blindy read any address by validating it is
 		 * a known text address.
 		 */
-		if (kernel_text_address(from))
+		if (kernel_text_address(from)) {
 			addr = (void *)from;
-		else
+			/*
+			 * Assume we can get the maximum possible size
+			 * when grabbing kernel data.  This is not
+			 * _strictly_ true since we could possibly be
+			 * executing up next to a memory hole, but
+			 * it is very unlikely to be a problem.
+			 */
+			bytes_read = MAX_INSN_SIZE;
+		} else {
 			return X86_BR_NONE;
+		}
 	}
 
 	/*
@@ -518,8 +529,10 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 #ifdef CONFIG_X86_64
 	is64 = kernel_ip((unsigned long)addr) || !test_thread_flag(TIF_IA32);
 #endif
-	insn_init(&insn, addr, is64);
+	insn_init(&insn, addr, bytes_read, is64);
 	insn_get_opcode(&insn);
+	if (!insn.opcode.got)
+		return X86_BR_ABORT;
 
 	switch (insn.opcode.bytes[0]) {
 	case 0xf:
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 67e6d19ef1be..f7e3cd50ece0 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -285,7 +285,7 @@ static int can_probe(unsigned long paddr)
 		 * normally used, we just go through if there is no kprobe.
 		 */
 		__addr = recover_probed_instruction(buf, addr);
-		kernel_insn_init(&insn, (void *)__addr);
+		kernel_insn_init(&insn, (void *)__addr, MAX_INSN_SIZE);
 		insn_get_length(&insn);
 
 		/*
@@ -330,8 +330,10 @@ int __copy_instruction(u8 *dest, u8 *src)
 {
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	unsigned long recovered_insn =
+		recover_probed_instruction(buf, (unsigned long)src);
 
-	kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, (unsigned long)src));
+	kernel_insn_init(&insn, (void *)recovered_insn, MAX_INSN_SIZE);
 	insn_get_length(&insn);
 	/* Another subsystem puts a breakpoint, failed to recover */
 	if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
@@ -342,7 +344,7 @@ int __copy_instruction(u8 *dest, u8 *src)
 	if (insn_rip_relative(&insn)) {
 		s64 newdisp;
 		u8 *disp;
-		kernel_insn_init(&insn, dest);
+		kernel_insn_init(&insn, dest, insn.length);
 		insn_get_displacement(&insn);
 		/*
 		 * The copied instruction uses the %rip-relative addressing
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f1314d0bcf0a..7c523bbf3dc8 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -251,13 +251,15 @@ static int can_optimize(unsigned long paddr)
 	/* Decode instructions */
 	addr = paddr - offset;
 	while (addr < paddr - offset + size) { /* Decode until function end */
+		unsigned long recovered_insn;
 		if (search_exception_tables(addr))
 			/*
 			 * Since some fixup code will jumps into this function,
 			 * we can't optimize kprobe in this function.
 			 */
 			return 0;
-		kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, addr));
+		recovered_insn = recover_probed_instruction(buf, addr);
+		kernel_insn_init(&insn, (void *)recovered_insn, MAX_INSN_SIZE);
 		insn_get_length(&insn);
 		/* Another subsystem puts a breakpoint */
 		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ab08aa2276fb..214245d6b996 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -960,6 +960,8 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_data = (unsigned long) _edata;
 	init_mm.brk = _brk_end;
 
+	mpx_mm_init(&init_mm);
+
 	code_resource.start = __pa_symbol(_text);
 	code_resource.end = __pa_symbol(_etext)-1;
 	data_resource.start = __pa_symbol(_etext);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0d0e922fafc1..651d5d4f7558 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -60,6 +60,7 @@
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
 #include <asm/alternative.h>
+#include <asm/mpx.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -228,7 +229,6 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 
 DO_ERROR(X86_TRAP_DE,     SIGFPE,  "divide error",		divide_error)
 DO_ERROR(X86_TRAP_OF,     SIGSEGV, "overflow",			overflow)
-DO_ERROR(X86_TRAP_BR,     SIGSEGV, "bounds",			bounds)
 DO_ERROR(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op)
 DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",coprocessor_segment_overrun)
 DO_ERROR(X86_TRAP_TS,     SIGSEGV, "invalid TSS",		invalid_TSS)
@@ -278,6 +278,89 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
+dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
+{
+	struct task_struct *tsk = current;
+	struct xsave_struct *xsave_buf;
+	enum ctx_state prev_state;
+	struct bndcsr *bndcsr;
+	siginfo_t *info;
+
+	prev_state = exception_enter();
+	if (notify_die(DIE_TRAP, "bounds", regs, error_code,
+			X86_TRAP_BR, SIGSEGV) == NOTIFY_STOP)
+		goto exit;
+	conditional_sti(regs);
+
+	if (!user_mode(regs))
+		die("bounds", regs, error_code);
+
+	if (!cpu_feature_enabled(X86_FEATURE_MPX)) {
+		/* The exception is not from Intel MPX */
+		goto exit_trap;
+	}
+
+	/*
+	 * We need to look at BNDSTATUS to resolve this exception.
+	 * It is not directly accessible, though, so we need to
+	 * do an xsave and then pull it out of the xsave buffer.
+	 */
+	fpu_save_init(&tsk->thread.fpu);
+	xsave_buf = &(tsk->thread.fpu.state->xsave);
+	bndcsr = get_xsave_addr(xsave_buf, XSTATE_BNDCSR);
+	if (!bndcsr)
+		goto exit_trap;
+
+	/*
+	 * The error code field of the BNDSTATUS register communicates status
+	 * information of a bound range exception #BR or operation involving
+	 * bound directory.
+	 */
+	switch (bndcsr->bndstatus & MPX_BNDSTA_ERROR_CODE) {
+	case 2:	/* Bound directory has invalid entry. */
+		if (mpx_handle_bd_fault(xsave_buf))
+			goto exit_trap;
+		break; /* Success, it was handled */
+	case 1: /* Bound violation. */
+		info = mpx_generate_siginfo(regs, xsave_buf);
+		if (PTR_ERR(info)) {
+			/*
+			 * We failed to decode the MPX instruction.  Act as if
+			 * the exception was not caused by MPX.
+			 */
+			goto exit_trap;
+		}
+		/*
+		 * Success, we decoded the instruction and retrieved
+		 * an 'info' containing the address being accessed
+		 * which caused the exception.  This information
+		 * allows and application to possibly handle the
+		 * #BR exception itself.
+		 */
+		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, info);
+		kfree(info);
+		break;
+	case 0: /* No exception caused by Intel MPX operations. */
+		goto exit_trap;
+	default:
+		die("bounds", regs, error_code);
+	}
+
+exit:
+	exception_exit(prev_state);
+	return;
+exit_trap:
+	/*
+	 * This path out is for all the cases where we could not
+	 * handle the exception in some way (like allocating a
+	 * table or telling userspace about it.  We will also end
+	 * up here if the kernel has MPX turned off at compile
+	 * time..
+	 */
+	do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
+	exception_exit(prev_state);
+}
+
 dotraplinkage void
 do_general_protection(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 5d1cbfe4ae58..8b96a947021f 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -219,7 +219,7 @@ static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool
 {
 	u32 volatile *good_insns;
 
-	insn_init(insn, auprobe->insn, x86_64);
+	insn_init(insn, auprobe->insn, sizeof(auprobe->insn), x86_64);
 	/* has the side-effect of processing the entire instruction */
 	insn_get_length(insn);
 	if (WARN_ON_ONCE(!insn_complete(insn)))
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 54fcffed28ed..2480978b31cc 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -28,7 +28,7 @@
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n - (insn)->kaddr <= MAX_INSN_SIZE)
+	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
 	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
@@ -50,10 +50,11 @@
  * @kaddr:	address (in kernel memory) of instruction (or copy thereof)
  * @x86_64:	!0 for 64-bit kernel or 64-bit app
  */
-void insn_init(struct insn *insn, const void *kaddr, int x86_64)
+void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
 {
 	memset(insn, 0, sizeof(*insn));
 	insn->kaddr = kaddr;
+	insn->end_kaddr = kaddr + buf_len;
 	insn->next_byte = kaddr;
 	insn->x86_64 = x86_64 ? 1 : 0;
 	insn->opnd_bytes = 4;
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 6a19ad9f370d..ecfdc46a024a 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -30,3 +30,5 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
+
+obj-$(CONFIG_X86_INTEL_MPX)	+= mpx.o
diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
new file mode 100644
index 000000000000..67ebf5751222
--- /dev/null
+++ b/arch/x86/mm/mpx.c
@@ -0,0 +1,928 @@
+/*
+ * mpx.c - Memory Protection eXtensions
+ *
+ * Copyright (c) 2014, Intel Corporation.
+ * Qiaowei Ren <qiaowei.ren@intel.com>
+ * Dave Hansen <dave.hansen@intel.com>
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/sched/sysctl.h>
+
+#include <asm/i387.h>
+#include <asm/insn.h>
+#include <asm/mman.h>
+#include <asm/mmu_context.h>
+#include <asm/mpx.h>
+#include <asm/processor.h>
+#include <asm/fpu-internal.h>
+
+static const char *mpx_mapping_name(struct vm_area_struct *vma)
+{
+	return "[mpx]";
+}
+
+static struct vm_operations_struct mpx_vma_ops = {
+	.name = mpx_mapping_name,
+};
+
+static int is_mpx_vma(struct vm_area_struct *vma)
+{
+	return (vma->vm_ops == &mpx_vma_ops);
+}
+
+/*
+ * This is really a simplified "vm_mmap". it only handles MPX
+ * bounds tables (the bounds directory is user-allocated).
+ *
+ * Later on, we use the vma->vm_ops to uniquely identify these
+ * VMAs.
+ */
+static unsigned long mpx_mmap(unsigned long len)
+{
+	unsigned long ret;
+	unsigned long addr, pgoff;
+	struct mm_struct *mm = current->mm;
+	vm_flags_t vm_flags;
+	struct vm_area_struct *vma;
+
+	/* Only bounds table and bounds directory can be allocated here */
+	if (len != MPX_BD_SIZE_BYTES && len != MPX_BT_SIZE_BYTES)
+		return -EINVAL;
+
+	down_write(&mm->mmap_sem);
+
+	/* Too many mappings? */
+	if (mm->map_count > sysctl_max_map_count) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Obtain the address to map to. we verify (or select) it and ensure
+	 * that it represents a valid section of the address space.
+	 */
+	addr = get_unmapped_area(NULL, 0, len, 0, MAP_ANONYMOUS | MAP_PRIVATE);
+	if (addr & ~PAGE_MASK) {
+		ret = addr;
+		goto out;
+	}
+
+	vm_flags = VM_READ | VM_WRITE | VM_MPX |
+			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
+
+	/* Set pgoff according to addr for anon_vma */
+	pgoff = addr >> PAGE_SHIFT;
+
+	ret = mmap_region(NULL, addr, len, vm_flags, pgoff);
+	if (IS_ERR_VALUE(ret))
+		goto out;
+
+	vma = find_vma(mm, ret);
+	if (!vma) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	vma->vm_ops = &mpx_vma_ops;
+
+	if (vm_flags & VM_LOCKED) {
+		up_write(&mm->mmap_sem);
+		mm_populate(ret, len);
+		return ret;
+	}
+
+out:
+	up_write(&mm->mmap_sem);
+	return ret;
+}
+
+enum reg_type {
+	REG_TYPE_RM = 0,
+	REG_TYPE_INDEX,
+	REG_TYPE_BASE,
+};
+
+static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
+			  enum reg_type type)
+{
+	int regno = 0;
+
+	static const int regoff[] = {
+		offsetof(struct pt_regs, ax),
+		offsetof(struct pt_regs, cx),
+		offsetof(struct pt_regs, dx),
+		offsetof(struct pt_regs, bx),
+		offsetof(struct pt_regs, sp),
+		offsetof(struct pt_regs, bp),
+		offsetof(struct pt_regs, si),
+		offsetof(struct pt_regs, di),
+#ifdef CONFIG_X86_64
+		offsetof(struct pt_regs, r8),
+		offsetof(struct pt_regs, r9),
+		offsetof(struct pt_regs, r10),
+		offsetof(struct pt_regs, r11),
+		offsetof(struct pt_regs, r12),
+		offsetof(struct pt_regs, r13),
+		offsetof(struct pt_regs, r14),
+		offsetof(struct pt_regs, r15),
+#endif
+	};
+	int nr_registers = ARRAY_SIZE(regoff);
+	/*
+	 * Don't possibly decode a 32-bit instructions as
+	 * reading a 64-bit-only register.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && !insn->x86_64)
+		nr_registers -= 8;
+
+	switch (type) {
+	case REG_TYPE_RM:
+		regno = X86_MODRM_RM(insn->modrm.value);
+		if (X86_REX_B(insn->rex_prefix.value) == 1)
+			regno += 8;
+		break;
+
+	case REG_TYPE_INDEX:
+		regno = X86_SIB_INDEX(insn->sib.value);
+		if (X86_REX_X(insn->rex_prefix.value) == 1)
+			regno += 8;
+		break;
+
+	case REG_TYPE_BASE:
+		regno = X86_SIB_BASE(insn->sib.value);
+		if (X86_REX_B(insn->rex_prefix.value) == 1)
+			regno += 8;
+		break;
+
+	default:
+		pr_err("invalid register type");
+		BUG();
+		break;
+	}
+
+	if (regno > nr_registers) {
+		WARN_ONCE(1, "decoded an instruction with an invalid register");
+		return -EINVAL;
+	}
+	return regoff[regno];
+}
+
+/*
+ * return the address being referenced be instruction
+ * for rm=3 returning the content of the rm reg
+ * for rm!=3 calculates the address using SIB and Disp
+ */
+static void __user *mpx_get_addr_ref(struct insn *insn, struct pt_regs *regs)
+{
+	unsigned long addr, base, indx;
+	int addr_offset, base_offset, indx_offset;
+	insn_byte_t sib;
+
+	insn_get_modrm(insn);
+	insn_get_sib(insn);
+	sib = insn->sib.value;
+
+	if (X86_MODRM_MOD(insn->modrm.value) == 3) {
+		addr_offset = get_reg_offset(insn, regs, REG_TYPE_RM);
+		if (addr_offset < 0)
+			goto out_err;
+		addr = regs_get_register(regs, addr_offset);
+	} else {
+		if (insn->sib.nbytes) {
+			base_offset = get_reg_offset(insn, regs, REG_TYPE_BASE);
+			if (base_offset < 0)
+				goto out_err;
+
+			indx_offset = get_reg_offset(insn, regs, REG_TYPE_INDEX);
+			if (indx_offset < 0)
+				goto out_err;
+
+			base = regs_get_register(regs, base_offset);
+			indx = regs_get_register(regs, indx_offset);
+			addr = base + indx * (1 << X86_SIB_SCALE(sib));
+		} else {
+			addr_offset = get_reg_offset(insn, regs, REG_TYPE_RM);
+			if (addr_offset < 0)
+				goto out_err;
+			addr = regs_get_register(regs, addr_offset);
+		}
+		addr += insn->displacement.value;
+	}
+	return (void __user *)addr;
+out_err:
+	return (void __user *)-1;
+}
+
+static int mpx_insn_decode(struct insn *insn,
+			   struct pt_regs *regs)
+{
+	unsigned char buf[MAX_INSN_SIZE];
+	int x86_64 = !test_thread_flag(TIF_IA32);
+	int not_copied;
+	int nr_copied;
+
+	not_copied = copy_from_user(buf, (void __user *)regs->ip, sizeof(buf));
+	nr_copied = sizeof(buf) - not_copied;
+	/*
+	 * The decoder _should_ fail nicely if we pass it a short buffer.
+	 * But, let's not depend on that implementation detail.  If we
+	 * did not get anything, just error out now.
+	 */
+	if (!nr_copied)
+		return -EFAULT;
+	insn_init(insn, buf, nr_copied, x86_64);
+	insn_get_length(insn);
+	/*
+	 * copy_from_user() tries to get as many bytes as we could see in
+	 * the largest possible instruction.  If the instruction we are
+	 * after is shorter than that _and_ we attempt to copy from
+	 * something unreadable, we might get a short read.  This is OK
+	 * as long as the read did not stop in the middle of the
+	 * instruction.  Check to see if we got a partial instruction.
+	 */
+	if (nr_copied < insn->length)
+		return -EFAULT;
+
+	insn_get_opcode(insn);
+	/*
+	 * We only _really_ need to decode bndcl/bndcn/bndcu
+	 * Error out on anything else.
+	 */
+	if (insn->opcode.bytes[0] != 0x0f)
+		goto bad_opcode;
+	if ((insn->opcode.bytes[1] != 0x1a) &&
+	    (insn->opcode.bytes[1] != 0x1b))
+		goto bad_opcode;
+
+	return 0;
+bad_opcode:
+	return -EINVAL;
+}
+
+/*
+ * If a bounds overflow occurs then a #BR is generated. This
+ * function decodes MPX instructions to get violation address
+ * and set this address into extended struct siginfo.
+ *
+ * Note that this is not a super precise way of doing this.
+ * Userspace could have, by the time we get here, written
+ * anything it wants in to the instructions.  We can not
+ * trust anything about it.  They might not be valid
+ * instructions or might encode invalid registers, etc...
+ *
+ * The caller is expected to kfree() the returned siginfo_t.
+ */
+siginfo_t *mpx_generate_siginfo(struct pt_regs *regs,
+				struct xsave_struct *xsave_buf)
+{
+	struct bndreg *bndregs, *bndreg;
+	siginfo_t *info = NULL;
+	struct insn insn;
+	uint8_t bndregno;
+	int err;
+
+	err = mpx_insn_decode(&insn, regs);
+	if (err)
+		goto err_out;
+
+	/*
+	 * We know at this point that we are only dealing with
+	 * MPX instructions.
+	 */
+	insn_get_modrm(&insn);
+	bndregno = X86_MODRM_REG(insn.modrm.value);
+	if (bndregno > 3) {
+		err = -EINVAL;
+		goto err_out;
+	}
+	/* get the bndregs _area_ of the xsave structure */
+	bndregs = get_xsave_addr(xsave_buf, XSTATE_BNDREGS);
+	if (!bndregs) {
+		err = -EINVAL;
+		goto err_out;
+	}
+	/* now go select the individual register in the set of 4 */
+	bndreg = &bndregs[bndregno];
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+	/*
+	 * The registers are always 64-bit, but the upper 32
+	 * bits are ignored in 32-bit mode.  Also, note that the
+	 * upper bounds are architecturally represented in 1's
+	 * complement form.
+	 *
+	 * The 'unsigned long' cast is because the compiler
+	 * complains when casting from integers to different-size
+	 * pointers.
+	 */
+	info->si_lower = (void __user *)(unsigned long)bndreg->lower_bound;
+	info->si_upper = (void __user *)(unsigned long)~bndreg->upper_bound;
+	info->si_addr_lsb = 0;
+	info->si_signo = SIGSEGV;
+	info->si_errno = 0;
+	info->si_code = SEGV_BNDERR;
+	info->si_addr = mpx_get_addr_ref(&insn, regs);
+	/*
+	 * We were not able to extract an address from the instruction,
+	 * probably because there was something invalid in it.
+	 */
+	if (info->si_addr == (void *)-1) {
+		err = -EINVAL;
+		goto err_out;
+	}
+	return info;
+err_out:
+	/* info might be NULL, but kfree() handles that */
+	kfree(info);
+	return ERR_PTR(err);
+}
+
+static __user void *task_get_bounds_dir(struct task_struct *tsk)
+{
+	struct bndcsr *bndcsr;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MPX))
+		return MPX_INVALID_BOUNDS_DIR;
+
+	/*
+	 * The bounds directory pointer is stored in a register
+	 * only accessible if we first do an xsave.
+	 */
+	fpu_save_init(&tsk->thread.fpu);
+	bndcsr = get_xsave_addr(&tsk->thread.fpu.state->xsave, XSTATE_BNDCSR);
+	if (!bndcsr)
+		return MPX_INVALID_BOUNDS_DIR;
+
+	/*
+	 * Make sure the register looks valid by checking the
+	 * enable bit.
+	 */
+	if (!(bndcsr->bndcfgu & MPX_BNDCFG_ENABLE_FLAG))
+		return MPX_INVALID_BOUNDS_DIR;
+
+	/*
+	 * Lastly, mask off the low bits used for configuration
+	 * flags, and return the address of the bounds table.
+	 */
+	return (void __user *)(unsigned long)
+		(bndcsr->bndcfgu & MPX_BNDCFG_ADDR_MASK);
+}
+
+int mpx_enable_management(struct task_struct *tsk)
+{
+	void __user *bd_base = MPX_INVALID_BOUNDS_DIR;
+	struct mm_struct *mm = tsk->mm;
+	int ret = 0;
+
+	/*
+	 * runtime in the userspace will be responsible for allocation of
+	 * the bounds directory. Then, it will save the base of the bounds
+	 * directory into XSAVE/XRSTOR Save Area and enable MPX through
+	 * XRSTOR instruction.
+	 *
+	 * fpu_xsave() is expected to be very expensive. Storing the bounds
+	 * directory here means that we do not have to do xsave in the unmap
+	 * path; we can just use mm->bd_addr instead.
+	 */
+	bd_base = task_get_bounds_dir(tsk);
+	down_write(&mm->mmap_sem);
+	mm->bd_addr = bd_base;
+	if (mm->bd_addr == MPX_INVALID_BOUNDS_DIR)
+		ret = -ENXIO;
+
+	up_write(&mm->mmap_sem);
+	return ret;
+}
+
+int mpx_disable_management(struct task_struct *tsk)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MPX))
+		return -ENXIO;
+
+	down_write(&mm->mmap_sem);
+	mm->bd_addr = MPX_INVALID_BOUNDS_DIR;
+	up_write(&mm->mmap_sem);
+	return 0;
+}
+
+/*
+ * With 32-bit mode, MPX_BT_SIZE_BYTES is 4MB, and the size of each
+ * bounds table is 16KB. With 64-bit mode, MPX_BT_SIZE_BYTES is 2GB,
+ * and the size of each bounds table is 4MB.
+ */
+static int allocate_bt(long __user *bd_entry)
+{
+	unsigned long expected_old_val = 0;
+	unsigned long actual_old_val = 0;
+	unsigned long bt_addr;
+	int ret = 0;
+
+	/*
+	 * Carve the virtual space out of userspace for the new
+	 * bounds table:
+	 */
+	bt_addr = mpx_mmap(MPX_BT_SIZE_BYTES);
+	if (IS_ERR((void *)bt_addr))
+		return PTR_ERR((void *)bt_addr);
+	/*
+	 * Set the valid flag (kinda like _PAGE_PRESENT in a pte)
+	 */
+	bt_addr = bt_addr | MPX_BD_ENTRY_VALID_FLAG;
+
+	/*
+	 * Go poke the address of the new bounds table in to the
+	 * bounds directory entry out in userspace memory.  Note:
+	 * we may race with another CPU instantiating the same table.
+	 * In that case the cmpxchg will see an unexpected
+	 * 'actual_old_val'.
+	 *
+	 * This can fault, but that's OK because we do not hold
+	 * mmap_sem at this point, unlike some of the other part
+	 * of the MPX code that have to pagefault_disable().
+	 */
+	ret = user_atomic_cmpxchg_inatomic(&actual_old_val, bd_entry,
+					   expected_old_val, bt_addr);
+	if (ret)
+		goto out_unmap;
+
+	/*
+	 * The user_atomic_cmpxchg_inatomic() will only return nonzero
+	 * for faults, *not* if the cmpxchg itself fails.  Now we must
+	 * verify that the cmpxchg itself completed successfully.
+	 */
+	/*
+	 * We expected an empty 'expected_old_val', but instead found
+	 * an apparently valid entry.  Assume we raced with another
+	 * thread to instantiate this table and desclare succecss.
+	 */
+	if (actual_old_val & MPX_BD_ENTRY_VALID_FLAG) {
+		ret = 0;
+		goto out_unmap;
+	}
+	/*
+	 * We found a non-empty bd_entry but it did not have the
+	 * VALID_FLAG set.  Return an error which will result in
+	 * a SEGV since this probably means that somebody scribbled
+	 * some invalid data in to a bounds table.
+	 */
+	if (expected_old_val != actual_old_val) {
+		ret = -EINVAL;
+		goto out_unmap;
+	}
+	return 0;
+out_unmap:
+	vm_munmap(bt_addr & MPX_BT_ADDR_MASK, MPX_BT_SIZE_BYTES);
+	return ret;
+}
+
+/*
+ * When a BNDSTX instruction attempts to save bounds to a bounds
+ * table, it will first attempt to look up the table in the
+ * first-level bounds directory.  If it does not find a table in
+ * the directory, a #BR is generated and we get here in order to
+ * allocate a new table.
+ *
+ * With 32-bit mode, the size of BD is 4MB, and the size of each
+ * bound table is 16KB. With 64-bit mode, the size of BD is 2GB,
+ * and the size of each bound table is 4MB.
+ */
+static int do_mpx_bt_fault(struct xsave_struct *xsave_buf)
+{
+	unsigned long bd_entry, bd_base;
+	struct bndcsr *bndcsr;
+
+	bndcsr = get_xsave_addr(xsave_buf, XSTATE_BNDCSR);
+	if (!bndcsr)
+		return -EINVAL;
+	/*
+	 * Mask off the preserve and enable bits
+	 */
+	bd_base = bndcsr->bndcfgu & MPX_BNDCFG_ADDR_MASK;
+	/*
+	 * The hardware provides the address of the missing or invalid
+	 * entry via BNDSTATUS, so we don't have to go look it up.
+	 */
+	bd_entry = bndcsr->bndstatus & MPX_BNDSTA_ADDR_MASK;
+	/*
+	 * Make sure the directory entry is within where we think
+	 * the directory is.
+	 */
+	if ((bd_entry < bd_base) ||
+	    (bd_entry >= bd_base + MPX_BD_SIZE_BYTES))
+		return -EINVAL;
+
+	return allocate_bt((long __user *)bd_entry);
+}
+
+int mpx_handle_bd_fault(struct xsave_struct *xsave_buf)
+{
+	/*
+	 * Userspace never asked us to manage the bounds tables,
+	 * so refuse to help.
+	 */
+	if (!kernel_managing_mpx_tables(current->mm))
+		return -EINVAL;
+
+	if (do_mpx_bt_fault(xsave_buf)) {
+		force_sig(SIGSEGV, current);
+		/*
+		 * The force_sig() is essentially "handling" this
+		 * exception, so we do not pass up the error
+		 * from do_mpx_bt_fault().
+		 */
+	}
+	return 0;
+}
+
+/*
+ * A thin wrapper around get_user_pages().  Returns 0 if the
+ * fault was resolved or -errno if not.
+ */
+static int mpx_resolve_fault(long __user *addr, int write)
+{
+	long gup_ret;
+	int nr_pages = 1;
+	int force = 0;
+
+	gup_ret = get_user_pages(current, current->mm, (unsigned long)addr,
+				 nr_pages, write, force, NULL, NULL);
+	/*
+	 * get_user_pages() returns number of pages gotten.
+	 * 0 means we failed to fault in and get anything,
+	 * probably because 'addr' is bad.
+	 */
+	if (!gup_ret)
+		return -EFAULT;
+	/* Other error, return it */
+	if (gup_ret < 0)
+		return gup_ret;
+	/* must have gup'd a page and gup_ret>0, success */
+	return 0;
+}
+
+/*
+ * Get the base of bounds tables pointed by specific bounds
+ * directory entry.
+ */
+static int get_bt_addr(struct mm_struct *mm,
+			long __user *bd_entry, unsigned long *bt_addr)
+{
+	int ret;
+	int valid_bit;
+
+	if (!access_ok(VERIFY_READ, (bd_entry), sizeof(*bd_entry)))
+		return -EFAULT;
+
+	while (1) {
+		int need_write = 0;
+
+		pagefault_disable();
+		ret = get_user(*bt_addr, bd_entry);
+		pagefault_enable();
+		if (!ret)
+			break;
+		if (ret == -EFAULT)
+			ret = mpx_resolve_fault(bd_entry, need_write);
+		/*
+		 * If we could not resolve the fault, consider it
+		 * userspace's fault and error out.
+		 */
+		if (ret)
+			return ret;
+	}
+
+	valid_bit = *bt_addr & MPX_BD_ENTRY_VALID_FLAG;
+	*bt_addr &= MPX_BT_ADDR_MASK;
+
+	/*
+	 * When the kernel is managing bounds tables, a bounds directory
+	 * entry will either have a valid address (plus the valid bit)
+	 * *OR* be completely empty. If we see a !valid entry *and* some
+	 * data in the address field, we know something is wrong. This
+	 * -EINVAL return will cause a SIGSEGV.
+	 */
+	if (!valid_bit && *bt_addr)
+		return -EINVAL;
+	/*
+	 * Do we have an completely zeroed bt entry?  That is OK.  It
+	 * just means there was no bounds table for this memory.  Make
+	 * sure to distinguish this from -EINVAL, which will cause
+	 * a SEGV.
+	 */
+	if (!valid_bit)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
+ * Free the backing physical pages of bounds table 'bt_addr'.
+ * Assume start...end is within that bounds table.
+ */
+static int zap_bt_entries(struct mm_struct *mm,
+		unsigned long bt_addr,
+		unsigned long start, unsigned long end)
+{
+	struct vm_area_struct *vma;
+	unsigned long addr, len;
+
+	/*
+	 * Find the first overlapping vma. If vma->vm_start > start, there
+	 * will be a hole in the bounds table. This -EINVAL return will
+	 * cause a SIGSEGV.
+	 */
+	vma = find_vma(mm, start);
+	if (!vma || vma->vm_start > start)
+		return -EINVAL;
+
+	/*
+	 * A NUMA policy on a VM_MPX VMA could cause this bouds table to
+	 * be split. So we need to look across the entire 'start -> end'
+	 * range of this bounds table, find all of the VM_MPX VMAs, and
+	 * zap only those.
+	 */
+	addr = start;
+	while (vma && vma->vm_start < end) {
+		/*
+		 * We followed a bounds directory entry down
+		 * here.  If we find a non-MPX VMA, that's bad,
+		 * so stop immediately and return an error.  This
+		 * probably results in a SIGSEGV.
+		 */
+		if (!is_mpx_vma(vma))
+			return -EINVAL;
+
+		len = min(vma->vm_end, end) - addr;
+		zap_page_range(vma, addr, len, NULL);
+
+		vma = vma->vm_next;
+		addr = vma->vm_start;
+	}
+
+	return 0;
+}
+
+static int unmap_single_bt(struct mm_struct *mm,
+		long __user *bd_entry, unsigned long bt_addr)
+{
+	unsigned long expected_old_val = bt_addr | MPX_BD_ENTRY_VALID_FLAG;
+	unsigned long actual_old_val = 0;
+	int ret;
+
+	while (1) {
+		int need_write = 1;
+
+		pagefault_disable();
+		ret = user_atomic_cmpxchg_inatomic(&actual_old_val, bd_entry,
+						   expected_old_val, 0);
+		pagefault_enable();
+		if (!ret)
+			break;
+		if (ret == -EFAULT)
+			ret = mpx_resolve_fault(bd_entry, need_write);
+		/*
+		 * If we could not resolve the fault, consider it
+		 * userspace's fault and error out.
+		 */
+		if (ret)
+			return ret;
+	}
+	/*
+	 * The cmpxchg was performed, check the results.
+	 */
+	if (actual_old_val != expected_old_val) {
+		/*
+		 * Someone else raced with us to unmap the table.
+		 * There was no bounds table pointed to by the
+		 * directory, so declare success.  Somebody freed
+		 * it.
+		 */
+		if (!actual_old_val)
+			return 0;
+		/*
+		 * Something messed with the bounds directory
+		 * entry.  We hold mmap_sem for read or write
+		 * here, so it could not be a _new_ bounds table
+		 * that someone just allocated.  Something is
+		 * wrong, so pass up the error and SIGSEGV.
+		 */
+		return -EINVAL;
+	}
+
+	/*
+	 * Note, we are likely being called under do_munmap() already. To
+	 * avoid recursion, do_munmap() will check whether it comes
+	 * from one bounds table through VM_MPX flag.
+	 */
+	return do_munmap(mm, bt_addr, MPX_BT_SIZE_BYTES);
+}
+
+/*
+ * If the bounds table pointed by bounds directory 'bd_entry' is
+ * not shared, unmap this whole bounds table. Otherwise, only free
+ * those backing physical pages of bounds table entries covered
+ * in this virtual address region start...end.
+ */
+static int unmap_shared_bt(struct mm_struct *mm,
+		long __user *bd_entry, unsigned long start,
+		unsigned long end, bool prev_shared, bool next_shared)
+{
+	unsigned long bt_addr;
+	int ret;
+
+	ret = get_bt_addr(mm, bd_entry, &bt_addr);
+	/*
+	 * We could see an "error" ret for not-present bounds
+	 * tables (not really an error), or actual errors, but
+	 * stop unmapping either way.
+	 */
+	if (ret)
+		return ret;
+
+	if (prev_shared && next_shared)
+		ret = zap_bt_entries(mm, bt_addr,
+				bt_addr+MPX_GET_BT_ENTRY_OFFSET(start),
+				bt_addr+MPX_GET_BT_ENTRY_OFFSET(end));
+	else if (prev_shared)
+		ret = zap_bt_entries(mm, bt_addr,
+				bt_addr+MPX_GET_BT_ENTRY_OFFSET(start),
+				bt_addr+MPX_BT_SIZE_BYTES);
+	else if (next_shared)
+		ret = zap_bt_entries(mm, bt_addr, bt_addr,
+				bt_addr+MPX_GET_BT_ENTRY_OFFSET(end));
+	else
+		ret = unmap_single_bt(mm, bd_entry, bt_addr);
+
+	return ret;
+}
+
+/*
+ * A virtual address region being munmap()ed might share bounds table
+ * with adjacent VMAs. We only need to free the backing physical
+ * memory of these shared bounds tables entries covered in this virtual
+ * address region.
+ */
+static int unmap_edge_bts(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
+{
+	int ret;
+	long __user *bde_start, *bde_end;
+	struct vm_area_struct *prev, *next;
+	bool prev_shared = false, next_shared = false;
+
+	bde_start = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(start);
+	bde_end = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(end-1);
+
+	/*
+	 * Check whether bde_start and bde_end are shared with adjacent
+	 * VMAs.
+	 *
+	 * We already unliked the VMAs from the mm's rbtree so 'start'
+	 * is guaranteed to be in a hole. This gets us the first VMA
+	 * before the hole in to 'prev' and the next VMA after the hole
+	 * in to 'next'.
+	 */
+	next = find_vma_prev(mm, start, &prev);
+	if (prev && (mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(prev->vm_end-1))
+			== bde_start)
+		prev_shared = true;
+	if (next && (mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(next->vm_start))
+			== bde_end)
+		next_shared = true;
+
+	/*
+	 * This virtual address region being munmap()ed is only
+	 * covered by one bounds table.
+	 *
+	 * In this case, if this table is also shared with adjacent
+	 * VMAs, only part of the backing physical memory of the bounds
+	 * table need be freeed. Otherwise the whole bounds table need
+	 * be unmapped.
+	 */
+	if (bde_start == bde_end) {
+		return unmap_shared_bt(mm, bde_start, start, end,
+				prev_shared, next_shared);
+	}
+
+	/*
+	 * If more than one bounds tables are covered in this virtual
+	 * address region being munmap()ed, we need to separately check
+	 * whether bde_start and bde_end are shared with adjacent VMAs.
+	 */
+	ret = unmap_shared_bt(mm, bde_start, start, end, prev_shared, false);
+	if (ret)
+		return ret;
+	ret = unmap_shared_bt(mm, bde_end, start, end, false, next_shared);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int mpx_unmap_tables(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
+{
+	int ret;
+	long __user *bd_entry, *bde_start, *bde_end;
+	unsigned long bt_addr;
+
+	/*
+	 * "Edge" bounds tables are those which are being used by the region
+	 * (start -> end), but that may be shared with adjacent areas.  If they
+	 * turn out to be completely unshared, they will be freed.  If they are
+	 * shared, we will free the backing store (like an MADV_DONTNEED) for
+	 * areas used by this region.
+	 */
+	ret = unmap_edge_bts(mm, start, end);
+	switch (ret) {
+		/* non-present tables are OK */
+		case 0:
+		case -ENOENT:
+			/* Success, or no tables to unmap */
+			break;
+		case -EINVAL:
+		case -EFAULT:
+		default:
+			return ret;
+	}
+
+	/*
+	 * Only unmap the bounds table that are
+	 *   1. fully covered
+	 *   2. not at the edges of the mapping, even if full aligned
+	 */
+	bde_start = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(start);
+	bde_end = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(end-1);
+	for (bd_entry = bde_start + 1; bd_entry < bde_end; bd_entry++) {
+		ret = get_bt_addr(mm, bd_entry, &bt_addr);
+		switch (ret) {
+			case 0:
+				break;
+			case -ENOENT:
+				/* No table here, try the next one */
+				continue;
+			case -EINVAL:
+			case -EFAULT:
+			default:
+				/*
+				 * Note: we are being strict here.
+				 * Any time we run in to an issue
+				 * unmapping tables, we stop and
+				 * SIGSEGV.
+				 */
+				return ret;
+		}
+
+		ret = unmap_single_bt(mm, bd_entry, bt_addr);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Free unused bounds tables covered in a virtual address region being
+ * munmap()ed. Assume end > start.
+ *
+ * This function will be called by do_munmap(), and the VMAs covering
+ * the virtual address region start...end have already been split if
+ * necessary, and the 'vma' is the first vma in this range (start -> end).
+ */
+void mpx_notify_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	int ret;
+
+	/*
+	 * Refuse to do anything unless userspace has asked
+	 * the kernel to help manage the bounds tables,
+	 */
+	if (!kernel_managing_mpx_tables(current->mm))
+		return;
+	/*
+	 * This will look across the entire 'start -> end' range,
+	 * and find all of the non-VM_MPX VMAs.
+	 *
+	 * To avoid recursion, if a VM_MPX vma is found in the range
+	 * (start->end), we will not continue follow-up work. This
+	 * recursion represents having bounds tables for bounds tables,
+	 * which should not occur normally. Being strict about it here
+	 * helps ensure that we do not have an exploitable stack overflow.
+	 */
+	do {
+		if (vma->vm_flags & VM_MPX)
+			return;
+		vma = vma->vm_next;
+	} while (vma && vma->vm_start < end);
+
+	ret = mpx_unmap_tables(mm, start, end);
+	if (ret)
+		force_sig(SIGSEGV, current);
+}
diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index 872eb60e7806..ba70ff232917 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -254,7 +254,7 @@ int main(int argc, char **argv)
 			continue;
 
 		/* Decode an instruction */
-		insn_init(&insn, insn_buf, x86_64);
+		insn_init(&insn, insn_buf, sizeof(insn_buf), x86_64);
 		insn_get_length(&insn);
 
 		if (insn.next_byte <= insn.kaddr ||
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index 13403fc95a96..56f04db0c9c0 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -149,7 +149,7 @@ int main(int argc, char **argv)
 				break;
 		}
 		/* Decode an instruction */
-		insn_init(&insn, insn_buf, x86_64);
+		insn_init(&insn, insn_buf, sizeof(insn_buf), x86_64);
 		insn_get_length(&insn);
 		if (insn.length != nb) {
 			warnings++;
diff --git a/fs/exec.c b/fs/exec.c
index 7302b75a9820..01aebe300200 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -277,6 +277,7 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 		goto err;
 
 	mm->stack_vm = mm->total_vm = 1;
+	arch_bprm_mm_init(mm, vma);
 	up_write(&mm->mmap_sem);
 	bprm->p = vma->vm_end - sizeof(void *);
 	return 0;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0388cffe3d..f6734c6b66a6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -552,6 +552,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
 		[ilog2(VM_DENYWRITE)]	= "dw",
+#ifdef CONFIG_X86_INTEL_MPX
+		[ilog2(VM_MPX)]		= "mp",
+#endif
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 67dea8123683..866aa461efa5 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -1,7 +1,7 @@
 /*
- * Define generic no-op hooks for arch_dup_mmap and arch_exit_mmap, to
- * be included in asm-FOO/mmu_context.h for any arch FOO which doesn't
- * need to hook these.
+ * Define generic no-op hooks for arch_dup_mmap, arch_exit_mmap
+ * and arch_unmap to be included in asm-FOO/mmu_context.h for any
+ * arch FOO which doesn't need to hook these.
  */
 #ifndef _ASM_GENERIC_MM_HOOKS_H
 #define _ASM_GENERIC_MM_HOOKS_H
@@ -15,4 +15,15 @@ static inline void arch_exit_mmap(struct mm_struct *mm)
 {
 }
 
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif	/* _ASM_GENERIC_MM_HOOKS_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b46461116cd2..f7606d3a0915 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -128,6 +128,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
+#define VM_ARCH_2	0x02000000
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
@@ -155,6 +156,11 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
 #endif
 
+#if defined(CONFIG_X86)
+/* MPX specific bounds table or bounds directory */
+# define VM_MPX		VM_ARCH_2
+#endif
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6e0b286649f1..004e9d17b47e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -454,6 +454,10 @@ struct mm_struct {
 	bool tlb_flush_pending;
 #endif
 	struct uprobes_state uprobes_state;
+#ifdef CONFIG_X86_INTEL_MPX
+	/* address of the bounds directory */
+	void __user *bd_addr;
+#endif
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index ba5be7fdbdfe..1e3552037a5a 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -91,6 +91,10 @@ typedef struct siginfo {
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
 			short _addr_lsb; /* LSB of the reported address */
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL */
@@ -131,6 +135,8 @@ typedef struct siginfo {
 #define si_trapno	_sifields._sigfault._trapno
 #endif
 #define si_addr_lsb	_sifields._sigfault._addr_lsb
+#define si_lower	_sifields._sigfault._addr_bnd._lower
+#define si_upper	_sifields._sigfault._addr_bnd._upper
 #define si_band		_sifields._sigpoll._band
 #define si_fd		_sifields._sigpoll._fd
 #ifdef __ARCH_SIGSYS
@@ -199,7 +205,8 @@ typedef struct siginfo {
  */
 #define SEGV_MAPERR	(__SI_FAULT|1)	/* address not mapped to object */
 #define SEGV_ACCERR	(__SI_FAULT|2)	/* invalid permissions for mapped object */
-#define NSIGSEGV	2
+#define SEGV_BNDERR	(__SI_FAULT|3)  /* failed address bound checks */
+#define NSIGSEGV	3
 
 /*
  * SIGBUS si_codes
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 513df75d0fc9..89f63503f903 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -179,4 +179,10 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
+/*
+ * Tell the kernel to start/stop helping userspace manage bounds tables.
+ */
+#define PR_MPX_ENABLE_MANAGEMENT  43
+#define PR_MPX_DISABLE_MANAGEMENT 44
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f9f6dd..2c403a4c8bee 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2748,6 +2748,10 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
+#ifdef SEGV_BNDERR
+		err |= __put_user(from->si_lower, &to->si_lower);
+		err |= __put_user(from->si_upper, &to->si_upper);
+#endif
 		break;
 	case __SI_CHLD:
 		err |= __put_user(from->si_pid, &to->si_pid);
diff --git a/kernel/sys.c b/kernel/sys.c
index 1eaa2f0b0246..a8c9f5a7dda6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -91,6 +91,12 @@
 #ifndef SET_TSC_CTL
 # define SET_TSC_CTL(a)		(-EINVAL)
 #endif
+#ifndef MPX_ENABLE_MANAGEMENT
+# define MPX_ENABLE_MANAGEMENT(a)	(-EINVAL)
+#endif
+#ifndef MPX_DISABLE_MANAGEMENT
+# define MPX_DISABLE_MANAGEMENT(a)	(-EINVAL)
+#endif
 
 /*
  * this is where the system-wide overflow UID and GID are defined, for
@@ -2203,6 +2209,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			me->mm->def_flags &= ~VM_NOHUGEPAGE;
 		up_write(&me->mm->mmap_sem);
 		break;
+	case PR_MPX_ENABLE_MANAGEMENT:
+		error = MPX_ENABLE_MANAGEMENT(me);
+		break;
+	case PR_MPX_DISABLE_MANAGEMENT:
+		error = MPX_DISABLE_MANAGEMENT(me);
+		break;
 	default:
 		error = -EINVAL;
 		break;
diff --git a/mm/mmap.c b/mm/mmap.c
index 87e82b38453c..814762c15631 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2597,6 +2597,8 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	detach_vmas_to_be_unmapped(mm, vma, prev, end);
 	unmap_region(mm, vma, prev, start, end);
 
+	arch_unmap(mm, vma, start, end);
+
 	/* Fix up all other VM information */
 	remove_vma_list(mm, vma);
 
