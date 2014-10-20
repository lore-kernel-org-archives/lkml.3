Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaJTGNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:13:14 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61648 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaJTGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <2997291.LjjH2RgEUW@wuerfel>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <1510578.dSiEYPPI9m@vostro.rjw.lan>
 <E99B44D9-C9E3-4C0B-8B18-450121793EB5@arndb.de> <2997291.LjjH2RgEUW@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 20 Oct 2014 15:12:50 +0900
Message-ID: <CAAVeFuKoGfkUXPZWt0Xy1jW-zGCUEzbzQ8W7_RVyetG9++uDHw@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface
To: Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 6:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 17 October 2014 20:09:51 Arnd Bergmann wrote:
>> On October 17, 2014 2:16:00 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
>> >From: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >
>> >Some drivers need to deal with only firmware representation of its
>> >GPIOs. An example would be a GPIO button array driver where each button
>> >is described as a separate firmware node in device tree. Typically
>> >these
>> >child nodes do not have physical representation in the Linux device
>> >model.
>> >
>> >In order to help device drivers to handle such firmware child nodes we
>> >add dev[m]_get_named_gpiod_from_child() that takes a child firmware
>> >node pointer as its second argument (the first one is the parent device
>> >itself), finds the GPIO using whatever is the underlying firmware
>> >method, and requests the GPIO properly.
>>
>> Could we also have a wrapper around this function without a "name" argument,
>> using just the index?
>
> Expanding on this thought: I think we should mandate for new bindings
> that they use either a name and no index, or an index but not name,

I'm afraid this could forbid some useful use-cases, namely the ones
where several GPIOs serve the same function (and are typically set
together). We had a few patch proposals to handle such GPIO groups,
and even though one was in pretty good shape the submitter did not
push it until the end. :/

But my concern is that instead of having this:

enable-gpio = <&gpio 0 GPIO_ACTIVE_HIGH>;
value-gpios = <&gpio 1 GPIO_ACTIVE_HIGH ... &gpio 8 GPIO_ACTIVE_HIGH>;

We would force this:

enable-gpio = <&gpio 0 GPIO_ACTIVE_HIGH>;
value0-gpio = <&gpio 1 GPIO_ACTIVE_HIGH>;
...
value7-gpio = <&gpio 8 GPIO_ACTIVE_HIGH>;

Or this:

// First GPIO is enable, other GPIOs are value
gpios = <&gpio 0 GPIO_ACTIVE_HIGH &gpio 1 GPIO_ACTIVE_HIGH ... &gpio 8
GPIO_ACTIVE_HIGH>;

Most bindings don't need that much sophistication, and for these we
should indeed make sure that they stick to using either the names or
index (and in a consistent manner), but closing the possibility to use
both together may bite us in the end.


> and I also think that for named gpios, we should try to converge on a
> common naming scheme. As discussed, we will probably want to support all
> the existing ways to do this even with ACPI and with the unified
> interface, but it doesn't have to be the obvious way.

Personally, I like the idea that each GPIO has a function, so now that
ACPI fully supports this I'd suggest the policy of using names for
each GPIO (e.g. never use the fallback "gpios" or "gpio" property),
and only ressort to indexes if several GPIOs happen to serve the same
function. I know we haven't reached consensus about this so far, but
it would be nice it we could discuss this point again in the light of
the new ACPI capabilities and come with something to write as a
guideline in the GPIO documentation.
