Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3KGTFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:05:48 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37561 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3KGTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <1383850597.2938.52.camel@localhost>
References: <20131107174746.GA22344@www.outflux.net> <CALCETrXpzmw7qvDPxkW+y=_h5W+a+uyJp1xkz55oBXu9sC+t3A@mail.gmail.com>
 <CAGXu5jJFv8Nkb89zq5029+35d9AwA4k1PRmP1VdY-LCCrJ4U6g@mail.gmail.com> <1383850597.2938.52.camel@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 7 Nov 2013 11:05:26 -0800
Message-ID: <CALCETrVgwMto=5Rn34dDOLrmzLargvs4QxCdPWdEvd=UZhg_Jg@mail.gmail.com>
Subject: Re: [PATCH v2] seccomp: not compatible with ARM OABI
To: Eric Paris <eparis@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>, James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 10:56 AM, Eric Paris <eparis@redhat.com> wrote:
> On Thu, 2013-11-07 at 10:39 -0800, Kees Cook wrote:
>> On Thu, Nov 7, 2013 at 10:16 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Thu, Nov 7, 2013 at 9:47 AM, Kees Cook <keescook@chromium.org> wrote:
>> >> Make sure that seccomp filter won't be built when ARM OABI is in use,
>> >> since there is work needed to distinguish calling conventions. Until
>> >> that is done (which is likely never since OABI is deprecated), make
>> >> sure seccomp filter is unavailable in the OABI world.
>> >>
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> ---
>> >> v2:
>> >>  - toggle availability via HAVE_ARCH_SECCOMP_FILTER; James Hogan.
>> >> ---
>> >>  arch/arm/Kconfig |    7 ++++++-
>> >>  1 file changed, 6 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> >> index 0a1dc697333c..a0a8590f3609 100644
>> >> --- a/arch/arm/Kconfig
>> >> +++ b/arch/arm/Kconfig
>> >> @@ -23,7 +23,7 @@ config ARM
>> >>         select HARDIRQS_SW_RESEND
>> >>         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
>> >>         select HAVE_ARCH_KGDB
>> >> -       select HAVE_ARCH_SECCOMP_FILTER
>> >> +       select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
>> >>         select HAVE_ARCH_TRACEHOOK
>> >>         select HAVE_BPF_JIT
>> >>         select HAVE_CONTEXT_TRACKING
>> >> @@ -1735,6 +1735,11 @@ config OABI_COMPAT
>> >>           in memory differs between the legacy ABI and the new ARM EABI
>> >>           (only for non "thumb" binaries). This option adds a tiny
>> >>           overhead to all syscalls and produces a slightly larger kernel.
>> >> +
>> >> +         The seccomp filter system will not be available when this is
>> >> +         selected, since there is no way yet to sensibly distinguish
>> >> +         between calling conventions during filtering.
>> >> +
>> >>           If you know you'll be using only pure EABI user space then you
>> >>           can say N here. If this option is not selected and you attempt
>> >>           to execute a legacy ABI binary then the result will be
>> >> --
>> >> 1.7.9.5
>> >>
>> >>
>> >
>> > FWIW, OABI-only (i.e. !AEABI, as opposed to OABI_COMPAT) is, in
>> > principle, supportable -- userspace would just have to know that, if
>> > build for OABI, the calling convention is different.
>>
>> Right -- I opted for enforcing seccomp-on-ARM-means-EABI.
>>
>> > I doubt this is worth supporting, though, and, if no one complains
>> > about your patch for a couple releases, then that would mean we could
>> > get away with adding AUDIT_ARCH_ARM_OABI or something (maybe for
>> > seccomp only) if needed.
>
> Audit already has: (ARM && AEABI && !OABI_COMPAT)  adding
> AUDIT_ARCH_ARM_OABI means we could support it and no worries about ABI
> breakage.

Maybe this isn't such a bad idea after all :)

>
> Isn't x32 similarly screwy?  Does it work because the syscall numbers
> are different?

Yes (from reading the code -- I haven't actually tried it).

I've always interpreted the AUDIT_ARCH stuff as meaning that
(audit_arch, nr) uniquely identifies a syscall and that (audit_arch,
nr, argument registers) identifies a syscall and its arguments.

On x32, the syscall invocation instruction is identical to x86_64 and
the mode of the process has nothing to do with which syscall is
invoked, so having a different audit_arch is unnecessary (as long as
the x32 bit in nr is preserved).

The weirdest case I know of is plain old x86, which has three
different syscall instructions that (IIRC) have three different
calling conventions.  They all result in the same syscalls happening,
and the kernel fudges it by changing the registers on entry and
fiddling with the return address.  This means that the physical
registers at the time of kernel entry are lost, but anyone can pretend
that the syscall was issued using int 80 and they'll correctly
interpret the syscall.

--Andy
