Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3IMPPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:15:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22341 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3IMPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:15:00 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-a1-52332bf12cce
Message-id: <52332BF0.4060605@samsung.com>
Date: Fri, 13 Sep 2013 17:14:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org> <20130913065434.GZ7393@intel.com>
In-reply-to: <20130913065434.GZ7393@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xK7qftI2DDBYeZ7TY1PebzeLvpGPs
	FlMfPmGzOLzoBaNF8+L1bBZfD69gtDjb9Ibd4v7Xo4wW3650MFks39cP1PH4GqtFx98vjBaX
	d81hs/i4dAOrxcV18hZTth9ht3i84i27xeluVouVJ2YxOwh7/P41idFj56y77B6L97xk8ti0
	qpPN4861PWwe804Geuyfu4bdY/OSeo++LasYPU6eesLi8XmTXAB3FJdNSmpOZllqkb5dAldG
	69Q1TAULhCtm3jjD0sB4mr+LkZNDQsBE4srdOWwQtpjEhXvrgWwuDiGBpYwSR09fYoRwPjFK
	HJ59naWLkYODV0BLYlafLUgDi4CqxPF7E5lAbDYBQ4neo32MILaoQIDE4iXn2EFsXgFBiR+T
	77GA2CICphJvX8xmApnJLLCKVeJ4725mkISwQIjE8mddzBDLLjNKXNz+ih1kGaeAnsSCzXYg
	NcwCOhL7W6exQdjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJCa/7GBcfMzqEKMAB6MSD++EZKMgIdbEsuLK3EOMEhzMSiK8s+4ChXhTEiurUovy
	44tKc1KLDzEycXBKNTAKfTcPKl4Yxt1953+gdJeo6Y1dQmr3lJZeP/vg6G95XT1pboat2ucU
	LwbfyZB6ZZ3z5JncPv7cdfx7WaM9Dx+42c7watstE3b3M6+WmciG852uyFnHukknPyzhk0CW
	RPjLLSGCJjvXrt60wOtN2GTG2ys97xU0T8wtO8BfYl6wYrp6f8aTkDYlluKMREMt5qLiRAAF
	eIoPpwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 08:54 AM, Mika Westerberg wrote:
> On Thu, Sep 12, 2013 at 02:34:21PM -0700, Kevin Hilman wrote:
>>> > > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>>> > > index f32ca29..44374b4 100644
>>> > > --- a/drivers/i2c/i2c-core.c
>>> > > +++ b/drivers/i2c/i2c-core.c
>>> > > @@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
>>> > >  					client->flags & I2C_CLIENT_WAKE);
>>> > >  	dev_dbg(dev, "probe\n");
>>> > >  
>>> > > +	/* Make sure the adapter is active */
>>> > > +	pm_runtime_get_sync(&client->adapter->dev);
>>> > > +
>>> > > +	/*
>>> > > +	 * Enable runtime PM for the client device. If the client wants to
>>> > > +	 * participate on runtime PM it should call pm_runtime_put() in its
>>> > > +	 * probe() callback.
>>> > > +	 */
>>> > > +	pm_runtime_get_noresume(&client->dev);
>>> > > +	pm_runtime_set_active(&client->dev);
>> > 
>> > Why the set_active here?
>> > 
>> > For hardware that is disabled/powered-off on startup, there will now be
>> > a mismatch between the hardware state an the RPM core state.
>
> The call to pm_runtime_get_noresume() should make sure that the device is
> in active state (at least in state where it can access the bus) if I'm
> understanding this right.

I can't see how this would happen. How runtime_resume/runtime_suspend
callbacks would get invoked with this code, if, e.g. originally driver called 
pm_runtime_enable(), pm_runtime_get_sync(), pm_runtime_put_sync() in probe() ? 

pm_runtime_get_noresume() merely increments usage counter of a device. 
It seems that these changes will break the s5p-tv driver. I might be missing 
something though.

As Mark pointed out this is currently unwanted behaviour to runtime PM
activate a bus controller device manually in the core for when the client's
probe() is executed, since i2c core will activate the bus controller for when 
transfer is being carried out.  
But I can understand this is needed for ACPI and it shouldn't break existing
drivers, that do runtime PM activate the client device in probe().

Now I'm sure this will break power management of the drivers/media/exynos4-is
driver, due to incorrect power sequence (power domain and clocks handling).
I'll try to take care of it in separate patch, as I have some patches pending,
that move most of code from drivers/media/exynos4-is/fimc-is-sensor.c to 
drivers/media/i2c/s5k6a3.c.

--
Regards,
Sylwester
