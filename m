Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbaKTTmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:42:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52973 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbaKTTmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:42:16 -0500
Date: Thu, 20 Nov 2014 13:42:31 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: add USB3 support to the printer driver
Message-ID: <20141120194231.GD23217@saruman>
Reply-To: <balbi@ti.com>
References: <1416341514-28499-1-git-send-email-jorge.ramirez-ortiz@linaro.org>
 <1416341514-28499-2-git-send-email-jorge.ramirez-ortiz@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <1416341514-28499-2-git-send-email-jorge.ramirez-ortiz@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 03:11:54PM -0500, Jorge Ramirez-Ortiz wrote:
> Add SS descriptors to support the capabilities provided by USB3 controller
> drivers; unit tests run using a PLX 3380 [max transfer speed measured of =
1Gbps]
>=20
> This driver shall fallback to lower operating modes when the higher ones =
are
> not available.
>=20
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
> ---
>  drivers/usb/gadget/legacy/printer.c | 65 +++++++++++++++++++++++++++++++=
++----
>  1 file changed, 59 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/leg=
acy/printer.c
> index 6474081..456730b 100644
> --- a/drivers/usb/gadget/legacy/printer.c
> +++ b/drivers/usb/gadget/legacy/printer.c
> @@ -208,6 +208,43 @@ static struct usb_descriptor_header *hs_printer_func=
tion[] =3D {
>  	NULL
>  };
> =20
> +/*
> + * Added endpoint descriptors for 3.0 devices
> + */
> +
> +static struct usb_endpoint_descriptor ss_ep_in_desc =3D {
> +	.bLength =3D              USB_DT_ENDPOINT_SIZE,
> +	.bDescriptorType =3D      USB_DT_ENDPOINT,
> +	.bmAttributes =3D         USB_ENDPOINT_XFER_BULK,
> +	.wMaxPacketSize =3D       cpu_to_le16(1024),
> +};
> +
> +struct usb_ss_ep_comp_descriptor ss_ep_in_comp_desc =3D {
> +	.bLength =3D              sizeof(ss_ep_in_comp_desc),
> +	.bDescriptorType =3D      USB_DT_SS_ENDPOINT_COMP,
> +};
> +
> +static struct usb_endpoint_descriptor ss_ep_out_desc =3D {
> +	.bLength =3D              USB_DT_ENDPOINT_SIZE,
> +	.bDescriptorType =3D      USB_DT_ENDPOINT,
> +	.bmAttributes =3D         USB_ENDPOINT_XFER_BULK,
> +	.wMaxPacketSize =3D       cpu_to_le16(1024),
> +};
> +
> +struct usb_ss_ep_comp_descriptor ss_ep_out_comp_desc =3D {
> +	.bLength =3D              sizeof(ss_ep_out_comp_desc),
> +	.bDescriptorType =3D      USB_DT_SS_ENDPOINT_COMP,
> +};
> +
> +static struct usb_descriptor_header *ss_printer_function[] =3D {
> +	(struct usb_descriptor_header *) &intf_desc,
> +	(struct usb_descriptor_header *) &ss_ep_in_desc,
> +	(struct usb_descriptor_header *) &ss_ep_in_comp_desc,
> +	(struct usb_descriptor_header *) &ss_ep_out_desc,
> +	(struct usb_descriptor_header *) &ss_ep_out_comp_desc,
> +	NULL
> +};
> +
>  static struct usb_otg_descriptor otg_descriptor =3D {
>  	.bLength =3D              sizeof otg_descriptor,
>  	.bDescriptorType =3D      USB_DT_OTG,
> @@ -220,7 +257,20 @@ static const struct usb_descriptor_header *otg_desc[=
] =3D {
>  };
> =20
>  /* maxpacket and other transfer characteristics vary by speed. */
> -#define ep_desc(g, hs, fs) (((g)->speed =3D=3D USB_SPEED_HIGH)?(hs):(fs))
> +static inline struct usb_endpoint_descriptor *ep_desc(struct usb_gadget =
*gadget,
> +					struct usb_endpoint_descriptor *fs,
> +					struct usb_endpoint_descriptor *hs,
> +					struct usb_endpoint_descriptor *ss)
> +{
> +	switch(gadget->speed) {
             ^^
	     missing space here. I'll fix it, but next time run your
	     patches through scripts/checkpatch.pl

--=20
balbi

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbkQnAAoJEIaOsuA1yqRE3V4P/0H2zuy8lGHSGRn5Ud2IIOvS
6ngcgqoqsv6jqBFuB1lXfoku2VFgl4Z4ui6UtRr8TxE6ZkcKDrIIB1rKVe4FIXCu
46ilyd2WuDKEyhNNROoNzhn8Lstey+20k0mr8vbkZ8NHSh+umaE4z6v+3Ax94vQt
FbtTCgV3ganfjiffVYUrMTh6qZS1sLjJONUfqXGEsmAdwiEL0Mp0kt0fEXNY4z35
mYL1Znms/pIvVVEp6zRsoh65RXvMyilpICA4T5Qy140UWaYKzl5wyrhO1VSYOEUl
ESFLicg9eSWLMbvIYSCdVxsvu7NKoZUULxrXq+8br4Si1qoruqITtWrsZg8ZlwNS
0PSSMvzvU2e4Eouf1d4Pxm+lwJvEKgLr2gvy2/Qe8eXepUbXOSH3fjfQcmoY51SL
9EtdCO1LQaITOfzcD+vFpP5jTDZ/zs9gDXt6xJNRxZF4ekGwrEw+xeRrtLtzTJ+8
IbXtRxXcxctjaaMIveUFuhQ8Lc2siRdgHbpW90g+yEZ62GgJC3JwoLyHwKQ2bmci
k5PIg6Qdpf61tJBQb0kyOZDx7IvSZn+uSrRxacn844CzxR4ZQi3O4o0MSFyq2SI0
sc8ckMJTWzDXTVw1rEadEho+r/wvzCUHyg9qF6L3PeiNjhCkXGLHxP8szTc/P2XD
nryJkfRK6F5ggCz9D1m9
=YvZz
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
