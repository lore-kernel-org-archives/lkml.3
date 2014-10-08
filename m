Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaJHHoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:44:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59758 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaJHHoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:44:09 -0400
Date: Wed, 8 Oct 2014 09:44:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: bhelgaas@google.com, swarren@wwwdotorg.org, kthota@nvidia.com,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] PCI: tegra: Enable root port specific features
Message-ID: <20141008074404.GC4999@ulmo>
References: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 03:57:58PM +0530, Vidya Sagar wrote:
> Enables root port to advertise its ASPM-L1 capability
>  resulting in possible link entry to L1 when an ASPM-L1 capable
>  device is connected
> Enables per-controller & per-TMS clock clamping by default
> Enabling above features result in more power saving
>=20
> It also avoids PM message truncation by waiting for DLLP to finish
> before entering into L1 or L2
>=20
> Also, it adds helper functions to access root port registers
>=20
> Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
> ---
>  drivers/pci/host/pci-tegra.c | 54 ++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 3d43874..b192a47 100644
> --- a/drivers/pci/host/pci-tegra.c
> +++ b/drivers/pci/host/pci-tegra.c
> @@ -237,6 +237,18 @@
>  		(0xf  << PADS_REFCLK_CFG_DRVI_SHIFT)     \
>  	)
> =20
> +#define NV_PCIE2_RP_VEND_XP1			0x00000F04
> +#define NV_PCIE2_RP_VEND_XP_LINK_PVT_CTL_L1_ASPM_SUPPORT	(1 << 21)
> +
> +#define NV_PCIE2_RP_VEND_XP_BIST		0x00000F4C
> +#define PCIE2_RP_VEND_XP_BIST_GOTO_L1_L2_AFTER_DLLP_DONE	(1 << 28)
> +
> +#define NV_PCIE2_RP_PRIV_MISC			0x00000FE0
> +#define PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_THRESHOLD	(0xF << 16)
> +#define PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_ENABLE	(1 << 23)
> +#define PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_THRESHOLD	(0xF << 24)
> +#define PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_ENABLE		(1 << 31)

These seem to be part of the same set as the RP_PRIV_* registers already
defined earlier in the file. In fact NV_PCIE2_RP_PRIV_MISC is defined as
RP_PRIV_MISC above already. Please move them there and drop the useless
NV_PCIE2_ and PCIE2_ prefixes.

>  struct tegra_msi {
>  	struct msi_chip chip;
>  	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
> @@ -346,6 +358,18 @@ static inline u32 pads_readl(struct tegra_pcie *pcie=
, unsigned long offset)
>  	return readl(pcie->pads + offset);
>  }
> =20
> +static inline void rp_writel(struct tegra_pcie_port *port, u32 value,
> +							 unsigned long offset)
> +{
> +	writel(value, offset + port->base);
> +}
> +
> +static inline unsigned int rp_readl(struct tegra_pcie_port *port,

readl() returns u32 and so should rp_readl().

> +							unsigned long offset)
> +{
> +	return readl(offset + port->base);
> +}

I don't see much use in these, but if you really want to add them,
please also replace any of the open-coded occurrences of this. Also
please fix the alignment of function arguments on subsequent lines.
They should align with the first argument on the first line.

> +/* Enable various features of root port */

This comment is useless. It's a rewording of the function name. Either
leave it out or describe what kind of features are being enabled. Since
you already do that with comments in the function body, I'd suggest to
just drop this comment out.

> +static void tegra_pcie_enable_rp_features(struct tegra_pcie_port *port)

I think a better name would be tegra_pcie_port_enable_features() so that
the name more accurately reflects what "object" the function operates
on.

> +{
> +	unsigned int data;

Should be u32 and a more common name as used in this driver is "value".

> +
> +	/* Power mangagement settings */

"management". Though I'm not sure why this comment is here. My best
guess is that you want to group features. Comments are terrible for
grouping code. Perhaps since everything in this function is related to
power management a better name would be tegra_pcie_port_enable_pm().
That gives you grouping for free.

> +	/* Enable clock clamping by default */
> +	data =3D rp_readl(port, NV_PCIE2_RP_PRIV_MISC);
> +	data |=3D PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_THRESHOLD |
> +		PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_ENABLE |
> +		PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_THRESHOLD |
> +		PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_ENABLE;
> +	rp_writel(port, data, NV_PCIE2_RP_PRIV_MISC);
> +
> +	/* Enable rootport to advertise its ASPM - L1 capability */

"root port"

> +	data =3D rp_readl(port, NV_PCIE2_RP_VEND_XP1);
> +	data |=3D NV_PCIE2_RP_VEND_XP_LINK_PVT_CTL_L1_ASPM_SUPPORT;
> +	rp_writel(port, data, NV_PCIE2_RP_VEND_XP1);
> +
> +	/* LTSSM : wait for DLLP to finish before entering L1 or L2/L3 */
> +	/* to avoid truncating PM messages resulting in receiver errors */

Proper style for block comments is:

	/*
	 * LTSSM: ...
	 * ... errors
	 */

Thierry

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNOtEAAoJEN0jrNd/PrOhinsQAIh+nVCpowYrtwKp9BFipdqy
WpGe59eVPsJk0xCynYw4sExbYtgEk+nxUiPsxRoKMtIThMVO2IJi1NluH2PKonIj
+vLtoa35iz9BK6DQR+2+blTgaKhJfr9snP+mDmNqQjKwRH3SuCFV9p2cyTt9qswv
wjyWmytyX0qVKknfI1beuRjwaYmGCNW77S8vhJlsVEzahVqrDi8Dqojfw8x1eqtM
ZEqWyceJJkIODy8m5TApiEVhOr55PATFZK2N2OWpZmcwkJXuz3HxAitKam8XTAKp
AMpUcD4BoALKv2CHKG6cRD3zANo+iQ2NiZxpDegdmHOENLBK/M5jEo62v9i8FucG
nEKOh004cLE7vvJrtnxBhGZ0fC3BB1+7yma45sx2Bx6G2ycwblWedTMDnu2XQ2PV
MQIjauIvi3LgvuOTCYUvWCQHT1oD9PmkeQnFsOEVuZJHDfcf4OdSPagB56pE0H+w
Kc8zIr3/d5xizPrDcI9xMzugK9mVls8wDYwu72gkT5UkAYRIO25e6i/qK9D18LKn
z9OTzj7hydeGOLVnOqpS+ZgYyvIiOnvpfGrUI3WmROSu0EX7n9uSv/tbE9Zteh3o
Fr+xPQPuuc2l2DsnkTYeuE2R85lJcmPleaNeIF8dX2ThdSrdq56QN5Jc1i5kcgeR
SCZ0R6Rwxyx3LYZx4G+W
=nPr3
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
