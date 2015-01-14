Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbbANQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:51:56 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:42922 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbANQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:51:54 -0500
Date: Wed, 14 Jan 2015 16:51:51 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Message-ID: <20150114165151.GA3479@codeblueprint.co.uk>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141231183739.GA28946@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec, at 06:37:39PM, Matt Fleming wrote:
> On Wed, 17 Dec, at 08:54:56AM, Andy Lutomirski wrote:
> > > As far as I know, the only way to have continuously functional interrupt
> > > handling across a long mode transition is to install an interrupt vector
> > > table and hope that CPUs actually do something intelligent when
> > > receiving an interrupt with LME=1, LMA=1, and PG=0.  Yuck.
> > >
> > > Could we get away with issuing 32-bit EFI calls in compat mode, i.e.
> > > with a 32-bit CPL0 CS but while still in long mode?  I think that
> > > delivery of an IST interrupt (which includes both NMI and MCE) will
> > > correctly switch to a fully valid 64-bit state and would correctly
> > > switch back when we execute IRET at the end.  (Am I missing some reason
> > > that switching bitness without a privilege level change doesn't work
> > > well?  I haven't thought of anything, other than the lack of SS/SP controls
> > > on intra-ring interrupts, but that shouldn't be an issue here.)
> > >
> > > As an added benefit, this would considerably simplify the code.
> 
> I can't immediately think of a reason that this wouldn't work, but I've
> Cc'd more x86 folks for additional insight.
> 
> I will schedule some time to look into this issue in the new year.
> Thanks Andy.

I finally got some time to look into this, and running with
__KERNEL32_CS seems to work fine at runtime both with Qemu + 32-bit OVMF
and on my ASUS T100. Manually triggering an MCE exception immediately
before invoking the firmware service recovers gracefully.

Where this won't work so well is at boot time before we jump to the
kernel proper. There, we still need to restore the firmware's GDT so
that interrupts are serviced correctly before ExitBootServices() (in
particular, ia32 Tianocore assumes __KERNEL_CS is a 32-bit CS).

Which means the code to handle mixed mode calls at boot time and runtime
has now diverged. Fixing that is probably just a SMOP to maximise code
reuse though.

I'll post a patch after some more testing.

-- 
Matt Fleming, Intel Open Source Technology Center
