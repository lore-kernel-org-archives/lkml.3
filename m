Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbbA0PGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:06:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44004 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523AbbA0PGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:06:31 -0500
Date: Tue, 27 Jan 2015 15:06:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Message-ID: <20150127150606.GI17721@leverpostej>
References: <20150126160044.GK23313@leverpostej>
 <20150126161356.GJ1451@lahna.fi.intel.com>
 <20150126163929.GL23313@leverpostej>
 <20150127101610.GK1451@lahna.fi.intel.com>
 <20150127103925.GB17721@leverpostej>
 <20150127105931.GN1451@lahna.fi.intel.com>
 <20150127111458.GD17721@leverpostej>
 <20150127113041.GP1451@lahna.fi.intel.com>
 <20150127143334.GF17721@leverpostej>
 <20150127144127.GT1451@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127144127.GT1451@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 02:41:27PM +0000, Mika Westerberg wrote:
> On Tue, Jan 27, 2015 at 02:33:34PM +0000, Mark Rutland wrote:
> > Ok, that allays my fear w.r.t. ordering of the resources.
> > 
> > As I see it, the fact that we convert GpioInt entries to GPIOs rather
> > than irqs when parsing _CRS is the issue here, and to me it makes no
> > sense that we do so. Were we to treat them as interrupts, the binding is
> > fine as-is, and we'd do the same thing in DT and ACPI.
> > 
> > The reason GpioInt is separate from GpioIo is that a GpioInt _is_ an
> > interrupt (which happens to be backed by a GPIO), and is not something
> > that necessarily makes sense as a GPIO.
> 
> I would rather say that GpioInt *is* a GPIO. That can then used as an
> interrupt but it should not prevent you from using it as GPIO instead.
> For example if you just want to poll that something is 0 or 1. That
> should be possible as well and nothing say that you cannot do that for
> GpioInt().

>From my POV a GpioInt is logically an interrupt, or it would be a
GpioIo. That doesn't necessarily mean it's invalid to try to query its
state as a GPIO, but I do not think that it makes sense to handle it by
default as a GPIO given that it was handed to us as a GpioInt so that it
can be used as an interrupt.

If it's just the case that ACPI and DT differ w.r.t. how this case (an
interrupt line wired to a GPIO) is described, that in itself is fine;
different standards have different models.

However, I do not think we must change the DT binding and violate
established DT practice simply becuase on the ACPI side things are
different (nor would it make sense to do things the other way around).
If the two have different rules, then we should handle those rules
separately rather than trying to force the two together when they
clearly don't fit.

In the driver that can easily be achieved with separate probe paths.
W.R.T. the DT binding, I do not think it makes sense to pretend this
is also an ACPI binding.

Thanks,
Mark.
