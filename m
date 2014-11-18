Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaKRAaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:30:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39008 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaKRAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:30:10 -0500
Date: Mon, 17 Nov 2014 18:30:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141118003028.GA11280@saruman>
Reply-To: <balbi@ti.com>
References: <546A829A.8030106@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <546A829A.8030106@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 17, 2014 at 06:19:54PM -0500, Jorge Ramirez-Ortiz wrote:
> Hi,
>=20
> This patch adds USB3 support to the legacy gadget printer driver.
> Applies cleanly on fc14f9c Linux 3.18-rc5.
>=20
> Please could it be considered for inclusion?

sure, if you send it properly (see Documentation/SubmittingPatches),
provide logs of your tests with a recent kernel (v3.18-rc5 would be just
awesome) and Cc myself on your resubmission.

> diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/leg=
acy/printer.c
> index 6474081..625d905 100644
> --- a/drivers/usb/gadget/legacy/printer.c
> +++ b/drivers/usb/gadget/legacy/printer.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 2003-2005 David Brownell
>   * Copyright (C) 2006 Craig W. Nadler
> + * Copyright (C) 2014 Linaro.org

I don't think the minimal change below constitutes enough to merit the
copyright. If your lawyers tell you otherwise, let me know.

Greg, what's Linux Foundation's lawyers take on this ?

