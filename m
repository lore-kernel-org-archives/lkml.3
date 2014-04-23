Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaDWKhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:37:14 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52391 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaDWKhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:37:09 -0400
Message-ID: <1398249425.5910.14.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Wed, 23 Apr 2014 12:37:05 +0200
In-Reply-To: <20140411185739.GA6644@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 20:57 +0200, Sebastian Andrzej Siewior wrote:

> This -RT series didn't crashed within ~4h testing on my ARM and
> x86-32.
> x86-64 crashed after I started hackbench. I figured out that the crash
> does not happen with lazy-preempt disabled. Therefore the last but one
> patch in the queue disables lazy preempt on x86-64. With this change the
> test box survived ~2h without a crash. I look at this later but it looks
> good now.

I think the below fixes it (in a more or less minimalist way), but it's
not very pretty.  Methinks it would be prettier to either clone the x86
percpu + fold logic, or neutralize that optimization completely when
PREEMPT_LAZY is enabled.

x86_32 bit is completely untested, x86_64 hasn't exploded.. yet :) 

---
 include/linux/preempt.h        |    3 +--
 arch/x86/include/asm/preempt.h |    8 ++++++++
 arch/x86/kernel/asm-offsets.c  |    1 +
 arch/x86/kernel/entry_32.S     |    9 ++++++---
 arch/x86/kernel/entry_64.S     |    7 +++++--
 5 files changed, 21 insertions(+), 7 deletions(-)

--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -126,8 +126,7 @@ do { \
 #define preempt_enable_notrace() \
 do { \
 	barrier(); \
-	if (unlikely(__preempt_count_dec_and_test() || \
-				test_thread_flag(TIF_NEED_RESCHED_LAZY))) \
+	if (unlikely(__preempt_count_dec_and_test())) \
 		__preempt_schedule_context(); \
 } while (0)
 #else
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -94,7 +94,11 @@ static __always_inline bool __preempt_co
 {
 	if (____preempt_count_dec_and_test())
 		return true;
+#ifdef CONFIG_PREEMPT_LAZY
 	return test_thread_flag(TIF_NEED_RESCHED_LAZY);
+#else
+	return false;
+#endif
 }
 
 /*
@@ -102,8 +106,12 @@ static __always_inline bool __preempt_co
  */
 static __always_inline bool should_resched(void)
 {
+#ifdef CONFIG_PREEMPT_LAZY
 	return unlikely(!__this_cpu_read_4(__preempt_count) || \
 			test_thread_flag(TIF_NEED_RESCHED_LAZY));
+#else
+	return unlikely(!__this_cpu_read_4(__preempt_count));
+#endif
 }
 
 #ifdef CONFIG_PREEMPT
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -72,4 +72,5 @@ void common(void) {
 
 	BLANK();
 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
+	DEFINE(_PREEMPT_ENABLED, PREEMPT_ENABLED);
 }
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -365,19 +365,22 @@ ENTRY(resume_kernel)
 need_resched:
 	# preempt count == 0 + NEED_RS set?
 	cmpl $0,PER_CPU_VAR(__preempt_count)
+#ifndef CONFIG_PREEMPT_LAZY
+	jnz restore_all
+#else
 	jz test_int_off
 
 	# atleast preempt count == 0 ?
-	cmpl $_TIF_NEED_RESCHED,PER_CPU_VAR(__preempt_count)
+	cmpl $_PREEMPT_ENABLED,PER_CPU_VAR(__preempt_count)
 	jne restore_all
 
 	cmpl $0,TI_preempt_lazy_count(%ebp)	# non-zero preempt_lazy_count ?
 	jnz restore_all
 
-	testl $_TIF_NEED_RESCHED_LAZY, %ecx
+	testl $_TIF_NEED_RESCHED_LAZY, TI_flags(%ebp)
 	jz restore_all
-
 test_int_off:
+#endif
 	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
 	jz restore_all
 	call preempt_schedule_irq
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1104,10 +1104,13 @@ ENTRY(native_iret)
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
 	cmpl $0,PER_CPU_VAR(__preempt_count)
+#ifndef CONFIG_PREEMPT_LAZY
+	jnz  retint_restore_args
+#else
 	jz  check_int_off
 
 	# atleast preempt count == 0 ?
-	cmpl $_TIF_NEED_RESCHED,PER_CPU_VAR(__preempt_count)
+	cmpl $_PREEMPT_ENABLED,PER_CPU_VAR(__preempt_count)
 	jnz retint_restore_args
 
 	cmpl $0, TI_preempt_lazy_count(%rcx)
@@ -1115,8 +1118,8 @@ ENTRY(retint_kernel)
 
 	bt $TIF_NEED_RESCHED_LAZY,TI_flags(%rcx)
 	jnc  retint_restore_args
-
 check_int_off:
+#endif
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
 	call preempt_schedule_irq


