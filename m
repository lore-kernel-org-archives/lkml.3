Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaAPVPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:15:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52696 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbaAPVPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:15:07 -0500
Date: Thu, 16 Jan 2014 22:12:01 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 3/4] spi: sunxi: Add Allwinner A31 SPI controller driver
Message-ID: <20140116211201.GC3351@lukather>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
 <1389892285-11745-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140116194003.GN17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <20140116194003.GN17314@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, Jan 16, 2014 at 07:40:03PM +0000, Mark Brown wrote:
> On Thu, Jan 16, 2014 at 06:11:24PM +0100, Maxime Ripard wrote:
>=20
> Looks pretty clean, a few fairly small things below.
>=20
> > +- clocks: phandle to the clocks feeding the SPI controller. Two are
> > +          needed:
> > +  - "ahb": the gated AHB parent clock
> > +  - "mod": the parent module clock
>=20
> I guess you should specify that this needs to be done with clock-names
> too then?

Yep, right.

> > --- a/drivers/spi/Makefile
> > +++ b/drivers/spi/Makefile
> > @@ -69,6 +69,7 @@ obj-$(CONFIG_SPI_SH_HSPI)		+=3D spi-sh-hspi.o
> >  obj-$(CONFIG_SPI_SH_MSIOF)		+=3D spi-sh-msiof.o
> >  obj-$(CONFIG_SPI_SH_SCI)		+=3D spi-sh-sci.o
> >  obj-$(CONFIG_SPI_SIRF)		+=3D spi-sirf.o
> > +obj-$(CONFIG_ARCH_SUNXI)		+=3D spi-sun6i.o
>=20
> I would expect a new Kconfig symbol for this.

Hmmm, yeah, sorry, some hacky leftover.

> > +static inline void sun6i_spi_drain_fifo(struct sun6i_spi *sspi, int le=
n)
> > +{
> > +	u32 reg, cnt;
> > +	u8 byte;
> > +
> > +	/* See how much data are available */
>=20
> data is available.
>=20
> > +	while (len--) {
> > +		byte =3D readb(sspi->base_addr + SUN6I_RXDATA_REG);
> > +		if (sspi->rx_buf)
> > +			*sspi->rx_buf++ =3D byte;
> > +	}
>=20
> It seems like this hardware is only able to handle bidirectional
> operation - this is actually quite common and isn't always as simple as
> it is here.  Can I persuade you to put something in the core which
> provides dummy data buffers for this case?  I was thinking flags like
> must_tx and must_rx or something but didn't get around to this yet.

I'm pretty sure It can support unidirectionnal operations as well. I
just didn't found out how yet. There's actually three counters to set
whenever I setup the transfer, two of them seem to be to set the
number of bytes to send, and the last one the overall number of bursts
to set on the clock line, so I guess that we can either set it only in
RX (with the first two to 0, the last one to spi_transfer->len), only
in TX or both (by programming all three to spi_transfer->len).

> > +static int sun6i_spi_finish_transfer(struct spi_device *spi,
> > +				     struct spi_transfer *tfr,
> > +				     bool cs_change)
> > +{
> > +	struct sun6i_spi *sspi =3D spi_master_get_devdata(spi->master);
> > +
> > +	sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
> > +
> > +	if (tfr->delay_usecs)
> > +		udelay(tfr->delay_usecs);
>=20
> If you implement this using transfer_one() (as you should) the core will
> do this for you.

Oh, nice. I overlooked it.

> > +	if (status & SUN6I_INT_CTL_RF_OVF) {
> > +		sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
> > +		sun6i_spi_write(sspi, SUN6I_INT_STA_REG, SUN6I_INT_CTL_RF_OVF);
> > +		return IRQ_HANDLED;
> > +	}
>=20
> This looks like an overflow - a log message would be helpful for users
> and you should possibly be flagging an error on the current transfer.

Hmmm, that was an attempt at receiving more bytes than the FIFO can
handle, but I guess the FIFO full interrupt would be more appropriate
for this.

> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	sspi->base_addr =3D devm_request_and_ioremap(&pdev->dev, res);
> > +	if (!sspi->base_addr) {
> > +		dev_err(&pdev->dev, "Unable to remap IO\n");
> > +		ret =3D -ENXIO;
> > +		goto err;
> > +	}
>=20
> devm_ioremap_resource() is nicer in that it returns an error and then
> you don't need to log either since it's noisy itself.

Ack.

> > +	irq =3D platform_get_irq(pdev, 0);
> > +	if (irq < 0) {
> > +		dev_err(&pdev->dev, "No spi IRQ specified\n");
> > +		ret =3D -ENXIO;
>=20
> Don't overwrite the error code.

Ack.

> > +	ret =3D clk_set_rate(sspi->mclk, 100000000);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Couldn't change module clock rate\n");
> > +		goto err2;
> > +	}
>=20
> Does this really need to be fatal (or done at all)?  There seems to be
> another reasonably flexible divider in the IP and it's more common to
> either set this per transfer to something that rounds nicely or just use
> the default and rely on the dividers.

The default parent of the module clock runs at 24MHz, that means that
we won't be able to reach a spi clock higher than 12MHz, which seems
quite low. We can always change the rate in the transfer setup code
though, if needs be.

> > +	ret =3D clk_prepare_enable(sspi->mclk);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Couldn't enable clock 'ahb spi'\n");
> > +		goto err2;
> > +	}
>=20
> I would recommend moving these to runtime PM so the clocks are only
> active when the device is actually in use, the core will do the runtime
> PM management if you set auto_runtime_pm so it's really easy to
> implement.

Ok, nice.


> > +	ret =3D reset_control_deassert(sspi->rstc);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Couldn't deassert the device from reset\n");
> > +		goto err3;
> > +	}
> > +
> > +	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
> > +			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
>=20
> Similarly here the IP could be kept in reset when not in use.

Ok.

Thanks a lot!
Maxime


--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS2EshAAoJEBx+YmzsjxAgBo4QALrq6ml5yZ3G+SLptaDjkSOj
jLUPJ2id9ignvvDsBIZJEdIUKS/Kgz6IfgCgWohWufnVEUtiEN0T8sM+BTaOknVo
K7AbpoI5rdIFYhymi7p4gA1jmoRXfVi9aNp4yCKPca0dzwlTjTJfT2NZVN2I0UJ+
aCJsnYT3VQtpY4GM+/ILTHJN/Q2XaJfyG+nBgvRuKk7r8TN33Cdiukw1QvWbi6pG
wMNpAtBN+KcOnSia5JTTVIa4nw+Rqmh+XJDsUZ3IJs9I3V29olkE2sfAxf3gj1N1
3OnQtSJizrmAgYMfQ24UnZSxYQDZ6gUBYSHYdJoQ9GwpDJgfkdWzyx18dhV8U2DE
K0WaGSKyb62sqPRFNFLurT6YW5UhtzEIGeBQ/8smJQiLpQ7m5d/U6+2mgSVfnymH
522ySV8yaydzS26hdu6LbqVJ9rDMvWdT94mpYffnoNxsWbTA5vATM2nyrgTeu62e
/qAcez4lWFPq3LJkNX/QgCEkSDGIMhb+0qoxikft9Ppid2XQgQALDj8cCuAyNY14
WCEEwRWYUK6FAsXqq3l7rA1/hfnKRfd+rRgyDcm4GMj1PEe8j8KwQVsa/OUQJsou
9hpgexomgGU1TQNntspbqB8f2EEHb3idOqcQwSd44O6GMaxysuUjuQH3gAStaH7q
KmDEXsVLP0uoFlE4pTpd
=6xI2
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
