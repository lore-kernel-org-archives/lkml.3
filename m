Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJFXiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 19:38:20 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60546 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaJFXiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:38:19 -0400
Message-ID: <543327E7.4020608@amacapital.net>
Date: Mon, 06 Oct 2014 16:38:15 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>, David Daney <ddaney@caviumnetworks.com>
CC: David Daney <ddaney.cavm@gmail.com>, libc-alpha@sourceware.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx>
In-Reply-To: <20141006215813.GB23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 02:58 PM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>> On 10/06/2014 02:31 PM, Rich Felker wrote:
>>> On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:
>>>>> Userspace should play no part in this; requiring userspace to help
>>>>> make special accomodations for fpu emulation largely defeats the
>>>>> purpose of fpu emulation.
>>>>
>>>> That is certainly one way of looking at it.  Really it is opinion,
>>>> rather than fact though.
>>>
>>> It's an opinion, yes, but it has substantial reason behind it.
>>>
>>>> GLibc is full of code (see ld.so) that in earlier incantations of
>>>> Unix/Linux was in kernel space, and was moved to userspace.  Given
>>>> that there is a partitioning of code between kernel space and
>>>> userspace, I think it not totally unreasonable to consider doing
>>>> some of this in userspace.
>>>>
>>>> Even on systems with hardware FPU, the architecture specification
>>>> allows for/requires emulation of certain cases (denormals, etc.)  So
>>>> it is already a requirement that userspace cooperate by always
>>>> having free space below $SP for use by the kernel.  So the current
>>>> situation is that userspace is providing services for the kernel FPU
>>>> emulator.
>>>>
>>>> My suggestion is to change the nature of the way these services are
>>>> provided by the userspace program.
>>>
>>> But this isn't setup by the userspace program. It's setup by the
>>> kernel on program entry. Despite that, though, I think it's an
>>> unnecessary (and undocumented!) constraint; the fact that it requires
>>> the stack to be executable makes it even more harmful and
>>> inappropriate.
>>>
>>
>> The management of the stack is absolutely done by userspace code.
>> Any time you do pthread_create(), userspace code does mmap() to
>> allocate the stack area, it then sets permissions on the area, and
>> then it passes the address of the area to clone().
> 
> This is hardly management.
> 
>> Furthermore the
>> userspace code has to be very careful in its use of the $sp
>> register, so that it doesn't store data in places that will be
>> used/clobbered by the kernel.
> 
> This is not "being careful". The stack pointer can never become
> invalid unless you do wacky things in asm or invoke UB.

I disagree a bit here.  There are runtimes that aren't libc or even C at
all.  See, for example, Go.  (Ugh!)

What happens if a signal happens while executing from this magic
trampoline?  Allocation of another one?  Crash on return from the outer
trampoline invocation?

Also, if this ends up being solved with a hack of this type, please do
it right: have *two* aliases of the trampoline, one writable, and one
executable (unless the MIPS kernel can bypass write-protection).


> 
>> All of this is under the control of the userspace program and done
>> with userspace code.
> 
> For the most part it just happens by default. There is no particular
> intentionality needed, and certainly no hideous MIPS-specific hacks
> needed.
> 
>> I appreciate the fact that libc authors might prefer *not* to write
>> more code, but they could, especially if they wanted to add the
>> feature of non-executable stacks to their library implementation.
> 
> So your position is that:
> 
> 1. A non-exec-stack system can only run new code produced to do extra
>    stuff in userspace.
> 
> 2. The startup code needs to do special work in userspace on MIPS to
>    setup an executable area for fpu emulation.
> 
> 3. Every call to clone/CLONE_VM needs to be accompanied by a call to
>    mmap and this new syscall to set the address, and every call to
>    SYS_exit needs to be accompanies by a call to munmap for the
>    corresponding mapping.
> 
> This is a huge ill-designed mess.

Amen.

Can the kernel not just emulate the instructions directly?  Can it
single-step through them in place?

FWIW, I have considered playing trampoline games like this on x86.  It's
a giant bloody mess, and it will almost certainly never happen, even
though the performance win is dramatic.  No, you don't want to know why. [1]

[1] If you actually want to know, imagine returning from a page fault
with sysret.

--Andy
