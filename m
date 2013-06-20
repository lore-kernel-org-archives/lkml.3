Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3FTMMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:12:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35708 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3FTMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:12:17 -0400
Date: Thu, 20 Jun 2013 15:11:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
Message-ID: <20130620121151.GD9817@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
 <1371650753-11452-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <1371650753-11452-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 19, 2013 at 05:05:51PM +0300, Roger Quadros wrote:
> Runtime suspend the controller during bus suspend and resume it
> during bus resume. This will ensure that the USB Host power domain
> enters lower power state and does not prevent the SoC from
> endering deeper sleep states.
>=20
> Remote wakeup will come up as an interrupt while the controller
> is suspended, so tackle it carefully using a workqueue.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/ehci-omap.c |   82 ++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 82 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 16d7150..91f14f1 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -44,6 +44,8 @@
>  #include <linux/usb/hcd.h>
>  #include <linux/of.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/workqueue.h>
> +#include <linux/spinlock.h>
> =20
>  #include "ehci.h"
> =20
> @@ -69,6 +71,7 @@ static const char hcd_name[] =3D "ehci-omap";
>  struct omap_hcd {
>  	struct usb_phy *phy[OMAP3_HS_USB_PORTS]; /* one PHY for each port */
>  	int nports;
> +	struct work_struct work;
>  };
> =20
>  static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
> @@ -81,6 +84,76 @@ static inline u32 ehci_read(void __iomem *base, u32 re=
g)
>  	return __raw_readl(base + reg);
>  }
> =20
> +static void omap_ehci_work(struct work_struct *work)
> +{
> +	struct omap_hcd *omap =3D container_of(work, struct omap_hcd, work);
> +	struct ehci_hcd *ehci =3D container_of((void *) omap,
> +						struct ehci_hcd, priv);
> +	struct usb_hcd *hcd =3D ehci_to_hcd(ehci);
> +	struct device *dev =3D hcd->self.controller;
> +
> +	pm_runtime_get_sync(dev);
> +	enable_irq(hcd->irq);
> +	/*
> +	 * enable_irq() should preempt us with a pending IRQ
> +	 * so we can be sure that IRQ handler completes before
> +	 * we call pm_runtime_put_sync()
> +	 */
> +	pm_runtime_put_sync(dev);
> +}
> +
> +static irqreturn_t omap_ehci_irq(struct usb_hcd *hcd)
> +{
> +	struct omap_hcd *omap =3D (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
> +	struct device *dev =3D hcd->self.controller;
> +	irqreturn_t ret;
> +
> +	if (pm_runtime_suspended(dev)) {
> +		schedule_work(&omap->work);
> +		disable_irq_nosync(hcd->irq);
> +		ret =3D IRQ_HANDLED;

looks like this could be done as:

if (pm_runtime_suspended(dev)) {
	pm_runtime_get(dev);
	omap->flags |=3D OMAP_EHCI_IRQ_PENDING;
	disable_irq_nosync(hcd->irq);
	ret =3D IRQ_HANDLED;
}

then on your ->runtime_resume():

runtime_resume(dev)
{
	...

	if (omap->flags & OMAP_EHCI_IRQ_PENDING) {
		process_pending_irqs(omap);
		omap->flags &=3D ~OMAP_EHCI_IRQ_PENDING;
	}

	return 0;
}

or something similar

--=20
balbi

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwvGHAAoJEIaOsuA1yqREE0AQAI7N/kNpLUqEjKRAkHq/1NO9
kw9dU/x+mDSldaCyUqyns6GTes+mg529QW9IyplBnSPWp19fh5EjMGbIPx8209OC
SPxeUne7mUVrNtj38yn0bnaM/E92Qj/DZWxx/bOYDIqs9p/QK4QtWkrH31853rrz
qPOfiGpc5IpufPCCukwMTn/bxPILs7vzDrkTkkVYPQ5yn9qKxYsMdk10kq8cAuQf
Ng/flXwZAbaOBBDWgisVlhOuhIJ+4TztLTkfw/emwRpAUlV6HWHF1ZxBFZ2oqto1
TwviZ/6utE9UPuu1u90s8E5eFGivl2BmTSsuSSLYHtDvzxqL8bccVzQ5/UTgg9Q/
Mqo31xDqr2dDNJ5V9I8u/xK7z2vYE5oHNiW0dLz3K7D1Mjaz+C5Z911vDvK3cSqx
bk91qPb5n3/wm8vyAWit3AZq1VgeIoM+THI7l9Ga4VxtWzNpXuWK0/Huetbx6RRO
Wg/FuZW/aFDVw5Atw3GneNJ1CBqwPs9fv2fgGzsPyYeKltD8ethWEUL6gjxi2Xdi
j//r+njnGRCF2MwgsV1+o/R0Jz1b6LfUCoE9tVPEZuArUkvz8OPPieTbEv6d+Iz8
IWADWhfTPnXqcTKj4N21EK8OMkKll+oV1UScYiMM1oTPW+EQd1WaRgTqsXo/sNDi
1IlynUe3KSULNiNJGiV8
=oiR5
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
