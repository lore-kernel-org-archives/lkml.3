Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3IJOVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:21:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:16635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3IJOVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:21:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,878,1371106800"; 
   d="scan'208";a="399336916"
Date: Tue, 10 Sep 2013 17:26:31 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
Message-ID: <20130910142631.GL7393@intel.com>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378733679-19500-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130909154028.GP29403@sirena.org.uk>
 <20130910075100.GK7393@intel.com>
 <20130910122754.GK29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910122754.GK29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 01:27:54PM +0100, Mark Brown wrote:
> On Tue, Sep 10, 2013 at 10:51:00AM +0300, Mika Westerberg wrote:
> > On Mon, Sep 09, 2013 at 04:40:28PM +0100, Mark Brown wrote:
> 
> > > How is this going to interact with client devices which are already
> > > enabling runtime PM for themselves, and what are the advantages of doing
> > > this over having the client device enable runtime PM for itself (given
> > > that the client still needs an explicit put() adding)?
> 
> > My understanding is that you can call pm_runtime_enable() several times
> > (provided that pm_runtime_disable() is called as many times). So that
> > should have no effect on the current drivers that already take advantage of
> > runtime PM.
> 
> Not quite...
> 
> > There is one difference though -- runtime PM is now blocked by default and
> > it needs to be unblocked from the userspace per each device.
> 
> ...as you say.
> 
> This seems crazy, why on earth would we want to have userspace be forced
> to manually go through every single device and manually enable power
> saving?  I can't see anyone finding that helpful and it's going to be a
> pain to deploy.

There are things like HID over I2C devices (e.g touch screen) where going
to lower power states too aggressively makes the touch experience really
sluggish. However, other HID over I2C devices like sensor hubs it doesn't
matter that much. In order to get the best performance we have runtime PM
blocked by default (and leave it up to the user to unblock to get power
savings).

That's basically what PCI drivers currently do.

> However I had thought it was just a case of the drivers doing a put()
> instead of their current code to enable runtime PM (you mention that
> later on)?

User still needs to unblock runtime PM for the device. The driver can call
the runtime PM functions but they don't have any effect until runtime PM is
unblocked by the user.

However, I don't have problems dropping the call to pm_runtime_forbid() in
this patch and leave it up to the user to decide whether runtime PM should
be blocked for the device.

> That seems both sensible and doable, though it would need
> doing as part of the conversion to avoid regressions and I'd expect it
> does mean that SPI needs to be converted at the same time.

OK.

> > For the advantages compared to each driver handling it completely
> > themselves:
> 
> > 	- Few lines less as you only need to call _put().
> > 	- It follows what is already been done for other buses, like PCI
> > 	  and AMBA .
> > 	- The I2C core makes sure that the device is available (from bus
> > 	  point of view) when the driver ->probe() is called.
> 
> I can't understand your last point here at all, sorry.  Can you expand
> please?

Sorry about that.

At least with ACPI enumerated I2C client devices, they might be powered off
by the BIOS (there are power resources attached to the devices). So when
the driver ->probe() is called we can't access the device's registers etc.

So we bind the device to the ACPI power domain (the second patch in this
series) and then call pm_runtime_get() for the device. That makes sure that
the device is accessible when ->probe() is called.

> 
> > > Given that it's relatively common for devices to have both I2C and SPI
> > > control it seems like it'd be sensible to keep the policy common between
> > > the two buses to simplify driver implementation.
> 
> > Yes and IMHO if I2C and SPI follows what has already been done for other
> > buses it should make the driver writer's job easier as the usage is similar
> > from one bus to another.
> 
> So then the obvious followup question is why this is even something that
> needs to be implemented per bus?  Shouldn't we be enhancing the driver
> core to do this, or is that the long term plan and this is a step on the
> road to doing that?

If we end up all buses implementing the same mechanism, I think it makes
sense to move it to the driver core.
