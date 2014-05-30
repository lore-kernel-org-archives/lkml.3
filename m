Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaE3Ifg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:35:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:49118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaE3Ifd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:35:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,939,1392192000"; 
   d="scan'208";a="520127894"
Date: Fri, 30 May 2014 11:35:28 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jean Delvare <khali@linux-fr.org>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] base: platform: name the device already during allocation
Message-ID: <20140530083528.GA10174@xps8300>
References: <1398686967-6086-1-git-send-email-heikki.krogerus@linux.intel.com>
 <20140528205806.GB3117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528205806.GB3117@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:58:06PM -0700, Greg KH wrote:
> On Mon, Apr 28, 2014 at 03:09:27PM +0300, Heikki Krogerus wrote:
> > This allows resources such as GPIOs and clocks, which can be
> > matched based on the device name when requested, to be
> > assigned even when PLATFORM_DEVID_AUTO is used.
> 
> Why would anyone want to do that?

The idea is to be able to share more resources of the parent device
with child platform devices that are created on fly without tricks.

Many frameworks offer lookup tables that we can use to bind the device
to a resource. I want to be able to always use those instead of being
forced to deliver the resources with platform_data in this kind of
cases..

> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  drivers/base/platform.c | 77 ++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 47 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 5b47210..697896d 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -174,11 +174,45 @@ struct platform_object {
> >   */
> >  void platform_device_put(struct platform_device *pdev)
> >  {
> > -	if (pdev)
> > -		put_device(&pdev->dev);
> > +	if (!pdev)
> > +		return;
> > +
> > +	if (pdev->id_auto) {
> > +		ida_simple_remove(&platform_devid_ida, pdev->id);
> > +		pdev->id = PLATFORM_DEVID_AUTO;
> > +	}
> > +
> > +	put_device(&pdev->dev);
> >  }
> >  EXPORT_SYMBOL_GPL(platform_device_put);
> >  
> > +static int pdev_set_name(struct platform_device *pdev)
> > +{
> > +	int ret;
> > +
> > +	switch (pdev->id) {
> > +	default:
> > +		return dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
> > +	case PLATFORM_DEVID_NONE:
> > +		return dev_set_name(&pdev->dev, "%s", pdev->name);
> > +	case PLATFORM_DEVID_AUTO:
> > +		/*
> > +		 * Automatically allocated device ID. We mark it as such so
> > +		 * that we remember it must be freed, and we append a suffix
> > +		 * to avoid namespace collision with explicit IDs.
> > +		 */
> > +		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
> > +		if (ret < 0)
> > +			return ret;
> > +		pdev->id = ret;
> > +		pdev->id_auto = true;
> > +		return dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name,
> > +				    pdev->id);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static void platform_device_release(struct device *dev)
> >  {
> >  	struct platform_object *pa = container_of(dev, struct platform_object,
> > @@ -211,6 +245,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
> >  		device_initialize(&pa->pdev.dev);
> >  		pa->pdev.dev.release = platform_device_release;
> >  		arch_setup_pdev_archdata(&pa->pdev);
> > +		if (pdev_set_name(&pa->pdev)) {
> > +			kfree(pa);
> > +			return NULL;
> > +		}
> >  	}
> >  
> >  	return pa ? &pa->pdev : NULL;
> > @@ -291,28 +329,6 @@ int platform_device_add(struct platform_device *pdev)
> >  
> >  	pdev->dev.bus = &platform_bus_type;
> >  
> > -	switch (pdev->id) {
> > -	default:
> > -		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
> > -		break;
> > -	case PLATFORM_DEVID_NONE:
> > -		dev_set_name(&pdev->dev, "%s", pdev->name);
> > -		break;
> > -	case PLATFORM_DEVID_AUTO:
> > -		/*
> > -		 * Automatically allocated device ID. We mark it as such so
> > -		 * that we remember it must be freed, and we append a suffix
> > -		 * to avoid namespace collision with explicit IDs.
> > -		 */
> > -		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
> > -		if (ret < 0)
> > -			goto err_out;
> > -		pdev->id = ret;
> > -		pdev->id_auto = true;
> > -		dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name, pdev->id);
> > -		break;
> > -	}
> > -
> >  	for (i = 0; i < pdev->num_resources; i++) {
> >  		struct resource *p, *r = &pdev->resource[i];
> >  
> > @@ -355,7 +371,6 @@ int platform_device_add(struct platform_device *pdev)
> >  			release_resource(r);
> >  	}
> >  
> > - err_out:
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(platform_device_add);
> > @@ -375,11 +390,6 @@ void platform_device_del(struct platform_device *pdev)
> >  	if (pdev) {
> >  		device_del(&pdev->dev);
> >  
> > -		if (pdev->id_auto) {
> > -			ida_simple_remove(&platform_devid_ida, pdev->id);
> > -			pdev->id = PLATFORM_DEVID_AUTO;
> > -		}
> > -
> >  		for (i = 0; i < pdev->num_resources; i++) {
> >  			struct resource *r = &pdev->resource[i];
> >  			unsigned long type = resource_type(r);
> > @@ -397,8 +407,15 @@ EXPORT_SYMBOL_GPL(platform_device_del);
> >   */
> >  int platform_device_register(struct platform_device *pdev)
> >  {
> > +	int ret;
> > +
> >  	device_initialize(&pdev->dev);
> >  	arch_setup_pdev_archdata(pdev);
> > +
> > +	ret = pdev_set_name(pdev);
> > +	if (ret)
> > +		return ret;
> > +
> >  	return platform_device_add(pdev);
> >  }
> >  EXPORT_SYMBOL_GPL(platform_device_register);
> > -- 
> > 2.0.0.rc0
> 
> I don't understand the usage of this, what drivers want/need this
> change?

The most common things where you have the parent sharing stuff like
the clocks and GPIOs are the probe drivers, and quite often you see
the platform_data being used there just for that.

The first place I want to use this is drivers/usb/dwc3/host.c. We need
to share at least the PHYs of the core dwc3 with the xHCI platform
device that is created there. Now it's not possible to share them by
adding a lookup entry because we can not be certain of the device name
of the platform device before platform_device_add() is called, and
that is of course too late. By the time it returns, xHCI will have
already requested things like the PHYs.

So I guess this is actually about reducing the need for driver
specific platform data (or at least my hate towards them). With things
like clocks, GPIOs, DMA channels, PHYs, etc., if the frameworks offer
the lookup tables, the drivers really don't need the platform_data to
get them. Actually, IMO it should always be possible and also enough
for the drivers to simply request that kind of resources
unconditionally, without any specific data. The drivers simply should
not need to care about any details related to them.


-- 
heikki
