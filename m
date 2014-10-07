Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaJGBi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:38:58 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59722 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaJGBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:38:57 -0400
Date: Mon, 6 Oct 2014 21:38:47 -0400
From: Rich Felker <dalias@libc.org>
To: "Kevin D. Kissell" <kevink@paralogos.com>
Cc: David Daney <ddaney.cavm@gmail.com>, libc-alpha@sourceware.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141007013847.GG23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <54333B9C.2040302@paralogos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54333B9C.2040302@paralogos.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 06:02:20PM -0700, Kevin D. Kissell wrote:
> On 10/06/2014 01:23 PM, David Daney wrote:
> >From: David Daney <david.daney@cavium.com>
> >
> >In order for MIPS to be able to support a non-executable stack, we
> >need to supply a method to specify a userspace area that can be used
> >for executing emulated branch delay slot instructions.
> >
> >We add a new system call, sys_set_fpuemul_xol_area so that userspace
> >threads that are using the FPU can specify the location of the FPU
> >emulation out of line execution area.
> >
> >Background:
> >
> >MIPS floating point support requires that any instruction that cannot
> >be directly executed by the FPU, be emulated by the kernel.  Part of
> >this emulation involves executing non-FPU instructions that fall in
> >the delay slots of FP branch instructions.  Since the beginning of
> >MIPS/Linux time, this has been done by placing the instructions on the
> >userspace thread stack, and executing them there, as the instructions
> >must be executed in the MM context of the thread receiving the
> >emulation.
> Well, actually it doesn't go back to the beginning of MIPS/Linux
> time - I was the b*astard who took the user-mode functional emulator
> from Algorithmics and got it to work in the MIPS Linux kernel
> context, some time in the early 2000s.  It was all pretty
> straightforward, except for the
> delay-slot-of-an-emulated-FP-conditional-branch problem. As you
> note, it may be a load or store (though not a branch), so it needs
> to be done in the user's MM context, and the user stack has nice
> properties of being intrinsically per-thread and re-entrancy
> tolerant.

If the space of possible instructions that need to run in the user's
MM context is sufficiently small, perhaps we could emulate the rest in
kernelspace and have a fixed code mapping exposed to userspace
containing each possible MM-context-dependent instruction combination.

As an alternative, the kernel could expose emulator code to run in
userspace as part of the vdso or other magic kernel-provided pages,
and this code would be capable of emulating arbitrary instructions,
which would of course take place in the user MM context.

This does not solve the problem for hardware with custom instructions,
but I still believe it's totally reasonable to say that the ABI does
not allow putting custom instructions in delay slots for coprocessor
branches.

> >Because of this, the de facto MIPS Linux userspace ABI requires that
> >the userspace thread have an executable stack.  It is de facto,
> >because it is not written anywhere that this must be the case, but it
> >is never the less a requirement.
> IIRC, when I first did the code, we already needed this for signal
> trampolines.  I just extended it.  Is it no longer required for
> signal support?  If not, how are signal trampolines now done, and
> could this not be re-extended to the FP branch delay slot emulation
> problem?

Signal trampolines were nonsense to begin with. The code needed is
fixed, not variable per-signal-instance, so it can be provided by libc
or by the kernel in the vdso page or similar.

> >Problem:
> >
> >How do we get MIPS Linux to use a non-executable stack in the face of
> >the FPU emulation problem?
> >
> >Since userspace desires to change the ABI, put some of the onus on the
> >userspace code.  Any userspace thread desiring a non-executable stack,
> >must allocate a 4-byte aligned area at least 8 bytes long with that
> >has read/write/execute permissions and pass the address of that area
> >to the kernel with the new sys_set_fpuemul_xol_area system call.
> >
> >This is similar to how we require userspace to notify the kernel of
> >the value of the thread local pointer.
> It's easy for me to criticise, since I'm no longer responsible for
> maintenance, but I hope you'll excuse me for commenting that, while
> this seems like a small enough and neat enough patch per se,  I find
> it disagreeable to break legacy binaries and to see a mechanism
> whose name and implementation is so strictly tied to the one
> purpose.  Even if it's only used for the FP delay slot emulation
> today, shouldn't it be designed/coded/documented as a sort of
> generic trampoline scratchpad?  And shouldn't we try to design
> things so that legacy code with FP but no new magic system call
> "just works"?  e.g. auto-allocate and initialize the space for a
> thread the first time it actually needs to emulate an FP branch?

"First time it actually needs to emulate" does not work, since it may
be impossible to allocate at that time, and then there's no way the
program can proceed. The allocation must be done at a time when you
can report failure, which means at the time of execve (for the main
thread) and clone (for other threads).

Rich
