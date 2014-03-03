Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaCCB7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:59:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54499 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaCCB7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:59:42 -0500
Date: Mon, 3 Mar 2014 10:05:26 +0900
From: Mark Brown <broonie@kernel.org>
To: Martin Sperl <kernel@martin.sperl.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, iivanov@mm-sol.com, gsi@denx.de,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140303010526.GV29849@sirena.org.uk>
References: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp>
 <20140301041330.GO29849@sirena.org.uk>
 <4D0588EB-C20C-4B24-B656-6175C2309352@martin.sperl.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ou5B7nmexOOGXbzo"
Content-Disposition: inline
In-Reply-To: <4D0588EB-C20C-4B24-B656-6175C2309352@martin.sperl.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: make zero length transfer valid again
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ou5B7nmexOOGXbzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 01, 2014 at 12:40:39PM +0100, Martin Sperl wrote:

> I am not sure if it might make some bus-drivers more complicated
> /inefficient just to support this zero length.

For most of them it should be relatively straightforward, especially as
we factor things out into the core so that the drivers don't need to
implement the delays at all and it's all handled in the core.

> For example: the spi-bcm2835.c driver would do the following with a
> spi_transfer.len == 0 in the transfer_on method:
> * enables SPI and wait for interrupt completion
> * the above which will trigger an interrupt
> ** in the interrupt we find out that there is nothing to transfer,
>     so we signal completion to transfer_one, so it may continue.
> * the main transfer_one will get woken up
> ** it will do a delay_usecs
> ** it will handle CS_CHANGE
> ** it will disable SPI/reset HW again

> So this implementation shows that there is a lot of inefficient
> overhead/delay just to trigger a delay...

You really ought to be deferring to task context to implement the delays
anyway - delaying in interrupt context is rude (though doable for very
short delays).  I'd have expected that the enable/disable to be
bypassable, unless the hardware needs to be reset between transfers this
should only be happening when the device goes idle.

> I guess other drivers will show similar code-artefacts and
> some may even make the implicit assumption it has to be non-zero,
> which would break functionality those odd devices.

There's lots of stuff that's broken with individual drivers - anything
that relies on cs_change is going to break with half the drivers out
there.  Some of this is legitimate hardware limitations (where the /CS
control is out of the control of software) but a lot of it is just bugs
due to people open coding things.

--Ou5B7nmexOOGXbzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTE9VNAAoJELSic+t+oim9WRQP/iQTUHHOtUUo5VsSaVjpneeT
eQqwV8bWKf9W6gOpsLPP5j+BTkccww5fHSjia1WErAbG/q1qxWjTt7upYoefxB0m
pyXZMbiopr9YOkpRrP/4+RFcVKnXea6wzr1iPrXMBnEFcC/G4GnwhsNm4cBZdC6W
JHbYTJWIhub09x4f+fvGLyLoNhqit0B/rEbpVI19f4kTnJeDs37r3JoI0431AMHu
DucAVjIDt9cF6ggtfn86JeRoURUlv328fPa4fbtX3EFFb5+xPP4OCtlssiDq5C7t
Z5eGy/lNVCrtg7fKfzF9VDWMdz9OKdQ+l/XHC/lviZbKhVyedRbjEbSqcixDSY0z
XJTlNkH8fFybTbHkKdf4wuZNYgqkgVcjvlARUD+H/VV4EIj4qMaEw0zl1ibC6ksx
4gTU1585hHKTAwKFtQRUKt459XyYbJr+KZqbHLHfHUddUiiSGyKj6PXSSB+HEWYc
SPaeO+U4Hdo/enOj5bQGKHdFIUdOnFv0CubMm4+cOwC2WE5Az+MCIKNcaZCnJ51P
oEF1jbyx/jwSbI3/TEA/ZA52NL40BMUWyWBZ9SzOlbIv4Q0388lFzdlMPXr6EwNY
4oBUpRW9hH5Slf8U0tdGxfOynUFXt9lVABzrG7da/H9O14VoHsp6Vr4MnBsE9B10
X9sZFGQu93Q+dCsNF92t
=u+wa
-----END PGP SIGNATURE-----

--Ou5B7nmexOOGXbzo--
