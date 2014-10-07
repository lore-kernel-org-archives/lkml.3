Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaJGJJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:09:33 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:32875 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaJGJJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:09:31 -0400
Date: Tue, 7 Oct 2014 10:09:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, b29396@freescale.com,
        boris.brezillon@free-electrons.com, tomasz.figa@gmail.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, kgene.kim@samsung.com, Li.Xiubo@freescale.com,
        geert+renesas@glider.be, swarren@nvidia.com
Subject: Re: [PATCH v7] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20141007090923.GI25331@lee--X1>
References: <1412066127-27063-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412066127-27063-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Pankaj Dubey wrote:

> Currently a syscon entity can be only registered directly through a
> platform device that binds to a dedicated syscon driver. However in
> certain use cases it is desirable to make a device used with another
> driver a syscon interface provider.
> 
> For example, certain SoCs (e.g. Exynos) contain system controller
> blocks which perform various functions such as power domain control,
> CPU power management, low power mode control, but in addition contain
> certain IP integration glue, such as various signal masks,
> coprocessor power control, etc. In such case, there is a need to have
> a dedicated driver for such system controller but also share registers
> with other drivers. The latter is where the syscon interface is helpful.
> 
> In case of DT based platforms, this patch decouples syscon object from
> syscon platform driver, and allows to create syscon objects first time
> when it is required by calling of syscon_regmap_lookup_by APIs and keep
> a list of such syscon objects along with syscon provider device_nodes
> and regmap handles.
> 
> For non-DT based platforms, this patch keeps syscon platform driver
> structure so that syscon can be probed and such non-DT based drivers
> can use syscon_regmap_lookup_by_pdev API and access regmap handles.
> Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> we can completely remove platform driver of syscon, and keep only helper
> functions to get regmap handles.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Applied for v3.19.

