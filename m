Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3IOGgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 02:36:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:32149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3IOGgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 02:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,908,1371106800"; 
   d="scan'208";a="401859652"
Date: Sun, 15 Sep 2013 09:41:39 +0300
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
Message-ID: <20130915064139.GJ7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
 <20130913173149.GE7393@intel.com>
 <87ioy4e8bw.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioy4e8bw.fsf@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 02:10:43PM -0700, Kevin Hilman wrote:
> >
> > 	// This makes sure that the controller itself is powered on
> > 	// (adapter device follows its parent which is the controller). The
> > 	// controller is attached to the ACPI power domain so it is
> > 	// brought to D0 now.
> > 	pm_runtime_get_sync(&client->adapter->dev);
> >
> > 	// This binds the client device to the ACPI power domain, and in
> > 	// addition to that brings the client device to D0.
> 
> OK, then here is where the problem is, because you're building ACPI
> assumptions into the core. For non-ACPI devices, this part is a nop, so
> the client device is still powered off, which breaks the assumptions
> below.

We expect that once the driver ->probe() is called, and it doesn't
participate the runtime PM prepared here, the device is regarded as powered
on, runtime PM active.

If the driver participates in runtime PM, it needs to power on the device
and then call pm_runtime_put() to suspend the device.

> > 	if (ACPI_HANDLE(&client->dev))
> > 		acpi_dev_pm_attach(&client->dev, true);
> >
> > 	// Increase the refcount so that client can start runtime PM
> > 	// transitions when it calls _put().
> > 	pm_runtime_get_noresume(&client->dev);
> 
> > 	// Mark the device being active as
> > 	//  1) In ACPI case we know that is true as we just powered the
> > 	//     device on.
> > 	//  2) We treat the device by default to be runtime PM active and
> > 	//     powered on (that's in the changelog and should follow what
> > 	//     the PCI bus did).
> > 	pm_runtime_set_active(&client->dev);
> >
> > 	// Enable runtime PM but nothing happens yet as long as the client
> > 	// driver doesn't call _put().
> > 	pm_runtime_enable(&client->dev);
> >
> > So, yes there might be a disconnect between the runtime PM state and the
> > device HW state now (same is with default to suspended).
> 
> Yes, but until now, default to suspended has been assumed, so any
> changes to that will likely require more thorough auditing of other drivers.

I agree. And it looks like I missed few existing drivers as well. I'm going
to update them in the next version of the series.

There's also a less intrusive way of fixing the problem we see with ACPI
enabled I2C devices:

	1. In I2C core i2c_device_probe() we power on the I2C controller
	and attach the client device to the ACPI power domain. Just like in
	this patch but we don't touch the I2C client device runtime PM.

	-> This should allow the existing drivers to keep using whatever
	runtime PM strategy they have chosen.

	2. For ACPI enumerated I2C client devices drivers we need to
	implement the runtime PM in order to save power (otherwise the
	devices will be left powered on).

and do the same for SPI devices as well.

Then only thing that changes for non-ACPI devices is that the controller
will be powered on during the client device probe (well, and during
remove).

Thoughts?
