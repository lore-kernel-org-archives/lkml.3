Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab3BYWaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:30:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3BYW37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:29:59 -0500
Date: Mon, 25 Feb 2013 14:29:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: add devm_rtc_device_{register,unregister}()
Message-Id: <20130225142957.8e4aca8a.akpm@linux-foundation.org>
In-Reply-To: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
References: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013 16:35:53 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> These functios allows the driver core to automatically clean up
> any allocation made by rtc drivers. Thus, it simplifies the error
> paths.
> 
> ...
>
> @@ -259,6 +259,78 @@ void rtc_device_unregister(struct rtc_device *rtc)
>  }
>  EXPORT_SYMBOL_GPL(rtc_device_unregister);
>  
> +static void devm_rtc_device_release(struct device *dev, void *res)
> +{
> +	struct rtc_device *rtc = *(struct rtc_device **)res;
> +
> +	rtc_device_unregister(rtc);
> +}
> +
> +static int devm_rtc_device_match(struct device *dev, void *res, void *data)
> +{
> +	struct rtc **r = res;
> +	if (!r || !*r) {
> +		WARN_ON(!r || !*r);
> +		return 0;
> +	}

Use

	if (WARN_ON(!r || !*r))
		return 0;

However, if anyone ever reports this warning you will be sad because
you won't know which condition triggered it.  So a more useful approach
is

	if (WARN_ON(!r))
		return 0;
	if (WARN_ON(!*r))
		return 0;

> +	return *r == data;
> +}
> +
> +/**
> + * devm_rtc_device_register - resource managed rtc_device_register()
> + * @name: the name of the device
> + * @dev: the device to register
> + * @ops: the rtc operations structure
> + * @owner: the module owner
> + *
> + * Managed rtc_device_register(). The rtc_device returned from this function
> + * are automatically freed on driver detach. See rtc_device_register()
> + * for more information.
> + */

I think the name is inappropriate.  devm functions start with "devm"
and rtc functions start with "rtc" and this code is a part of rtc core,
not a part of devm core.  Hence it should be something like
"rtc_devm_device_register".

> +struct rtc_device *devm_rtc_device_register(const char *name,
> +					struct device *dev,
> +					const struct rtc_class_ops *ops,
> +					struct module *owner)
> +{
> +	struct rtc_device **ptr, *rtc;
> +
> +	ptr = devres_alloc(devm_rtc_device_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	rtc = rtc_device_register(name, dev, ops, owner);
> +	if (!IS_ERR(rtc)) {
> +		*ptr = rtc;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +
> +	return rtc;
> +}
> +EXPORT_SYMBOL_GPL(devm_rtc_device_register);

So this function will return an ERR_PTR on error.  Please add a
description of the return value into the kerneldoc.


> +/**
> + * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
> + * @dev: the device to unregister
> + * @rtc: the RTC class device to unregister
> + *
> + * Deallocated a rtc allocated with devm_rtc_device_register(). Normally this
> + * function will not need to be called and the resource management code will
> + * ensure that the resource is freed.
> + */
> +void devm_rtc_device_unregister(struct device *dev, struct rtc_device *rtc)
> +{
> +	int rc;
> +
> +	rc = devres_release(dev, devm_rtc_device_release,
> +				devm_rtc_device_match, rtc);
> +	if (rc != 0)
> +		WARN_ON(rc);

	WARN_ON(!rc);

> +}
> +EXPORT_SYMBOL_GPL(devm_rtc_device_unregister);
> +
>
> ...
>
