Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbaGZUNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:13:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbaGZUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:13:52 -0400
Date: Sat, 26 Jul 2014 13:13:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] platform: Make platform_bus device a platform device
Message-ID: <20140726201351.GC21870@kroah.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
 <1406298233-27876-5-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406298233-27876-5-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 03:23:53PM +0100, Pawel Moll wrote:
> ... describing the root of the device tree, so one can write
> a platform driver initializing the platform.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/base/platform.c         | 20 ++++++++++++++------
>  include/linux/platform_device.h |  2 +-
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index eee48c4..9caffa7 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -30,8 +30,8 @@
>  /* For automatically allocated device IDs */
>  static DEFINE_IDA(platform_devid_ida);
>  
> -struct device platform_bus = {
> -	.init_name	= "platform",
> +struct platform_device platform_bus = {
> +	.name	= "platform",
>  };
>  EXPORT_SYMBOL_GPL(platform_bus);
>  
> @@ -300,7 +300,7 @@ int platform_device_add(struct platform_device *pdev)
>  		return -EINVAL;
>  
>  	if (!pdev->dev.parent)
> -		pdev->dev.parent = &platform_bus;
> +		pdev->dev.parent = &platform_bus.dev;
>  
>  	pdev->dev.bus = &platform_bus_type;
>  
> @@ -946,12 +946,20 @@ int __init platform_bus_init(void)
>  
>  	early_platform_cleanup();
>  
> -	error = device_register(&platform_bus);
> +	dev_set_name(&platform_bus.dev, "%s", platform_bus.name);
> +	error = device_register(&platform_bus.dev);
>  	if (error)
>  		return error;
>  	error =  bus_register(&platform_bus_type);
> -	if (error)
> -		device_unregister(&platform_bus);
> +	if (!error) {
> +#ifdef CONFIG_OF
> +		platform_bus.dev.of_node = of_allnodes;
> +#endif

Why are you doing this?  The original code didn't do it and all was
fine, right?  What changes here?

thanks,

greg k-h
