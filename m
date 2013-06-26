Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3FZKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:16:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49405 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab3FZKQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:16:55 -0400
Date: Wed, 26 Jun 2013 13:16:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not
 available
Message-ID: <20130626101647.GT12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z3PcgjD2qOzdkXVS"
Content-Disposition: inline
In-Reply-To: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--z3PcgjD2qOzdkXVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 26, 2013 at 02:59:14PM +0530, George Cherian wrote:
> There can be configurations in which DWC3 is hoooked up only to USB2 PHY.
> In such cases we should not return -EPROBE_DEFER, rather continue probe
> even if there is no USB3 PHY.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/dwc3/core.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index c35d49d..d5e6f3e 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -100,7 +100,9 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>  	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
> =20
>  	usb_phy_init(dwc->usb2_phy);
> -	usb_phy_init(dwc->usb3_phy);
> +
> +	if (dwc->usb3_phy)
> +		usb_phy_init(dwc->usb3_phy);

I would feel more comfortable if you would move our maximum_speed module
parameter to DT with a property such as:

snps,maximum_speed =3D "highspeed";

then on driver you could:

ret =3D of_property_read_string(np, "snps,maximum_speed", &maximum_speed);
if (ret < 0)
	bailout();

if (strncmp(maximum_speed, "superspeed", 10) =3D=3D 0) {
	/* grab USB3 PHY, return EPROBE_DEFER if not found */
	grab_usb3_phy();
}

if ((strncmp(maximum_speed, "highspeed", 9) =3D=3D 0) ||
	(strncmp(maximum_speed, "fullspeed", 9) =3D=3D 0) ||
	(strncmp(maximum_speed, "lowspeed", 8) =3D=3D 0)) {
	/* grab USB2 PHY, return EPROBE_DEFER if not found */
	grab_usb2_phy();
}

this way, we depend solely on setting maximum_speed to highspeed for
AM437x :-)

ps: don't forget to default to superspeed in case no property is passed.

--=20
balbi

--z3PcgjD2qOzdkXVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyr+PAAoJEIaOsuA1yqREPgwQAIiUlQ8T/i6WRco9c7pA4TuS
x7FxBlz3ExUZF+8CNT8esEAXwIGfnO73pafkWOkKeIeA9+eS+bZ8mrjlPimmES0b
Tkd+dy0WPScodB201zsPOapwSTQm8shaqwTKpE0ja917n9UoBZKjDIK4vGO5tUGD
wXpzGAMXhIhDZNM42L3IqaCM3ws5Audhr31ZU8L0KDn0S0v8/xEcxD9PyxQmkRw2
lrmaCPqTmV717/OvwyrVJnTKHcKishoW2aAhEGeSScmMaMe47ggvLs+DwJ99MzmD
tmTeIew+BlgohLMl6ho2W84I+FsDanrVHNG/TMuVWkYdiQPL2HO+M1rgNHgLAvJY
/f5i2tNV2vljYIeQfczC93VOj5MO/BAK7wTHv+b4qTRTd/2g2r8ssoP62zanHQL5
H/vbipcg+bfnBuKNX+ptLlgjV/g2QfKFd68XtxmgSQ9EP3xTG4tVATxo9OQthNcT
H6EPC7B7MUTa0gtg2l2gXuGPsWFZCP/NtiLttcn8VztM7j5n1cBvHwPzEZjCOgzr
lnNYq3puZ2NvwKdPxLr8cxYQ85bKujX0uUEqIukuPz01jneHvPiRQSAoCr5sJViU
4aBz+x+ri+jArmstNiDIfRjFW99rVw3+DtBV2s+GIvaImPL0Be5PFplum6y1f04T
G30gQHdaU3sY5No92Ih5
=lSsz
-----END PGP SIGNATURE-----

--z3PcgjD2qOzdkXVS--
