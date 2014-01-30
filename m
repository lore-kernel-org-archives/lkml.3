Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaA3TvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:51:17 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:53253 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaA3TvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:51:16 -0500
MIME-Version: 1.0
In-Reply-To: <1391110761.945.15.camel@wall-e.seibold.net>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
 <1391078953-1575-4-git-send-email-stefani@seibold.net> <CALCETrWCgLYS0_+EjpxuFFgQ_wpRAihQM_fX0uHAezmp82upTw@mail.gmail.com>
 <1391110761.945.15.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 11:50:55 -0800
Message-ID: <CALCETrV3fF8u2WWPmtFDybf94JmhDpNmCJcu9WxM0qxaA=H-og@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO support for 32 kernel
To: Stefani Seibold <stefani@seibold.net>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:39 AM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Donnerstag, den 30.01.2014, 10:17 -0800 schrieb Andy Lutomirski:
>> > +struct vsyscall_gtod_data vvar_vsyscall_gtod_data
>> > +       __attribute__((visibility("hidden")));
>> > +
>> > +u32 hpet_counter
>> > +       __attribute__((visibility("hidden")));
>> > +
>> > +#define gtod (&vvar_vsyscall_gtod_data)
>>
>> Is it possible to keep the VVAR macro working for this?  It'll keep
>> this code more unified and make it easier for anyone who tries to add
>> vgetcpu support.
>>
>
> Nope, since the access to the VVAR area differs in a 32 bit VDSO differ.
> 64 Bit VDSO always use FIXMAP Address, 32 bit VDSO depends on the sysctl
> parameter vsyscall32 and the vdso32= kernel parameter.

It should be possible to modify arch/x86/include/asm/vvar.h to make
the macro work, I think.

>
> In the origin code there is still gtod macro in the vclock_gettime.c,
> but there is a mixed used of the gtod macro and
> VVAR(vsyscall_gtod_data), so i cleaned it up only use the gtod Macro.
>
> This has also nothing to do with vgetcpu, this is locate in a own file
> called vgetcpu.c

If you fix up the VVAR macro, then you can enable __vdso_getcpu for
32-bit userspace for free.

>
>> >         if (compat_uses_vma || !compat) {
>> > -               /*
>> > -                * MAYWRITE to allow gdb to COW and set breakpoints
>> > -                */
>> > -               ret = install_special_mapping(mm, addr, PAGE_SIZE,
>> > -                                             VM_READ|VM_EXEC|
>> > -                                             VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
>> > -                                             vdso32_pages);
>> > +
>> > +               vma = _install_special_mapping(mm,
>> > +                       addr,
>> > +                       VDSO_OFFSET(VDSO_PAGES),
>> > +                       VM_READ|VM_EXEC,
>> > +                       vdso32_pages);
>> > +
>> > +               if (IS_ERR(vma)) {
>> > +                       ret = PTR_ERR(vma);
>> > +                       goto up_fail;
>> > +               }
>> > +
>> > +               ret = remap_pfn_range(vma,
>> > +                       vma->vm_start + VDSO_OFFSET(VDSO_VVAR_PAGE),
>> > +                       __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
>> > +                       PAGE_SIZE,
>> > +                       PAGE_READONLY);
>> >
>> >                 if (ret)
>> >                         goto up_fail;
>> > +
>> > +#ifdef CONFIG_HPET_TIMER
>> > +               if (hpet_address) {
>> > +                       ret = io_remap_pfn_range(vma,
>> > +                               vma->vm_start + VDSO_OFFSET(VDSO_HPET_PAGE),
>> > +                               hpet_address >> PAGE_SHIFT,
>> > +                               PAGE_SIZE,
>> > +                               pgprot_noncached(PAGE_READONLY));
>> > +
>> > +                       if (ret)
>> > +                               goto up_fail;
>> > +               }
>> > +#endif
>> >         }
>>
>> Now I'm confused.  What's the fixmap stuff for?  Isn't this sufficient?
>>
>> Also, presumably remap_pfn_range is already smart enough to prevent
>> mprotect and ptrace from doing evil things.
>>
>
> The fixmap code is for the original behaviour. It saves address space
> and does not change the layout. Never break user space.

I must still be missing something here.  There *is* no 32-bit
userspace with any expectation of where the VVAR page should be (or
the HPET, for that matter).

In any case, unless I'm reading it wrong, you've now added two
mappings of the vvar page and the hpet on 32-bit: the special mapping
and the fixmap.

Can you summarize exactly what mappings are intended to exist on
32-bit and for compat tasks?

(x32 can already use the 64-bit vdso, right?  I lost track of the
current state of that variant.)

--Andy
