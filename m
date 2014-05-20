Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaETJLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:11:24 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41761 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaETJLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:11:22 -0400
Message-ID: <537B1C35.20107@gmail.com>
Date: Tue, 20 May 2014 11:11:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] phy: add a driver for the Berlin SATA PHY
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com> <1400576675-25265-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1400576675-25265-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 11:04 AM, Antoine Ténart wrote:
> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
>
> The mode selection can let us think this PHY can be configured to fit
> other purposes. But there are reasons to think the SATA mode will be
> the only one usable: the PHY registers are only accessible indirectly
> through two registers in the SATA range, the PHY seems to be integrated
> and no information tells us the contrary. For these reasons, make the
> driver a SATA PHY driver.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
[...]
> diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
> new file mode 100644
> index 000000000000..597f008cae32
> --- /dev/null
> +++ b/drivers/phy/phy-berlin-sata.c
> @@ -0,0 +1,230 @@
> +/*
> + * Marvell Berlin SATA PHY driver
> + *
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/phy/phy.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +
> +#define HOST_VSA_ADDR		0x0
> +#define HOST_VSA_DATA		0x4
> +#define PORT_VSR_ADDR           0x78
> +#define PORT_VSR_DATA           0x7c

Above two lines are indented with spaces.

> +#define PORT_SCR_CTL		0x2c
> +
> +#define CONTROL_REGISTER	0x0
> +#define MBUS_SIZE_CONTROL	0x4
> +
> +#define POWER_DOWN_PHY0			BIT(6)
> +#define POWER_DOWN_PHY1			BIT(14)
> +#define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
> +#define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
> +
> +#define PHY_BASE                0x200

ditto.

> +
> +/* register 0x01 */
> +#define REF_FREF_SEL_25         BIT(0)
> +#define PHY_MODE_SATA           (0x0 << 5)

ditto.

> +
> +/* register 0x02 */
> +#define USE_MAX_PLL_RATE        BIT(12)

ditto.

> +
> +/* register 0x23 */
> +#define DATA_BIT_WIDTH_10       (0x0 << 10)
> +#define DATA_BIT_WIDTH_20       (0x1 << 10)
> +#define DATA_BIT_WIDTH_40       (0x2 << 10)

ditto.

> +
> +/* register 0x25 */
> +#define PHY_GEN_MAX_1_5         (0x0 << 10)
> +#define PHY_GEN_MAX_3_0         (0x1 << 10)
> +#define PHY_GEN_MAX_6_0         (0x2 << 10)

ditto.

