Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaJFV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:59:53 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59685 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJFV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:59:52 -0400
Date: Mon, 6 Oct 2014 17:58:13 -0400
From: Rich Felker <dalias@libc.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, libc-alpha@sourceware.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141006215813.GB23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54330D79.80102@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
> On 10/06/2014 02:31 PM, Rich Felker wrote:
> >On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:
> >>>Userspace should play no part in this; requiring userspace to help
> >>>make special accomodations for fpu emulation largely defeats the
> >>>purpose of fpu emulation.
> >>
> >>That is certainly one way of looking at it.  Really it is opinion,
> >>rather than fact though.
> >
> >It's an opinion, yes, but it has substantial reason behind it.
> >
> >>GLibc is full of code (see ld.so) that in earlier incantations of
> >>Unix/Linux was in kernel space, and was moved to userspace.  Given
> >>that there is a partitioning of code between kernel space and
> >>userspace, I think it not totally unreasonable to consider doing
> >>some of this in userspace.
> >>
> >>Even on systems with hardware FPU, the architecture specification
> >>allows for/requires emulation of certain cases (denormals, etc.)  So
> >>it is already a requirement that userspace cooperate by always
> >>having free space below $SP for use by the kernel.  So the current
> >>situation is that userspace is providing services for the kernel FPU
> >>emulator.
> >>
> >>My suggestion is to change the nature of the way these services are
> >>provided by the userspace program.
> >
> >But this isn't setup by the userspace program. It's setup by the
> >kernel on program entry. Despite that, though, I think it's an
> >unnecessary (and undocumented!) constraint; the fact that it requires
> >the stack to be executable makes it even more harmful and
> >inappropriate.
> >
> 
> The management of the stack is absolutely done by userspace code.
> Any time you do pthread_create(), userspace code does mmap() to
> allocate the stack area, it then sets permissions on the area, and
> then it passes the address of the area to clone().

This is hardly management.

> Furthermore the
> userspace code has to be very careful in its use of the $sp
> register, so that it doesn't store data in places that will be
> used/clobbered by the kernel.

This is not "being careful". The stack pointer can never become
invalid unless you do wacky things in asm or invoke UB.

> All of this is under the control of the userspace program and done
> with userspace code.

For the most part it just happens by default. There is no particular
intentionality needed, and certainly no hideous MIPS-specific hacks
needed.

> I appreciate the fact that libc authors might prefer *not* to write
> more code, but they could, especially if they wanted to add the
> feature of non-executable stacks to their library implementation.

So your position is that:

1. A non-exec-stack system can only run new code produced to do extra
   stuff in userspace.

2. The startup code needs to do special work in userspace on MIPS to
   setup an executable area for fpu emulation.

3. Every call to clone/CLONE_VM needs to be accompanied by a call to
   mmap and this new syscall to set the address, and every call to
   SYS_exit needs to be accompanies by a call to munmap for the
   corresponding mapping.

This is a huge ill-designed mess.

Rich
