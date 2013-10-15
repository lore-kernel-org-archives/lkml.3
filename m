Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab3JOTcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:32:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306Ab3JOTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:32:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
Date: Tue, 15 Oct 2013 21:32:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Mack <zonque@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1380635719-31171-1-git-send-email-zonque@gmail.com> <CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
In-Reply-To: <CACRpkdYhQ+-d1COcvmg_hEJ==cTFpKLNDnvF8kdK4QgXzHenEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310152132.00409.arnd@arndb.de>
X-Provags-ID: V02:K0:vDNQtigtKuHmwbAItB0aYRAekS5mYogBN6zrRmABvx4
 ygwya9bRHAKCMe/Ok8U2Jrj0lA7+ARymtZEsxkHVKjg4BnN8V9
 DwJdfmEwvBUez9QpztZecE329cnKgivEIRu9ikddO1tFzyO/d0
 HSAFVgRNkr+EWd9N0hsJZoNqjRuYRSIpIkufgLOL+QTgmaccN1
 G+KAFdV24Gf2jTIvqwQ285xyrXqLCAqZjcgMiKrJoxeNBpsCpy
 ImTVAkQGxfFI97RYXznQq7F2nqM2Ioav7G9RRrduCIzhOz+Wkh
 ZKJ2KkQriBNYUexazf9p3UNs0XAk1vHDp7WnAz1K6IWqZCjLa7
 PuJcHqYGkA84errqh+NY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 October 2013, Linus Walleij wrote:
> On Tue, Oct 1, 2013 at 3:55 PM, Daniel Mack <zonque@gmail.com> wrote:
> 
> > This patch adds a very simple driver that enables GPIO lines as wakeup
> > sources. It only operates on information passed in via DT, and depends
> > on CONFIG_OF && CONFIG_PM_SLEEP. It can for example be used to connect
> > wake-on-LAN (WOL) signals or other electric wakeup networks.
> >
> > The driver accepts a list of GPIO nodes and claims them along with their
> > interrupt line. During suspend, the interrupts will be enabled and
> > selected as wakeup source. The driver doesn't do anything else with the
> > GPIO lines, and will ignore occured interrupts silently.
> >
> > Signed-off-by: Daniel Mack <zonque@gmail.com>
> 
> This makes a weird kind of sense.
> Hm hm hm.
> 
> But I really need the misc mainatiners' help here...
> possibly also irqchip maintainers.

This seems like a completely generic driver, rather than some oddball
hack, so I'd prefer to not see it in drivers/misc at all. Maybe you
can find some other maintainer who is willing to put it into his
subsystem, candidates would be

 * gpio
 * irqchip
 * power
 * of/dt

I don't see anything wrong with the basic approach though.

> > +Example:
> > +
> > +       wake_up {
> > +               compatible = "gpio-wakeup";
> > +               gpios = <&gpio0 19 0>;
> > +       };
> 
> This will not work if that GPIO chip is not capable of supporting
> interrupts on that GPIO line right?
> 
> We have recently had a very long discussion about this: such
> GPIO chips will also be marked "interrupt-controller" and you
> should be able to just state interrupt-parent and
> interrupts = <>; for this. (And it should accept an array.)
> 
> It *may* be that we have many GPIO drivers that do not accept
> that you request an interrupt on them before you have done
> request_gpio() followed by gpio_to_irq() on the pin. Then this
> shall be treated like a bug and the GPIO driver fixed to handle
> this. (That was the outcome of this discussion.)

I haven't followed that discussion, but it's good to hear that
you made some progress there. I find it a bit worrying that you
say the behavior may be dependent on the gpio driver, but maybe
I didn't fully understand what the resolution is.

> Since what the driver will then eventually provide is to
> flag an IRQ line as wakeup, I wonder if this should not just
> simply go into the interrupt core, or atleast of/irq.c.

Right.

	Arnd
