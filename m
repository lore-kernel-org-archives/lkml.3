Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3HWTzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:55:38 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:59651 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3HWTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:55:37 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
Date: Fri, 23 Aug 2013 21:55:29 +0200
Message-ID: <1551491.9oAMd0jnLN@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <5217BD74.5030801@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com> <5217BD74.5030801@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 of August 2013 13:52:20 Stephen Warren wrote:
> On 08/23/2013 12:45 PM, Linus Walleij wrote:
> > On Thu, Aug 22, 2013 at 11:10 PM, Stephen Warren 
<swarren@wwwdotorg.org> wrote:
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
> >> GPIO
> >> as both a GPIO and as an (dual-edge) interrupt, so that they can read
> >> the GPIO input whenever the IRQ goes off, in order to determine the
> >> pin
> >> state. This is safer against high-latency or lost interrupts.
> > 
> > Yes? Are we talking past each other here?
> > 
> > This is a perfectly OK thing to do as long as it is done like
> > this:
> > 
> > request_gpio(gpio);
> > gpio_direction_input(gpio);
> > request_irq(gpio_to_irq(gpio));
> 
> But I'm not aware that there's a rule saying it's illegal to:
> 
> request_irq(gpio_to_irq(gpio));
> request_gpio(gpio);
> gpio_direction_input(gpio);

Well, at least on Samsung platforms it is illegal to do so, because 
gpio_direction_input() would override the interrupt+input function set by 
setup done in request_irq() with normal input function, thus breaking the 
interrupt.

We are still to implement some sanity check to disallow (or ignore) this 
if the pin is already configured as an interrupt.

Best regards,
Tomasz

