Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaJ1Ov5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:51:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47154 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaJ1Ovz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:51:55 -0400
Date: Tue, 28 Oct 2014 15:51:52 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: bhelgaas@google.com, swarren@wwwdotorg.org, kthota@nvidia.com,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: tegra: Enable root port specific features
Message-ID: <20141028145151.GD17770@ulmo>
References: <1413803091-10824-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <1413803091-10824-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 04:34:51PM +0530, Vidya Sagar wrote:
> Enables root port to advertise its ASPM-L1 capability
> resulting in possible link entry to L1 when an ASPM-L1 capable
> device is connected
> Enables per-controller & per-TMS clock clamping by default
> Enabling above features result in more power saving
>=20
> It also avoids PM message truncation by waiting for DLLP to finish
> before entering into L1 or L2
>=20
> Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
> ---
> v2:
>  Removed rp_read() & rp_write() as they seem to be redundant
>  Moved port disable code under error condition i.e. it the link
>   is down, corresponding port will be disabled
>=20
>  drivers/pci/host/pci-tegra.c | 50 ++++++++++++++++++++++++++++++++++++++=
+-----
>  1 file changed, 45 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 3d43874..7f32b07 100644
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

These registers should move to the section where other RP_* registers
are already defined. Also, please adjust the name to match what's
already there.

In particular you also redefine RP_PRIV_MISC here.

> +/* Enable various features of root port */
> +static void tegra_pcie_enable_rp_features(struct tegra_pcie_port *port)
> +{
> +	unsigned int data;

u32 please. And maybe rename it to something like "value" to be more
consistent with other parts of the driver.

> +
> +	/* Power mangagement settings */
> +	/* Enable clock clamping by default */
> +	data =3D readl(port->base + NV_PCIE2_RP_PRIV_MISC);
> +	data |=3D PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_THRESHOLD |
> +		PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_ENABLE |
> +		PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_THRESHOLD |
> +		PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_ENABLE;
> +	writel(data, port->base + NV_PCIE2_RP_PRIV_MISC);
> +
> +	/* Enable rootport to advertise its ASPM - L1 capability */
> +	data =3D readl(port->base + NV_PCIE2_RP_VEND_XP1);
> +	data |=3D NV_PCIE2_RP_VEND_XP_LINK_PVT_CTL_L1_ASPM_SUPPORT;
> +	writel(data, port->base + NV_PCIE2_RP_VEND_XP1);
> +
> +	/* LTSSM : wait for DLLP to finish before entering L1 or L2/L3 */
> +	/* to avoid truncating PM messages resulting in receiver errors */

See Documentation/CodingStyle for the proper format of multi-line
comments.

> +	data =3D readl(port->base + NV_PCIE2_RP_VEND_XP_BIST);
> +	data |=3D PCIE2_RP_VEND_XP_BIST_GOTO_L1_L2_AFTER_DLLP_DONE;
> +	writel(data, port->base + NV_PCIE2_RP_VEND_XP_BIST);
> +}

I think these features could all be implemented in separate functions,
which would allow you to give them meaningful names and make these odd
comments obsolete. Or if you want to be more verbose about explaining
the features, having separate functions for them will give you a good
place for such comments.

> +
>  static int tegra_pcie_enable(struct tegra_pcie *pcie)
>  {
>  	struct tegra_pcie_port *port, *tmp;
> @@ -1870,13 +1908,15 @@ static int tegra_pcie_enable(struct tegra_pcie *p=
cie)
> =20
>  		tegra_pcie_port_enable(port);
> =20
> -		if (tegra_pcie_port_check_link(port))
> +		if (!tegra_pcie_port_check_link(port)) {
> +			dev_info(pcie->dev, "link %u down, ignoring\n",
> +				port->index);

This isn't properly aligned.

> +			tegra_pcie_port_disable(port);
> +			tegra_pcie_port_free(port);
>  			continue;
> +		}
> =20
> -		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
> -
> -		tegra_pcie_port_disable(port);
> -		tegra_pcie_port_free(port);
> +		tegra_pcie_enable_rp_features(port);
>  	}

I think the new function is oddly named. Perhaps something like
tegra_pcie_enable_pm() or tegra_pcie_port_init() would work better. The
latter would for example give us a good point to do other work that's
not "enabling a feature" if we need that kind of thing in the future.

Thierry

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUT62HAAoJEN0jrNd/PrOhBNsQAKes/G+j+ELuMx2RP1CuMrQ7
jjEM4FIlgTXgAbmWi59QVAbH/WvlwKbZY9rVbAxcUMVUpyU+8RkUsSV98bqS2pjD
prv75aiUhKHmUnrkvP/DxUCIgAhUwmi4roxVDRXFRlCbupdpfVSc5HeUUDVvi17Y
UdrIgnDTTMrtcLCMyk/kJbuq4rK8FFcZOWhBt0rMyMbmLCmRLn1BxIjkhso/QC1y
wyx+KdUeDNWOAsJoKRwE5qznyeHUI46uHlXuCdRoT+f5/tT6iq0wb1bDO1Gc4lLA
sCZW2nbihtzQFGOagFNlSWt6YcVqJcDFP0ZlWvARpJnmHuFx3Q4qwVoldI0eJru2
kLIPOL13kLUonIDA2DfpJUn/fMtLE1pt9/opntX8zziivU/KZzwqp0ENQIoj60ce
gel+MWhA1tSt+Yfxbqc+sojhQlPhKx2WRYJ57hzKgBNaO6cd2tFSq2RNtY6BH+il
OGHLIB91I4LO60F/t/o2OigpYq1xjI71QKXCx/cgiqO/RPdcdXw69Uif4hJPP3dD
Fy9SpV9ro3y4KnwLVkruPhKZMP6t5ju2/niW+ZtrbtuGgHp6txXyp/YSqPjMc61t
GCbgOW1XBRwNxXp+Pv+WDCMMhFlRng12SQO85eOCYT/nFPOP6ljM7rq3VZWt3M2I
wjqq9IbYBqZZ4Yces40J
=Dqr1
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
