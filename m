Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaJFXKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 19:10:41 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59692 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJFXKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:10:40 -0400
Date: Mon, 6 Oct 2014 19:08:56 -0400
From: Rich Felker <dalias@libc.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, libc-alpha@sourceware.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141006230856.GC23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx>
 <543314DF.20808@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543314DF.20808@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 03:17:03PM -0700, David Daney wrote:
> >>Furthermore the
> >>userspace code has to be very careful in its use of the $sp
> >>register, so that it doesn't store data in places that will be
> >>used/clobbered by the kernel.
> >
> >This is not "being careful". The stack pointer can never become
> >invalid unless you do wacky things in asm or invoke UB.
> >
> >>All of this is under the control of the userspace program and done
> >>with userspace code.
> >
> >For the most part it just happens by default. There is no particular
> >intentionality needed, and certainly no hideous MIPS-specific hacks
> >needed.
> 
> Yes, it happens by default.  But it wasn't magic.  It took careful
> work by the ABI and toolchain designers to make it work.

Here I disagree. All of these things are completely universal, not
MIPS-specific.

> >>I appreciate the fact that libc authors might prefer *not* to write
> >>more code, but they could, especially if they wanted to add the
> >>feature of non-executable stacks to their library implementation.
> >
> >So your position is that:
> 
> It is not really a position that I have.  Rather a proposal for one
> possible way to make non-executable stacks work on MIPS.
> 
> >
> >1. A non-exec-stack system can only run new code produced to do extra
> >    stuff in userspace.
> 
> Any non-executable stack solution for MIPS will require changes to
> the toolchain/libc.  So it is merely a question of what form the
> change should take.

I disagree with this, at least for the most part. If the kernel does
the fpu emulation correctly, there's no reason it shouldn't be
possible to run existing binaries on a hardened kernel that does not
even support executable stack.

> >2. The startup code needs to do special work in userspace on MIPS to
> >    setup an executable area for fpu emulation.
> 
> Yes. Similar to how startup code has to do special work to set up
> the TLS areas,

Yes. Actually the simple way to implement this in userspace would be
with a page-sized, page-aligned object in TLS and a special call to
mprotect and your new syscall. One thing I'm not clear on: should this
memory have permissions r-x or rwx? If it has rwx, that defeats a lot
of the purpose of non-executable-stack. Hopefully it's r-x and the
kernel bypasses the non-writability to write to it.

> and load shared libraries.

Dynamic linking is completely a separate matter. Not all programs are
even dynamic-linked.

> >3. Every call to clone/CLONE_VM needs to be accompanied by a call to
> >    mmap and this new syscall to set the address, and every call to
> >    SYS_exit needs to be accompanies by a call to munmap for the
> >    corresponding mapping.
> >
> 
> No, We don't have to mmap() on each thread creation.  Many threads
> (perhaps 512) could be handled by a single page, so the normal case
> would be a single mmap() for the life of the program.

That's nice from a standpoint of avoiding memory waste, but it's
problematic if .////

> >This is a huge ill-designed mess.
> >
> 
> Have you seen the alternatives?

I proposed a couple and I think they're much less ugly. Could you
point me to the others?

But perhaps you could clarify one thing for me: why is any of this
even needed? A delay slot only exists for branch instructions, and I
can't see any reason the kernel can't just emulate the branch
instruction at the same time. This is a very restricted class of
instructions that should not require any complex emulation of memory
permissions, just manipulation of the resulting program counter value
after the floating point instruction finishes. Or am I missing
something?

> Have you ever wondered why MIPS doesn't have non-executable stack support?

I wasn't even aware that it didn't until your email.

Rich
