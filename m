Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3IPIlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:41:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:9205 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3IPIlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,913,1371106800"; 
   d="scan'208";a="295306463"
Date: Mon, 16 Sep 2013 11:47:08 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
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
Message-ID: <20130916084708.GN7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <52332BF0.4060605@samsung.com>
 <20130913154013.GD7393@intel.com>
 <5235BA9C.1090509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5235BA9C.1090509@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 03:48:12PM +0200, Sylwester Nawrocki wrote:
> On 09/13/2013 05:40 PM, Mika Westerberg wrote:
> [...]
> >>>The call to pm_runtime_get_noresume() should make sure that the device is
> >>>in active state (at least in state where it can access the bus) if I'm
> >>>understanding this right.
> >>
> >>I can't see how this would happen. How runtime_resume/runtime_suspend
> >>callbacks would get invoked with this code, if, e.g. originally driver called
> >>pm_runtime_enable(), pm_runtime_get_sync(), pm_runtime_put_sync() in probe() ?
> >
> >The driver callbacks are not called but if the device has been attached to
> >a power domain (like we do with ACPI) the power domain callbacks get called
> >and it brings the "bus" to such state that we are able to access the
> >device. That also was the reason I used _noresume() but didn't look too
> >close the implementation.
> 
> OK, but if a client driver assumes default inactive power state it
> will expect
> its callbacks to get called. Otherwise exisiting code might break. So, e.g.
> in case of s5p-tv it would rather need to be something like:
> 
> 	pm_runtime_put()
> 
> 	pm_runtime_get_sync()
>  	sii9234_verify_version()
>  	pm_runtime_put(dev)

Yes, or even call directly its runtime_resume callback to bring the device
to the active state.

> >>pm_runtime_get_noresume() merely increments usage counter of a device.
> >>It seems that these changes will break the s5p-tv driver. I might be missing
> >>something though.
> >
> >You are right and Kevin also mentioned this. It should be pm_runtime_get(),
> >if I'm not mistaken.
> 
> Note that client drivers usually call pm_runtime_enable() only when
> it is safe
> to call their driver's runtime PM callbacks. By enabling runtime PM
> before the
> client's driver has completely initialized we may risk that the
> callbacks are
> executed with uninitialized data, if I understand things correctly.

I think that calling pm_runtime_enable() on behalf of the client driver
shouldn't cause any problems. There is no PM events queued for that device
yet (and we have prevented that from happening when we called
_get_noresume() for the device).

Only when the client driver calls _put() things start to happen and at that
phase the runtime PM hooks should be usable.

> >>As Mark pointed out this is currently unwanted behaviour to runtime PM
> >>activate a bus controller device manually in the core for when the client's
> >>probe() is executed, since i2c core will activate the bus controller for when
> >>transfer is being carried out.
> >>
> >>But I can understand this is needed for ACPI and it shouldn't break existing
> >>drivers, that do runtime PM activate the client device in probe().
> >
> >Indeed, we don't want to break anything (and we still need something like
> >this for ACPI).
> >
> >>Now I'm sure this will break power management of the drivers/media/exynos4-is
> >>driver, due to incorrect power sequence (power domain and clocks handling).
> >>I'll try to take care of it in separate patch, as I have some patches pending,
> >>that move most of code from drivers/media/exynos4-is/fimc-is-sensor.c to
> >>drivers/media/i2c/s5k6a3.c.
> >
> >I missed that code when I converted existing users to this method. Sorry
> >about that (I can handle that in the next version).
> >
> >I quickly looked at it and I don't see anything that could break (once
> >converted). What it does is this:
> >
> >	pm_runtime_no_callbacks(dev);
> >	pm_runtime_enable(dev);
> >
> >changing that to:
> >
> >	pm_runtime_no_callbacks(dev);
> >	pm_runtime_put(dev);
> >
> >shouldn't cause problems AFAICT.
> 
> Yes, considering this driver in isolation it should be fine.
> 
> However, I observed system suspend issues when the I2C bus controller was
> being activated (which would happen in the I2C core after your changes)
> before some other driver has initialized.
> 
> So to ensure things continue to work the "fimc-isp-i2c" driver would need
> to be registered after the "exynos4-fimc-is" driver has initialized. Or the
> "exynos4-fimc-is" would need to call of_platform_populate() to instantiate
> its all children devices as specified in device tree (see arch/arm/boot/dts/
> exynos4x12.dtsi in -next). "simple-bus" would then have to be not listed in
> the compatible property of that top level device. So to avoid regressions
> some additional changes would be needed, outside of this particular I2C
> client driver. I guess this could be avoided by better design of the
> exynos4-is driver right from the beginning. But it's all some times tricky
> when there is some many IP blocks involved and the hardware behaviour/device
> interactions are not always well documented.

OK.

I'm actually thinking that it is probably better now if we don't touch the
client runtime PM at all in the I2C core.

I proposed a less intrusive solution in this same thread where we power the
I2C controller briefly at the client ->probe() (In order to have all the
ACPI power resources etc. and the controller on) and let the client driver
handle their own runtime PM as they do currently.

Do you think that would work better wrt. fimc-isp-i2c driver?

