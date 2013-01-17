Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3AQKdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:33:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40389 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab3AQKda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:33:30 -0500
Date: Thu, 17 Jan 2013 12:32:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: <linux-i2c@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>, <dirk.brandewie@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] i2c-designware: always set the STOP bit after last
 byte
Message-ID: <20130117103248.GL10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358418667-4533-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ll0BBk1HBk/f94B0"
Content-Disposition: inline
In-Reply-To: <1358418667-4533-3-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ll0BBk1HBk/f94B0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 17, 2013 at 12:31:05PM +0200, Mika Westerberg wrote:
> If IC_EMPTYFIFO_HOLD_MASTER_EN is set to one, the DesignWare I2C controll=
er
> doesn't generate STOP on the bus when the FIFO is empty. This violates the
> rules of Linux I2C stack as it requires that the STOP is issued once the
> i2c_transfer() is finished.
>=20
> However, there is no way to detect this from the hardware registers, so we
> must make sure that the STOP bit is always set once the last byte of the
> last message is transferred.
>=20
> This patch is based on the work of Dirk Brandewie.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-core.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busse=
s/i2c-designware-core.c
> index f5258c2..94fd818 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -413,11 +413,23 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
>  		rx_limit =3D dev->rx_fifo_depth - dw_readl(dev, DW_IC_RXFLR);
> =20
>  		while (buf_len > 0 && tx_limit > 0 && rx_limit > 0) {
> +			u32 cmd =3D 0;
> +
> +			/*
> +			 * If IC_EMPTYFIFO_HOLD_MASTER_EN is set we must
> +			 * manually set the stop bit. However, it cannot be
> +			 * detected from the registers so we set it always
> +			 * when writing/reading the last byte.
> +			 */
> +			if (dev->msg_write_idx =3D=3D dev->msgs_num - 1 &&
> +			    buf_len =3D=3D 1)
> +				cmd |=3D BIT(9);
> +
>  			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
> -				dw_writel(dev, 0x100, DW_IC_DATA_CMD);
> +				dw_writel(dev, cmd | 0x100, DW_IC_DATA_CMD);
>  				rx_limit--;
>  			} else
> -				dw_writel(dev, *buf++, DW_IC_DATA_CMD);
> +				dw_writel(dev, cmd | *buf++, DW_IC_DATA_CMD);

also need to send STP bit if I2C_M_STOP is set.

--=20
balbi

--Ll0BBk1HBk/f94B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ99NQAAoJEIaOsuA1yqRE+ekP/il52M61T5a1iZfps4KYYq52
PWYtSz1qdI6PH6bqaZaAFtU6luxw3x485nDxscq8X5ybtmmY3i+0JcFm8fgyz0LH
3aNRq59KAb5c8aOPO/iOc6SrPINCfM2Azy6VkSFLElkntIo36oZcMR33Dq/Y9R1D
iIOGR9VYTrbh4fROz7xa5Dad6hzjfctKdUuade1bGYPJQw3yPFhB1kL+J1bRIssG
9uFmqxd9Aj4awM+2lPtuY50U02jrSW8aU9NHfyOyGq3lNfWehdJK6IX3f16MTFKC
SrcakoZT8cMO3SVUwqfc4OZ8gggf8ncSWUGueeYCKDPF7Rf7bhASPCZItL024wXc
qGETHojqsHG37kiwNgWYqo7wSlrredzDzw/lMm/7KhkluaFldaSx3Cm0MA8W0Ndu
yCGtpEVJHGnSizy9RFShiABONkmAvUcvqHLbrmqakKM2nJAQkGK5xOCv+UxH2K9l
XKxraUYZNwEjxTslmxzSzziYk9qafuh8M2xjwEqvv5OTJMEGm+GhwV0lpWOTJfNi
GOb1kbRXbSjYhIIa7hPA53yvVEgE4LWsI5ce1s6g7T7RYGstLBDHotRv2zOLpQiH
6FfGZZ7LF+kVQLbWgCik2C5GHfvzP14IoefVpcz7tlMt78pFPjzf2LOPyNgy9w3B
VsEKLgJPdlTMGigLj6DR
=y9jd
-----END PGP SIGNATURE-----

--Ll0BBk1HBk/f94B0--
