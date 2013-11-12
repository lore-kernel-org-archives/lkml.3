Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3KLGxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:53:01 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57381 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3KLGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:52:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131111112110.GD28302@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
	<1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
	<20131108165639.GD15074@mudshark.cambridge.arm.com>
	<CA+b37P2Yt8Hb_fgtLfw56DO=ZGC0LxVkxJHftHdxa45HQTXJcQ@mail.gmail.com>
	<20131111112110.GD28302@mudshark.cambridge.arm.com>
Date: Tue, 12 Nov 2013 12:22:51 +0530
Message-ID: <CA+b37P1REzXJabkiNEc5Ji+n6p02PfuSdaPrb-k4P25kgfkLNQ@mail.gmail.com>
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

On 11 November 2013 16:51, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Nov 11, 2013 at 05:35:37AM +0000, Sandeepa Prabhu wrote:
>> On 8 November 2013 22:26, Will Deacon <will.deacon@arm.com> wrote:
>> >> diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
>> >> new file mode 100644
>> >> index 0000000..9b491d0
>> >> --- /dev/null
>> >> +++ b/arch/arm64/include/asm/kprobes.h
>> >> @@ -0,0 +1,59 @@
>> >> +/*
>> >> + * arch/arm64/include/asm/kprobes.h
>> >> + *
>> >> + * Copyright (C) 2013 Linaro Limited
>> >> + *
>> >> + * This program is free software; you can redistribute it and/or modify
>> >> + * it under the terms of the GNU General Public License version 2 as
>> >> + * published by the Free Software Foundation.
>> >> + *
>> >> + * This program is distributed in the hope that it will be useful,
>> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> >> + * General Public License for more details.
>> >> + */
>> >> +
>> >> +#ifndef _ARM_KPROBES_H
>> >> +#define _ARM_KPROBES_H
>> >> +
>> >> +#include <linux/types.h>
>> >> +#include <linux/ptrace.h>
>> >> +#include <linux/percpu.h>
>> >> +
>> >> +#define __ARCH_WANT_KPROBES_INSN_SLOT
>> >> +#define MAX_INSN_SIZE                  2
>> >
>> > Why is this 2?
>> Second entry is to hold NOP instruction, absence of it cause abort
>> while instruction decode.
>
> Hmm, can you elaborate please? I'm not sure why you should get an abort
> decoding kernel addresses.
well, kprobes does not step from kernel address, but it prepares a
allocated memory(executable),  copies the instruction and update the
single step address (ELR) to enable stepping while ERET.
So, don't we need NOP at next location after the instruction because
next instruction will be in decode stage and might throw "undefined
instruction" error?
I have removed the trailing NOP and tested single step and it worked
fine!, so I am not sure if  MAX_INSN_SIZE can be 1, I would check v8
debug spec again.

>
>> >> +DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>> >> +DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>> >> +
>> >> +static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>> >> +{
>> >> +       int i;
>> >> +       /* prepare insn slot */
>> >> +       p->ainsn.insn[0] = p->opcode;
>> >> +       /* NOP for superscalar uArch decode */
>> >
>> > superscalar uArch?
>> well, the comment needs refining, what we mean is that one NOP should
>> follow the instruction in memory slot, for the decode stage(not to hit
>> undefined instruction).
>
> Is this undef related to your comment above?
[Yes,  again, I don't know if trailing NOP is necessary as step is
working without it -decode stage for next location is not throwing
"undefined instruction" error while single stepping previous
instruction]

>
>> > NAK. Unmasking debug exceptions from within a debug exception is not safe.
>> > I'd much rather we returned from handling this exception, then took whatever
>> > other pending exception there was.
>> well, kprobes needs recursive breakpoints to be handled, and I am not
>> sure if this can be achieved other way than unmasking D-flag for a
>> shorter duration where we can expect re-entry (I would check if this
>> can be done without re-cursing)
>> I want to understand why unmasking D-flag is unsafe here, kprobes make
>> sure that recursion depth is only 2 (i.e. does not generate 3rd
>> Breakpoint trap) and interrupts are kept masked while recursion/single
>> stepping. Is it unsafe only if conflict with hardware breakpoint on
>> same CPU?
>
> Is this recursion only to support setting kprobes on the kprobe
> implementation? The problem is that the rest of the debug infrastructure is
> not set up to deal with recursive exceptions, so allowing them can break
> state machines maintained by code like hw_breakpoint.
No, upon one kprobe hit for an address, the subsystem can call the
user-defined handlers (pre- and -post) which can call same function
again. Example, if we place kprobe on "printk" entry, and registered
handler can invoke printk to print more info.
This will make kprobe to trigger again and re-enter, so the kprobe
subsystem need to handle the 2nd instance first, and then return back
to previous execution. D-flag is enabled only the duration when the
pre- and post- handler are called, so they they can recurse and handle
single stepping, after that, D-flag is kept disabled.   I am yet to
test the concurrency with hw_breakpoint, would update once I run these
tests.

>
>> >
>> > In fact, how do you avoid a race with hardware breakpoints? E.g., somebody
>> > places a hardware breakpoint on an instruction in the kernel for which
>> > kprobes has patched in a brk. We take the hardware breakpoint, disable the
>> > breakpoint and set up a single step before returning to the brk. The brk
>> > then traps, but we must take care not to disable single-step and/or unmask
>> > debug exceptions, because that will cause the hardware breakpoint code to
>> > re-arm its breakpoint before we've stepped off the brk instruction.
>> Not sure if kprobes can work together with hardware breakpoint or kgdb
>> when multiple breakpoints (h/w and s/w) are placed on same text
>> address. How arm32 and x86 handle this kind of scenario?
>
> ARM doesn't support kernel hw breakpoints due to various limitations (we
> don't have hw single step in ARMv7).
>
>> Probably, the person debugging hardware breakpoint or kgdb should have
>> control over the flow and disable kprobes (sysfs interface available)?
>
> That sounds like a bit of a cop-out. I'd rather we understand the situation
> and, if necessary, add code so that we can deny use of kprobes if kgdb is
> active (or something similar) if we can't get the subsystems to collaborate.
Hmm, as it seems from x86 (updates from Masami), guessing it is fair
expectation that kprobes can co-exist with hardware breakpoints and
work even when happened to be both placed on same text address.
Though we have not discussed about *policy",  I think as long as this
can be fixed, we should support it.
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
