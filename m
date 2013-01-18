Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3ARSfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:35:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41265 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3ARSfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:35:02 -0500
Date: Fri, 18 Jan 2013 20:34:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/4] USB: PHY: Tegra: Get rid of instance number to
 differentiate PHY type
Message-ID: <20130118183457.GB1776@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
 <1358343022-28919-4-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <1358343022-28919-4-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 07:00:21PM +0530, Venu Byravarasu wrote:
> Tegra20 USB has 3 PHY instances:
> Instance 1 and 3 are UTMI. Instance 2 is ULPI.
>=20
> As instance number was used to differentiate ULPI from UTMI,
> used DT param to get this info and processed accordingly.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/phy/tegra_usb_phy.c   |   23 +++++++++--------------
>  include/linux/usb/tegra_usb_phy.h |    1 +
>  2 files changed, 10 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_=
phy.c
> index 79280fe..ce1ff2a 100644
> --- a/drivers/usb/phy/tegra_usb_phy.c
> +++ b/drivers/usb/phy/tegra_usb_phy.c
> @@ -209,11 +209,6 @@ static struct tegra_utmip_config utmip_default[] =3D=
 {
>  	},
>  };
> =20
> -static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
> -{
> -	return (phy->instance =3D=3D 1);
> -}
> -
>  static int utmip_pad_open(struct tegra_usb_phy *phy)
>  {
>  	phy->pad_clk =3D clk_get_sys("utmip-pad", NULL);
> @@ -655,7 +650,7 @@ static int	tegra_phy_init(struct usb_phy *x)
>  	struct tegra_ulpi_config *ulpi_config;
>  	int err;
> =20
> -	if (phy_is_ulpi(phy)) {
> +	if (phy->is_ulpi_phy) {
>  		ulpi_config =3D phy->config;
>  		phy->clk =3D clk_get_sys(NULL, ulpi_config->clk);
>  		if (IS_ERR(phy->clk)) {
> @@ -693,7 +688,7 @@ static void tegra_usb_phy_close(struct usb_phy *x)
>  {
>  	struct tegra_usb_phy *phy =3D container_of(x, struct tegra_usb_phy, u_p=
hy);
> =20
> -	if (phy_is_ulpi(phy))
> +	if (phy->is_ulpi_phy)
>  		clk_put(phy->clk);
>  	else
>  		utmip_pad_close(phy);
> @@ -704,7 +699,7 @@ static void tegra_usb_phy_close(struct usb_phy *x)
> =20
>  static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
>  {
> -	if (phy_is_ulpi(phy))
> +	if (phy->is_ulpi_phy)
>  		return ulpi_phy_power_on(phy);
>  	else
>  		return utmi_phy_power_on(phy);
> @@ -712,7 +707,7 @@ static int tegra_usb_phy_power_on(struct tegra_usb_ph=
y *phy)
> =20
>  static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
>  {
> -	if (phy_is_ulpi(phy))
> +	if (phy->is_ulpi_phy)
>  		return ulpi_phy_power_off(phy);
>  	else
>  		return utmi_phy_power_off(phy);
> @@ -749,7 +744,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct devic=
e *dev, int instance,
>  		of_property_read_bool(np, "nvidia,has-legacy-mode");
> =20
>  	if (!phy->config) {
> -		if (phy_is_ulpi(phy)) {
> +		if (phy->is_ulpi_phy) {
>  			pr_err("%s: ulpi phy configuration missing", __func__);
>  			err =3D -EINVAL;
>  			goto err0;
> @@ -796,14 +791,14 @@ EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
> =20
>  void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
>  {
> -	if (!phy_is_ulpi(phy))
> +	if (!phy->is_ulpi_phy)
>  		utmi_phy_preresume(phy);
>  }
>  EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
> =20
>  void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
>  {
> -	if (!phy_is_ulpi(phy))
> +	if (!phy->is_ulpi_phy)
>  		utmi_phy_postresume(phy);
>  }
>  EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
> @@ -811,14 +806,14 @@ EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
>  void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
>  				 enum tegra_usb_phy_port_speed port_speed)
>  {
> -	if (!phy_is_ulpi(phy))
> +	if (!phy->is_ulpi_phy)
>  		utmi_phy_restore_start(phy, port_speed);
>  }
>  EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
> =20
>  void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
>  {
> -	if (!phy_is_ulpi(phy))
> +	if (!phy->is_ulpi_phy)
>  		utmi_phy_restore_end(phy);
>  }
>  EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
> diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_=
usb_phy.h
> index f03e157..a6a89d4 100644
> --- a/include/linux/usb/tegra_usb_phy.h
> +++ b/include/linux/usb/tegra_usb_phy.h
> @@ -60,6 +60,7 @@ struct tegra_usb_phy {
>  	struct usb_phy u_phy;
>  	struct device *dev;
>  	bool is_legacy_phy;
> +	bool is_ulpi_phy;
>  };
> =20
>  struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instanc=
e,
> --=20
> 1.7.0.4
>=20

--=20
balbi

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+ZXRAAoJEIaOsuA1yqREUNsP/0AukMd99gxGAPQXeHe5jKSK
fBfFjrwUvH7FSG76aWOPiXofQipr9MEf4ldCa1GxnIkUiM5HpCd4Bftost9XhTa9
6ZFN77KCBUjkYwTHgThjLGFtirN+ujGfChntd+ouH4/JYJFUYPX0sqzwh8jlkzRa
DaPMiZ5Si+TYiPriOqRiIvr9Us2diVBrgR5SFbXgj5IqhlkmKtfzqYGywp8G649W
QZNp5qXbzn1F4FmQFs4he9Z0kjIQOTN+kT8gkiZbGOMR583zdICN9gr3ViLVmU55
WAdKgsatzgPFBpeZ8Efg31cxEakXFedLYAKVoAJkbKxiJJr06WqMNs5otlQT6cf5
2lpSzsWnyry8XQxTquBPPo6MW5WftBHrH306pdeSA6SAUEFLv4joLYNZi2s0cLHV
LlnVuEHpLEDI2A3LMKRhESCEFljFvY5WTdbTRD98GKSihDmiJojVtMUYKgTr8Rwd
kBmHaM06E1XOuZlET4B/r0U79GwG9nAlcL38Ko5oCt4KU419i3L1P5PGn1I9OSm1
QWNC7AGmCWomebGQyaQ8tF9NQOLIrFqtWRt/2LRxXbbnkdcbtu1e2UphZPKi1m3p
4CNPodVixBEmc6CGiMePGB6bXauEpGlqaRRIGYvlB+/xtNs/r4qFSVy0D1At4p+I
ukvRvFHavGrTAAr5+yAi
=Oggo
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
