Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaJBKlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:41:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:17576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaJBKla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="608645389"
Date: Thu, 2 Oct 2014 13:41:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Message-ID: <20141002104123.GJ1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <5597683.oi0VxOogFu@vostro.rjw.lan>
 <1979325.jM0BQzDCTX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1979325.jM0BQzDCTX@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 09:59:14AM +0200, Arnd Bergmann wrote:
> On Wednesday 01 October 2014 04:11:20 Rafael J. Wysocki wrote:
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > This document describes the data format and interfaces of ACPI device
> > specific properties.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Overall looks sane, but I wonder if we should try harder to not duplicate
> some of the mistakes we made in the DT bindings. Two points in particular
> stick out:
> 
> > +2.3 Strings
> > +-----------
> > +String properties can be used to describe many things like labels for GPIO
> > +buttons, compability ids, etc.
> > +
> > +A string property looks like this:
> > +
> > +	Package () {"pwm-names", "backlight"},
> 
> The way we name things in DT using separate "foos" and "foo-names" properties
> is a bit quirky. Those are always defined on a per-subsystem level, not
> a per-device level though, so it should be possible to come up with a
> better representation in ACPI.
> 
> Since the device driver should never look into the "foo-names" property
> itself but just pass down the name into the subsystem, the "foo" subsystem
> could instead have a way to add an (optional) name for each reference.
> 
> This is something the DT syntax doesn't allow because you can't have
> both a phandle and a string in a single property but I think the ACPI
> packages can do it, and it wouldn't change the basic structure.

ACPI packages can hold anything (even other packages) but one goal with
the _DSD implementation was to reuse existing DT bindings wherever it
makes sense even if they would not always be optimal for ACPI. So the
current acpi_dev_get_property_reference() is modelled after
corresponding DT function and it allows only integer arguments to
accompany the reference.

Doing that allows taking the existing DT description, package it inside
ACPI _DSD and be done with it.

> > +The referenced ACPI device is returned in args->adev if found.
> > +
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
> 
> Similarly, the "#foo-cells" syntax is an artifact of the limitations of the
> DT syntax, and I'd assume there would be a better way to encode this
> in ACPI. Also, a "cell" in Open Firmware is defined as a big-endian
> 32-bit value, which doesn't directly correspond to something in ACPI,
> and the '#' character is an artifact of the use of the Forth language
> in Open Firmware, which you also don't have here.

Same here, we tried to make it follow closely the DT description. It is
probably not the best/optimal encoding for ACPI but it is documented
well in Documentation/devicetree/bindings so why not use it.

The summary email from Darren at KS also mentions that for the existing
drivers, the existing schemas should be common for both implementations [1].

For new bindings we probably should look out if they can be better
represented using ACPI types.

[1] http://lwn.net/Articles/609373/
