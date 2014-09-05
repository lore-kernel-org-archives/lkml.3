Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaIETVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:21:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:33856 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaIETVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:21:42 -0400
Date: Fri, 5 Sep 2014 21:21:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
cc: Mark Rutland <mark.rutland@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: bcm7120-l2: Add Broadcom BCM7120-style
 L2 binding
In-Reply-To: <5409FA82.6000703@gmail.com>
Message-ID: <alpine.DEB.2.10.1409052113210.5472@nanos>
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com> <1409265326-7579-3-git-send-email-f.fainelli@gmail.com> <alpine.DEB.2.10.1409031410580.3333@nanos> <20140903124317.GB3127@leverpostej> <5407490E.7060505@gmail.com> <20140905090528.GG2172@leverpostej>
 <5409FA82.6000703@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Florian Fainelli wrote:
> On 09/05/2014 02:05 AM, Mark Rutland wrote:
> >>>>> +- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
> >>>>> +  wakeup source for system suspend/resume.
> >>>
> >>> How variable is this?
> >>
> >> There's two instances of this interrupt controller on most SoCs, one
> >> that can wake up the system, one that cannot, see below.
> >>
> >>>
> >>> I realise have properties like this elsewhere, but it seems to be
> >>> hacking around the lack of a decent power domain interface for figuring
> >>> this out.
> >>
> >> Humm, I kind of see your point here with the power domains, I don't see
> >> a big problem with specifying that property though, at most this becomes
> >> redundant when we have a power domain representation (which will be very
> >> simple: always-on and everything else).
> > 
> > Sure, we seem to have done that elsewhere.
> > 
> >>>>> +- brcm,int-fwd-mask: if present, a 32-bits bit mask describing the interrupts
> >>>>> +  which need to be enabled in this controller to flow to the higher level
> >>>>> +  interrupt controller. This is typically needed for the UARTs interrupts to
> >>>>> +  flow through the top-level interrupt controller (e.g: ARM GIC on ARM-based
> >>>>> +  platforms).
> >>>>> +
> >>>
> >>> I don't follow why this property is needed at all. Is this a mechanism
> >>> to bypass this controller entirely? Why should this be described as a
> >>> fixed HW property?
> >>
> >> This interrupt controller has traditionally (not necessarily for good
> >> reasons) been the placeholder for special bits that control whether our
> >> UARTs level 1 interrupts (wired to the ARM GIC) will flow to the L1
> >> interrupt.
> > 
> > So basically setting these bits unmasks some irq lines inpout to the
> > GIC?
> 
> Right, this is what happens. We prefer to use the GIC interrupts because
> that provides more flexibility.
> 
> > 
> >> We discussed initially with Arnd Bergman about how to best approach
> >> this, and he was happy with a bitmask since:
> >>
> >> a) that is a one-time initialization thing that can happen anywhere in
> >> the kernel before UART interrupts get used (so before user-space gets
> >> scheduled)
> > 
> > That feels a little dodgy to me, but perhaps that's ok.
> 
> The other approach was to use the "interrupt-extended" property for the
> UART nodes and have them reference both their GIC interrupt, and the
> BCM7120-L2 interrupt, but that also requires UART driver/platform
> modifications to account for that extra "interrupt", on which we are
> only ever going to call enable_irq() and nothing more.
> 
> So, in the end, this turned out to be simpler to just read the
> "brcm,irq-fwd-mask" property and apply it to the relevant register.

So if I understand correctly what you have is:

                          /- GIC------------->   
 Device-irq ---- [routing]
                          \- BC irq chip ---->

and you implement it as

 Device-irq ---- [BC irq chip] ---- [GIC] --->
                            |
                            ----------------->

And the fwd mask is to tell the BC chip to use the GIC and which irq
of the GIC, so it can fiddle with the GIC under the hood, right?

Thanks,

	tglx
