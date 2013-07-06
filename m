Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3GFTau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 15:30:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3GFTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 15:30:48 -0400
Date: Sat, 6 Jul 2013 12:31:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] hwmon: (ds1621) Convert to use
 hwmon_device_register_groups
Message-ID: <20130706193142.GA9778@kroah.com>
References: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
 <1373131495-13465-4-git-send-email-linux@roeck-us.net>
 <20130706175747.GA8658@kroah.com>
 <20130706200151.70b7ac3d@endymion.delvare>
 <20130706191816.GA15066@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130706191816.GA15066@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:18:16PM -0700, Guenter Roeck wrote:
> On Sat, Jul 06, 2013 at 08:01:51PM +0200, Jean Delvare wrote:
> > On Sat, 6 Jul 2013 10:57:47 -0700, Greg Kroah-Hartman wrote:
> > > On Sat, Jul 06, 2013 at 10:24:53AM -0700, Guenter Roeck wrote:
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > ---
> > > >  drivers/hwmon/ds1621.c |   25 +++++++++----------------
> > > >  1 file changed, 9 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
> > > > index a26ba7a..f1d0fa0 100644
> > > > --- a/drivers/hwmon/ds1621.c
> > > > +++ b/drivers/hwmon/ds1621.c
> > > > @@ -358,11 +358,15 @@ static const struct attribute_group ds1621_group = {
> > > >  	.is_visible = ds1621_attribute_visible
> > > >  };
> > > >  
> > > > +static const struct attribute_group *ds1621_groups[] = {
> > > > +	&ds1621_group,
> > > > +	NULL
> > > > +};
> > > > +
> > > >  static int ds1621_probe(struct i2c_client *client,
> > > >  			const struct i2c_device_id *id)
> > > >  {
> > > >  	struct ds1621_data *data;
> > > > -	int err;
> > > >  
> > > >  	data = devm_kzalloc(&client->dev, sizeof(struct ds1621_data),
> > > >  			    GFP_KERNEL);
> > > > @@ -377,22 +381,12 @@ static int ds1621_probe(struct i2c_client *client,
> > > >  	/* Initialize the DS1621 chip */
> > > >  	ds1621_init_client(client);
> > > >  
> > > > -	/* Register sysfs hooks */
> > > > -	err = sysfs_create_group(&client->dev.kobj, &ds1621_group);
> > > > -	if (err)
> > > > -		return err;
> > > > -
> > > > -	data->hwmon_dev = hwmon_device_register(&client->dev);
> > > > -	if (IS_ERR(data->hwmon_dev)) {
> > > > -		err = PTR_ERR(data->hwmon_dev);
> > > > -		goto exit_remove_files;
> > > > -	}
> > > > +	data->hwmon_dev = hwmon_device_register_groups(&client->dev, data,
> > > > +						       ds1621_groups);
> > > > +	if (IS_ERR(data->hwmon_dev))
> > > > +		return PTR_ERR(data->hwmon_dev);
> > > >  
> > > >  	return 0;
> > > > -
> > > > - exit_remove_files:
> > > > -	sysfs_remove_group(&client->dev.kobj, &ds1621_group);
> > > > -	return err;
> > > 
> > > Aren't your sysfs files now being created attached to a different device
> > > than they originally were?  Before this patch, they were being attached
> > > to the parent device of the hwmon device being created with the call to
> > > hwmon_device_register(), and now they are attached to the device created
> > > with that call.
> > > 
> > > Is that what you really want?  Can userspace handle this movement of
> > > files?
> > 
> > libsensors supports both, as well as pwmconfig/fancontrol. Some drivers
> > are already doing that so every application dealing with hwmon devices
> > should handle it already.
> > 
> Yes, and I tested it with the new nct6775 driver to make sure that it works.
> The i2c and spi drivers need some more work, though - the name attribute is
> now missing and will have to be created for the hwmon device itself. If you have
> an idea how to do that without adding it in every driver, please let me know.

Why do you need a name attribute at all?  Shouldn't that just be the
name of the device, or the parent?

Can you make the name be part of the groups always?

greg k-h
