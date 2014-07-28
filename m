Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaG1ORJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:17:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39918 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaG1ORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:17:07 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 RESEND 2/4] drivers: of: initialize and assign
 reserved memory to newly created devices
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1405326487-15346-3-git-send-email-m.szyprowski@samsung.com>
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
	<1405326487-15346-3-git-send-email-m.szyprowski@samsung.com>
Date: Mon, 28 Jul 2014 08:17:00 -0600
Message-Id: <20140728141700.55FC4C408EA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 10:28:05 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Use recently introduced of_reserved_mem_device_init() function to
> automatically assign respective reserved memory region to the newly created
> platform and amba device.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

I'm still not okay with this patch. I don't think it is appropriate to
add the hook into the generic path that gets used for every platform
device. The devices that need reserved memory should explicitly request
it, and any setup be done at that time.

g.

> ---
>  drivers/of/platform.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 500436f9be7f..a9055d3da5c2 100644
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
> @@ -233,12 +234,15 @@ static struct platform_device *of_platform_device_create_pdata(
>  	dev->dev.bus = &platform_bus_type;
>  	dev->dev.platform_data = platform_data;
>  
> +	of_reserved_mem_device_init(&dev->dev);
> +
>  	/* We do not fill the DMA ops for platform devices by default.
>  	 * This is currently the responsibility of the platform code
>  	 * to do such, possibly using a device notifier
>  	 */
>  
>  	if (of_device_add(dev) != 0) {
> +		of_reserved_mem_device_release(&dev->dev);
>  		platform_device_put(dev);
>  		goto err_clear_flag;
>  	}
> @@ -300,6 +304,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	else
>  		of_device_make_bus_id(&dev->dev);
>  
> +	of_reserved_mem_device_init(&dev->dev);
> +
>  	/* Allow the HW Peripheral ID to be overridden */
>  	prop = of_get_property(node, "arm,primecell-periphid", NULL);
>  	if (prop)
> @@ -326,6 +332,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	return dev;
>  
>  err_free:
> +	of_reserved_mem_device_release(&dev->dev);
>  	amba_device_put(dev);
>  err_clear_flag:
>  	of_node_clear_flag(node, OF_POPULATED);
> -- 
> 1.9.2
> 

