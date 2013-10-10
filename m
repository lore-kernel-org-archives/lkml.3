Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3JJPMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:12:25 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52821 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3JJPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:12:23 -0400
Date: Thu, 10 Oct 2013 17:12:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto' miscompilation
 bug
Message-ID: <20131010151219.GC5167@gmail.com>
References: <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010142703.GI30970@tucnak.zalov.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jakub Jelinek <jakub@redhat.com> wrote:

> On Thu, Oct 10, 2013 at 07:04:18AM -0700, Richard Henderson wrote:
> > On 10/10/2013 01:31 AM, Jakub Jelinek wrote:
> > > Also, for the bitops patch, you probably want an asm_volatile_goto variant.
> > 
> > Why?  Asm without output (which asm goto must be) are automatically volatile.
> 
> You're right.

Indeed. Something like the updated version below?

[ I kept the asm_volatile_goto() naming to make sure the implicit volatile 
  is visible. ]

Thanks,

	Ingo

--------------------->
>From 1ab592e8d55576880b90c131529111f51c188284 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 10 Oct 2013 10:16:30 +0200
Subject: [PATCH] compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Fengguang Wu, Oleg Nesterov and Peter Zijlstra tracked down
a kernel crash to a GCC bug: GCC miscompiles certain 'asm goto'
constructs, as outlined here:

  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670

Implement a workaround suggested by Jakub Jelinek.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Suggested-by: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/include/asm/jump_label.h     |  2 +-
 arch/mips/include/asm/jump_label.h    |  2 +-
 arch/powerpc/include/asm/jump_label.h |  2 +-
 arch/s390/include/asm/jump_label.h    |  2 +-
 arch/sparc/include/asm/jump_label.h   |  2 +-
 arch/x86/include/asm/cpufeature.h     |  6 +++---
 arch/x86/include/asm/jump_label.h     |  2 +-
 arch/x86/include/asm/mutex_64.h       |  4 ++--
 arch/x86/include/asm/rmwcc.h          |  2 +-
 include/linux/compiler-gcc4.h         | 15 +++++++++++++++
 10 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index bfc198c..863c892 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -16,7 +16,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_volatile_goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".word 1b, %l[l_yes], %c0\n\t"
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 4d6d77e..e194f95 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -22,7 +22,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\tnop\n\t"
+	asm_volatile_goto("1:\tnop\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index ae098c4..f016bb6 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -19,7 +19,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 6c32190..346b1c8 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -15,7 +15,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("0:	brcl 0,0\n"
+	asm_volatile_goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 5080d16..ec2e2e2 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -9,7 +9,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-		asm goto("1:\n\t"
+		asm_volatile_goto("1:\n\t"
 			 "nop\n\t"
 			 "nop\n\t"
 			 ".pushsection __jump_table,  \"aw\"\n\t"
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index d3f5c63..89270b4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -374,7 +374,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		 * Catch too early usage of this before alternatives
 		 * have run.
 		 */
-		asm goto("1: jmp %l[t_warn]\n"
+		asm_volatile_goto("1: jmp %l[t_warn]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
@@ -388,7 +388,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 
 #endif
 
-		asm goto("1: jmp %l[t_no]\n"
+		asm_volatile_goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
@@ -453,7 +453,7 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
  * have. Thus, we force the jump to the widest, 4-byte, signed relative
  * offset even though the last would often fit in less bytes.
  */
-		asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
+		asm_volatile_goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"		/* src offset */
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 64507f3..6a2cefb 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -18,7 +18,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:"
+	asm_volatile_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
diff --git a/arch/x86/include/asm/mutex_64.h b/arch/x86/include/asm/mutex_64.h
index e7e6751..07537a4 100644
--- a/arch/x86/include/asm/mutex_64.h
+++ b/arch/x86/include/asm/mutex_64.h
@@ -20,7 +20,7 @@
 static inline void __mutex_fastpath_lock(atomic_t *v,
 					 void (*fail_fn)(atomic_t *))
 {
-	asm volatile goto(LOCK_PREFIX "   decl %0\n"
+	asm_volatile_goto(LOCK_PREFIX "   decl %0\n"
 			  "   jns %l[exit]\n"
 			  : : "m" (v->counter)
 			  : "memory", "cc"
@@ -75,7 +75,7 @@ static inline int __mutex_fastpath_lock_retval(atomic_t *count)
 static inline void __mutex_fastpath_unlock(atomic_t *v,
 					   void (*fail_fn)(atomic_t *))
 {
-	asm volatile goto(LOCK_PREFIX "   incl %0\n"
+	asm_volatile_goto(LOCK_PREFIX "   incl %0\n"
 			  "   jg %l[exit]\n"
 			  : : "m" (v->counter)
 			  : "memory", "cc"
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 735f184..1ff990f 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -5,7 +5,7 @@
 
 #define __GEN_RMWcc(fullop, var, cc, ...)				\
 do {									\
-	asm volatile goto (fullop "; j" cc " %l[cc_label]"		\
+	asm_volatile_goto (fullop "; j" cc " %l[cc_label]"		\
 			: : "m" (var), ## __VA_ARGS__ 			\
 			: "memory" : cc_label);				\
 	return 0;							\
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 842de22..ded4299 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -65,6 +65,21 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
+ * Fixed in GCC 4.8.2 and later versions.
+ *
+ * (asm goto is automatically volatile - the naming reflects this.)
+ */
+#if GCC_VERSION <= 40801
+# define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
+#else
+# define asm_volatile_goto(x...)	do { asm goto(x); } while (0)
+#endif
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if GCC_VERSION >= 40400
