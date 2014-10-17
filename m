Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaJQOmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:42:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36765 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaJQOmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:42:17 -0400
Date: Fri, 17 Oct 2014 09:41:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/16] usb: dwc3: add quirks support to be compatible
 for kinds of SoCs
Message-ID: <20141017144144.GA26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-6-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-6-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Fri, Oct 17, 2014 at 04:53:30PM +0800, Huang Rui wrote:
> This patch adds a quirks flag at dwc3 structure, and SoCs platform vendor=
 is
> able to define this flag in platform data at bus glue layer. Then do some
> independent behaviors at dwc3 core level.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 2 ++
>  drivers/usb/dwc3/core.h          | 3 +++
>  drivers/usb/dwc3/dwc3-pci.c      | 9 +++++++++
>  drivers/usb/dwc3/platform_data.h | 2 ++
>  4 files changed, 16 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index ddac372..50c0eae 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -710,6 +710,8 @@ static int dwc3_probe(struct platform_device *pdev)
> =20
>  		dwc->needs_fifo_resize =3D pdata->tx_fifo_resize;
>  		dwc->dr_mode =3D pdata->dr_mode;
> +
> +		dwc->quirks =3D pdata->quirks;
>  	}
> =20
>  	/* default to superspeed if no maximum_speed passed */
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index f6ee623..cfe0d57 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -636,6 +636,7 @@ struct dwc3_scratchpad_array {
>   * @u1u2: only used on revisions <1.83a for workaround
>   * @maximum_speed: maximum speed requested (mainly for testing purposes)
>   * @revision: revision register contents
> + * @quirks: represents different SOCs hardware work-arounds and quirks
>   * @dr_mode: requested mode of operation
>   * @usb2_phy: pointer to USB2 PHY
>   * @usb3_phy: pointer to USB3 PHY
> @@ -740,6 +741,8 @@ struct dwc3 {
>  #define DWC3_REVISION_270A	0x5533270a
>  #define DWC3_REVISION_280A	0x5533280a
> =20
> +	u32			quirks;
> +
>  	enum dwc3_ep0_next	ep0_next_event;
>  	enum dwc3_ep0_state	ep0state;
>  	enum dwc3_link_state	link_state;
> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> index 3806547..18569a4 100644
> --- a/drivers/usb/dwc3/dwc3-pci.c
> +++ b/drivers/usb/dwc3/dwc3-pci.c
> @@ -25,6 +25,8 @@
>  #include <linux/usb/otg.h>
>  #include <linux/usb/usb_phy_generic.h>
> =20
> +#include "platform_data.h"
> +
>  /* FIXME define these in <linux/pci_ids.h> */
>  #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
>  #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
> @@ -103,6 +105,9 @@ static int dwc3_pci_probe(struct pci_dev *pci,
>  	struct dwc3_pci		*glue;
>  	int			ret;
>  	struct device		*dev =3D &pci->dev;
> +	struct dwc3_platform_data dwc3_pdata;
> +
> +	memset(&dwc3_pdata, 0x00, sizeof(dwc3_pdata));
> =20
>  	glue =3D devm_kzalloc(dev, sizeof(*glue), GFP_KERNEL);
>  	if (!glue)
> @@ -149,6 +154,10 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> =20
>  	pci_set_drvdata(pci, glue);
> =20
> +	ret =3D platform_device_add_data(dwc3, &dwc3_pdata, sizeof(dwc3_pdata));
> +	if (ret)
> +		goto err3;
> +
>  	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
> =20
>  	dwc3->dev.dma_mask =3D dev->dma_mask;
> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform=
_data.h
> index 7db34f0..1d3d65f 100644
> --- a/drivers/usb/dwc3/platform_data.h
> +++ b/drivers/usb/dwc3/platform_data.h
> @@ -24,4 +24,6 @@ struct dwc3_platform_data {
>  	enum usb_device_speed maximum_speed;
>  	enum usb_dr_mode dr_mode;
>  	bool tx_fifo_resize;
> +
> +	u32     quirks;

I prefer to have one-bit fields like we already have for delayed_status,
ep0_bounced, ep0_expect_in, and so on. That makes it easier to support
the same quirks through devicetree as well.

--=20
balbi

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQSqoAAoJEIaOsuA1yqRE6t4QALGTAP7LppLdLzBZbi/BmWln
qJJ2sxuoZvcih0i3aAaefjEIWZrwQESh+swEleJeBKRdywT8zBlOc8VtP38dqd7t
ky/hDhpK4os/FOuh6MSMaVP0fjRf0wEP/5f4K038eD33YRQypXcs6zXX7HfHbl8i
gfLOmjZSWH75g3rXe2PFuZaqmxu2873ZbCI5wbagVGUQgTPRetJallnQxMq3juSv
KU6wYsJNpVJzZh2IeUoGhP5cetabG9HjBwNYwEAplF1isD0G0ddxDJcxTWBxRxfK
q/n/QSaILSdOsWl8/L4wKPbm8/Sp8v7DAj/iP0IXlMlCW25DEcir0xlDuMDBTbRq
8aPXZVWyYooQUIMc7lm2GkeO7DSQpcfLwNPdNY3gLFMtA3riDSBa2TrNi/l0g+K3
ATFv2VLSOv1wexpqAT3blbU7ijiKMD2ojYxy5ZWLvn5xdzTJ67P/dCnHoBxRfl0c
XA2tJv6WqDdHDyYoxE3XNshHsYcT9VAiJsiBGIgJj9Np1J1Y1gxcBDl3I31NGhQI
qAabByJRgyN3D4bM5gRtIXuvd408dWK/1e0GRM20OYR/MuDSAz721SxGkTcL6tnz
CvmuVzAp+hPKNdN3w82ZKkyMZzWwjF6j2H2i6YVS2dydhTNPq2I3efH466Dri88l
SEFly+Z5ailZJTL5DiyH
=TZ1o
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
