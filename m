Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3A1MJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:09:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54809 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3A1MJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:09:33 -0500
Date: Mon, 28 Jan 2013 14:09:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <dianders@chromium.org>, <sylvester.nawrocki@gmail.com>,
        <tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/4] usb: phy: samsung: Enable runtime power management
 on samsung-usb3
Message-ID: <20130128120909.GG28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-5-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <1359373348-18320-5-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 28, 2013 at 05:12:28PM +0530, Vivek Gautam wrote:
> Enabling runtime power management support on samsung-usb3 phy
> and further adding support to turn off the PHY ref_clk PLL.
> It thereby requires PHY ref_clk to be switched between internal
> core clock and external PLL clock.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

this needs to be broken down a bit. I can see three patches at least:
add support for external clock, add support for phy gpio powerdown and
add runtime pm ;-)

> ---
>  drivers/usb/phy/samsung-usb3.c   |  107 ++++++++++++++++++++++++++++++++=
+++--
>  drivers/usb/phy/samsung-usbphy.c |   26 +++++++++
>  drivers/usb/phy/samsung-usbphy.h |    1 +
>  3 files changed, 128 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/phy/samsung-usb3.c b/drivers/usb/phy/samsung-usb=
3.c
> index 29e1321..4dbef15 100644
> --- a/drivers/usb/phy/samsung-usb3.c
> +++ b/drivers/usb/phy/samsung-usb3.c
> @@ -22,8 +22,10 @@
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/err.h>
> +#include <linux/gpio.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/usb/samsung_usb_phy.h>
>  #include <linux/platform_data/samsung-usbphy.h>
> =20
> @@ -32,7 +34,7 @@
>  /*
>   * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clo=
ck core.
>   */
> -static u32 samsung_usb3_phy_set_refclk(struct samsung_usbphy *sphy)
> +static u32 samsung_usb3_phy_set_refclk_int(struct samsung_usbphy *sphy)
>  {
>  	u32 reg;
>  	u32 refclk;
> @@ -65,7 +67,22 @@ static u32 samsung_usb3_phy_set_refclk(struct samsung_=
usbphy *sphy)
>  	return reg;
>  }
> =20
> -static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *sphy)
> +/*
> + * Sets the phy clk as ref_pad_clk (XusbXTI) which is clock from externa=
l PLL.
> + */
> +static u32 samsung_usb3_phy_set_refclk_ext(void)
> +{
> +	u32 reg;
> +
> +	reg =3D PHYCLKRST_REFCLKSEL_PAD_REFCLK |
> +		PHYCLKRST_FSEL_PAD_100MHZ |
> +		PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF;
> +
> +	return reg;
> +}

I wonder if you really need this small function (likewise for
set_refclk_int()). They don't do much, so you could just inline them on
the only caller.

