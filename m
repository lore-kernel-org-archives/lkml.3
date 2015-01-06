Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbbAFSoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:44:21 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33836 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbbAFSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <20150106153429.GB32560@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net> <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
 <20150105125943.GC19655@pd.tnic> <CALCETrVEnVV5gibE++gj=eudqEBFTckDasqcY2zZDC9Y+NMUrQ@mail.gmail.com>
 <20150106153429.GB32560@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Jan 2015 10:43:57 -0800
Message-ID: <CALCETrXGmDOo-4aT3Zh2UzCHNK_Rkyw=y0sKMVBo=7Vjb9O1BA@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86_64,entry: Fix RCX for traced syscalls
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 6, 2015 7:34 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Mon, Jan 05, 2015 at 12:31:15PM -0800, Andy Lutomirski wrote:
> > Do you have context tracking on?
>
> Yap, it is enabled for whatever reason:
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_CONTEXT_TRACKING_FORCE=y
> CONFIG_HAVE_CONTEXT_TRACKING=y

I'll boot a kernel like this on bare metal and see what shakes loose.

>
> > I assume that's in the historical tree?
>
> Yeah.
>
> > > [  180.059170] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 frozen
> > > [  180.066873] ata1.00: failed command: WRITE FPDMA QUEUED
> > > [  180.072158] ata1.00: cmd 61/08:00:a8:ac:d9/00:00:23:00:00/40 tag 0 ncq 4096 out
> > > [  180.072158]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >
> > That's really weird.  The only thing I can think of is that somehow we
> > returned to user mode without enabling interrupts.
>
> Right, considering FIXUP_TOP_OF_STACK is used in a bunch of cases in
> entry_64.S, no wonder it corrupts something.
>
> > This leads me to wonder: why do we save eflags in the R11 pt_regs
> > slot?
>
> That: "If executed in 64-bit mode, SYSRET loads the lower-32 RFLAGS bits
> from R11[31:0] and clears the upper 32 RFLAGS bits."

Sure, but the code would be simpler if we shoved that value in the EFLAGS slot.

>
> > This seems entirely backwards, not to mention that it accounts for two
> > instructions in each of FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK
> > for no apparently reason whatsoever.
>
> > Can you send the full output from syscall_exit_regs_64 from here:
> >
> > https://gitorious.org/linux-test-utils/linux-clock-tests/source/34884122b6ebe81d9b96e3e5128b6d6d95082c6e:
> >
> > with the patch applied (assuming it even gets that far for you)?  I
> > see results like:
> >
> > [NOTE]    syscall ffff: orig RCX = 1  ss = 2b  orig_ss = 6b  flags =
> > 217  orig_flags = 217
> >
> > which seems fine.
>
> ./syscall_exit_regs_64
> [OK]    int80 ffff: AX = ffffffffffffffda
> [OK]    int80 40000000: AX = ffffffffffffffda
> [OK]    syscall ffff: RCX = 400962  RIP = 400962
> [OK]    syscall ffff: AX = ffffffffffffffda
> [NOTE]  syscall ffff: orig RCX = 1  ss = 2b  orig_ss = 6b  flags = 217  orig_flags = 217
> [OK]    syscall 40000000: RCX = 400962  RIP = 400962
> [FAIL]  syscall 40000000: AX = fffffffffffffff7
> [NOTE]  syscall 40000000: orig RCX = 1  ss = 2b  orig_ss = 6b  flags = 217  orig_flags = 217
> [OK]    syscall(ffff): ret = -1, errno = 38
>
> > Are you seeing this with the whole series applied or with only this patch?
>
> I applied this patch only and started seeing those. Then I booted in the
> previous kernel and tried to repro but it didn't trigger.
>
> I'll try hammering on the kernel *without* your patch to see whether I
> can trigger it somehow...

Hmm.  I added and pushed a test for fork, but that didn't turn
anything up.  And I don't see any bugs in the code.

I booted 3.18 plus this patch with context tracking forced on on my
laptop, and something seems to have gone wrong.

--Andy

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
