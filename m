Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3B0Jw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:52:57 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:64646 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3B0Jwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:52:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130227085216.GC30395@linux-sh.org>
References: <20130218142834.28739.39417.sendpatchset@w520>
	<20130227082335.GB30395@linux-sh.org>
	<CANqRtoSbiPhRbDsZppkJ+F48tEmuCdSfVRo3dTs9cEUxfvLopA@mail.gmail.com>
	<20130227085216.GC30395@linux-sh.org>
Date: Wed, 27 Feb 2013 18:52:51 +0900
Message-ID: <CANqRtoTFgHDKpb52HCRD=11ds_zKgLammcnymF719L9u4v3fvg@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 5:52 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, Feb 27, 2013 at 05:35:51PM +0900, Magnus Damm wrote:
>> On Wed, Feb 27, 2013 at 5:23 PM, Paul Mundt <lethal@linux-sh.org> wrote:
>> > So how exactly does this interact with the existing sh_intc code? Or is
>> > there some reason why you have opted to bypass it in order to implement a
>> > simplified reduced-functionality version of INTC support focused only on
>> > external pins? If both are used together this is going to be a nightmare
>> > for locking, and it's also non-obvious how the IRQ domains on both sides
>> > will interact.
>> >
>> > This needs a lot more explanation.
>>
>> Recent GIC-based SoCs do not make use of INTC for any on-chip I/O
>> devices. This driver is meant to be used as a layer between the actual
>> IRQ pin and the GIC. Anything else needs the full driver. The existing
>> non-DT INTC driver can happily coexist with this driver like it does
>> in the case of sh73a0 here:
>>
>> [PATCH 02/03] ARM: shmobile: INTC External IRQ pin driver on sh73a0
>>
> Ok, thanks for clarifying.
>
> I suppose the main concern is how quickly this will simply turn in to a
> deviated partial implementation of the full driver as newer SoCs begin
> deviating from your simplified case, and we basically end up
> reimplementing sh_intc anyways.

As you know, the INTC code that you are referring to is a full
interrupt controller designed to work directly with CPU cores like SH
and ARM. Newer ARM cores like Cortex-A9 all include the GIC both for
IPI purpose in case of SMP and they also implement SPI functionality
for I/O device interrupts. So the need for vendor-specific interrupt
controller IP is almost down to nothing these days.

With that in mind I do really doubt that we end up reimplementing
sh_intc. The upcoming designs that I am aware of do not change their
external IRQ pin hardware to force us to update this driver. What
happens after that I'm afraid I can't say. =)

>> The driver is not meant to be used with INTC-only based systems like
>> sh7372 and the SH architecture. I would be very happy if someone could
>> get their shit together and fix up DT support for the common INTC
>> code. This has not happened yet though. So if you know anyone with
>> time to spare then feel free to suggest them to work together with
>> Iwamatsu-san to get the DT version of the code reviewed together with
>> Linaro.
>>
> I haven't heard or seen anything new on that in some time, so I assumed
> the work had stalled. I'm not sure why there wasn't more effort put in to
> DT support for the INTC code rather than simply coming up with a
> temporary bypass shim, and I'm not sure why you think this work is
> blocked by anyone (unless you're just referring to a general lack of
> resources).

I mainly wrote this driver to support the r8a7779 SoC which can't be
driven by the existing INTC code base. During development I decided to
try to share the driver between multiple GIC-based SoCs like r8a7779
and sh73a0. The reason behind trying to share this driver between
multiple SoCs is to remove SoC-specific hacks that can't be dealt with
by the existing INTC code.

> In any event, I'm not sure what the best option for the interim is. I
> suppose we can merge the irqchips until the INTC stuff catches up, but
> then we are probaby going to run in to a situation where they either have
> to co-exist, or the irqchips are removed and the sh_intc code has to
> carry a compat shim to deal with those DT bindings. Neither of those
> options seem particularly appealing to me.

I don't really understand why you would want to use a generic table
driven driver when you have the possibility of using a
hardware-specific driver. I suppose you are wondering why no one seems
to be working on INTC DT support at this point. The truth is that we
got very little feedback and development support with interrupts in
general last autumn and on top of that our developers went their own
way instead of following advice.

Anyway, I do understand your worry about what happens if the hardware
starts to deviate, but judging by the future devices that I've seen we
should be ok for a while. Beyond that no one can tell.

Thanks,

/ magnus
