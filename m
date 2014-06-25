Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaFYTD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:03:26 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:55686 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaFYTDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:03:23 -0400
Message-ID: <53AB1CFD.4040500@cogentembedded.com>
Date: Wed, 25 Jun 2014 23:03:25 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
CC: thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/7] phy: add a driver for the Berlin SATA PHY
References: <1403530783-17180-1-git-send-email-antoine.tenart@free-electrons.com> <1403530783-17180-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1403530783-17180-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/23/2014 05:39 PM, Antoine Ténart wrote:

> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.

> The mode selection can let us think this PHY can be configured to fit
> other purposes. But there are reasons to think the SATA mode will be
> the only one usable: the PHY registers are only accessible indirectly
> through two registers in the SATA range, the PHY seems to be integrated
> and no information tells us the contrary. For these reasons, make the
> driver a SATA PHY driver.

    I'm not even sure why you want to make it a separate driver if the 
registers are mapped to SATA controller's range.

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

[...]

> diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
> new file mode 100644
> index 000000000000..317f62358165
> --- /dev/null
> +++ b/drivers/phy/phy-berlin-sata.c
> @@ -0,0 +1,246 @@
[...]
+#define HOST_VSA_ADDR		0x0
+#define HOST_VSA_DATA		0x4
+#define PORT_VSR_ADDR		0x78
+#define PORT_VSR_DATA		0x7c
+#define PORT_SCR_CTL		0x2c

    Could you keep this list sorted?

[...]

+struct phy_berlin_desc {
+	struct phy	*phy;
+	u32		val;

    Hm, aren't these power down bits? Why not call the field accordingly?

[...]

> +static int phy_berlin_sata_power_on(struct phy *phy)
> +{
> +	struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> +	struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> +	void __iomem *ctrl_reg = priv->base + 0x60 + (desc->index * 0x80);
> +	int ret = 0;
> +	u32 regval;
> +
> +	clk_prepare_enable(priv->clk);
> +
> +	spin_lock(&priv->lock);
> +
> +	/* Power on PHY */
> +	writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> +	regval = readl(priv->base + HOST_VSA_DATA);
> +	regval &= ~(desc->val);

    Parens not needed here.

> +	writel(regval, priv->base + HOST_VSA_DATA);
> +
> +	/* Configure MBus */
> +	writel(MBUS_SIZE_CONTROL, priv->base + HOST_VSA_ADDR);
> +	regval = readl(priv->base + HOST_VSA_DATA);
> +	regval |= MBUS_WRITE_REQUEST_SIZE_128 | MBUS_READ_REQUEST_SIZE_128;
> +	writel(regval, priv->base + HOST_VSA_DATA);

    It probably makes sense to factor these address/data register writes into 
a separate function like phy_berlin_sata_reg_setbits().

[...]
> +	/* set the controller speed */
> +	writel(0x31, ctrl_reg + PORT_SCR_CTL);

    Value undocumented? Or is this the SATA SControl register by chance?

[...]

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
> +	if (!res)
> +		return -EINVAL;
> +
> +	priv->base = devm_ioremap(dev, res->start, resource_size(res));

    Can't you use devm_ioremap_resource()?

> +	if (!priv->base)
> +		return -ENOMEM;
> +
> +	priv->clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(priv->clk))
> +		return PTR_ERR(priv->clk);
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
> +		priv->phys[i].val = phy_berlin_power_down_bits[i];
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

    No dev_err() here?

> +		return PTR_ERR(phy_provider);
> +
> +	return 0;
> +}

WBR, Sergei

