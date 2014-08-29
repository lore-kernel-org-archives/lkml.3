Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaH2STz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbaH2STy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:19:54 -0400
Date: Fri, 29 Aug 2014 20:17:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] x86, fpu: irq_fpu_usable: kill all checks except
	!in_kernel_fpu
Message-ID: <20140829181729.GE30659@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com> <20140828111628.GB15276@redhat.com> <20140829181533.GA30659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829181533.GA30659@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ONCE AGAIN, THIS IS MORE THE QUESTION THAN THE PATCH.

interrupted_kernel_fpu_idle() does:

	if (use_eager_fpu())
		return true;

	return !__thread_has_fpu(current) &&
		(read_cr0() & X86_CR0_TS);

and it is absolutely not clear why these 2 cases differ so much.

To remind, the use_eager_fpu() case is buggy; __save_init_fpu() in
__kernel_fpu_begin() can race with math_state_restore() which does
__thread_fpu_begin() + restore_fpu_checking(). So we should fix this
race anyway and we can't require __thread_has_fpu() == F likes the
!use_eager_fpu() case does, in this case kernel_fpu_begin() will not
work if it interrupts the idle thread (this will reintroduce the
performance regression fixed by 5187b28f).

Probably math_state_restore() can use kernel_fpu_disable/end() which
sets/clears in_kernel_fpu, or it can disable irqs. Doesn't matter, we
should fix this bug anyway.

And if we fix this bug, why else !use_eager_fpu() case needs the much
more strict check? Why we can't handle the __thread_has_fpu(current)
case the same way?

The comment deleted by this change says:

	and TS must be set so that the clts/stts pair does nothing

and can explain the difference, but I can not understand this (again,
assuming that we fix the race(s) mentoined above).

Say, user_fpu_begin(). Yes, kernel_fpu_begin/end() can restore X86_CR0_TS.
But this should be fine? A context switch before restore_user_xstate()
can equally set it back? And device_not_available() should be fine even
in kernel context?

I'll appreciate any comment.
---
 arch/x86/kernel/i387.c |   44 +-------------------------------------------
 1 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 9fb2899..ef60f33 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -22,54 +22,12 @@
 static DEFINE_PER_CPU(bool, in_kernel_fpu);
 
 /*
- * Were we in an interrupt that interrupted kernel mode?
- *
- * On others, we can do a kernel_fpu_begin/end() pair *ONLY* if that
- * pair does nothing at all: the thread must not have fpu (so
- * that we don't try to save the FPU state), and TS must
- * be set (so that the clts/stts pair does nothing that is
- * visible in the interrupted kernel thread).
- *
- * Except for the eagerfpu case when we return 1.
- */
-static inline bool interrupted_kernel_fpu_idle(void)
-{
-	if (this_cpu_read(in_kernel_fpu))
-		return false;
-
-	if (use_eager_fpu())
-		return true;
-
-	return !__thread_has_fpu(current) &&
-		(read_cr0() & X86_CR0_TS);
-}
-
-/*
- * Were we in user mode (or vm86 mode) when we were
- * interrupted?
- *
- * Doing kernel_fpu_begin/end() is ok if we are running
- * in an interrupt context from user mode - we'll just
- * save the FPU state as required.
- */
-static inline bool interrupted_user_mode(void)
-{
-	struct pt_regs *regs = get_irq_regs();
-	return regs && user_mode_vm(regs);
-}
-
-/*
  * Can we use the FPU in kernel mode with the
  * whole "kernel_fpu_begin/end()" sequence?
- *
- * It's always ok in process context (ie "not interrupt")
- * but it is sometimes ok even from an irq.
  */
 bool irq_fpu_usable(void)
 {
-	return !in_interrupt() ||
-		interrupted_user_mode() ||
-		interrupted_kernel_fpu_idle();
+	return !this_cpu_read(in_kernel_fpu);
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
-- 
1.5.5.1


