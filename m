Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaJAPuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:50:44 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37981 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaJAPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:50:43 -0400
MIME-Version: 1.0
In-Reply-To: <542C1D2E.9050005@zytor.com>
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net>
 <542C1C28.9050408@zytor.com> <542C1D2E.9050005@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 Oct 2014 08:50:21 -0700
Message-ID: <CALCETrU2_tS-tmWAkW0vscOqQ89JrRrnjCA3P1aiZM-Xvj_oMA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anish Bhatt <anish@chelsio.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 1, 2014 8:26 AM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 10/01/2014 08:22 AM, H. Peter Anvin wrote:
> > On 09/30/2014 09:51 PM, Andy Lutomirski wrote:
> >>
> >> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> >> index 4299eb05023c..44d1dd371454 100644
> >> --- a/arch/x86/ia32/ia32entry.S
> >> +++ b/arch/x86/ia32/ia32entry.S
> >> @@ -151,6 +151,18 @@ ENTRY(ia32_sysenter_target)
> >>  1:  movl    (%rbp),%ebp
> >>      _ASM_EXTABLE(1b,ia32_badarg)
> >>      ASM_CLAC
> >> +
> >> +    /*
> >> +     * Sysenter doesn't filter flags, so we need to clear NT
> >> +     * ourselves.  To save a few cycles, we can check whether
> >> +     * NT was set instead of doing an unconditional popfq.
> >> +     */
> >> +    testl $X86_EFLAGS_NT,EFLAGS(%rsp)       /* saved EFLAGS match cpu */
> >> +    jz 1f
> >> +    pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
> >> +    popfq_cfi
> >> +1:
> >> +
> >
> > I'm wondering if it would be easier to just remove ASM_CLAC and do this
> > unconditionally.  On SMAP-enabled hardware then that gives us back some
> > of the cycles, may make the branch unnecessary.
> >
>
> Heck, we can drop the CLD and the STI as well (with some tweaking in
> ia32_badarg.)

I prototyped this, and performance sucked.  I suspect that cld and sti
are fairly well optimized, that I ended up introducing stalls due to
stack manipulation, and that Sandy Bridge's popfq microcode is just
not that fast.  Maybe I did it wrong.  Dunno.  Also, I can't benchmark
a SMAP machine, since I don't have one.  (Does anyone?  I'm currently
tempted to wait for Skylake before upgrading all my systems.)

In fact, I think we should change all the irqrestore code to do

if (flags & X86_EFLAFS_IF)
        sti;

I can send a v3 with the unlikely code moved out of line.

--Andy
