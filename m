Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaBJRnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:43:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaBJRna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:43:30 -0500
Date: Mon, 10 Feb 2014 18:43:23 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laszlo Papp <lpapp@kde.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (max6650) Rename the device ids to  contain the
 hwmon suffix
Message-ID: <20140210184323.456e921c@endymion.delvare>
In-Reply-To: <20140210165853.GD26997@lee--X1>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<20140210165853.GD26997@lee--X1>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, 10 Feb 2014 16:58:53 +0000, Lee Jones wrote:
> > > >  static const struct i2c_device_id max6650_id[] = {
> > > > -	{ "max6650", 1 },
> > > > -	{ "max6651", 4 },
> > > > +	{ "max6650-hwmon", 1 },
> > > > +	{ "max6651-hwmon", 4 },
> > 
> > No, this is not acceptable, sorry. This will change the name of the
> > hwmon device as seen from user-space, breaking any configuration file
> > referring to it. Additionally, dashes are explicitly forbidden in hwmon
> > device names. And lastly this will break any explicit instantiation of
> > theses devices (which is the only way, as the driver doesn't support
> > device auto-detection), be it in the kernel itself or from user-space.
> > 
> > The change doesn't make sense anyway. If you move to the MFD framework,
> > the core driver will be an I2C driver binding to the I2C device, and it
> > will spawn the logical devices, presumably in the form of platform
> > devices. That's what the current max6650 driver would have to bind to.
> > Just renaming the device won't work, you also need to change the type.
> > 
> > If you want to turn this into an MFD driver, I believe you must first
> > convert the hwmon part to register using
> > devm_hwmon_device_register_with_groups(). This will dissociate the i2c
> > device name from the hwmon device name and create a clean name-space
> > for each function. Guenter, maybe you had a plan to do so already
> > anyway?
> > 
> > That being said, going with MFD in this case seems quite overkill to
> > me. MFD makes a lot of sense when each function has its own resources.
> > As this isn't the case here, a single driver registering both an hwmon
> > interface and a pinctrl interface would seem sufficient to me. But I
> > think Guenter already discussed this in the past so I'll let him
> > continue and decide.
> 
> I'll get you guys decide if you want to go the MFD route or not.
> 
> Either is okay with me, but if you do decide in favour, a name change
> with the device type appended would be preferred. Else the core device
> would have the same name as all of its children which would be quite
> unworkable.

No problem with that. The main (I2C) device should be named max6650 (or
max6651), the subdevices can be named whatever you want, as long as the
hwmon (class) device's name attribute is also "max6650" (or "max6651".)
As stated above, this is required to preserve compatibility with
existing users.

> > > Might be worth taking the opportunity to swap out these magic numbers
> > > now.
> > 
> > There's nothing magic about them, they tell the driver how many fans
> > each device supports. If you don't pass them as driver_data you'll have
> > to derive them from the device name in the probe function.
> 
> They're magic in that they're not easily identifiable. In the few
> moments that I looked at the patch I assumed they were device
> IDs. They should be clearly defined.

They could have been device IDs, some drivers do that, and that would
have been equally fine. driver_data can be anything. Best thing to do
is to document it right above the device id array if you really find it
confusing (I don't.) I don't know what else exactly you had in mind,
but #defining FOUR_FANS as 4 and ONE_FAN as 1 and using that doesn't
strike me as the best coding practice.

-- 
Jean Delvare
Suse L3 Support
