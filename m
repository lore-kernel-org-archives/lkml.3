Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaIQP2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:28:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59355 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbaIQP2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:28:33 -0400
Date: Wed, 17 Sep 2014 10:28:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v5 1/3] usb: gadget: Refactor request completion
Message-ID: <20140917152801.GD6903@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410938473-29385-1-git-send-email-sojka@merica.cz>
 <1410938473-29385-2-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AbQceqfdZEv+FvjW"
Content-Disposition: inline
In-Reply-To: <1410938473-29385-2-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 09:21:11AM +0200, Michal Sojka wrote:
> All USB peripheral controller drivers called completion routines
> directly. This patch moves the completion call from drivers to
> usb_gadget_giveback_request(), in order to have a place where common
> functionality can be added.
>=20
> All places in drivers/usb/ matching "[-.]complete(" were replaced with a
> call to usb_gadget_giveback_request(). This was compile-tested with all
> ARM drivers enabled and runtime-tested for musb.
>=20
> Signed-off-by: Michal Sojka <sojka@merica.cz>
> ---
>  drivers/usb/chipidea/udc.c              |  6 +++---
>  drivers/usb/dwc2/gadget.c               |  6 +++---
>  drivers/usb/dwc3/gadget.c               |  2 +-
>  drivers/usb/gadget/udc/amd5536udc.c     |  2 +-
>  drivers/usb/gadget/udc/at91_udc.c       |  2 +-
>  drivers/usb/gadget/udc/atmel_usba_udc.c |  4 ++--
>  drivers/usb/gadget/udc/bcm63xx_udc.c    |  2 +-
>  drivers/usb/gadget/udc/dummy_hcd.c      | 10 +++++-----
>  drivers/usb/gadget/udc/fotg210-udc.c    |  2 +-
>  drivers/usb/gadget/udc/fsl_qe_udc.c     |  6 +-----
>  drivers/usb/gadget/udc/fsl_udc_core.c   |  6 ++----
>  drivers/usb/gadget/udc/fusb300_udc.c    |  2 +-
>  drivers/usb/gadget/udc/goku_udc.c       |  2 +-
>  drivers/usb/gadget/udc/gr_udc.c         |  2 +-
>  drivers/usb/gadget/udc/lpc32xx_udc.c    |  2 +-
>  drivers/usb/gadget/udc/m66592-udc.c     |  2 +-
>  drivers/usb/gadget/udc/mv_u3d_core.c    |  8 ++------
>  drivers/usb/gadget/udc/mv_udc_core.c    |  8 ++------
>  drivers/usb/gadget/udc/net2272.c        |  2 +-
>  drivers/usb/gadget/udc/net2280.c        |  2 +-
>  drivers/usb/gadget/udc/omap_udc.c       |  2 +-
>  drivers/usb/gadget/udc/pch_udc.c        |  2 +-
>  drivers/usb/gadget/udc/pxa25x_udc.c     |  2 +-
>  drivers/usb/gadget/udc/pxa27x_udc.c     |  2 +-
>  drivers/usb/gadget/udc/r8a66597-udc.c   |  2 +-
>  drivers/usb/gadget/udc/s3c-hsudc.c      |  3 +--
>  drivers/usb/gadget/udc/s3c2410_udc.c    |  2 +-
>  drivers/usb/gadget/udc/udc-core.c       | 19 +++++++++++++++++++
>  drivers/usb/musb/musb_gadget.c          |  2 +-
>  drivers/usb/renesas_usbhs/mod_gadget.c  |  2 +-
>  include/linux/usb/gadget.h              |  8 ++++++++

I would rather split this into several patches, btw. With the
introduction of usb_gadget_giveback_request() being the first one in the
series. It's easier to review that way.

> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/u=
dc-core.c
> index b0d9817..29789f1 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -106,6 +106,25 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
> =20
>  /* ---------------------------------------------------------------------=
---- */
> =20
> +/**
> + * usb_gadget_giveback_request - give the request back to the gadget lay=
er
> + * Context: in_interrupt()
> + *
> + * This is called by device controller drivers in order to return the
> + * completed request back to the gadget layer.
> + */
> +void usb_gadget_giveback_request(struct usb_ep *ep,
> +		struct usb_request *req)
> +{
> +	if (likely(req->complete))
> +		req->complete(ep, req);
> +	else
> +		pr_err("%s : req->complete must not be NULL\n", __func__);

let it Oops. We require ->complete to be valid, if there's any gadget
driver not setting ->complete, it deserves to oops so we can the error.

--=20
balbi

--AbQceqfdZEv+FvjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGaiBAAoJEIaOsuA1yqRE8WMQAKgoTtR7uIVAo0oGMyPmO1rH
LFBwtHFD8d9ko8mMrzTRlx/3fIa+FcKXXPUG+kLRySnUfaB0kd4qEBTYosQvU4En
0JvtIMQc6LNra5UM1PesdZoA1z9gpsMDIsFw8ngO0hptBUMJc0TZ4Zmracx6DXGX
r5+WZHZTODUOt0PFAROGb/tst+IczF/cxddAQoyd7dRRLcyHsA4sfJN5kJXyDjD4
8nb+pL+4f+N8+eEcJ5zkinDtqv4CK4CfcwLXAUvXYqLg7kcAL2taKbiTj4VSwTpM
xh+G5AAIAVaFMH/3jV/GWG4WITrx3/o0T9fWITd6rWpMy2h+6E/e5nBDUasnCd4W
pRCkUBYnENCQ7/eBb9ir1jgEB3oPdbA7J+UWD04Zz4xHKOKNsy5+ddJgmWtIEldj
GCjrjXUWCd/Nm8EiqqyTBwnuZjB02KwkgdEv7WeT6pfo6rSz7GHK4VWod/HGC0Zw
ExYQzKO/wzIBHkm8DPJIWAJMv1kShMKETT+5SiP5EHowfg7ryVyvcBQ4g3nQDBur
CqH97JPvygveZqhD1YL5i01nlwWqyzkVmk4rGaKOy7La5b4beyPyC2U5t22GBKvN
aAS/7rqHZUnCIE7i7iAYHtxO98TK6xXfsDfnnFzTDVU4uw9SZamS0z66QXtOyWGH
xpLX0rmQH1sl3HriuOEn
=50S9
-----END PGP SIGNATURE-----

--AbQceqfdZEv+FvjW--