> @@ -208,6 +209,43 @@ static struct usb_descriptor_header *hs_printer_func=
tion[] =3D {
>         NULL
>  };
> =20
> +/*
> + * Added endpoint descriptors for 3.0 devices
> + */
> +
> +static struct usb_endpoint_descriptor ss_ep_in_desc =3D {
> +       .bLength =3D              USB_DT_ENDPOINT_SIZE,
> +       .bDescriptorType =3D      USB_DT_ENDPOINT,
> +       .bmAttributes =3D         USB_ENDPOINT_XFER_BULK,
> +       .wMaxPacketSize =3D       cpu_to_le16(1024),
> +};
> +
> +struct usb_ss_ep_comp_descriptor ss_ep_in_comp_desc =3D {
> +       .bLength =3D              sizeof(ss_ep_in_comp_desc),
> +       .bDescriptorType =3D      USB_DT_SS_ENDPOINT_COMP,
> +};
> +
> +static struct usb_endpoint_descriptor ss_ep_out_desc =3D {
> +       .bLength =3D              USB_DT_ENDPOINT_SIZE,
> +       .bDescriptorType =3D      USB_DT_ENDPOINT,
> +       .bmAttributes =3D         USB_ENDPOINT_XFER_BULK,
> +       .wMaxPacketSize =3D       cpu_to_le16(1024),
> +};
> +
> +struct usb_ss_ep_comp_descriptor ss_ep_out_comp_desc =3D {
> +       .bLength =3D              sizeof(ss_ep_out_comp_desc),
> +       .bDescriptorType =3D      USB_DT_SS_ENDPOINT_COMP,
> +};
> +
> +static struct usb_descriptor_header *ss_printer_function[] =3D {
> +       (struct usb_descriptor_header *) &intf_desc,
> +       (struct usb_descriptor_header *) &ss_ep_in_desc,
> +       (struct usb_descriptor_header *) &ss_ep_in_comp_desc,
> +       (struct usb_descriptor_header *) &ss_ep_out_desc,
> +       (struct usb_descriptor_header *) &ss_ep_out_comp_desc,
> +       NULL
> +};
> +
>  static struct usb_otg_descriptor otg_descriptor =3D {
>         .bLength =3D              sizeof otg_descriptor,
>         .bDescriptorType =3D      USB_DT_OTG,
> @@ -220,7 +258,20 @@ static const struct usb_descriptor_header *otg_desc[=
] =3D {
>  };
> =20
>  /* maxpacket and other transfer characteristics vary by speed. */
> -#define ep_desc(g, hs, fs) (((g)->speed =3D=3D USB_SPEED_HIGH)?(hs):(fs))
> +static inline struct usb_endpoint_descriptor *ep_desc(struct usb_gadget =
*gadget,
> +                                       struct usb_endpoint_descriptor *f=
s,
> +                                       struct usb_endpoint_descriptor *h=
s,
> +                                       struct usb_endpoint_descriptor *s=
s)
> +{
> +       struct usb_endpoint_descriptor *d =3D fs;
> +
> +       if (gadget->speed =3D=3D USB_SPEED_SUPER)
> +               d =3D ss;
> +       else if (gadget->speed =3D=3D USB_SPEED_HIGH)
> +               d =3D hs;

what happened to good old switch ?

> +       return d;
> +}
> =20
>  /*----------------------------------------------------------------------=
---*/
> =20
> @@ -793,11 +844,12 @@ set_printer_interface(struct printer_dev *dev)
>  {
>         int                     result =3D 0;
> =20
> -       dev->in_ep->desc =3D ep_desc(dev->gadget, &hs_ep_in_desc, &fs_ep_=
in_desc);
> +       dev->in_ep->desc =3D ep_desc(dev->gadget, &fs_ep_in_desc, &hs_ep_=
in_desc,
> +                                                               &ss_ep_in=
_desc);

Fix your indentation.

>         dev->in_ep->driver_data =3D dev;
> =20
> -       dev->out_ep->desc =3D ep_desc(dev->gadget, &hs_ep_out_desc,
> -                                   &fs_ep_out_desc);
> +       dev->out_ep->desc =3D ep_desc(dev->gadget, &fs_ep_out_desc,
> +                                       &hs_ep_out_desc, &ss_ep_out_desc);
>         dev->out_ep->driver_data =3D dev;
> =20
>         result =3D usb_ep_enable(dev->in_ep);
> @@ -1016,9 +1068,11 @@ autoconf_fail:
>         /* assumes that all endpoints are dual-speed */
>         hs_ep_in_desc.bEndpointAddress =3D fs_ep_in_desc.bEndpointAddress;
>         hs_ep_out_desc.bEndpointAddress =3D fs_ep_out_desc.bEndpointAddre=
ss;
> +       ss_ep_in_desc.bEndpointAddress =3D fs_ep_in_desc.bEndpointAddress;
> +       ss_ep_out_desc.bEndpointAddress =3D fs_ep_out_desc.bEndpointAddre=
ss;
> =20
>         ret =3D usb_assign_descriptors(f, fs_printer_function,
> -                       hs_printer_function, NULL);
> +                                    hs_printer_function, ss_printer_func=
tion);

why do you change indentation when adding just one extra argument ?

--=20
balbi

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUapMkAAoJEIaOsuA1yqREYW4QAJNcTEYMlb5UbzKjLqyv5QPs
9wXVYTSePcNyjV+2Rc7eE0qKAJ+KQkcmM28pCBfB8IvO9mTjeY2bIguf1kBoDNXL
EMSL2muuYe+8gLr++Y9pUF1Yjo/3e2cJl0JZ8LR4cAIWdvlMsfbgOewP5EkTT4xJ
EujVLDr4egUKC7UWipksRgb8fT29UXnKV5r/ZLqeggsDa8tAvlh/dO9rpZcOJQh6
feH+F0DFEJwU3d+PQnhH4TdcKzwbMcqt+1nJt3J7YyJtR8C+F+Ur6RRpIiqH9MxM
Ty2j05tH/InMm1jjduf8Jo/maYHdU0BfoYmEIpFjTxqVOxZHMKZMO9C7N5LK2xtG
Rc6CyLUcsz5oV68OCARVeLYjEPSoiQulkIP80wT9XL/5nQijAocB+QAKtMsOWrnA
CpROeQRAm8CVNkFHYWGww8iuR9U1OJ1XgkUDz2EtZX6bNGzcPhZua8dq7WYvCURe
dSUVuZulzd4VqOjUwkahZ4Ftqmm2nGusBb/latyn/86G6hZBfTKahvMBxRr44f8u
Uwnn16Z7nWWi/U/+Ub+kOttPXj2GPtadN+WOlDdKmD2uT0wRuRLO6hi2lSW75uld
RUpcf8KuDZArzZOPNHKvjCwA246e7c1bo+YVDferv2CMOm6+GdPq523SmR6E9OaK
89A48zghPlZrL+2F2yMV
=eLX9
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