> @@ -80,7 +97,11 @@ static int samsung_exynos5_usb3_phy_enable(struct sams=
ung_usbphy *sphy)
> =20
>  	phyparam0 =3D readl(regs + EXYNOS5_DRD_PHYPARAM0);
>  	/* Select PHY CLK source */
> -	phyparam0 &=3D ~PHYPARAM0_REF_USE_PAD;
> +	if (use_ext_clk)
> +		phyparam0 |=3D PHYPARAM0_REF_USE_PAD;
> +	else
> +		phyparam0 &=3D ~PHYPARAM0_REF_USE_PAD;
> +
>  	/* Set Loss-of-Signal Detector sensitivity */
>  	phyparam0 &=3D ~PHYPARAM0_REF_LOSLEVEL_MASK;
>  	phyparam0 |=3D PHYPARAM0_REF_LOSLEVEL;
> @@ -115,7 +136,10 @@ static int samsung_exynos5_usb3_phy_enable(struct sa=
msung_usbphy *sphy)
>  	/* UTMI Power Control */
>  	writel(PHYUTMI_OTGDISABLE, regs + EXYNOS5_DRD_PHYUTMI);
> =20
> -	phyclkrst =3D samsung_usb3_phy_set_refclk(sphy);
> +	if (use_ext_clk)
> +		phyclkrst =3D samsung_usb3_phy_set_refclk_ext();
> +	else
> +		phyclkrst =3D samsung_usb3_phy_set_refclk_int(sphy);
> =20
>  	phyclkrst |=3D PHYCLKRST_PORTRESET |
>  			/* Digital power supply in normal operating mode */
> @@ -163,7 +187,7 @@ static void samsung_exynos5_usb3_phy_disable(struct s=
amsung_usbphy *sphy)
>  	writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
>  }
> =20
> -static int samsung_usb3_phy_init(struct usb_phy *phy)
> +static int samsung_exynos5_usb3_phy_init(struct usb_phy *phy, bool use_e=
xt_clk)
>  {
>  	struct samsung_usbphy *sphy;
>  	unsigned long flags;
> @@ -187,7 +211,7 @@ static int samsung_usb3_phy_init(struct usb_phy *phy)
>  	samsung_usbphy_set_isolation(sphy, false);
> =20
>  	/* Initialize usb phy registers */
> -	samsung_exynos5_usb3_phy_enable(sphy);
> +	samsung_exynos5_usb3_phy_enable(sphy, use_ext_clk);
> =20
>  	spin_unlock_irqrestore(&sphy->lock, flags);
> =20
> @@ -198,6 +222,34 @@ static int samsung_usb3_phy_init(struct usb_phy *phy)
>  }
> =20
>  /*
> + * Switch  between internal core clock and external oscillator clock
> + * for PHY reference clock
> + */
> +static int samsung_exynos5_usb3phy_clk_switch(struct usb_phy *phy,
> +						bool use_ext_clk)
> +{
> +	/*
> +	 * This will switch PHY refclk from internal core clock
> +	 * to external PLL clock when device is in use and vice versa
> +	 * when device plunge into runtime suspend mode.
> +	 */
> +	return samsung_exynos5_usb3_phy_init(phy, use_ext_clk);
> +}
> +
> +/*
> + * The function passed to the usb driver for phy initialization
> + */
> +static int samsung_usb3_phy_init(struct usb_phy *phy)
> +{
> +	/*
> +	 * We start with using PHY refclk from external PLL,
> +	 * once runtime suspend for the device is called this
> +	 * will change to internal core clock
> +	 */
> +	return  samsung_exynos5_usb3_phy_init(phy, true);
> +}
> +
> +/*
>   * The function passed to the usb driver for phy shutdown
>   */
>  static void samsung_usb3_phy_shutdown(struct usb_phy *phy)
> @@ -287,6 +339,9 @@ static int samsung_usb3_phy_probe(struct platform_dev=
ice *pdev)
> =20
>  	platform_set_drvdata(pdev, sphy);
> =20
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
>  	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB3);
>  }
> =20
> @@ -296,6 +351,8 @@ static int samsung_usb3_phy_remove(struct platform_de=
vice *pdev)
> =20
>  	usb_remove_phy(&sphy->phy);
> =20
> +	pm_runtime_disable(&pdev->dev);

before disabling, shouldn't you make sure the IP is turned off by
calling:

if (!pm_runtime_suspend(&pdev->dev))
	pm_runtime_put_sync(&pdev->dev);

??

