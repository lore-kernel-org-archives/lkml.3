Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3KOPCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:02:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47853 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3KOPCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:02:24 -0500
Message-ID: <5286372F.3000302@ti.com>
Date: Fri, 15 Nov 2013 10:01:03 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Sricharan R <r.sricharan@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>, "rnayak@ti.com" <rnayak@ti.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "nm@ti.com" <nm@ti.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>
Subject: Re: [PATCH V4 1/4] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable
 irqs
References: <1384431530-2166-1-git-send-email-r.sricharan@ti.com> <1384431530-2166-2-git-send-email-r.sricharan@ti.com> <20131114140103.GA28328@e106331-lin.cambridge.arm.com> <5284FE6C.9040901@ti.com> <20131115112329.GE1709@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131115112329.GE1709@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 November 2013 06:23 AM, Mark Rutland wrote:
> On Thu, Nov 14, 2013 at 04:46:36PM +0000, Sricharan R wrote:
>> Hi Mark,
>>
>> On Thursday 14 November 2013 07:31 PM, Mark Rutland wrote:
>>> On Thu, Nov 14, 2013 at 12:18:47PM +0000, Sricharan R wrote:
>>>> In some socs the gic can be preceded by a crossbar IP which
>>>> routes the peripheral interrupts to the gic inputs. The peripheral
>>>> interrupts are associated with a fixed crossbar input line and the
>>>> crossbar routes that to one of the free gic input line.
>>>>
>>>> The DT entries for peripherals provides the fixed crossbar input line
>>>> as its interrupt number and the mapping code should associate this with
>>>> a free gic input line. This patch adds the support inside the gic irqchip
>>>> to handle such routable irqs. The routable irqs are registered in a linear
>>>> domain. The registered routable domain's callback should be implemented
>>>> to get a free irq and to configure the IP to route it.
>>>>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Tony Lindgren <tony@atomide.com>
>>>> Cc: Rajendra Nayak <rnayak@ti.com>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Grant Likely <grant.likely@linaro.org>
>>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>>>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>> ---
>>>>  [V2] Added default routable-irqs functions to avoid
>>>>       unnecessary if checks as per Thomas Gleixner comments
>>>>       and renamed routable-irq binding as per
>>>>       Kumar Gala <galak@codeaurora.org> comments.
>>>>
>>>>  [V3] Addressed unnecessary warn-on and updated default
>>>>       xlate function as per Thomas Gleixner comments
>>>>
>>>>  Documentation/devicetree/bindings/arm/gic.txt |    6 ++
>>>>  drivers/irqchip/irq-gic.c                     |   81 ++++++++++++++++++++++---
>>>>  include/linux/irqchip/arm-gic.h               |    7 ++-
>>>>  3 files changed, 83 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>>>> index 3dfb0c0..5357745 100644
>>>> --- a/Documentation/devicetree/bindings/arm/gic.txt
>>>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>>>> @@ -49,6 +49,11 @@ Optional
>>>>    regions, used when the GIC doesn't have banked registers. The offset is
>>>>    cpu-offset * cpu-nr.
>>>>  
>>>> +- arm,routable-irqs : Total number of gic irq inputs which are not directly
>>>> +		  connected from the peripherals, but are routed dynamically
>>>> +		  by a crossbar/multiplexer preceding the GIC. The GIC irq
>>>> +		  input line is assigned dynamically when the corresponding
>>>> +		  peripheral's crossbar line is mapped.
>>> I'm not keen on the design of the arm,routable-irqs property. The set of
>>> IRQs which the crossbar IP can use is a property of which IRQ lines it
>>> has routed to the GIC. I don't see why that should be considered a
>>> property of the GIC; it's a property of the crossbar IP's attachment to
>>> the GIC.
>>>
>>> Given we already have a mechanism for describing the attachment (i.e.
>>> the interrupts property) where the property appears on the node for the
>>> device generating/propagating the interrupt, I don't see why we should
>>> do differently here.
>>  We did try using interrupts=<> property for all peripherals and
>>  mapping them as crossbar's parent. But that approach of representing
>>  crossbar as a interrupt parent was not accepted, since the crossbar
>>  was just routing the interrupts from peripherals to GIC and nothing more.
>>  Also  mapping all the interrupts using interrupt-map like property by a fixed way
>>  in DTS itself was considered hacky
> 
> I'm not suggesting you should interrupt-map. I agree that that
> interrupt-map is not suitable for a dynamically configurable device like
> the crossbar.
> 
> When you say that the crossbar is just routing the interrupts, at what
> level is it doing so? Does it accept a logical interrupt and output
> another logical interrupt, or does it just connect the two lines
> electrically?
> 
Its just makes electrical connection between input and output line and
thats it.

Regards,
Santosh
