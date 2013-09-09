Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3IIVdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:33:32 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34829 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab3IIVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:33:14 -0400
From: Andrew Pinski <pinskia@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5/5] ARM64: Add support for ILP32 ABI.
Date: Mon,  9 Sep 2013 14:32:59 -0700
Message-Id: <1378762380-13152-5-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378762380-13152-1-git-send-email-apinski@cavium.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds full support of the ABI to the ARM64 target.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/Kconfig                           |   11 +-
 arch/arm64/include/asm/Kbuild                |    1 -
 arch/arm64/include/asm/compat.h              |   72 ++++++-
 arch/arm64/include/asm/elf.h                 |   71 ++++++--
 arch/arm64/include/asm/hwcap.h               |    2 +-
 arch/arm64/include/asm/memory.h              |    4 +-
 arch/arm64/include/asm/processor.h           |   12 --
 arch/arm64/include/asm/stat.h                |    6 +-
 arch/arm64/include/asm/syscalls.h            |    3 +
 arch/arm64/include/asm/thread_info.h         |    1 +
 arch/arm64/include/asm/unistd.h              |   10 +-
 arch/arm64/include/asm/vdso.h                |    4 +
 arch/arm64/include/uapi/asm/bitsperlong.h    |    7 +-
 arch/arm64/include/uapi/asm/posix_types.h    |   12 ++
 arch/arm64/include/uapi/asm/siginfo.h        |    6 +
 arch/arm64/kernel/Makefile                   |    7 +
 arch/arm64/kernel/entry.S                    |   20 ++-
 arch/arm64/kernel/process.c                  |   18 ++
 arch/arm64/kernel/ptrace.c                   |   38 ++++-
 arch/arm64/kernel/signal.c                   |   43 ++++-
 arch/arm64/kernel/signal_template.c          |  193 ++++++++++++++++++
 arch/arm64/kernel/signalilp32.c              |   30 +++
 arch/arm64/kernel/sys_ilp32.c                |  274 ++++++++++++++++++++++++++
 arch/arm64/kernel/vdso.c                     |   81 ++++++++-
 arch/arm64/kernel/vdsoilp32/.gitignore       |    2 +
 arch/arm64/kernel/vdsoilp32/Makefile         |   72 +++++++
 arch/arm64/kernel/vdsoilp32/vdso_ilp32.lds.S |  100 ++++++++++
 arch/arm64/kernel/vdsoilp32/vdsoilp32.S      |   33 +++
 arch/arm64/mm/init.c                         |    1 +
 29 files changed, 1076 insertions(+), 58 deletions(-)
 create mode 100644 arch/arm64/include/uapi/asm/posix_types.h
 create mode 100644 arch/arm64/kernel/signal_template.c
 create mode 100644 arch/arm64/kernel/signalilp32.c
 create mode 100644 arch/arm64/kernel/sys_ilp32.c
 create mode 100644 arch/arm64/kernel/vdsoilp32/.gitignore
 create mode 100644 arch/arm64/kernel/vdsoilp32/Makefile
 create mode 100644 arch/arm64/kernel/vdsoilp32/vdso_ilp32.lds.S
 create mode 100644 arch/arm64/kernel/vdsoilp32/vdsoilp32.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cc64df5..7fdc994 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -248,7 +248,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	def_bool y
-	depends on ARM64_AARCH32
+	depends on ARM64_AARCH32 || ARM64_ILP32
 	select COMPAT_BINFMT_ELF
 
 config ARM64_AARCH32
@@ -263,7 +263,14 @@ config ARM64_AARCH32
 	  the user helper functions, VFP support and the ptrace interface are
 	  handled appropriately by the kernel.
 
-	  If you want to execute 32-bit userspace applications, say Y.
+	  If you want to execute Aarch32 userspace applications, say Y.
+
+config ARM64_ILP32
+	bool "Kernel support for ILP32"
+	help
+	  This option enables support for AArch64 ILP32 user space.  These are
+	  64-bit binaries using 32-bit quantities for addressing and certain
+	  data that would normally be 64-bit.
 
 config SYSVIPC_COMPAT
 	def_bool y
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 79a642d..902aef9 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -28,7 +28,6 @@ generic-y += mutex.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 5ab2676..91bcf13 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -62,6 +62,8 @@ typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
 typedef u32		compat_uptr_t;
 
