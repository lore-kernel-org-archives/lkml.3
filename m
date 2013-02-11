Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3BKMh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:37:56 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51237 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3BKMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:37:53 -0500
Message-ID: <5118E60E.5060606@synopsys.com>
Date: Mon, 11 Feb 2013 18:07:34 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal
 handling)
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-9-git-send-email-vgupta@synopsys.com> <51189D2F.4030000@synopsys.com> <CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com> <5118C458.2070205@synopsys.com> <5118C7B6.6040807@imgtec.com> <CACM3HyG+4Pzx02iL9atxG+FOLiCcTeXR+ivzRO78bqDHNp5rGQ@mail.gmail.com> <5118D478.3010205@synopsys.com> <CACM3HyG7B=iMb4cHYP2cb8np55t8WefWTh4x3SYkGK4Lc=RXbA@mail.gmail.com>
In-Reply-To: <CACM3HyG7B=iMb4cHYP2cb8np55t8WefWTh4x3SYkGK4Lc=RXbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 05:42 PM, Jonas Bonn wrote:
> On 11 February 2013 12:22, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> On Monday 11 February 2013 04:23 PM, Jonas Bonn wrote:
>>> On 11 February 2013 11:28, James Hogan <james.hogan@imgtec.com> wrote:
>>>> On 11/02/13 10:13, Vineet Gupta wrote:
>>>>> On Monday 11 February 2013 03:06 PM, Jonas Bonn wrote:
>>>>>> On 11 February 2013 08:26, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>>>>>
>>>>>>> The only downside of this patch is that userspace signal stack grows in size,
>>>>>>> since signal frame only cares about scratch regs (pt_regs), but has to accommodate
>>>>>>> unused placeholder for callee regs too by virtue of using user_regs_struct.
>>>>>> Is this really true?  Don't setcontext and friends require that _all_
>>>>>> the registers be part of sigcontext?
>>>>> But for an ABI - callee saved regs will anyhow be saved/restored even in
>>>>> setcontext case ! So collecting it for that purpose seems useless, or am I missing
>>>>> something here.
>>>> I think Jonas' point was that signals are asynchronous, i.e. you could
>>>> get interrupted by a signal at virtually any time during the program's
>>>> execution.
>>> No, I agree that the callee-saved regs don't need to be saved across a
>>> signal handler invocation.  It's really just the setcontext case that
>>> wants to be able to swap out the callee-saved regs.
>> I don't think that's needed either - and if thats mandated somewhere, it would
>> seem a unnecessary mis-optimization IMHO.
>>
>> See, even a setcontext enabled control flow needs to be ABI compliant so that it
>> plays nicely with other normal flows of execution. Thus e.g. it can't fudge a
>> callee reg - it needs to save orig callee reg(s) and restore them in the end. And
>> if we agree to those semantics - I don't see any value in swapping the callee reg
>> context around usage of setcontext as it would be a wasted effort.
> Yeah, that makes sense.  I can see where you're coming from... and the
> fact that you switch the stack, as James pointed out, means that you
> end up restoring whatever callee-saved registers you need in the new
> control flow on the way out of your setcontext wrapper.
>
> BUT... a successful call to setcontext() does not return and whatever
> code you end up jumping to as a result of the call has its own
> expectations about the state of the registers. 

It doesn't matter if the call returns or not. The point is the code jumped to - if
ABI compliant will save the callee regs before clobbering them.
For a new execution context, callee regs (for any ABI whatsoever) can have random
state, as the caller will save/restore them. It's only in the __switch_to kind of
scenario (see below) does the orig values really matter.


> Somebody has to set up
> the registers to meet these expectations and, as far as I can see,
> this means:
>
> i) sigreturn fixes up the internal pt_regs with the new userspace state
> ii) the syscall return path restores _all_ the regs, as though there
> had been a context switch
>
> What am I missing?  I'm totally open to the idea that I'm the one
> who's confused here...

Far from that - u seem to be the one in charge here :-)

I don't know how setcontext enabled app works - but there's a different use case
we can compare with - __switch_to( ) is the only legit place in kernel (ignoring
ptrace-peek/pokeusr for now) which saves callee regs (kernel mode) and restores
them for different task. And the only reason it does that is because it switches
context from the "middle" of control flow. Now if setcontext based switching works
in that fashion - then yes we do need callee regs setup there - if not then we don't.

> ...and perhaps this is all moot since it seems that
> getcontext/setcontext are obsolete anyway(???).

That would make it so much be easy :-)

Anyhow going back to my orig patch - if we park the
callee-regs-in-sigcontext-or-not, other bits look OK ?

-Vineet