FWIW,

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> +
> +#define BERLIN_SATA_PHY_NB	2
> +
> +#define to_berlin_sata_phy_priv(desc)	\
> +	container_of((desc), struct phy_berlin_priv, phys[(desc)->index])
> +
> +struct phy_berlin_desc {
> +	struct phy	*phy;
> +	u32		val;
> +	unsigned	index;
> +};
> +
> +struct phy_berlin_priv {
> +	void __iomem		*base;
> +	spinlock_t		lock;
> +	struct phy_berlin_desc	phys[BERLIN_SATA_PHY_NB];
> +};
> +
> +static inline void phy_berlin_sata_reg_setbits(void __iomem *ctrl_reg, u32 reg,
> +					       u32 mask, u32 val)
> +{
> +	u32 regval;
> +
> +	/* select register */
> +	writel(PHY_BASE + reg, ctrl_reg + PORT_VSR_ADDR);
> +
> +	/* set bits */
> +	regval = readl(ctrl_reg + PORT_VSR_DATA);
> +	regval &= ~mask;
> +	regval |= val;
> +	writel(regval, ctrl_reg + PORT_VSR_DATA);
> +}
> +
> +static int phy_berlin_sata_power_on(struct phy *phy)
> +{
> +	struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> +	struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> +	void __iomem *ctrl_reg = priv->base + 0x60 + (desc->index * 0x80);
> +	int ret = 0;
> +	u32 regval;
> +
> +	spin_lock(&priv->lock);
> +
> +	/* Power on PHY */
> +	writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> +	regval = readl(priv->base + HOST_VSA_DATA);
> +	regval &= ~(desc->val);
> +	writel(regval, priv->base + HOST_VSA_DATA);
> +
> +	/* Configure MBus */
> +	writel(MBUS_SIZE_CONTROL, priv->base + HOST_VSA_ADDR);
> +	regval = readl(priv->base + HOST_VSA_DATA);
> +	regval |= MBUS_WRITE_REQUEST_SIZE_128 | MBUS_READ_REQUEST_SIZE_128;
> +	writel(regval, priv->base + HOST_VSA_DATA);
> +
> +	/* set PHY mode and ref freq to 25 MHz */
> +	phy_berlin_sata_reg_setbits(ctrl_reg, 0x1, 0xff,
> +				    REF_FREF_SEL_25 | PHY_MODE_SATA);
> +
> +	/* set PHY up to 6 Gbps */
> +	phy_berlin_sata_reg_setbits(ctrl_reg, 0x25, 0xc00, PHY_GEN_MAX_6_0);
> +
> +	/* set 40 bits width */
> +	phy_berlin_sata_reg_setbits(ctrl_reg, 0x23,  0xc00, DATA_BIT_WIDTH_40);
> +
> +	/* use max pll rate */
> +	phy_berlin_sata_reg_setbits(ctrl_reg, 0x2, 0x0, USE_MAX_PLL_RATE);
> +
> +	/* set the controller speed */
> +	writel(0x31, ctrl_reg + PORT_SCR_CTL);
> +
> +	spin_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +static int phy_berlin_sata_power_off(struct phy *phy)
> +{
> +	struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> +	struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> +	u32 regval;
> +
> +	spin_lock(&priv->lock);
> +
> +	/* Power down PHY */
> +	writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> +	regval = readl(priv->base + HOST_VSA_DATA);
> +	regval |= desc->val;
> +	writel(regval, priv->base + HOST_VSA_DATA);
> +
> +	spin_unlock(&priv->lock);
> +
> +	return 0;
> +}
> +
> +static struct phy *phy_berlin_sata_phy_xlate(struct device *dev,
> +					     struct of_phandle_args *args)
> +{
> +	struct phy_berlin_priv *priv = dev_get_drvdata(dev);
> +
> +	if (WARN_ON(args->args[0] >= BERLIN_SATA_PHY_NB))
> +		return ERR_PTR(-ENODEV);
> +
> +	return priv->phys[args->args[0]].phy;
> +}
> +
> +static struct phy_ops phy_berlin_sata_ops = {
> +	.power_on	= phy_berlin_sata_power_on,
> +	.power_off	= phy_berlin_sata_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static struct phy_berlin_desc desc[] = {
> +	{ .val = POWER_DOWN_PHY0 },
> +	{ .val = POWER_DOWN_PHY1 },
> +	{ },
> +};
> +
> +static int phy_berlin_sata_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct phy *phy;
> +	struct phy_provider *phy_provider;
> +	struct phy_berlin_priv *priv;
> +	struct resource *res;
> +	int i;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap(dev, res->start, resource_size(res));
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	dev_set_drvdata(dev, priv);
> +	spin_lock_init(&priv->lock);
> +
> +	for (i = 0; i < BERLIN_SATA_PHY_NB; i++) {
> +		phy = devm_phy_create(dev, &phy_berlin_sata_ops, NULL);
> +		if (IS_ERR(phy)) {
> +			dev_err(dev, "failed to create PHY %d\n", i);
> +			return PTR_ERR(phy);
> +		}
> +
> +		priv->phys[i].phy = phy;
> +		priv->phys[i].val = desc[i].val;
> +		priv->phys[i].index = i;
> +		phy_set_drvdata(phy, &priv->phys[i]);
> +
> +		/* Make sure the PHY is off */
> +		phy_berlin_sata_power_off(phy);
> +	}
> +
> +	phy_provider =
> +		devm_of_phy_provider_register(dev, phy_berlin_sata_phy_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id phy_berlin_sata_of_match[] = {
> +	{ .compatible = "marvell,berlin-sata-phy" },
> +	{ },
> +};
> +
> +static struct platform_driver phy_berlin_sata_driver = {
> +	.probe	= phy_berlin_sata_probe,
> +	.driver	= {
> +		.name		= "phy-berlin-sata",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= phy_berlin_sata_of_match,
> +	},
> +};
> +module_platform_driver(phy_berlin_sata_driver);
> +
> +MODULE_DESCRIPTION("Marvell Berlin SATA PHY driver");
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL v2");
>

