Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaBZMO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:14:56 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44474 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaBZMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:14:53 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 06/11] drivers: of: initialize and assign reserved memory to newly created devices
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1392985527-6260-7-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com> < 1392985527-6260-7-git-send-email-m.szyprowski@samsung.com>
Date: Wed, 26 Feb 2014 12:14:45 +0000
Message-Id: <20140226121445.54D2DC40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 13:25:22 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Use recently introduced of_reserved_mem_device_init() function to
> automatically assign respective reserved memory region to the newly created
> platform and amba device.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

I'm wary on this patch. It hides the assignment of regions into the core
code and I worry that it is the wrong level of abstraction. I would
think that drivers should know that they need a reserved memory region
and should be calling the API to obtain the region directly rather than
doing it for them. The reason being is that there may be some situations
where the common code isn't quite right and the driver needs to override
the behaviour. If it is called automatically then the driver cannot do
that.

Is it really a big burden to have the driver call the reserved memory
init function?

g.

> ---
>  drivers/of/platform.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1daebefa..3df0b1826e8b 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -21,6 +21,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_reserved_mem.h>
>  #include <linux/platform_device.h>
>  
>  const struct of_device_id of_default_bus_match_table[] = {
> @@ -220,6 +221,8 @@ static struct platform_device *of_platform_device_create_pdata(
>  	dev->dev.bus = &platform_bus_type;
>  	dev->dev.platform_data = platform_data;
>  
> +	of_reserved_mem_device_init(&dev->dev);
> +
>  	/* We do not fill the DMA ops for platform devices by default.
>  	 * This is currently the responsibility of the platform code
>  	 * to do such, possibly using a device notifier
> @@ -227,6 +230,7 @@ static struct platform_device *of_platform_device_create_pdata(
>  
>  	if (of_device_add(dev) != 0) {
>  		platform_device_put(dev);
> +		of_reserved_mem_device_release(&dev->dev);
>  		return NULL;
>  	}
>  
> @@ -282,6 +286,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	else
>  		of_device_make_bus_id(&dev->dev);
>  
> +	of_reserved_mem_device_init(&dev->dev);
> +
>  	/* Allow the HW Peripheral ID to be overridden */
>  	prop = of_get_property(node, "arm,primecell-periphid", NULL);
>  	if (prop)
> @@ -308,6 +314,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	return dev;
>  
>  err_free:
> +	of_reserved_mem_device_release(&dev->dev);
>  	amba_device_put(dev);
>  	return NULL;
>  }
> -- 
> 1.7.9.5
> 

