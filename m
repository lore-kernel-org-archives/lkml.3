Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaA3Tij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:38:39 -0500
Received: from www84.your-server.de ([213.133.104.84]:33545 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaA3Tii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:38:38 -0500
Message-ID: <1391110761.945.15.camel@wall-e.seibold.net>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO support for 32 kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Thu, 30 Jan 2014 20:39:21 +0100
In-Reply-To: <CALCETrWCgLYS0_+EjpxuFFgQ_wpRAihQM_fX0uHAezmp82upTw@mail.gmail.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
	 <1391078953-1575-4-git-send-email-stefani@seibold.net>
	 <CALCETrWCgLYS0_+EjpxuFFgQ_wpRAihQM_fX0uHAezmp82upTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.01.2014, 10:17 -0800 schrieb Andy Lutomirski:
> > +struct vsyscall_gtod_data vvar_vsyscall_gtod_data
> > +       __attribute__((visibility("hidden")));
> > +
> > +u32 hpet_counter
> > +       __attribute__((visibility("hidden")));
> > +
> > +#define gtod (&vvar_vsyscall_gtod_data)
> 
> Is it possible to keep the VVAR macro working for this?  It'll keep
> this code more unified and make it easier for anyone who tries to add
> vgetcpu support.
> 

Nope, since the access to the VVAR area differs in a 32 bit VDSO differ.
64 Bit VDSO always use FIXMAP Address, 32 bit VDSO depends on the sysctl
parameter vsyscall32 and the vdso32= kernel parameter.

In the origin code there is still gtod macro in the vclock_gettime.c,
but there is a mixed used of the gtod macro and
VVAR(vsyscall_gtod_data), so i cleaned it up only use the gtod Macro.

This has also nothing to do with vgetcpu, this is locate in a own file
called vgetcpu.c

> >         if (compat_uses_vma || !compat) {
> > -               /*
> > -                * MAYWRITE to allow gdb to COW and set breakpoints
> > -                */
> > -               ret = install_special_mapping(mm, addr, PAGE_SIZE,
> > -                                             VM_READ|VM_EXEC|
> > -                                             VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
> > -                                             vdso32_pages);
> > +
> > +               vma = _install_special_mapping(mm,
> > +                       addr,
> > +                       VDSO_OFFSET(VDSO_PAGES),
> > +                       VM_READ|VM_EXEC,
> > +                       vdso32_pages);
> > +
> > +               if (IS_ERR(vma)) {
> > +                       ret = PTR_ERR(vma);
> > +                       goto up_fail;
> > +               }
> > +
> > +               ret = remap_pfn_range(vma,
> > +                       vma->vm_start + VDSO_OFFSET(VDSO_VVAR_PAGE),
> > +                       __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
> > +                       PAGE_SIZE,
> > +                       PAGE_READONLY);
> >
> >                 if (ret)
> >                         goto up_fail;
> > +
> > +#ifdef CONFIG_HPET_TIMER
> > +               if (hpet_address) {
> > +                       ret = io_remap_pfn_range(vma,
> > +                               vma->vm_start + VDSO_OFFSET(VDSO_HPET_PAGE),
> > +                               hpet_address >> PAGE_SHIFT,
> > +                               PAGE_SIZE,
> > +                               pgprot_noncached(PAGE_READONLY));
> > +
> > +                       if (ret)
> > +                               goto up_fail;
> > +               }
> > +#endif
> >         }
> 
> Now I'm confused.  What's the fixmap stuff for?  Isn't this sufficient?
> 
> Also, presumably remap_pfn_range is already smart enough to prevent
> mprotect and ptrace from doing evil things.
> 

The fixmap code is for the original behaviour. It saves address space
and does not change the layout. Never break user space.

> >
> > @@ -19,11 +22,17 @@ ENTRY(__kernel_vsyscall);
> >   */
> >  VERSION
> >  {
> > -       LINUX_2.5 {
> > +       LINUX_2.6 {
> >         global:
> >                 __kernel_vsyscall;
> >                 __kernel_sigreturn;
> >                 __kernel_rt_sigreturn;
> > +               clock_gettime;
> > +               __vdso_clock_gettime;
> > +               gettimeofday;
> > +               __vdso_gettimeofday;
> > +               time;
> > +               __vdso_time;
> >         local: *;
> 
> Please remove the functions that don't start with __vdso -- I don't
> think they serve any purpose.  They can be confusing, since they're
> not interchangeable with the glibc functions of the same name.  (The
> 64-bit vdso needs them for historical reasons.)

I can do this...


