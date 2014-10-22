Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaJVIvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:51:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:59218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaJVIvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:51:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="623051964"
Date: Wed, 22 Oct 2014 11:51:40 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Message-ID: <20141022085140.GF1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <4582579.9WMrIMALsy@wuerfel>
 <20141022081044.GB1484@lahna.fi.intel.com>
 <4711930.7fsc2oSxcp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4711930.7fsc2oSxcp@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:33:32AM +0200, Arnd Bergmann wrote:
> On Wednesday 22 October 2014 11:10:44 Mika Westerberg wrote:
> > 
> > It expects that GPIOs returned from _CRS are in specific order. Since we
> > can't change these existing ACPI tables, we must support them somehow.
> > 
> > This patch series handles it so that:
> > 
> >   1) If we can't find given property (e.g "reset-gpios" or
> >      "shutdown-gpios") the index above will refer directly to the GPIO
> >      resource returned from _CRS.
> > 
> >   2) If the property is found we ignore index and take it from the
> >      property instead.
> > 
> > This has the drawback that we cannot support this:
> > 
> >         Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0, ^GPIO, 1, 0, 0}}
> >                                                                  ^^^^^^^^^^^^^^
> > So the second entry in the above is not accessible using
> > gpiod_get_index() and the reason is that we want to support the existing
> > and new ACPI tables where _DSD is not being used.
> 
> So this is not using the DT binding but does thing slightly differently then.
> In this case (supporting two incompatible bindings for DT and ACPI), I think
> the only sensible driver implementation would be to know what we are asking
> for and use different devm_gpiod_get_index statements based on the firmware
> interface.

Yes something like that is probably needed.

Alternatively (I didn't try if this works) we could do it so that
when we see:

	gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);

we check first for the property ("shutdown-gpios"), and check if it has
more than one entry in the value, like:

	Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0, ^GPIO, 1, 0, 0}}

and in that case return the second entry. If we find this instead:

	Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0 }}

we just ignore the index.

Last if there is no _DSD the index refers directly to the GPIO resource
in _CRS.

This would support both _DSD and non-_DSD at the same time but it makes
the implementation more complex.
