Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3AQLoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:44:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46052 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3AQLoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:44:23 -0500
Date: Thu, 17 Jan 2013 13:44:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 14/22] mfd: omap-usb-host: cleanup clock management
 code
Message-ID: <20130117114401.GE18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-15-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <1358422231-24736-15-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 01:30:23PM +0200, Roger Quadros wrote:
> All ports have similarly named port clocks so we can
> bunch them into a port data structure and use for loop
> to enable/disable the clocks.
>=20
> Dynamically allocate and get clocks based on number of ports
> available on the platform
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |  180 ++++++++++++++++++++++++-------------=
-----
>  1 files changed, 103 insertions(+), 77 deletions(-)
>=20
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 779588b..c75b79d 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -92,13 +92,12 @@
> =20
>  struct usbhs_hcd_omap {
>  	int				nports;
> +	struct clk			**utmi_clk;
> =20
>  	struct clk			*xclk60mhsp1_ck;
>  	struct clk			*xclk60mhsp2_ck;
> -	struct clk			*utmi_p1_fck;
> -	struct clk			*usbhost_p1_fck;
> -	struct clk			*utmi_p2_fck;
> -	struct clk			*usbhost_p2_fck;
> +	struct clk			*utmi_p1_gfclk;
> +	struct clk			*utmi_p2_gfclk;
>  	struct clk			*init_60m_fclk;
>  	struct clk			*ehci_logic_fck;
> =20
> @@ -276,6 +275,7 @@ static int usbhs_runtime_resume(struct device *dev)
>  	struct usbhs_hcd_omap		*omap =3D dev_get_drvdata(dev);
>  	struct usbhs_omap_platform_data	*pdata =3D omap->pdata;
>  	unsigned long			flags;
> +	int i, r;
> =20
>  	dev_dbg(dev, "usbhs_runtime_resume\n");
> =20
> @@ -285,13 +285,18 @@ static int usbhs_runtime_resume(struct device *dev)
>  	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
>  		clk_enable(omap->ehci_logic_fck);
> =20
> -	if (is_ehci_tll_mode(pdata->port_mode[0]))
> -		clk_enable(omap->usbhost_p1_fck);
> -	if (is_ehci_tll_mode(pdata->port_mode[1]))
> -		clk_enable(omap->usbhost_p2_fck);
> -
> -	clk_enable(omap->utmi_p1_fck);
> -	clk_enable(omap->utmi_p2_fck);
> +	for (i =3D 0; i < omap->nports; i++) {
> +		if (is_ehci_tll_mode(pdata->port_mode[i])) {
> +			if (omap->utmi_clk[i]) {
> +				r =3D clk_enable(omap->utmi_clk[i]);
> +				if (r) {
> +					dev_err(dev,
> +					 "Can't enable port %d clk : %d\n",
> +					 i, r);
> +				}
> +			}
> +		}
> +	}

you can decrease indentation here a little bit:

	for (i =3D 0; i < omap->nports; i++) {
		if (!is_ehci_tll_mode(pdata->port_mode[i]))
			continue;

		if (!omap->utmi_clk[i])
			continue;

		r =3D clk_enable(omap->utmi_clk[i]);
		if (r) {
			dev_err(dev,
			 "Can't enable port %d clk : %d\n",
			 i, r);
		}
	}


> @@ -303,18 +308,18 @@ static int usbhs_runtime_suspend(struct device *dev)
>  	struct usbhs_hcd_omap		*omap =3D dev_get_drvdata(dev);
>  	struct usbhs_omap_platform_data	*pdata =3D omap->pdata;
>  	unsigned long			flags;
> +	int i;
> =20
>  	dev_dbg(dev, "usbhs_runtime_suspend\n");
> =20
>  	spin_lock_irqsave(&omap->lock, flags);
> =20
> -	if (is_ehci_tll_mode(pdata->port_mode[0]))
> -		clk_disable(omap->usbhost_p1_fck);
> -	if (is_ehci_tll_mode(pdata->port_mode[1]))
> -		clk_disable(omap->usbhost_p2_fck);
> -
> -	clk_disable(omap->utmi_p2_fck);
> -	clk_disable(omap->utmi_p1_fck);
> +	for (i =3D 0; i < omap->nports; i++) {
> +		if (is_ehci_tll_mode(pdata->port_mode[i])) {
> +			if (omap->utmi_clk[i])
> +				clk_disable(omap->utmi_clk[i]);
> +		}
> +	}

same as above.

--=20
balbi

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+QBAAoJEIaOsuA1yqREyOYP/ik1DHi3ZywDBS9eINiysnr3
LlHLCWxvJSTRq8a5xYDKELCdpC9RyrpS4raJFVQdMTRVnN+z77S69HWZd+4/dNdN
XMKPlWfm++DvD5JOXvdV2eP3ndP8VX8o37ZebGp0N8L2O+23vcVgfr15f5UxfDgf
W33Uu0r2B3t5eY9NcbnLSI7Pv0OVLVPmu9rCZQkaZJ9poVlpHuy8I8TCH2sVNv1a
AlmX/P5MVaaPZR7/r5iP23gcx0p/dh6XJVNw031k/a/NFtVfAKNajiaVb7rfbi7n
xDrk0Dg7uhQSOYIe+4NcAaILsPv+fxChYJpVFEmfeJxyO5YboSLGQ82toPAmamF1
lA1SdniaHljHbep7ZdO9VHy4EqHgopH98YiY9vQbyFu5IxW3q6EfjJmkuqCA//7T
Tvm9fHjCKtaB0AFiHaRn07KURUaiw1A0BOKA17M+3dSD0R10/aCm6YF0Ohb04a0W
0LBnvimJsbtwz2nN15Ikvtf5JYhW8UlpcnJNvGP61P8CvAuGQQEZEzpUMV0cMFBC
dAu3u+EDQMreF4kzDcV1EszVb1VdsN2/tPSM9DxQ+1V2j/IjbHloPArzOTHo7Q0B
4XdZZ9SIhJDid0K1vpJQ6BpBK7y9oLvdM3/3OK5aggS4hTkBq2FPUpCxDIuAKU7w
UnKNYotfhOAyqCnoJKf7
=h+QD
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
