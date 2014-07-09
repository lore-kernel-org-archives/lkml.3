Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbaGIOXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:23:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35072 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbaGIOXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:23:38 -0400
Message-ID: <53BD5066.4000500@ti.com>
Date: Wed, 9 Jul 2014 10:23:34 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 2/2] net: davinci_mdio: allow to create phys from dt
References: <1404911451-9921-1-git-send-email-grygorii.strashko@ti.com> <1404911451-9921-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1404911451-9921-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 09:10 AM, Grygorii Strashko wrote:
> This patch allows to create PHYs from DT in case
> if they are explicitly defined. The of_mdiobus_register() is
> used for such purposes.
> 
> For backward compatibility, call  of_mdiobus_register() only in case
> if at least one PHY's child is defined in DT, otherwise rollback to
> mdiobus_register().
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/net/ethernet/ti/davinci_mdio.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
> index 735dc53..22d3dab 100644
> --- a/drivers/net/ethernet/ti/davinci_mdio.c
> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
> @@ -38,6 +38,7 @@
>  #include <linux/davinci_emac.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/of_mdio.h>
>  #include <linux/pinctrl/consumer.h>
>  
>  /*
> @@ -95,6 +96,7 @@ struct davinci_mdio_data {
>  	struct mii_bus	*bus;
>  	bool		suspended;
>  	unsigned long	access_time; /* jiffies */
> +	bool		skip_scan;
The vairiable name is not too intutive so probably add a little
bit description on what are you skipping with it.

>  };
>  
>  static void __davinci_mdio_reset(struct davinci_mdio_data *data)
> @@ -144,6 +146,9 @@ static int davinci_mdio_reset(struct mii_bus *bus)
>  	dev_info(data->dev, "davinci mdio revision %d.%d\n",
>  		 (ver >> 8) & 0xff, ver & 0xff);
>  
> +	if (data->skip_scan)
> +		return 0;
> +
>  	/* get phy mask from the alive register */
>  	phy_mask = __raw_readl(&data->regs->alive);
>  	if (phy_mask) {
> @@ -369,8 +374,17 @@ static int davinci_mdio_probe(struct platform_device *pdev)
>  		goto bail_out;
>  	}
>  
> -	/* register the mii bus */
> -	ret = mdiobus_register(data->bus);
> +	/* register the mii bus
> +	 * Create PHYs from DT only in case if PHY child nodes are explicitly
> +	 * defined to support backward compatibility with DTs which assume that
> +	 * Davinci MDIO will always scan the bus for PHYs detection.
> +	 */
multi line comment is not as per coding style. Please fix that.
Patch as such looks good to me so with those minor fixes, feel
free to append my review tag.

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

> +	if (dev->of_node && of_get_child_count(dev->of_node)) {
> +		data->skip_scan = true;
> +		ret = of_mdiobus_register(data->bus, dev->of_node);
> +	} else {
> +		ret = mdiobus_register(data->bus);
> +	}
>  	if (ret)
>  		goto bail_out;
>  
> 

