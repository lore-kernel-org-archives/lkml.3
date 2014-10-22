Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaJVO5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:57:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:49141 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaJVO5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:57:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,769,1406617200"; 
   d="scan'208";a="618557557"
Date: Wed, 22 Oct 2014 17:56:51 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio:
 Support for unified device properties interface)
Message-ID: <20141022145651.GH1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <20141022085140.GF1484@lahna.fi.intel.com>
 <2466280.tMTA38OpXD@wuerfel>
 <1971792.8pKYWlGxB9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1971792.8pKYWlGxB9@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:07:08PM +0200, Rafael J. Wysocki wrote:
> Moreover, we need to clarify what situation we're really talking about.
> 
> For one, drivers using the unified interface only will always use names for
> GPIOs, because they have to assume that either a DT or ACPI w/ _DSD is present.
> This is the cost of keeping those drivers firmware interface agnostic.
> 
> So it looks like we're not talking about this case here.

We are talking about the case of rfkill-gpio.c where it definitely wants
to use properties for the GPIOs but it cannot be sure if the underlying
firmware provides _DSD or not.

> Now, if there's no DT or no _DSD in the ACPI tables for the given device
> *and* the driver wants to use its GPIOs anyway, it has to be ACPI-aware to
> some extent, because in that case the device ID it has been matched against
> tells it what the meaning of the GpioIo resources in the _CRS is.
> 
> Then, the driver needs to do something like:
> 
> 	if (!device_property_present(dev, "known_property_that_should_be_present")
> 	    && ACPI_COMPANION(dev))
> 		acpi_probe_gpios(dev);

Indeed we can use similar pattern to detect if we have _DSD present or
not.

> and in the acpi_probe_gpios() routine there may be checks like:
> 
> 	if (device_has_id(dev, "MARY0001")) {
> 		The first pin in the first GpioIo resource in _CRS is "fred" and
> 		it is active-low.
> 		The third pin in the second GpioIo resource in _CRS is "steve"
> 		and it is not active-low.
> 	} else if (device_has_id(dev, "JANE0002")) {
> 		The first pin in the second GpioIo resource in _CRS is "fred" and
> 		it is not active-low.
> 		The second pin in the first GpioIo resource in _CRS is "steve"
> 		and it is active-low.
> 	}
> 
> and so on.  Of course, there may be drivers knowing that the meaning of the
> GpioIo resources in _CRS is the same for all devices handled by them, in which
> case they will not need to check device IDs, but the core has now way of
> knowing that.  Only the drivers have that information and the core has now
> way to figure out what to do for a given specific device.
> 
> So here's a radical idea: Why don't we introduce something like
> 
> 	acpi_enumerate_gpio(dev, name, GpioIo_index, pin_index, active_low)
> 
> such that after calling, say, acpi_enumerate_gpio(dev, "fred", 0, 0, true) the
> driver can do something like:
> 
> 	desc = get_gpiod_by_name(dev, "fred");
> 
> and it'll all work.  Then, the only part of the driver that really needs to be
> ACPI-specific will be the acpi_probe_gpios() function calling acpi_enumerate_gpio()
> in accordance with what the device ID is.
> 
> Thoughts?

I think this is good idea. It solves the rfkill-gpio.c problem with just
small amount of ACPI specific code.
