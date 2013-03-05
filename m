Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3CEVd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:33:58 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55220 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CEVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:33:56 -0500
Date: Wed, 6 Mar 2013 05:34:16 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, thierry.reding@avionic-design.de,
        rob@landley.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC] pwm: add sysfs interface
Message-ID: <20130305213416.GA10758@kroah.com>
References: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de>
 <20130225040025.GB7911@kroah.com>
 <201303051546.13636.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303051546.13636.poeschel@lemonage.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 03:46:13PM +0100, Lars Poeschel wrote:
> At first: Thanks for your review!
> 
> On Monday 25 February 2013 at 05:00:25, Greg KH wrote:
> > On Tue, Feb 19, 2013 at 03:27:41PM +0100, Lars Poeschel wrote:
> > > +static int pwmchip_export(struct pwm_chip *chip)
> > > +{
> > > +	int status;
> > > +	struct device *dev;
> > > +
> > > +	mutex_lock(&sysfs_lock);
> > > +	dev = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> > > +				"pwmchip%d", chip->base);
> > > +	if (!IS_ERR(dev))
> > > +		status = sysfs_create_group(&dev->kobj, &pwmchip_attr_group);
> > > +	else
> > > +		status = PTR_ERR(dev);
> > 
> > You can't create sysfs files after the device has been exposed to
> > userspace.  Please use the default group functionality for the class,
> > which fixes this problem.
> 
> I don't understand, what is wrong here. This is the same that gpio sysfs 
> does. Could you please be a bit more specific ?
> I create a new device using device_create and create a new group with it with 
> some attributes. Isn't it exposed to userspace after that ?

The device was exposed to userspace when you called device_create(), so
any program is then free to start looking for attributes.  It will not
find them because you haven't created them yet.

To prevent this race from happening, use the default attribute group for
the class to create the attributes before the device is announced to
userspace by the driver core.

That is what the dev_attrs pointer is for in 'struct class'.

Hope this helps,

greg k-h
