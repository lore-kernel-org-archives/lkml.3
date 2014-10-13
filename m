Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaJMH71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:59:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48191 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaJMH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:59:24 -0400
Date: Mon, 13 Oct 2014 09:59:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes, leftover from v3.17
Message-ID: <20141013075919.GA16235@gmail.com>
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

   # HEAD: 4ea48a01bb1a99f4185b77cd90cf962730336cc4 x86/build: Add arch/x86/purgatory/ make generated files to gitignore

Misc smaller fixes that missed the v3.17 cycle.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: Fix section conflict for numachip

Andy Lutomirski (1):
      x86_64, entry: Filter RFLAGS.NT on entry from userspace

Ben Hutchings (1):
      x86: Reject x32 executables if x32 ABI not supported

Kees Cook (1):
      x86, boot, kaslr: Fix nuisance warning on 32-bit builds

Shuah Khan (1):
      x86/build: Add arch/x86/purgatory/ make generated files to gitignore


 arch/x86/.gitignore                  |  2 ++
 arch/x86/boot/compressed/aslr.c      |  2 +-
 arch/x86/ia32/ia32entry.S            | 18 +++++++++++++++++-
 arch/x86/include/asm/elf.h           |  5 +++--
 arch/x86/kernel/apic/apic_numachip.c |  2 +-
 arch/x86/kernel/cpu/common.c         |  2 +-
 6 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
index 7cab8c08e6d1..aff152c87cf4 100644
--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,4 +1,6 @@
 boot/compressed/vmlinux
 tools/test_get_len
 tools/insn_sanity
+purgatory/kexec-purgatory.c
+purgatory/purgatory.ro
 
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index d39189ba7f8e..f302dc45ce08 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -195,7 +195,7 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	while (ptr) {
 		struct mem_vector avoid;
 
-		avoid.start = (u64)ptr;
+		avoid.start = (unsigned long)ptr;
 		avoid.size = sizeof(*ptr) + ptr->len;
 
 		if (mem_overlaps(img, &avoid))
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb05023c..711de084ab57 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -151,6 +151,16 @@ ENTRY(ia32_sysenter_target)
 1:	movl	(%rbp),%ebp
 	_ASM_EXTABLE(1b,ia32_badarg)
 	ASM_CLAC
+
+	/*
+	 * Sysenter doesn't filter flags, so we need to clear NT
+	 * ourselves.  To save a few cycles, we can check whether
+	 * NT was set instead of doing an unconditional popfq.
+	 */
+	testl $X86_EFLAGS_NT,EFLAGS(%rsp)	/* saved EFLAGS match cpu */
+	jnz sysenter_fix_flags
+sysenter_flags_fixed:
+
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	CFI_REMEMBER_STATE
@@ -184,6 +194,8 @@ ENTRY(ia32_sysenter_target)
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS_SYSEXIT32
 
+	CFI_RESTORE_STATE
+
 #ifdef CONFIG_AUDITSYSCALL
 	.macro auditsys_entry_common
 	movl %esi,%r9d			/* 6th arg: 4th syscall arg */
@@ -226,7 +238,6 @@ ENTRY(ia32_sysenter_target)
 	.endm
 
 sysenter_auditsys:
-	CFI_RESTORE_STATE
 	auditsys_entry_common
 	movl %ebp,%r9d			/* reload 6th syscall arg */
 	jmp sysenter_dispatch
@@ -235,6 +246,11 @@ ENTRY(ia32_sysenter_target)
 	auditsys_exit sysexit_from_sys_call
 #endif
 
+sysenter_fix_flags:
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
+	popfq_cfi
+	jmp sysenter_flags_fixed
+
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 1a055c81d864..ca3347a9dab5 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -160,8 +160,9 @@ do {						\
 #define elf_check_arch(x)			\
 	((x)->e_machine == EM_X86_64)
 
-#define compat_elf_check_arch(x)		\
-	(elf_check_arch_ia32(x) || (x)->e_machine == EM_X86_64)
+#define compat_elf_check_arch(x)					\
+	(elf_check_arch_ia32(x) ||					\
+	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine == EM_X86_64))
 
 #if __USER32_DS != __USER_DS
 # error "The following code assumes __USER32_DS == __USER_DS"
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index ae915391ebec..4128b5fcb559 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -32,7 +32,7 @@
 
 static int numachip_system __read_mostly;
 
-static const struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip;
 
 static unsigned int get_apic_id(unsigned long x)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..31265580c38a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1184,7 +1184,7 @@ void syscall_init(void)
 	/* Flags to clear on syscall */
 	wrmsrl(MSR_SYSCALL_MASK,
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
-	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
+	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
 }
 
 /*
