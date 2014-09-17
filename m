Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaIQJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:58:24 -0400
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:64384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753853AbaIQJ6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:58:22 -0400
X-Greylist: delayed 1091 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 05:58:21 EDT
Date: Wed, 17 Sep 2014 16:58:42 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <naushad@samsung.com>, <tomasz.figa@gmail.com>, <joshi@samsung.com>,
        <thomas.ab@samsung.com>, <vikas.sajjan@samsung.com>,
        <chow.kim@samsung.com>, <lee.jones@linaro.org>
Subject: Re: [PATCH v3] mfd: syscon: Decouple syscon interface from
 platform devices
Message-ID: <20140917085818.GA10285@shlinux1.ap.freescale.net>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(24454002)(189002)(104016003)(106466001)(33656002)(102836001)(76482002)(26826002)(85306004)(105606002)(95666004)(97736003)(110136001)(46406003)(50466002)(107046002)(77982003)(74502003)(90102001)(46102003)(81342003)(80022003)(74662003)(81542003)(79102003)(31966008)(15975445006)(83506001)(64706001)(47776003)(20776003)(84676001)(92566001)(92726001)(76176999)(54356999)(50986999)(99396002)(68736004)(83322001)(21056001)(44976005)(19580405001)(83072002)(4396001)(19580395003)(85852003)(6806004)(15202345003)(87936001)(23726002)(97756001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:01:50PM +0530, Pankaj Dubey wrote:
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
> structure where is can be probed and such non-DT based drivers can use
> syscon_regmap_lookup_by_pdev API and get access to regmap handles.
> Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> we can completly remove platform driver of syscon, and keep only helper
> functions to get regmap handles.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> V2 of this patchset and related discussion can be found here [1].
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
> [1]: https://lkml.org/lkml/2014/9/2/299
> 
>  drivers/mfd/syscon.c |   78 ++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 57 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index ca15878..4a4bad9 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -15,40 +15,49 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> +#include <linux/list.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> -#include <linux/of_platform.h>
>  #include <linux/platform_data/syscon.h>
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
>  };
>  
> -static int syscon_match_node(struct device *dev, void *data)
> -{
> -	struct device_node *dn = data;
> -
> -	return (dev->of_node == dn) ? 1 : 0;
> -}
> +static struct syscon *of_syscon_register(struct device_node *np);
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
>  
> -	return syscon->regmap;
> +	spin_unlock(&syscon_list_slock);
> +
> +	if (!syscon)
> +		syscon = of_syscon_register(np);
> +
> +	if (!IS_ERR(syscon))
> +		return syscon->regmap;
> +
> +	return ERR_CAST(syscon);
>  }
>  EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
>  
> @@ -110,17 +119,45 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
>  
> -static const struct of_device_id of_syscon_match[] = {
> -	{ .compatible = "syscon", },
> -	{ },
> -};
> -
>  static struct regmap_config syscon_regmap_config = {
>  	.reg_bits = 32,
>  	.val_bits = 32,
>  	.reg_stride = 4,
>  };
>  
> +static struct syscon *of_syscon_register(struct device_node *np)
> +{
> +	struct syscon *syscon;
> +	struct regmap *regmap;
> +	void __iomem *base;
> +
> +	if (!of_device_is_compatible(np, "syscon"))
> +		return ERR_PTR(-EINVAL);
> +
> +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> +	if (!syscon)
> +		return ERR_PTR(-ENOMEM);
> +
> +	base = of_iomap(np, 0);
> +	if (!base)
> +		return ERR_PTR(-ENOMEM);
> +
> +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);

Does a NULL device pointer work?
I just tested on MX6SX SDB board and it seemed crashed at here in regmap_init function.

Regards
Dong Aisheng

> +	if (IS_ERR(regmap)) {
> +		pr_err("regmap init failed\n");
> +		return ERR_CAST(regmap);
> +	}
> +
> +	syscon->regmap = regmap;
> +	syscon->np = np;
> +
> +	spin_lock(&syscon_list_slock);
> +	list_add_tail(&syscon->list, &syscon_list);
> +	spin_unlock(&syscon_list_slock);
> +
> +	return syscon;
> +}
> +
>  static int syscon_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -167,7 +204,6 @@ static struct platform_driver syscon_driver = {
>  	.driver = {
>  		.name = "syscon",
>  		.owner = THIS_MODULE,
> -		.of_match_table = of_syscon_match,
>  	},
>  	.probe		= syscon_probe,
>  	.id_table	= syscon_ids,
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
