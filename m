Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbaGPRVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:21:44 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:52430 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593AbaGPRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <53C6761A.9090002@linaro.org>
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
	<CAB5oZtCk5NwBJF+dBESKGhYabti=EWWtF2jJYK7HdyNHM46nTw@mail.gmail.com>
	<53C4F745.3070701@linaro.org>
	<201407152045.06517.marex@denx.de>
	<53C6761A.9090002@linaro.org>
Date: Wed, 16 Jul 2014 19:21:40 +0200
Message-ID: <CAB5oZtCWe2Z4PqUaMBzmO-W_UH3Hau4U8Yw+9ca71wTUksWs8w@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] arm: KGDB NMI/FIQ support
From: Harro Haan <hrhaan@gmail.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Marek Vasut <marex@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        patches@linaro.org, kgdb-bugreport@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        John Stultz <john.stultz@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>, Detlev Zundel <dzu@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 14:54, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> On 15/07/14 19:45, Marek Vasut wrote:
>>>> I can reduce the number of occurrences (not prevent it) by adding the
>>>> following hack to irq-gic.c
>>>> @@ -297,10 +309,12 @@ static asmlinkage void __exception_irq_entry
>>>> gic_handle_irq(struct pt_regs *regs
>>>>
>>>>   u32 irqstat, irqnr;
>>>>   struct gic_chip_data *gic = &gic_data[0];
>>>>   void __iomem *cpu_base = gic_data_cpu_base(gic);
>>>>
>>>>   do {
>>>>
>>>> + while(readl_relaxed(gic_data_dist_base(gic) + GIC_DIST_PENDING_SET)
>>>> & (1 << 30))
>>>> +   printk(KERN_ERR "TEMP: gic_handle_irq: wait for FIQ exception\n");
>>>>
>>>>   irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>>>>   irqnr = irqstat & ~0x1c00;
>>>
>>> I've made a more complete attempt to fix this. Could you test the
>>> following? (and be prepared to fuzz the line numbers)
>>
>> There's also another workaround, look at [1], but it's really a perverse hack
>> thus far (blush). What I did there is I got hinted that an L1 page table can
>> have this NS bit set. If this bit is set for a mapping, all accesses to memory
>> area via that mapping will be non-secure. And then, in turn, by doing a non-
>> secure read of the INTACK register, it will not ever happen that the FIQ number
>> will pop up in the INTACK. I only do a non-secure read of the INTACK register,
>> all other registers of the GICv1 are read via regular secure-mode accesses.
>
> I'll be looking into this approach.
>
> It is technically a better approach than mine since it prevents the IRQ
> handler from ever reading a group 0 interrupt from INTACK.

Agree, preventing the problem is better than fixing it afterwards.

>
> Unfortunately the tentacles of this workaround reach pretty deep in the
> memory management code (rather than being concentrated in the GIC
> driver) but the improved runtime behaviour might be worth it.

I did some worst case measurements on the SabreSD while running:
$ while true; do hackbench 20; done &

Use banked non-secure GIC_CPU_INTACK register for regular interrupts
(patches by Marek):
The FIQ handler reads the TWD_TIMER_COUNTER 2570 ticks (which is x
1000 / 498 = 5161 nsec) after FIQ interrupt ID30 is generated.
The average is around 497 ticks.
The minimum is around 34 ticks.

Use re-trigger approach by putting it back to pending state (latest
patch by Daniel):
The FIQ handler reads the TWD_TIMER_COUNTER 2678 ticks (which is x
1000 / 498 = 5378 nsec) after FIQ interrupt ID30 is generated.
The average is around 563 ticks (note: almost everything is normal path)
The minimum is around 34 ticks (note: this is the normal path, not the
re-trigger path)

So the results are quite similar.
