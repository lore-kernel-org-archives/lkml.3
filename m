Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3CEPLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:11:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56292 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CEPLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:11:30 -0500
Date: Tue, 5 Mar 2013 17:11:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>,
        <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: dwc3: dwc3-omap: set dma_mask for dwc3 inorder
 for host mode to work
Message-ID: <20130305151104.GJ12123@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
 <1362493320-13913-2-git-send-email-kishon@ti.com>
 <20130305145458.GF12123@arwen.pp.htv.fi>
 <51360856.8030306@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kr14OxHsRwZHHqxS"
Content-Disposition: inline
In-Reply-To: <51360856.8030306@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kr14OxHsRwZHHqxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 08:29:34PM +0530, kishon wrote:
> Hi,
>=20
> On Tuesday 05 March 2013 08:24 PM, Felipe Balbi wrote:
> >On Tue, Mar 05, 2013 at 07:51:57PM +0530, Kishon Vijay Abraham I wrote:
> >>While creating the child devices, *of_platform_populate* sets only
> >>coherent_dma_mask but USBHCD sets *uses_dma* (determines whether the
> >>controller is DMA'able) based on dma_mask. So If we haven't explicitly =
set
> >>dma_mask, the HCD thinks the controller is not DMA'able and the
> >>controller will fail. So explicity set dma_mask for dwc3 after
> >>*of_platform_populate*.
> >>
> >>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>---
> >>  drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >>diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> >>index 35b9673..19c6e72 100644
> >>--- a/drivers/usb/dwc3/dwc3-omap.c
> >>+++ b/drivers/usb/dwc3/dwc3-omap.c
> >>@@ -277,6 +277,14 @@ static void dwc3_omap_disable_irqs(struct dwc3_oma=
p *omap)
> >>  	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, 0x00);
> >>  }
> >>
> >>+static u64 dwc3_omap_dma_mask =3D DMA_BIT_MASK(32);
> >>+
> >>+static int dwc3_omap_set_dmamask(struct device *dev, void *c)
> >>+{
> >>+	dev->dma_mask =3D &dwc3_omap_dma_mask;
> >>+	return 0;
> >>+}
> >>+
> >>  static int dwc3_omap_probe(struct platform_device *pdev)
> >>  {
> >>  	struct device_node	*node =3D pdev->dev.of_node;
> >>@@ -381,6 +389,8 @@ static int dwc3_omap_probe(struct platform_device *=
pdev)
> >>  		return ret;
> >>  	}
> >>
> >>+	device_for_each_child(&pdev->dev, NULL, dwc3_omap_set_dmamask);
> >
> >I don't think this is correct. Child should be setting its own by
> >copying from parent. In summary I think we should add this to dwc3 core:
> >
> >dma_set_coherent_mask(&pdev->dev, pdev->dev.parent->coherent_dma_mask);
> >pdev->dev.dma_mask =3D pdev->dev.parent->dma_mask;
> >pdev->dev.dma_parms =3D pdev->dev.parent->dma_parms;
> >
> >And add the same thing to xhci-plat.c btw.
>=20
> hmm.. ok.

another thing, this means that we can remove similar code from
dwc3-pci.c and dwc3-exynos.c ;-)

--=20
balbi

--kr14OxHsRwZHHqxS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNgsIAAoJEIaOsuA1yqREIlwP/2jDPkNYP+/YPXcfkxgAcgoV
1EAxKGBm0db1OPOCWwSukjflP5GtlP0n1+5w1WHNwVwNI1qMMLw2GdhTHLmdfRVd
XATBCWWOWctA8o6+ivQcPBO/XR/jCaNWlQD+aNFShxh7io6gYpHQ0L5ZcIn4gxHl
HGjiEwDHx5l3UhKMLzqflqyo8eOQEtKSOmubhkD92zVbbCJ+mwotKl8AGY3+/TLq
AKUv8pMAjUbKyOsDWuM3EDB4jbRvXOOilYeNmY/uAtU/w7AbfeJyTzRYRMZQydJp
hPfO4EkIzLmtwthipvLd+5ZysZ4vH3PLHkV2eK6mMaJ3RLNGkaJcn8jYzNddTQCb
5sjjg5bVzMO2+B/RB0Y5wjfeFU5qQkKK4QivJNGzGrYY7PGKifMsoYXD2ONvXK4W
TaTdu4BRNJ1AJX0TCWnHazI1idMnvs+qTqFZpP3DYXfIVrtTxI/cNXZzDPVqgJFo
VJIM6rjZ5GQ6AgKR9gp+ziz2qM4uHAY8J2Ssc3xG8D10VYqNgzcqXQyupGaV5oBw
rTYmtOg/wcjC/tbPx6SNFpdmUqo0MYvi/qaKkQ5pE2y8B+zKArxF3Dk9wRsjQvTQ
nitPxxwvKvy6vJerD7SKeej8n0RELfRYpIGS21IRwDMcRU6oowrUMqhpFqwzQUxU
pFA81UqPmsj3oJAEP7Dg
=1zlL
-----END PGP SIGNATURE-----

--kr14OxHsRwZHHqxS--
