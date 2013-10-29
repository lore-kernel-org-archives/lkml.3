Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3J2Ngy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:36:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46817 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab3J2Ngx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:36:53 -0400
Date: Tue, 29 Oct 2013 08:37:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/2] usb: ffs/dwc3: pad epout buffer size when not
 aligned to maxpacketsize
Message-ID: <20131029133724.GH2776@gimli>
Reply-To: <balbi@ti.com>
References: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
 <1383009180-23236-3-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
Content-Disposition: inline
In-Reply-To: <1383009180-23236-3-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 28, 2013 at 06:13:00PM -0700, David Cohen wrote:
> DWC3 requires buffer size to be aligned to maxpacketsize of an out
> endpoint. ffs_epfile_io() needs to pad epout buffer to match above
> condition if DWC3 controller is used.
>=20
> This patch solves an specific situation but a more generic solution
> should be found.
>=20
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/gadget/f_fs.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 75e4b78..33880e6 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -27,6 +27,7 @@
>  #include <linux/usb/composite.h>
>  #include <linux/usb/functionfs.h>
> =20
> +#include "gadget_chips.h"
> =20
>  #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
> =20
> @@ -755,10 +756,12 @@ static ssize_t ffs_epfile_io(struct file *file,
>  			     char __user *buf, size_t len, int read)
>  {
>  	struct ffs_epfile *epfile =3D file->private_data;
> +	struct usb_gadget *gadget =3D epfile->ffs->gadget;
>  	struct ffs_ep *ep;
>  	char *data =3D NULL;
>  	ssize_t ret;
>  	int halt;
> +	size_t orig_len =3D len;
> =20
>  	goto first_try;
>  	do {
> @@ -794,6 +797,22 @@ first_try:
>  			goto error;
>  		}
> =20
> +		/*
> +		 * DWC3 requires buffer size to be aligned to maxpacketsize
> +		 * of an out endpoint.
> +		 * FIXME: a more generic solution might be necessary.
> +		 */

see, gadget drivers shouldn't have to know about DWC3 at all. They need
to know that current UDC has a quirk where EP OUT transactions need to
be aligned to wMaxPacketSize, so what I was expecting to see here was:

		if (test_bit(USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE, &gadget->qirks) &&
			!IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize))
			len =3D align_length(orig_len, wMaxPacketSize);


--=20
balbi

--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSb7oUAAoJEIaOsuA1yqREYmAP/ieHNCuZHt6v7yirjN4qIxbW
KdBgIeaV2TvGnl4lZRECRDF8fhH02+JzLcm3axQHZFJ4PwIJhtZ+0SY1WCdmssfH
eInm5esU8lD1zsPAItbYg2lGC8bvLOlJ5bYzcP7vpTMlRMGqUeg88NISh62Rqoz0
oN1z235BagXxBwSbNfnow+wb+gMi1t+j8RspkZueAYpWg7jG/4CzuMJ/6EWBEWvz
4AEWkUGHkOiFxvn1nvOmNfpteLr37bAcpHH9OeCb3KFU+3uygdYnccTLn/hGm+zo
AeZ6CnyeY+hFWS4rXWrdvHtucbIMsw2vh1/3XmZ/M9M9YSKSGaKRpDODibWEKha8
FzNZgqg+/kknC/3bllEa1x95VBLf3SLkC65su/Gxlu52B3NHyQDJxXod2i/08Hpm
9HpMNajvjWNxzpFkiuuuJqNiIaGGdGEgKLUx2OogwIOtyGGvPZkfDE6vgEY3LVcD
8uwLEQRQcq5aE1gqxQRhP3YNMI27PF4wyIRQaNVEAT1Mr8DNhDLWw+WscIEjhuVN
tch9qJfTw7k9BuS30yYHJ1pg+R0uv55e5XGCxCJ7C7btWbkg0tMCiVFvX2uctYyC
L9BxAreFgQU6RO02d/bIFr8RT+PtqOluNpik5epdUjgbWJsEg4F1+eQfoJ1nGB6J
1RstnPEEEFxYXVNdiWVB
=Y40H
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--
