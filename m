Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3CEOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:55:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52551 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3CEOzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:55:33 -0500
Date: Tue, 5 Mar 2013 16:54:58 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>,
        <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: dwc3: dwc3-omap: set dma_mask for dwc3 inorder
 for host mode to work
Message-ID: <20130305145458.GF12123@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
 <1362493320-13913-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline
In-Reply-To: <1362493320-13913-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 07:51:57PM +0530, Kishon Vijay Abraham I wrote:
> While creating the child devices, *of_platform_populate* sets only
> coherent_dma_mask but USBHCD sets *uses_dma* (determines whether the
> controller is DMA'able) based on dma_mask. So If we haven't explicitly set
> dma_mask, the HCD thinks the controller is not DMA'able and the
> controller will fail. So explicity set dma_mask for dwc3 after
> *of_platform_populate*.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index 35b9673..19c6e72 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -277,6 +277,14 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap =
*omap)
>  	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, 0x00);
>  }
> =20
> +static u64 dwc3_omap_dma_mask =3D DMA_BIT_MASK(32);
> +
> +static int dwc3_omap_set_dmamask(struct device *dev, void *c)
> +{
> +	dev->dma_mask =3D &dwc3_omap_dma_mask;
> +	return 0;
> +}
> +
>  static int dwc3_omap_probe(struct platform_device *pdev)
>  {
>  	struct device_node	*node =3D pdev->dev.of_node;
> @@ -381,6 +389,8 @@ static int dwc3_omap_probe(struct platform_device *pd=
ev)
>  		return ret;
>  	}
> =20
> +	device_for_each_child(&pdev->dev, NULL, dwc3_omap_set_dmamask);

I don't think this is correct. Child should be setting its own by
copying from parent. In summary I think we should add this to dwc3 core:

dma_set_coherent_mask(&pdev->dev, pdev->dev.parent->coherent_dma_mask);
pdev->dev.dma_mask =3D pdev->dev.parent->dma_mask;
pdev->dev.dma_parms =3D pdev->dev.parent->dma_parms;

And add the same thing to xhci-plat.c btw.

--=20
balbi

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNgdCAAoJEIaOsuA1yqREZtsP/RvhPw/azCkMKffPn99XgIcn
bOA9TvJiFEtWc7M7q7DbG+by3/q0WSZCU29LjfXebXRYQ+MOHK7iXb7WGs7ipjra
M37HjPFCl4jICuGcF2aCi1UXn00JfB9OoeVqZLpF19Ml7zJBZLfKZbjQf3iaHw8J
Qhg+2gQqMBujLf1dawyr5glLjntiPte6B4YnWp/qgUM58FAd98DcVUxwfVWm4ALM
umkOvrbOKZ6gyxevcJZfRdSWH1kng8CJWoW70n+MrIfhE07f0vt1/OGoBba3UEzM
yf6LBxt/Ktxx1LBwkdXuemMiZSm5TYwnJWcisfe9u4z3EOXnmxgpCii03XLu3kL6
WxAjq9DiZNg/3RoTnucCzHNmoGpiD7LmP9NCQ/5UXKwcLygYP9S+Ru/RqIQbwB3C
ZbW7CmRL5NECsHYPgIOBwOPLtMDYUbtfECt0IunZ8kKDgpWZjGacGS/7zr7MvSrW
uYHM2+9gZB8cuncKNkGXSzMZws+eTppnrqdPX3LKIS3ZGmawfKuQ4R/l+jibLqvU
aA3VuvBTYPOoV6eeayG+W4GURgy6tgtcY6lzCY0Aavz4VNSbqWpRG9qs/TFiYl9f
R1fhk9HCeTsAttt0Rfaiu0hu1qTuuO94COhhIeW9YJ3f6MpfHZTD9GfBRxmIKzH+
dMhr/ONZ5QafoeBfcv0l
=aSct
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
