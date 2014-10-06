Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJFVHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:07:47 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59672 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaJFVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:07:46 -0400
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2014 17:07:46 EDT
Date: Mon, 6 Oct 2014 16:54:59 -0400
From: Rich Felker <dalias@libc.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141006205459.GZ23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 01:23:30PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> In order for MIPS to be able to support a non-executable stack, we
> need to supply a method to specify a userspace area that can be used
> for executing emulated branch delay slot instructions.
> 
> We add a new system call, sys_set_fpuemul_xol_area so that userspace
> threads that are using the FPU can specify the location of the FPU
> emulation out of line execution area.
> 
> Background:
> 
> MIPS floating point support requires that any instruction that cannot
> be directly executed by the FPU, be emulated by the kernel.  Part of
> this emulation involves executing non-FPU instructions that fall in
> the delay slots of FP branch instructions.  Since the beginning of
> MIPS/Linux time, this has been done by placing the instructions on the
> userspace thread stack, and executing them there, as the instructions
> must be executed in the MM context of the thread receiving the
> emulation.
> 
> Because of this, the de facto MIPS Linux userspace ABI requires that
> the userspace thread have an executable stack.  It is de facto,
> because it is not written anywhere that this must be the case, but it
> is never the less a requirement.
> 
> Problem:
> 
> How do we get MIPS Linux to use a non-executable stack in the face of
> the FPU emulation problem?
> 
> Since userspace desires to change the ABI, put some of the onus on the
> userspace code.  Any userspace thread desiring a non-executable stack,
> must allocate a 4-byte aligned area at least 8 bytes long with that
> has read/write/execute permissions and pass the address of that area
> to the kernel with the new sys_set_fpuemul_xol_area system call.
> 
> This is similar to how we require userspace to notify the kernel of
> the value of the thread local pointer.

Userspace should play no part in this; requiring userspace to help
make special accomodations for fpu emulation largely defeats the
purpose of fpu emulation. The kernel is perfectly capable of mapping
an appropriate page. The mapping should happen at exec time, and at
clone time with CLONE_VM unless the kernel is going to handle mutual
exclusion so that only one thread can be using the page at a time.
(Using one page for the whole process, and excluding simultaneous
execution of fpu emulation in multiple threads, may be the more
practical approach.)

As an alternative, if the space of possible instruction with a delay
slot is sufficiently small, all such instructions could be mapped as
immutable code in a shared mapping, each at a fixed offset in the
mapping. I suspect this would be borderline-impractical (multiple
megabytes?), but it is the cleanest solution otherwise.

Rich
