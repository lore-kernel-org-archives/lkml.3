Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3EXU1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:27:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3EXU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:27:52 -0400
Date: Fri, 24 May 2013 13:27:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jg1.han@samsung.com
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH 1/2] backlight: add
 devm_backlight_device_{register,unregister}()
Message-Id: <20130524132751.8bbcf26cb02c78ad9a8b7d80@linux-foundation.org>
In-Reply-To: <20226221.131531368682106551.JavaMail.weblogic@epml12>
References: <20226221.131531368682106551.JavaMail.weblogic@epml12>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013 05:28:26 +0000 (GMT) Jingoo Han <jg1.han@samsung.com> wrote:

> These functions allow the driver core to automatically clean up any
> allocation made by backlight drivers. Thus it simplifies the error
> paths.
> 
> ...
>
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -370,6 +370,81 @@ void backlight_device_unregister(struct backlight_device *bd)
>  }
>  EXPORT_SYMBOL(backlight_device_unregister);
>  
> +static void devm_backlight_device_release(struct device *dev, void *res)
> +{
> +	struct backlight_device *backlight = *(struct backlight_device **)res;
> +
> +	backlight_device_unregister(backlight);
> +}
>
> ...
>
> +struct backlight_device *devm_backlight_device_register(struct device *dev,
> +	const char *name, struct device *parent, void *devdata,
> +	const struct backlight_ops *ops,
> +	const struct backlight_properties *props)
> +{
> +	struct backlight_device **ptr, *backlight;
> +
> +	ptr = devres_alloc(devm_backlight_device_release, sizeof(*ptr),
> +			GFP_KERNEL);

Well this is an awkward-looking thing.  We allocate a silly little 4-
or 8-byte object just to track the backlight_device* via the devres
system.

I assume this was done so that devres could be used as a wrapper around
the existing code?  

Really it would be better if things like backlight_device_register()
were themselves directly converted to use devm_foo(), yes?

