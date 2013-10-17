Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3JQQiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:38:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40937 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3JQQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:38:50 -0400
Date: Thu, 17 Oct 2013 11:38:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY's
Message-ID: <20131017163828.GH11611@gimli>
Reply-To: <balbi@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
 <1381866857-3861-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Content-Disposition: inline
In-Reply-To: <1381866857-3861-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pMCBjikF2xGw87uL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 16, 2013 at 01:24:11AM +0530, Kishon Vijay Abraham I wrote:
> There can be systems which does not have a external usb_phy, so get
> usb_phy only if dt data indicates the presence of PHY in the case of dt b=
oot or
> if platform_data indicates the presence of PHY. Also remove checking if
> return value is -ENXIO since it's now changed to always enable usb_phy la=
yer.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

I'm fine with this patch, but one comment below:

> @@ -387,16 +388,49 @@ static int dwc3_probe(struct platform_device *pdev)
>  	if (node) {
>  		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> =20
> -		dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> -		dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> +		count =3D of_count_phandle_with_args(node, "usb-phy", NULL);
> +		switch (count) {
> +		case 2:
> +			dwc->usb3_phy =3D devm_usb_get_phy_by_phandle(dev,
> +				"usb-phy", 1);
> +			if (IS_ERR(dwc->usb3_phy)) {
> +				dev_err(dev, "usb3 phy not found\n");
> +				return PTR_ERR(dwc->usb3_phy);
> +			}
> +		case 1:
> +			dwc->usb2_phy =3D devm_usb_get_phy_by_phandle(dev,
> +				"usb-phy", 0);
> +			if (IS_ERR(dwc->usb2_phy)) {
> +				dev_err(dev, "usb2 phy not found\n");
> +				return PTR_ERR(dwc->usb2_phy);
> +			}
> +			break;
> +		default:
> +			dev_err(dev, "usb phy nodes not configured\n");
> +		}
> =20
>  		dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-resize=
");
>  		dwc->dr_mode =3D of_usb_get_dr_mode(node);
>  	} else if (pdata) {
>  		dwc->maximum_speed =3D pdata->maximum_speed;
> =20
> -		dwc->usb2_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -		dwc->usb3_phy =3D devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> +		if (pdata->usb2_phy) {
> +			dwc->usb2_phy =3D devm_usb_get_phy(dev,
> +				USB_PHY_TYPE_USB2);
> +			if (IS_ERR(dwc->usb2_phy)) {
> +				dev_err(dev, "usb2 phy not found\n");
> +				return PTR_ERR(dwc->usb2_phy);
> +			}
> +		}
> +
> +		if (pdata->usb3_phy) {
> +			dwc->usb3_phy =3D devm_usb_get_phy(dev,
> +				USB_PHY_TYPE_USB3);
> +			if (IS_ERR(dwc->usb3_phy)) {
> +				dev_err(dev, "usb3 phy not found\n");
> +				return PTR_ERR(dwc->usb3_phy);
> +			}
> +		}
> =20
>  		dwc->needs_fifo_resize =3D pdata->tx_fifo_resize;
>  		dwc->dr_mode =3D pdata->dr_mode;
> @@ -409,36 +443,6 @@ static int dwc3_probe(struct platform_device *pdev)
>  	if (dwc->maximum_speed =3D=3D USB_SPEED_UNKNOWN)
>  		dwc->maximum_speed =3D USB_SPEED_SUPER;
> =20
> -	if (IS_ERR(dwc->usb2_phy)) {
> -		ret =3D PTR_ERR(dwc->usb2_phy);
> -
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret =3D=3D -ENXIO)
> -			return ret;
> -
> -		dev_err(dev, "no usb2 phy configured\n");
> -		return -EPROBE_DEFER;
> -	}
> -
> -	if (IS_ERR(dwc->usb3_phy)) {
> -		ret =3D PTR_ERR(dwc->usb3_phy);
> -
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret =3D=3D -ENXIO)
> -			return ret;
> -
> -		dev_err(dev, "no usb3 phy configured\n");
> -		return -EPROBE_DEFER;
> -	}

the idea for doing the error checking here was actually to avoid
duplicating it in all previous cases, as you did. Please keep the error
checking here and you're good to go.

> -
>  	dwc->xhci_resources[0].start =3D res->start;
>  	dwc->xhci_resources[0].end =3D dwc->xhci_resources[0].start +
>  					DWC3_XHCI_REGS_END;
> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform=
_data.h
> index 7db34f0..49ffa6d 100644
> --- a/drivers/usb/dwc3/platform_data.h
> +++ b/drivers/usb/dwc3/platform_data.h
> @@ -24,4 +24,6 @@ struct dwc3_platform_data {
>  	enum usb_device_speed maximum_speed;
>  	enum usb_dr_mode dr_mode;
>  	bool tx_fifo_resize;
> +	bool usb2_phy;
> +	bool usb3_phy;

This would look better as a quirks flag, then we could:

unsigned long quirks;
#define DWC3_QUIRK_NO_USB3_PHY	BIT(0)
#define DWC3_QUIRK_NO_USB2_PHY	BIT(1)

=2E..

if (!test_bit(DWC3_QUIRK_NO_USB3_PHY), &dwc->quirks &&
	dwc->has_usb3_phy) {
	grab_usb3_phy();
}

cheers

--=20
balbi

--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSYBKDAAoJEIaOsuA1yqREpSAQAK58qSjzBkKsgfkFlv8ryg1E
39FEmmRPE0Md5D62NrdBZsG1Rxg6eNkw5rMOWa8V5/6WG2khKQSPXyFpxIcIZZrv
yEDWNnUg80PSPqThorGPvxhLrf01aOSEs+fXBM1/oXG3Bkb4K59f7xWIMCITfdEu
55ZF4/sTKA6QrHKTDhigrbpXiTunSqKUaOhoUVHYvHcl2pfbx9V46vXS3Gd2azh8
elRr3QnKuDNGbpMCCco4G69+81uXFKCrHVbQ1GHrT0CtnEYWqpWqW1ryvknqlrgy
IQdZPLWYffudNq1nohbADxwhjQLfsMdubfW5Ai292Z8bPiGW/MCLOlXIHIJ2yJWR
CSf/PcttvHgIISABjzvRgBF0grS8U5+bDwCeZOysihWvbcUpcwYwFcx0ZPUo4GoY
3AXcY21FD6k82V/U+1ojRWq1++Q75j3SqzneIMsDay/W25nqO3Zi9Xz+lImdLgNm
F8snr0kVyYD8epH6oWKLP6uQH+V/vVCYqP2DGSzW6n6NIDfva1zj5gelFWsTgvgL
McetN7YNlTgB/YiuqiXXpK8oq9uRaUq/FiqWXnNsxFEBqcCIysVbgWZDndrJ8OXx
5pmFhEc8VOaxbH3+Lv7cbNk4Sg7mnHyBKPZcvr1FSxsYztJFE5W7YYcMkpkcU2+Y
Hx5OfP23gsQqmBX/jzaW
=286k
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--
