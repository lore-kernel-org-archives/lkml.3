Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3KYVGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:06:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47456 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3KYVGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:06:50 -0500
Date: Mon, 25 Nov 2013 15:06:14 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <mina86@mina86.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/5] usb: dwc3: implement gadget's quirk
 ep_out_align_size
Message-ID: <20131125210614.GP18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384290286-21432-6-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyi3v9V9xafcEDI/"
Content-Disposition: inline
In-Reply-To: <1384290286-21432-6-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oyi3v9V9xafcEDI/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 12, 2013 at 01:04:46PM -0800, David Cohen wrote:
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 5452c0fce360..7c2d36f6ad4b 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1130,6 +1130,14 @@ static int dwc3_gadget_ep_queue(struct usb_ep *ep,=
 struct usb_request *request,
>  	dev_vdbg(dwc->dev, "queing request %p to %s length %d\n",
>  			request, ep->name, request->length);
> =20
> +	/* If ep out, roundup request->length to epout maxpacketsize */
> +	if (!(dep->number & 1)) {

we have a direction field in the dep structure, please use that.

> +		unsigned int aligned =3D roundup(request->length,
> +					       ep->desc->wMaxPacketSize);
> +		req->pad =3D aligned - request->length;
> +		request->length =3D aligned;

this is quite dangerous. You really don't know the size that gadget
driver allocated. What if we're using SLOB and gadget driver allocated
exactly 31 bytes (think MSC's CBW) ? Then you change request->length to
512-bytes (or 1024 if USB SS), and host happens to be buggy (or
exploited somehow) and sends more than 31-bytes ? You told dwc3 you
could receive more than 31-bytes even though you don't know what follows
your 31-byte buffer.

This is why I have been saying that gadget driver *must* be the one
hadnling this issue based on the quirk flag.

--=20
balbi

--oyi3v9V9xafcEDI/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk7vGAAoJEIaOsuA1yqREhb4P/16XUhYar3KJUpJ0hi//mnQL
d1NX3CXfafzJvB65tC9KvNzYRdzgNbpW86HfDltVZjskXHB3F3nszJ4Hg3I1YoXz
DwH03A8sM5wfRP8VPyi+ZwJcBVDbnrdQ+B3yq82HDFzlhEQrgisW6tqHAzCPveWM
dXSPisrmmSiMtc59GXWFMFc0SXrrA5wMMd2BSCp4k3gxILZUzYLhHzKFA1E7c5ua
y89SAf1w6r7RzZj5dPkXFr5DIB8P6Soo9hq5n2gUzZxz7vl0e1hWLkTLIp1DExym
5OXBdnn4iav9Af1/fzULIYX3R/6/8pFVCZw3J7CKOBa9AtboQZwLlgMcYfoAImmV
ALDopx7GPC2qj4/LnG/i4N1Pw7s39MqwHvEmUnEZ1wTPPOuv2kYzzhrFkqmR7fcb
aQr59dVvLhc549lWqiuLna+uoAOt7sg9vwvJk3ssYzfhTlfTmGzfSiB8SvRibhXR
Gve8SgJgHqEra3nQr1tqYB3ExO/4/KyBSqbxqjBkaj+e3F4q7VhPB8gjEp5MN8q1
DPAkNU6+X8yGTUaT1dArx7ojQF0EGY5fSFYGT9WQuHQzq6+mzi9+ARfJIiJv29ll
cgCTPOBY8vrJMysQALHm3ZEIiRI2jnXf3y03ui1PDNNPXEEUmraZ0nqWB550sDRM
dy+gnKuynGdydMvMs3rx
=w04U
-----END PGP SIGNATURE-----

--oyi3v9V9xafcEDI/--