+typedef s64		ilp32_clock_t;
+
 struct compat_timespec {
 	compat_time_t	tv_sec;
 	s32		tv_nsec;
@@ -180,6 +182,15 @@ typedef struct compat_siginfo {
 			compat_clock_t _stime;
 		} _sigchld;
 
+		/* SIGCHLD (ILP32 version) */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			__compat_uid32_t _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			ilp32_clock_t _utime;
+			ilp32_clock_t _stime;
+		} _sigchld_ilp32;
+
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
 		struct {
 			compat_uptr_t _addr; /* faulting insn/memory ref. */
@@ -214,12 +225,15 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-#define compat_user_stack_pointer() (current_pt_regs()->compat_sp)
+#define COMPAT_USE_64BIT_TIME is_ilp32_task()
+
+/* AARCH64 ILP32 vs AARCH32 differences. */
+#define compat_user_stack_pointer()			\
+	(is_ilp32_task()				\
+	 ? current_user_stack_pointer()			\
+	 : current_pt_regs()->compat_sp)
+
 
-static inline void __user *arch_compat_alloc_user_space(long len)
-{
-	return (void __user *)compat_user_stack_pointer() - len;
-}
 
 struct compat_ipc64_perm {
 	compat_key_t key;
@@ -279,7 +293,7 @@ struct compat_shmid64_ds {
 	compat_ulong_t __unused5;
 };
 
-#if defined(CONFIG_ARM64_AARCH32)
+#ifdef CONFIG_ARM64_AARCH32
 static inline int is_aarch32_task(void)
 {
 	return test_thread_flag(TIF_32BIT);
@@ -289,7 +303,9 @@ static inline int is_aarch32_thread(struct thread_info *thread)
 {
 	return test_ti_thread_flag(thread, TIF_32BIT);
 }
+
 #else
+
 static inline int is_aarch32_task(void)
 {
 	return 0;
@@ -299,8 +315,36 @@ static inline int is_aarch32_thread(struct thread_info *thread)
 {
 	return 0;
 }
-#endif
+#endif /* CONFIG_ARM64_AARCH32 */
+
+#ifdef CONFIG_ARM64_ILP32
+static inline int is_ilp32_task(void)
+{
+	return test_thread_flag(TIF_32BIT_AARCH64);
+}
+
+static inline int is_ilp32_thread(struct thread_info *thread)
+{
+	return test_ti_thread_flag(thread, TIF_32BIT_AARCH64);
+}
+
+#else
+
+static inline int is_ilp32_task(void)
+{
+	return 0;
+}
 
+static inline int is_ilp32_thread(struct thread_info *thread)
+{
+	return 0;
+}
+#endif /* CONFIG_ARM64_ILP32 */
+
+static inline void __user *arch_compat_alloc_user_space(long len)
+{
+	return (void __user *)compat_user_stack_pointer() - len;
+}
 
 #else /* !CONFIG_COMPAT */
 
@@ -308,22 +352,28 @@ static inline int is_aarch32_task(void)
 {
 	return 0;
 }
-
 static inline int is_aarch32_thread(struct thread_info *thread)
 {
 	return 0;
 }
-
+static inline int is_ilp32_task(void)
+{
+	return 0;
+}
+static inline int is_ilp32_thread(struct thread_info *thread)
+{
+	return 0;
+}
 #endif /* CONFIG_COMPAT */
 
 static inline int is_compat_task(void)
 {
-  return is_aarch32_task();
+	return is_aarch32_task() || is_ilp32_task();
 }
 
 static inline int is_compat_thread(struct thread_info *thread)
 {
-  return is_aarch32_thread(thread);
+	return is_aarch32_thread(thread) || is_ilp32_thread(thread);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 0a89e94..7b07b52 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -122,13 +122,15 @@ extern unsigned long randomize_et_dyn(unsigned long base);
  */
 #define ELF_PLAT_INIT(_r, load_addr)	(_r)->regs[0] = 0
 
-#define SET_PERSONALITY(ex)		clear_thread_flag(TIF_32BIT);
+#define SET_PERSONALITY(ex)    do {			\
+		clear_thread_flag(TIF_32BIT);		\
+		clear_thread_flag(TIF_32BIT_AARCH64);	\
+	} while (0)
 
-#define ARCH_DLINFO							\
-do {									\
-	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
-		    (elf_addr_t)current->mm->context.vdso);		\
-} while (0)
+#define ARCH_DLINFO	do {						\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
+			    (elf_addr_t)current->mm->context.vdso);	\
+	} while (0)
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
@@ -165,20 +167,65 @@ typedef compat_a32_elf_greg_t compat_a32_elf_gregset_t[COMPAT_ELF_NGREG];
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
 #define COMPAT_SET_A32_PERSONALITY(ex)	set_thread_flag(TIF_32BIT);
-#define COMPAT_ARCH_DLINFO
 
 extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
 				      int uses_interp);
 #define compat_arch_setup_additional_pages \
 					aarch32_setup_vectors_page
 
-typedef compat_a32_elf_greg_t		compat_elf_greg_t;
-typedef compat_a32_elf_gregset_t	compat_elf_gregset_t;
+extern void compat_start_thread(struct pt_regs *regs, unsigned long pc,
+				unsigned long sp);
+#define compat_start_thread		compat_start_thread
+
+#else
+#define COMPAT_SET_A32_PERSONALITY(ex) do {} while (0)
+#define compat_elf_a32_check_arch(x)    (0)
 #endif
 
-#define compat_elf_check_arch(x) compat_elf_a32_check_arch(x)
-#define COMPAT_SET_PERSONALITY(ex) COMPAT_SET_A32_PERSONALITY(x)
-#define compat_start_thread		compat_start_thread
+#ifdef CONFIG_ARM64_ILP32
+#define COMPAT_SET_ILP32_PERSONALITY(ex)	do { \
+		set_thread_flag(TIF_32BIT_AARCH64);         \
+		clear_thread_flag(TIF_32BIT);               \
+	} while (0)
+
+#define compat_elf_ilp32_check_arch(x) ((x)->e_machine == EM_AARCH64)
+
+#define ARCH_DLINFO_ILP32	do {						\
+		NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
+			    (elf_addr_t)(long)current->mm->context.vdso);	\
+	} while (0)
+
+typedef unsigned long                  compat_elf_greg_t;
+typedef compat_elf_greg_t              compat_elf_gregset_t[32+2];
+#define PR_REG_SIZE(S)                 (is_aarch32_task() ? 72 : 272)
+#define PRSTATUS_SIZE(S)               (is_aarch32_task() ? 124 : (is_ilp32_task() ? 352 : 392))
+#define SET_PR_FPVALID(S, V) \
+	(void)(*(int *) (((void *) &((S)->pr_reg)) + PR_REG_SIZE((S)->pr_reg)) = (V));
+
+#else
+#define compat_elf_ilp32_check_arch(x)  0
+#define ARCH_DLINFO_ILP32          do {} while (0)
+
+typedef compat_a32_elf_greg_t          compat_elf_greg_t;
+typedef compat_elf_greg_t              compat_elf_gregset_t[COMPAT_ELF_NGREG];
+#define COMPAT_SET_ILP32_PERSONALITY(x) do {} while (0)
+
+#endif /* CONFIG_ARM64_ILP32 */
+
+#define COMPAT_ARCH_DLINFO	do {		\
+		if (is_ilp32_task())		\
+			ARCH_DLINFO_ILP32;	\
+	} while (0)
+
+#define compat_elf_check_arch(x) (compat_elf_a32_check_arch(x) || compat_elf_ilp32_check_arch(x))
+#define COMPAT_SET_PERSONALITY(ex)	do {			\
+		if (compat_elf_ilp32_check_arch(&(ex)))		\
+			COMPAT_SET_ILP32_PERSONALITY((ex));	\
+		else						\
+			COMPAT_SET_A32_PERSONALITY((ex));	\
+	} while (0)
+
+
 
 #endif /* CONFIG_COMPAT */
 
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index d189728..581398f 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -44,6 +44,6 @@
 				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
 
 extern unsigned int elf_hwcap;
-#define COMPAT_ELF_HWCAP COMPAT_ELF_A32_HWCAP
+#define COMPAT_ELF_HWCAP (is_aarch32_task() ? COMPAT_ELF_A32_HWCAP : elf_hwcap)
 #endif
 #endif
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 4a644a5..720515c 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -52,8 +52,8 @@
 #define TASK_SIZE		(is_compat_task() ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
 #else
-#define TASK_SIZE              TASK_SIZE_64
-#endif
+#define TASK_SIZE		TASK_SIZE_64
+#endif /* CONFIG_COMPAT */
 
 #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 9f0cbcd..fd7a439 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -99,18 +99,6 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->sp = sp;
 }
 
-#ifdef CONFIG_COMPAT
-static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
-				       unsigned long sp)
-{
-	start_thread_common(regs, pc);
-	regs->pstate = COMPAT_PSR_MODE_USR;
-	if (pc & 1)
-		regs->pstate |= COMPAT_PSR_T_BIT;
-	regs->compat_sp = sp;
-}
-#endif
-
 /* Forward declaration, a strange C thing */
 struct task_struct;
 
diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
index 989128a..f2e0d3c 100644
--- a/arch/arm64/include/asm/stat.h
+++ b/arch/arm64/include/asm/stat.h
@@ -18,9 +18,11 @@
 
 #include <uapi/asm/stat.h>
 
-#ifdef CONFIG_ARM64_AARCH32
-
+#ifdef CONFIG_COMPAT
 #include <asm/compat.h>
+#endif
+
+#ifdef CONFIG_ARM64_AARCH32
 
 /*
  * struct stat64 is needed for compat tasks only. Its definition is different
diff --git a/arch/arm64/include/asm/syscalls.h b/arch/arm64/include/asm/syscalls.h
index 48fe7c6..ef6dfdc 100644
--- a/arch/arm64/include/asm/syscalls.h
+++ b/arch/arm64/include/asm/syscalls.h
@@ -24,6 +24,9 @@
  * System call wrappers implemented in kernel/entry.S.
  */
 asmlinkage long sys_rt_sigreturn_wrapper(void);
+#ifdef CONFIG_ARM64_ILP32
+asmlinkage long sys_ilp32_rt_sigreturn_wrapper(void);
+#endif
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 23a3c47..18ecdca 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -114,6 +114,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* 32bit process */
 #define TIF_SWITCH_MM		23	/* deferred switch_mm */
+#define TIF_32BIT_AARCH64	24	/* 32 bit process on AArch64(ILP32)  */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 82ce217..33cd2fd 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,18 +13,22 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_ARM64_AARCH32
 #define __ARCH_WANT_COMPAT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
-#define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
 #endif
+
+#ifdef CONFIG_COMPAT
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#endif
+
 #define __ARCH_WANT_SYS_CLONE
 #include <uapi/asm/unistd.h>
diff --git a/arch/arm64/include/asm/vdso.h b/arch/arm64/include/asm/vdso.h
index 839ce00..84050c6 100644
--- a/arch/arm64/include/asm/vdso.h
+++ b/arch/arm64/include/asm/vdso.h
@@ -29,6 +29,10 @@
 
 #include <generated/vdso-offsets.h>
 
