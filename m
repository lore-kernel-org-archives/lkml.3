Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3DQAHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:07:01 -0400
Received: from ozlabs.org ([203.10.76.45]:41228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3DQAG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:06:59 -0400
From: Michael Neuling <mikey@neuling.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kill ptrace_{get,put}_breakpoints()
In-reply-to: <20130416134913.GC9189@redhat.com>
References: <20130414160501.GA7612@redhat.com> <3883.1366096958@ale.ozlabs.ibm.com> <20130416134913.GC9189@redhat.com>
Comments: In-reply-to Oleg Nesterov <oleg@redhat.com>
   message dated "Tue, 16 Apr 2013 15:49:13 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 17 Apr 2013 10:06:57 +1000
Message-ID: <23596.1366157217@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/16, Michael Neuling wrote:
> >
> > > Benjamin, Paul, arch_dup_task_struct()->flush_ptrace_hw_breakpoint(src)
> > > on powerpc looks "obviously wrong". Don't we need
> > >
> > > 	- flush_ptrace_hw_breakpoint(src);
> > > 	+ dst->thread->ptrace_bps[0] = NULL;
> >
> > Do you mean the following?
> >
> >
> > diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> > index 59dd545..559804e 100644
> > --- a/arch/powerpc/kernel/process.c
> > +++ b/arch/powerpc/kernel/process.c
> > @@ -911,7 +911,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct tas
> >         flush_vsx_to_thread(src);
> >         flush_spe_to_thread(src);
> >  #ifdef CONFIG_HAVE_HW_BREAKPOINT
> > -       flush_ptrace_hw_breakpoint(src);
> > +       dst->thread.ptrace_bps[0] = NULL;
> >  #endif /* CONFIG_HAVE_HW_BREAKPOINT */
> 
> Almost.
> 
> This is what I think we should do, but it is pointless to do this
> in arch_dup_task_struct(), setup_thread_stack() will copy ptrace_bps[]
> from parent later.
> 
> > Unable to handle kernel paging request for data at address 0x00100108
> > Faulting instruction address: 0xc00000000014d5e4
> > cpu 0x0: Vector: 300 (Data Access) at [c00000007e5836a0]
> >     pc: c00000000014d5e4: .toggle_bp_slot+0x74/0x1c0
> >     lr: c00000000014dc14: .release_bp_slot+0x44/0x70
> >     sp: c00000007e583920
> >    msr: 9000000000009032
> >    dar: 100108
> >  dsisr: 42000000
> >   current = 0xc00000007e560000
> >   paca    = 0xc00000000fe00000	 softe: 0	 irq_happened: 0x08
> >     pid   = 1, comm = init
> > enter ? for help
> > [c00000007e5839d0] c00000000014dc14 .release_bp_slot+0x44/0x70
> > [c00000007e583a50] c000000000144bbc .free_event+0x6c/0x1e0
> > [c00000007e583ad0] c000000000144dc4 .perf_event_release_kernel+0x94/0x110
> > [c00000007e583b60] c00000000014cf08 .unregister_hw_breakpoint+0x18/0x30
> > [c00000007e583bd0] c00000000000e5f8 .ptrace_set_debugreg+0x158/0x230
> > [c00000007e583cd0] c00000000000eb4c .arch_ptrace+0x43c/0x7b0
> > [c00000007e583d90] c00000000008cbf8 .SyS_ptrace+0x98/0x170
> > [c00000007e583e30] c000000000009d54 syscall_exit+0x0/0x98
> > --- Exception: c01 (System Call) at 000000001001d1d4
> > SP (3fffdf7459f0) is in userspace
> >
> > The crash seems to happen some time after the fork.  Might be when the
> > new processes exits or get another ptrace call on it (I'm not sure which
> > one sorry).
> 
> Yes, probably because both parent and child have the same ->ptrace_bps[]
> pointers.
> 
> > Without your suggestion it doesn't crash this case (ie. mainline passes).
> 
> This is clear. flush_ptrace_hw_breakpoint() nullifies ->ptrace_bps[], so
> setup_thread_stack() copies NULL.
> 
> But, unless I missed something, this is wrong. Why should the parent lose
> its bps after fork?

Agreed, it shouldn't lose it.

> IOW, I think we need something like the patch below, but I do not have
> a powerpc machine for the testing.

OK, the below works for me... no more crashing.  FWIW

Acked-by: Michael Neuling <mikey@neuling.org>

Thanks,
Mikey

> 
> > Acked-by: Michael Neuling <mikey@neuling.org>
> 
> Thanks!
> 
> Oleg.
> 
> [PATCH] ptrace/powerpc: dont flush_ptrace_hw_breakpoint() on fork()
> 
> arch_dup_task_struct() does flush_ptrace_hw_breakpoint(src), this
> is not what we want. We should clear child->thread.ptrace_bps[]
> copied by dup_task_struct().
> 
> --- x/arch/powerpc/kernel/process.c
> +++ x/arch/powerpc/kernel/process.c
> @@ -910,10 +910,6 @@ int arch_dup_task_struct(struct task_str
>  	flush_altivec_to_thread(src);
>  	flush_vsx_to_thread(src);
>  	flush_spe_to_thread(src);
> -#ifdef CONFIG_HAVE_HW_BREAKPOINT
> -	flush_ptrace_hw_breakpoint(src);
> -#endif /* CONFIG_HAVE_HW_BREAKPOINT */
> -
>  	*dst = *src;
>  	return 0;
>  }
> @@ -984,6 +980,10 @@ int copy_thread(unsigned long clone_flag
>  	p->thread.ksp_limit = (unsigned long)task_stack_page(p) +
>  				_ALIGN_UP(sizeof(struct thread_info), 16);
>  
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +	p->thread.ptrace_bps[0] = NULL;
> +#endif
> +
>  #ifdef CONFIG_PPC_STD_MMU_64
>  	if (mmu_has_feature(MMU_FTR_SLB)) {
>  		unsigned long sp_vsid;
> 
