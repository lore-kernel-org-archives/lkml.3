Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab3DDJeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:34:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:1364 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753Ab3DDJeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:34:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,407,1363158000"; 
   d="scan'208";a="316777092"
Date: Thu, 4 Apr 2013 12:38:20 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
Message-ID: <20130404093820.GI21804@intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAN+gG=F4LMHMsOqVh+BikSLKBJ8V7ni-p4hKi7yRb4jjD7gv0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=F4LMHMsOqVh+BikSLKBJ8V7ni-p4hKi7yRb4jjD7gv0w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:19:53AM +0200, Benjamin Tissoires wrote:
> Hi Mika,
> 
> On Wed, Apr 3, 2013 at 12:56 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > Instead of open-coding ACPI GPIO resource lookup in each driver, we provide
> > a helper function analogous to Device Tree version that allows drivers to
> > specify which GPIO resource they are interested (using an index to the GPIO
> > resources). The function then finds out the correct resource, translates
> > the ACPI GPIO number to the corresponding Linux GPIO number and returns
> > that.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  Documentation/acpi/enumeration.txt |   32 ++++++++++++++-
> >  drivers/gpio/gpiolib-acpi.c        |   77 ++++++++++++++++++++++++++++++++++++
> >  include/linux/acpi_gpio.h          |   17 ++++++++
> >  3 files changed, 125 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
> > index 94a6561..b0d5410 100644
> > --- a/Documentation/acpi/enumeration.txt
> > +++ b/Documentation/acpi/enumeration.txt
> > @@ -199,6 +199,8 @@ the device to the driver. For example:
> >         {
> >                 Name (SBUF, ResourceTemplate()
> >                 {
> > +                       ...
> > +                       // Used to power on/off the device
> >                         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
> >                                 IoRestrictionOutputOnly, "\\_SB.PCI0.GPI0",
> >                                 0x00, ResourceConsumer,,)
> > @@ -206,10 +208,20 @@ the device to the driver. For example:
> >                                 // Pin List
> >                                 0x0055
> >                         }
> > +
> > +                       // Interrupt for the device
> > +                       GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullNone,
> > +                                0x0000, "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer,,)
> 
> Sorry for coming late in the GPIO ACPI discussion, but when I see this
> documentation, I wonder:
> wouldn't it be feasible to find the correct GPIO by its type? Here, we
> have a GpioIo and a GpioInt, and I bet this would be sometime more
> useful to request the first GpioInt without knowing the correct order
> of declarations.

Why not. But then again you can always check the type returned in the
acpi_gpio_info structure and pick the first GpioInt (if you have multiple
GPIO resources).

> It may be feasible by walking the tree, but a helper would be of great
> help (thinking at i2c-hid here, which can not rely on indexes in the
> DSDT).

Well, index is the only thing we can rely on unfortunately. There's nothing
like names or anything like that.

What I've seen from ACPI enumerated i2c-hid devices there is only one GPIO
resource (GpioInt) declared.
