Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbbAZQOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:14:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:49973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028AbbAZQOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:14:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,469,1418112000"; 
   d="scan'208";a="642712822"
Date: Mon, 26 Jan 2015 18:13:56 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: i2c-hid: Add support for GPIO interrupts
Message-ID: <20150126161356.GJ1451@lahna.fi.intel.com>
References: <1422282573-18215-1-git-send-email-mika.westerberg@linux.intel.com>
 <1422282573-18215-2-git-send-email-mika.westerberg@linux.intel.com>
 <20150126143723.GI23313@leverpostej>
 <20150126144729.GG1451@lahna.fi.intel.com>
 <20150126145000.GJ23313@leverpostej>
 <20150126151637.GH1451@lahna.fi.intel.com>
 <20150126160044.GK23313@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126160044.GK23313@leverpostej>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 04:01:20PM +0000, Mark Rutland wrote:
> On Mon, Jan 26, 2015 at 03:16:37PM +0000, Mika Westerberg wrote:
> > On Mon, Jan 26, 2015 at 02:50:01PM +0000, Mark Rutland wrote:
> > > On Mon, Jan 26, 2015 at 02:47:29PM +0000, Mika Westerberg wrote:
> > > > On Mon, Jan 26, 2015 at 02:37:24PM +0000, Mark Rutland wrote:
> > > > > On Mon, Jan 26, 2015 at 02:29:33PM +0000, Mika Westerberg wrote:
> > > > > > The HID over I2C specification allows to have the interrupt for a HID
> > > > > > device to be GPIO instead of directly connected to the IO-APIC.
> > > > > > 
> > > > > > Add support for this so that when the driver does not find proper interrupt
> > > > > > number from the I2C client structure we check if the device has property
> > > > > > named "gpios". This is then assumed to be the GPIO that serves as an
> > > > > > interrupt for the device.
> > > > > > 
> > > > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > > > ---
> > > > > >  .../devicetree/bindings/hid/hid-over-i2c.txt       |  5 +-
> > > > > >  drivers/hid/i2c-hid/i2c-hid.c                      | 70 ++++++++++++++++------
> > > > > >  2 files changed, 56 insertions(+), 19 deletions(-)
> > > > > > 
> > > > > > diff --git a/Documentation/devicetree/bindings/hid/hid-over-i2c.txt b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
> > > > > > index 488edcb264c4..8f4a99dad3b9 100644
> > > > > > --- a/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
> > > > > > +++ b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt
> > > > > > @@ -15,7 +15,10 @@ Required properties:
> > > > > >  - reg: i2c slave address
> > > > > >  - hid-descr-addr: HID descriptor address
> > > > > >  - interrupt-parent: the phandle for the interrupt controller
> > > > > > -- interrupts: interrupt line
> > > > > > +- interrupts: interrupt line if the device uses IO-APIC interrupts
> > > > > > +
> > > > > > +Optional properties:
> > > > > > +- gpios: GPIO used as an interrupt if the device uses GPIO interrupts
> > > > > 
> > > > > Elsewhere we've said that for a GPIO acting as an interrupt line, GPIO
> > > > > controller should be marked as an interrupt-controller, and the GPIO
> > > > > described as an interrupt line. That also gets you the appropriate
> > > > > configuration for the GPIO as an interrupt.
> > > > > 
> > > > > Does this GPIO serve any other purpose than an ersatz interrupt line?
> > > > 
> > > > It is just an interrupt.
> > > > 
> > > > > If not, it should probably be described as an interrupt. From the PoV of
> > > > > this device, it's just an interrupt controller hooked up to the
> > > > > interrupt pin.
> > > > 
> > > > What I'm trying to do is to get a GPIO that is described in ACPI (as
> > > > GpioInt() in _CRS) to be supported in this driver using gpiolib like
> > > > this:
> > > > 
> > > > 	desc = gpiod_get(&client->dev, NULL);
> > > > 
> > > > This calls to find "gpios" property which ends up finding the GpioInt()
> > > > in _CRS.
> > > 
> > > I understand what you are trying to do, but I disagree on the principle.
> > > If it's logically an interrupt, it should be described as an interrupt.
> > 
> > It is a GPIO line that is used as interrupt. It is not IO-APIC interrupt
> > or anything like that. It will be handled through a GPIO driver.
> 
> I understand that the interrupt line is wired up to a GPIO controller,
> where the GPIO controller is able to raise an interrupt as required.
> 
> However, from the PoV of the I2C device, this doesn't matter. From it's
> PoV it raises an interrupt, and that's all. It has no idea what happens
> to be wired up to its IRQ pin, and nor should it.
> 
> > > If ACPI lacks the ability to describe things in that fashion, it's yet
> > > another reason that we shouldn't be pretending that DT and ACPI are the
> > > same thing.
> > 
> > I'm not saying they are the same thing (they're not). I'm trying to get
> > a GPIO from ACPI translated to an interrupt so that the driver can use
> > it. Preferably so that the DT description does not prevent people from
> > using the same on non-ACPI platforms.
> 
> If you're following the Microsoft HID over I2C ACPI spec, why is this DT
> binding document relevant. Assuming you're following the spec, you won't
> be using _DSD with "hid-over-i2c". If you're not following the spec then
> you aren't following the spec, so the spec is irrelevant.
> 
> > ACPI can desribe Interrupt(), GpioInt() and GpioIo() just fine. It is
> > the Microsoft HID over I2C specification that says it should be
> > GpioInt() even though we have seen Interrupt() used there as well.
> 
> Ok, so if the HID over I2C spec says that for ACPI, do that for ACPI.
> 
> I don't follow why the DT binding should do this.

I added it there because I thought it's the right thing to do. After all
it is assumed that there exists property "gpios" now for both ACPI and
DT if I pass NULL in gpiod_get().

Obviously I was wrong.

I'll remove the binding documentation from the next revision and call it
"ACPI only" if it makes this work for you.
