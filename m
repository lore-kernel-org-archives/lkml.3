Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaFFWwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:52:54 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50486 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:52:52 -0400
Date: Sat, 7 Jun 2014 00:52:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v2 6/6] usb: host: ohci-exynos: Use devm_ioremap_resource
 instead of devm_ioremap
Message-ID: <20140606225246.GB22188@mithrandir>
References: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
 <1399723210-21569-7-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iFufCh6SVEF-HQA62ZsJGJGSebDSs28eqcrMy1X8e5vjA@mail.gmail.com>
 <20140604131306.GB28484@ulmo>
 <CAFp+6iEe8fvxboG79=2s=oe4BkQJYAoVUPtYkPdjJHCe+bC=8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEe8fvxboG79=2s=oe4BkQJYAoVUPtYkPdjJHCe+bC=8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 06:32:42PM +0530, Vivek Gautam wrote:
> On Wed, Jun 4, 2014 at 6:43 PM, Thierry Reding <thierry.reding@gmail.com>=
 wrote:
> > On Wed, Jun 04, 2014 at 03:41:20PM +0530, Vivek Gautam wrote:
> >> On Sat, May 10, 2014 at 5:30 PM, Vivek Gautam <gautam.vivek@samsung.co=
m> wrote:
[...]
> >> > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-=
exynos.c
> >> > index 9cf80cb..dec691d 100644
> >> > --- a/drivers/usb/host/ohci-exynos.c
> >> > +++ b/drivers/usb/host/ohci-exynos.c
> >> > @@ -120,10 +120,9 @@ skip_phy:
> >> >
> >> >         hcd->rsrc_start =3D res->start;
> >> >         hcd->rsrc_len =3D resource_size(res);
> >> > -       hcd->regs =3D devm_ioremap(&pdev->dev, res->start, hcd->rsrc=
_len);
> >> > -       if (!hcd->regs) {
> >> > -               dev_err(&pdev->dev, "Failed to remap I/O memory\n");
> >> > -               err =3D -ENOMEM;
> >> > +       hcd->regs =3D devm_ioremap_resource(&pdev->dev, res);
> >>
> >> Here, we replaced devm_ioremap() call with devm_ioremap_resource(),
> >> which internally requests the memory region
> >
> > I guess this could lead to problems if drivers haven't been written to
> > cleanly split the register ranges that they access, since now two
> > overlapping regions may be requested and cause the drivers to fail.
>=20
> Sorry i did not understand completely. Wouldn't the request_mem_region()
> fail for an already busy resource ?
> So devm_ioremap_resource() will in fact prevent the drivers from requesti=
ng
> the same memory region twice until the first request frees the region.
> Isn't it ?

Yes exactly. What I was trying to say is that since drivers weren't
requesting the resources before they may be using overlapping regions.
Now that this patch changes these drivers to also request the resources
they will fail if the regions overlap with those of other drivers.

> >> and then does a "devm_ioremap()" or "devm_ioremap_nocache()" based on
> >> the check for IORESOURCE_CACHEABLE flag.
> >>
> >> But this flag is not set for the resource of this device.
> >> So should we be explicitly setting the flag in driver ?
> >
> > I don't think it makes much sense to map these registers cached anyway.
> > Drivers will likely expect writes to this region to take effect without
> > needing any kind of flushing.
>=20
> These "hcd->regs" are going to be used by the controller, so wouldn't
> there be a performance difference when the requested address space is
> cacheable/non-cacheable ?

The issue here is that if the region is mapped cacheable then register
writes may not immediately take effect and that's almost certainly not
what the driver will expect. I don't think it ever makes sense to map
registers cacheable.

Thierry

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkkY+AAoJEN0jrNd/PrOhPmoP/AqwOmizwuk3rpr6uU+x3K/j
Y2+eFQQw8EBVSnaCFI1QN+s/27vM2OcN1ByZ55G6B1NaA6WiAnhQWEUv1t+KvLt/
Go3Tv1tr53xQNyKXSdOuS0WkQa5y+ZxhgT6dgKn+knOdXCbdfb93WR8cvprQoiRE
c/E8wsA8heV4Sk94HZW0qvcMRCfV3XLKR7H3VfYdbZEQhZYwooQP6u/WjY88094x
fXhI8Cga5O9i0eDkkSeUgQYlhzi4N9Qpp00shx66+KoSsafVj/YpblFBKCzrQ/0E
AyqnOOUsEt4OJOk6GPoZmON1odPIYBMemgZukjKNqLOx+G8KU50a4IhqAnjfgTTj
wZeKC8mAi90s/ZeTtBsr+pRvZGmpgvbO0vZ8ZAovHFDKebnPT2dtqWvMv9CgpB+f
BAKnakjrL8yn+uZWBs+TuYmx03wQLWNNbj0FUUgWHt/fmPQnsvKSVx77p45t0ihX
G5Kh8ttUtfYOMnJSkE063Cya5CLCrEx8fN92AtqklGsawiA56XmpPhfhrdOKWYvO
elL6S15Bf0Gk3gf1l61K5B5rHEuiRRmaxy6U+lVcozmGFwkMns4TlFgYmWJG9S/j
no2o93RmxSMf5i9qfaDukCKOxsp9VjoXnt37Fe66tmolBdYnU8l637C2oZGgTScb
kbheiVhKz1zjQJLsN956
=QxJm
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
