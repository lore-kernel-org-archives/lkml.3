Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab3KRGoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 01:44:03 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56237 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3KRGny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 01:43:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131115163718.GH19468@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
	<20131108165639.GD15074@mudshark.cambridge.arm.com>
	<CA+b37P2Yt8Hb_fgtLfw56DO=ZGC0LxVkxJHftHdxa45HQTXJcQ@mail.gmail.com>
	<20131111112110.GD28302@mudshark.cambridge.arm.com>
	<CA+b37P1REzXJabkiNEc5Ji+n6p02PfuSdaPrb-k4P25kgfkLNQ@mail.gmail.com>
	<20131115163718.GH19468@mudshark.cambridge.arm.com>
Date: Mon, 18 Nov 2013 12:13:53 +0530
Message-ID: <CA+b37P1foRWLWk_5VqvXGe8L=F6yHXysoKLkS5My3L=r_r15+A@mail.gmail.com>
Subject: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 22:07, Will Deacon <will.deacon@arm.com> wrote:

>> well, kprobes does not step from kernel address, but it prepares a
>> allocated memory(executable),  copies the instruction and update the
>> single step address (ELR) to enable stepping while ERET.
>> So, don't we need NOP at next location after the instruction because
>> next instruction will be in decode stage and might throw "undefined
>> instruction" error?
>
> You can't take speculative prefetch aborts like that, so unless you actually
> go and *execute* garbage, you don't need that NOP. From the sounds of it, it's
> not required, as long as you handle the step exception correctly.
Ok, the stepping is for exactly one instruction, after trapping again
stepping is disabled.
so clear that NOP is not necessary. I will remove NOP in next version.

>> > Is this recursion only to support setting kprobes on the kprobe
>> > implementation? The problem is that the rest of the debug infrastructure is
>> > not set up to deal with recursive exceptions, so allowing them can break
>> > state machines maintained by code like hw_breakpoint.
>> No, upon one kprobe hit for an address, the subsystem can call the
>> user-defined handlers (pre- and -post) which can call same function
>> again. Example, if we place kprobe on "printk" entry, and registered
>> handler can invoke printk to print more info.
>
> Hang on, I think I'm missing something here. If you run into a recursive
> probe, you'll simply hit another BRK instruction, right? That should be
> fine, since PSTATE.D doesn't mask software breakpoint exceptions. The
> tricky part comes when you try to step over that guy, but you might be ok
> if you clear PSTATE.D *only* while you step your single instruction that you
> copied out to the buffer.
Yes exactly, D-flag was enabled so that single step can run on BRK
handler code! exactly once. So I was unmasking D-flag before
taking(expecting) a BRK so that saved spsr_el1 in pt_regs have it
stored and restore when return with single stepping!
I agree with your suggestion to unmask D-flag just before ERET for
stepping, makes more sense, is it as simple as updating pt_regs
(regs->pstate)?

>
> What do you think? I'd really like you to try testing something like:
>
>   1. Place a hardware breakpoint in the kernel
>   2. Place a kprobe on the same address
>   3. Place a kprobe somewhere in the pre- hook for the kprobe placed in (2)
>
> then check that (a) we manage to get through that lot without locking up and
> (b) each probe/breakpoint is hit exactly once.
Ok, will do, this can be easily done with kprobing "printk" with pre-
handler invoking printk, and then placing a hw_breakpoint.  (also we
need to check for kprobe-watchpoint concurrency right?)
I would update with results.

>
>> This will make kprobe to trigger again and re-enter, so the kprobe
>> subsystem need to handle the 2nd instance first, and then return back
>> to previous execution. D-flag is enabled only the duration when the
>> pre- and post- handler are called, so they they can recurse and handle
>> single stepping, after that, D-flag is kept disabled.   I am yet to
>> test the concurrency with hw_breakpoint, would update once I run these
>> tests.
>
> If you really want to support this, you need to do more than just clear the
> D flag. Not only do you need to deal with hardware breakpoints, but also
> things like scheduling... Assuming that the user-defined handlers can block,
> then you run the risk of context-switching with the D-flag set, which
> introduces a significant black-out period to kernel debugging. There are
> also issues like returning to userspace with MDSCR_EL1.SS set because of a
> context switch triggered by the pre- handler, resulting in a single-step
> exception from userspace.
kprobe user-defined handlers should not block no blocking calls) and
this is one of the requirements of kprobes, so we cannot manage
context-switching or interrupts until the kprobe trap is completely
handled. So, we basically disable local interrupts throughout
exception handler.

Masami,
kprobe framework cannot check if the  supplied user-handlers can block
right? and blocking call would cause undesired sequences, how to
handle this? (recommendations/policies?)

>
> I reckon what I suggested above might work, but I'd like your input.
Sure, would come back with more clear picture after running all tests
and making the changes as per your suggestion.

Thanks for reviewing this in detail,
-Sandeepa
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
