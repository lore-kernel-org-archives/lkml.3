Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaJMMlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:41:39 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44320 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaJMMlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:41:36 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 04/13] ACPI: Document ACPI device specific properties
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
In-Reply-To: <4876377.qMEam54Cox@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<4876377.qMEam54Cox@vostro.rjw.lan>
Date: Mon, 13 Oct 2014 14:41:32 +0200
Message-Id: <20141013124132.4E08BC408F6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2014 02:14:06 +0200
, "Rafael J. Wysocki" <rjw@rjwysocki.net>
 wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> This document describes the data format and interfaces of ACPI device
> specific properties.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  Documentation/acpi/properties.txt |  376 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 376 insertions(+)
>  create mode 100644 Documentation/acpi/properties.txt
> 
> Index: linux-pm/Documentation/acpi/properties.txt
> ===================================================================
> --- /dev/null
> +++ linux-pm/Documentation/acpi/properties.txt
> @@ -0,0 +1,376 @@
> +ACPI device properties
> +======================
> +This document describes the format and interfaces of ACPI device
> +properties as specified in "Device Properties UUID For _DSD" available
> +here:
> +
> +http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> +
> +1. Introduction
> +---------------
> +In systems that use ACPI and want to take advantage of device specific
> +properties, there needs to be a standard way to return and extract
> +name-value pairs for a given ACPI device.
> +
> +An ACPI device that wants to export its properties must implement a
> +static name called _DSD that takes no arguments and returns a package of
> +packages:
> +
> +	Name (_DSD, Package () {
> +		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		Package () {
> +			Package () {"name1", <VALUE1>},
> +			Package () {"name2", <VALUE2>}
> +		}
> +	})
> +
> +The UUID identifies contents of the following package. In case of ACPI
> +device properties it is daffd814-6eba-4d8c-8a91-bc9bbf4aa301.
> +
> +In each returned package, the first item is the name and must be a string.
> +The corresponding value can be a string, integer, reference, or package. If
> +a package it may only contain strings, integers, and references.
> +
> +An example device where we might need properties is a device that uses
> +GPIOs. In addition to the GpioIo/GpioInt resources the driver needs to
> +know which GPIO is used for which purpose.
> +
> +To solve this we add the following ACPI device properties to the device:
> +
> +	Device (DEV0)
> +	{
> +		Name (_CRS, ResourceTemplate () {
> +			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
> +				"\\_SB.PCI0.LPC", 0, ResourceConsumer) {0}
> +			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
> +				"\\_SB.PCI0.LPC", 0, ResourceConsumer) {1}
> +			...
> +		})
> +
> +		Name (_DSD, Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () {"reset-gpio", {^DEV0, 0, 0, 0}},
> +				Package () {"shutdown-gpio", {^DEV0, 1, 0, 0}},
> +			}
> +		})
> +	}
> +
> +Now the device driver can reference the GPIOs using names instead of
> +using indexes.

Ummm... so this is kind of odd. Why would arguments be needed for the
gpio reference, or a device trying to reference itself (^DEV0) within
it's own device.

It looks like it is trying to shoehorn DT design patterns into the ACPI
tables when ACPI already has a native method for doing the same thing.
That concerns me.

[...]
> +In addition to simple object references it is also possible to have object
> +references with arguments. These are represented in ASL as follows:
> +
> +	Device (\_SB.PCI0.PWM)
> +	{
> +		Name (_DSD, Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () {"#pwm-cells", 2}
> +			}
> +		})
> +	}
> +
> +	Device (\_SB.PCI0.BL)
> +	{
> +		Name (_DSD, Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () {
> +					"pwms",
> +					Package () {
> +						\_SB.PCI0.PWM, 0, 5000000,
> +						\_SB.PCI0.PWM, 1, 4500000,
> +					}
> +				}
> +			}
> +		})
> +	}

This worries me even more. #x-cells is a very devicetree oriented
pattern that looks wrong for ACPI data. I would expect PWM resources in
ACPI to look much like ACPI GPIO resources or Serial bus resources.

g.

