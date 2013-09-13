Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3IMR02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:26:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:7754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab3IMR00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:26:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,899,1371106800"; 
   d="scan'208";a="395360764"
Date: Fri, 13 Sep 2013 20:31:49 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130913173149.GE7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913145022.GC7393@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:50:22PM +0300, Mika Westerberg wrote:
> On Fri, Sep 13, 2013 at 07:30:55AM -0700, Kevin Hilman wrote:
> > Mika Westerberg <mika.westerberg@linux.intel.com> writes:
> > 
> > > On Thu, Sep 12, 2013 at 02:34:21PM -0700, Kevin Hilman wrote:
> > >> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > >> > index f32ca29..44374b4 100644
> > >> > --- a/drivers/i2c/i2c-core.c
> > >> > +++ b/drivers/i2c/i2c-core.c
> > >> > @@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
> > >> >  					client->flags & I2C_CLIENT_WAKE);
> > >> >  	dev_dbg(dev, "probe\n");
> > >> >  
> > >> > +	/* Make sure the adapter is active */
> > >> > +	pm_runtime_get_sync(&client->adapter->dev);
> > >> > +
> > >> > +	/*
> > >> > +	 * Enable runtime PM for the client device. If the client wants to
> > >> > +	 * participate on runtime PM it should call pm_runtime_put() in its
> > >> > +	 * probe() callback.
> > >> > +	 */
> > >> > +	pm_runtime_get_noresume(&client->dev);
> > >> > +	pm_runtime_set_active(&client->dev);
> > >> 
> > >> Why the set_active here?
> > >> 
> > >> For hardware that is disabled/powered-off on startup, there will now be
> > >> a mismatch between the hardware state an the RPM core state.
> > >
> > > The call to pm_runtime_get_noresume() should make sure that the device is
> > > in active state (at least in state where it can access the bus) if I'm
> > > understanding this right.
> > 
> > No, after _get_noresume(), nothing happens to the hardware.  It simply
> > increments the usecount.  From pm_runtime.h:
> > 
> > static inline void pm_runtime_get_noresume(struct device *dev)
> > {
> > 	atomic_inc(&dev->power.usage_count);
> > }
> > 
> > So after the _get_noresume() and _set_active() you're very likely to
> > have a disconnect between the hardware state and what state RPM thinks
> > the hardware is in.
> 
> Good point.
> 
> I suppose calling pm_runtime_get() here would work (and make the state
> active in all case)? I used _noresume() here because at this point the
> driver itself hasn't had change to install it's RPM hooks.

I take that back.

[ It has been some time since this code was originally written so I can't
remember all the details :-/ ]

The pm_runtime_get_noresume() is there just to increment the refcount. It
has nothing to do to "activate" the device in question. Sorry about the
confusion from my part.

This is what happens in case the device is enumerated from ACPI:

	// This makes sure that the controller itself is powered on
	// (adapter device follows its parent which is the controller). The
	// controller is attached to the ACPI power domain so it is
	// brought to D0 now.
	pm_runtime_get_sync(&client->adapter->dev);

	// This binds the client device to the ACPI power domain, and in
	// addition to that brings the client device to D0.
	if (ACPI_HANDLE(&client->dev))
		acpi_dev_pm_attach(&client->dev, true);

	// Increase the refcount so that client can start runtime PM
	// transitions when it calls _put().
	pm_runtime_get_noresume(&client->dev);

	// Mark the device being active as
	//  1) In ACPI case we know that is true as we just powered the
	//     device on.
	//  2) We treat the device by default to be runtime PM active and
	//     powered on (that's in the changelog and should follow what
	//     the PCI bus did).
	pm_runtime_set_active(&client->dev);

	// Enable runtime PM but nothing happens yet as long as the client
	// driver doesn't call _put().
	pm_runtime_enable(&client->dev);

So, yes there might be a disconnect between the runtime PM state and the
device HW state now (same is with default to suspended).

When the driver ->probe() is called, it needs to power on the device (which
it probably needs to do anyway to be able to talk to the device and probe
its registers, etc.). Once the driver calls _put() the device is eventually
moved to suspended state (and its RPM hooks are called). I might be missing
something but is there a case where this is not beneficial?
