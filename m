Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaJNJma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:42:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:27860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbaJNJmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,716,1406617200"; 
   d="scan'208";a="614141413"
Date: Tue, 14 Oct 2014 12:42:06 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 04/13] ACPI: Document ACPI device specific properties
Message-ID: <20141014094206.GD2255@lahna.fi.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <4876377.qMEam54Cox@vostro.rjw.lan>
 <20141013124132.4E08BC408F6@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013124132.4E08BC408F6@trevor.secretlab.ca>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 02:41:32PM +0200, Grant Likely wrote:
> On Tue, 07 Oct 2014 02:14:06 +0200
> , "Rafael J. Wysocki" <rjw@rjwysocki.net>
>  wrote:
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > This document describes the data format and interfaces of ACPI device
> > specific properties.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  Documentation/acpi/properties.txt |  376 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 376 insertions(+)
> >  create mode 100644 Documentation/acpi/properties.txt
> > 
> > Index: linux-pm/Documentation/acpi/properties.txt
> > ===================================================================
> > --- /dev/null
> > +++ linux-pm/Documentation/acpi/properties.txt
> > @@ -0,0 +1,376 @@
> > +ACPI device properties
> > +======================
> > +This document describes the format and interfaces of ACPI device
> > +properties as specified in "Device Properties UUID For _DSD" available
> > +here:
> > +
> > +http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > +
> > +1. Introduction
> > +---------------
> > +In systems that use ACPI and want to take advantage of device specific
> > +properties, there needs to be a standard way to return and extract
> > +name-value pairs for a given ACPI device.
> > +
> > +An ACPI device that wants to export its properties must implement a
> > +static name called _DSD that takes no arguments and returns a package of
> > +packages:
> > +
> > +	Name (_DSD, Package () {
> > +		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +		Package () {
> > +			Package () {"name1", <VALUE1>},
> > +			Package () {"name2", <VALUE2>}
> > +		}
> > +	})
> > +
> > +The UUID identifies contents of the following package. In case of ACPI
> > +device properties it is daffd814-6eba-4d8c-8a91-bc9bbf4aa301.
> > +
> > +In each returned package, the first item is the name and must be a string.
> > +The corresponding value can be a string, integer, reference, or package. If
> > +a package it may only contain strings, integers, and references.
> > +
> > +An example device where we might need properties is a device that uses
> > +GPIOs. In addition to the GpioIo/GpioInt resources the driver needs to
> > +know which GPIO is used for which purpose.
> > +
> > +To solve this we add the following ACPI device properties to the device:
> > +
> > +	Device (DEV0)
> > +	{
> > +		Name (_CRS, ResourceTemplate () {
> > +			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
> > +				"\\_SB.PCI0.LPC", 0, ResourceConsumer) {0}
> > +			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
> > +				"\\_SB.PCI0.LPC", 0, ResourceConsumer) {1}
> > +			...
> > +		})
> > +
> > +		Name (_DSD, Package () {
> > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +			Package () {
> > +				Package () {"reset-gpio", {^DEV0, 0, 0, 0}},
> > +				Package () {"shutdown-gpio", {^DEV0, 1, 0, 0}},
> > +			}
> > +		})
> > +	}
> > +
> > +Now the device driver can reference the GPIOs using names instead of
> > +using indexes.
> 
> Ummm... so this is kind of odd. Why would arguments be needed for the
> gpio reference, or a device trying to reference itself (^DEV0) within
> it's own device.

The reference doesn't need to be the device itself. It can be the parent
device for example.

Also arguments contain information that is not available in ACPI GpioIo
resources:

 - Name of the GPIO
 - Is the GPIO active low

Remember that we can write the above also like:

		Name (_CRS, ResourceTemplate () {
			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
				"\\_SB.PCI0.LPC", 0, ResourceConsumer) {0, 1}
			...
		})

		Name (_DSD, Package () {
			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
			Package () {
				Package () {"reset-gpio", {^DEV0, 0, 0, 0}},
				Package () {"shutdown-gpio", {^DEV0, 0, 1, 0}},
			}
		})

So the first two integers are used as indexes in _CRS and in the
pinlist.

> It looks like it is trying to shoehorn DT design patterns into the ACPI
> tables when ACPI already has a native method for doing the same thing.
> That concerns me.

There is no native method in ACPI to do what we are doing.

> [...]
> > +In addition to simple object references it is also possible to have object
> > +references with arguments. These are represented in ASL as follows:
> > +
> > +	Device (\_SB.PCI0.PWM)
> > +	{
> > +		Name (_DSD, Package () {
> > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +			Package () {
> > +				Package () {"#pwm-cells", 2}
> > +			}
> > +		})
> > +	}
> > +
> > +	Device (\_SB.PCI0.BL)
> > +	{
> > +		Name (_DSD, Package () {
> > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > +			Package () {
> > +				Package () {
> > +					"pwms",
> > +					Package () {
> > +						\_SB.PCI0.PWM, 0, 5000000,
> > +						\_SB.PCI0.PWM, 1, 4500000,
> > +					}
> > +				}
> > +			}
> > +		})
> > +	}
> 
> This worries me even more. #x-cells is a very devicetree oriented
> pattern that looks wrong for ACPI data. I would expect PWM resources in
> ACPI to look much like ACPI GPIO resources or Serial bus resources.

This was already discussed in v3 version of the series and our argument
here is that we should be able to reuse the existing DT schemas as much
as possible as long as ACPI does not have a native method to describe
the thing (and it makes sense in general).

However, nothing prevents us to extend the
acpi_dev_get_property_reference() in future to support a more ACPI style
way of doing things:

http://www.spinics.net/lists/linux-acpi/msg53367.html
