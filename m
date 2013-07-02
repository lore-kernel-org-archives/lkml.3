Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab3GBKbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:31:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60260 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab3GBKbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:31:37 -0400
Date: Tue, 2 Jul 2013 13:31:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <balbi@ti.com>, <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
Message-ID: <20130702103122.GP3352@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
 <20130702092458.GI3352@arwen.pp.htv.fi>
 <51D2A4CA.5030804@ti.com>
 <20130702101608.GO3352@arwen.pp.htv.fi>
 <51D2AA35.2070002@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NEaRsfQExFH3jWtg"
Content-Disposition: inline
In-Reply-To: <51D2AA35.2070002@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NEaRsfQExFH3jWtg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 03:53:49PM +0530, Sourav Poddar wrote:
> On Tuesday 02 July 2013 03:46 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Jul 02, 2013 at 03:30:42PM +0530, Sourav Poddar wrote:
> >>>>+static int dra7xxx_qspi_setup(struct spi_device *spi)
> >>>>+{
> >>>>+	struct dra7xxx_qspi	*qspi =3D
> >>>>+			spi_master_get_devdata(spi->master);
> >>>>+
> >>>>+	int clk_div;
> >>>>+
> >>>>+	if (!qspi->spi_max_frequency)
> >>>>+		clk_div =3D 0;
> >>>won't this generate division by zero ?
> >>>
> >>Yes, Probably only an error should be thrown here. ?
> >>since min clk_div should be kept at 1.
> >right, if spi_max_frequency isn't passed, this is a broken DT binding.
> >Bail out.
> >
> >>>>+	pm_runtime_get_sync(qspi->dev);
> >>>>+
> >>>>+	/* disable SCLK */
> >>>>+	dra7xxx_writel(qspi, dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG)
> >>>>+			&   ~QSPI_CLK_EN, QSPI_SPI_CLOCK_CNTRL_REG);
> >>>>+
> >>>>+	if (clk_div<   0) {
> >btw, add a space between clk_div and<
> >
> >>>>+			dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
> >>>>+			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
> >>>>+			dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
> >>>>+					QSPI_SPI_CMD_REG);
> >>>>+			status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> >>>>+			timeout =3D QSPI_TIMEOUT;
> >>>>+			while ((status&   QSPI_WC_BUSY) !=3D QSPI_XFER_DONE) {
> >>>do you really need to poll ? No IRQ available ?
> >>>
> >>There is an interrupt available, I will try using that.
> >look at how i2c-omap.c synchronizes interrupt with the transfer_msg
> >code. It just uses a wait_for_completion().
> >
> Ok.
> >>>>+static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
> >>>>+		struct spi_message *m)
> >>>>+{
> >>>>+	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> >>>>+	struct spi_device *spi =3D m->spi;
> >>>>+	struct spi_transfer *t;
> >>>>+	int status =3D 0;
> >>>>+	int flags =3D 0;
> >>>>+
> >>>>+	/* setup command reg */
> >>>>+	qspi->cmd =3D 0;
> >>>>+	qspi->cmd |=3D QSPI_WLEN(8);
> >>>>+	qspi->cmd |=3D QSPI_EN_CS(0);
> >>>>+	qspi->cmd |=3D 0xfff;
> >>Since, we dont know the number of frame lenght that need to be
> >>transferred and it comes from the spi framework, we keep the frame
> >>lenght to maximum.
> >>Then depending on the count value above in while loop, we terminate
> >>our trasnfer.
> >what ? seriously didn't get what you meant.
> >
> I mean, the lower 12 bits of cmd register is meant to be filled with
> frame lenght.
>=20
> But the frame lenght is parsed when you iterate the list. So, what is

which list ?

> done here is that
> the framelenght is kept to its maximum value.

why ? That seems wrong. If you can get the actual frame length at some
point, that's what you should use.

>=20
> Then, to signal the the end of the frame, we use
>=20
> static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, unsigned count,
>                         const u8 *txbuf, u8 *rxbuf, bool flags)
> {
>         uint status;
>         int timeout;
>=20
>         while (count--) {
>                 if (txbuf) {
>                         pr_debug("tx cmd %08x dc %08x data %02x\n",
>                                 qspi->cmd | QSPI_WR_SNGL, qspi->dc,
> *txbuf);
>                         dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
>                         dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
>                         dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
>                                         QSPI_SPI_CMD_REG);
>                         status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_RE=
G);
>                         timeout =3D QSPI_TIMEOUT;
>                         while ((status & QSPI_WC_BUSY) !=3D QSPI_XFER_DON=
E) {
>                                 if (--timeout < 0) {
>                                         pr_debug("QSPI tx timed out\n");
>                                         return
>=20
>      .............................
>=20
>                                    status, *(rxbuf-1));
>                 }
>         }
>=20
>         if (flags & XFER_END)
>                 dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL,
> QSPI_SPI_CMD_REG);
>=20
> }
> INVAL will terminate the current frame.

nevermind that this value is "RESERVED" on the documentation. You should
not rely on reserved features, they can go away at any point in time.

That's probably there only for some IP debugging kinda thing.

--=20
balbi

--NEaRsfQExFH3jWtg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0qv6AAoJEIaOsuA1yqREUHgP/39XjT3owSfpKDAoR+X2jOjP
GMDcIrB3H5kJlwj7GrV611u/ZlqWs9z8uzBNKg6DwI2IIQfhzj/fryLWGTDEzrs5
gzsMfrlQIL764qWwgUoeiahJcvgH4U3/cB7FGMxGxjJ74+225B/4zaPpkkefcj0/
80EEvmZQJDfqYM/YbBiVL1Ojz3ZFJSHwZ9QgyOUpf0J1+A1XzkO50QeVXUHAo/f8
sA4GLxFx25fvNFY5/hHioPgU9Fq4wBIvwXlvaIFibmtSJcVfNRFSJo3IQMUIPI51
0OoXhpqfsUiXK7x5sNfGe/3vSLd+OrSK7w4egDEMMTemmkYB8ELIQsUhekrOPyUH
WpihZBMORcTUxO04prY36a2Rpd8i5+92wvkicP+p4eeRFh9IF5HvvpYtR8wdjIwf
ER0gu+IV1gGtg0cSTrl6eT8zuIJ4j3PIGD+BrQatfhFw3yBOIjtusa76nzvKbXYn
Gopi08s2IPhf+Xrswkke69nXObvfWjAEy5j7w2ENELLYTt4S4ermu1X3c8/BVXzJ
NVDfGrXzsk0A7zw8hyn/6dD78izMDD0MMEzRxwJZS7SzhQYEPIt58/6k+Cg7AjVa
hRIFVjBHVkrA6ZqXnwr9mNco1tPvIZPuTDqPMEELVcdZ4YPWHINo5E34FRSyuUtZ
eeSW4xiVg630fc+TSw4T
=nHhg
-----END PGP SIGNATURE-----

--NEaRsfQExFH3jWtg--
