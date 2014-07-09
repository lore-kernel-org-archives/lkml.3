Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaGIGtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:49:36 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61307 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaGIGtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:49:33 -0400
Date: Wed, 9 Jul 2014 08:49:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: swarren@wwwdotorg.org, tj@kernel.org, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
Message-ID: <20140709064928.GC3170@ulmo>
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
 <1403101406-15439-7-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
In-Reply-To: <1403101406-15439-7-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 18, 2014 at 05:23:25PM +0300, Mikko Perttunen wrote:
[...]
> diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
[...]
> +#include <linux/ahci_platform.h>
> +#include <linux/reset.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/tegra-powergate.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/tegra-soc.h>
> +#include "ahci.h"
> +
> +#define SATA_CONFIGURATION_0				0x180
> +#define		SATA_CONFIGURATION_EN_FPCI		BIT(0)

This, and the register/field definitions below look weirdly indented,
but I guess that's mostly a matter of taste.

> +#define T_SATA0_CHX_PHY_CTRL1_GEN1			0x690
> +#define		T_SATA0_CHX_PHY_CTRL1_GEN1_TX_AMP_MASK	0xff
> +#define		T_SATA0_CHX_PHY_CTRL1_GEN1_TX_AMP_SHIFT	0
> +#define		T_SATA0_CHX_PHY_CTRL1_GEN1_TX_PEAK_MASK	(0xff<<8)

Perhaps single spaces around "<<"? The same for other occurrences below.

> +struct sata_pad_calibration {
> +	u8 gen1_tx_amp, gen1_tx_peak, gen2_tx_amp, gen2_tx_peak;
> +};

I think a more idiomatic way would be to put the fields in a structure
declaration on separate lines.

