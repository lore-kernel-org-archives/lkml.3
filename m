Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaJVNqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:46:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57723 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750863AbaJVNqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:46:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
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
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface)
Date: Wed, 22 Oct 2014 16:07:08 +0200
Message-ID: <1971792.8pKYWlGxB9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2466280.tMTA38OpXD@wuerfel>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <20141022085140.GF1484@lahna.fi.intel.com> <2466280.tMTA38OpXD@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 22, 2014 11:28:40 AM Arnd Bergmann wrote:
> On Wednesday 22 October 2014 11:51:40 Mika Westerberg wrote:
> > On Wed, Oct 22, 2014 at 10:33:32AM +0200, Arnd Bergmann wrote:
> > > On Wednesday 22 October 2014 11:10:44 Mika Westerberg wrote:
> > > > 
> > > > It expects that GPIOs returned from _CRS are in specific order. Since we
> > > > can't change these existing ACPI tables, we must support them somehow.
> > > > 
> > > > This patch series handles it so that:
> > > > 
> > > >   1) If we can't find given property (e.g "reset-gpios" or
> > > >      "shutdown-gpios") the index above will refer directly to the GPIO
> > > >      resource returned from _CRS.
> > > > 
> > > >   2) If the property is found we ignore index and take it from the
> > > >      property instead.
> > > > 
> > > > This has the drawback that we cannot support this:
> > > > 
> > > >         Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0, ^GPIO, 1, 0, 0}}
> > > >                                                                  ^^^^^^^^^^^^^^
> > > > So the second entry in the above is not accessible using
> > > > gpiod_get_index() and the reason is that we want to support the existing
> > > > and new ACPI tables where _DSD is not being used.
> > > 
> > > So this is not using the DT binding but does thing slightly differently then.
> > > In this case (supporting two incompatible bindings for DT and ACPI), I think
> > > the only sensible driver implementation would be to know what we are asking
> > > for and use different devm_gpiod_get_index statements based on the firmware
> > > interface.
> > 
> > Yes something like that is probably needed.
> > 
> > Alternatively (I didn't try if this works) we could do it so that
> > when we see:
> > 
> >         gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);
> > 
> > we check first for the property ("shutdown-gpios"), and check if it has
> > more than one entry in the value, like:
> > 
> >         Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0, ^GPIO, 1, 0, 0}}
> > 
> > and in that case return the second entry. If we find this instead:
> > 
> >         Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0 }}
> > 
> > we just ignore the index.
> > 
> > Last if there is no _DSD the index refers directly to the GPIO resource
> > in _CRS.
> > 
> > This would support both _DSD and non-_DSD at the same time but it makes
> > the implementation more complex.
> 
> I think the main problem with that approach is that it makes the common
> code more error-prone in case of unintentionally broken device descriptions,
> because it less often returns an error.

Moreover, we need to clarify what situation we're really talking about.

For one, drivers using the unified interface only will always use names for
GPIOs, because they have to assume that either a DT or ACPI w/ _DSD is present.
This is the cost of keeping those drivers firmware interface agnostic.

So it looks like we're not talking about this case here.

Now, if there's no DT or no _DSD in the ACPI tables for the given device
*and* the driver wants to use its GPIOs anyway, it has to be ACPI-aware to
some extent, because in that case the device ID it has been matched against
tells it what the meaning of the GpioIo resources in the _CRS is.

Then, the driver needs to do something like:

	if (!device_property_present(dev, "known_property_that_should_be_present")
	    && ACPI_COMPANION(dev))
		acpi_probe_gpios(dev);

and in the acpi_probe_gpios() routine there may be checks like:

	if (device_has_id(dev, "MARY0001")) {
		The first pin in the first GpioIo resource in _CRS is "fred" and
		it is active-low.
		The third pin in the second GpioIo resource in _CRS is "steve"
		and it is not active-low.
	} else if (device_has_id(dev, "JANE0002")) {
		The first pin in the second GpioIo resource in _CRS is "fred" and
		it is not active-low.
		The second pin in the first GpioIo resource in _CRS is "steve"
		and it is active-low.
	}

and so on.  Of course, there may be drivers knowing that the meaning of the
GpioIo resources in _CRS is the same for all devices handled by them, in which
case they will not need to check device IDs, but the core has now way of
knowing that.  Only the drivers have that information and the core has now
way to figure out what to do for a given specific device.

So here's a radical idea: Why don't we introduce something like

	acpi_enumerate_gpio(dev, name, GpioIo_index, pin_index, active_low)

such that after calling, say, acpi_enumerate_gpio(dev, "fred", 0, 0, true) the
driver can do something like:

	desc = get_gpiod_by_name(dev, "fred");

and it'll all work.  Then, the only part of the driver that really needs to be
ACPI-specific will be the acpi_probe_gpios() function calling acpi_enumerate_gpio()
in accordance with what the device ID is.

Thoughts?

Rafael

