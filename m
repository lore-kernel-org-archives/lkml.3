Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3KYVZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:25:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3KYVZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:25:02 -0500
Date: Mon, 25 Nov 2013 15:24:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mark Jackson <mpfj-list@newflow.co.uk>
CC: <linux-usb@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>, <jkosina@suse.cz>,
        <anatol.pomozov@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Allow MUSB DSPS to use "force host" mode
Message-ID: <20131125212415.GS18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <528F7E8F.5050807@newflow.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69FgzCUgmxT1EUzs"
Content-Disposition: inline
In-Reply-To: <528F7E8F.5050807@newflow.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--69FgzCUgmxT1EUzs
Content-Type: multipart/mixed; boundary="rYaPn2Jr/kqjcqFq"
Content-Disposition: inline


--rYaPn2Jr/kqjcqFq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 22, 2013 at 03:55:59PM +0000, Mark Jackson wrote:
> The IDDIG input pin is normally used to determine the USB mode
> (i.e. HOST or DEVICE).
>=20
> On some systems (e.g. AM335x) leaving this pin floating allows
> the USB mode to be set via software.
>=20
> This patch adds support for this via the device tree.
>=20
> Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
> ---
>  .../devicetree/bindings/usb/am33xx-usb.txt         |    2 ++
>  drivers/usb/musb/musb_dsps.c                       |   14 ++++++++++++++
>  include/linux/usb/musb.h                           |    1 +
>  3 files changed, 17 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/am33xx-usb.txt b/Docum=
entation/devicetree/bindings/usb/am33xx-usb.txt
> index 20c2ff2..560b7ff 100644
> --- a/Documentation/devicetree/bindings/usb/am33xx-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
> @@ -47,6 +47,8 @@ USB
>  - dmas: specifies the dma channels
>  - dma-names: specifies the names of the channels. Use "rxN" for receive
>    and "txN" for transmit endpoints. N specifies the endpoint number.
> +- ti,force-host: specifies that the IDDIG input be ignored and the devic=
e be
> +  put into host mode regardless.
> =20
>  The controller should have an "usb" alias numbered properly in the alias
>  node.
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 1901f6f..6439809 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -105,6 +105,7 @@ struct dsps_musb_wrapper {
>  	unsigned	otg_disable:5;
> =20
>  	/* bit positions for mode */
> +	unsigned	iddig_mux:5;
>  	unsigned	iddig:5;
>  	/* miscellaneous stuff */
>  	u8		poll_seconds;
> @@ -387,6 +388,15 @@ static int dsps_musb_init(struct musb *musb)
> =20
>  	musb->isr =3D dsps_interrupt;
> =20
> +	/* Force host mode, rather than relying on IDDIG input */
> +	if (musb->config->force_host) {
> +		val =3D dsps_readl(reg_base, wrp->mode);
> +		/* clear IDDIG bit, set IDDIG_MUX bit */
> +		val &=3D ~(1 << wrp->iddig);
> +		val |=3D (1 << wrp->iddig_mux);
> +		dsps_writel(musb->ctrl_base, wrp->mode, val);
> +	}
> +
>  	/* reset the otgdisable bit, needed for host mode to work */
>  	val =3D dsps_readl(reg_base, wrp->phy_utmi);
>  	val &=3D ~(1 << wrp->otg_disable);
> @@ -512,6 +522,9 @@ static int dsps_create_musb_pdev(struct dsps_glue *gl=
ue,
>  	pdata.power =3D get_int_prop(dn, "mentor,power") / 2;
>  	config->multipoint =3D of_property_read_bool(dn, "mentor,multipoint");
> =20
> +	if (of_property_read_bool(dn, "ti,force-host"))
> +		config->force_host =3D true;
> +
>  	ret =3D platform_device_add_data(musb, &pdata, sizeof(pdata));
>  	if (ret) {
>  		dev_err(dev, "failed to add platform_data\n");
> @@ -607,6 +620,7 @@ static const struct dsps_musb_wrapper am33xx_driver_d=
ata =3D {
>  	.mode			=3D 0xe8,
>  	.reset			=3D 0,
>  	.otg_disable		=3D 21,
> +	.iddig_mux		=3D 7,

I recently sent a patch to make this work, I'm attaching it here in case
it didn't reach mailing list.

--=20
balbi

--rYaPn2Jr/kqjcqFq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-usb-musb-dsps-implement-set_mode.diff"
Content-Transfer-Encoding: quoted-printable

=46rom 5edc4b78bbfdc5fcff2cba46c7dbeebd2efddb76 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Tue, 29 Oct 2013 12:17:16 -0500
Subject: [PATCH 1/2] usb: musb: dsps: implement ->set_mode()

this will let us support broken designs such
as AM335x EVM SK where ID pin isn't routed
anywhere on a host port.

With this we can toggle internal IDDIG signal
and make sure MUSB goes into host mode as
necessary.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 51 ++++++++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 1901f6f..ce7ec01 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -106,6 +106,7 @@ struct dsps_musb_wrapper {
=20
 	/* bit positions for mode */
 	unsigned	iddig:5;
+	unsigned	iddig_mux:5;
 	/* miscellaneous stuff */
 	u8		poll_seconds;
 };
@@ -406,6 +407,54 @@ static int dsps_musb_exit(struct musb *musb)
 	return 0;
 }
=20
+static int dsps_musb_set_mode(struct musb *musb, u8 mode)
+{
+	struct device *dev =3D musb->controller;
+	struct dsps_glue *glue =3D dev_get_drvdata(dev->parent);
+	const struct dsps_musb_wrapper *wrp =3D glue->wrp;
+	void __iomem *ctrl_base =3D musb->ctrl_base;
+	void __iomem *base =3D musb->mregs;
+	u32 reg;
+
+	reg =3D dsps_readl(base, wrp->mode);
+
+	switch (mode) {
+	case MUSB_HOST:
+		reg &=3D ~(1 << wrp->iddig);
+
+		/*
+		 * if we're setting mode to host-only or device-only, we're
+		 * going to ignore whatever the PHY sends us and just force
+		 * ID pin status by SW
+		 */
+		reg |=3D (1 << wrp->iddig_mux);
+
+		dsps_writel(base, wrp->mode, reg);
+		dsps_writel(ctrl_base, wrp->phy_utmi, 0x02);
+		break;
+	case MUSB_PERIPHERAL:
+		reg |=3D (1 << wrp->iddig);
+
+		/*
+		 * if we're setting mode to host-only or device-only, we're
+		 * going to ignore whatever the PHY sends us and just force
+		 * ID pin status by SW
+		 */
+		reg |=3D (1 << wrp->iddig_mux);
+
+		dsps_writel(base, wrp->mode, reg);
+		break;
+	case MUSB_OTG:
+		dsps_writel(base, wrp->phy_utmi, 0x02);
+		break;
+	default:
+		dev_err(glue->dev, "unsupported mode %d\n", mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct musb_platform_ops dsps_ops =3D {
 	.init		=3D dsps_musb_init,
 	.exit		=3D dsps_musb_exit,
@@ -414,6 +463,7 @@ static struct musb_platform_ops dsps_ops =3D {
 	.disable	=3D dsps_musb_disable,
=20
 	.try_idle	=3D dsps_musb_try_idle,
+	.set_mode	=3D dsps_musb_set_mode,
 };
=20
 static u64 musb_dmamask =3D DMA_BIT_MASK(32);
@@ -608,6 +658,7 @@ static const struct dsps_musb_wrapper am33xx_driver_dat=
a =3D {
 	.reset			=3D 0,
 	.otg_disable		=3D 21,
 	.iddig			=3D 8,
+	.iddig_mux		=3D 7,
 	.usb_shift		=3D 0,
 	.usb_mask		=3D 0x1ff,
 	.usb_bitmap		=3D (0x1ff << 0),
--=20
1.8.4.GIT


--rYaPn2Jr/kqjcqFq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-usb-musb-core-call-musb_platform_set_mode-during-prob.diff"
Content-Transfer-Encoding: quoted-printable

=46rom c9dfe3d2b4c3f00951839eb17835daa0c5c19d71 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Tue, 29 Oct 2013 12:17:17 -0500
Subject: [PATCH 2/2] usb: musb: core: call musb_platform_set_mode() during
 probe

This will tell glue layer which mode we want port
to be in.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/musb_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 0a43329..377ef9b 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1941,17 +1941,26 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
 	switch (musb->port_mode) {
 	case MUSB_PORT_MODE_HOST:
 		status =3D musb_host_setup(musb, plat->power);
+		if (status < 0)
+			goto fail3;
+		status =3D musb_platform_set_mode(musb, MUSB_HOST);
 		break;
 	case MUSB_PORT_MODE_GADGET:
 		status =3D musb_gadget_setup(musb);
+		if (status < 0)
+			goto fail3;
+		status =3D musb_platform_set_mode(musb, MUSB_PERIPHERAL);
 		break;
 	case MUSB_PORT_MODE_DUAL_ROLE:
 		status =3D musb_host_setup(musb, plat->power);
 		if (status < 0)
 			goto fail3;
 		status =3D musb_gadget_setup(musb);
-		if (status)
+		if (status) {
 			musb_host_cleanup(musb);
+			goto fail3;
+		}
+		status =3D musb_platform_set_mode(musb, MUSB_OTG);
 		break;
 	default:
 		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
--=20
1.8.4.GIT


--rYaPn2Jr/kqjcqFq--

--69FgzCUgmxT1EUzs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk7//AAoJEIaOsuA1yqREDxMQAJNqBnGx+yYzN5wx/ds2XvHE
eCdBmqX0huRJ5F4CFNkehWj6tnc/noriGMADNYo7Ew9UEuBAxN4H8ivrw65l0qTQ
bgAyFvczBHCyNvETWaM8GHGivyW6qVNBkHWgV+OC4ZPMtbovSxvDRqlUi72Ad50Y
eDjJsJf3bMEbMRPH5zCmlJdFN10NUgr9I1GWAw6q4fgDDzTRAjuuQhcHmmNrdBXK
K8lT8jAJNooWWiBy2PhU1JypHXcQdI+ae/49B7D1KC7V9jzzBoYebe98tV5iNsSi
fhC1VHnaGjjyJfb8VKmKmPjLDELFQa5FAtHpL1a7b2rr8up8epiCGOdppuPzGIzL
X6z56PVCLuwCgMDAS6v5PlPss3BtqWc3mielxi0jSGqgfhh29V8vccQSWB31x378
H+utt6fr/QdNQ6RxIGWe7fswXvWeqWCQS5VJvE/ql0FkbocE+XfnbbBMx/QpK+zK
vtZkBnBCbAybQT146YEF1SCyTjnDi0bOD7F/7gjGX2+bz6Q7DDCTfQ5lJ1wE/Ega
KqmrDDelOy5QYw5xqgQmhC54oFWYZGL6w01/7ReEFYVbR5IuImI5jrrvB8vH24Nz
+oXtPPL+SeMR9ZcJq7nvJ0exYoCQqjRNzDRDg8DV1bG01LQI4hIOcs1VtVMkmPyO
DBSwEN3/C9VpLaBhMasB
=SDoM
-----END PGP SIGNATURE-----

--69FgzCUgmxT1EUzs--
