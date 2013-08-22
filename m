Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3HVQIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:08:09 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:38534 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753025Ab3HVQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:08:07 -0400
Message-ID: <5216359F.8000603@overkiz.com>
Date: Thu, 22 Aug 2013 18:00:31 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] net/cadence/macb: add support for dt phy definition
References: <1377186980-21902-1-git-send-email-b.brezillon@overkiz.com> <1377187048-21944-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377187048-21944-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3864088481059076336
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Florian,

On 22/08/2013 17:57, Boris BREZILLON wrote:
> The macb driver only handle PHY description through platform_data
> (macb_platform_data).
> Thus, when using dt you cannot define phy properties like phy address or
> phy irq pin.
>
> This patch makes use of the of_mdiobus_register to add support for
> phy device definition using dt.
> A fallback to the autoscan procedure is added in case there is no phy
> devices defined in dt.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   drivers/net/ethernet/cadence/macb.c |   41 +++++++++++++++++++++++++++++------
>   1 file changed, 34 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index e866608..fe06ab0 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -27,6 +27,7 @@
>   #include <linux/phy.h>
>   #include <linux/of.h>
>   #include <linux/of_device.h>
> +#include <linux/of_mdio.h>
>   #include <linux/of_net.h>
>   #include <linux/pinctrl/consumer.h>
>   
> @@ -314,6 +315,7 @@ static int macb_mii_probe(struct net_device *dev)
>   int macb_mii_init(struct macb *bp)
>   {
>   	struct macb_platform_data *pdata;
> +	struct device_node *np;
>   	int err = -ENXIO, i;
>   
>   	/* Enable management port */
> @@ -335,21 +337,46 @@ int macb_mii_init(struct macb *bp)
>   	bp->mii_bus->parent = &bp->dev->dev;
>   	pdata = bp->pdev->dev.platform_data;
>   
> -	if (pdata)
> -		bp->mii_bus->phy_mask = pdata->phy_mask;
> -
>   	bp->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
>   	if (!bp->mii_bus->irq) {
>   		err = -ENOMEM;
>   		goto err_out_free_mdiobus;
>   	}
>   
> -	for (i = 0; i < PHY_MAX_ADDR; i++)
> -		bp->mii_bus->irq[i] = PHY_POLL;
> -
>   	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
>   
> -	if (mdiobus_register(bp->mii_bus))
> +	np = bp->pdev->dev.of_node;
> +	if (np) {
> +		/* try dt phy registration */
> +		err = of_mdiobus_register(bp->mii_bus, np);
> +
> +		/* fallback to standard phy registration if no phy were
> +		   found during dt phy registration */
> +		if (!err && !phy_find_first(bp->mii_bus)) {
> +			for (i = 0; i < PHY_MAX_ADDR; i++) {
> +				struct phy_device *phydev;
> +
> +				phydev = mdiobus_scan(bp->mii_bus, i);
> +				if (IS_ERR(phydev)) {
> +					err = PTR_ERR(phydev);
> +					break;
> +				}
> +			}
> +

This is were I need the mdiobus_full_scan function.

> +			if (err)
> +				goto err_out_unregister_bus;
> +		}
> +	} else {
> +		for (i = 0; i < PHY_MAX_ADDR; i++)
> +			bp->mii_bus->irq[i] = PHY_POLL;
> +
> +		if (pdata)
> +			bp->mii_bus->phy_mask = pdata->phy_mask;
> +
> +		err = mdiobus_register(bp->mii_bus);
> +	}
> +
> +	if (err)
>   		goto err_out_free_mdio_irq;
>   
>   	if (macb_mii_probe(bp->dev) != 0) {

