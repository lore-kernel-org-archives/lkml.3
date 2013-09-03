Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab3ICM2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:28:17 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51546 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3ICM2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <5220FBC9.1070602@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1507189.CRWvzVJqTV@flatron>
	<521548E3.6010703@wwwdotorg.org>
	<CACRpkdYUeyVZcN1-jOzg0zo4eSJK1S+M5fJ0FcMsgwaPKW4Obw@mail.gmail.com>
	<52167E5D.6060802@wwwdotorg.org>
	<CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com>
	<5217BD74.5030801@wwwdotorg.org>
	<CACRpkdYz7Kn-y8LHpNBV3YyYFhyaU6N592BJE1newUZJpUMNfA@mail.gmail.com>
	<5220FBC9.1070602@wwwdotorg.org>
Date: Tue, 3 Sep 2013 14:28:14 +0200
Message-ID: <CACRpkdZ8xYr2igJ+0OHo9tuM4U4QH-1S8Nu6uF=eNTARfYk+Tw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:08 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/29/2013 01:00 PM, Linus Walleij wrote:

>> No but I think there should be one ... maybe I'm an oddball
>> but it seems natural to request a GPIO before tying
>> IRQs to fire off it.
>
> What if there is no GPIO?
>
> There are plenty of chips with dedicated IRQ input pins that can't be
> read as GPIOs, or treated as GPIOs in any way.

I'm not following this. In that case it is not tagged as
gpio-controller right? The patch is to gpiolib.c.

Do you mean chips where some part of it is GPIO and
another part is IRQ-only?

Should we not in that case create an MFD device that spawns
one GPIO device and then another irqchip device, or possibly
have the IRQ handling directly in the MFD device, as
ab8500-core.c does?

> If a driver only needs IRQ input functionality, it should just request
> an IRQ and be done with it. There should be no need at all for the
> driver to know that the IRQ might be routed into a GPIO controller, and
> hence that the driver may (or may not) need to additionally request the
> GPIO before requesting the IRQ.

This is what the patch is trying to achieve, for the DT use case.

> In other words, request_irq() must do everything necessary for the input
> signal to operate as an IRQ input, irrespective of whether it might be
> possible to use that input signal as a GPIO.

That is not the case for a bunch of OMAP drivers today, and their
attempt to fix that inside the irqchip callback backfired since it
was mutually exclusive with requesting the gpio first.

We have to encode some semantic into this, it's just a matter of
which one shall win, the APIs as they stand are ambiguous wrt
call sequence.

Yours,
Linus Walleij
