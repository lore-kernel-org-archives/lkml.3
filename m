Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBVIfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:35:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:41879 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751536AbaBVIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:35:05 -0500
Date: Sat, 22 Feb 2014 09:31:28 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: David =?iso-8859-1?Q?Lanzend=F6rfer?= 
	<david.lanzendoerfer@o2s.ch>,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/8] ARM: sunxi: Add driver for SD/MMC hosts found on
 Allwinner sunxi SoCs
Message-ID: <20140222083128.GH3931@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100234.15040.84232.stgit@pagira.o2s.ch>
 <20140218153731.GK3142@lukather>
 <5303C751.5090809@redhat.com>
 <20140219094615.GT3142@lukather>
 <5304A042.7090903@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GBuTPvBEOL0MYPgd"
Content-Disposition: inline
In-Reply-To: <5304A042.7090903@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GBuTPvBEOL0MYPgd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

(As a side note, your mailer just did something nasty with the
wrapping which made the code snippets totally unreadable. I'm going to
drop them.)

On Wed, Feb 19, 2014 at 01:14:58PM +0100, Hans de Goede wrote:
> >>>> +	wmb(); /* Ensure idma_des hit main mem before we start the idmac */
> >>>=20
> >>> wmb ensure the proper ordering of the instructions, not flushing
> >>> the caches like what your comment implies.
> >>=20
> >> Since I put that comment there, allow me to explain. A modern ARM
> >> cpu core has 2 or more units handling stores. One for regular
> >> memory stores, and one for io-mem stores. Regular mem stores can
> >> be re-ordered, io stores cannot. Normally there is no "syncing"
> >> between the 2 store units. Cache flushing is not an issue here
> >> since the memory holding the descriptors for the idma controller
> >> is allocated cache coherent, which on arm means it is not cached.
> >>=20
> >> What is an issue here is the io-store starting the idmac hitting
> >> the io-mem before the descriptors hit the main-mem, the wmb()
> >> ensures this does not happen.
> >=20
> > To expand a bit, my point was not that it was functionnally
> > wrong. Since you put a barrier in there, and that it resides in a
> > cache coherent section, we're fine.
> >=20
> > My point was that the comment itself was misleading.
>=20
> Well as explained above, the purpose of the wmb is to ensure that
> the descriptors hit main memory, before the following writel (in the
> caller of this function) starts the controller. So I don't see
> exactly how the comment is wrong.
>=20
> If you've a better wording for the comment, suggestions are welcome.

Your first reply was great :)

But if you feel like it enough, fine.

[ codeless snip..]=20

> >>> I'd rather put it at a debug loglevel.
> >>=20
> >> Erm, this only happens if something is seriously wrong.
> >=20
> > Still. Something would be seriously wrong in the MMC
> > driver/controller. You don't want to bloat the whole kernel logs
> > with the dump of your registers just because the MMC is
> > failing. This is of no interest to anyone but someone that would
> > actually try to debug what's wrong.
>=20
> This is not a complete register dump, this writes a single line to
> the kernel log saying that an io error happened, and printing the
> error flags set in the status register. We cannot be much shorter
> then this without simply not notifying the user that an io error has
> happened, and not notifying the user is wrong IMHO.

Ok.

> >>>> +	/* And put it back in reset */
> >>>> +	sunxi_mmc_exit_host(host);
> >>>=20
> >>> Hu? If it's in reset, how can it generate some IRQs?
> >>=20
> >> Yes, that is why we do the whole dance of init controller, get
> >> irq, disable irq, drop it back in reset (until the mmc subsys
> >> does a power on of the mmc card / sdio dev).
> >>=20
> >> Sometime the controller asserts the irq in reset for some reason,
> >> so without the dance as soon as we do the devm_request_irq we get
> >> an irq, and worse, not only do we get an irq, we cannot clear it
> >> since writing to the interrupt status register does not work when
> >> the controller is in reset, so we get stuck re-entering the irq
> >> handler.
> >=20
> > Hmmm, I see. It probably deserves some commenting here too then.
>=20
> This call is the mirror of the sunxi_mmc_init_host a few lines
> higher, which has this comment:
>=20
> /* Make sure the controller is in a sane state before enabling irqs */
>=20
> Which attempts to explain why we do the init controller, claim irq,
> disable irq, put controller back in reset sequence. Again suggestions
> for a better comment are welcome.

And again, the second part of your first reply was great :)

> >>>> +	ret =3D mmc_add_host(mmc);=20
> >>>> +	if (ret)
> >>>> +		goto error_free_dma;
> >>>> +
> >>>> +	dev_info(&pdev->dev, "base:0x%p irq:%u\n", host->reg_base, host->i=
rq);
> >>>> +	platform_set_drvdata(pdev, mmc);
> >>>=20
> >>> This should be before the registration. Otherwise, you're racy.
> >>=20
> >> Nope, we only need this to get the data on sunxi_mmc_remove,
> >> everywhere else the data is found through the mmc-host struct.
> >=20
> > Still, if anyone makes a following patch using the platform_device
> > for some reason, we will have a race condition, without any way to
> > notice it.
> >=20
> > Plus, you're doing all the other bits of initialization of your
> > structures much earlier, why not be consistent and having all of
> > them at the same place?
>=20
> Most platform drivers I've worked on do platform_set_drvdata as late
> as possible, so that the drvdata does not get set and never cleared
> in error paths.

You don't actually have to clear it, and some frameworks actually
require you to call dev_set_drvdata before registration, so that
statement looks quite odd to me.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GBuTPvBEOL0MYPgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTCGBfAAoJEBx+YmzsjxAgB8EP/2KINWi+YTfBVtMEYNGiJjVy
01PPEcQoXDBIwMS0b8A1o8QZQF5cGY3PxCyPEoV6wr7X6cb8foG7R1A1G8Wvg5oD
iY2i1jvIr9VaIGhYaOsKMABSY0Z/kkSg08ponF6PZEUnJtMZHReZPswvZ9PoOSqS
D/4uy6EH5oxQf09fr2sd8XyLno018+rCz9LbxMtrOuwILFDN4KM59pBL3A5rsGsn
AaCgDTQS1IANUd02NpRp+ORKUAGYQQNQrFwausJN0XdcI3jhKbwSnegkFnSsJw5+
xynY7IcNARyA1JR5rGl8oDoKJBNbyMn/ubg9laljms9W7HRH3xtRhSqJX6lVKyNq
I5SbAppYhxAPFDnYXi16M/V1PPtIPIBeST765iydJL2/6ZZo1unIAWbm1ux/FRFv
PlWuk9LB+BhULD0Mc7LmkjFc9sI5+7kZe/ERVFSDPe+OrhAfEkReNN2lu/b+LaTM
XCqcpYWMh1bRozYZ+jI6bcVU6rxUPJXPp14vRJMi4XpG5Ejebujj8MApLQd7gMPM
OVqJ8hT4SToDFbHzegBLjodonY/VX9oI+bM1zmIwC8Lqt4XN+vYbgrbXuZVDBW8l
PzV2pc1GJuR8SslK+EqhqmARBWi77JssDC6ouGkf3ELIIYzroUfMu2kLu2dg/MPF
icpEf8ScNCdtxwBPQBz6
=OCq2
-----END PGP SIGNATURE-----

--GBuTPvBEOL0MYPgd--
