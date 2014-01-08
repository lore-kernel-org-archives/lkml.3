Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaAHAZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:25:23 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41768 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbaAHAZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:25:12 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Naveen Krishna Ch <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/5] crypto:s5p-sss: Add device tree and Exynos5 support
Date: Wed, 08 Jan 2014 01:25:05 +0100
Message-ID: <5114267.LR2mpjRmaP@flatron>
User-Agent: KMail/4.12 (Linux/3.12.6-gentoo; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com> <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

Please see my comments inline.

On Tuesday 07 of January 2014 17:21:46 Naveen Krishna Ch wrote:
> This patch adds device tree support along with a new
> compatible string to support Exynos5 SoCs (SSS_VER_5).
> 
> Also, Documentation under devicetree/bindings added.
> 
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
>  .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++++++++++
>  drivers/crypto/s5p-sss.c                           |   40 ++++++++++++++++++++
>  2 files changed, 64 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> new file mode 100644
> index 0000000..8871a29
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> @@ -0,0 +1,24 @@
> +Samsung SoC SSS crypto Module

A sentence or two explaining what this module is would be nice.

> +
> +Required properties:
> +
> +- compatible : Should contain entries for this and backward compatible
> +  SSS versions:
> +  - "samsung,exynos-secss" for S5PV210.
> +  - "samsung,s5p-secss" for Exynos5 series SoCs.

Hmm, this doesn't make any sense, Exynos for S5PV210 and S5P for
Exynos5...

Please use specific compatible strings containing names of first SoC in
which given compatible IP block appeared. E.g. "samsung,s5pv210-secss"
and "samsung,exynos5250-secss" (if S5PV210 and Exynos5 have been first
respectively).

> +  TBD: SSS module on Exynos5 SoCs supports other algorithms,
> +  support for the is yet to be added in the driver.

This has nothing to do with DT bindings.

> +- reg : Offset and length of the register set for the module
> +- interrupts : the interrupt-specifier for the SSS module.

It should be specified how many entries should be specified and what are
their meanings.

> +- clocks : the required gating clock for the SSS module.
> +- clock-names : the gating clock name requested in the SSS driver.

The name should be specified and no dependency on the driver should be
made (it's the driver that should follow the bindings, not the other
way around).

> +
> +Example:
> +	/* SSS_VER_5 */
> +	sss: sss {

Should be sss: sss@10830000 as per ePAPR recommendation about node naming.

> +		compatible = "samsung,exynos-secss";
> +		reg = <0x10830000 0x10000>;
> +		interrupts = <0 112 0>;
> +		clocks = <&clock 471>;
> +		clock-names = "secss";
> +	};
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index dda4551..dcb9fc1 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -22,6 +22,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  #include <linux/crypto.h>
>  #include <linux/interrupt.h>
>  
> @@ -173,10 +174,45 @@ struct s5p_aes_dev {
>  	struct crypto_queue         queue;
>  	bool                        busy;
>  	spinlock_t                  lock;
> +
> +	/* To support SSS versions across Samsung SoCs */
> +	unsigned int		    version;
>  };
>  
>  static struct s5p_aes_dev *s5p_dev;
>  
> +enum sss_version {
> +	SSS_VER_4,	/* SSS found on S5PV210 */
> +	SSS_VER_5,	/* SSS found on Exynos5 Series SoCs */
> +};
> +
> +static struct platform_device_id s5p_sss_ids[] = {

static const struct platform_device_id

> +	{
> +		.name		= "s5p-secss",
> +		.driver_data	= SSS_VER_4,
> +	}, { },
> +};
> +MODULE_DEVICE_TABLE(platform, s5p_sss_ids);
> +

#ifdef CONFIG_OF

> +static struct of_device_id s5p_sss_dt_match[] = {

static const struct of_device_id

> +	{ .compatible = "samsung,s5p-secss", .data = (void *)SSS_VER_4 },
> +	{ .compatible = "samsung,exynos-secss", .data = (void *)SSS_VER_5 },

Does this driver already support SSS version 5 at this stage? Aren't
further patches needed for this?

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);

#endif

> +
> +static inline unsigned int find_s5p_sss_version(struct platform_device *pdev)
> +{
> +#ifdef CONFIG_OF
> +	if (pdev->dev.of_node) {

Please use IS_ENABLED() helper inside the if instead of #ifdef.

> +		const struct of_device_id *match;
> +		match = of_match_node(s5p_sss_dt_match, pdev->dev.of_node);
> +		return (unsigned int)match->data;
> +	}
> +#endif
> +	return platform_get_device_id(pdev)->driver_data;
> +}
> +
>  static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
>  {
>  	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
> @@ -580,6 +616,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  				     resource_size(res), pdev->name))
>  		return -EBUSY;
>  
> +	pdata->version = find_s5p_sss_version(pdev);

Instead of storing a version number, I would rather consider using
a variant struct containing version-specific data.

> +
>  	pdata->clk = devm_clk_get(dev, "secss");
>  	if (IS_ERR(pdata->clk)) {
>  		dev_err(dev, "failed to find secss clock source\n");
> @@ -674,9 +712,11 @@ static int s5p_aes_remove(struct platform_device *pdev)
>  static struct platform_driver s5p_aes_crypto = {
>  	.probe	= s5p_aes_probe,
>  	.remove	= s5p_aes_remove,
> +	.id_table	= s5p_sss_ids,
>  	.driver	= {
>  		.owner	= THIS_MODULE,
>  		.name	= "s5p-secss",
> +		.of_match_table = s5p_sss_dt_match,

of_match_ptr() macro should be used instead of passing s5p_sss_dt_match
directly.

Best regards,
Tomasz

