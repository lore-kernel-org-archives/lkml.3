Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3G3G0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:26:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab3G3G0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:26:05 -0400
Date: Tue, 30 Jul 2013 09:25:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v3] usb: phy-samsung-usb: Simplify PMU register handling
Message-ID: <20130730062551.GG9155@radagast>
Reply-To: <balbi@ti.com>
References: <1375134253-18406-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0z5c7mBtSy1wdr4F"
Content-Disposition: inline
In-Reply-To: <1375134253-18406-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0z5c7mBtSy1wdr4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 02:44:13PM -0700, Julius Werner wrote:
> This patch simplifies the way the phy-samsung-usb code finds the correct
> power management register to enable PHY clock gating. Previously, the
> code would calculate the register address from a device tree supplied
> base address and add an offset based on the PHY type.
>=20
> Since every PHY has its own device tree entry and needs only one
> register, we can just encode the address itself in the device tree and
> remove the diffentiation in the code. The bitmask needed to specify the
> bit within that register stays in place, allowing support for platforms
> like s3c64xx that use different bits within the same register. Due to
> this simplification, the whole complication of a Samsung-specific USB
> PHY type can be removed from the PHY driver.
>=20
> Signed-off-by: Julius Werner <jwerner@chromium.org>

alright, let's try to split this patch down, it's too large.

> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos=
5250.dtsi
> index ef57277..5a754d7 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -473,7 +473,7 @@
>  		ranges;
> =20
>  		usbphy-sys {
> -			reg =3D <0x10040704 0x8>;
> +			reg =3D <0x10040704 0x4>;
>  		};
>  	};
> =20
> @@ -505,7 +505,7 @@
>  		ranges;
> =20
>  		usbphy-sys {
> -			reg =3D <0x10040704 0x8>,
> +			reg =3D <0x10040708 0x4>,
>  			      <0x10050230 0x4>;
>  		};
>  	};
> diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-sams=
ung-usb.c
> index ac025ca..32c5264 100644
> --- a/drivers/usb/phy/phy-samsung-usb.c
> +++ b/drivers/usb/phy/phy-samsung-usb.c
> @@ -27,7 +27,6 @@
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> -#include <linux/usb/samsung_usb_phy.h>
> =20
>  #include "phy-samsung-usb.h"
> =20
> @@ -42,9 +41,9 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
>  		return -ENODEV;
>  	}
> =20
> -	sphy->pmuregs =3D of_iomap(usbphy_sys, 0);
> +	sphy->pmureg =3D of_iomap(usbphy_sys, 0);

this rename can go in a separate patch.

> @@ -75,35 +74,25 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
>   */
>  void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool=
 on)
>  {
> -	void __iomem *reg =3D NULL;
>  	u32 reg_val;
> -	u32 en_mask =3D 0;
> =20
> -	if (!sphy->pmuregs) {
> +	if (!sphy->pmureg) {
>  		dev_warn(sphy->dev, "Can't set pmu isolation\n");
>  		return;
>  	}
> =20
> -	if (sphy->phy_type =3D=3D USB_PHY_TYPE_DEVICE) {
> -		reg =3D sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
> -		en_mask =3D sphy->drv_data->devphy_en_mask;
> -	} else if (sphy->phy_type =3D=3D USB_PHY_TYPE_HOST) {
> -		reg =3D sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
> -		en_mask =3D sphy->drv_data->hostphy_en_mask;
> -	}
>=20
> -	reg_val =3D readl(reg);
> +	reg_val =3D readl(sphy->pmureg);
> =20
>  	if (on)
> -		reg_val &=3D ~en_mask;
> +		reg_val &=3D ~sphy->drv_data->phy_en_mask;
>  	else
> -		reg_val |=3D en_mask;
> +		reg_val |=3D sphy->drv_data->phy_en_mask;

removing the if case up there and updating this if here could be a patch
of its own.

> @@ -111,7 +100,7 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
>  /*
>   * Configure the mode of working of usb-phy here: HOST/DEVICE.
>   */
> -void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
> +void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy, bool device_mod=
e)

passing this extra parameter could be a patch of its own.

> @@ -122,31 +111,15 @@ void samsung_usbphy_cfg_sel(struct samsung_usbphy *=
sphy)
> =20
>  	reg =3D readl(sphy->sysreg);
> =20
> -	if (sphy->phy_type =3D=3D USB_PHY_TYPE_DEVICE)
> +	if (device_mode)
>  		reg &=3D ~EXYNOS_USB20PHY_CFG_HOST_LINK;
> -	else if (sphy->phy_type =3D=3D USB_PHY_TYPE_HOST)
> +	else
>  		reg |=3D EXYNOS_USB20PHY_CFG_HOST_LINK;
> =20
>  	writel(reg, sphy->sysreg);
>  }
>  EXPORT_SYMBOL_GPL(samsung_usbphy_cfg_sel);
> =20
> -/*
> - * PHYs are different for USB Device and USB Host.
> - * This make sure that correct PHY type is selected before
> - * any operation on PHY.
> - */
> -int samsung_usbphy_set_type(struct usb_phy *phy,
> -				enum samsung_usb_phy_type phy_type)
> -{
> -	struct samsung_usbphy *sphy =3D phy_to_sphy(phy);
> -
> -	sphy->phy_type =3D phy_type;
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(samsung_usbphy_set_type);

removing this function should be a patch of its own.

--=20
balbi

--0z5c7mBtSy1wdr4F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR91xvAAoJEIaOsuA1yqREUlMP/3+Kq5szEK9694Dy7TebVSub
KC3D+kOq+jlgiZMOhgVf/hp49C9+N1ZpSIl7tn0Qp5L4TFfrDvVjBssxWjddqY0x
kO/hQk1g/4CSx+NmaKTGZgo/bFy47x+ZoQphaiDmqnQ6094Q/K75cTr5Bi1SohdI
2d8+e8MzUvcxPTB/uJ06M6gqVCj4ITN19+rLT3cYndvVqxots9N5ZXwoJ+sE1XV6
GaNLsxurNzxTRM0rYaXPfsFkVsvdK0Ewlr4vkAG1ErTggSGlR5aYmpIAI+CaxKvV
37vOeDFRdPQib9ajehpP6MnIhODIAVrDmwqYaTiftH9+2GrAS7CxLCKwbu/POKjS
TGtMmQXkjbus2RbRlOf1vaCVTiQQl9roxILIt71SLCGmFUl+T+X31tPI6UUWmPwb
pJrbvquSiQJwwD/+wIJfw1RDqCIhLp0xPH8GyK0foQF8BWGCj7jVIRxsw3/XPycL
t6Ez+VA1rWi4Z4Lb9aRmb9DugsOIfOjQfWXDeCHDFoc6r7ZECuaVu25pJ1hEADSH
tlr7MHkMU2Y6k9kr9LE4bug2gYjRR36AjSwgtmqq7aN9mFL1lbtM4fXYSAZegfRg
NcdBaBPBvt093+PIdWWfiw4OzVaqElcph9l9CIlEST6RQ/AKhNSFekhb1vu88rtH
4i0/b2k04CSha3FLxHRJ
=L1qn
-----END PGP SIGNATURE-----

--0z5c7mBtSy1wdr4F--
