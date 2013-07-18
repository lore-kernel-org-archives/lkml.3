Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3GRLZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:25:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33280 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab3GRLZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:25:12 -0400
Date: Thu, 18 Jul 2013 14:24:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <balbi@ti.com>, <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130718112458.GJ11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718102404.GH11251@arwen.pp.htv.fi>
 <51E7CF11.5030301@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8cpS+6Cx+xtICsjy"
Content-Disposition: inline
In-Reply-To: <51E7CF11.5030301@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8cpS+6Cx+xtICsjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 04:48:41PM +0530, Sourav Poddar wrote:
> >>+static void qspi_write_msg(struct ti_qspi *qspi, struct spi_transfer *=
t)
> >>+{
> >>+	const u8 *txbuf;
> >>+	int wlen, count;
> >>+
> >>+	count =3D t->len;
> >>+	txbuf =3D t->tx_buf;
> >>+	wlen =3D t->bits_per_word;
> >>+
> >>+	while (count--) {
> >>+		dev_dbg(qspi->dev, "tx cmd %08x dc %08x data %02x\n",
> >>+			qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
> >>+		ti_qspi_writel_data(qspi, *txbuf++, QSPI_SPI_DATA_REG, wlen);
> >you always increment by each byte. Here, if you used writel(), you wrote
> >4 bytes and should increment txbuf by 4.
>=20
> hmm..got this point. Yes, my mistake, here I agree if wlen is not 8 bits
> txbuf++ is not valid.
> >  Same goes for read_data(),
> >below. Another thing. Even though your wlen might be 8 bits, if you
> >write 4 bytes to write, you can save a few CPU cycles by using writel().
> >
> Do you mean 4 words of 8 bits?

yeah. Say you have wlen =3D 8 but the transfer length is 8 bytes (64
bits). If you use writeb(), you will do 8 writes, if you use writel()
you'll do 2 writes.

> >>+static int ti_qspi_start_transfer_one(struct spi_master *master,
> >>+		struct spi_message *m)
> >>+{
> >>+	struct ti_qspi *qspi =3D spi_master_get_devdata(master);
> >>+	struct spi_device *spi =3D m->spi;
> >>+	struct spi_transfer *t;
> >>+	int status =3D 0, ret;
> >>+	int frame_length;
> >>+
> >>+	/* setup device control reg */
> >>+	qspi->dc =3D 0;
> >>+
> >>+	if (spi->mode&  SPI_CPHA)
> >>+		qspi->dc |=3D QSPI_CKPHA(spi->chip_select);
> >>+	if (spi->mode&  SPI_CPOL)
> >>+		qspi->dc |=3D QSPI_CKPOL(spi->chip_select);
> >>+	if (spi->mode&  SPI_CS_HIGH)
> >>+		qspi->dc |=3D QSPI_CSPOL(spi->chip_select);
> >>+
> >>+	frame_length =3D DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
> >>+				spi->bits_per_word);
> >this calculation doesn't look correct.
> >
> >	(m->frame_length * spi->bits_per_word) /
> >		spi->bits_per_word =3D m->frame_length
> >
> >What are you trying to achieve here ? frame_length should be counted in
> >words right ? And we get that value in bytes. So what's the best
> >calculation to convert bytes into words ? If you have 8 bits_per_word
> >you don't need any calculation, but if you have 32 bits_per_word, you
> >_do_ need something.
> >
> Yes, just derive this formulae with 8 bits per word in mind.
> Will change.
> It should be (m->frame_length * 8) / spi->bits_per_word

right on. To make sure this will execute a little faster (you never know
what several different versions of GCC will do), instead of multiplying
by 8, left shift by 3.

> >How will you achieve the number you want ? (hint: 1 byte =3D=3D 8 bits)
> >
> >And btw, all of these mistakes pretty much tell me that this driver
> >hasn't been tested. How have you tested this driver ?
> After bootup, I checked for deive detting enumerated as /proc/mtd.
> After which I am using mtdutils(erase, dump and write utilied to
> check for the communication with the flash device.)

alright, make that clear in your commit log.

--=20
balbi

--8cpS+6Cx+xtICsjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR59CKAAoJEIaOsuA1yqREi6UQAKK8mB1uaKjGbfzz/HtObff3
/J4OHd43TSb4dwxzP5YAtMPWo+q84x90kBgPl6Eleej6biVegF/lPw1LS00ZBQw2
dVChiGwj/snnX44EalD/ppVSiQbTyjiMn2vbkPxSz2Bu8NMPxaQUaf7h8jUFRSpo
1kzhRsPJ1bObEhUIR1rpr4i19NSk/oTP9L/tMuTGseiAs+aWCE3Y/wP8Je1u8/GV
osBC8Ewmr2dQ/FAWMtNZ3uQNB+hIEM6xRwk9sKvVajPuacWU65iRkcJC40fditS+
4oSo44aasQ13yt50zdoHkOD4Z6g4feYoWYpNmvjq4LH3b1Jp/z1aXxD3U4Inr8xK
CWEebzYk6wctcu5mhGbu2axBsysKKBowmLIVkXGlUo9jJZBiltzdzBdzuZO9Vjwp
zgX4l7bhqTMylcFBTrkVjtTYuKp0fS8Ni+7+H5HtbUbaJ09sWlZLvMnhAo+ZEz6d
nqTlgGPRB8X/CEeX5usa4kKnz2GmKSy/J8Y06ME2g5Juc3DHJJh1hIeoE6fetAx1
zlKynd5Xb7uERkYN2Vk+w22cUeC/YFkWsHp3DfoZjf3ihNf7DE6BjKPXxtjO1r7u
QkK6y4Ww0ZIbFTcCgSiZrmEgmhpJbNoMKH9HauQevYvJ/s7+wFk5rhDs7Oa+NZ9X
u1R/9vp1o527SR8c+VM7
=hjgP
-----END PGP SIGNATURE-----

--8cpS+6Cx+xtICsjy--
