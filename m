Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3IMPfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:35:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:22804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab3IMPfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,899,1371106800"; 
   d="scan'208";a="401224117"
Date: Fri, 13 Sep 2013 18:40:13 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
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
Message-ID: <20130913154013.GD7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <52332BF0.4060605@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52332BF0.4060605@samsung.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:14:56PM +0200, Sylwester Nawrocki wrote:
> On 09/13/2013 08:54 AM, Mika Westerberg wrote:
> > On Thu, Sep 12, 2013 at 02:34:21PM -0700, Kevin Hilman wrote:
> >>> > > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> >>> > > index f32ca29..44374b4 100644
> >>> > > --- a/drivers/i2c/i2c-core.c
> >>> > > +++ b/drivers/i2c/i2c-core.c
> >>> > > @@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
> >>> > >  					client->flags & I2C_CLIENT_WAKE);
> >>> > >  	dev_dbg(dev, "probe\n");
> >>> > >  
> >>> > > +	/* Make sure the adapter is active */
> >>> > > +	pm_runtime_get_sync(&client->adapter->dev);
> >>> > > +
> >>> > > +	/*
> >>> > > +	 * Enable runtime PM for the client device. If the client wants to
> >>> > > +	 * participate on runtime PM it should call pm_runtime_put() in its
> >>> > > +	 * probe() callback.
> >>> > > +	 */
> >>> > > +	pm_runtime_get_noresume(&client->dev);
> >>> > > +	pm_runtime_set_active(&client->dev);
> >> > 
> >> > Why the set_active here?
> >> > 
> >> > For hardware that is disabled/powered-off on startup, there will now be
> >> > a mismatch between the hardware state an the RPM core state.
> >
> > The call to pm_runtime_get_noresume() should make sure that the device is
> > in active state (at least in state where it can access the bus) if I'm
> > understanding this right.
> 
> I can't see how this would happen. How runtime_resume/runtime_suspend
> callbacks would get invoked with this code, if, e.g. originally driver called 
> pm_runtime_enable(), pm_runtime_get_sync(), pm_runtime_put_sync() in probe() ? 

The driver callbacks are not called but if the device has been attached to
a power domain (like we do with ACPI) the power domain callbacks get called
and it brings the "bus" to such state that we are able to access the
device. That also was the reason I used _noresume() but didn't look too
close the implementation.

> pm_runtime_get_noresume() merely increments usage counter of a device. 
> It seems that these changes will break the s5p-tv driver. I might be missing 
> something though.

You are right and Kevin also mentioned this. It should be pm_runtime_get(),
if I'm not mistaken.

> As Mark pointed out this is currently unwanted behaviour to runtime PM
> activate a bus controller device manually in the core for when the client's
> probe() is executed, since i2c core will activate the bus controller for when 
> transfer is being carried out.  
>
> But I can understand this is needed for ACPI and it shouldn't break existing
> drivers, that do runtime PM activate the client device in probe().

Indeed, we don't want to break anything (and we still need something like
this for ACPI).

> Now I'm sure this will break power management of the drivers/media/exynos4-is
> driver, due to incorrect power sequence (power domain and clocks handling).
> I'll try to take care of it in separate patch, as I have some patches pending,
> that move most of code from drivers/media/exynos4-is/fimc-is-sensor.c to 
> drivers/media/i2c/s5k6a3.c.

I missed that code when I converted existing users to this method. Sorry
about that (I can handle that in the next version).

I quickly looked at it and I don't see anything that could break (once
converted). What it does is this:

	pm_runtime_no_callbacks(dev);
	pm_runtime_enable(dev);

changing that to:

	pm_runtime_no_callbacks(dev);
	pm_runtime_put(dev);

shouldn't cause problems AFAICT.
