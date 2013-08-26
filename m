Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3HZKbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:31:02 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:43498 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab3HZKbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:31:00 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.744
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
Date: Mon, 26 Aug 2013 12:30:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, galak@codeaurora.org,
        Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <201308231140.44923.poeschel@lemonage.de> <5217BC9B.4060906@wwwdotorg.org>
In-Reply-To: <5217BC9B.4060906@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308261230.50243.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013 at 21:48:43, Stephen Warren wrote:
> On 08/23/2013 03:40 AM, Lars Poeschel wrote:
> > On Thursday 22 August 2013 at 23:10:53, Stephen Warren wrote:
> >> On 08/21/2013 05:36 PM, Linus Walleij wrote:
> >>> On Thu, Aug 22, 2013 at 1:10 AM, Stephen Warren
> >>> <swarren@wwwdotorg.org> wrote: [Me]
> >>> 
> >>>>>> check if these in turn reference the interrupt-controller, and
> >>>>>> if they do, loop over the interrupts used by that child and
> >>>>>> perform gpio_request() and gpio_direction_input() on these,
> >>>>>> making them unreachable from the GPIO side.
> >>>> 
> >>>> What about bindings that require a GPIO to be specified, yet don't
> >>>> allow an IRQ to be specified, and the driver internally does
> >>>> perform gpio_to_irq() on it? I don't think one can detect that
> >>>> case.
> >>> 
> >>> This is still allowed. Consumers that prefer to have a GPIO
> >>> passed and convert it to IRQ by that call can still do so,
> >>> they will know what they're doing and will not cause the
> >>> double-command situation that we're trying to solve.
> >> 
> >> Why not? There are certainly drivers in the kernel which request a
> >> GPIO as both a GPIO and as an (dual-edge) interrupt, so that they
> >> can read the GPIO input whenever the IRQ goes off, in order to
> >> determine the pin state. This is safer against high-latency or lost
> >> interrupts.
> > 
> > This is the point! They REQUEST the GPIO. They can then do whatever
> > they like with this GPIO then, even additionally use it as interrupt.
> > In the devicetree case the interrupts are not requested. This is what
> > we are trying to address with the patch. The device using this
> > interrupt has no idea where this interrupt comes from. Is it a
> > gpio-interrupt or not? Does it have to request a gpio before using
> > this interrupt or not?
> 
> If the kernel automatically requests the GPIO because it's referenced as
> an interrupt then surely if the driver also requests it, then it will
> fail, because the GPIO is already requested. Or, is there an explicit
> check for that?

There is no explicit check, because it is not wanted! Drivers that only 
want the interrupt do not know that it is gpio-backed and therefore can not 
request it.
Drivers wanting to explicit use a gpio for interrupt, request the gpio in 
the device tree. They can then turn that gpio into an interrupt.

> Is the problem you're trying to solve really an actual problem? I'm not
> convinced it's necessary for the GPIO to show up as requested if the pin
> is used as an IRQ input?

It is definitely an actual problem. Please read the thread I already sent!
Surely it is not necessary for the GPIO to show up as requested but it does 
not harm it is even neat if it shows up. But it HAS to be requested so that 
no other entity can request it and change it's configuration i.e. turn it 
to an output.
