Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762128Ab3DCNtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:49:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38299 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab3DCNtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:49:02 -0400
Date: Wed, 3 Apr 2013 16:48:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <swarren@wwwdotorg.org>,
        <sylvester.nawrocki@gmail.com>, <rob@landley.net>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <mchehab@redhat.com>,
        <santosh.shilimkar@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <swarren@nvidia.com>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 2/6] usb: phy: omap-usb2: use the new generic PHY
 framework
Message-ID: <20130403134827.GF14680@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364993634-6378-1-git-send-email-kishon@ti.com>
 <1364993634-6378-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Content-Disposition: inline
In-Reply-To: <1364993634-6378-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 06:23:50PM +0530, Kishon Vijay Abraham I wrote:
> Used the generic PHY framework API to create the PHY. omap_usb2_suspend
> is split into omap_usb_suspend and omap_usb_resume in order to align
> with the new framework.
>=20
> However using the old USB PHY library cannot be completely removed
> because OTG is intertwined with PHY and moving to the new framework
> will break OTG. Once we have a separate OTG state machine, we
> can get rid of the USB PHY library.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/phy/omap-usb2.c |   48 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 48 insertions(+)
>=20
> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
> index 844ab68..4e48db4 100644
> --- a/drivers/usb/phy/omap-usb2.c
> +++ b/drivers/usb/phy/omap-usb2.c
> @@ -28,6 +28,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/delay.h>
>  #include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/phy.h>
> =20
>  /**
>   * omap_usb2_set_comparator - links the comparator present in the sytem =
with
> @@ -119,9 +120,49 @@ static int omap_usb2_suspend(struct usb_phy *x, int =
suspend)
>  	return 0;
>  }
> =20
> +static int omap_usb_suspend(struct phy *x)
> +{
> +	struct omap_usb *phy =3D dev_get_drvdata(&x->dev);
> +
> +	if (!phy->is_suspended) {
> +		omap_control_usb_phy_power(phy->control_dev, 0);
> +		pm_runtime_put_sync(phy->dev);
> +		phy->is_suspended =3D 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int omap_usb_resume(struct phy *x)
> +{
> +	u32 ret;
> +	struct omap_usb *phy =3D dev_get_drvdata(&x->dev);
> +
> +	if (phy->is_suspended) {
> +		ret =3D pm_runtime_get_sync(phy->dev);
> +		if (ret < 0) {
> +			dev_err(phy->dev, "get_sync failed with err %d\n",
> +									ret);
> +			return ret;
> +		}
> +		omap_control_usb_phy_power(phy->control_dev, 1);
> +		phy->is_suspended =3D 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct phy_ops ops =3D {

const ? Maybe provide a:

#define DEFINE_PHY_OPS(name)	\
const struct phy_ops #name_phy_ops =3D {

macro ? This will force people to add the const keyword :-)

--=20
balbi

--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXDMrAAoJEIaOsuA1yqRE9YMQAKAO8yLvo66L/58x/SnJxyrl
3A7JrDkmh/d07zz19R3XrwfvTaYJg/k1NxakWd/iIUSHbeWGTJrmJzS0DlRbHlmr
+DrRSu1DlkfmKPKCB8Z7kajn8osqFSLAhJzw3tfBbcCTV+8ZnzruQbE1BvJJUlGz
W4AVjssYOoI1Dll/qDekz8QgDdPTkZ7rhabCKEXZjGFbq3RDfe/0UtlPLyTZnM0K
LQlIcZymLCUTTpoY0NdAlM6twdMGc5IEFvRjnDJeEN8z6ILVBolt7dbHwo8DxgBT
naFC/t9lV9e+vBegd5bDzNjH1vbC2Hf9Pu5kf+m+bCCqNV/z+ncCCAMXWDBG8JXA
SS0nsdov7CDbr58FGjTY4VcHv6KIWB4wyepak/nCPrDLaVARiB03l/zMZpVZGO7g
mL3TvIeCRvObsszo/F91xMb+eu11XRuwGOt16reur1yupJ/FvDO91HkxBsK63KX0
tXXyXFLtVM1Ias1xH18GN6Nbz6i3b+0ZSE2GBEitXUAFQF6kBB5FzjmzAm6f8M8a
kksgrQchEr/LkPYKapeKiU0fpRXCIO0DaaXT/kFpte1LoOniq3Z5VoYadZpFoLN2
acpWPTSbG0Myxbru4sjY8p1MzcV6XTleDmv5BCmMVo2XRx31k29r7TRa6VSzGidM
oA9NXDSz1r3RpzIuEuRH
=OvUh
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