> @@ -304,6 +361,42 @@ static int samsung_usb3_phy_remove(struct platform_d=
evice *pdev)
>  	return 0;
>  }
> =20
> +static int samsung_usb3_phy_runtime_suspend(struct device *dev)
> +{
> +	struct samsung_usbphy *sphy =3D dev_get_drvdata(dev);
> +
> +	samsung_exynos5_usb3phy_clk_switch(&sphy->phy, false);
> +
> +	if (gpio_is_valid(sphy->phyclk_gpio))
> +		gpio_set_value(sphy->phyclk_gpio, 0);
> +
> +	return 0;
> +}
> +
> +static int samsung_usb3_phy_runtime_resume(struct device *dev)
> +{
> +	struct samsung_usbphy *sphy =3D dev_get_drvdata(dev);
> +
> +	if (gpio_is_valid(sphy->phyclk_gpio)) {
> +		gpio_set_value(sphy->phyclk_gpio, 1);
> +		/*
> +		 * PI6C557-03 clock generator needs 3ms typically to stabilise,
> +		 * but the datasheet doesn't list max.  We'll sleep for 10ms
> +		 * and cross our fingers that it's enough.
> +		 */
> +		usleep_range(10000, 20000);
> +	}
> +
> +	samsung_exynos5_usb3phy_clk_switch(&sphy->phy, true);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops samsung_usb3_phy_pm_ops =3D {
> +	SET_RUNTIME_PM_OPS(samsung_usb3_phy_runtime_suspend,
> +				samsung_usb3_phy_runtime_resume, NULL)
> +};

you need to wrap this with #ifdef CONFIG_PM_RUNTIME. So it would look
better as:

#ifdef CONFIG_PM_RUNTIME
suspend()
resume()
#define DEV_PM_OPS	(&samsung_usb3_phy_pm_ops)
#else
#define DEV_PM_OPS	NULL
#endif

> +
>  static struct samsung_usbphy_drvdata usb3_phy_exynos5 =3D {
>  	.cpu_type		=3D TYPE_EXYNOS5250,
>  	.devphy_en_mask		=3D EXYNOS_USBPHY_ENABLE,
> @@ -338,7 +431,9 @@ static struct platform_driver samsung_usb3_phy_driver=
 =3D {
>  		.name	=3D "samsung-usb3-phy",
>  		.owner	=3D THIS_MODULE,
>  		.of_match_table =3D of_match_ptr(samsung_usbphy_dt_match),
> +		.pm	=3D &samsung_usb3_phy_pm_ops,

and here you have:

	.pm =3D DEV_PM_OPS,

--=20
balbi

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBmplAAoJEIaOsuA1yqREOTUP/i6ZCOlIx9ktzmwt75DK9tMD
qLZn5G1lEPO6jzofM6BlocD05xxPAWSEuZ4Uz+00rnxx5J95du6CgNxyt6ztCWD6
/6M7Z4SYg4KAn/c2oqFQzVswl1qv6VRLYez8/bCcRXRe52rMfQRawgo5KHFLqa/P
mjr92S/s7xIuzt0LQ6DqBn+dWAUptYl3UxexKyO/bO+Lf6+hl03LOixTGqf2hRHW
+nqF+Tg0QsmkQnB3CuYFeosKvPr7Qy1iYs+y2Z25Whuv2vMhg6EvJTa89tJ05mE9
kr1AmzG8IIJSKPS+L1fZJ0Du0mcPQc7/3Rb14A6AdlJg9lj9SXTenQwouOaIEQID
vz/eD35Lc2v8E3IZUzV9USCab8Z3S7ADnNrosYDX34/FNaOwkuR3+1I+nSDBQwhy
O83C6BOnYTwybcu1l60kl0uk7n+LXYzIAm+Ii+K7w/1a99HdRkCDeDerhRV655Cx
kPl5hKbIjNAE0Dwd19B8iOMJaUeW51l2zdIs85IJFBz1mEnNM3hmGZpoTN/gsamg
kmV4aw/2j2qTf8qW2fbd7JtRASTsWftdA/QSR1t5KZD3fQ3D5zOm5CNeHeb6Q+SE
2E5hR0lBkq8pK7qcbcsQ5zI1B8yrE1cPHxB3nUfQ542XBfARwTo2oNrWfg13wluj
dRyU9MXuIntctSG8Sj88
=4AcZ
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
