Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3BYUCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:02:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49872 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3BYUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:02:39 -0500
Date: Mon, 25 Feb 2013 20:02:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Steve Muckle <smuckle@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field
	mask width
Message-ID: <20130225200209.GP17833@n2100.arm.linux.org.uk>
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org> <20130225172545.GO17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225172545.GO17833@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 05:25:45PM +0000, Russell King - ARM Linux wrote:
> On Fri, Feb 22, 2013 at 12:08:05AM -0800, Stephen Boyd wrote:
> > From: Steve Muckle <smuckle@codeaurora.org>
> > 
> > The subarchitecture field in the fpsid register is 7 bits wide.
> > The topmost bit is used to designate that the subarchitecture
> > designer is not ARM. We use this field to determine which VFP
> > version is supported by the CPU. Since the topmost bit is masked
> > off we detect non-ARM subarchitectures as supporting only
> > HWCAP_VFP and not HWCAP_VFPv3 as it should be for Qualcomm's
> > processors.
> > 
> > Use the proper width for the mask so that we report the correct
> > elf_hwcap of non-ARM designed processors.
> 
> This is a *big* can of worms.  How this register is defined depends on
> what document you look at:

This can of worms is getting bigger.  We have more problems with our
handling of the different VFP versions, specifically the handling of
the EX=0 DEX=0 case.

VFP common subarch 3 defines the EX=0, DEX=0 encoding to mean one of
the following conditions have been met:

1. an unallocated VFP instruction was encountered.

   In other words, the VFP was the target of the co-processor instruction,
   but the instruction is not a known VFP instruction encoding.  This
   should raise an undefined instruction exception.

2. an allocated VFP instruction was encountered, but not handled in
   hardware.

   In other words, the instruction is a valid VFP instruction, but the
   hardware has opted not to implement this instruction and wants
   software to emulate it instead.

   (Note: this can also be raised as EX=0, DEX=1 - implementation
    defined!)

Now, VFP common subarch 2 removes condition (2) from this.  VFP common
subarch 1 further complicates this by changing the behaviour when IXE=1
(these are always 'synchronous' exceptions.

Now, what does our code do?  Well, the first area to look at is the
assembly:

look_for_VFP_exceptions:
        @ Check for synchronous or asynchronous exception
        tst     r1, #FPEXC_EX | FPEXC_DEX
        bne     process_exception
        @ On some implementations of the VFP subarch 1, setting FPSCR.IXE
        @ causes all the CDP instructions to be bounced synchronously without
        @ setting the FPEXC.EX bit
        VFPFMRX r5, FPSCR
        tst     r5, #FPSCR_IXE
        bne     process_exception

        @ Fall into hand on to next handler - appropriate coproc instr
        @ not recognised by VFP

So, if EX or DEX is set, _or_ IXE is set, we pass control to VFP_bounce.
This is problematical.

(a) condition (2) above isn't correctly handled for common subarch v3 - it
    is always treated as an undefined instruction, and will result in a
    SIGILL being delivered.

(b) if IXE is set, we _always_ treat the instruction as being defined,
    which means we will never raise a SIGILL for the faulting instruction,
    even if it is an undefined VFP instruction.  Instead, they will
    receive a SIGFPE and the kernel will dump the entire VFP state into
    the kernel message log - eg:
	VFP: Error: unhandled bounce
	VFP: EXC 0x40000000 SCR 0x00001000 INST 0xec410b30
	VFP: s 0: 0x00000000 s 1: 0x00000000
	VFP: s 2: 0x00000000 s 3: 0x00000000
	VFP: s 4: 0x00000000 s 5: 0x00000000
	VFP: s 6: 0x00000000 s 7: 0x00000000
	VFP: s 8: 0x00000000 s 9: 0x00000000
	VFP: s10: 0x00000000 s11: 0x00000000
	VFP: s12: 0x00000000 s13: 0x00000000
	VFP: s14: 0x00000000 s15: 0x00000000
	VFP: s16: 0x00000000 s17: 0x00000000
	VFP: s18: 0x00000000 s19: 0x00000000
	VFP: s20: 0x00000000 s21: 0x00000000
	VFP: s22: 0x00000000 s23: 0x00000000
	VFP: s24: 0x00000000 s25: 0x00000000
	VFP: s26: 0x00000000 s27: 0x00000000
	VFP: s28: 0x00000000 s29: 0x00000000
	VFP: s30: 0x00000000 s31: 0x00000000
    (Yes, I've just proven this on Marvell Dove.)

Now, (a) is just bad behaviour - as we haven't had any reports of this
yet, I suspect that no one has implemented VFP hardware with this
behaviour yet.

However, (b) is something of a problem: consider a userspace program
which ignores SIGFPE signals, sets IXE, and executes an undefined
instruction in a tight loop.  Watch your kernel message log spew an
endless stream of VFP data dumps...

And now we come to the final niggle.  As you can see from the above,
to be able to handle the various VFP exceptions correctly, it is
required to know which of the common subarchitecture versions has been
implemented in the hardware.  These common subarchitectures are entirely
optional, and are not even guaranteed to be implemented this way even
on ARM hardware.  And now go back and look at my preceding mail on the
implementer specific decoding of the "subarch" field in the FPSID
register...

So, what can we do?

We _can_ fix some of these by decoding the subarch field for ARM
implementations, and having the exception handling code decode these
cases in the appropriate common subarchitecture way.

What do we do for non-ARM implementations?  For Marvell Dove, what
little information I have says that it is a "VFPv2 architecture"
implementation to the ARM ARM.  But Marvell Dove is ARMv7, and the
ARM ARM says VFPv2 is not permitted on ARMv7 CPUs.  Also, it reports:

VFP support v0.3: implementor 56 architecture 2 part 20 variant 9 rev 5

this decodes as "VFPv3 architecture, or later, with Common VFP
subarchitecture v2." which is also contary to the Marvell statement.
Given that it does appear to work without modifications, I'm willing
to bet that it really is VFPv3.

For others?  That's a very good question to which I don't have any
answer: if they don't implement the common subarchitecture, then the
decoding of FPEXC, except for the EX and EN bits, is implementation
defined.  What joy.
