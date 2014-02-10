Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaBJQiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:38:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaBJQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:38:16 -0500
Date: Mon, 10 Feb 2014 17:38:11 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laszlo Papp <lpapp@kde.org>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
  contain the hwmon suffix
Message-ID: <20140210173811.04ba5964@endymion.delvare>
In-Reply-To: <20140210160842.GB26997@lee--X1>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee, Laszlo,

On Mon, 10 Feb 2014 16:08:42 +0000, Lee Jones wrote:
> > In the preparation of creating an mfd driver and then refactor this one into a
> > platform driver in order to add some pinctrl functionality to the chip, it is
> > necessary to start the series with this change so that the mfd driver can refer
> > to the proper name in the subsequent change without making changes in more than
> > one driver later.
> > 
> > This was a request from Lee Jones, the MFD subsystem maintainer.
> > 
> > Signed-off-by: Laszlo Papp <lpapp@kde.org>
> > ---
> >  drivers/hwmon/max6650.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
> > index 0cafc39..3c36edc 100644
> > --- a/drivers/hwmon/max6650.c
> > +++ b/drivers/hwmon/max6650.c
> > @@ -116,8 +116,8 @@ static struct max6650_data *max6650_update_device(struct device *dev);
> >   */
> >  
> >  static const struct i2c_device_id max6650_id[] = {
> > -	{ "max6650", 1 },
> > -	{ "max6651", 4 },
> > +	{ "max6650-hwmon", 1 },
> > +	{ "max6651-hwmon", 4 },

No, this is not acceptable, sorry. This will change the name of the
hwmon device as seen from user-space, breaking any configuration file
referring to it. Additionally, dashes are explicitly forbidden in hwmon
device names. And lastly this will break any explicit instantiation of
theses devices (which is the only way, as the driver doesn't support
device auto-detection), be it in the kernel itself or from user-space.

The change doesn't make sense anyway. If you move to the MFD framework,
the core driver will be an I2C driver binding to the I2C device, and it
will spawn the logical devices, presumably in the form of platform
devices. That's what the current max6650 driver would have to bind to.
Just renaming the device won't work, you also need to change the type.

If you want to turn this into an MFD driver, I believe you must first
convert the hwmon part to register using
devm_hwmon_device_register_with_groups(). This will dissociate the i2c
device name from the hwmon device name and create a clean name-space
for each function. Guenter, maybe you had a plan to do so already
anyway?

That being said, going with MFD in this case seems quite overkill to
me. MFD makes a lot of sense when each function has its own resources.
As this isn't the case here, a single driver registering both an hwmon
interface and a pinctrl interface would seem sufficient to me. But I
think Guenter already discussed this in the past so I'll let him
continue and decide.

> Might be worth taking the opportunity to swap out these magic numbers
> now.

There's nothing magic about them, they tell the driver how many fans
each device supports. If you don't pass them as driver_data you'll have
to derive them from the device name in the probe function.

> >  	{ }
> >  };
> >  MODULE_DEVICE_TABLE(i2c, max6650_id);
> 


-- 
Jean Delvare
Suse L3 Support
