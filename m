Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbbA0RLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:11:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:13580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbbA0RLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:11:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="668464150"
Date: Tue, 27 Jan 2015 19:10:56 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH 2/2] HID: i2c-hid: Add support for GPIO interrupts
Message-ID: <20150127171056.GX1451@lahna.fi.intel.com>
References: <20150127101610.GK1451@lahna.fi.intel.com>
 <20150127103925.GB17721@leverpostej>
 <20150127105931.GN1451@lahna.fi.intel.com>
 <20150127111458.GD17721@leverpostej>
 <20150127113041.GP1451@lahna.fi.intel.com>
 <20150127143334.GF17721@leverpostej>
 <20150127144127.GT1451@lahna.fi.intel.com>
 <20150127150606.GI17721@leverpostej>
 <20150127152127.GV1451@lahna.fi.intel.com>
 <20150127155747.GJ17721@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127155747.GJ17721@leverpostej>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 03:57:47PM +0000, Mark Rutland wrote:
> On Tue, Jan 27, 2015 at 03:21:27PM +0000, Mika Westerberg wrote:
> > On Tue, Jan 27, 2015 at 03:06:06PM +0000, Mark Rutland wrote:
> > > On Tue, Jan 27, 2015 at 02:41:27PM +0000, Mika Westerberg wrote:
> > > > On Tue, Jan 27, 2015 at 02:33:34PM +0000, Mark Rutland wrote:
> > > > > Ok, that allays my fear w.r.t. ordering of the resources.
> > > > > 
> > > > > As I see it, the fact that we convert GpioInt entries to GPIOs rather
> > > > > than irqs when parsing _CRS is the issue here, and to me it makes no
> > > > > sense that we do so. Were we to treat them as interrupts, the binding is
> > > > > fine as-is, and we'd do the same thing in DT and ACPI.
> > > > > 
> > > > > The reason GpioInt is separate from GpioIo is that a GpioInt _is_ an
> > > > > interrupt (which happens to be backed by a GPIO), and is not something
> > > > > that necessarily makes sense as a GPIO.
> > > > 
> > > > I would rather say that GpioInt *is* a GPIO. That can then used as an
> > > > interrupt but it should not prevent you from using it as GPIO instead.
> > > > For example if you just want to poll that something is 0 or 1. That
> > > > should be possible as well and nothing say that you cannot do that for
> > > > GpioInt().
> > > 
> > > >From my POV a GpioInt is logically an interrupt, or it would be a
> > > GpioIo. That doesn't necessarily mean it's invalid to try to query its
> > > state as a GPIO, but I do not think that it makes sense to handle it by
> > > default as a GPIO given that it was handed to us as a GpioInt so that it
> > > can be used as an interrupt.
> > > 
> > > If it's just the case that ACPI and DT differ w.r.t. how this case (an
> > > interrupt line wired to a GPIO) is described, that in itself is fine;
> > > different standards have different models.
> > > 
> > > However, I do not think we must change the DT binding and violate
> > > established DT practice simply becuase on the ACPI side things are
> > > different (nor would it make sense to do things the other way around).
> > > If the two have different rules, then we should handle those rules
> > > separately rather than trying to force the two together when they
> > > clearly don't fit.
> > 
> > I agree.
> > 
> > > In the driver that can easily be achieved with separate probe paths.
> > 
> > Yes, that's what this patch is doing. It has different paths for
> > interrupt and GPIO cases. If we find that there is an interrupt number
> > already, then we use that directly.
> > 
> > If not we try to look for a GPIO which we could use as an interrupt.
> 
> My comment about separate probe paths was w.r.t. ACPI and DT. In DT,
> acquiring a GPIO here shouldn't be necessary (and ideally shouldn't be
> allowed) because the GPIO should be described as an interrupt (we need
> this to have the correct flags).
> 
> > The reason why this is not done only in the ACPI probe path is that
> > there is nothing ACPI specific in gpiod_get() and friends.
> 
> While the high-level APIs are not specific to ACPI or DT, the behaviour
> we want for DT is subtly different top the behaviour you want for ACPI.
> 
> In DT we don't necessarily have the relevant flags (e.g. edge vs level,
> active high vs active low) unless the GPIO is described as an interrupt,
> so permitting it to be described as a GPIO permits situations which we
> cannot handle correctly. In the DT case therefore we must not acquire
> the interrupt GPIO as a GPIO; it must be described as an interrupt.
> 
> So if we need to acquire a GPIO in the ACPI case, this should be limited
> to the ACPI case.

How about cases where platform data (no ACPI or DT) is used? You can
also provide lookup table to the GPIOs from platform data.

> Looking further at ACPI, the flags issue also seems to be a problem
> there. If the interrupt GPIO were described as a GpioIo, then you could
> acquire it as a GPIO with gpiod_get(), but wouldn't have the EdgeLevel
> and ActiveLevel properties, and therefore cannot necessarily correctly
> convert the GPIO to an irq, no?

That's right but typically what I've seen the drivers configure the GPIO
as they think is necessary.

Anyway, I think I'll give up now and leave the i2c-hid.c driver to
support only interrupts for now.
