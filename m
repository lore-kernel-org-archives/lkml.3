Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaJGAuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:50:37 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59716 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaJGAug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:50:36 -0400
Date: Mon, 6 Oct 2014 20:49:15 -0400
From: Rich Felker <dalias@libc.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Andy Lutomirski <luto@amacapital.net>, David Daney <ddaney.cavm@gmail.com>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141007004915.GF23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx>
 <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com>
 <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543334CE.8060305@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 05:33:18PM -0700, David Daney wrote:
> On 10/06/2014 05:05 PM, Rich Felker wrote:
> >On Mon, Oct 06, 2014 at 04:48:52PM -0700, David Daney wrote:
> >>On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
> >>>On 10/06/2014 02:58 PM, Rich Felker wrote:
> >>>>On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
> >>[...]
> >>>>This is a huge ill-designed mess.
> >>>
> >>>Amen.
> >>>
> >>>Can the kernel not just emulate the instructions directly?
> >>
> >>In theory it could, but since there can be implementation defined
> >>instructions, there is no way to achieve full instruction set
> >>coverage for all possible machines.
> >
> >Is the issue really implementation-defined instructions with delay
> >slots?
> 
> It is the instructions in the delay slots, not the branch
> instructions themselves that are of interest.  But, for the sake of
> the arguments, this is not a critical point.

I think it's an important distinction. It means the problem domain is
supporting all possible instructions, not instructions which can
reasonably have delay slots.

> >If so it sounds like a made-up issue.
> 
> It is not a made up issue.
> 
> If you want an architecture that has a well defined instruction set,
> stick with x86, Intel will tell you what is good for you and you
> will take whatever they give you.
> 
> If you want an architecture where you can add implementation defined
> instructions to do whatever you want, then you use an architecture
> like MIPS.

The ability to add arbitrary instructions does not mean that arbitrary
uses of those instructions have to be supported by the ABI. It's
completely reasonable for the ABI to say they cannot be used in delay
slots for coprocessor-conditional branches.

And of course once you're in the realm of custom hardware and software
written to depend on that custom hardware, you know whether you have
an fpu or not anyway. If you have an fpu, you can ignore the
restriction. If you don't, you should follow it. Note that "partial
fpu emulation" (e.g. just denormals) is not relevant here; the issue
only arises if the coprocessor branch instructions have to be
emulated, which means "there's no fpu at all".

> >They're not going to
> >occur in real binaries. Certainly a compiler is not going to generate
> >implementation-defined instructions,
> 
> Why not?  It will emit any instructions we care to make it emit.  If
> we want it to emit crypto instructions with patented algorithms,
> then it will do that.  But we would still like to use a generic
> kernel with generic FPU support.
> 
> The most straight forward way (and the currently implemented way) of
> doing this is to execute the instructions in question out-of-line
> (on the userspace stack).
> 
> The question here is:  What is the best way to get to a
> non-executable stack.
> 
> The consensus among MIPS developers is that we should continue using

My experience has been that hardware and software developers focused
on a particular hardware target are generally unqualified to make
decisions that affect the design and operation of libc or the kernel.
They are not experts in these areas. It was apparent early on in this
thread, when you mentioned the idea that "not all threads would need
fpu support", that you were thinking from a standpoint of custom
low-level software and not a general purpose libc that cannot read the
application author's mind. It seems nobody had thought of the
impossibility of doing lazy setup (inability to handle failure) and
the necessity of always initializing this stuff at pthread_create
time, either. Design issues like this should be run by experts in the
libc area early on, not as an afterthought.

> the out-of-line execution trick, but do it somewhere other than in
> stack memory.

How do you answer Andy Lutomirski's question about what happens when a
signal handler interrupts execution while the program counter is
pointing at this "out-of-line execution" trampoline? This seems like a
show-stopper for using anything other than the stack.

> One way of doing this is to have the kernel magically generate
> thread local memory regions.
> 
> Another option is to have userspace manage the out-of-line execution areas.
> 
> As is often the case, each approach has different pluses and minuses.

Having the kernel magically do it would be better, but I'm doubtful
that solution works anyway due to the above signal handler/nesting
issue.

Rich
