Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaJVIK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:10:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:63095 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaJVIKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="618380063"
Date: Wed, 22 Oct 2014 11:10:44 +0300
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
Message-ID: <20141022081044.GB1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <4582579.9WMrIMALsy@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4582579.9WMrIMALsy@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 09:54:45AM +0200, Arnd Bergmann wrote:
> On Tuesday 21 October 2014 14:14:02 Alexandre Courbot wrote:
> > >
> > > We have enforced naming things for the dmaengine binding, which has
> > > just led to everyone calling things "rx" and "tx". My fear is that
> > > if we start to enforce giving a name, we'd end up with lots of
> > > drivers that use a "gpio-gpios" property or something silly.
> > 
> > Checking the bindings is also part of the review process.  Things
> > like "gpio-gpios" should simply not be accepted to begin with.
> > 
> > This sounds like a good chance to finally land some guidelines
> > regarding GPIO bindings. Let's summarize the situation:
> > - GPIO bindings can be defined using both DT and ACPI (both interfaces
> > nicely abstracted by the interface introduced by this series)
> > - Both firmware interfaces support indexed GPIOs
> > - Both firmware interfaces support named GPIO properties, with an
> > optional index (can we absolutely take this for granted on ACPI now?)
> 
> The developers working on it have said that they definitely want to
> be compatible with the existing bindings, so the answer to your question
> is yes.

One thing to consider still is that we have plenty of existing ACPI code
out there where _DSD is not used but instead we rely on the index. An
example would be rfkill-gpio.c driver:

        gpio = devm_gpiod_get_index(&pdev->dev, "reset", 0);
        if (!IS_ERR(gpio)) {
		...
        }

        gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);
        if (!IS_ERR(gpio)) {
		...
        }

It expects that GPIOs returned from _CRS are in specific order. Since we
can't change these existing ACPI tables, we must support them somehow.

This patch series handles it so that:

  1) If we can't find given property (e.g "reset-gpios" or
     "shutdown-gpios") the index above will refer directly to the GPIO
     resource returned from _CRS.

  2) If the property is found we ignore index and take it from the
     property instead.

This has the drawback that we cannot support this:

	Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0, ^GPIO, 1, 0, 0}}
                                                                 ^^^^^^^^^^^^^^
So the second entry in the above is not accessible using
gpiod_get_index() and the reason is that we want to support the existing
and new ACPI tables where _DSD is not being used.
