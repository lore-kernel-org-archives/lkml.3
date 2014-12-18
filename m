Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaLRDOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:14:37 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48188 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaLRDOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:14:35 -0500
MIME-Version: 1.0
In-Reply-To: <1533637.nrBHixev6I@avalon>
References: <20141215050920.533.20169.sendpatchset@w520>
	<52558289.TJpHJaW3sy@avalon>
	<CANqRtoS34Jf+ztJYpt1faCkNQk-V0vihgxjWj2Sn61YWKZepJQ@mail.gmail.com>
	<1533637.nrBHixev6I@avalon>
Date: Thu, 18 Dec 2014 12:14:33 +0900
Message-ID: <CANqRtoTrBx=wscHCCRDw2SRrA_YWbCB3+q7aOdvQjiiCkSan+Q@mail.gmail.com>
Subject: Re: [PATCH] irqchip: renesas-intc-irqpin: r8a7779 IRLM setup support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Dec 18, 2014 at 11:39 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Thursday 18 December 2014 10:26:27 Magnus Damm wrote:
>> On Thu, Dec 18, 2014 at 6:41 AM, Laurent Pinchart wrote:
>> > On Monday 15 December 2014 14:09:20 Magnus Damm wrote:
>> >> From: Magnus Damm <damm+renesas@opensource.se>
>> >>
>> >> Add r8a7779 specific support for IRLM bit configuration
>> >> in the INTC-IRQPIN driver. Without this code we need
>> >> special workaround code in arch/arm/mach-shmobile.
>> >>
>> >> The IRLM bit for the INTC hardware exists on various
>> >> older SH-based SoCs and is used to select between two
>> >> modes for the external interrupt pins IRQ0 to IRQ3:
>> >>
>> >> IRLM = 0: (default from reset on r8a7779)
>> >> In this mode the pins IRQ0 to IRQ3 are used together
>> >> to give a value between 0 and 15 to the SoC. External
>> >> logic is required for masking. This mode is not
>> >> supported by the INTC-IRQPIN driver.
>> >>
>> >> IRLM = 1: (needs this patch or configuration elsewhere)
>> >> In this mode IRQ0 to IRQ3 operate as 4 individual
>> >> external interrupt pins. In this mode the SMSC ethernet
>> >> chip can be used via IRQ1 on r8a7779 Marzen. This mode
>> >> is the only supported mode by the INTC-IRQPIN driver.
>> >>
>> >> For this patch to work the r8a7779 DTS needs to pass
>> >> the ICR0 register as the last register bank.
>> >>
>> >> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
>> >> ---
>> >>
>> >>  Same version as sent on December 3rd.
>> >>
>> >>  Written against renesas-devel-20141202-v3.18-rc7 which is
>> >>  basically v3.18-rc7 plus latest arch/arm/mach-shmobile code.
>> >>
>> >>  Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqp
>> >>  in.txt |    5 +
>> >>  drivers/irqchip/irq-renesas-intc-irqpi                |   50 ++++++++--
>> >>  2 files changed, 46 insertions(+), 9 deletions(-)
>> >>
>> >> ---
>> >> 0001/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-
>> >> ir qpin.txt +++
>> >> work/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-
>> >> irqpin.txt      2014-12-03 20:25:13.000000000 +0900
>> >> @@ -9,6 +9,11 @@
>> >> Required properties:
>> >>      - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
>> >>      - "renesas,intc-irqpin-r8a7779" (R-Car H1)
>> >>      - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
>> >> +
>> >> +- reg: Base address and length of each register bank used by the
>> >> external
>> >> +  IRQ pins driven by the interrupt controller hardware module. The base
>> >> +  addresses, length and number of required register banks varies with
>> >> soctype.
>> >
>> > Ouch. Ouch. Multiple times. Very much :-/
>> >
>> > I suppose it's too late to fix the DT bindings ?
>>
>> I don't think it is ever too late, but the question is just how urgent
>> it is to get rid of the Marzen C board code. With the code in this
>> patch queue up we can get rid of the board code. If someone decides to
>> rework the INTC IRQPIN bits then we will have to live with the Marzen
>> code for longer. And if we should do it right and describe the actual
>> hardware, then perhaps we should consider the non-IRQ-pin interrupts
>> included in INTC for some SoCs. So it rapidly gets more complex...
>
> I don't think there's a need to delay getting rid of Marzen legacy code, my
> comment wasn't an attempt to delay your efforts :-)

Thanks. Just to be clear, I've never had any problems with board code
written in C. =)

> Looking at the hardware we should have a single INTC DT node, not four. What
> I'm wondering is whether we could still fix the DT bindings, or if the
> backward compatibility requirements would make it too painful, especially
> given that R-Car Gen2 doesn't use INTC.

My feeling is that it is a waste of time for existing SoCs. Only old
stuff is using it from the mobile line (r8a7740 and sh73a0) and R-Car
Gen1 (r8a7779 and r8a7778). If for some unknown reason new SoCs come
out that make use of this hardware then we can rework at that point.

If you want to poke around with interrupts on old systems then how
about looking into DT-enabled PINT support for sh73a0 and others?

Cheers,

/ magnus
