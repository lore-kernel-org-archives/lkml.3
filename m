Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaIXJM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:12:56 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56507 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIXJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:12:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Darren Hart <dvhart@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <david.woodhouse@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Wed, 24 Sep 2014 11:12:36 +0200
Message-ID: <6744174.JquHLt80n3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D04730D8.A9DB0%dvhart@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2809308.3y5s7TV5Ip@wuerfel> <D04730D8.A9DB0%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yVrQTsXXREuS8J5iFW4vpjJWCumwftBSGQlDzYPYzUW
 qzchy29H5rSpRwYscf1b7V4yN6ajNnYbRuNi9AhNWeFRZFwT+X
 1ghFmpCYHdFcETphwBgb7cJ0aVz6+daJ3aqBEbY4GC6D+uq10q
 coe5si1ONpyj+q8fUXLF+mMXF12EtTaK/yOeepT8rOK11J2uBX
 IgPjnCNH1Huns7LCMh/5bZ/1OzXIqi8wBv9B88iNEYyZm8/qmi
 sNdp308ZUcGmO/rHMjee/mvRJN7TqUpBqPcHiMKuLSEmwDbUBh
 Bu67JphIizlJHgE23MlLffmsRbaM9isKPYDqLt0TOU9YHQ1uqD
 WEnrcRNbsRInaw+PnMuI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 14:15:47 Darren Hart wrote:
> Arnd, I think you meant:
> 
>         Return gpio_leds_create_acpi(pdev) ?

Yes, sorry for the confusion on my part.

> This is what we did early on to prototype this concept, but the problem
> with this approach we duplicate all of the creation code, which leads to
> maintenance errors, and is inconsistent with the goals of the _DSD which
> is to reuse the same schemas for ACPI and FDT. If we have separate pdata
> creation functions anyway, we are leaving much of the advantage of the
> common schema on the table. Namely the ability to reuse drivers relatively
> easily across firmware implementations. We don't want driver authors to
> have to care if it's ACPI or FDT.

I think we are absolutely in agreement about the basic principle here,
but disagree on how far we'd want to take the abstraction.

I got a little confused by the leds-gpio example, as I initially saw
that as generic infrastructure rather than a specific driver. As I just
wrote in my reply to Rafael, I generally believe we should strive to
have generic driver-side interfaces so drivers don't have to care,
but keep the differences in subsystem specific code.

> We would have preferred to have deprecated the of property interface in
> favor of the new generic device_property interface, but Grant specifically
> requested that we update drivers individually rather than all at once,
> which means we can't just kill the OF interface.

I don't actually have a strong opinion on that matter, having only the
device property interface does have some advantages as well, but I also
agree that we are somewhat better off not having to change all the drivers.

> We agreed to that, somewhat reluctantly as it adds more work in updating
> the drivers over time which will slow adoption, but I understand the
> desire not to make large sweeping changes due to the risk of breaking
> things inadvertently as we cannot expect to be able to test all of them.
> That said, I don't want to forget that the goal is to use the common
> interface over time as we convert individual drivers, and using the common
> interface means we need a common iterator function and that we not have fw
> implementation specific pdata create functions.

I've looked a bit closer at how the LED subsystem handles sub-nodes
in DT at the moment. It seems that there is some duplication between
the drivers already, as they all implement a variation of the sub-node
parsing code.

There are other non-LED drivers with similar loops, but they seem to be
either very specialized, or explicitly for DT abstractions, so I'm still
not convinced we need a generic loop-through-child-nodes-and-parse-properties
interface.

How would you feel about a more general way of probing LED, using
a new helper in the leds-core that iterates over the child nodes
and parses the standard properties but calls into a driver specific
callback to parse the specific properties?
It's probably much more work than your current approach, but it seems
to me that there is more to gain by solving the problem for LED
drivers in particular to cut down the per-driver duplication
at the same time as the per-firmware-interface duplication.

As a start, we could probably take the proposed device_for_each_child_node
and move that into the leds-core, changing the fw_dev_node argument
for an led_classdev with the addition of the of_node and acpi_object
members. It would still leave it up to the gpio-leds driver to do

	if (led_cdev->of_node)
		gpiod = devm_of_get_gpiod(led_cdev->of_node, ...);
	else
		gpiod = devm_acpi_get_gpiod(led_cdev->acpi_object, ...);

but there seems little benefit in abstracting this because there is
only one driver that needs it.

	Arnd
