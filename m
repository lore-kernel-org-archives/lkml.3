Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3JJIzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:55:16 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39674 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3JJIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:55:12 -0400
Date: Thu, 10 Oct 2013 10:55:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: [PATCH, -v2] compiler/gcc4: Add quirk for 'asm goto' miscompilation
 bug
Message-ID: <20131010085506.GA11775@gmail.com>
References: <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <20131010084535.GA10620@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010084535.GA10620@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Jakub Jelinek <jakub@redhat.com> wrote:
> 
> > On Thu, Oct 10, 2013 at 10:24:30AM +0200, Ingo Molnar wrote:
> > > Something like the patch below? (Totally untested and all that.)
> > > 
> > > Notes:
> > > 
> > > - If the bug is fixed in 4.8.3 then the version check can be sharpened
> > >   from 99999 to 40803.
> > 
> > The bug is likely going to be fixed already for 4.8.2 (to be released
> > next week or so).
> > 
> > > - I'd really prefer this quirk versus having to add the extra barrier to 
> > >   the label, as it makes the actual usage sites a lot less painful.
> > 
> > Please check how much it bloats the generated code.
> 
> on Linus's latest tree plain 'asm goto' is only rarely used, so the size 
> impact of the patch, on x86-64 defconfig, is zero:
> 
>  vmlinux:
>      text           data     bss      dec            hex filename
>  11166823        1448024 1187840 13802687         d29cbf vmlinux.before
>  11166823        1448024 1187840 13802687         d29cbf vmlinux.after
>  1f7c3c1fd71b4b1327965bcfbc7a77fb  vmlinux.before
>  3b246add801bc170e47096b712942395  vmlinux.after
> 
> Using GCC 4.8.1.
> 
> > Also, for the bitops patch, you probably want an asm_volatile_goto variant.
> 
> Also, for mutex_64.h - good point, will fix that.

See the updated patch below. I've added a 4.8.2 version cutoff.

Thanks,

	Ingo

===================>
Subject: compiler/gcc4: Add quirk for 'asm goto' miscompilation bug
From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 10 Oct 2013 10:16:30 +0200

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
 arch/arm/include/asm/jump_label.h     |    2 +-
 arch/mips/include/asm/jump_label.h    |    2 +-
 arch/powerpc/include/asm/jump_label.h |    2 +-
 arch/s390/include/asm/jump_label.h    |    2 +-
 arch/sparc/include/asm/jump_label.h   |    2 +-
 arch/x86/include/asm/cpufeature.h     |    6 +++---
 arch/x86/include/asm/jump_label.h     |    2 +-
 arch/x86/include/asm/mutex_64.h       |    4 ++--
 include/linux/compiler-gcc4.h         |   16 ++++++++++++++++
 9 files changed, 27 insertions(+), 11 deletions(-)

Index: tip/arch/arm/include/asm/jump_label.h
===================================================================
--- tip.orig/arch/arm/include/asm/jump_label.h
+++ tip/arch/arm/include/asm/jump_label.h
@@ -16,7 +16,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".word 1b, %l[l_yes], %c0\n\t"
Index: tip/arch/mips/include/asm/jump_label.h
===================================================================
--- tip.orig/arch/mips/include/asm/jump_label.h
+++ tip/arch/mips/include/asm/jump_label.h
@@ -22,7 +22,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\tnop\n\t"
+	asm_goto("1:\tnop\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
Index: tip/arch/powerpc/include/asm/jump_label.h
===================================================================
--- tip.orig/arch/powerpc/include/asm/jump_label.h
+++ tip/arch/powerpc/include/asm/jump_label.h
@@ -19,7 +19,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
Index: tip/arch/s390/include/asm/jump_label.h
===================================================================
--- tip.orig/arch/s390/include/asm/jump_label.h
+++ tip/arch/s390/include/asm/jump_label.h
@@ -15,7 +15,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("0:	brcl 0,0\n"
+	asm_goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
Index: tip/arch/sparc/include/asm/jump_label.h
===================================================================
--- tip.orig/arch/sparc/include/asm/jump_label.h
+++ tip/arch/sparc/include/asm/jump_label.h
@@ -9,7 +9,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-		asm goto("1:\n\t"
+		asm_goto("1:\n\t"
 			 "nop\n\t"
 			 "nop\n\t"
 			 ".pushsection __jump_table,  \"aw\"\n\t"
Index: tip/arch/x86/include/asm/cpufeature.h
===================================================================
--- tip.orig/arch/x86/include/asm/cpufeature.h
+++ tip/arch/x86/include/asm/cpufeature.h
@@ -374,7 +374,7 @@ static __always_inline __pure bool __sta
 		 * Catch too early usage of this before alternatives
 		 * have run.
 		 */
-		asm goto("1: jmp %l[t_warn]\n"
+		asm_goto("1: jmp %l[t_warn]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
@@ -388,7 +388,7 @@ static __always_inline __pure bool __sta
 
 #endif
 
-		asm goto("1: jmp %l[t_no]\n"
+		asm_goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
@@ -453,7 +453,7 @@ static __always_inline __pure bool _stat
  * have. Thus, we force the jump to the widest, 4-byte, signed relative
  * offset even though the last would often fit in less bytes.
  */
-		asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
+		asm_goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"		/* src offset */
Index: tip/arch/x86/include/asm/jump_label.h
===================================================================
--- tip.orig/arch/x86/include/asm/jump_label.h
+++ tip/arch/x86/include/asm/jump_label.h
@@ -18,7 +18,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:"
+	asm_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
Index: tip/arch/x86/include/asm/mutex_64.h
===================================================================
--- tip.orig/arch/x86/include/asm/mutex_64.h
+++ tip/arch/x86/include/asm/mutex_64.h
@@ -20,7 +20,7 @@
 static inline void __mutex_fastpath_lock(atomic_t *v,
 					 void (*fail_fn)(atomic_t *))
 {
-	asm volatile goto(LOCK_PREFIX "   decl %0\n"
+	asm_volatile_goto(LOCK_PREFIX "   decl %0\n"
 			  "   jns %l[exit]\n"
 			  : : "m" (v->counter)
 			  : "memory", "cc"
@@ -75,7 +75,7 @@ static inline int __mutex_fastpath_lock_
 static inline void __mutex_fastpath_unlock(atomic_t *v,
 					   void (*fail_fn)(atomic_t *))
 {
-	asm volatile goto(LOCK_PREFIX "   incl %0\n"
+	asm_volatile_goto(LOCK_PREFIX "   incl %0\n"
 			  "   jg %l[exit]\n"
 			  : : "m" (v->counter)
 			  : "memory", "cc"
Index: tip/include/linux/compiler-gcc4.h
===================================================================
--- tip.orig/include/linux/compiler-gcc4.h
+++ tip/include/linux/compiler-gcc4.h
@@ -65,6 +65,22 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via quirk suggested by Jakub Jelinek.
+ * Fixed in GCC 4.8.2 and later versions.
+ */
+#if GCC_VERSION <= 40801
+# define __asm_goto(vol, x...) do { asm vol goto(x); asm (""); } while (0)
+#else
+# define __asm_goto(vol, x...) do { asm vol goto(x); } while (0)
+#endif
+
+#define asm_goto(x...)			__asm_goto(,x)
+#define asm_volatile_goto(x...)		__asm_goto(volatile, x)
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if GCC_VERSION >= 40400
