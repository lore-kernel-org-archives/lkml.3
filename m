Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaBDTQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:16:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35454 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaBDTQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:16:37 -0500
Date: Tue, 4 Feb 2014 19:16:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mmc@vger.kernel.org
Message-ID: <20140204191609.GU22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-8-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZkPsHaVllGm+sYrn"
Content-Disposition: inline
In-Reply-To: <1391529538-21685-8-git-send-email-ulf.hansson@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/17] spi: pl022: Don't ignore power domain and amba bus
 at system suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZkPsHaVllGm+sYrn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 04:58:48PM +0100, Ulf Hansson wrote:

> @@ -2328,8 +2300,23 @@ static int pl022_suspend(struct device *dev)
>  		return ret;
>  	}
> =20
> -	pm_runtime_get_sync(dev);
> -	pl022_suspend_resources(pl022, false);
> +	pm_runtime_disable(dev);
> +
> +	if (!pm_runtime_status_suspended(dev)) {
> +		if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
> +			ret =3D dev->pm_domain->ops.runtime_suspend(dev);
> +		else
> +			ret =3D dev->bus->pm->runtime_suspend(dev);
> +
> +		if (ret) {
> +			pm_runtime_enable(dev);
> +			return ret;
> +		}
> +
> +		pm_runtime_set_suspended(dev);
> +	}

This seems like a fairly hideous thing to be having to open code in an
individual driver, it all looks generic and like something that most if
not all devices ought to be doing and it looks very vulnerable to being
broken by changes in the core.  At the very least I would expect this to
be done in a helper function, though it would be even nicer if the
driver core were figuring this stuff out for us based on the device
level callback so that drivers didn't need to worry about being in power
domains or manually calling bus level callbacks. =20

Putting it in a helper would at least mean that it's easier for the
mechanics to be transferred to the core proper later on.

--ZkPsHaVllGm+sYrn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8Tx1AAoJELSic+t+oim9OKcP/2vZiGXoxlTK/RIMPmzZDsIf
3W2NciL8THJsv2d7cGHy76k3K+9G5yVo3a3IUMai37P3j7gadPbdOfClbD0A4izk
wKJ+R8tr6zFpeMclY70KdYlDtQmI5mO/tfM3x//gCWbYyLBhN8f6p5Zyeaq95Sz6
kmwPVYhNUKqH5V0dCdOURHRdFges54AMh8Pbt2jsOPPr2cMuwuD1gB5dIkN+Pz6J
8cYf3I4cW5L/am9qBISbBlNWUKrBnHkmitk9S/PcI0Yr97k5cyYx9xyUb2r8wA83
sJpZWFDDsu9Sxm0rwQTkFPtQMVcbc2ZB5ekbKR7D/gkLGH4JQ+BlysE/NDvTB8E5
VdhFSYSQJOoHeOkffmttovOM2bmzbbgBzRanbYzBxFiJAAayc1Bww87ewBw3QNnf
cQSngwjzCTJjNPQqZMUufHTh58SiuiOBTZI9ZRsmyMQLWoZ3NxFcOBXePS51xmMq
S3RsBJy2WXcKciOHnFIlQwZQtUkCU87FKcfX2wSJTeaCpoj1rlL56cU5lz6+i5Bc
f4idZuVzPo9NPfDuxQoUwIKWKjRyYx+6uCpt6uLRmA82/pG2BBil5QGAWYWA2XEo
G9Go3qegjcus4lD/3Rix2hRqc52Aq8HzxvMDQHeB8TPYwxOKmR2iNmZyUkocmOf8
Ngiu/RRStOQt4XNdVDow
=4UiI
-----END PGP SIGNATURE-----

--ZkPsHaVllGm+sYrn--
