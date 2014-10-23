Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJWGDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 02:03:11 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:54307 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaJWGDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 02:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <4582579.9WMrIMALsy@wuerfel>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <4582579.9WMrIMALsy@wuerfel>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 23 Oct 2014 15:02:46 +0900
Message-ID: <CAAVeFuJzZJdh+Z7hY-Ws3orxyO=PSqCB_eBphbWk3nRb15op2w@mail.gmail.com>
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio: Support
 for unified device properties interface)
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

On Tue, Oct 21, 2014 at 4:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 21 October 2014 14:14:02 Alexandre Courbot wrote:
>> >
>> > We have enforced naming things for the dmaengine binding, which has
>> > just led to everyone calling things "rx" and "tx". My fear is that
>> > if we start to enforce giving a name, we'd end up with lots of
>> > drivers that use a "gpio-gpios" property or something silly.
>>
>> Checking the bindings is also part of the review process.  Things
>> like "gpio-gpios" should simply not be accepted to begin with.
>>
>> This sounds like a good chance to finally land some guidelines
>> regarding GPIO bindings. Let's summarize the situation:
>> - GPIO bindings can be defined using both DT and ACPI (both interfaces
>> nicely abstracted by the interface introduced by this series)
>> - Both firmware interfaces support indexed GPIOs
>> - Both firmware interfaces support named GPIO properties, with an
>> optional index (can we absolutely take this for granted on ACPI now?)
>
> The developers working on it have said that they definitely want to
> be compatible with the existing bindings, so the answer to your question
> is yes.
>
>> - For DT bindings, both foo-gpio and foo-gpios are valid properties
>> for the GPIO "foo".
>
> I would like to see the documentation recommend one over the other for
> new bindings. Most other subsystems use the plural form even for
> properties that only have one entry, so I'd like to see "foo-gpios"
> become the canonical form for named gpio lines.

Sounds good.

> Drivers that use
> existing bindings with the "foo-gpio" form (or worse, "foo-somethingelse"
> can use the same internal interface as the drivers that use name plus
> index. Do you see a problem using what I suggested for the combined
> API:
>
> __gpiod_get(dev, propname, index); // use property name plus index
> gpiod_get(dev, index); // use "gpios" plus index
> gpiod_get_named(dev, "name"); use "name-gpios" with index 0

Apart from the loosy naming practices which we sometimes see (and
which should be caught during review), do you have something against
requiring a name for all new GPIO bindings, i.e. for ensuring that all
new properties are "name-gpio" and forbidding "gpios"?

Requiring a proper name for all GPIOs makes a lot of sense IMHO, it
makes drivers easier to understand and is less error-prone than long
arrays of GPIOs. The API would then be basically what we have today:

gpiod_get(dev, name) // use "name-gpios" with index 0
gpiod_get_index(dev, name, index) // for the rare case where several
GPIOs serve the same function. Not to be used lightly.

... with stronger guidelines for the definition of new bindings, and a
big warning in the kerneldoc of gpiod_get_index().

ACPI drivers that may use tables without _DSD should then use a way to
bind GPIO names to indexes as a fallback for older hardware.
