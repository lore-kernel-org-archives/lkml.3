Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3GRKYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:24:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36951 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab3GRKYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:24:17 -0400
Date: Thu, 18 Jul 2013 13:24:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130718102404.GH11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ah9ph+G2cWRpKogL"
Content-Disposition: inline
In-Reply-To: <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ah9ph+G2cWRpKogL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

it might be just me, but ...

On Thu, Jul 18, 2013 at 03:31:26PM +0530, Sourav Poddar wrote:
> +static inline unsigned long ti_qspi_readl_data(struct ti_qspi *qspi,
> +		unsigned long reg, int wlen)
> +{
> +	switch (wlen) {
> +	case 8:
> +		return readw(qspi->base + reg);
> +		break;
> +	case 16:
> +		return readb(qspi->base + reg);
> +		break;
> +	case 32:
> +		return readl(qspi->base + reg);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static inline void ti_qspi_writel_data(struct ti_qspi *qspi,
> +		unsigned long val, unsigned long reg, int wlen)
> +{
> +	switch (wlen) {
> +	case 8:
> +		writew(val, qspi->base + reg);
> +		break;
> +	case 16:
> +		writeb(val, qspi->base + reg);
> +		break;
> +	case 32:
> +		writeb(val, qspi->base + reg);
> +		break;
> +	default:
> +		dev_dbg(qspi->dev, "word lenght out of range");
> +		break;
> +	}
> +}

because of these two functions you have the hability to read/write
*more* than one byte, and yet ...

> +static void qspi_write_msg(struct ti_qspi *qspi, struct spi_transfer *t)
> +{
> +	const u8 *txbuf;
> +	int wlen, count;
> +
> +	count =3D t->len;
> +	txbuf =3D t->tx_buf;
> +	wlen =3D t->bits_per_word;
> +
> +	while (count--) {
> +		dev_dbg(qspi->dev, "tx cmd %08x dc %08x data %02x\n",
> +			qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
> +		ti_qspi_writel_data(qspi, *txbuf++, QSPI_SPI_DATA_REG, wlen);

you always increment by each byte. Here, if you used writel(), you wrote
4 bytes and should increment txbuf by 4. Same goes for read_data(),
below. Another thing. Even though your wlen might be 8 bits, if you
write 4 bytes to write, you can save a few CPU cycles by using writel().

You only use writew() if you have exactly 2 bytes to write and writeb()
if you have exactly 1 byte to write. 3 bytes we'll be left as an
exercise.

> +static int ti_qspi_start_transfer_one(struct spi_master *master,
> +		struct spi_message *m)
> +{
> +	struct ti_qspi *qspi =3D spi_master_get_devdata(master);
> +	struct spi_device *spi =3D m->spi;
> +	struct spi_transfer *t;
> +	int status =3D 0, ret;
> +	int frame_length;
> +
> +	/* setup device control reg */
> +	qspi->dc =3D 0;
> +
> +	if (spi->mode & SPI_CPHA)
> +		qspi->dc |=3D QSPI_CKPHA(spi->chip_select);
> +	if (spi->mode & SPI_CPOL)
> +		qspi->dc |=3D QSPI_CKPOL(spi->chip_select);
> +	if (spi->mode & SPI_CS_HIGH)
> +		qspi->dc |=3D QSPI_CSPOL(spi->chip_select);
> +
> +	frame_length =3D DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
> +				spi->bits_per_word);

this calculation doesn't look correct.

	(m->frame_length * spi->bits_per_word) /
		spi->bits_per_word =3D m->frame_length

What are you trying to achieve here ? frame_length should be counted in
words right ? And we get that value in bytes. So what's the best
calculation to convert bytes into words ? If you have 8 bits_per_word
you don't need any calculation, but if you have 32 bits_per_word, you
_do_ need something.

How will you achieve the number you want ? (hint: 1 byte =3D=3D 8 bits)

And btw, all of these mistakes pretty much tell me that this driver
hasn't been tested. How have you tested this driver ? Is your spansion
memory accessed with 8 bits_per_word only ? Is there anyway to use
32 bits_per_word with that device ? That would uncover quite a few
mistakes in $subject.

--=20
balbi

--Ah9ph+G2cWRpKogL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR58JDAAoJEIaOsuA1yqREd4IP/0hO3zH0hK2xkDrc35yIeMEt
MEIXOLl4Qhj4rl1YSVqHV7OwUFeOqOng2PniJp9ui+WaB/SGCp9iMrIM32ragTQk
XuF48EBgX+cxNVhBJJ2Bvhhbk5jkqPvZPxGoJlLtqC/yG7wRE6WRPzq5BbR8y4PS
hpa21rpyWgwgjd2sqkIoWp2QcZCwAmc6z2awYB7KdHBBhOVX6oPokHlHDVWoPanr
1MVB9c/QKBYeE1sXivA9TZ0IvYhXXePthQMN65xodcKg5C6Ag/xBYXQcOlFZl5DV
FNBJ5eMlEcnp5BZOsackiOSbenXsJgTCLhNpzSJbnnMpZ5Ma2EpqRZIsb6AJ66s+
COcq8WVUHCqH//J9726mcVnmpcy3ua9TZJ6cP+Og80xXNjoT4Vdm1PU29St+x06Z
9UoKebcWaz0hvhQSUyGC3fcsst2VIm6GrOnyeZc3AMO0DTVr5+Kq7Kv9LPoC6dRF
LZh1om2DyOWcCsFo7bO+WoZv2LLlildm9EM7+cBoQq75zfmekjiNFJyZlqZ841bP
qjM1d4LAuN0S80DRj8htSUeSUvGXFWG7RMvqq9dcSYWtdXywjyhWj1EjDnlF/qVG
TOKfZjOD9r9k6sPhZAXPG50bRK3IVRePrxyD0rTzZvr/xbOZdu/hKSd8As9E5NRG
SNSxQ2QCAdai7Gm9H1wx
=jHvY
-----END PGP SIGNATURE-----

--Ah9ph+G2cWRpKogL--
