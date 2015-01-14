Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbANWYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:24:55 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49358 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbANWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501141110190.5526@nanos>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
 <1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com>
 <CAL_JsqJ5DSo6jmAuHPDdV6pMca8BVbg5V-GZ5=2qu96_QYXMtQ@mail.gmail.com> <alpine.DEB.2.11.1501141110190.5526@nanos>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 14 Jan 2015 16:24:32 -0600
Message-ID: <CAL_JsqLwBvV5s531_YsA=sCE4_LG=eXTua8mh069ufRjSNFhng@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] irqchip: add dumb demultiplexer implementation
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 4:36 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 13 Jan 2015, Rob Herring wrote:
>> On Tue, Jan 13, 2015 at 12:46 PM, Boris Brezillon
>> <boris.brezillon@free-electrons.com> wrote:
>> > Some interrupt controllers are multiplexing several peripheral IRQs on
>> > a single interrupt line.
>> > While this is not a problem for most IRQs (as long as all peripherals
>> > request the interrupt with IRQF_SHARED flag set), multiplexing timers and
>> > other type of peripherals will generate a WARNING (mixing IRQF_NO_SUSPEND
>> > and !IRQF_NO_SUSPEND is prohibited).
>> >
>> > Create a dumb irq demultiplexer which simply forwards interrupts to all
>> > peripherals (exactly what's happening with IRQ_SHARED) but keep a unique
>> > irq number for each peripheral, thus preventing the IRQF_NO_SUSPEND
>> > and !IRQF_NO_SUSPEND mix on a given interrupt.
>>
>> This really seems like a work-around for how IRQF_SHARED works. It
>
> It's a workaround for a short coming of IRQF_SHARED.
>
> IRQF_SHARED has a massive short coming versus suspend and wakeup
> interrupts. If one of the demultiplexed interrupts is a valid wakeup
> source then we have no sane way to express this with IRQF_SHARED
> simply because the drivers need to be aware whether they run on stupid
> or well designed hardware.

Unfortunately, the drivers will still have to know this. They cannot
assume that they can call disable_irq and their device irq state does
not matter.

Perhaps we need a debug feature such that disable_irq/enable_irq are
nops with IRQF_SHARED?

>> seems like what is really desired is just per handler disabling. It is
>
> So you want a magic API like disable/enable_irq_action()?
>
> Certainly not.

Agreed.

> You'd open just another can of worms which will bring us abuse and
> hard to debug problems because driver writers think it's a good idea
> to use it for random purposes.
>
> Aside of that it would add another conditional into the interrupt
> delivery hotpath which is not desired either.
>
>> fragile in that devices can deadlock the system if the drivers don't
>> disable the interrupt source before calling disable_irq. But unlike
>
> Any misdesigned driver can do that for you.
>
>> IRQF_SHARED, there is nothing explicit in the driver indicating it is
>> designed to work properly with a shared interrupt line.
>
> IRQF_SHARED is a pretty bad indicator. Look at all the drivers which
> slap this flag onto request_irq() and have no single line of code
> which makes sure that the driver would ever work on a shared line.
>
> If it's just for annotational purposes, we can add a new IRQF flag,
> which is required to request such a interrupt line.
>
>> I see no reason to accept this into DT either. We already can support
>> shared lines and modeling an OR gate as an interrupt controller is
>> pointless.
>
> It's absolutely not pointless.
>
> All attempts to work around that have resulted in horrible bandaids so
> far. That's why I guided Boris to implement this dummy demultiplexing
> mechanism. It solves the problem at hand nicely without adding nasty
> hackarounds into the suspend/resume code and inflicting platform
> knowledge on multi-platform device drivers.

This change will break on old kernels with a new dtb. Would you be
happy if a BIOS update required a new kernel? Fixing this for any
platform requires a dtb update which may not be possible on some
platforms. I don't have a problem with this breakage for 1 platform
and the at91 guys may not care, but we'd ultimately be changing how
all shared irqs are specified for all DT. Maybe we decide that this is
how we want to describe things, but that needs much wider discussion
and agreement.

> If you have a proper solution for the problem at hand which
>
>    - avoids the demux dummy
>
>    - works straight forward with suspend/resume/wakeup
>
>    - does not add horrible new APIs
>
>    - does not add conditionals to the interrupt hotpath
>
>    - does not inflict platform knowledge about interrupt chip details
>      on drivers
>
> then I'm happy to take it.
>
> But as long as you can't come up with anything sane, the demux dummy
> is the best solution for this problem we've seen so far.

What if during suspend you move all actions w/o IRQF_NO_SUSPEND to a
suspended action list? This would leave only the actions with
IRQF_NO_SUSPEND set in the active action list. The cost would be a
pointer in irq_desc and moving the actions during suspend and resume.

There are probably ways to do this demux irqchip without a DT change.
Since we can't just move Linux irq numbers to different irq_chips
during request_irq, we would have to parse the DT up front to find all
shared interrupts and create a demux irqchip for them. That wouldn't
be very efficient, but is straight-forward. Then we'd have to handle
the translation into Linux irq numbers correctly which is probably the
more difficult part.

Rob
