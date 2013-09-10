Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3IJTxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:53:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42155 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3IJTxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:53:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C client devices
Date: Tue, 10 Sep 2013 22:04:21 +0200
Message-ID: <3397524.g9aUWuArnm@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130910161321.GM29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com> <20130910142631.GL7393@intel.com> <20130910161321.GM29403@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 10, 2013 05:13:21 PM Mark Brown wrote:
> On Tue, Sep 10, 2013 at 05:26:31PM +0300, Mika Westerberg wrote:
> > On Tue, Sep 10, 2013 at 01:27:54PM +0100, Mark Brown wrote:
> 
> > > > There is one difference though -- runtime PM is now blocked by default and
> > > > it needs to be unblocked from the userspace per each device.
> 
> > > ...as you say.
> 
> > > This seems crazy, why on earth would we want to have userspace be forced
> > > to manually go through every single device and manually enable power
> > > saving?  I can't see anyone finding that helpful and it's going to be a
> > > pain to deploy.
> 
> > There are things like HID over I2C devices (e.g touch screen) where going
> > to lower power states too aggressively makes the touch experience really
> > sluggish. However, other HID over I2C devices like sensor hubs it doesn't
> > matter that much. In order to get the best performance we have runtime PM
> > blocked by default (and leave it up to the user to unblock to get power
> > savings).
> 
> > That's basically what PCI drivers currently do.
> 
> So those specific devices need to implement runtime PM in an appropriate
> fashion.  That's no need to implement a poor default for every single
> device to work around poor implementations from some, especially when it
> requires a userspace update to get acceptable performance again from the
> unaffected devices.
> 
> > > However I had thought it was just a case of the drivers doing a put()
> > > instead of their current code to enable runtime PM (you mention that
> > > later on)?
> 
> > User still needs to unblock runtime PM for the device. The driver can call
> > the runtime PM functions but they don't have any effect until runtime PM is
> > unblocked by the user.
> 
> > However, I don't have problems dropping the call to pm_runtime_forbid() in
> > this patch and leave it up to the user to decide whether runtime PM should
> > be blocked for the device.
> 
> I think this is essential - we can't really go around forcing userspace
> updates to restore runtime power management, nobody is going to thank us
> for that and it sounds like the issue you're trying to solve is device
> specific anyway.

In fact, that's all about what the default should be, because user space
can very easily change it either way (it takes one loop in shell code to do
that for all devices on the given bus).

And I'm fine with defaulting to "auto".

> > > > 	- The I2C core makes sure that the device is available (from bus
> > > > 	  point of view) when the driver ->probe() is called.
> 
> > > I can't understand your last point here at all, sorry.  Can you expand
> > > please?
> 
> > Sorry about that.
> 
> > At least with ACPI enumerated I2C client devices, they might be powered off
> > by the BIOS (there are power resources attached to the devices). So when
> > the driver ->probe() is called we can't access the device's registers etc.
> 
> > So we bind the device to the ACPI power domain (the second patch in this
> > series) and then call pm_runtime_get() for the device. That makes sure that
> > the device is accessible when ->probe() is called.
> 
> OK, that is very much not the model which embedded systems follow, in
> embedded systems the driver for the device is fully in control of its
> own power.  It gets resources like GPIOs and regulators which allow it
> to make fine grained decisions.

There are platforms where those resources are simply not available for
direct manipulation and we need to use ACPI methods for power management.

Now, since those methods are used in pretty much the same way for all I2C
devices, we add a PM domain for that to avoid duplicating the same code in
all of the drivers in question (patch [2/2]).  Does that make sense to you?

> > > So then the obvious followup question is why this is even something that
> > > needs to be implemented per bus?  Shouldn't we be enhancing the driver
> > > core to do this, or is that the long term plan and this is a step on the
> > > road to doing that?
> 
> > If we end up all buses implementing the same mechanism, I think it makes
> > sense to move it to the driver core.
> 
> If we're starting to get a reasonable number of buses following the same
> pattern it seems like we're in a position to start 

We need that for exactly 3 buses: platform (already done), I2C and SPI.

No other bus types are going to use ACPI this way for PM, at least for the
time being, simply because PCI, USB and SATA/IDE have their own ways of doing
this (which are bus-specific) and the spec doesn't cover other bus types
directly (it defines support for UART, but we don't have a UART bus type).

Moreover, because PCI and USB use ACPI for PM in their own ways, moving that
thing up to the driver core would be rather inconvenient.

Thanks,
Rafael

