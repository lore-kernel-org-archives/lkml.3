Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaA2NfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:35:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60238 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbaA2NfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:35:07 -0500
Date: Wed, 29 Jan 2014 14:32:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v2 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
Message-ID: <20140129133227.GQ3867@lukather>
References: <1390993850-9054-1-git-send-email-maxime.ripard@free-electrons.com>
 <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140129122520.GY11841@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CoNbBaeZcnNUO34V"
Content-Disposition: inline
In-Reply-To: <20140129122520.GY11841@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CoNbBaeZcnNUO34V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2014 at 12:25:20PM +0000, Mark Brown wrote:
> On Wed, Jan 29, 2014 at 12:10:48PM +0100, Maxime Ripard wrote:
>=20
> > +config SPI_SUN6I
> > +	tristate "Allwinner A31 SPI controller"
> > +	depends on ARCH_SUNXI || COMPILE_TEST
> > +	select PM_RUNTIME
> > +	help
> > +	  This enables using the SPI controller on the Allwinner A31 SoCs.
> > +
>=20
> A select of PM_RUNTIME is both surprising and odd - why is that there?
> The usual idiom is that the device starts out powered up (flagged using
> pm_runtime_set_active()) and then runtime PM then suspends it when it's
> compiled in.  That way if for some reason people want to avoid runtime
> PM they can still use the device.

Since pm_runtime_set_active and all the pm_runtime* callbacks in
general are defined to pretty much empty functions, how the
suspend/resume callbacks are called then? Obviously, we need them to
be run, hence why I added the select here, but now I'm seeing a
construct like what's following acceptable then?

pm_runtime_enable(&pdev->dev);
if (!pm_runtime_enabled(&pdev->dev))
   sun6i_spi_runtime_resume(&pdev->dev);

> > +static void sun6i_spi_set_cs(struct spi_device *spi, bool enable)
> > +{
> > +	struct sun6i_spi *sspi =3D spi_master_get_devdata(spi->master);
> > +	u32 reg;
> > +
> > +	if (!enable)
> > +		return;
> > +
> > +	reg =3D sun6i_spi_read(sspi, SUN6I_TFR_CTL_REG);
> > +	reg &=3D ~SUN6I_TFR_CTL_CS_MASK;
> > +	reg |=3D SUN6I_TFR_CTL_CS(spi->chip_select);
> > +	sun6i_spi_write(sspi, SUN6I_TFR_CTL_REG, reg);
> > +}
>=20
> The !enable means that it'll only ever be able to go one way.  Also note
> that the documentation was clarified here to make the enable flag be the
> absolute logic level, not if chip select was asserted.

Actually the IP asserts the CS automatically, the only thing you need
to do is to set which CS to use for your next transfer in some
register (which is what I'm doing after the !enable), and the CS will
be managed directly by the controller. Hence, there's no way to say
wether you want to enable it or not.

The controller allows to control the CS manually also, if that's the
preferred way of doing things.

> > +	timeout =3D wait_for_completion_timeout(&sspi->done,
> > +					      msecs_to_jiffies(1000));
> > +	if (!timeout) {
> > +		ret =3D -ETIMEDOUT;
> > +		goto out;
> > +	}
> > +
> > +	sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
>=20
> This means we can only transfer a single FIFO of data?  I didn't see a
> check on the transfer length.

At the moment, indeed. And that's the first thing I check in the
transfer_one function.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CoNbBaeZcnNUO34V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS6QLrAAoJEBx+YmzsjxAgvZkQAJf3RgJt2+yKvlR6eUzCtuzi
PmiP1SMaUSNoQ6tnQUJoLTsOHT9qZYwhuLMTY/1SP+EFO4dU4ZkONM0xgUBpsXji
++uqQxjjcT2lOq2NWYKNzP8HpCCPuIwqfqBkKZHIvf0oi6JYDljblKARYs7WIY8b
cLOcbpRbcpOYn57CBqzAQmwYFSe8fTzFl+q1JGurZzph40uKRzU+XeZpXJ1OLV/h
XQ2lRIH2trCSrphPAyyRGq0PVpDgEYtFtSSd3vADK6LGvegWsBwmMn2ZwL4Qxgv3
777oNPnew3jRscKk0PTyaToe5WOjopLyacXCyW7beyPQR7CCN2vGnJipcxowAFJv
Hwx01r5+M22hZ+6CNkiiuhM6u513HkHj+X3sl2Wldh2I6nTCo3KB3Rl/OAqj8s3L
vtGeYOrtN3FCwdkiDWQl1/Hs3O73IiHskhf3u8+5Y1I62XEvKBFtIvPkT4tLwOGZ
4rd9H9LeQ5ipeM5YSqWL6R5dt3NMnJ3mltNkTdxsYJjK4Bb6Yx6a1trj/YXImZpN
S2GvPGVWbNak6rWUQ67D8kLLqn+eiEVjKEYNLUhTKF027r0wdc1hQkH4D6l2ap3j
2Zz38SsapQlr2KSGvBwThzs/ZXgDP4tJa2Rzz06UEL6Cet1/eftoyE+vGvm7G2E6
o0KvRQKK6sJGa5mqU3RE
=fVQP
-----END PGP SIGNATURE-----

--CoNbBaeZcnNUO34V--
