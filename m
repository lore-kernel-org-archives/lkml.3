Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3GXQ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:26:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3GXQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:26:06 -0400
Date: Wed, 24 Jul 2013 09:26:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: Re: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Message-ID: <20130724162605.GA9700@kroah.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
 <20130724160008.GA17083@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:20:32PM +0000, Winkler, Tomas wrote:
> 
> 
> > >  int mei_register(struct mei_device *dev)  {
> > > +	struct device *device = &dev->pdev->dev;
> > >  	int ret;
> > > -	mei_misc_device.parent = &dev->pdev->dev;
> > > +
> > > +	mei_misc_device.parent = device;
> > >  	ret = misc_register(&mei_misc_device);
> > >  	if (ret)
> > >  		return ret;
> > >
> > > +	ret = sysfs_create_group(&device->kobj, &mei_attr_group);
> > > +	if (ret)
> > > +		return ret;
> > 
> 
> > And you just lost the race with userspace (you told it you had a device, it
> > went and scanned your attributes and saved them, then you registered
> > more...)
> > 
> > Please use the dev_groups field for your class to properly have the driver
> > core register these before userspace is told about the device, that's the
> > correct way to do this.
> 
> Just to make sure, is this what you're suggesting ?
> 
> device->groups = mei_attr_groups
> mei_misc_device.parent = device;
> ret = misc_register(&mei_misc_device);

Yes, that should work.  If not, please let me know, the code underwent
some changes in 3.11-rc2.

thanks,

greg k-h
