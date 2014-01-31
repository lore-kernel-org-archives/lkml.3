Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaAaIPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:15:53 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42438 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbaAaIPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:15:04 -0500
Date: Fri, 31 Jan 2014 09:11:47 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v2 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
Message-ID: <20140131081147.GC2950@lukather>
References: <1390993850-9054-1-git-send-email-maxime.ripard@free-electrons.com>
 <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140129122520.GY11841@sirena.org.uk>
 <20140129133227.GQ3867@lukather>
 <CAGa+x854huSmiWmEv2EgOPUgZKcp3iitNaBvKXt8DiEj8msSVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <CAGa+x854huSmiWmEv2EgOPUgZKcp3iitNaBvKXt8DiEj8msSVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

On Thu, Jan 30, 2014 at 03:52:16PM -0800, Kevin Hilman wrote:
> On Wed, Jan 29, 2014 at 5:32 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Wed, Jan 29, 2014 at 12:25:20PM +0000, Mark Brown wrote:
> >> On Wed, Jan 29, 2014 at 12:10:48PM +0100, Maxime Ripard wrote:
> >>
> >> > +config SPI_SUN6I
> >> > +   tristate "Allwinner A31 SPI controller"
> >> > +   depends on ARCH_SUNXI || COMPILE_TEST
> >> > +   select PM_RUNTIME
> >> > +   help
> >> > +     This enables using the SPI controller on the Allwinner A31 SoC=
s.
> >> > +
> >>
> >> A select of PM_RUNTIME is both surprising and odd - why is that there?
> >> The usual idiom is that the device starts out powered up (flagged using
> >> pm_runtime_set_active()) and then runtime PM then suspends it when it's
> >> compiled in.  That way if for some reason people want to avoid runtime
> >> PM they can still use the device.
> >
> > Since pm_runtime_set_active and all the pm_runtime* callbacks in
> > general are defined to pretty much empty functions, how the
> > suspend/resume callbacks are called then? Obviously, we need them to
> > be run, hence why I added the select here, but now I'm seeing a
> > construct like what's following acceptable then?
>=20
> Even with your 'select', The runtime PM callbacks will never be called
> in the current driver.  pm_runtime_enable() doesn't do any runtime PM
> transitions.  It just allows transitions to happen when they're
> triggered by _get()/_put()/etc.

Actually, pm_runtime_get_sync is called by the SPI framework whenever
the device needs to be used. And pm_runtime_put whenever it's not used
anymore, so the callbacks are actually called.

>=20
> > pm_runtime_enable(&pdev->dev);
> > if (!pm_runtime_enabled(&pdev->dev))
> >    sun6i_spi_runtime_resume(&pdev->dev);
>=20
> Similarily here, it's not the pm_runtime_enable that will fail when
> runtime PM is disabled (or not built-in), it's a pm_runtime_get_sync()
> that will fail.

In the case where pm_runtime is disabled, pm_runtime_enabled will only
return false, and hence the resume callback will be called. get_sync
will fail too when the framework will call it, but since the device is
already initialized, it's fine I guess.

> What you want is something like this in ->probe()
>=20
>    sun6i_spi_runtime_resume();
>    /* now, device is always activated whether or not runtime PM is enable=
d */
>    pm_runtime_enable();
>    pm_runtime_set_active();  /* tells runtime PM core device is
> already active */
>    pm_runtime_get_sync();
>=20
> This 'get' will increase the usecount, but not actually call the
> callbacks because we told the RPM core that the device was already
> activated with _set_active().
>=20
> And then, in ->remove(), you'll want
>=20
>    pm_runtime_put();
>    pm_runtime_disable();
>=20
> And if runtime PM is not enabled in the kernel, then the device will
> be left on (which is kinda what you want if you didn't build runtime
> PM into the kernel.)

Yes, but that also mean that the device is actually on after the
probe, even if it's never going to be used. From what I got reading
the pm_runtime code, the suspend callback is called only whenever you
call _put, so the device will be suspended only after it's been used
the first time, right?

Wouldn't it be better if it was suspended by default, and just waken
up whenever the framework needs it?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS61rDAAoJEBx+YmzsjxAgs94P/2nc5NFGnlbEGkSHTiiI/YNb
4b1WeSAbr7OyIUG/BgxUtPbuSHLhizYRYI1nrMfPRyxoALm8zI3mRXjK/R4UqHLB
id+qUlOkJn3RQ2GJEzD8PQiIXZYt884mIeT2OveC55B3UUYSqUwemhFUfRVlJu0i
+hAIyuAg/y7Vcsys6uvof8S8zcAXqvxyw/RVPs3VBy6BMHg6y+BaJEV0AI6FvInJ
y3oc8RYMzFwdqILVdCyXMKA3pqIe3sVI94BxVor9izSe5Rm+U7v+qykGNKZXWWDc
telhJ5d1owWiYpQRuFGoTx+EHhWkRplUfYaYULAvaXpyA0SW5IrG7i6qNeXm0v/O
35RhVDYEXirnLvUdHSFL+dcX5aL5E+g+hye/7Oia3k3c5JCedRTq3xcLa4s9jsEy
rPeJ9ZaxYW6Togrxv5NyEJT9CTqyZ2zw4z9mnQQeb3iDobKyWfXJVrcr3L6sJU9r
R4LGi2xCb7OtC3FRJB9p4rKtH2Gf+xMOFuI/xWSLBFpudiBzXFcWoBFda8GNQKz8
P9I9O38wOCpl2eQTwG0ZXiXzGmzekiC8olt+q/MOIKTNBNVtCCkjvDSaNgjwCRmq
B2f9oGys2WHBoD0KksWUBF63ONMNmMjLQT6+KNT29CddkTq9b3+nGFv5ZrkdPrtj
EdmMn6thUFVatmZdq6Ww
=k/rz
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
