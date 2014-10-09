Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaJIXsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:48:22 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:40193 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJIXsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:48:18 -0400
Message-ID: <54371EBC.6070805@imgtec.com>
Date: Thu, 9 Oct 2014 16:48:12 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <Zubair.Kakakhel@imgtec.com>, <geert+renesas@glider.be>,
        <david.daney@cavium.com>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <richard@nod.at>,
        <zajec5@gmail.com>, <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <akpm@linux-foundation.org>, <lars.persson@axis.com>
Subject: Re: [PATCH v2 0/3] MIPS executable stack protection
References: <20141009195030.31230.58695.stgit@linux-yegoshin> <5437015B.3010205@gmail.com> <543709D0.6000501@imgtec.com> <5437134E.5040601@caviumnetworks.com>
In-Reply-To: <5437134E.5040601@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 03:59 PM, David Daney wrote:
>
>>>
>>>>
>>>> Note: actual execute-protection depends from HW capability, of course.
>>>>
>>>> This patch is required for MIPS32/64 R2 emulation on MIPS R6
>>>> architecture.
>>>> Without it 'ssh-keygen' crashes pretty fast on attempt to execute
>>>> instruction
>>>> in stack.
>>>
>>> There is much more blocking MIPS32/64 R2 emulation on MIPS R6 than
>>> just this patch isn't there?
>>
>> This one is critical - ssh-keygen crashes during running MIPS R2. I have
>> a patch in my R6 repository but GLIBC still can't set stack executable
>> and security suffers.
>
> But is the R6 code already in the lmo or kernel.org repositories?
>
> If not, then the lack of this patch is not a gating issue.  If this 
> patch is really needed for R6 support, why not submit the R6 
> prerequisite patches first?

Because -

1) security concern still does exist for MIPS R5 (MIPS R2 has no RI/XI 
support, it was defined in MIPS R3 but for simplicity it is referred as 
"MIPS R2")
2) GLIBC need that to start development


>
> If this patch has nothing to do with MIPS R6, then state that.

It has value for both - MIPS R5 and MIPS R6.

>
>>
>>>
>>> Also, if you are supporting MIPS R6, this patch doesn't even work,
>>> because it doesn't handle PC relative instructions at all.
>>
>> It seems like you missed my statement - adding support for PC-relative
>> instruction is just 5 lines of code. I just refrain from this until
>> toolchain starts generating that.
>
> How can it be just 5 lines of code?  You have to emulate all those 
> instructions:
>
>   ADDIUPC
>   AUIPC
>   ALUIPC
>   LDPC
>   LWPC
>   LWUPC
>
> I think that is all of them.  You can emulate all of those in 5 lines 
> of code?

You misread my statement - 5 lines of code for PC-related instruction. 
And only ADDIUPC is a part of microMIPS R2 which I can emulate.
But we discuss something insignificant, MIPS R6 load instructions takes 
more, of course, but definitely less than LWL/LWR/LDL/LDR which I should 
emulate anyway and do.

>
> We need to support everything the toolchain could product in the 
> future.  I don't think it makes sense to add all this stuff when it is 
> well known that it doesn't solve the problem for MIPS R6, especially 
> when the justification for the patch is that it is needed for R6.
>
> I understand what your goals are here, I have spend many months 
> working towards a non-executable stack (see the patches that moved the 
> signal trampolines off the stack).  But I am worried that there are 
> many cases that it will not handle.
>
>>
>> Besides that, this version 2 of patch just passed 20-22 hours on P5600
>> and Virtuoso (no FPU on both) under SOAK test and it gets around 1 per
>> hour of signal right at emulated instruction in VDSO and unwind works
>> (as I can see in debug prints).
>>
>
> I'm not saying that the patch doesn't work under your highly 
> constrained test conditions, I believe that it does.
>
> I am not familiar with the SOAK test.  Does it really put faulting 
> instructions the delay slots of FP branch instructions, catch the 
> resulting signal, and then throw an exception from the signal handler?

Yes, the debug output shows me that. "from the signal handler" -> "to 
the signal handler"?

>
>
>>>
>>>
>>> The recent discussions on this subject, including many comments from
>>> Imgtec e-mail addresses, brought to light the need to use an
>>> instruction set emulator for newer MIPSr6 ISA processors.
>>
>> In Imgtec I am only one who works on MIPS R6 SW and FPU branch emulation
>> and I say you - it is not needed, this solution is enough.
>
> It can't be true the PC relative support is not needed, why did you 
> add the PC relative instructions, if you didn't want to use them in 
> Linux userspace?

Sorry, I misunderstood you here - I assume you told here about FULL 
INSTRUCTION SET emulator. Of course, some emulation is needed like PC 
relative instructions, but not a full instruction set. I never said that 
PC-relative instruction doesn't require an emulation.

But see your point (1) below, if you retract from that HERE, please 
confirm the difference - do you want a full instruction set emulator or 
you speak about only PC relative instructions?

 > Here is my proposal:

 > 1) Add an emulator for all documented MIPS R6 instructions that can 
appear in a linux userspace delay slot.

 > 2) Document as not supported placing COP2 instructions in FP branch 
delay slots.

 > 3) Get rid of this execute-out-of-line code in the FPU emulator all 
together.

 > 4) Enable non-execute stack.

 > In order to have full MIPS R6 support in the kernel, you will need an 
emulator for a subset of the instructions anyhow.  Going to a full ISA 
emulator will be a little
 > more work, but it shouldn't be too hard.

It is too restrictive and kills the idea of customised processor.

- Leonid.

