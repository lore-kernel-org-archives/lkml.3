Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab3ARSeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:34:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48761 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab3ARSeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:34:21 -0500
Date: Fri, 18 Jan 2013 20:34:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/4] USB: PHY: Get rid of instance number to
 differentiate legacy controller
Message-ID: <20130118183416.GA1776@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
 <1358343022-28919-3-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1358343022-28919-3-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 07:00:20PM +0530, Venu Byravarasu wrote:
> Tegra20 USB has 3 PHY instances. Instance 0 is based on
> legacy PHY interface and other two are standard interfaces.
>=20
> As instance number was used to differentiate legacy from
> standard interfaces, used DT param to get this info and
> processed accordingly.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/phy/tegra_usb_phy.c   |   32 +++++++++++++++-----------------
>  include/linux/usb/tegra_usb_phy.h |    1 +
>  2 files changed, 16 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_=
phy.c
> index 3059384..79280fe 100644
> --- a/drivers/usb/phy/tegra_usb_phy.c
> +++ b/drivers/usb/phy/tegra_usb_phy.c
> @@ -24,6 +24,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/gpio.h>
> +#include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/usb/otg.h>
>  #include <linux/usb/ulpi.h>
> @@ -221,7 +222,7 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
>  		return PTR_ERR(phy->pad_clk);
>  	}
> =20
> -	if (phy->instance =3D=3D 0) {
> +	if (phy->is_legacy_phy) {
>  		phy->pad_regs =3D phy->regs;
>  	} else {
>  		phy->pad_regs =3D ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);
> @@ -236,7 +237,7 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
> =20
>  static void utmip_pad_close(struct tegra_usb_phy *phy)
>  {
> -	if (phy->instance !=3D 0)
> +	if (!phy->is_legacy_phy)
>  		iounmap(phy->pad_regs);
>  	clk_put(phy->pad_clk);
>  }
> @@ -305,7 +306,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy=
 *phy)
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> =20
> -	if (phy->instance =3D=3D 0) {
> +	if (phy->is_legacy_phy) {
>  		val =3D readl(base + USB_SUSP_CTRL);
>  		val |=3D USB_SUSP_SET;
>  		writel(val, base + USB_SUSP_CTRL);
> @@ -315,9 +316,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy=
 *phy)
>  		val =3D readl(base + USB_SUSP_CTRL);
>  		val &=3D ~USB_SUSP_SET;
>  		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	if (phy->instance =3D=3D 2) {
> +	} else {
>  		val =3D readl(base + USB_PORTSC1);
>  		val |=3D USB_PORTSC1_PHCD;
>  		writel(val, base + USB_PORTSC1);
> @@ -332,7 +331,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy =
*phy)
>  	unsigned long val;
>  	void __iomem *base =3D phy->regs;
> =20
> -	if (phy->instance =3D=3D 0) {
> +	if (phy->is_legacy_phy) {
>  		val =3D readl(base + USB_SUSP_CTRL);
>  		val |=3D USB_SUSP_CLR;
>  		writel(val, base + USB_SUSP_CTRL);
> @@ -342,9 +341,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy =
*phy)
>  		val =3D readl(base + USB_SUSP_CTRL);
>  		val &=3D ~USB_SUSP_CLR;
>  		writel(val, base + USB_SUSP_CTRL);
> -	}
> -
> -	if (phy->instance =3D=3D 2) {
> +	} else {
>  		val =3D readl(base + USB_PORTSC1);
>  		val &=3D ~USB_PORTSC1_PHCD;
>  		writel(val, base + USB_PORTSC1);
> @@ -365,7 +362,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *ph=
y)
>  	val |=3D UTMIP_RESET;
>  	writel(val, base + USB_SUSP_CTRL);
> =20
> -	if (phy->instance =3D=3D 0) {
> +	if (phy->is_legacy_phy) {
>  		val =3D readl(base + USB1_LEGACY_CTRL);
>  		val |=3D USB1_NO_LEGACY_MODE;
>  		writel(val, base + USB1_LEGACY_CTRL);
> @@ -440,16 +437,14 @@ static int utmi_phy_power_on(struct tegra_usb_phy *=
phy)
>  	val |=3D UTMIP_BIAS_PDTRK_COUNT(0x5);
>  	writel(val, base + UTMIP_BIAS_CFG1);
> =20
> -	if (phy->instance =3D=3D 0) {
> +	if (phy->is_legacy_phy) {
>  		val =3D readl(base + UTMIP_SPARE_CFG0);
>  		if (phy->mode =3D=3D TEGRA_USB_PHY_MODE_DEVICE)
>  			val &=3D ~FUSE_SETUP_SEL;
>  		else
>  			val |=3D FUSE_SETUP_SEL;
>  		writel(val, base + UTMIP_SPARE_CFG0);
> -	}
> -
> -	if (phy->instance =3D=3D 2) {
> +	} else {
>  		val =3D readl(base + USB_SUSP_CTRL);
>  		val |=3D UTMIP_PHY_ENABLE;
>  		writel(val, base + USB_SUSP_CTRL);
> @@ -459,7 +454,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *ph=
y)
>  	val &=3D ~UTMIP_RESET;
>  	writel(val, base + USB_SUSP_CTRL);
> =20
> -	if (phy->instance =3D=3D 0) {
> +	if (phy->is_legacy_phy) {
>  		val =3D readl(base + USB1_LEGACY_CTRL);
>  		val &=3D ~USB1_VBUS_SENSE_CTL_MASK;
>  		val |=3D USB1_VBUS_SENSE_CTL_A_SESS_VLD;
> @@ -472,7 +467,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *ph=
y)
> =20
>  	utmi_phy_clk_enable(phy);
> =20
> -	if (phy->instance =3D=3D 2) {
> +	if (!phy->is_legacy_phy) {
>  		val =3D readl(base + USB_PORTSC1);
>  		val &=3D ~USB_PORTSC1_PTS(~0);
>  		writel(val, base + USB_PORTSC1);
> @@ -739,6 +734,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct devic=
e *dev, int instance,
>  	unsigned long parent_rate;
>  	int i;
>  	int err;
> +	struct device_node *np =3D dev->of_node;
> =20
>  	phy =3D kzalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
>  	if (!phy)
> @@ -749,6 +745,8 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct devic=
e *dev, int instance,
>  	phy->config =3D config;
>  	phy->mode =3D phy_mode;
>  	phy->dev =3D dev;
> +	phy->is_legacy_phy =3D
> +		of_property_read_bool(np, "nvidia,has-legacy-mode");
> =20
>  	if (!phy->config) {
>  		if (phy_is_ulpi(phy)) {
> diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_=
usb_phy.h
> index 34e6355..f03e157 100644
> --- a/include/linux/usb/tegra_usb_phy.h
> +++ b/include/linux/usb/tegra_usb_phy.h
> @@ -59,6 +59,7 @@ struct tegra_usb_phy {
>  	struct usb_phy *ulpi;
>  	struct usb_phy u_phy;
>  	struct device *dev;
> +	bool is_legacy_phy;
>  };
> =20
>  struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instanc=
e,
> --=20
> 1.7.0.4
>=20

--=20
balbi

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+ZWoAAoJEIaOsuA1yqREG00QAKLFUfh8YPFLYFafhinl3ccP
rq8Hr7ExCa8AxD1jYLMw8CC9QUx2EcES/A5HY2/3gGFVvDI4vdLCP+dXQbq0lXUH
exlqoC1R4wIPons9P2V4ORJLmEBL3v5Rq2yIp2DwEapTwic+LFEIgRM3e1bSvYhe
dG4anJuH/+Rw7cECGCi2KPAhaA/dX4kqXbTo8+YPUuRxRWOkIkRMw44bfKsx86Se
8KO1MfhyIuKRtp2H6AqNecHaTY3gP03rnayc0ajBoH/qrXdibGkmVDEMnegk3tZ3
vh6NBrq0SeW6hWWOwitmO/l2wxftWg4ZoneE+oS29fLZ9gmAI6W9sqgyRTSpIkht
ImfOFZADbb4ZgItJ2ZtDqoAMYEYSZ5KJpmV774PTkmv6N/1p+l8/wwUYhHoUjmTy
yNTNfXN67381onMX6Ep/+aXNorOZzlHZToSI159MyK9i8PZyA4DY9Knwi2TSbR+d
TWAG4ESMCt3RSRmFCYfxSEETPx8Y9mYFf3zCGekT3oqGineTL+P7cjPN4CM0YZ3g
AVnRgflRpIVC1iSCDGM/Wund53Jxsfs5k4FuyLjyEsJpFslaPB+e+NmZOU/E9KhF
rqmWg6JrTa/4n8U1N05R1Mu6rv3IB4d8M9SC8itg3LDhz97Js1PThsAFiqw79u8S
qwho8VHXU6esCrr1MJSC
=m1mu
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
