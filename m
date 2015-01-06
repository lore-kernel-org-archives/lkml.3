Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbbAFPeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:34:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbbAFPec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:34:32 -0500
Date: Tue, 6 Jan 2015 16:34:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86_64,entry: Fix RCX for traced syscalls
Message-ID: <20150106153429.GB32560@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net>
 <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
 <20150105125943.GC19655@pd.tnic>
 <CALCETrVEnVV5gibE++gj=eudqEBFTckDasqcY2zZDC9Y+NMUrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVEnVV5gibE++gj=eudqEBFTckDasqcY2zZDC9Y+NMUrQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 12:31:15PM -0800, Andy Lutomirski wrote:
> Do you have context tracking on?

Yap, it is enabled for whatever reason:
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_HAVE_CONTEXT_TRACKING=y

> I assume that's in the historical tree?

Yeah.

> > [  180.059170] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 frozen
> > [  180.066873] ata1.00: failed command: WRITE FPDMA QUEUED
> > [  180.072158] ata1.00: cmd 61/08:00:a8:ac:d9/00:00:23:00:00/40 tag 0 ncq 4096 out
> > [  180.072158]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> 
> That's really weird.  The only thing I can think of is that somehow we
> returned to user mode without enabling interrupts.

Right, considering FIXUP_TOP_OF_STACK is used in a bunch of cases in
entry_64.S, no wonder it corrupts something.

> This leads me to wonder: why do we save eflags in the R11 pt_regs
> slot?

That: "If executed in 64-bit mode, SYSRET loads the lower-32 RFLAGS bits
from R11[31:0] and clears the upper 32 RFLAGS bits."

> This seems entirely backwards, not to mention that it accounts for two
> instructions in each of FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK
> for no apparently reason whatsoever.

> Can you send the full output from syscall_exit_regs_64 from here:
> 
> https://gitorious.org/linux-test-utils/linux-clock-tests/source/34884122b6ebe81d9b96e3e5128b6d6d95082c6e:
> 
> with the patch applied (assuming it even gets that far for you)?  I
> see results like:
> 
> [NOTE]    syscall ffff: orig RCX = 1  ss = 2b  orig_ss = 6b  flags =
> 217  orig_flags = 217
> 
> which seems fine.

./syscall_exit_regs_64
[OK]    int80 ffff: AX = ffffffffffffffda
[OK]    int80 40000000: AX = ffffffffffffffda
[OK]    syscall ffff: RCX = 400962  RIP = 400962
[OK]    syscall ffff: AX = ffffffffffffffda
[NOTE]  syscall ffff: orig RCX = 1  ss = 2b  orig_ss = 6b  flags = 217  orig_flags = 217
[OK]    syscall 40000000: RCX = 400962  RIP = 400962
[FAIL]  syscall 40000000: AX = fffffffffffffff7
[NOTE]  syscall 40000000: orig RCX = 1  ss = 2b  orig_ss = 6b  flags = 217  orig_flags = 217
[OK]    syscall(ffff): ret = -1, errno = 38

> Are you seeing this with the whole series applied or with only this patch?

I applied this patch only and started seeing those. Then I booted in the
previous kernel and tried to repro but it didn't trigger.

I'll try hammering on the kernel *without* your patch to see whether I
can trigger it somehow...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