> ---
> Patch v6 and related discussions can be found here [1].
> 
> Change since v5:
>  - Addressed review comments from "Heiko Stuebner".
>  - Updated commit description.
>  - Including Arnd's and Heiko's Reviewed-by.
> 
> Change since v5:
>  - Dropping creation of dummy platform device in of_syscon_register.
>  - As we are changing syscon to decouple from platform_device, creation of 
>    dummy platform_device does not look good option, and as suggested by Arnd,
>    I made another attempt so that regmap_mmio_init API should work with NULL
>    dev pointer itself. Since regmap needs to know about Syscon device node
>    properties so let's parse device node of syscon in syscon itself for any
>    such properties and using regmap_config parameter pass all such information
>    to regmap. Other concern of crashes due to NULL dev pointer in regmap already
>    addressed in separate patches of regmap. Please see [2] and [3].
> 
> Changes since v4:
>  - Addressed Tomasz Figa's comments for v4.
>  - Added error handing in of_syscon_register function.
>  - Using devm_regmap_init_mmio instead of regmap_init_mmio.
> 
> Changes since v3:
>  - Addressed Arnd's comment for v2.
>  - Updated of_syscon_register for adding dev pointer in regmap_init_mmio.
>  - For early users created dummy platform device.
> 
> Changes since v2:
>  - Added back platform device support from syscon, with one change that
>    syscon will not be probed for DT based platform.
>  - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
>    users of syscon will not be broken.
>  - Removed unwanted change in syscon.h.
>  - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
>    Arnd Bergmann.
>  - Added Tested-by of Vivek Gautam for testing on Exynos platform.
> 
> Changes since v1:
>  - Removed of_syscon_unregister function.
>  - Modified of_syscon_register function and it will be used by syscon.c
>    to create syscon objects whenever required.
>  - Removed platform device support from syscon.
>  - Removed syscon_regmap_lookup_by_pdevname API support.
>  - As there are significant changes w.r.t patchset v1, I am taking over
>    author for this patchset from Tomasz Figa.
> 
> [1]: https://lkml.org/lkml/2014/9/29/99
> [2]: https://lkml.org/lkml/2014/9/18/130
> [3]: https://lkml.org/lkml/2014/9/27/2
>  drivers/mfd/syscon.c |   96 ++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 74 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index ca15878..72373b1 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -15,6 +15,7 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> +#include <linux/list.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
> @@ -22,31 +23,94 @@
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/syscon.h>
> +#include <linux/slab.h>
>  
>  static struct platform_driver syscon_driver;
>  
> +static DEFINE_SPINLOCK(syscon_list_slock);
> +static LIST_HEAD(syscon_list);
> +
>  struct syscon {
> +	struct device_node *np;
>  	struct regmap *regmap;
> +	struct list_head list;
> +};
> +
> +static struct regmap_config syscon_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
>  };
>  
> -static int syscon_match_node(struct device *dev, void *data)
> +static struct syscon *of_syscon_register(struct device_node *np)
>  {
> -	struct device_node *dn = data;
> +	struct syscon *syscon;
> +	struct regmap *regmap;
> +	void __iomem *base;
> +	int ret;
> +	struct regmap_config syscon_config = syscon_regmap_config;
> +
> +	if (!of_device_is_compatible(np, "syscon"))
> +		return ERR_PTR(-EINVAL);
> +
> +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> +	if (!syscon)
> +		return ERR_PTR(-ENOMEM);
> +
> +	base = of_iomap(np, 0);
> +	if (!base) {
> +		ret = -ENOMEM;
> +		goto err_map;
> +	}
> +
> +	/* Parse the device's DT node for an endianness specification */
> +	if (of_property_read_bool(np, "big-endian"))
> +		syscon_config.val_format_endian = REGMAP_ENDIAN_BIG;
> +	 else if (of_property_read_bool(np, "little-endian"))
> +		syscon_config.val_format_endian = REGMAP_ENDIAN_LITTLE;
> +
> +	regmap = regmap_init_mmio(NULL, base, &syscon_config);
> +	if (IS_ERR(regmap)) {
> +		pr_err("regmap init failed\n");
> +		ret = PTR_ERR(regmap);
> +		goto err_regmap;
> +	}
> +
> +	syscon->regmap = regmap;
> +	syscon->np = np;
> +
> +	spin_lock(&syscon_list_slock);
> +	list_add_tail(&syscon->list, &syscon_list);
> +	spin_unlock(&syscon_list_slock);
>  
> -	return (dev->of_node == dn) ? 1 : 0;
> +	return syscon;
> +
> +err_regmap:
> +	iounmap(base);
> +err_map:
> +	kfree(syscon);
> +	return ERR_PTR(ret);
>  }
>  
>  struct regmap *syscon_node_to_regmap(struct device_node *np)
>  {
> -	struct syscon *syscon;
> -	struct device *dev;
> +	struct syscon *entry, *syscon = NULL;
>  
> -	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> -				 syscon_match_node);
> -	if (!dev)
> -		return ERR_PTR(-EPROBE_DEFER);
> +	spin_lock(&syscon_list_slock);
>  
> -	syscon = dev_get_drvdata(dev);
> +	list_for_each_entry(entry, &syscon_list, list)
> +		if (entry->np == np) {
> +			syscon = entry;
> +			break;
> +		}
> +
> +	spin_unlock(&syscon_list_slock);
> +
> +	if (!syscon)
> +		syscon = of_syscon_register(np);
> +
> +	if (IS_ERR(syscon))
> +		return ERR_CAST(syscon);
>  
>  	return syscon->regmap;
>  }
> @@ -110,17 +174,6 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
>  
> -static const struct of_device_id of_syscon_match[] = {
> -	{ .compatible = "syscon", },
> -	{ },
> -};
> -
> -static struct regmap_config syscon_regmap_config = {
> -	.reg_bits = 32,
> -	.val_bits = 32,
> -	.reg_stride = 4,
> -};
> -
>  static int syscon_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -167,7 +220,6 @@ static struct platform_driver syscon_driver = {
>  	.driver = {
>  		.name = "syscon",
>  		.owner = THIS_MODULE,
> -		.of_match_table = of_syscon_match,
>  	},
>  	.probe		= syscon_probe,
>  	.id_table	= syscon_ids,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
