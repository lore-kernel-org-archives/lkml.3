Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaLWQZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:25:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56519 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128AbaLWQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:25:01 -0500
Date: Tue, 23 Dec 2014 10:24:19 -0600
From: Felipe Balbi <balbi@ti.com>
To: Songjun Wu <songjun.wu@atmel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: gadget: udc: atmel: fix possible oops when
 unloading module
Message-ID: <20141223162419.GB9147@saruman>
Reply-To: <balbi@ti.com>
References: <1419240374-12179-1-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1419240374-12179-1-git-send-email-songjun.wu@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2014 at 05:26:14PM +0800, Songjun Wu wrote:
> When unloading the module, the urb request will be dequeued
> and the completion routine will be excuted.
> If no urb packet, the urb request will not be added to the endpoint queue
> and the completion routine pointer in urb request is NULL.
> Accessing to the NULL function pointer will cause the oops issue.
> Add the code to check the urb request is in the endpoint queue or not.
> If the urb request is not in the endpoint queue, a negative error code
> will be returned.

have you triggered the NULL pointer oops ? Care to add it to the commit
log.

Also, which commit is this fixing ? Does this need to be backported ?
When was the bug introduced ?

> Signed-off-by: Songjun Wu <songjun.wu@atmel.com>
> ---
>  drivers/usb/gadget/udc/atmel_usba_udc.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget=
/udc/atmel_usba_udc.c
> index ce88237..48629cc 100644
> --- a/drivers/usb/gadget/udc/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
> @@ -828,7 +828,7 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struct=
 usb_request *_req)
>  {
>  	struct usba_ep *ep =3D to_usba_ep(_ep);
>  	struct usba_udc *udc =3D ep->udc;
> -	struct usba_request *req =3D to_usba_req(_req);
> +	struct usba_request *req;
>  	unsigned long flags;
>  	u32 status;
> =20
> @@ -837,6 +837,16 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struc=
t usb_request *_req)
> =20
>  	spin_lock_irqsave(&udc->lock, flags);
> =20
> +	list_for_each_entry(req, &ep->queue, queue) {
> +		if (&req->req =3D=3D _req)
> +			break;
> +	}
> +
> +	if (&req->req !=3D _req) {
> +		spin_unlock_irqrestore(&udc->lock, flags);
> +		return -EINVAL;
> +	}
> +
>  	if (req->using_dma) {
>  		/*
>  		 * If this request is currently being transferred,
> --=20
> 1.7.9.5
>=20

--=20
balbi

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmZczAAoJEIaOsuA1yqREOa4QAISDSdn2Hzi5iFO6gpI4KCY6
Fd1M+vFzSMtAqJZHqhreuCIGD6hFo6mHYnDKj1Rh4ZP84ip0xKNWiecGwPAm2ihU
Raha+8HFKRDHRTS7OVcrXn8zCjBiMFBCP6CihDbHg2PGjRjo8D+X14d4ZJkfttGf
aGGM6KDgr3TuuVZLmz08e29U/q96S1Vq2xrTx4qz/qhAsVaaE80jMd+gN9QNhTu4
uS6+addJksdOqEdHLQNfaRCqHM1m6WSauhyPzdRYsyl5ngmjw/WZ/ErfyDqgWSKM
cFdHBS6YSOUhX3yRJffhh/oPM7dp2u271LqlP/uM7CQQES7ylJCYrTVr0QbBxEvg
qBC8M8sAp+WAMunMhmCZgOUTiqR5s8DnrWeL/3oPYD7RDakm+AjzhI7qwL/toxsg
BTdGfI4BeG6HoOISe9i8zQAW9BsL1S3H4x6+hiyuU/iDnQUr85LEVWyXb3aEVG88
0gt3zY+v1ZWjd7UUCFHAswMfhf6Ek37cTgg9bhPHdnWD0Xj2KZT7Z/phBtZQPl48
MwLeZGJvwkDdF63MUJ4t/Ulm49FechtQXkvK44DDvlvPcnn6l3ODfyRyhfawWwr6
eSPqj6MjBqHJQRp7cBIB63B9yXifBnbOmVAMw/VGO1cHQpcXJu5XEeKK/0rbsgY7
Q0+BES62lUdfAIYx7KBw
=AI8M
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
