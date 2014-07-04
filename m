Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031851AbaGDXFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:05:53 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:51946 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031010AbaGDXFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140703163200.GA17372@arm.com>
References: <CAGXu5jKg0didhwZTUq8AbMnwD=RV=EaWiZWBWuar625JXGnL6w@mail.gmail.com>
 <CAGXu5j+bk3g0Dude8jfKM3dXxX8LE_46CMmcBCGdVMNX_Hu-6w@mail.gmail.com>
 <20140623084608.GA9316@arm.com> <CAGXu5jLJRU21YoBXjXRpfHW1-jwy_PV0hpH_oUfew23xLF4gYg@mail.gmail.com>
 <20140624085405.GA26013@arm.com> <53B5098B.9050801@linaro.org>
 <20140703102450.GD12958@arm.com> <CALCETrWQdHmn0-so1JHFoT-2A02mgcxDUb3jphSQmBGn-SQ+pA@mail.gmail.com>
 <20140703161154.GF14305@arm.com> <CALCETrXNQ0aLsE03mM0rdt-3mWP1Zze-nHSsME7Bwcf=5DyisA@mail.gmail.com>
 <20140703163200.GA17372@arm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 4 Jul 2014 16:05:29 -0700
Message-ID: <CALCETrUCX0sF5TBqfx1qzv4FKbesEKjr9KggF_kD4+yLQtFKnA@mail.gmail.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under PTRACE_O_TRACESECCOMP
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        =?UTF-8?Q?Andr=C3=A9_Hentschel?= <nerv@dawncrow.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 9:32 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Jul 03, 2014 at 05:13:50PM +0100, Andy Lutomirski wrote:
>> On Thu, Jul 3, 2014 at 9:11 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > On Thu, Jul 03, 2014 at 04:39:21PM +0100, Andy Lutomirski wrote:
>> >> On Thu, Jul 3, 2014 at 3:24 AM, Will Deacon <will.deacon@arm.com> wrote:
>> >> > On Thu, Jul 03, 2014 at 08:43:07AM +0100, AKASHI Takahiro wrote:
>> >> >> So it seems to me that we can't change a system call by ptrace().
>> >> >> Do I misunderstand anything?
>> >> >
>> >> > No, it looks like you have a point here. I don't think userspace has any
>> >> > business with orig_x0, but changing syscallno is certainly useful. I can
>> >> > think of two ways to fix this:
>> >> >
>> >> >   (1) Updating syscallno based on w8, but this ties us to the current ABI
>> >> >       and could get messy if this register changes in the future.
>> >> >
>> >> >   (2) Adding a PTRACE_SET_SYSCALL request, like we have for arch/arm/,
>> >> >       but that means adding arch-specific stuff to arch_ptrace (which
>> >> >       currently goes straight to ptrace_request on arm64).
>> >> >
>> >> > It looks like x86 uses orig_ax, which I *think* means we would go with
>> >> > (1) above if we followed their lead.
>> >>
>> >> w8 is a real register, right?  On x86, at least orig_ax isn't a real
>> >> register, so it's quite unlikely to conflict with hardware stuff.
>> >
>> > Yeah, w8 is the hardware register which the Linux ABI uses for the system
>> > call number. I was thinking We could allow the debugger/tracer to update
>> > the syscall number by updating that register, or do you see an issue with
>> > that? (other than tying us to the current ABI).
>>
>> Not immediately, but I'm not super-familiar with ptrace.
>>
>> Is w8 clobbered or otherwise changed by syscalls?  Using w8 for this
>> has the odd effect that tracers can't force a return with a specific
>> value of w8 without executing the corresponding syscall.  If that's a
>> meaningful limitation, then presumably some other channel should be
>> used.
>
> Hmm, that's true. Currently w8 is preserved across a syscall by the kernel,
> so it would be pretty bizarre for somebody to try and modify it but I guess
> they could do it if they wanted to. However, they could just as easily
> modify it on the syscall return path and have the same effect...
>
> Furthermore, glibc unconditionally emits a mov into w8 prior to the svc
> instruction, so from a user's perspective that register always contains
> the system call number.

That means that, if someone uses a seccomp trace action to skip or
emulate a syscall by writing -1 to w8, then user code will see an
unexpected -1 in w8.  I don't know how much this matters.

>
> FWIW: the role of w8 in the PCS is `Indirect result location register', so
> I'd expect it to be saved across the syscall anyway.
>
> Will



-- 
Andy Lutomirski
AMA Capital Management, LLC
