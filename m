Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3HJRSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:18:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33891 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab3HJRSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:18:45 -0400
Message-ID: <520675D3.7030703@zytor.com>
Date: Sat, 10 Aug 2013 10:18:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Galbraith <bitbucket@online.de>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org> <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net> <5206659F.9070705@zytor.com> <CA+55aFyB5E+Keupjz4trfMcNawUKVzQV8DF5aS_VsPiw3FaT_Q@mail.gmail.com>
In-Reply-To: <CA+55aFyB5E+Keupjz4trfMcNawUKVzQV8DF5aS_VsPiw3FaT_Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 09:43 AM, Linus Torvalds wrote:
> On Sat, Aug 10, 2013 at 9:09 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Do you have any quantification of "munches throughput?"  It seems odd
>> that it would be worse than polling for preempt all over the kernel, but
>> perhaps the additional locking is what costs.
> 
> Actually, the big thing for true preemption is not so much the preempt
> count itself, but the fact that when the preempt count goes back to
> zero we have that "check if we should have been preempted" thing.
> 
> And in particular, the conditional function call that goes along with it.
> 
> The thing is, even if that is almost never taken, just the fact that
> there is a conditional function call very often makes code generation
> *much* worse. A function that is a leaf function with no stack frame
> with no preemption often turns into a non-leaf function with stackcheck
> frames when you enable preemption, just because it had a RCU read
> region which disabled preemption.
> 
> It's similar to the kind of code generation issue that Andi's patches
> are trying to work on.
> 
> Andi did the "test and jump to a different section to call the
> scheduler with registers saved" as an assembly stub in one of his
> patches in this series exactly to avoid the cost of this for the
> might_sleep() case, and generated that GET_THREAD_AND_SCHEDULE asm
> macro for it. But look at that asm macro, and compare it to
> "preempt_check_resched()"..
> 
> I have often wanted to have access to that kind of thing from C code.
> It's not unusual. Think lock failure paths, not Tom Jones.
> 

Hmm... if that is really the big issue then I'm wondering if
preempt_enable() &c shouldn't be rewritten in assembly... if nothing
else to get the outbound call out of view of the C compiler; it could
even be turned into an exception instruction.

There are a few other things that one have to wonder about: the
preempt_count is currently located in the thread_info structure, but
since by definition we can't switch a thread that is preemption-locked
it should work in a percpu variable as well.

We could then play a really ugly stunt by marking NEED_RESCHED by adding
0x7fffffff to the counter.  Then the whole sequence becomes something like:

	subl $1,%fs:preempt_count
	jno 1f
	call __naked_preempt_schedule	/* Or a trap */
1:

For architectures with conditional traps the trapping option becomes
even more attractive.

	-hpa