+#ifdef CONFIG_ARM64_ILP32
+#include <generated/vdso-ilp32-offsets.h>
+#endif
+
 #define VDSO_SYMBOL(base, name)						   \
 ({									   \
 	(void *)(vdso_offset_##name - VDSO_LBASE + (unsigned long)(base)); \
diff --git a/arch/arm64/include/uapi/asm/bitsperlong.h b/arch/arm64/include/uapi/asm/bitsperlong.h
index fce9c29..3d35762 100644
--- a/arch/arm64/include/uapi/asm/bitsperlong.h
+++ b/arch/arm64/include/uapi/asm/bitsperlong.h
@@ -16,7 +16,12 @@
 #ifndef __ASM_BITSPERLONG_H
 #define __ASM_BITSPERLONG_H
 
-#define __BITS_PER_LONG 64
+
+#ifdef __LP64__
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
 
 #include <asm-generic/bitsperlong.h>
 
diff --git a/arch/arm64/include/uapi/asm/posix_types.h b/arch/arm64/include/uapi/asm/posix_types.h
new file mode 100644
index 0000000..53b15e6
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/posix_types.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_POSIX_TYPES_H
+#define __ASM_POSIX_TYPES_H
+
+#ifndef __LP64__	/* ILP32 */
+typedef long long __kernel_long_t;
+typedef unsigned long long __kernel_ulong_t;
+#define __kernel_long_t __kernel_long_t
+#endif
+
+#include <asm-generic/posix_types.h>
+
+#endif /* __ASM_POSIX_TYPES_H */
diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
index 5a74a08..297fb4f 100644
--- a/arch/arm64/include/uapi/asm/siginfo.h
+++ b/arch/arm64/include/uapi/asm/siginfo.h
@@ -16,7 +16,13 @@
 #ifndef __ASM_SIGINFO_H
 #define __ASM_SIGINFO_H
 
+#ifdef __LP64__
 #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
+#else /* ILP32 */
+typedef long long __kernel_si_clock_t __attribute__((aligned(4)));
+#define __ARCH_SI_CLOCK_T	__kernel_si_clock_t
+#define __ARCH_SI_ATTRIBUTES	__attribute__((aligned(8)))
+#endif
 
 #include <asm-generic/siginfo.h>
 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index e23efb7..432a71d 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -13,6 +13,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 
 arm64-obj-$(CONFIG_ARM64_AARCH32)	+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
+arm64-obj-$(CONFIG_ARM64_ILP32)		+= sys_ilp32.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o smp_psci.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
@@ -20,6 +21,7 @@ arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-y					+= $(arm64-obj-y) vdso/
+obj-$(CONFIG_ARM64_ILP32)		+= vdsoilp32/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
 extra-y					:= $(head-y) vmlinux.lds
@@ -27,3 +29,8 @@ extra-y					:= $(head-y) vmlinux.lds
 # vDSO - this must be built first to generate the symbol offsets
 $(call objectify,$(arm64-obj-y)): $(obj)/vdso/vdso-offsets.h
 $(obj)/vdso/vdso-offsets.h: $(obj)/vdso
+
+ifeq ($(CONFIG_ARM64_ILP32),y)
+$(call objectify,$(arm64-obj-y)): $(obj)/vdsoilp32/vdso-ilp32-offsets.h
+$(obj)/vdsoilp32/vdso-ilp32-offsets.h: $(obj)/vdsoilp32
+endif
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 28cf5c7..548ecc6 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -633,9 +633,14 @@ ENDPROC(ret_from_fork)
  */
 	.align	6
 el0_svc:
-	adrp	stbl, sys_call_table		// load syscall table pointer
 	uxtw	scno, w8			// syscall number in w8
 	mov	sc_nr, #__NR_syscalls
+#ifdef CONFIG_ARM64_ILP32
+	get_thread_info tsk
+	ldr	x16, [tsk, #TI_FLAGS]
+	tbnz	x16, #TIF_32BIT_AARCH64, el0_ilp32_svc // We are using ILP32
+#endif
+	adrp	stbl, sys_call_table		// load syscall table pointer
 el0_svc_naked:					// compat entry point
 	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
 	disable_step x16
@@ -656,6 +661,12 @@ ni_sys:
 	b	do_ni_syscall
 ENDPROC(el0_svc)
 
+#ifdef CONFIG_ARM64_ILP32
+el0_ilp32_svc:
+	adrp	stbl, sys_ilp32_call_table	// load syscall table pointer
+	b el0_svc_naked
+#endif
+
 	/*
 	 * This is the really slow path.  We're going to be doing context
 	 * switches, and waiting for our parent to respond.
@@ -691,5 +702,12 @@ ENTRY(sys_rt_sigreturn_wrapper)
 	b	sys_rt_sigreturn
 ENDPROC(sys_rt_sigreturn_wrapper)
 
+#ifdef CONFIG_ARM64_ILP32
+ENTRY(sys_ilp32_rt_sigreturn_wrapper)
+	mov	x0, sp
+	b	sys_ilp32_rt_sigreturn
+ENDPROC(sys_ilp32_rt_sigreturn_wrapper)
+#endif
+
 ENTRY(handle_arch_irq)
 	.quad	0
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 8845c2d..233c591 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -329,3 +329,21 @@ unsigned long randomize_et_dyn(unsigned long base)
 {
 	return randomize_base(base);
 }
+
+#ifdef CONFIG_ARM64_AARCH32
+void compat_start_thread(struct pt_regs *regs, unsigned long pc,
+			 unsigned long sp)
+{
+	if (is_ilp32_task()) {
+		start_thread(regs, pc, sp);
+		return;
+	}
+
+	start_thread_common(regs, pc);
+	regs->pstate = COMPAT_PSR_MODE_USR;
+	if (pc & 1)
+		regs->pstate |= COMPAT_PSR_T_BIT;
+	regs->compat_sp = sp;
+}
+#endif
+
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 4805581..956f18c 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -609,8 +609,11 @@ static const struct user_regset_view user_aarch64_view = {
 	.regsets = aarch64_regsets, .n = ARRAY_SIZE(aarch64_regsets)
 };
 
-#ifdef CONFIG_ARM64_AARCH32
+#ifdef CONFIG_COMPAT
 #include <linux/compat.h>
+#endif
+
+#ifdef CONFIG_ARM64_AARCH32
 
 enum compat_regset {
 	REGSET_COMPAT_GPR,
@@ -968,8 +971,9 @@ static int compat_ptrace_sethbpregs(struct task_struct *tsk, compat_long_t num,
 }
 #endif	/* CONFIG_HAVE_HW_BREAKPOINT */
 
-long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
-			compat_ulong_t caddr, compat_ulong_t cdata)
+
+static long compat_arch_aarch32_ptrace(struct task_struct *child, compat_long_t request,
+				       compat_ulong_t caddr, compat_ulong_t cdata)
 {
 	unsigned long addr = caddr;
 	unsigned long data = cdata;
@@ -1047,6 +1051,34 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 }
 #endif /* CONFIG_ARM64_AARCH32 */
 
+#ifdef CONFIG_ARM64_ILP32
+static long compat_arch_ilp32_ptrace(struct task_struct *child, compat_long_t request,
+				     compat_ulong_t caddr, compat_ulong_t cdata)
+{
+	return compat_ptrace_request(child, request, caddr, cdata);
+}
+#endif  /* CONFIG_ARM64_ILP32 */
+
+#ifdef CONFIG_COMPAT
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
+{
+
+#ifdef CONFIG_ARM64_ILP32
+	if (is_ilp32_task())
+		return compat_arch_ilp32_ptrace(child, request, caddr, cdata);
+#endif
+
+#ifdef CONFIG_ARM64_AARCH32
+	if (is_aarch32_task())
+		return compat_arch_aarch32_ptrace(child, request, caddr, cdata);
+#endif
+
+	panic("Calling compat_arch_ptrace without being ilp32 or aarch32 task.");
+}
+
+#endif
+
 const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 {
 #ifdef CONFIG_ARM64_AARCH32
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 5986b7f..5278415 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -45,6 +45,29 @@ struct rt_sigframe {
 	u64 lr;
 };
 
+#ifdef CONFIG_COMPAT
+
+struct ucontext_ilp32 {
+	compat_ulong_t uc_flags;
+	compat_uptr_t	  uc_link; /* struct ucontext* */
+	compat_stack_t	  uc_stack;
+	compat_sigset_t	  uc_sigmask;
+	/* glibc uses a 1024-bit sigset_t */
+	__u8		  __unused[1024 / 8 - sizeof(sigset_t)];
+	/* last for future expansion */
+	struct sigcontext uc_mcontext;
+};
+
+struct rt_sigframe_ilp32 {
+	struct compat_siginfo info;
+	struct ucontext_ilp32 uc;
+	u64 fp;
+	u64 lr;
+};
+
+#endif
+
+
 static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 {
 	struct fpsimd_state *fpsimd = &current->thread.fpsimd_state;
@@ -96,7 +119,7 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 }
 
 #include "signal_template.c"
-
+#include "signalilp32.c"
 
 static void setup_restart_syscall(struct pt_regs *regs)
 {
@@ -133,9 +156,13 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 						    regs);
 		else
 			ret = compat_setup_frame(usig, ka, oldset, regs);
-	} else {
-		ret = setup_rt_frame(usig, ka, info, oldset, regs);
 	}
+#ifdef CONFIG_ARM64_ILP32
+	else if (is_ilp32_thread(thread))
+		ret = setup_rt_frame_ilp32(usig, ka, info, oldset, regs);
+#endif
+	else
+		ret = setup_rt_frame(usig, ka, info, oldset, regs);
 
 	/*
 	 * Check that the resulting registers are actually sane.
@@ -255,6 +282,7 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err;
+	bool ilp32 = is_ilp32_task();
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(*to)))
 		return -EFAULT;
@@ -304,8 +332,13 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
 		err |= __put_user(from->si_status, &to->si_status);
-		err |= __put_user(from->si_utime, &to->si_utime);
-		err |= __put_user(from->si_stime, &to->si_stime);
+		if (!ilp32) {
+			err |= __put_user(from->si_utime, &to->si_utime);
+			err |= __put_user(from->si_stime, &to->si_stime);
+		} else {
+			err |= __put_user(from->si_utime, &to->_sifields._sigchld_ilp32._utime);
+			err |= __put_user(from->si_stime, &to->_sifields._sigchld_ilp32._stime);
+		}
 		break;
 	case __SI_RT: /* This is not generated by the kernel as of now. */
 	case __SI_MESGQ: /* But this is */
diff --git a/arch/arm64/kernel/signal_template.c b/arch/arm64/kernel/signal_template.c
new file mode 100644
index 0000000..ceec598
--- /dev/null
+++ b/arch/arm64/kernel/signal_template.c
@@ -0,0 +1,193 @@
+/*
+ * Based on arch/arm/kernel/signal.c
+ *
+ * Copyright (C) 1995-2009 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+static int restore_sigframe(struct pt_regs *regs,
+			    struct rt_sigframe __user *sf)
+{
+	sigset_t set;
+	int i, err;
+	struct aux_context __user *aux =
+		(struct aux_context __user *)sf->uc.uc_mcontext.__reserved;
+
+	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
+	if (err == 0)
+		set_current_blocked(&set);
+
+	for (i = 0; i < 31; i++)
+		__get_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
+				 err);
+	__get_user_error(regs->sp, &sf->uc.uc_mcontext.sp, err);
+	__get_user_error(regs->pc, &sf->uc.uc_mcontext.pc, err);
+	__get_user_error(regs->pstate, &sf->uc.uc_mcontext.pstate, err);
+
+	/*
+	 * Avoid sys_rt_sigreturn() restarting.
+	 */
+	regs->syscallno = ~0UL;
+
+	err |= !valid_user_regs(&regs->user_regs);
+
+	if (err == 0)
+		err |= restore_fpsimd_context(&aux->fpsimd);
+
+	return err;
+}
+
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	/*
+	 * Since we stacked the signal on a 128-bit boundary, then 'sp' should
+	 * be word aligned here.
+	 */
+	if (regs->sp & 15)
+		goto badframe;
+
+	frame = (struct rt_sigframe __user *)regs->sp;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+
+	if (restore_sigframe(regs, frame))
+		goto badframe;
+
+	if (restore_altstack(&frame->uc.uc_stack))
+		goto badframe;
+
+	return regs->regs[0];
+
+badframe:
+	if (show_unhandled_signals)
+		pr_info_ratelimited("%s[%d]: bad frame in %s: pc=%08llx sp=%08llx\n",
+				    current->comm, task_pid_nr(current), __func__,
+				    regs->pc, regs->sp);
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+static int setup_sigframe(struct rt_sigframe __user *sf,
+			  struct pt_regs *regs, sigset_t *set)
+{
+	int i, err = 0;
+	struct aux_context __user *aux =
+		(struct aux_context __user *)sf->uc.uc_mcontext.__reserved;
+
+	/* set up the stack frame for unwinding */
+	__put_user_error(regs->regs[29], &sf->fp, err);
+	__put_user_error(regs->regs[30], &sf->lr, err);
+
+	for (i = 0; i < 31; i++)
+		__put_user_error(regs->regs[i], &sf->uc.uc_mcontext.regs[i],
+				 err);
+	__put_user_error(regs->sp, &sf->uc.uc_mcontext.sp, err);
+	__put_user_error(regs->pc, &sf->uc.uc_mcontext.pc, err);
+	__put_user_error(regs->pstate, &sf->uc.uc_mcontext.pstate, err);
+
+	__put_user_error(current->thread.fault_address, &sf->uc.uc_mcontext.fault_address, err);
+
+	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(*set));
+
+	if (err == 0)
+		err |= preserve_fpsimd_context(&aux->fpsimd);
+
+	/* set the "end" magic */
+	__put_user_error(0, &aux->end.magic, err);
+	__put_user_error(0, &aux->end.size, err);
+
+	return err;
+}
+
+static struct rt_sigframe __user *get_sigframe(struct k_sigaction *ka,
+					       struct pt_regs *regs)
+{
+	unsigned long sp, sp_top;
+	struct rt_sigframe __user *frame;
+
+	sp = sp_top = regs->sp;
+
+	/*
+	 * This is the X/Open sanctioned signal stack switching.
+	 */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && !sas_ss_flags(sp))
+		sp = sp_top = current->sas_ss_sp + current->sas_ss_size;
+
+	sp = (sp - sizeof(struct rt_sigframe)) & ~15;
+	frame = (struct rt_sigframe __user *)sp;
+
+	/*
+	 * Check that we can actually write to the signal frame.
+	 */
+	if (!access_ok(VERIFY_WRITE, frame, sp_top - sp))
+		frame = NULL;
+
+	return frame;
+}
+
+static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
+			 void __user *frame, int usig)
+{
+	__sigrestore_t sigtramp;
+
+	regs->regs[0] = usig;
+	regs->sp = (unsigned long)frame;
+	regs->regs[29] = regs->sp + offsetof(struct rt_sigframe, fp);
+	regs->pc = (unsigned long)ka->sa.sa_handler;
+
+	if (ka->sa.sa_flags & SA_RESTORER)
+		sigtramp = ka->sa.sa_restorer;
+	else
+#ifdef ilp32
+		sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp_ilp32);
+#else
+		sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
+#endif
+
+	regs->regs[30] = (unsigned long)sigtramp;
+}
+
+static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	int err = 0;
+
+	frame = get_sigframe(ka, regs);
+	if (!frame)
+		return 1;
+
+	__put_user_error(0, &frame->uc.uc_flags, err);
+	__put_user_error(0, &frame->uc.uc_link, err);
+
+	err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
+	err |= setup_sigframe(frame, regs, set);
+	if (err == 0) {
+		setup_return(regs, ka, frame, usig);
+		if (ka->sa.sa_flags & SA_SIGINFO) {
+			err |= copy_siginfo_to_user(&frame->info, info);
+			regs->regs[1] = (unsigned long)&frame->info;
+			regs->regs[2] = (unsigned long)&frame->uc;
+		}
+	}
+
+	return err;
+}
diff --git a/arch/arm64/kernel/signalilp32.c b/arch/arm64/kernel/signalilp32.c
new file mode 100644
index 0000000..607f8ec
--- /dev/null
+++ b/arch/arm64/kernel/signalilp32.c
@@ -0,0 +1,30 @@
+
+#ifdef CONFIG_ARM64_ILP32
+
+#define rt_sigframe rt_sigframe_ilp32
+#define restore_sigframe restore_sigframe_ilp32
+#define sys_rt_sigreturn sys_ilp32_rt_sigreturn
+#define restore_altstack compat_restore_altstack
+#define setup_sigframe setup_sigframe_ilp32
+#define get_sigframe get_sigframe_ilp32
+#define setup_return setup_return_ilp32
+#define setup_rt_frame setup_rt_frame_ilp32
+#define __save_altstack __compat_save_altstack
+#define copy_siginfo_to_user copy_siginfo_to_user32
+#define ilp32
+
+#include "signal_template.c"
+
+#undef rt_sigframe
+#undef restore_sigframe
+#undef sys_rt_sigreturn
+#undef restore_altstack
+#undef setup_sigframe
+#undef get_sigframe
+#undef setup_return
+#undef setup_rt_frame
+#undef __save_altstack
+#undef copy_siginfo_to_user
+#undef ilp32
+
+#endif
diff --git a/arch/arm64/kernel/sys_ilp32.c b/arch/arm64/kernel/sys_ilp32.c
new file mode 100644
index 0000000..ada52c8
--- /dev/null
+++ b/arch/arm64/kernel/sys_ilp32.c
@@ -0,0 +1,274 @@
+/*
+ * AArch64- ILP32 specific system calls implementation
+ *
+ * Copyright (C) 2013 Cavium Inc.
+ * Author: Andrew Pinski <apinski@cavium.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+/* Adjust unistd.h to provide 32-bit numbers and functions. */
+#define __SYSCALL_COMPAT
+
+#include <linux/compat.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/statfs.h>
+
+/*
+ * Wrappers to pass the pt_regs argument.
+ */
+#define compat_sys_rt_sigreturn sys_ilp32_rt_sigreturn_wrapper
+
+#include <asm/syscalls.h>
+
+#ifndef __AARCH64EB__
+#define __LONG_LONG_PAIR(HI, LO) LO, HI
+#else
+#define __LONG_LONG_PAIR(HI, LO) HI, LO
+#endif
+
+/* These system calls all split their 64bit arguments into high/low parts. */
+#define compat_sys_ftruncate64 ilp32_ftruncate64
+#define compat_sys_truncate64 ilp32_truncate64
+#define compat_sys_pread64 ilp32_pread64
+#define compat_sys_pwrite64 ilp32_pwrite64
+#define compat_sys_sync_file_range ilp32_sync_file_range
+#define compat_sys_readahead ilp32_readahead
+#define compat_sys_statfs64 ilp32_statfs64
+#define compat_sys_fstatfs64 ilp32_fstatfs64
+#define compat_sys_fallocate ilp32_fallocate
+#define compat_sys_fadvise64_64 ilp32_fadvise64_64
+
+#define sys_mmap2 sys_mmap_pgoff
+/* Since time_t is the 64bits. */
+#define compat_sys_gettimeofday sys_gettimeofday
+#define compat_sys_settimeofday sys_settimeofday
+#define compat_sys_wait4 sys_wait4
+#define compat_sys_times sys_times
+#define compat_sys_setitimer sys_setitimer
+#define compat_sys_getitimer sys_getitimer
+#define compat_sys_nanosleep sys_nanosleep
+#define compat_sys_clock_nanosleep sys_clock_nanosleep
+#define compat_sys_ppoll sys_ppoll
+#define sys_fstatat64 sys_newfstatat
+#define sys_fstat64 sys_newfstat
+#define compat_sys_sched_rr_get_interval sys_sched_rr_get_interval
+#define compat_sys_utimensat sys_utimensat
+#define compat_sys_timerfd_settime sys_timerfd_settime
+#define compat_sys_timerfd_gettime sys_timerfd_gettime
+#define compat_sys_io_getevents sys_io_getevents
+#define compat_sys_epoll_pwait sys_epoll_pwait
+
+#define compat_sys_timer_create sys_timer_create
+#define compat_sys_timer_gettime sys_timer_gettime
+#define compat_sys_timer_settime sys_timer_settime
+#define compat_sys_clock_settime sys_clock_settime
+#define compat_sys_clock_gettime sys_clock_gettime
+#define compat_sys_clock_getres sys_clock_getres
+
+#define compat_sys_getrusage sys_getrusage
+
+/* Since timex is the same as the non-comat one */
+#define compat_sys_adjtimex sys_adjtimex
+#define compat_sys_clock_adjtime sys_clock_adjtime
+
+/* Since mq_attr is the same as the non-compat one */
+#define compat_sys_mq_timedsend sys_mq_timedsend
+#define compat_sys_mq_timedreceive sys_mq_timedreceive
+#define compat_sys_mq_getsetattr sys_mq_getsetattr
+#define compat_sys_mq_open  sys_mq_open
+
+#define compat_sys_msgctl sys_msgctl
+#define compat_sys_semctl sys_semctl
+#define compat_sys_shmctl sys_shmctl
+
+#define sys_ptrace compat_sys_ptrace
+
+/* pselect is special as we have both compat ulong and native timespec. */
+#define compat_sys_pselect6 ilp32_sys_pselect6
+
+asmlinkage long ilp32_statfs64(const char __user *pathname, compat_size_t sz,
+			       struct statfs __user *buf)
+{
+	int error;
+	if (sz != sizeof(*buf))
+		return -EINVAL;
+	error = sys_statfs(pathname, buf);
+	return error;
+}
+
+asmlinkage long ilp32_fstatfs64(unsigned int fd, compat_size_t sz, struct statfs __user *buf)
+{
+	int error;
+	if (sz != sizeof(*buf))
+		return -EINVAL;
+	error = sys_fstatfs(fd, buf);
+	return error;
+}
+
+asmlinkage long ilp32_fallocate(int fd, int mode, __LONG_LONG_PAIR(u32 offset_hi, u32 offset_lo),
+				__LONG_LONG_PAIR(u32 len_hi, u32 len_lo))
+{
+	return sys_fallocate(fd, mode, ((loff_t)offset_hi << 32) | offset_lo,
+			     ((loff_t)len_hi << 32) | len_lo);
+}
+
+asmlinkage long ilp32_fadvise64_64(int fd,
+				   __LONG_LONG_PAIR(unsigned long offhi, unsigned long offlo),
+				   __LONG_LONG_PAIR(unsigned long lenhi, unsigned long lenlo),
+				   int advice)
+{
+	return sys_fadvise64_64(fd,
+				(offhi << 32) | offlo,
+				(lenhi << 32) | lenlo,
+				advice);
+}
+
+asmlinkage int ilp32_truncate64(const char __user *path,
+				__LONG_LONG_PAIR(unsigned long high, unsigned long low))
+{
+	return sys_truncate(path, (high << 32) | low);
+}
+
+asmlinkage int ilp32_ftruncate64(unsigned int fd, __LONG_LONG_PAIR(unsigned long high,
+				 unsigned long low))
+{
+	return sys_ftruncate(fd, (high << 32) | low);
+}
+
+compat_ssize_t ilp32_pread64(unsigned int fd, char __user *ubuf, compat_size_t count,
+			     u32 reg6, __LONG_LONG_PAIR(u32 poshi, u32 poslo))
+{
+	return sys_pread64(fd, ubuf, count, ((loff_t)poshi << 32) | poslo);
+}
+
+compat_ssize_t ilp32_pwrite64(unsigned int fd, const char __user *ubuf, compat_size_t count,
+			      u32 reg6, __LONG_LONG_PAIR(u32 poshi, u32 poslo))
+{
+	return sys_pwrite64(fd, ubuf, count, ((loff_t)poshi << 32) | poslo);
+}
+
+asmlinkage long ilp32_sync_file_range(int fd,
+				   __LONG_LONG_PAIR(unsigned offset_hi, unsigned offset_lo),
+				   __LONG_LONG_PAIR(unsigned nbytes_hi, unsigned nbytes_lo),
+				   unsigned int flags)
+{
+	loff_t offset = ((loff_t)offset_hi << 32) | offset_lo;
+	loff_t nbytes = ((loff_t)nbytes_hi << 32) | nbytes_lo;
+
+	return sys_sync_file_range(fd, offset, nbytes, flags);
+}
+
+compat_ssize_t ilp32_readahead(int fd, u32 r4, __LONG_LONG_PAIR(u32 offhi, u32 offlo), u32 count)
+{
+	return sys_readahead(fd, ((loff_t)offhi << 32) | offlo, count);
+}
+
+/*
+ * This is a virtual copy of sys_select from fs/select.c and probably
+ * should be compared to it from time to time
+ */
+
+extern int compat_core_sys_select(int n, compat_ulong_t __user *inp,
+				  compat_ulong_t __user *outp, compat_ulong_t __user *exp,
+				  struct timespec *end_time);
+
+extern int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
+				      int timeval, int ret);
+
+static long do_compat_pselect(int n, compat_ulong_t __user *inp,
+	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
+	struct timespec __user *tsp, sigset_t __user *sigmask,
+	compat_size_t sigsetsize)
+{
+	sigset_t ksigmask, sigsaved;
+	struct timespec ts, end_time, *to = NULL;
+	int ret;
+
+	if (tsp) {
+		if (copy_from_user(&ts, tsp, sizeof(ts)))
+			return -EFAULT;
+
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
+	}
+
+	if (sigmask) {
+		if (sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+			return -EFAULT;
+
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL)|sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
+
+	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
+
+	if (ret == -ERESTARTNOHAND) {
+		/*
+		 * Don't restore the signal mask yet. Let do_signal() deliver
+		 * the signal on the way back to userspace, before the signal
+		 * mask is restored.
+		 */
+		if (sigmask) {
+			memcpy(&current->saved_sigmask, &sigsaved,
+					sizeof(sigsaved));
+			set_restore_sigmask();
+		}
+	} else if (sigmask)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
+	return ret;
+}
+
+asmlinkage long ilp32_sys_pselect6(int n, compat_ulong_t __user *inp,
+	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
+	struct timespec __user *tsp, void __user *sig)
+{
+	compat_size_t sigsetsize = 0;
+	compat_uptr_t up = 0;
+
+	if (sig) {
+		if (!access_ok(VERIFY_READ, sig,
+				sizeof(compat_uptr_t)+sizeof(compat_size_t)) ||
+			__get_user(up, (compat_uptr_t __user *)sig) ||
+			__get_user(sigsetsize,
+				(compat_size_t __user *)(sig+sizeof(up))))
+			return -EFAULT;
+	}
+	return do_compat_pselect(n, inp, outp, exp, tsp, compat_ptr(up),
+				 sigsetsize);
+}
+
+
+#undef __SYSCALL
+#define __SYSCALL(nr, sym)	[nr] = sym,
+
+/*
+ * The sys_call_table array must be 4K aligned to be accessible from
+ * kernel/entry.S.
+ */
+void *sys_ilp32_call_table[__NR_syscalls] __aligned(4096) = {
+	[0 ... __NR_syscalls - 1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index b5605ac..a7b1c8d 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -40,6 +40,12 @@ extern char vdso_start, vdso_end;
 static unsigned long vdso_pages;
 static struct page **vdso_pagelist;
 
+#ifdef CONFIG_ARM64_ILP32
+extern char vdsoilp32_start, vdsoilp32_end;
+static unsigned long vdsoilp32_pages;
+static struct page **vdsoilp32_pagelist;
+#endif
+
 /*
  * The vDSO data page.
  */
@@ -87,6 +93,11 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr = AARCH32_VECTORS_BASE;
 	int ret;
 
+#ifdef CONFIG_ARM64_ILP32
+	if (is_ilp32_task())
+		return arch_setup_additional_pages(bprm, uses_interp);
+#endif
+
 	down_write(&mm->mmap_sem);
 	current->mm->context.vdso = (void *)addr;
 
@@ -101,6 +112,59 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
 }
 #endif /* CONFIG_ARM64_AARCH32 */
 
+#ifdef CONFIG_ARM64_ILP32
+static int  __init vdso_init_ilp32(void)
+{
+	struct page *pg;
+	char *vbase;
+	int i, ret = 0;
+
+	vdsoilp32_pages = (&vdsoilp32_end - &vdsoilp32_start) >> PAGE_SHIFT;
+	pr_info("vdsoilp32: %ld pages (%ld code, %ld data) at base %p\n",
+		vdsoilp32_pages + 1, vdsoilp32_pages, 1L, &vdsoilp32_start);
+
+	/* Allocate the vDSO pagelist, plus a page for the data. */
+	vdsoilp32_pagelist = kzalloc(sizeof(struct page *) * (vdsoilp32_pages + 1),
+				GFP_KERNEL);
+	if (vdsoilp32_pagelist == NULL) {
+		pr_err("Failed to allocate vDSO_ilp32 pagelist!\n");
+		return -ENOMEM;
+	}
+
+	/* Grab the vDSO code pages. */
+	for (i = 0; i < vdsoilp32_pages; i++) {
+		pg = virt_to_page(&vdsoilp32_start + i*PAGE_SIZE);
+		ClearPageReserved(pg);
+		get_page(pg);
+		vdsoilp32_pagelist[i] = pg;
+	}
+
+	/* Sanity check the shared object header. */
+	vbase = vmap(vdsoilp32_pagelist, 1, 0, PAGE_KERNEL);
+	if (vbase == NULL) {
+		pr_err("Failed to map vDSO pagelist!\n");
+		return -ENOMEM;
+	} else if (memcmp(vbase, "\177ELF", 4)) {
+		pr_err("vDSO is not a valid ELF object!\n");
+		ret = -EINVAL;
+		goto unmap;
+	}
+
+	/* Grab the vDSO data page. */
+	pg = virt_to_page(vdso_data);
+	get_page(pg);
+	vdsoilp32_pagelist[i] = pg;
+
+unmap:
+	vunmap(vbase);
+	return ret;
+
+}
+
+arch_initcall(vdso_init_ilp32);
+
+#endif /* CONFIG_ARM64_ILP32 */
+
 static int __init vdso_init(void)
 {
 	struct page *pg;
@@ -155,9 +219,17 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	struct mm_struct *mm = current->mm;
 	unsigned long vdso_base, vdso_mapping_len;
 	int ret;
+	unsigned long pages;
+	struct page **pagelist;
 
 	/* Be sure to map the data page */
-	vdso_mapping_len = (vdso_pages + 1) << PAGE_SHIFT;
+	pages = vdso_pages;
+#ifdef CONFIG_ARM64_ILP32
+	if (is_ilp32_task())
+		pages = vdsoilp32_pages;
+#endif
+	vdso_mapping_len = (pages + 1) << PAGE_SHIFT;
+
 
 	down_write(&mm->mmap_sem);
 	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
@@ -167,10 +239,15 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	}
 	mm->context.vdso = (void *)vdso_base;
 
+	pagelist = vdso_pagelist;
+#ifdef CONFIG_ARM64_ILP32
+	if (is_ilp32_task())
+		pagelist = vdsoilp32_pagelist;
+#endif
 	ret = install_special_mapping(mm, vdso_base, vdso_mapping_len,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-				      vdso_pagelist);
+				      pagelist);
 	if (ret) {
 		mm->context.vdso = NULL;
 		goto up_fail;
diff --git a/arch/arm64/kernel/vdsoilp32/.gitignore b/arch/arm64/kernel/vdsoilp32/.gitignore
new file mode 100644
index 0000000..618c4dd
--- /dev/null
+++ b/arch/arm64/kernel/vdsoilp32/.gitignore
@@ -0,0 +1,2 @@
+vdso_ilp32.lds
+vdso-ilp32-offsets.h
diff --git a/arch/arm64/kernel/vdsoilp32/Makefile b/arch/arm64/kernel/vdsoilp32/Makefile
new file mode 100644
index 0000000..ec93f3f
--- /dev/null
+++ b/arch/arm64/kernel/vdsoilp32/Makefile
@@ -0,0 +1,72 @@
+#
+# Building a vDSO image for AArch64.
+#
+# Author: Will Deacon <will.deacon@arm.com>
+# Heavily based on the vDSO Makefiles for other archs.
+#
+
+obj-vdso_ilp32 := gettimeofday_ilp32.o note_ilp32.o sigreturn_ilp32.o
+
+# Build rules
+targets := $(obj-vdso_ilp32) vdso_ilp32.so vdso_ilp32.so.dbg
+obj-vdso_ilp32 := $(addprefix $(obj)/, $(obj-vdso_ilp32))
+
+ccflags-y := -shared -fno-common -fno-builtin
+ccflags-y += -nostdlib -Wl,-soname=linux-vdso.so.1 \
+		$(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+
+obj-y += vdsoilp32.o
+extra-y += vdso_ilp32.lds vdso-ilp32-offsets.h
+CPPFLAGS_vdso_ilp32.lds += -P -C -U$(ARCH) -mabi=ilp32
+CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+
+
+# Force dependency (incbin is bad)
+$(obj)/vdsoilp32.o : $(obj)/vdso_ilp32.so
+
+# Link rule for the .so file, .lds has to be first
+$(obj)/vdso_ilp32.so.dbg: $(src)/vdso_ilp32.lds $(obj-vdso_ilp32)
+	$(call if_changed,vdsoilp32ld)
+
+# Strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+# Generate VDSO offsets using helper script
+gen-vdsosym := $(srctree)/$(src)/../vdso/gen_vdso_offsets.sh
+quiet_cmd_vdsosym = VDSOSYM $@
+define cmd_vdsosym
+	$(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@ && \
+	cp $@ include/generated/
+endef
+
+$(obj)/vdso-ilp32-offsets.h: $(obj)/vdso_ilp32.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
+# Assembly rules for the .S files
+$(obj)/gettimeofday_ilp32.o: $(src)/../vdso/gettimeofday.S
+	$(call if_changed_dep,vdsoilp32as)
+
+$(obj)/note_ilp32.o: $(src)/../vdso/note.S
+	$(call if_changed_dep,vdsoilp32as)
+
+$(obj)/sigreturn_ilp32.o: $(src)/../vdso/sigreturn.S
+	$(call if_changed_dep,vdsoilp32as)
+
+# Actual build commands
+quiet_cmd_vdsoilp32ld = VDSOILP32L $@
+      cmd_vdsoilp32ld = $(CC) $(c_flags) -mabi=ilp32 -Wl,-T $^ -o $@
+quiet_cmd_vdsoilp32as = VDSOILP32A $@
+      cmd_vdsoilp32as = $(CC) $(a_flags) -mabi=ilp32 -c -o $@ $<
+
+
+# Install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso_ilp32.so: $(obj)/vdso_ilp32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso_ilp32.so
diff --git a/arch/arm64/kernel/vdsoilp32/vdso_ilp32.lds.S b/arch/arm64/kernel/vdsoilp32/vdso_ilp32.lds.S
new file mode 100644
index 0000000..a9eb665
--- /dev/null
+++ b/arch/arm64/kernel/vdsoilp32/vdso_ilp32.lds.S
@@ -0,0 +1,100 @@
+/*
+ * GNU linker script for the VDSO library.
+*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ * Heavily based on the vDSO linker scripts for other archs.
+ */
+
+#include <linux/const.h>
+#include <asm/page.h>
+#include <asm/vdso.h>
+
+/*OUTPUT_FORMAT("elf32-littleaarch64", "elf32-bigaarch64", "elf32-littleaarch64")
+OUTPUT_ARCH(aarch64)
+*/
+SECTIONS
+{
+	. = VDSO_LBASE + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	. = ALIGN(16);
+
+	.text		: { *(.text*) }			:text	=0xd503201f
+	PROVIDE (__etext = .);
+	PROVIDE (_etext = .);
+	PROVIDE (etext = .);
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+
+	_end = .;
+	PROVIDE(end = .);
+
+	. = ALIGN(PAGE_SIZE);
+	PROVIDE(_vdso_data = .);
+
+	/DISCARD/	: {
+		*(.note.GNU-stack)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
+}
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
+
+/*
+ * This controls what symbols we export from the DSO.
+ */
+VERSION
+{
+	LINUX_2.6.39 {
+	global:
+		__kernel_rt_sigreturn;
+		__kernel_gettimeofday;
+		__kernel_clock_gettime;
+		__kernel_clock_getres;
+	local: *;
+	};
+}
+
+/*
+ * Make the sigreturn code visible to the kernel.
+ */
+VDSO_sigtramp_ilp32		= __kernel_rt_sigreturn;
diff --git a/arch/arm64/kernel/vdsoilp32/vdsoilp32.S b/arch/arm64/kernel/vdsoilp32/vdsoilp32.S
new file mode 100644
index 0000000..68329fa
--- /dev/null
+++ b/arch/arm64/kernel/vdsoilp32/vdsoilp32.S
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.globl vdsoilp32_start, vdsoilp32_end
+	.balign PAGE_SIZE
+vdsoilp32_start:
+	.incbin "arch/arm64/kernel/vdsoilp32/vdso_ilp32.so"
+	.balign PAGE_SIZE
+vdsoilp32_end:
+
+	.previous
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 67e8d7c..17b9c39 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -35,6 +35,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/sizes.h>
+#include <asm/compat.h>
 #include <asm/tlb.h>
 
 #include "mm.h"
-- 
1.7.2.5

