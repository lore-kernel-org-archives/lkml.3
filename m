Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3FGIr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:47:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3FGIry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:47:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: netdev@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Steven J. Hill" <sjhill@mips.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ethernet/arc/arc_emac - Add new driver
Date: Fri, 07 Jun 2013 10:47:37 +0200
Message-ID: <1505761.5DsauZd6eq@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com>
References: <1370348510-23754-1-git-send-email-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uT3WoaaSKj4rTs1cnLlYNcdWxLYVWww+pfOitgY82jB
 vWKl5pY7WaZ0/T54a8N07CWSQ330b0F5iw4XUBrYZuiOcX8IMP
 8BpU0u2+B4RIvoRhUeSx7LBSmbSxKxDXG23W7jjokZZT3hDiFR
 tvT+/iRLe0syvtApobnkBjFn2XDQxUf71+6IqF3X2tM6NIWCNG
 iKsW7aHlZ2C5G/cYOveypda9zXjSFCwArR5B9R35igLKRj7PhS
 9G6R1WTZBBHjDr7y2P1slR1tgec1GfnzclW202EC+f8qfY6zUo
 v6KkNNls8QvHDCeV90tQhFY+f4T+7rxl479MYSHFatPBV+gcXA
 3PZqhtQKInxU+GX8pyZs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 16:21:50 Alexey Brodkin wrote:

>  drivers/net/ethernet/Kconfig             |    1 +
>  drivers/net/ethernet/Makefile            |    1 +
>  drivers/net/ethernet/arc/Kconfig         |   29 +
>  drivers/net/ethernet/arc/Makefile        |    6 +
>  drivers/net/ethernet/arc/arc_emac_main.c |  905 ++++++++++++++++++++++++++++++
>  drivers/net/ethernet/arc/arc_emac_main.h |   82 +++
>  drivers/net/ethernet/arc/arc_emac_mdio.c |  181 ++++++
>  drivers/net/ethernet/arc/arc_emac_mdio.h |   22 +
>  drivers/net/ethernet/arc/arc_emac_regs.h |   73 +++

I wonder if it would be better to name the directory "synopsys" or
"designware" rather than "arc" now. Is there a chance that the same
controller is used on non-arc CPUs?

> +static int arc_emac_probe(struct platform_device *pdev)
> +{
> +	struct net_device *net_dev;
> +	struct arc_emac_priv *priv;
> +	int err;
> +	unsigned int clock_frequency;
> +	unsigned int id;
> +	struct resource res_regs;
> +#ifdef CONFIG_OF_IRQ
> +	struct resource res_irq;
> +#endif
> +	const char *mac_addr = NULL;

Please remove the #ifdef here. The driver does not work without this
anyway, so better make it 'depend on OF_IRQ' in Kconfig.

> +	/* Get phy from device tree */
> +	priv->phy_node = of_parse_phandle(pdev->dev.of_node, "phy", 0);
> +	if (!priv->phy_node) {
> +		dev_err(&pdev->dev,
> +			"failed to retrieve phy description from device tree\n");
> +		err = -ENODEV;
> +		goto out;
> +	}

You should add a binding document in Documentation/devicetree/bindings that
describes what properties are required.

> +	/* Get EMAC registers base address from device tree */
> +	err = of_address_to_resource(pdev->dev.of_node, 0, &res_regs);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"failed to retrieve base register from device tree\n");
> +		err = -ENODEV;
> +		goto out;
> +	}
> +
> +	if (!devm_request_mem_region(&pdev->dev, res_regs.start,
> +			resource_size(&res_regs), pdev->name)) {
> +		dev_err(&pdev->dev,
> +			"failed to request memory region for base registers\n");
> +		err = -ENXIO;
> +		goto out;
> +	}
> +
> +	priv->reg_base_addr = (void *) devm_ioremap_nocache(&pdev->dev,
> +			res_regs.start, resource_size(&res_regs));
> +	if (!priv->reg_base_addr) {
> +		dev_err(&pdev->dev, "failed to ioremap MAC registers\n");
> +		err = -ENXIO;
> +		goto out;
> +	}

This block can be simplified to a single devm_ioremap_resource() now.

The cast to 'void *' is wrong: please make sure that you always use '__iomem'
pointers for MMIO mappings. You can use 'sparse' with 'make C=1' to check this
at build time.

> +	/* Get MAC address from device tree */
> +#ifdef CONFIG_OF_NET
> +	mac_addr = of_get_mac_address(pdev->dev.of_node);
> +#endif

Same as above, remove the #ifdef.

> diff --git a/drivers/net/ethernet/arc/arc_emac_main.h b/drivers/net/ethernet/arc/arc_emac_main.h
> new file mode 100644
> index 0000000..6f03d26
> --- /dev/null
> +++ b/drivers/net/ethernet/arc/arc_emac_main.h

This header seems to be included only in the main .c file, just
move the contents there and remove this file.

> +/**
> + * arc_mdio_probe - MDIO probe function.
> + * @dev_node:	Pointer to device node.
> + * @priv:		Pointer to ARC MDIO private data structure.
> + *
> + * returns:	0 on success, -ENOMEM when mdiobus_alloc
> + * (to allocate memory for MII bus structure) fails.
> + *
> + * Sets up and registers the MDIO interface.
> + */
> +int arc_mdio_probe(struct device_node *dev_node, struct arc_mdio_priv *priv)
> +{
> +	struct device_node *mdio_np;
> +	struct mii_bus *bus;
> +	int error;
> +
> +	bus = mdiobus_alloc();
> +	if (!bus) {
> +		error = -ENOMEM;
> +		goto cleanup;
> +	}
> +
> +	priv->bus = bus;
> +	bus->priv = priv;
> +	bus->name = "Synopsys MII Bus",
> +	bus->read = &arc_mdio_read;
> +	bus->write = &arc_mdio_write;
> +
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%.8x",
> +			(unsigned int)priv->reg_base_addr);
> +
> +	bus->parent = priv->dev;
> +
> +	mdio_np = of_find_node_by_name(NULL, "mdio");
> +	if (!mdio_np) {
> +		dev_err(priv->dev, "cannot find <mdio> in device tree\n");
> +		error = -ENODEV;
> +		goto cleanup;
> +	}

of_find_node_by_name() is probably not what you want here, the name should
not be used as a primary key. Maybe it's better to use a standalone driver
for the phy and put it into drivers/net/phy/. I don't know what the official
policy is here though, since the phy is only used in this one driver.

	Arnd
