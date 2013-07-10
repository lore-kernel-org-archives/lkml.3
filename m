Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3GJQew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:34:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab3GJQev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:34:51 -0400
Date: Wed, 10 Jul 2013 17:34:11 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        "linux-arm@lists.infradead.org" <linux-arm@lists.infradead.org>
Subject: Re: Seg fault occurs when running statically compiled binary from
 kernel using call_usermodehelper
Message-ID: <20130710163410.GA30514@mudshark.cambridge.arm.com>
References: <CAOiN93mGTu9w9rVNCrbbH1sccXY9VJhaCmg+dS7Rk9mMgKHBaA@mail.gmail.com>
 <CAOiN93=Nx77RkbNuEJMV617MjV5+GmorF0G3vyLy1SwQcuCs+g@mail.gmail.com>
 <CAOiN93nH9fyHoz4yrZmJ-OKCy6ogdt5bYartXCBgP5eHMUBPdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiN93nH9fyHoz4yrZmJ-OKCy6ogdt5bYartXCBgP5eHMUBPdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 11:42:25AM +0100, Ashish Sangwan wrote:
> Any heads up on this?
> 
> or could someone just advice what can we do to debug this?
> 
> The ret_from_fork currently looks like following:
> /*
>  * This is how we return from a fork.
>  */
> ENTRY(ret_from_fork)
>         bl      schedule_tail
>         cmp     r5, #0
>         movne   r0, r4
>         adrne   lr, BSYM(1f)
>         movne   pc, r5
> 1:      get_thread_info tsk
>         b       ret_slow_syscall
> ENDPROC(ret_from_fork)
> 
> Is this a real issue? Because we are getting this just for static binaries.

Ok, I've finally got to the bottom of this, but I'm not sure on the best way
to fix it. The issue is that libc expects r0 to contain a function pointer
to be invoked at exit (rtld_fini), to clean up after a dynamic linker. If
this pointer is NULL, then it is ignored. We actually zero this pointer in
our ELF_PLAT_INIT macro.

At the same time, we have this strange code called next from the ARM ELF
loader:

	regs->ARM_r2 = stack[2];	/* r2 (envp) */			\
	regs->ARM_r1 = stack[1];	/* r1 (argv) */			\
	regs->ARM_r0 = stack[0];	/* r0 (argc) */			\

which puts argc into r0. Usually this gets overwritten by the return value
of execve (0), so everything hangs together. With kernel threads this is
different since we do the exec from ____call_usermodehelper on the stack and
then return to the new application via ret_from_fork, which takes the
slowpath; popping r0 from pt_regs and making argc visible to the library.

When the application exits and libc starts running its exit functions, we
jump to hyperspace.

My inclination would be to remove the stack popping above (patch below),
but it's a user-visible change and I'm not sure if something like OABI
requires it.

Will

--->8

diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 06e7d50..413f387 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -54,7 +54,6 @@ struct thread_struct {
 
 #define start_thread(regs,pc,sp)                                       \
 ({                                                                     \
-       unsigned long *stack = (unsigned long *)sp;                     \
        memset(regs->uregs, 0, sizeof(regs->uregs));                    \
        if (current->personality & ADDR_LIMIT_32BIT)                    \
                regs->ARM_cpsr = USR_MODE;                              \
@@ -65,9 +64,6 @@ struct thread_struct {
        regs->ARM_cpsr |= PSR_ENDSTATE;                                 \
        regs->ARM_pc = pc & ~1;         /* pc */                        \
        regs->ARM_sp = sp;              /* sp */                        \
-       regs->ARM_r2 = stack[2];        /* r2 (envp) */                 \
-       regs->ARM_r1 = stack[1];        /* r1 (argv) */                 \
-       regs->ARM_r0 = stack[0];        /* r0 (argc) */                 \
        nommu_start_thread(regs);                                       \
 })
 