> +static const struct sata_pad_calibration tegra124_pad_calibration[] = {
> +	{0x18, 0x04, 0x18, 0x0a},

Maybe spaces after '{' and before '}'?

> +static int tegra_ahci_power_on(struct ahci_host_priv *hpriv)
> +{
> +	struct tegra_ahci_priv *tegra = hpriv->plat_data;
> +	int ret;
> +
> +	ret = regulator_bulk_enable(ARRAY_SIZE(tegra->supplies),
> +				    tegra->supplies);
> +	if (ret)
> +		return ret;
> +
> +	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_SATA,
> +		tegra->sata_clk, tegra->sata_rst);

These could be aligned with TEGRA_POWERGATE_SATA.

> +	ret = clk_prepare_enable(tegra->cml1_clk);
> +	if (ret) {
> +		clk_disable_unprepare(tegra->sata_oob_clk);
> +		goto disable_power;
> +	}
> +
> +	ret = clk_prepare_enable(tegra->plle_clk);
> +	if (ret) {
> +		clk_disable_unprepare(tegra->cml1_clk);
> +		clk_disable_unprepare(tegra->sata_oob_clk);
> +		goto disable_power;
> +	}
> +
> +	reset_control_deassert(tegra->sata_cold_rst);
> +	reset_control_deassert(tegra->sata_oob_rst);
> +
> +	ret = phy_power_on(tegra->padctl_phy);
> +	if (ret) {
> +		clk_disable_unprepare(tegra->plle_clk);
> +		clk_disable_unprepare(tegra->cml1_clk);
> +		clk_disable_unprepare(tegra->sata_oob_clk);
> +		goto disable_power;
> +	}

These error paths might be more readable if you did unwind them similar
to how you did with sata_clk below.

> +static int tegra_ahci_controller_init(struct ahci_host_priv *hpriv)
> +{
> +	struct tegra_ahci_priv *tegra = hpriv->plat_data;
> +	int ret;
> +	unsigned int val;
> +	struct sata_pad_calibration calib;
> +
> +	ret = tegra_ahci_power_on(hpriv);
> +	if (ret) {
> +		dev_err(&tegra->pdev->dev,
> +			"failed to power on ahci controller: %d\n", ret);

s/ahci/AHCI/

> +		return ret;
> +	}
> +
> +	val = readl(tegra->sata_regs + SATA_CONFIGURATION_0);
> +	val |= SATA_CONFIGURATION_EN_FPCI;
> +	writel(val, tegra->sata_regs + SATA_CONFIGURATION_0);
> +
> +	/* Pad calibration */
> +
> +	ret = tegra_fuse_readl(FUSE_SATA_CALIB, &val);
> +	if (ret) {
> +		dev_err(&tegra->pdev->dev,
> +			"failed to read sata calibration fuse: %d\n", ret);

s/sata/SATA/

> +static struct ata_port_operations ahci_tegra_port_ops = {
> +	.inherits	= &ahci_ops,
> +	.host_stop	= tegra_ahci_host_stop,
> +};
> +
> +static const struct ata_port_info ahci_tegra_port_info = {
> +	.flags		= AHCI_FLAG_COMMON,
> +	.pio_mask	= ATA_PIO4,
> +	.udma_mask	= ATA_UDMA6,
> +	.port_ops	= &ahci_tegra_port_ops,
> +};

I prefer these to not be arbitrarily indented, but Tejun seemed to
indicate he did, so it's ultimately his call.

> +static const struct of_device_id tegra_ahci_of_match[] = {
> +	{ .compatible = "nvidia,tegra124-ahci" },
> +	{},

Technically there's no need for the comma at the end here. Usually you'd
put one here so that if somebody ever were to add a new entry after this
the diff wouldn't need to include the line that you only add a comma to.
But in this particular case the last entry is used as a sentinel, so
leaving away the comma is actually useful as a hint that entries should
be added in front rather than at the end.

> +	hpriv->mmio = devm_ioremap_resource(&pdev->dev,
> +		platform_get_resource(pdev, IORESOURCE_MEM, 0));

Perhaps a temporary variable for the result of platform_get_resource()
would help make this look less cluttered.

> +	if (IS_ERR(hpriv->mmio)) {
> +		dev_err(&pdev->dev, "Failed to get AHCI IO memory\n");

This isn't necessary. devm_ioremap_resource() will already output an
error message.

> +	tegra->sata_regs = devm_ioremap_resource(&pdev->dev,
> +		platform_get_resource(pdev, IORESOURCE_MEM, 1));
> +	if (IS_ERR(tegra->sata_regs)) {
> +		dev_err(&pdev->dev, "Failed to get SATA IO memory\n");

Same here.

> +	tegra->padctl_phy = devm_phy_get(&pdev->dev, "sata-phy");
> +	if (IS_ERR(tegra->padctl_phy)) {
> +		dev_err(&pdev->dev, "Failed to get phy\n");

s/phy/PHY/

> +	ret = devm_regulator_bulk_get(&pdev->dev, ARRAY_SIZE(tegra->supplies),
> +					tegra->supplies);

The trailing argument here isn't aligned as in other places.

> +static struct platform_driver tegra_ahci_driver = {
> +	.probe = tegra_ahci_probe,
> +	.remove = ata_platform_remove_one,
> +	.driver = {
> +		.name = "tegra-ahci",
> +		.owner = THIS_MODULE,

This isn't really needed anymore, module_platform_driver will end up
setting this for you anyway.

Thierry

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvOX4AAoJEN0jrNd/PrOhe9AQAJQeRSYMRCkut/2iRRpJmvpp
h5JL/XLVmcCTsseLiBRcwP0a+2M0CK7QghmvTAEkly0mucWbkthwao0z0T3fdlAR
jttvC3/YYBsXZVkOMm6Q+N/AFD891BnhTi9IcITNfzYffcSYZurpvhioCtYfOS1t
7Kwna1n3uG2Rqeqj5MQfxEPuRoWXB7ibMJLYX8twKeAj7P28BJiBkZ99kOae60XQ
C7zbrMUXkCpRZO6SAs9zPmtAMrKxRDIADmQ2KTLJByYGtcR7A3ZmvaiXTte7S/6x
VPzAFA66qXwDiBrPBUj1ciP10nLKs/kE53DAOfKItX00dDXMDu+7MQgeIRIW52HE
uQOMYsV6/1/P2Xm+UmtT6ps486U5meDYW9RNy3KrdsC+pkYT/M2RN3QIwOp54bvA
KKxxM+XmrM7LDH4Nf0qttklk/CfkSGniacwEOLEelzjh97hMXqGmQ9t4HOBLnvrT
D2voaxtNPmQ7RyYkvJ6B77JmcOww8j+YeWbi2yEgobuEa/6lJNsNASIoy/GfzIZb
c3uNeK0Cw5Ox8Wo8Nu88Oe+SzSByna+7ikKjuRiX/6w59zBupASVP7iOYLvlTtN7
278NXrEv9teXklzCvsp8jUcikp4Ih+/MFEQL8DJo/hk8g9AXUFB2TReOH3hmh4my
jA7qvcAUP0R9nZxdpmfO
=Y0ip
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--
