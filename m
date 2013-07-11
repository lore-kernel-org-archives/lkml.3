Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3GKKzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:55:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43122 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081Ab3GKKzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:55:32 -0400
Date: Thu, 11 Jul 2013 11:54:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm@lists.infradead.org" <linux-arm@lists.infradead.org>
Subject: Re: Seg fault occurs when running statically compiled binary from
 kernel using call_usermodehelper
Message-ID: <20130711105443.GE32197@mudshark.cambridge.arm.com>
References: <CAOiN93mGTu9w9rVNCrbbH1sccXY9VJhaCmg+dS7Rk9mMgKHBaA@mail.gmail.com>
 <CAOiN93=Nx77RkbNuEJMV617MjV5+GmorF0G3vyLy1SwQcuCs+g@mail.gmail.com>
 <CAOiN93nH9fyHoz4yrZmJ-OKCy6ogdt5bYartXCBgP5eHMUBPdw@mail.gmail.com>
 <20130710163410.GA30514@mudshark.cambridge.arm.com>
 <20130710185200.GX24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710185200.GX24642@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 07:52:00PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 10, 2013 at 05:34:11PM +0100, Will Deacon wrote:
> > Ok, I've finally got to the bottom of this, but I'm not sure on the best way
> > to fix it.
> 
> I don't think you have!  You need to look back at the older ARM kernels
> to really get to the bottom of this...

It's hard enough looking at the current kernel with the internet connection
I'm currently on! Anyway, what I meant was that I can see why the
application is falling over.

> > The issue is that libc expects r0 to contain a function pointer
> > to be invoked at exit (rtld_fini), to clean up after a dynamic linker. If
> > this pointer is NULL, then it is ignored. We actually zero this pointer in
> > our ELF_PLAT_INIT macro.
> > 
> > At the same time, we have this strange code called next from the ARM ELF
> > loader:
> > 
> > 	regs->ARM_r2 = stack[2];	/* r2 (envp) */			\
> > 	regs->ARM_r1 = stack[1];	/* r1 (argv) */			\
> > 	regs->ARM_r0 = stack[0];	/* r0 (argc) */			\
> > 
> > which puts argc into r0.
> 
> You're sort of right.  It dates from the days when we had a.out binaries,
> those required argc, argv and envp in r0/r1/r2 - and ARM kernels carried
> this hack in  binfmt_aout.c to make it work in conjunction with the above:
> 
> static int load_aout_binary(struct linux_binprm * bprm)
> {
> ...
>         start_thread(regs, ex.a_entry, current->mm->start_stack);
> #ifndef __arm__
>         return 0;
> #else
>         return regs->ARM_r0;
> #endif
> }
> 
> ELF, on the other hand, never had that hack - ELF has always been zero
> in r0, and it's always retrieved the argc/argv/envp off the stack.

Aha, I was missing the a.out part, thanks. The ELF loader does call:

	ELF_PLAT_INIT(regs, reloc_func_desc);
	start_thread(regs, elf_entry, bprm->p);

back-to-back, which zeroes ARM_r0 and then promptly sticks argc there
straight away. libc uses the stack for everything (ARM_r0 gets clobbered
again with the return value of execve anyway), so we just have to assume
that nobody is using argv and/or envp from r1 and r2. I think that's a
sensible assumption.

> As the above hack got dropped from the kernel (I don't think it ever made
> it into mainline), I think we should be safe getting rid of this
> initialization of regs->ARM_r0 to r2, leaving them all as zeros.
> 
> We should probably also remove the selection of HAVE_AOUT from
> arch/arm/Kconfig too as this definitely won't work with any recent
> kernel (certainly not without binfmt_aout.c hacked in the above way.)

Sounds like a good idea, I'll write a patch...

Will
