Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbbAGWTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:19:10 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:42763 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbbAGWTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:19:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irqchip: renesas-intc-irqpin: r8a7779 IRLM setup support
Date: Thu, 08 Jan 2015 00:19:22 +0200
Message-ID: <61770409.DB0uPzOGg3@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150107171545.GM24989@titan.lakedaemon.net>
References: <20141215050920.533.20169.sendpatchset@w520> <1533637.nrBHixev6I@avalon> <20150107171545.GM24989@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Wednesday 07 January 2015 12:15:45 Jason Cooper wrote:
> On Thu, Dec 18, 2014 at 04:39:51AM +0200, Laurent Pinchart wrote:
> > On Thursday 18 December 2014 10:26:27 Magnus Damm wrote:
> >> On Thu, Dec 18, 2014 at 6:41 AM, Laurent Pinchart wrote:
> >>> On Monday 15 December 2014 14:09:20 Magnus Damm wrote:
> >>>> From: Magnus Damm <damm+renesas@opensource.se>
> >>>> 
> >>>> Add r8a7779 specific support for IRLM bit configuration
> >>>> in the INTC-IRQPIN driver. Without this code we need
> >>>> special workaround code in arch/arm/mach-shmobile.
> >>>> 
> >>>> The IRLM bit for the INTC hardware exists on various
> >>>> older SH-based SoCs and is used to select between two
> >>>> modes for the external interrupt pins IRQ0 to IRQ3:
> >>>> 
> >>>> IRLM = 0: (default from reset on r8a7779)
> >>>> In this mode the pins IRQ0 to IRQ3 are used together
> >>>> to give a value between 0 and 15 to the SoC. External
> >>>> logic is required for masking. This mode is not
> >>>> supported by the INTC-IRQPIN driver.
> >>>> 
> >>>> IRLM = 1: (needs this patch or configuration elsewhere)
> >>>> In this mode IRQ0 to IRQ3 operate as 4 individual
> >>>> external interrupt pins. In this mode the SMSC ethernet
> >>>> chip can be used via IRQ1 on r8a7779 Marzen. This mode
> >>>> is the only supported mode by the INTC-IRQPIN driver.
> >>>> 
> >>>> For this patch to work the r8a7779 DTS needs to pass
> >>>> the ICR0 register as the last register bank.
> >>>> 
> >>>> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
> >>>> ---
> >>>> 
> >>>>  Same version as sent on December 3rd.
> >>>>  
> >>>>  Written against renesas-devel-20141202-v3.18-rc7 which is
> >>>>  basically v3.18-rc7 plus latest arch/arm/mach-shmobile code.
> >>>>  
> >>>>  Documentation/devicetree/bindings/interrupt-controller/renesas,intc-
> >>>>  irqpin.txt |    5 +
> >>>>  drivers/irqchip/irq-renesas-intc-irqpi            |   50 ++++++++--
> >>>>  2 files changed, 46 insertions(+), 9 deletions(-)
> >>>> 
> >>>> ---
> >>>> 0001/Documentation/devicetree/bindings/interrupt-controller/renesas,i
> >>>> ntc-irqpin.txt +++
> >>>> work/Documentation/devicetree/bindings/interrupt-controller/renesas,i
> >>>> ntc-irqpin.txt      2014-12-03 20:25:13.000000000 +0900
> >>>> @@ -9,6 +9,11 @@
> >>>> Required properties:
> >>>>      - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
> >>>>      - "renesas,intc-irqpin-r8a7779" (R-Car H1)
> >>>>      - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
> >>>> +
> >>>> +- reg: Base address and length of each register bank used by the
> >>>> external
> >>>> +  IRQ pins driven by the interrupt controller hardware module. The
> >>>> base
> >>>> +  addresses, length and number of required register banks varies
> >>>> with soctype.
> >>> 
> >>> Ouch. Ouch. Multiple times. Very much :-/
> >>> 
> >>> I suppose it's too late to fix the DT bindings ?
> 
> Fix?  Is this a change to the reg property (from an undocumented
> version)?  Or just adding the reg property?  If the later, then as long
> as the driver preserves the old behavior when the reg property isn't
> present, we should be good.
> 
> If the case was the former, then we need to keep in mind that these are
> old SoCs and that this binding is mfgr-specific.  afair from the DT
> maintainers, it's acceptable to have a little instability under these
> conditions.

The reg property is already used, and this patch documents it. My concern is 
that the property is (at least in my opinion) used in a pretty dirty way.

In a nutshell, the INTC IP core handles several banks of interrupts, with a 
set of registers per bank. The registers are interleaved instead of split per 
bank. However, the driver expects one device instance per bank, with one 
memory resource for each register. This predates DT support and has never been 
reworked. I would have liked to instantiate a single INTC device given that we 
have a single INTC IP core, but the change would likely be too disruptive.

> >> I don't think it is ever too late, but the question is just how urgent
> >> it is to get rid of the Marzen C board code. With the code in this
> >> patch queue up we can get rid of the board code. If someone decides to
> >> rework the INTC IRQPIN bits then we will have to live with the Marzen
> >> code for longer. And if we should do it right and describe the actual
> >> hardware, then perhaps we should consider the non-IRQ-pin interrupts
> >> included in INTC for some SoCs. So it rapidly gets more complex...
> > 
> > I don't think there's a need to delay getting rid of Marzen legacy code,
> > my comment wasn't an attempt to delay your efforts :-)
> > 
> > Looking at the hardware we should have a single INTC DT node, not four.
> > What I'm wondering is whether we could still fix the DT bindings, or if
> > the backward compatibility requirements would make it too painful,
> > especially given that R-Car Gen2 doesn't use INTC.
> 
> Please see above.  I'm sure the DT maintainers will chirp up if the
> winds have shifted, but I'd rather we do it right if we're breaking
> compatibility anyway.

We're not breaking compatibility with this patch. The question is whether we 
should break compatibility to do things right.

-- 
Regards,

Laurent Pinchart

