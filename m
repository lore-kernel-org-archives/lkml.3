Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3DANML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:12:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46566 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503Ab3DANMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:12:09 -0400
Date: Mon, 1 Apr 2013 14:12:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Subject: Re: [PATCH V3 2/5] spi: s3c64xx: added support for polling mode
Message-ID: <20130401131207.GI18636@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
 <1363157014-9615-3-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IR1Y5IvQhrKgS4e6"
Content-Disposition: inline
In-Reply-To: <1363157014-9615-3-git-send-email-ks.giri@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IR1Y5IvQhrKgS4e6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 12:13:31PM +0530, Girish K S wrote:

> Some SoC's that adopt this controller might not have have dma
> interface. This patch adds support for complete polling mode
> and gives flexibity for the user to select poll/dma mode.

Ouch, that sounds like a regression.

> @@ -419,6 +422,27 @@ static inline void enable_cs(struct s3c64xx_spi_driv=
er_data *sdd,
> =20
>  	cs =3D spi->controller_data;
>  	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
> +
> +	/* Start the signals */
> +	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
> +}
> +

This looks odd and not obviously related to the rest of the change -
does it belong as part of some of your other commits adding support for
using the controller /CS functionality?  In general it feels like this
ought to be broken down a bit - there's some refactoring as well as the
new functionality.

> +static u32 wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
> +					int timeout_ms)
> +{
> +	void __iomem *regs =3D sdd->regs;
> +	unsigned long val;
> +	u32 status;
> +	/* max fifo depth available */
> +	u32 max_fifo =3D (FIFO_LVL_MASK(sdd) >> 1) + 1;
> +
> +	val =3D msecs_to_loops(timeout_ms);
> +	do {
> +		status =3D readl(regs + S3C64XX_SPI_STATUS);
> +	} while (RX_FIFO_LVL(status, sdd) < max_fifo && --val);
> +
> +	/* return the actual received data length */
> +	return RX_FIFO_LVL(status, sdd);

This is really wait_for_fifo_empty_with_timeout() isn't it?  It feels
like there ought to be at least a cpu_relax() in the busy wait too.

> +		/*
> +		 * If the receive length is bigger than the controller fifo
> +		 * size, calculate the loops and read the fifo as many times.
> +		 * loops =3D length / max fifo size (calculated by using the
> +		 * fifo mask).
> +		 * For any size less than the fifo size the below code is
> +		 * executed atleast once.
> +		 */
> +		loops =3D xfer->len / ((FIFO_LVL_MASK(sdd) >> 1) + 1);
> +		buf =3D xfer->rx_buf;
> +		do{

Coding style.

> -	if (!sdd->pdev->dev.of_node) {
> +	if (!sdd->pdev->dev.of_node && !is_polling(sdd)) {
>  		res =3D platform_get_resource(pdev, IORESOURCE_DMA,  0);
>  		if (!res) {
>  			dev_err(&pdev->dev, "Unable to get SPI tx dma "

It seems like it'd be sensible to also handle failure to get the DMA
resource by going into polling mode.

--IR1Y5IvQhrKgS4e6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWYefAAoJELSic+t+oim9FHUQAJdHdn7vjn7iRARnpeZDFs1i
qW/0LnIE23mCoBJdpDasGfEP11NWkQ08P8aJRHIi2UX/k6y7YJ1UavMRW1NZXnlg
6SapeuKjGx05mY5aWTtYCYMVzckTT1n8JxOVen3HAbhs29XtN2XDBH2duaxhjfqB
egbVWdrHZVi6/09BILpuSqqjvI+yGJFD4Vx7HeHOVB0K0dDBWOKsmMha1p2/GgHq
twFYV6C6gXxrNZGQSjLHkfCtxbBCsbPJJz4CxWpHCQPHJVGERkJDbUV85avifLtp
rSe4BlThlmfONQxuVUQ0nnIgEWWCu9T/VTWotXQuLO9ZNrEOjRToAcoWRkZTCABC
IIW3+g2BjFXh7gAhN5tgQ6VS/oSw7J5FT9D52Ly8rnpc7kw/Uohr8jYfxLgr1XMA
vfkY/3fbOpS+w4EvdPj1hu445zkK1VAXZfuNGCleYVUZu2KkVD2Qk65aQlNSyOrH
7X0SHH7O6d3r2EpZeyb7iLqFR/vukWtpfakQfpa6o5lfCcbHHExJJ4REobVIroiy
fk/W/bVgi1ZRYNb7RVtuoptvVpo7X3U5t3XKBfKwTTzXwYFEQeAUgB8z/Gg+F7p5
UUoLqEQoGhZoYW6W4Yha1yWBZpg6/OM21q7zHGxv1tQIYcHuT63wpD7/ZRnplkZV
6ou+vNJVF2Nt/ZJ/8Suv
=Ba8B
-----END PGP SIGNATURE-----

--IR1Y5IvQhrKgS4e6--
