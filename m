Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaAaCb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:31:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60179 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbaAaCb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:31:56 -0500
Date: Thu, 30 Jan 2014 20:29:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, <linux-sunxi@googlegroups.com>,
        <linux-spi@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <kevin.z.m.zh@gmail.com>,
        <sunny@allwinnertech.com>, <shuge@allwinnertech.com>,
        <zhuzhenhua@allwinnertech.com>
Subject: Re: [PATCH v2 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
Message-ID: <20140131022954.GB8163@saruman.home>
Reply-To: <balbi@ti.com>
References: <1390993850-9054-1-git-send-email-maxime.ripard@free-electrons.com>
 <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140129122520.GY11841@sirena.org.uk>
 <20140129133227.GQ3867@lukather>
 <CAGa+x854huSmiWmEv2EgOPUgZKcp3iitNaBvKXt8DiEj8msSVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <CAGa+x854huSmiWmEv2EgOPUgZKcp3iitNaBvKXt8DiEj8msSVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

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
>=20
> > pm_runtime_enable(&pdev->dev);
> > if (!pm_runtime_enabled(&pdev->dev))
> >    sun6i_spi_runtime_resume(&pdev->dev);
>=20
> Similarily here, it's not the pm_runtime_enable that will fail when
> runtime PM is disabled (or not built-in), it's a pm_runtime_get_sync()
> that will fail.
>=20
> What you want is something like this in ->probe()
>=20
>    sun6i_spi_runtime_resume();
>    /* now, device is always activated whether or not runtime PM is enable=
d */
>    pm_runtime_enable();
>    pm_runtime_set_active();  /* tells runtime PM core device is
> already active */

shouldn't this be done before pm_runtime_enable() ?

>    pm_runtime_get_sync();
>=20
> This 'get' will increase the usecount, but not actually call the
> callbacks because we told the RPM core that the device was already
> activated with _set_active().
>=20
> And then, in ->remove(), you'll want
>=20
>    pm_runtime_put();

in ->remove() you actually want a put_sync() right ? You don't want to
schedule anything since you're just about to disable pm_runtime.

--=20
balbi

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS6wqiAAoJEIaOsuA1yqREThYQAJIl97JA8uNJ+dT2HbIBVXzB
TiIk505z+1r8v3/Qm4wIa8RnUKF9aYb2SN9WvoP0Nl7ZVIOsXrJwccvWfO+8H4VQ
WRXwnlctcFHowmKKNz94jGSz53bH81B4PGhnOPNb3tZxWhMB91A5hNQFYzuSm8Ib
x0nd+YjameLzoRWPzGi50nqLdmg105x8FvZAgjrbqwtpuzPDrtMg7IV+QaTSvwQ8
CmTfS8ygUd1p1y0HVLQZ10zcJmyti9Va3yydtCJEbffwk5vMBuzXBz6XO6TxqLHS
LYn1ImWkzc1QkOhfyo61LSYHmMp9STS6HtocaOYHv0NBwhEAemvBTYSK6cYT2EUz
Rqd16dm3imeVJkMwqjPFYdEXjXosCknImi+Pd96s0JBtkqIxmJcRpPONr3GwvfPD
q0VChWx+iIOitJCeUmqN30F/UQgBeGl3hFSJaJ9dywv6mqOHucgaW7diPJfbqWlW
seXA/6RybTem96TkDnW3Le/FxMsQ66eIvQ6SKawiM8lsZ5zSTOzs934TG4Sefh+g
Q1bqmL7N+PCQAvAe1JyU7ATjVUJ3T3PlSiTFYXvUJHIHduX32r+H6TuUcEPOAf/H
GD3dzfprly4zsbMotBv+N54fBlwosmig2LMOWUBNPVBu0/dqDdTJSzMsnkdFxgPp
GyFdRPuHSWKszy/fs3vT
=WTAs
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
