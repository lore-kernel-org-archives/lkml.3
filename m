Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161924Ab3LFWN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:13:26 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55695 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161864Ab3LFWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:12:43 -0500
MIME-Version: 1.0
In-Reply-To: <201312052107.07197.arnd@arndb.de>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
 <201312031601.04997.arnd@arndb.de> <CAGVrzcbxHA+S0yZbsrj8uMZR0hsb_ng=PB02zte7S0rCZWQpBg@mail.gmail.com>
 <201312052107.07197.arnd@arndb.de>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 6 Dec 2013 14:12:03 -0800
Message-ID: <CAGVrzcYha7y2pQ-tFtu19ZAN3DVWVAJOt_0UPEU6e5KfuBnMjA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based
 Broadcom STB SoCs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Carino <marc.ceeeee@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/5 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 05 December 2013, Florian Fainelli wrote:
>> 2013/12/3 Arnd Bergmann <arnd@arndb.de>:
>> >
>> >> +     addr = ioremap(BPHYSADDR(BCHP_IRQ0_IRQEN), sizeof(u32));
>> >> +     writel_relaxed(BCHP_IRQ0_IRQEN_uarta_irqen_MASK
>> >> +             | BCHP_IRQ0_IRQEN_uartb_irqen_MASK
>> >> +             | BCHP_IRQ0_IRQEN_uartc_irqen_MASK, addr);
>> >> +     iounmap(addr);
>> >
>> > What does this part do? Isn't that something that should have been set
>> > up by the boot loader?
>>
>> The bootloader will typically use the UART in busy-looping mode and
>> not rely on interrupts, also the bootloader currently does not know
>> much about how many UARTs there are in the system and how they are
>> going to be used.
>
> Well, it should at least know how many ports are wire up and be able
> to set them up to a working state.
>
>> One possible way to solve this would be to write a very small irqchip
>> driver which only implements the "irq_enable" method to allow these
>> interrupts to be forwarded to the GIC. Somewhere in the Device Tree we
>> would have an interrupt-map property which describes the mapping
>> between the bits in BCHP_IRQ0_IRQEN and their corresponding
>> peripherals (UARTA, B, C).
>>
>> Would that work?
>
> I think that would work, but it's getting into the overdesign territory.
> Can you clarify why this register exists in the first place and what
> makes it necessary to set it up? Are there similar registers for all
> other IRQs?

This BCHP_IRQ0 register is kind of special and only acts as an
interrupt forwarder. Not enabling the IRQEN bit will prevent the UART
interrupts to be raised at the GIC level. Now that I think about this
some more, we might just go with some sort of special node which
contains a mask of the interrupts and apply this mask to the
corresponding hardware register? There is no need for this to be
modelled as an interrupt controller because this really is not a real
one.
-- 
Florian
