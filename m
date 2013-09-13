Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3IMVMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 17:12:46 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37441 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IMVMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 17:12:44 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client devices
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
	<1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
	<87vc25pvvm.fsf@linaro.org> <20130913065434.GZ7393@intel.com>
	<87bo3whjz4.fsf@linaro.org> <20130913145022.GC7393@intel.com>
	<20130913173149.GE7393@intel.com>
Date: Fri, 13 Sep 2013 14:10:43 -0700
In-Reply-To: <20130913173149.GE7393@intel.com> (Mika Westerberg's message of
	"Fri, 13 Sep 2013 20:31:49 +0300")
Message-ID: <87ioy4e8bw.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Westerberg <mika.westerberg@linux.intel.com> writes:

> On Fri, Sep 13, 2013 at 05:50:22PM +0300, Mika Westerberg wrote:
>> On Fri, Sep 13, 2013 at 07:30:55AM -0700, Kevin Hilman wrote:
>> > Mika Westerberg <mika.westerberg@linux.intel.com> writes:
>> > 
>> > > On Thu, Sep 12, 2013 at 02:34:21PM -0700, Kevin Hilman wrote:
>> > >> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> > >> > index f32ca29..44374b4 100644
>> > >> > --- a/drivers/i2c/i2c-core.c
>> > >> > +++ b/drivers/i2c/i2c-core.c
>> > >> > @@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
>> > >> >  					client->flags & I2C_CLIENT_WAKE);
>> > >> >  	dev_dbg(dev, "probe\n");
>> > >> >  
>> > >> > +	/* Make sure the adapter is active */
>> > >> > +	pm_runtime_get_sync(&client->adapter->dev);
>> > >> > +
>> > >> > +	/*
>> > >> > +	 * Enable runtime PM for the client device. If the client wants to
>> > >> > +	 * participate on runtime PM it should call pm_runtime_put() in its
>> > >> > +	 * probe() callback.
>> > >> > +	 */
>> > >> > +	pm_runtime_get_noresume(&client->dev);
>> > >> > +	pm_runtime_set_active(&client->dev);
>> > >> 
>> > >> Why the set_active here?
>> > >> 
>> > >> For hardware that is disabled/powered-off on startup, there will now be
>> > >> a mismatch between the hardware state an the RPM core state.
>> > >
>> > > The call to pm_runtime_get_noresume() should make sure that the device is
>> > > in active state (at least in state where it can access the bus) if I'm
>> > > understanding this right.
>> > 
>> > No, after _get_noresume(), nothing happens to the hardware.  It simply
>> > increments the usecount.  From pm_runtime.h:
>> > 
>> > static inline void pm_runtime_get_noresume(struct device *dev)
>> > {
>> > 	atomic_inc(&dev->power.usage_count);
>> > }
>> > 
>> > So after the _get_noresume() and _set_active() you're very likely to
>> > have a disconnect between the hardware state and what state RPM thinks
>> > the hardware is in.
>> 
>> Good point.
>> 
>> I suppose calling pm_runtime_get() here would work (and make the state
>> active in all case)? I used _noresume() here because at this point the
>> driver itself hasn't had change to install it's RPM hooks.
>
> I take that back.
>
> [ It has been some time since this code was originally written so I can't
> remember all the details :-/ ]
>
> The pm_runtime_get_noresume() is there just to increment the refcount. It
> has nothing to do to "activate" the device in question. Sorry about the
> confusion from my part.
>
> This is what happens in case the device is enumerated from ACPI:
>
> 	// This makes sure that the controller itself is powered on
> 	// (adapter device follows its parent which is the controller). The
> 	// controller is attached to the ACPI power domain so it is
> 	// brought to D0 now.
> 	pm_runtime_get_sync(&client->adapter->dev);
>
> 	// This binds the client device to the ACPI power domain, and in
> 	// addition to that brings the client device to D0.

OK, then here is where the problem is, because you're building ACPI
assumptions into the core. For non-ACPI devices, this part is a nop, so
the client device is still powered off, which breaks the assumptions
below.

> 	if (ACPI_HANDLE(&client->dev))
> 		acpi_dev_pm_attach(&client->dev, true);
>
> 	// Increase the refcount so that client can start runtime PM
> 	// transitions when it calls _put().
> 	pm_runtime_get_noresume(&client->dev);

> 	// Mark the device being active as
> 	//  1) In ACPI case we know that is true as we just powered the
> 	//     device on.
> 	//  2) We treat the device by default to be runtime PM active and
> 	//     powered on (that's in the changelog and should follow what
> 	//     the PCI bus did).
> 	pm_runtime_set_active(&client->dev);
>
> 	// Enable runtime PM but nothing happens yet as long as the client
> 	// driver doesn't call _put().
> 	pm_runtime_enable(&client->dev);
>
> So, yes there might be a disconnect between the runtime PM state and the
> device HW state now (same is with default to suspended).

Yes, but until now, default to suspended has been assumed, so any
changes to that will likely require more thorough auditing of other drivers.

Kevin

> When the driver ->probe() is called, it needs to power on the device (which
> it probably needs to do anyway to be able to talk to the device and probe
> its registers, etc.). Once the driver calls _put() the device is eventually
> moved to suspended state (and its RPM hooks are called). I might be missing
> something but is there a case where this is not beneficial?
