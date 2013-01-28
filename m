Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3A1LsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:48:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36059 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab3A1LsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:48:19 -0500
Date: Mon, 28 Jan 2013 13:47:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <dianders@chromium.org>, <sylvester.nawrocki@gmail.com>,
        <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] usb: dwc3: exynos: Enable runtime power management
Message-ID: <20130128114755.GF28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 05:12:27PM +0530, Vivek Gautam wrote:
> Enabling runtime power management on dwc3-exynos to save
> power and allow its PHY's power to be managed at runtime.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   47 ++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 47 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exyno=
s.c
> index aae5328..c51e8c1 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -157,11 +157,15 @@ static int dwc3_exynos_probe(struct platform_device=
 *pdev)
>  		goto err4;
>  	}
> =20
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
>  	return 0;
> =20
>  err4:
>  	clk_disable(clk);
>  	clk_put(clk);
> +	pm_runtime_disable(&pdev->dev);
>  err3:
>  	platform_device_put(dwc3);
>  err1:
> @@ -174,6 +178,8 @@ static int dwc3_exynos_remove(struct platform_device =
*pdev)
>  {
>  	struct dwc3_exynos	*exynos =3D platform_get_drvdata(pdev);
> =20
> +	pm_runtime_disable(&pdev->dev);
> +
>  	platform_device_unregister(exynos->dwc3);
>  	platform_device_unregister(exynos->usb2_phy);
>  	platform_device_unregister(exynos->usb3_phy);
> @@ -186,6 +192,46 @@ static int dwc3_exynos_remove(struct platform_device=
 *pdev)
>  	return 0;
>  }
> =20
> +static int dwc3_exynos_runtime_suspend(struct device *dev)
> +{
> +	struct dwc3_exynos	*exynos =3D dev_get_drvdata(dev);
> +	struct platform_device	*pdev_dwc =3D exynos->dwc3;
> +	struct dwc3		*dwc =3D NULL;
> +
> +	dwc =3D platform_get_drvdata(pdev_dwc);
> +
> +	if (!dwc)
> +		return 0;
> +
> +	pm_runtime_put_sync(dwc->usb3_phy->dev);
> +
> +	clk_disable(exynos->clk);
> +
> +	return 0;
> +}
> +static int dwc3_exynos_runtime_resume(struct device *dev)
> +{
> +	struct dwc3_exynos	*exynos =3D dev_get_drvdata(dev);
> +	struct platform_device	*pdev_dwc =3D exynos->dwc3;
> +	struct dwc3		*dwc =3D NULL;
> +
> +	dwc =3D platform_get_drvdata(pdev_dwc);
> +
> +	clk_enable(exynos->clk);
> +
> +	if (!dwc)
> +		return 0;
> +
> +	pm_runtime_get_sync(dwc->usb3_phy->dev);

dude, this is wrong :-)

look at this:

pm_runtime_get() -> dwc3_exynos_runtime_resume() ->
pm_runtime_get_sync() -> dwc3_exynos_runtime_resume() -> ...

only your clock enalbe should do

--=20
balbi

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBmVrAAoJEIaOsuA1yqREHCIP/1RSqbMzoriqHEzRsbjssFnN
8bCrwYz83KV38ayRQfnDkCIrvstLCjADhYvU4Y/06R1HlJF7vfrP71J4Ilkz0aJW
mLJyMPthoH0GtiBl38N92+3nLfAVB0bNHvSRBYTmA/OPtTeho8CllLIJhAOgQ6Hb
ji+JOtAoqsqa3RZI+zlGrCkahuH7eIh+rwPc+Aopzf+HGSpMQZATfQyOqRhCNiHl
vAi6A86S9DGR29ueX5qs/HHn3joQLC/W/XA7l8PBDqEgbnwV7Q9LBJ2sBjKXM4Ys
UgN7o08VY3W7218zkYnwrg3RChMxhbDX70fscqbtVc6jAWOmGaOEoMicz/bz/KST
U41YkMMZTOMfQDawu3YDgLAdTaRrai4ib1LESEhIMqfeMUNL4ugJQHYo5EmViisL
EHsMJ27o9EVcMuz/T/qx4YgaA41T+4LmDUqSr1nudW/+eRsnzkcTzAsQi5G0GY1/
0Nr4gSNoTx3dCqLAtoj3VkIC3GwpShT1c6DDUFsLdXA22H5ygYmObtEpN8S/fhL1
LfvbvhBywPZG7G9PNWNNgWCHowLf93EvbiKVgJAcEvuxKQ5emVROsYbA9mlaeXTi
HsStM8ttPWpTd1cRbqCpk8r8UsMGX9/iI3AMYpp66wNsU70vFX8kTvlYilSsPPM6
LiB0ze6WYcb2poyAuzyL
=2NdJ
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
