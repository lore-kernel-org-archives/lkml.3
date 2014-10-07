Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaJGAtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:49:19 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61194 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaJGAtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <543334CE.8060305@caviumnetworks.com>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 6 Oct 2014 17:48:55 -0700
Message-ID: <CALCETrWHYaZSVC_V2h4fSxSpHh5D6RPHG8VupKUjCJGiwpwmyg@mail.gmail.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
To: David Daney <ddaney@caviumnetworks.com>
Cc: Rich Felker <dalias@libc.org>, David Daney <ddaney.cavm@gmail.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 5:33 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> On 10/06/2014 05:05 PM, Rich Felker wrote:
>>
>> On Mon, Oct 06, 2014 at 04:48:52PM -0700, David Daney wrote:
>>>
>>> On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
>>>>
>>>> On 10/06/2014 02:58 PM, Rich Felker wrote:
>>>>>
>>>>> On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>>>
>>> [...]
>>>>>
>>>>> This is a huge ill-designed mess.
>>>>
>>>>
>>>> Amen.
>>>>
>>>> Can the kernel not just emulate the instructions directly?
>>>
>>>
>>> In theory it could, but since there can be implementation defined
>>> instructions, there is no way to achieve full instruction set
>>> coverage for all possible machines.
>>
>>
>> Is the issue really implementation-defined instructions with delay
>> slots?
>
>
> It is the instructions in the delay slots, not the branch instructions
> themselves that are of interest.  But, for the sake of the arguments, this
> is not a critical point.
>
>> If so it sounds like a made-up issue.
>
>
> It is not a made up issue.
>
> If you want an architecture that has a well defined instruction set, stick
> with x86, Intel will tell you what is good for you and you will take
> whatever they give you.
>
> If you want an architecture where you can add implementation defined
> instructions to do whatever you want, then you use an architecture like
> MIPS.
>
>> They're not going to
>> occur in real binaries. Certainly a compiler is not going to generate
>> implementation-defined instructions,
>
>
> Why not?  It will emit any instructions we care to make it emit.  If we want
> it to emit crypto instructions with patented algorithms, then it will do
> that.  But we would still like to use a generic kernel with generic FPU
> support.
>
> The most straight forward way (and the currently implemented way) of doing
> this is to execute the instructions in question out-of-line (on the
> userspace stack).
>
> The question here is:  What is the best way to get to a non-executable
> stack.
>
> The consensus among MIPS developers is that we should continue using the
> out-of-line execution trick, but do it somewhere other than in stack memory.
>
> One way of doing this is to have the kernel magically generate thread local
> memory regions.
>
> Another option is to have userspace manage the out-of-line execution areas.
>
> As is often the case, each approach has different pluses and minuses.

Your patch is still buggy.  Imagine this sequence:

Daft userspace code does:

emulated fp branch to elsewhere (not taken)
insn 1
insn 2

The kernel shoves insn1 and insn2 in this magic trampoline and
re-enters user code there.

An asynchronous signal happens before insn1 executes.

The signal hander runs similar daft code, gets fixed up and returns
*to the now-overwritten trampoline*.  Boom.  This kind of failure mode
is why using any kind of magic trampoline sucks on all architectures.

Even the current code might have the same bug for all I know -- are
really updating the stack pointer when you emulate these instructions?
 Do you have a redzone for exactly this purpose?  Does the MIPS signal
delivery code check to see whether you're executing off the stack
outside of the ABI-protected region?


Given that this is documented as an ABI change, I'll ask again: can
you demand that user code that wants the ABI-breaking non-executable
stack must not do this?  IOW, binaries that claim to work with
non-executable stacks must not have fp branches (or alternatively must
not have anything other than nops in the delay slots of possibly
emulated FP branches)?  Or you could be polite and explicitly define
the set of instructions that are safe in fp branch delay slots.

(Also, seriously, fp branches have usable delay slots?  Wow!)

--Andy
