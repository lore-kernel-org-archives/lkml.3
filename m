Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3FRJtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:49:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43169 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3FRJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:49:08 -0400
Date: Tue, 18 Jun 2013 12:47:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 7/9] usb: musb: omap2430: use the new generic PHY
 framework
Message-ID: <20130618094703.GV5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-8-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GGxZz/e2pmGePzrA"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-8-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GGxZz/e2pmGePzrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 13, 2013 at 02:13:57PM +0530, Kishon Vijay Abraham I wrote:
> Use the generic PHY framework API to get the PHY. The usb_phy_set_resume
> and usb_phy_set_suspend is replaced with power_on/get_sync and
> power_off/put_sync to align with the new PHY framework.
>=20
> musb->xceiv can't be removed as of now because musb core uses xceiv.state=
 and
> xceiv.otg. Once there is a separate state machine to handle otg, these ca=
n be
> moved out of xceiv and then we can start using the generic PHY framework.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/musb/musb_core.c |    1 +
>  drivers/usb/musb/musb_core.h |    3 +++
>  drivers/usb/musb/omap2430.c  |   29 +++++++++++++++++++++--------
>  3 files changed, 25 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 37a261a..f732bcc 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -1864,6 +1864,7 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
>  	musb->board_set_power =3D plat->set_power;
>  	musb->min_power =3D plat->min_power;
>  	musb->ops =3D plat->platform_ops;
> +	musb->phy_label =3D plat->phy_label;
> =20
>  	/* The musb_platform_init() call:
>  	 *   - adjusts musb->mregs
> diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
> index 7fb4819..498ae21 100644
> --- a/drivers/usb/musb/musb_core.h
> +++ b/drivers/usb/musb/musb_core.h
> @@ -46,6 +46,7 @@
>  #include <linux/usb.h>
>  #include <linux/usb/otg.h>
>  #include <linux/usb/musb.h>
> +#include <linux/phy/phy.h>
> =20
>  struct musb;
>  struct musb_hw_ep;
> @@ -357,6 +358,7 @@ struct musb {
>  	u16			int_tx;
> =20
>  	struct usb_phy		*xceiv;
> +	struct phy		*phy;
> =20
>  	int nIrq;
>  	unsigned		irq_wake:1;
> @@ -434,6 +436,7 @@ struct musb {
>  	unsigned                double_buffer_not_ok:1;
> =20
>  	struct musb_hdrc_config	*config;
> +	const char		*phy_label;
> =20
>  #ifdef MUSB_CONFIG_PROC_FS
>  	struct proc_dir_entry *proc_entry;
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index 628b93f..c62a004 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -348,14 +348,24 @@ static int omap2430_musb_init(struct musb *musb)
>  	 * up through ULPI.  TWL4030-family PMICs include one,
>  	 * which needs a driver, drivers aren't always needed.
>  	 */
> -	if (dev->parent->of_node)
> +	if (dev->parent->of_node) {
> +		musb->phy =3D devm_phy_get(dev->parent, "usb2-phy");
> +
> +		/* We can't totally remove musb->xceiv as of now because
> +		 * musb core uses xceiv.state and xceiv.otg. Once we have
> +		 * a separate state machine to handle otg, these can be moved
> +		 * out of xceiv and then we can start using the generic PHY
> +		 * framework
> +		 */
>  		musb->xceiv =3D devm_usb_get_phy_by_phandle(dev->parent,
>  		    "usb-phy", 0);
> -	else
> +	} else {
>  		musb->xceiv =3D devm_usb_get_phy_dev(dev, 0);
> +		musb->phy =3D devm_phy_get(dev, musb->phy_label);
> +	}
> =20
> -	if (IS_ERR(musb->xceiv)) {
> -		status =3D PTR_ERR(musb->xceiv);
> +	if (IS_ERR(musb->xceiv) || IS_ERR(musb->phy)) {
> +		status =3D PTR_ERR(musb->xceiv) | PTR_ERR(musb->phy);
> =20
>  		if (status =3D=3D -ENXIO)
>  			return status;
> @@ -397,9 +407,10 @@ static int omap2430_musb_init(struct musb *musb)
>  	if (glue->status !=3D OMAP_MUSB_UNKNOWN)
>  		omap_musb_set_mailbox(glue);
> =20
> -	usb_phy_init(musb->xceiv);
> +	phy_init(musb->phy);
> =20
>  	pm_runtime_put_noidle(musb->controller);
> +	phy_pm_runtime_put(musb->phy);

see, weird unbalanced calls :-)

Make it all explicit:

phy_pm_runtime_get_sync(phy);
phy_init(phy);
phy_pm_runtime_put(phy);

--=20
balbi

--GGxZz/e2pmGePzrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCyXAAoJEIaOsuA1yqREkTgQAJs8UQWdjEbA5JMjG6j/OFYm
UXh/6pVBr4twHMsSYNPdBftkTZIZjMMGNUHukMG5OzbMAcMJuCGFCc4j25IVVyQJ
bo4G5uF1stOzSQ8oJWL3QY7iOsW0l6LiCWDp1npuEowoo8etqCU+bcpBz2YUkixP
WDMcJBzsDKBpIse6GB026wCyfYXD/O/D7zYczzP3/KIrG+hTs7tkwnEs1siCC6Al
xKUJ6F3M6W4AdeQXCUspqiEoPVouMDMkNE5wLPLmeRcLeSdvOB7VWTcaYi1OmldJ
Chfb3sp3mGO0hvt2jvilK7eo6Q3t1P4ZGZ9KXOVTRGIx8OnEBq3yRxch2H7XCAZQ
+KOM54XYRphvGMqj3X26BjOcvoXERaWH+frgLOSqReVaLHbSbvproZaBjcE1SbD3
ZUX871Md4eZy2Wi6AfctS8zA4DZNkVPNIafZbbAfdvfOCJzUowTS6VIEPKVq9cDv
OsVcjvVSVaKXJKPmzC+7liPvfq2VFPpG729vLR99nx9yAz6eGUCu4UZ8vZIh41vK
SHBoWiHgMGjl7heEOqhX0I/2YUoch3PdFPnjFppcudspIThOYn792zslDb2kWg56
kTHNxzHTzUf8C4jVO+GLLdxRxIGF0oc1DCADAZ4LzXHl0hjFCCDSWe0XklQBBT8p
hMtBM5pukV71ARH/i8du
=hZmk
-----END PGP SIGNATURE-----

--GGxZz/e2pmGePzrA--
