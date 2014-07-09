Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaGIKlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:41:45 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21914 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGIKlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:41:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xUhYQ1hQ1JH7fGN8cyJ+q
Date: Wed, 9 Jul 2014 03:41:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pascal Huerst <pascal.huerst@gmail.com>
Cc: santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        linus.walleij@linaro.org, gnurou@gmail.com, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: Re: gpio-omap: wakeup mask
Message-ID: <20140709104142.GO28884@atomide.com>
References: <53B3F687.5050502@gmail.com>
 <20140704072752.GC28884@atomide.com>
 <53BD1683.9030505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD1683.9030505@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pascal Huerst <pascal.huerst@gmail.com> [140709 03:18]:
> Hey Tony, all
> 
> On 04.07.2014 09:27, Tony Lindgren wrote:
> > * Pascal Huerst <pascal.huerst@gmail.com> [140702 05:12]:
> >> Hi everyone,
> >>
> >> we have a device with an am335x and are using some gpios on bank0 to
> >> wake up the device from suspend to ram.
> >>
> >> We have some user buttons which are configured in the devicetree as
> >> gpio-keys and one power-key which should wake up the device:
> >>
> >> &buttons {
> >>         power {
> >>                 label = "Power";
> >>                 gpios = <&gpio0 6 1>;
> >>                 linux,code = <116>;
> >>                 gpio-key,wakeup;
> >>         };
> >>
> >>         one {
> >>                 label = "One";
> >>                 gpios = <&gpio0 11 1>;
> >>                 linux,code = <2>;
> >>         };
> >>
> >>         : : :
> >> }
> >>
> >> The problem is, that the device wakes up on any trigger on bank 0. No
> >> matter which button was pressed. "gpio-key,wakeup" seems not to have any
> >> influence.
> >>
> >> Now, if I comment the following lines out in drivers/gpio/gpio-omap.c :
> >> set_gpio_trigger(...).
> >>
> >> 321
> >> 322 if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
> >> 323    _gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
> >> 324      bank->context.wake_en =
> >> 325        readl_relaxed(bank->base + bank->regs->wkup_en);
> >> 326 }
> >> 327
> >>
> >> Everything works as expected. But I don't really understand why? Is this
> >> a bug, or does this break something else I have not discovered yet?
> > 
> > The GPIO wake-up events are working from off-idle for omap3
> > the last time I checked, so sounds like this is some am335x
> > related issue.
> 
> Ok, that sounds reasonable.
> 
> > What does your bank->context.wake_en mask get set to with this code?
> 
> by calling 'echo mem > /sys/power/state' followed by a wakeup, I get the
> following:
> 
> [   28.992866] bank->context->wake_en = 00080040
> [   29.020974] PM: noirq resume of devices complete after 22.439 msecs

I guess that's for gpio bank 0 with no bit 11 as your dts has it
configured. If you just comment out the _gpio_rmw part above do
things work as expected?

Then if that works as expected, maybe write only some unused bits
into wkup_en register and see if it still wakes to all events while
it should not?

It might be worth comparing the GPIO registers between am37xx and
am335x for the wkup_en register.

Regards,

Tony
