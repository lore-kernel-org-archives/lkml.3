Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaIVJr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:47:28 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:58331
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752943AbaIVJrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:47:24 -0400
Date: Mon, 22 Sep 2014 17:19:30 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lee.jones@linaro.org>, <arnd@arndb.de>, <tomasz.figa@gmail.com>,
        <linux@arm.linux.org.uk>, <vikas.sajjan@samsung.com>,
        <joshi@samsung.com>, <naushad@samsung.com>, <thomas.ab@samsung.com>,
        <chow.kim@samsung.com>, <kgene.kim@samsung.com>,
        <Li.Xiubo@freescale.com>
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from
 platform devices
Message-ID: <20140922091925.GA19778@shlinux1.ap.freescale.net>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(189002)(199003)(69596002)(50466002)(81156004)(105606002)(107046002)(50986999)(76176999)(76482002)(54356999)(97736003)(15975445006)(106466001)(47776003)(95666004)(92726001)(99396002)(68736004)(26826002)(92566001)(46406003)(83072002)(81542003)(83322001)(81342003)(85852003)(97756001)(83506001)(20776003)(110136001)(23726002)(6806004)(19580405001)(77982003)(80022003)(44976005)(85306004)(21056001)(46102003)(64706001)(19580395003)(104016003)(79102003)(4396001)(84676001)(31966008)(102836001)(87936001)(120916001)(74662003)(33656002)(74502003)(90102001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0759;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:10:07AM +0530, Pankaj Dubey wrote:
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
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> Patch v4 and related discussions can be found here [1].
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
> [1]: https://lkml.org/lkml/2014/9/19/267
> 
>  drivers/mfd/syscon.c |  107 +++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 85 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index ca15878..0b17f50 100644
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
> @@ -22,31 +23,105 @@
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
> +	struct platform_device *pdev = NULL;
> +	struct syscon *syscon;
> +	struct regmap *regmap;
> +	void __iomem *base;
> +	int ret;
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
> +	/* if device is already populated and available then use it */
> +	pdev = of_find_device_by_node(np);
> +	if (!pdev) {
> +		/* for early users create dummy syscon device and use it */
> +		pdev = platform_device_alloc("dummy-syscon", -1);

Can we create specific devices for each syscon device?
That looks more reasonable to me.
Then we can dump registers in regmap debugfs more clearly, just like other devices.
And i think it's better to follow device tree way to generate devices from node.
If DT core find a device is already created, it can ignore that device to avoid
creating duplicated device during of_platform_populate.

Regards
Dong Aisheng

> +		if (!pdev) {
> +			ret = -ENOMEM;
> +			goto err_pdev;
> +		}
> +		pdev->dev.of_node = of_node_get(np);
> +	}
> +
> +	regmap = devm_regmap_init_mmio(&pdev->dev, base, &syscon_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_err(&pdev->dev, "regmap init failed\n");
> +		ret = PTR_ERR(regmap);
> +		goto err_regmap;
> +	}
> +
> +	syscon->regmap = regmap;
> +	syscon->np = np;
>  
> -	return (dev->of_node == dn) ? 1 : 0;
> +	spin_lock(&syscon_list_slock);
> +	list_add_tail(&syscon->list, &syscon_list);
> +	spin_unlock(&syscon_list_slock);
> +
> +	return syscon;
> +
> +err_regmap:
> +	if (!strcmp(pdev->name, "dummy-syscon")) {
> +		of_node_put(np);
> +		platform_device_put(pdev);
> +	}
> +err_pdev:
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
> @@ -110,17 +185,6 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
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
> @@ -167,7 +231,6 @@ static struct platform_driver syscon_driver = {
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
