Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaJTO0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:26:37 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64675 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJTO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:26:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface
Date: Mon, 20 Oct 2014 16:26:30 +0200
Message-ID: <12255408.hd0Fqgc3mD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAVeFuKoGfkUXPZWt0Xy1jW-zGCUEzbzQ8W7_RVyetG9++uDHw@mail.gmail.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <2997291.LjjH2RgEUW@wuerfel> <CAAVeFuKoGfkUXPZWt0Xy1jW-zGCUEzbzQ8W7_RVyetG9++uDHw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9Mo4SS6BOmZr7y6UWEkQiZqsVzvDXEpjN/VgEj/f/LG
 /uI85zVt5qQv6NDJ8CFlr8Pztk6/4XfOGzHcQsnq5lEZGmpJLO
 V3LXDUDJHrXkkRb9dbWkO0TnEYS5qSwGiJGsQXCZHePDMLKeBk
 uOAsFjmKDYNUc9WdV0LqLFMEzTAkBZ1mRLY7/EQhggIqS/Hoky
 WVlehrT6qGBlB9SR2YpqsdexNeSMDaaHuSLtlxcDfD+k1v83YH
 +YIe/qsOVh17o8DFz+EOlr2Esg5OqnyGoqRiS2xLW7QuJNeups
 BPZg9xUl0iCuX7OUbhBl8DFZtdF9OtjPPHQp+vJLiVgMVl5CNh
 hS3UdSPYpNe7h9RIwEOM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 15:12:50 Alexandre Courbot wrote:
> On Sat, Oct 18, 2014 at 6:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 17 October 2014 20:09:51 Arnd Bergmann wrote:
> >> On October 17, 2014 2:16:00 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> >> >From: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> >
> >> >Some drivers need to deal with only firmware representation of its
> >> >GPIOs. An example would be a GPIO button array driver where each button
> >> >is described as a separate firmware node in device tree. Typically
> >> >these
> >> >child nodes do not have physical representation in the Linux device
> >> >model.
> >> >
> >> >In order to help device drivers to handle such firmware child nodes we
> >> >add dev[m]_get_named_gpiod_from_child() that takes a child firmware
> >> >node pointer as its second argument (the first one is the parent device
> >> >itself), finds the GPIO using whatever is the underlying firmware
> >> >method, and requests the GPIO properly.
> >>
> >> Could we also have a wrapper around this function without a "name" argument,
> >> using just the index?
> >
> > Expanding on this thought: I think we should mandate for new bindings
> > that they use either a name and no index, or an index but not name,
> 
> I'm afraid this could forbid some useful use-cases, namely the ones
> where several GPIOs serve the same function (and are typically set
> together). We had a few patch proposals to handle such GPIO groups,
> and even though one was in pretty good shape the submitter did not
> push it until the end. :/
> 
> But my concern is that instead of having this:
> 
> enable-gpio = <&gpio 0 GPIO_ACTIVE_HIGH>;
> value-gpios = <&gpio 1 GPIO_ACTIVE_HIGH ... &gpio 8 GPIO_ACTIVE_HIGH>;
> 
> We would force this:
> 
> enable-gpio = <&gpio 0 GPIO_ACTIVE_HIGH>;
> value0-gpio = <&gpio 1 GPIO_ACTIVE_HIGH>;
> ...
> value7-gpio = <&gpio 8 GPIO_ACTIVE_HIGH>;
> 
> Or this:
> 
> // First GPIO is enable, other GPIOs are value
> gpios = <&gpio 0 GPIO_ACTIVE_HIGH &gpio 1 GPIO_ACTIVE_HIGH ... &gpio 8
> GPIO_ACTIVE_HIGH>;
> 
> Most bindings don't need that much sophistication, and for these we
> should indeed make sure that they stick to using either the names or
> index (and in a consistent manner), but closing the possibility to use
> both together may bite us in the end.

I would actually prefer the single-property case here, but I see your
point. Could we make it a strong suggestion rather than a mandatory
requirement for new bindings then?

> > and I also think that for named gpios, we should try to converge on a
> > common naming scheme. As discussed, we will probably want to support all
> > the existing ways to do this even with ACPI and with the unified
> > interface, but it doesn't have to be the obvious way.
> 
> Personally, I like the idea that each GPIO has a function, so now that
> ACPI fully supports this I'd suggest the policy of using names for
> each GPIO (e.g. never use the fallback "gpios" or "gpio" property),
> and only ressort to indexes if several GPIOs happen to serve the same
> function. I know we haven't reached consensus about this so far, but
> it would be nice it we could discuss this point again in the light of
> the new ACPI capabilities and come with something to write as a
> guideline in the GPIO documentation.

We have enforced naming things for the dmaengine binding, which has
just led to everyone calling things "rx" and "tx". My fear is that
if we start to enforce giving a name, we'd end up with lots of
drivers that use a "gpio-gpios" property or something silly.

	Arnd
