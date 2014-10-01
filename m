Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaJAPEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:04:08 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43553 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJAPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <20141001095603.3d5103d9@as>
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net>
 <20141001090915.16c8b1db@as> <20141001093208.79bb0891@as> <CALCETrXo-tvQOJ8Cg1d1wkQm=5095VdESq0SBUH4MivZWH8iQw@mail.gmail.com>
 <20141001095603.3d5103d9@as>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 Oct 2014 08:03:42 -0700
Message-ID: <CALCETrX=GzHBjPDQEVsk2zhXR9q855FKxj=pSfqS9n8R9bufBQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 7:56 AM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Wed, 1 Oct 2014 07:46:54 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Wed, Oct 1, 2014 at 7:32 AM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
>> > On Wed, 1 Oct 2014 09:09:13 -0500
>> > Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
>> >
>> >> On Tue, 30 Sep 2014 21:51:27 -0700
>> >> Andy Lutomirski <luto@amacapital.net> wrote:
>> >>
>> >> > The NT flag doesn't do anything in long mode other than causing IRET
>> >> > to #GP.  Oddly, CPL3 code can still set NT using popf.
>> >> >
>> >> > Entry via hardware or software interrupt clears NT automatically, so
>> >> > the only relevant entries are fast syscalls.
>> >> >
>> >> > If user code causes kernel code to run with NT set, then there's at
>> >> > least some (small) chance that it could cause trouble.  For example,
>> >> > user code could cause a call to EFI code with NT set, and who knows
>> >> > what would happen?  Apparently some games on Wine sometimes do
>> >> > this (!), and, if an IRET return happens, they will segfault.  That
>> >> > segfault cannot be handled, because signal delivery fails, too.
>> >> >
>> >> > This patch programs the CPU to clear NT on entry via SYSCALL (both
>> >> > 32-bit and 64-bit, by my reading of the AMD APM), and it clears NT
>> >> > in software on entry via SYSENTER.
>> >> >
>> >> > To save a few cycles, this borrows a trick from Jan Beulich in Xen:
>> >> > it checks whether NT is set before trying to clear it.  As a result,
>> >> > it seems to have very little effect on SYSENTER performance on my
>> >> > machine.
>> >> >
>> >> > Testers beware: on Xen, SYSENTER with NT set turns into a GPF.
>> >> >
>> >> > I haven't touched anything on 32-bit kernels.
>> >> >
>> >> > The syscall mask change comes from a variant of this patch by Anish
>> >> > Bhatt.
>> >> >
>> >> > Cc: stable@vger.kernel.org
>> >> > Reported-by: Anish Bhatt <anish@chelsio.com>
>> >> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> > ---
>> >> >  arch/x86/ia32/ia32entry.S    | 12 ++++++++++++
>> >> >  arch/x86/kernel/cpu/common.c |  2 +-
>> >> >  2 files changed, 13 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
>> >> > index 4299eb05023c..44d1dd371454 100644
>> >> > --- a/arch/x86/ia32/ia32entry.S
>> >> > +++ b/arch/x86/ia32/ia32entry.S
>> >> > @@ -151,6 +151,18 @@ ENTRY(ia32_sysenter_target)
>> >> >  1: movl    (%rbp),%ebp
>> >> >     _ASM_EXTABLE(1b,ia32_badarg)
>> >> >     ASM_CLAC
>> >> > +
>> >> > +   /*
>> >> > +    * Sysenter doesn't filter flags, so we need to clear NT
>> >> > +    * ourselves.  To save a few cycles, we can check whether
>> >> > +    * NT was set instead of doing an unconditional popfq.
>> >> > +    */
>> >> > +   testl $X86_EFLAGS_NT,EFLAGS(%rsp)       /* saved EFLAGS match cpu */
>> >> > +   jz 1f
>> >> > +   pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
>> >> > +   popfq_cfi
>> >> > +1:
>> >> > +
>> >>
>> >> I think you've gone backwards with this version. The earlier one got
>> >> some of the performance loss back by not needing to do the "cld" insn.
>> >>
>> >> You should just replace that "cld" (line 146) with
>> >>
>> >>       pushfq_cfi $2
>> >>       popfq_cfi
>> >>
>> >> Unfortunately I'm not set up to test that yet. But I did look at
>> >> the SDM and can't see a need to preserve any of the flags.
>> >>
>> >
>> >
>> > <sigh> that's:
>> >
>> >         pushfw_cfi $0x202
>> >
>> > IF needs to stay on because we've already enabled interrupts after
>> > sysenter.
>>
>> I tried exactly this.  It was much slower than the version I sent.
>>
>
> Yeah, it looks like a new paravirt op that enables interrupts and
> clears all the other flags would be the only way to do this without at
> least some impact on performance.

We have that -- it's called something like setfl.

But it still wouldn't help.  It seems that cld, test, jnz is simply
much faster than popfq.

If we could fold it with the sti earlier, *maybe* that would be a win,
but then we'd also have to patch the saved flags to avoid returning to
userspace with interrupts off.  (And I tried that.  It still didn't
seem to be fast enough.)

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
