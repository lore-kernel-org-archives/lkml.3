Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3JJIYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:24:43 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49974 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3JJIYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:24:34 -0400
Date: Thu, 10 Oct 2013 10:24:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: [PATCH] gcc4: Add 'asm goto' miscompilation quirk
Message-ID: <20131010082430.GA20577@gmail.com>
References: <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010080457.GC21875@tucnak.zalov.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jakub Jelinek <jakub@redhat.com> wrote:

> On Thu, Oct 10, 2013 at 08:51:04AM +0200, Jakub Jelinek wrote:
> > @@ -8,6 +8,7 @@ foo (int a, int b)
> >    asm volatile goto ("bts $1, %0; jc %l[lab]" : : "m" (b) : "memory" : lab);
> >    return 0;
> >  lab:
> > +  asm ("");
> >    return 0;
> >  }
> 
> Or alternatively put the asm (""); right after asm goto,
>   asm volatile goto ("bts $1, %0; jc %l[lab]" : : "m" (b) : "memory" : lab);
>   asm ("");
>   return ...;
> lab;
>   return ...;
> What generates better code remains to be tested.  In any case, please
> conditionalize the hacks on non-fixed compilers once the fix is released.

Something like the patch below? (Totally untested and all that.)

Notes:

- If the bug is fixed in 4.8.3 then the version check can be sharpened
  from 99999 to 40803.

- I'd really prefer this quirk versus having to add the extra barrier to 
  the label, as it makes the actual usage sites a lot less painful.

Thanks,

	Ingo

=======================>
>From 76372b417b900f8c13f42af6dae67751add339dd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 10 Oct 2013 10:16:30 +0200
Subject: [PATCH] gcc4: Add 'asm goto' miscompilation quirk

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
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/include/asm/jump_label.h     |  2 +-
 arch/mips/include/asm/jump_label.h    |  2 +-
 arch/powerpc/include/asm/jump_label.h |  2 +-
 arch/s390/include/asm/jump_label.h    |  2 +-
 arch/sparc/include/asm/jump_label.h   |  2 +-
 arch/x86/include/asm/cpufeature.h     |  6 +++---
 arch/x86/include/asm/jump_label.h     |  2 +-
 include/linux/compiler-gcc4.h         | 13 +++++++++++++
 8 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index bfc198c..1ab0cf6 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -16,7 +16,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".word 1b, %l[l_yes], %c0\n\t"
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 4d6d77e..c0f8f5d 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -22,7 +22,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\tnop\n\t"
+	asm_goto("1:\tnop\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index ae098c4..2b843a2 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -19,7 +19,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 6c32190..323422e 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -15,7 +15,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("0:	brcl 0,0\n"
+	asm_goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 5080d16..e466c37 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -9,7 +9,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-		asm goto("1:\n\t"
+		asm_goto("1:\n\t"
 			 "nop\n\t"
 			 "nop\n\t"
 			 ".pushsection __jump_table,  \"aw\"\n\t"
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index d3f5c63..acba4ad 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -374,7 +374,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		 * Catch too early usage of this before alternatives
 		 * have run.
 		 */
-		asm goto("1: jmp %l[t_warn]\n"
+		asm_goto("1: jmp %l[t_warn]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
@@ -388,7 +388,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 
 #endif
 
-		asm goto("1: jmp %l[t_no]\n"
+		asm_goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
@@ -453,7 +453,7 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
  * have. Thus, we force the jump to the widest, 4-byte, signed relative
  * offset even though the last would often fit in less bytes.
  */
-		asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
+		asm_goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"		/* src offset */
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 64507f3..65e951e 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -18,7 +18,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:"
+	asm_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 842de22..b2ae613 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -65,6 +65,19 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via quirk suggested by Jakub Jelinek.
+ * Not yet fixed, so use the quirk on all compiler versions:
+ */
+#if GCC_VERSION <= 99999
+# define asm_goto(x...) do { asm goto(x); asm (""); } while (0)
+#else
+# define asm_goto(x...) do { asm goto(x); } while (0)
+#endif
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if GCC_VERSION >= 40400
