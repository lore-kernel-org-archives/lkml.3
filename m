Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935201AbaFTRzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:55:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57536 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbaFTRzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:55:43 -0400
Date: Fri, 20 Jun 2014 12:55:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Himangi Saraogi <himangi774@gmail.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <julia.lawall@lip6.fr>
Subject: Re: [PATCH] usb: host: xhci-plat: use devm_functions
Message-ID: <20140620175531.GC28686@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140620174123.GA6973@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <20140620174123.GA6973@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2014 at 11:11:23PM +0530, Himangi Saraogi wrote:
> This patch introduces the use of managed interface devm_ioremap_resource
> for ioremap_nocache and request_mem_region and removes the corresponding
> free functions in the probe and remove functions.
>=20
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/xhci-plat.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 29d8adb..23eeb15 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -140,20 +140,12 @@ static int xhci_plat_probe(struct platform_device *=
pdev)
>  	hcd->rsrc_start =3D res->start;
>  	hcd->rsrc_len =3D resource_size(res);
> =20
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
> -				driver->description)) {
> -		dev_dbg(&pdev->dev, "controller already in use\n");
> -		ret =3D -EBUSY;
> +	hcd->regs =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(hcd->regs)) {
> +		ret =3D PTR_ERR(hcd->regs);
>  		goto put_hcd;
>  	}
> =20
> -	hcd->regs =3D ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> -		dev_dbg(&pdev->dev, "error mapping memory\n");
> -		ret =3D -EFAULT;
> -		goto release_mem_region;
> -	}
> -
>  	/*
>  	 * Not all platforms have a clk so it is not an error if the
>  	 * clock does not exists.
> @@ -162,7 +154,7 @@ static int xhci_plat_probe(struct platform_device *pd=
ev)
>  	if (!IS_ERR(clk)) {
>  		ret =3D clk_prepare_enable(clk);
>  		if (ret)
> -			goto unmap_registers;
> +			goto put_hcd;
>  	}
> =20
>  	ret =3D usb_add_hcd(hcd, irq, IRQF_SHARED);
> @@ -207,12 +199,6 @@ disable_clk:
>  	if (!IS_ERR(clk))
>  		clk_disable_unprepare(clk);
> =20
> -unmap_registers:
> -	iounmap(hcd->regs);
> -
> -release_mem_region:
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> -
>  put_hcd:
>  	usb_put_hcd(hcd);
> =20
> @@ -231,8 +217,6 @@ static int xhci_plat_remove(struct platform_device *d=
ev)
>  	usb_remove_hcd(hcd);
>  	if (!IS_ERR(clk))
>  		clk_disable_unprepare(clk);
> -	iounmap(hcd->regs);
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>  	usb_put_hcd(hcd);
>  	kfree(xhci);
> =20
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
balbi

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTpHWTAAoJEIaOsuA1yqREM54P/2vn4wlINJ9KD8wBi8UOpwla
DtbHlICveKj855AusHYCO1S96Ffm206Lg3pD8nJALHuU2He1E9je0gZuNy0xDgP2
zL70W8mh+iw13gCIA6xXH+DAtxgi/j03ZNUq37TQ38n8mjQEkdq1NTwfudGGhDND
24hHb4wo6NMcm/KT4fY6Ypa7PH04KOKFpbt29vtHYpSfZVZoUrb1yUBzH/Agx9Be
DPjYi0dVGoypBZWWADv1cfCWQakhDPfynwv4wxX0B0QNbzaIlKLeY5g7RgZbP0ti
gAlA/fPkHxNTHN2+Kni7Iknbm6QI71/LNiSpeFZt1xJKfSjB4X74sloHdsnVF7Pg
yQoNcCqJaWNfIiskv/jORPnudidLu/P9EWjzigtavVYpNdK7mVxkcLu25Ulpm5ir
MsgF96d2x3Q3UUPFFTGvxote8hyzoQrqaehr9mRDLKxW/rP/kKdBAd2F241XLaq+
qP+s+o9qy0v8ikXYWCB7ZKXKyY3KY5gPB7akAeuUVILWLTuoPvVQ00YCsyl+O/1s
IPL63VSz7bVDh/jdrCZqvQUnuuoD7Vei61/LCKImCLwAlue+166sm5nmJ7MV4UsO
kAJK2dksRFUe5dp4zUwTckVz0sbZ5mtTjkrFwXC+wLSe5/F6N973KWD/e/G62IFh
YVeIhVo0UCGFRzn0PkSO
=+WRw
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
