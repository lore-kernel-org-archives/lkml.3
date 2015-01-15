Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbbAOIrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:47:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbAOIrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:47:01 -0500
Message-ID: <54B77E57.7060708@redhat.com>
Date: Thu, 15 Jan 2015 09:46:15 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ata: libahci: Allow using multiple regulators
References: <1421158953-2957-1-git-send-email-gregory.clement@free-electrons.com> <1421158953-2957-4-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1421158953-2957-4-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13-01-15 15:22, Gregory CLEMENT wrote:
> The current implementation of the libahci allows using multiple PHYs
> but not multiple regulators. This patch adds the support of multiple
> regulators. Until now it was mandatory to have a PHY under a subnode,
> now a port subnode can contain either a regulator or a PHY (or both).
>
> In order to be able to asociate a port with a regulator the port are
> now a platform device in the device tree case.
>
> There was only one driver which used directly the regulator field of
> the ahci_host_priv structure. To preserve the bisectability the change
> in the ahci_imx driver was done in the same patch.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Looks good, still needs one more (small) revision though, see comments
inline.

> ---
>   drivers/ata/ahci.h             |   2 +-
>   drivers/ata/ahci_imx.c         |  14 +--
>   drivers/ata/libahci_platform.c | 227 +++++++++++++++++++++++++++++------------
>   include/linux/ahci_platform.h  |   2 +
>   4 files changed, 170 insertions(+), 75 deletions(-)
>
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 40f0e34f17af..275358ae0b3f 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -333,7 +333,7 @@ struct ahci_host_priv {
>   	u32			em_msg_type;	/* EM message type */
>   	bool			got_runtime_pm; /* Did we do pm_runtime_get? */
>   	struct clk		*clks[AHCI_MAX_CLKS]; /* Optional */
> -	struct regulator	*target_pwr;	/* Optional */
> +	struct regulator	**target_pwrs;	/* Optional */
>   	/*
>   	 * If platform uses PHYs. There is a 1:1 relation between the port number and
>   	 * the PHY position in this array.
> diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
> index 35d51c59a370..41632e57d46f 100644
> --- a/drivers/ata/ahci_imx.c
> +++ b/drivers/ata/ahci_imx.c
> @@ -221,11 +221,9 @@ static int imx_sata_enable(struct ahci_host_priv *hpriv)
>   	if (imxpriv->no_device)
>   		return 0;
>
> -	if (hpriv->target_pwr) {
> -		ret = regulator_enable(hpriv->target_pwr);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = ahci_platform_enable_regulators(hpriv);
> +	if (ret)
> +		return ret;
>
>   	ret = clk_prepare_enable(imxpriv->sata_ref_clk);
>   	if (ret < 0)
> @@ -270,8 +268,7 @@ static int imx_sata_enable(struct ahci_host_priv *hpriv)
>   disable_clk:
>   	clk_disable_unprepare(imxpriv->sata_ref_clk);
>   disable_regulator:
> -	if (hpriv->target_pwr)
> -		regulator_disable(hpriv->target_pwr);
> +	ahci_platform_disable_regulators(hpriv);
>
>   	return ret;
>   }
> @@ -291,8 +288,7 @@ static void imx_sata_disable(struct ahci_host_priv *hpriv)
>
>   	clk_disable_unprepare(imxpriv->sata_ref_clk);
>
> -	if (hpriv->target_pwr)
> -		regulator_disable(hpriv->target_pwr);
> +	ahci_platform_disable_regulators(hpriv);
>   }
>
>   static void ahci_imx_error_handler(struct ata_port *ap)
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index a147aaadca85..1db968ef6ff8 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -24,6 +24,7 @@
>   #include <linux/ahci_platform.h>
>   #include <linux/phy/phy.h>
>   #include <linux/pm_runtime.h>
> +#include <linux/of_platform.h>
>   #include "ahci.h"
>
>   static void ahci_host_stop(struct ata_host *host);
> @@ -138,6 +139,59 @@ void ahci_platform_disable_clks(struct ahci_host_priv *hpriv)
>   EXPORT_SYMBOL_GPL(ahci_platform_disable_clks);
>
>   /**
> + * ahci_platform_enable_regulators - Enable regulators
> + * @hpriv: host private area to store config values
> + *
> + * This function enables all the regulators found in
> + * hpriv->target_pwrs, if any.  If a regulator fails to be enabled, it
> + * disables all the regulators already enabled in reverse order and
> + * returns an error.
> + *
> + * RETURNS:
> + * 0 on success otherwise a negative error code
> + */
> +int ahci_platform_enable_regulators(struct ahci_host_priv *hpriv)
> +{
> +	int rc, i;
> +
> +	for (i = 0; i < hpriv->nports; i++) {
> +		if (!hpriv->target_pwrs[i])
> +			continue;
> +
> +		rc = regulator_enable(hpriv->target_pwrs[i]);
> +		if (rc)
> +			goto disable_target_pwrs;
> +	}
> +
> +	return 0;
> +
> +disable_target_pwrs:
> +	while (--i >= 0)
> +		if (hpriv->target_pwrs[i])
> +			regulator_disable(hpriv->target_pwrs[i]);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(ahci_platform_enable_regulators);
> +
> +/**
> + * ahci_platform_disable_regulators - Disable regulators
> + * @hpriv: host private area to store config values
> + *
> + * This function disables all regulators found in hpriv->target_pwrs.
> + */
> +void ahci_platform_disable_regulators(struct ahci_host_priv *hpriv)
> +{
> +	int i;
> +
> +	for (i = 0; i < hpriv->nports; i++) {
> +		if (!hpriv->target_pwrs[i])
> +			continue;
> +		regulator_disable(hpriv->target_pwrs[i]);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(ahci_platform_disable_regulators);
> +/**
>    * ahci_platform_enable_resources - Enable platform resources
>    * @hpriv: host private area to store config values
>    *
> @@ -157,11 +211,9 @@ int ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
>   {
>   	int rc;
>
> -	if (hpriv->target_pwr) {
> -		rc = regulator_enable(hpriv->target_pwr);
> -		if (rc)
> -			return rc;
> -	}
> +	rc = ahci_platform_enable_regulators(hpriv);
> +	if (rc)
> +		return rc;
>
>   	rc = ahci_platform_enable_clks(hpriv);
>   	if (rc)
> @@ -177,8 +229,8 @@ disable_clks:
>   	ahci_platform_disable_clks(hpriv);
>
>   disable_regulator:
> -	if (hpriv->target_pwr)
> -		regulator_disable(hpriv->target_pwr);
> +	ahci_platform_disable_regulators(hpriv);
> +
>   	return rc;
>   }
>   EXPORT_SYMBOL_GPL(ahci_platform_enable_resources);
> @@ -199,8 +251,7 @@ void ahci_platform_disable_resources(struct ahci_host_priv *hpriv)
>
>   	ahci_platform_disable_clks(hpriv);
>
> -	if (hpriv->target_pwr)
> -		regulator_disable(hpriv->target_pwr);
> +	ahci_platform_disable_regulators(hpriv);
>   }
>   EXPORT_SYMBOL_GPL(ahci_platform_disable_resources);
>
> @@ -218,6 +269,59 @@ static void ahci_platform_put_resources(struct device *dev, void *res)
>   		clk_put(hpriv->clks[c]);
>   }
>
> +static int ahci_platform_get_phy(struct ahci_host_priv *hpriv, u32 port,
> +				struct device *dev, struct device_node *node)
> +{
> +	int rc;
> +
> +	hpriv->phys[port] = devm_of_phy_get(dev, node, NULL);
> +
> +	if (!IS_ERR(hpriv->phys[port]))
> +		return 0;
> +
> +	rc = PTR_ERR(hpriv->phys[port]);
> +	switch (rc) {
> +	case -ENOSYS:
> +		/* No PHY support. Check if PHY is required. */
> +		if (of_find_property(node, "phys", NULL)) {
> +			dev_err(dev,
> +				"couldn't get PHY in node %s: ENOSYS\n",
> +				node->name);
> +			break;
> +		}
> +	case -ENODEV:
> +		/* continue normally */
> +		hpriv->phys[port] = NULL;
> +		rc = 0;
> +		break;
> +
> +	default:
> +		dev_err(dev,
> +			"couldn't get PHY in node %s: %d\n",
> +			node->name, rc);
> +
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +static int ahci_platform_get_regulator(struct ahci_host_priv *hpriv, u32 port,
> +				struct device *dev)
> +{
> +	struct regulator *target_pwr;
> +	int rc = 0;
> +
> +	target_pwr = devm_regulator_get_optional(dev, "target");

As you've already found out the devm framework does not work for freeing
things which are tied to the child node devices, so it is better to
use the non devm function here, the devm variant just adds overhead
(extra malloc under the hood), without buying us anything here.

> +
> +	if (!IS_ERR(target_pwr))
> +		hpriv->target_pwrs[port] = target_pwr;
> +	else
> +		rc = PTR_ERR(target_pwr);
> +
> +	return rc;
> +}
> +
>   /**
>    * ahci_platform_get_resources - Get platform resources
>    * @pdev: platform device to get resources for


You're not modifying ahci_platform_put_resources to put the regulators here,
since the regulators may now be bound to the platfrom-devs for the child nodes,
they will not get cleaned up by the devm framework on driver unbind, as the
driver is only bound to the main device and thus the devm framework only
cleans up resources attached to the main device.

So you need to modify ahci_platform_put_resources to explicitly put the
reference to the regulators.

Note since ahci_platform_put_resources gets called during probe errors too,
you need to check hpriv->target_pwrs before you deref it as it may be NULL!

Please also add a comment to ahci_platform_put_resources why the regulators
cannot be devm managed.

> @@ -240,7 +344,7 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>   	struct ahci_host_priv *hpriv;
>   	struct clk *clk;
>   	struct device_node *child;
> -	int i, enabled_ports = 0, rc = -ENOMEM;
> +	int i, sz, enabled_ports = 0, rc = -ENOMEM, child_nodes;
>   	u32 mask_port_map = 0;
>
>   	if (!devres_open_group(dev, NULL, GFP_KERNEL))
> @@ -261,14 +365,6 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>   		goto err_out;
>   	}
>
> -	hpriv->target_pwr = devm_regulator_get_optional(dev, "target");
> -	if (IS_ERR(hpriv->target_pwr)) {
> -		rc = PTR_ERR(hpriv->target_pwr);
> -		if (rc == -EPROBE_DEFER)
> -			goto err_out;
> -		hpriv->target_pwr = NULL;
> -	}
> -
>   	for (i = 0; i < AHCI_MAX_CLKS; i++) {
>   		/*
>   		 * For now we must use clk_get(dev, NULL) for the first clock,
> @@ -290,19 +386,33 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>   		hpriv->clks[i] = clk;
>   	}
>
> -	hpriv->nports = of_get_child_count(dev->of_node);
> +	hpriv->nports = child_nodes = of_get_child_count(dev->of_node);
>
> -	if (hpriv->nports) {
> -		hpriv->phys = devm_kzalloc(dev,
> -					   hpriv->nports * sizeof(*hpriv->phys),
> -					   GFP_KERNEL);
> -		if (!hpriv->phys) {
> -			rc = -ENOMEM;
> -			goto err_out;
> -		}
> +	/*
> +	 * If no sub-node was found, we still need to set nports to
> +	 * one in order to be able to use the
> +	 * ahci_platform_[en|dis]able_[phys|regulators] functions.
> +	 */
> +	if (!child_nodes)
> +		hpriv->nports = 1;
> +
> +	sz = hpriv->nports * sizeof(*hpriv->phys);
> +	hpriv->phys = devm_kzalloc(dev, sz, GFP_KERNEL);
> +	if (!hpriv->phys) {
> +		rc = -ENOMEM;
> +		goto err_out;
> +	}
> +	sz = hpriv->nports * sizeof(*hpriv->target_pwrs);
> +	hpriv->target_pwrs = devm_kzalloc(dev, sz, GFP_KERNEL);
> +	if (!hpriv->target_pwrs) {
> +		rc = -ENOMEM;
> +		goto err_out;
> +	}
>
> +	if (child_nodes) {
>   		for_each_child_of_node(dev->of_node, child) {
>   			u32 port;
> +			struct platform_device *port_dev;
>
>   			if (!of_device_is_available(child))
>   				continue;
> @@ -316,17 +426,20 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>   				dev_warn(dev, "invalid port number %d\n", port);
>   				continue;
>   			}
> -
>   			mask_port_map |= BIT(port);
>
> -			hpriv->phys[port] = devm_of_phy_get(dev, child, NULL);
> -			if (IS_ERR(hpriv->phys[port])) {
> -				rc = PTR_ERR(hpriv->phys[port]);
> -				dev_err(dev,
> -					"couldn't get PHY in node %s: %d\n",
> -					child->name, rc);
> +			of_platform_device_create(child, NULL, NULL);
> +
> +			port_dev = of_find_device_by_node(child);

This call can fail, you need to error check it before dereferencing the port_dev
pointer below.

> +
> +			rc = ahci_platform_get_regulator(hpriv, port,
> +							&port_dev->dev);
> +			if (rc == -EPROBE_DEFER)
> +				goto err_out;
> +
> +			rc = ahci_platform_get_phy(hpriv, port, dev, child);
> +			if (rc)
>   				goto err_out;
> -			}
>
>   			enabled_ports++;
>   		}
> @@ -343,38 +456,14 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>   		 * If no sub-node was found, keep this for device tree
>   		 * compatibility
>   		 */
> -		struct phy *phy = devm_phy_get(dev, "sata-phy");
> -		if (!IS_ERR(phy)) {
> -			hpriv->phys = devm_kzalloc(dev, sizeof(*hpriv->phys),
> -						   GFP_KERNEL);
> -			if (!hpriv->phys) {
> -				rc = -ENOMEM;
> -				goto err_out;
> -			}
> -
> -			hpriv->phys[0] = phy;
> -			hpriv->nports = 1;
> -		} else {
> -			rc = PTR_ERR(phy);
> -			switch (rc) {
> -				case -ENOSYS:
> -					/* No PHY support. Check if PHY is required. */
> -					if (of_find_property(dev->of_node, "phys", NULL)) {
> -						dev_err(dev, "couldn't get sata-phy: ENOSYS\n");
> -						goto err_out;
> -					}
> -				case -ENODEV:
> -					/* continue normally */
> -					hpriv->phys = NULL;
> -					break;
> -
> -				default:
> -					goto err_out;
> +		rc = ahci_platform_get_phy(hpriv, 0, dev, dev->of_node);
> +		if (rc)
> +			goto err_out;
>
> -			}
> -		}
> +		rc = ahci_platform_get_regulator(hpriv, 0, dev);
> +		if (rc == -EPROBE_DEFER)
> +			goto err_out;
>   	}
> -
>   	pm_runtime_enable(dev);
>   	pm_runtime_get_sync(dev);
>   	hpriv->got_runtime_pm = true;
> @@ -383,6 +472,14 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>   	return hpriv;
>
>   err_out:
> +	/*
> +	 * In case of a deferred probe, previous regulators may have
> +	 * been already get, so put them to be able to get them again
> +	 * in the next probe.
> +	 */
> +	for (i = 0; i < hpriv->nports; i++)
> +		if (hpriv->target_pwrs[i])
> +			devm_regulator_put(hpriv->target_pwrs[i]);

Once you've added the regulator_put calls to ahci_platform_put_resources
you can drop this as the devres_release_group() call will call
ahci_platform_put_resources().

>   	devres_release_group(dev, NULL);
>   	return ERR_PTR(rc);
>   }
> diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
> index 642d6ae4030c..f65b33809170 100644
> --- a/include/linux/ahci_platform.h
> +++ b/include/linux/ahci_platform.h
> @@ -24,6 +24,8 @@ struct platform_device;
>
>   int ahci_platform_enable_clks(struct ahci_host_priv *hpriv);
>   void ahci_platform_disable_clks(struct ahci_host_priv *hpriv);
> +int ahci_platform_enable_regulators(struct ahci_host_priv *hpriv);
> +void ahci_platform_disable_regulators(struct ahci_host_priv *hpriv);
>   int ahci_platform_enable_resources(struct ahci_host_priv *hpriv);
>   void ahci_platform_disable_resources(struct ahci_host_priv *hpriv);
>   struct ahci_host_priv *ahci_platform_get_resources(
>

Regards,

Hans
