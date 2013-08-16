Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3HQALA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:11:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3HQAKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:10:50 -0400
Date: Fri, 16 Aug 2013 14:06:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130816210637.GC2198@kroah.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376685563-1053-3-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:39:21PM +0200, Thierry Reding wrote:
> +static DEFINE_MUTEX(device_early_mutex);
> +static LIST_HEAD(device_early_list);
> +static bool device_is_early = true;
> +
> +/*
> + * Keep a list of early registered devices so that they can be fully
> + * registered at a later point in time.
> + */
> +static void device_early_add(struct device *dev)

__init?

> +{
> +	mutex_lock(&device_early_mutex);
> +	list_add_tail(&dev->p->early, &device_early_list);
> +	mutex_unlock(&device_early_mutex);
> +}
> +
> +/*
> + * Mark the early device registration phase as completed.
> + */
> +int __init device_early_init(void)
> +{
> +	device_is_early = false;
> +
> +	return 0;
> +}
> +
> +/*
> + * Fixup platform devices instantiated from device tree. The problem is
> + * that since early registration happens before interrupt controllers
> + * have been setup, the OF core code won't know how to map interrupts.
> + */
> +int __init platform_device_early_fixup(struct platform_device *pdev)

This shouldn't be in this file, because:

> +/*
> + * Fully register early devices.
> + */
> +int __init device_early_done(void)
> +{
> +	struct device_private *private;
> +
> +	list_for_each_entry(private, &device_early_list, early) {
> +		struct device *dev = private->device;
> +		int err;
> +
> +		if (dev->bus == &platform_bus_type) {

Why special case the platform bus?  We are trying to move things off of
the platform bus, don't make it harder to do that :)

> +			struct platform_device *pdev = to_platform_device(dev);
> +
> +			err = platform_device_early_fixup(pdev);
> +			if (err < 0)
> +				dev_err(&pdev->dev,
> +					"failed to fixup device %s: %d\n",
> +					dev_name(&pdev->dev), err);
> +		}

You should just have a bus callback that can be made here that, if
present, can be called.  That way any bus can handle this type of thing,
not just the platform one.


Not that I really like the whole idea anyway, but I doubt there's much I
can do about it...

thanks,

greg k-h
