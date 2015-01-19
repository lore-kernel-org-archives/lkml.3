Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbbASOwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:52:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbASOv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:51:59 -0500
Date: Mon, 19 Jan 2015 08:50:50 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH v2 3/5] usb: dwc3: Add quirk for Synopsis device
 disconnection errata
Message-ID: <20150119145050.GF20386@saruman>
Reply-To: <balbi@ti.com>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1421654209-6486-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExXT7PjY8AI4Hyfa"
Content-Disposition: inline
In-Reply-To: <1421654209-6486-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ExXT7PjY8AI4Hyfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 19, 2015 at 03:56:47PM +0800, Sneeker Yeh wrote:
> Synopsis Designware USB3 IP earlier than v3.00a which is configured in si=
licon
> with DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1, would need a specific quirk t=
o prevent
> xhci host controller from dying when device is disconnected.
>=20
> Since DWC_USB3_SUSPEND_ON_DISCONNECT_EN is an IP configuration whose state
> cannot be checked from software in runtime, it has to be enabled via plat=
form
> data or device tree.
>=20
> Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
> ---
>  Documentation/devicetree/bindings/usb/dwc3.txt |   17 +++++++++++++++++
>  drivers/usb/dwc3/core.c                        |    6 ++++++
>  drivers/usb/dwc3/core.h                        |    1 +
>  drivers/usb/dwc3/host.c                        |    4 ++++
>  drivers/usb/dwc3/platform_data.h               |    1 +
>  5 files changed, 29 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentati=
on/devicetree/bindings/usb/dwc3.txt
> index cd7f045..1b78b29 100644
> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> @@ -37,6 +37,23 @@ Optional properties:
>   - snps,is-utmi-l1-suspend: true when DWC3 asserts output signal
>  			utmi_l1_suspend_n, false when asserts utmi_sleep_n
>   - snps,hird-threshold: HIRD threshold
> + - snps,has_suspend_on_disconnect: true when IP is configured in silicon=
 with
> +			DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1, it can inject a
> +			specific quirk to prevent xhci host controller from
> +			dying when usb device is disconnected from root hub.
> +			Since DWC_USB3_SUSPEND_ON_DISCONNECT_EN is an IP
> +			configuration whose state cannot be checked from
> +			software in runtime, it has to be enabled via platform
> +			data or device tree.
> +
> +			xhci host dying symptom here is caused by that
> +			DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1
> +			configuration makes IP auto-suspended after PORTCSC is
> +			cleared when usb device detached, then an asynchronous
> +			disconnection procedure might fail using endpoint
> +			command that suspened IP won't have any response to.
> +
> +			this issue is fixed when IP version >=3D 3.00a.
> =20
>  This is usually a subnode to DWC3 glue to which it is connected.
> =20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 25ddc39..fbceab1 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -838,6 +838,9 @@ static int dwc3_probe(struct platform_device *pdev)
>  				"snps,tx_de_emphasis_quirk");
>  		of_property_read_u8(node, "snps,tx_de_emphasis",
>  				&tx_de_emphasis);
> +
> +		dwc->suspend_on_disconnect_quirk =3D of_property_read_bool(node,
> +				"snps,has_suspend_on_disconnect");
>  	} else if (pdata) {
>  		dwc->maximum_speed =3D pdata->maximum_speed;
>  		dwc->has_lpm_erratum =3D pdata->has_lpm_erratum;
> @@ -864,6 +867,9 @@ static int dwc3_probe(struct platform_device *pdev)
>  		dwc->tx_de_emphasis_quirk =3D pdata->tx_de_emphasis_quirk;
>  		if (pdata->tx_de_emphasis)
>  			tx_de_emphasis =3D pdata->tx_de_emphasis;
> +
> +		dwc->suspend_on_disconnect_quirk =3D
> +			pdata->has_suspend_on_disconnect;
>  	}
> =20
>  	/* default to superspeed if no maximum_speed passed */
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 8090249..d7458ff 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -832,6 +832,7 @@ struct dwc3 {
> =20
>  	unsigned		tx_de_emphasis_quirk:1;
>  	unsigned		tx_de_emphasis:2;
> +	unsigned		suspend_on_disconnect_quirk:1;

you're missing the comment on the structure and these should be
alphabetically sorted.

> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> index 12bfd3c..9c42074 100644
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -53,6 +53,10 @@ int dwc3_host_init(struct dwc3 *dwc)
>  	pdata.usb3_lpm_capable =3D 1;
>  #endif
> =20
> +	if ((dwc->revision < DWC3_REVISION_300A) &&
> +	    dwc->suspend_on_disconnect_quirk)
> +		pdata.delay_portcsc_clear =3D 1;
> +
>  	ret =3D platform_device_add_data(xhci, &pdata, sizeof(pdata));
>  	if (ret) {
>  		dev_err(dwc->dev, "couldn't add platform data to xHCI device\n");
> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform=
_data.h
> index a3a3b6d..69562f1 100644
> --- a/drivers/usb/dwc3/platform_data.h
> +++ b/drivers/usb/dwc3/platform_data.h
> @@ -44,4 +44,5 @@ struct dwc3_platform_data {
> =20
>  	unsigned tx_de_emphasis_quirk:1;
>  	unsigned tx_de_emphasis:2;
> +	unsigned has_suspend_on_disconnect:1;

needs a comment at the top of this structure and should sorted.

--=20
balbi

--ExXT7PjY8AI4Hyfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvRnKAAoJEIaOsuA1yqRE7EMP/2rVOXq7C1HMSV02qivbAe3X
ubhDvpPTD6z0GfuSB0uNgkCvqCIsDkOpfdK/w8+14BstW9U70SstaonDurkaqz8J
cokQRDpd7I8MXsUgNL9MhzeM0nXeLsY/kWixqXwSHPnXrZS3YCiLvl/b47VVjpBb
a551AHngvWgfSZI60EJ5oc9eEW5+okNYFTp+ZN2KTI9gmeT5tK4yXyLaw36OVfBC
fIKWbCFw4pSLHchnk1cJEnG+GOEhNkE7Yq82wsjGJB4tHL8DqWBljzPOnATnigyr
rs8VEALsETFkYr46fySZlCOpsFlA6uxLDjxIptFAW6W8tWvCH0xWRBDoYoOerTOb
68oetn9y7DCucwoJy4nsr+QQKxDz/dWzIR8X4CHBPOFoCXuU+4fIi/+c8fxs/wej
uOW+OiDDwJqfDL8OM5uueO39TR6EBhfD15bdjnw1EKu+5mPZWuzSAzbSA1xkKg+8
THNM/ZYwALk9We7AnSi0SRJ5TMQsFXTJnmVMPb4oDF4N6P7SV9GM0cjopKybkBex
L0QARDE2CzQj+M2GYV9N1zMmDi2gU1zz1otsI7wll2ZYd9ZVmNuPrPA2enJLmuNg
/Vokg5t9W6clQC0IvDT5gkxzsIwfyDNRzlqxYpXcSq72iqfiRgUltVxqwYiC9FQi
dixJwdY4/7DPYjHbmI8S
=cvzo
-----END PGP SIGNATURE-----

--ExXT7PjY8AI4Hyfa--
