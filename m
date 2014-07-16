Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaGPJU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:20:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34019 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaGPJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:20:23 -0400
Message-ID: <53C64389.3050705@gmail.com>
Date: Wed, 16 Jul 2014 14:49:05 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/12] phy: add the Berlin USB PHY driver
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <1405499166-6726-6-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1405499166-6726-6-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 01:55 PM, Antoine Ténart wrote:
> +static const struct of_device_id phy_berlin_sata_of_match[] = {
> +	{
> +		.compatible = "marvell,berlin2-usb-phy",
> +		.data = &phy_berlin_pll_dividers[0],
> +	},
> +	{
> +		.compatible = "marvell,berlin2cd-usb-phy",
> +		.data = &phy_berlin_pll_dividers[1],
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, phy_berlin_sata_of_match);
> +

It looks good if we move this after probe().. So that we can see of_match_table directly...

> +static int phy_berlin_usb_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match =
> +		of_match_device(phy_berlin_sata_of_match, &pdev->dev);
> +	struct phy_berlin_usb_priv *priv;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	priv->rst_ctrl = devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(priv->rst_ctrl))
> +		return PTR_ERR(priv->rst_ctrl);
> +
> +	priv->pll_divider = *((u32 *)match->data);
> +
> +	priv->phy = devm_phy_create(&pdev->dev, &phy_berlin_usb_ops, NULL);
> +	if (IS_ERR(priv->phy)) {
> +		dev_err(&pdev->dev, "failed to create PHY\n");
> +		return PTR_ERR(priv->phy);
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	phy_provider =
> +		devm_of_phy_provider_register(&pdev->dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver phy_berlin_usb_driver = {
> +	.probe	= phy_berlin_usb_probe,
> +	.driver	= {
> +		.name		= "phy-berlin-usb",
> +		.owner		= THIS_MODULE,

No need to update owner field.

-- 
Regards,
Varka Bhadram.

