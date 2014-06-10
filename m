Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaFJT1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:27:16 -0400
Received: from sauhun.de ([89.238.76.85]:37726 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaFJT1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:27:14 -0400
Date: Tue, 10 Jun 2014 21:27:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v5] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Message-ID: <20140610192709.GA3122@katana>
References: <5192968.EzcUiXba22@typ>
 <1956748.HoDAyYWJMb@typ>
 <10794912.fZysmMBNIZ@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <10794912.fZysmMBNIZ@typ>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jun 07, 2014 at 07:36:19PM +0200, Max Schwarz wrote:
> Driver for the native I2C adapter found in Rockchip RK3xxx SoCs.
>=20
> Configuration is only possible through devicetree. The driver is
> interrupt driven and supports the I2C_M_IGNORE_NAK mangling bit.
>=20
> Signed-off-by: Max Schwarz <max.schwarz@online.de>

Checking if the spinlock is needed would be nice, but we can also fix
this later. Besides this, my code-checkers say:

    CHECKPATCH
CHECK: Logical continuations should be on the previous line
#615: FILE: drivers/i2c/busses/i2c-rk3x.c:470:
+	if (num >=3D 2 && msgs[0].len < 4
+	    && !(msgs[0].flags & I2C_M_RD)

CHECK: Logical continuations should be on the previous line
#616: FILE: drivers/i2c/busses/i2c-rk3x.c:471:
+	    && !(msgs[0].flags & I2C_M_RD)
+	    && (msgs[1].flags & I2C_M_RD)) {

    SPARSE
drivers/i2c/busses/i2c-rk3x.c:173:20: warning: Using plain integer as NULL =
pointer
drivers/i2c/busses/i2c-rk3x.c:664:45: warning: Using plain integer as NULL =
pointer
drivers/i2c/busses/i2c-rk3x.c:735:9: warning: cast removes address space of=
 expression
    SMATCH
drivers/i2c/busses/i2c-rk3x.c:592 rk3x_i2c_xfer() error: double unlock 'spi=
n_lock:&i2c->lock'
    SPATCH
drivers/i2c/busses/i2c-rk3x.c:366:1-10: WARNING: Assignment of bool to 0/1
drivers/i2c/busses/i2c-rk3x.c:187:2-11: WARNING: Assignment of bool to 0/1
  CC      drivers/i2c/busses/i2c-rk3x.o
drivers/i2c/busses/i2c-rk3x.c: In function 'rk3x_i2c_irq':
drivers/i2c/busses/i2c-rk3x.c:336:15: warning: 'val' may be used uninitiali=
zed in this function [-Wuninitialized]
drivers/i2c/busses/i2c-rk3x.c:321:15: note: 'val' was declared here

The smatch warning may be a false positive, please check. The gcc warning i=
s a
false positive but to prevent people from sending fixup patches, please do
something like commit a55b44ac3fe0.

> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> new file mode 100644
> index 0000000..7a430f4
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -0,0 +1,769 @@
> +/*
> + * Driver for I2C adapter in Rockchip RK3xxx SoC
> + *
> + * Max Schwarz <max.schwarz@online.de>
> + * based on the patches by Rockchip Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +

No empty line here.

> +#include <linux/i2c.h>
> +#include <linux/time.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/spinlock.h>
> +#include <linux/clk.h>
> +#include <linux/wait.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>

Do you really need delay.h and time.h? Look like leftovers to me.

> +/**
> + * Generate a START condition, which triggers a REG_INT_START interrupt.
> + */
> +static void rk3x_i2c_start(struct rk3x_i2c *i2c)
> +{
> +	u32 val;
> +
> +	dev_dbg(i2c->dev, "start\n");

I think this debug could go now, or?

> +
> +	rk3x_i2c_clean_ipd(i2c);
> +	i2c_writel(i2c, REG_INT_START, REG_IEN);
> +
> +	/* enable adapter with correct mode, send START condition */
> +	val =3D REG_CON_EN | REG_CON_MOD(i2c->mode) | REG_CON_START;
> +
> +	/* if we want to react to NACK, set ACTACK bit */
> +	if (!(i2c->msg->flags & I2C_M_IGNORE_NAK))
> +		val |=3D REG_CON_ACTACK;
> +
> +	i2c_writel(i2c, val, REG_CON);
> +}

=2E..

> +
> +static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
> +{
> +	unsigned int len =3D i2c->msg->len - i2c->processed;
> +	u32 con;
> +
> +	con =3D i2c_readl(i2c, REG_CON);
> +
> +	/*
> +	 * The hw can read up to 32 bytes at a time. If we need more than one
> +	 * chunk, send an ACK after the last byte of the current chunk.
> +	 */
> +	if (unlikely(len > 32)) {
> +		len =3D 32;
> +		con &=3D ~REG_CON_LASTACK;
> +	} else {
> +		con |=3D REG_CON_LASTACK;
> +	}

This is a bit confusing also due to the description of this bit:
"/* 1: do not send ACK after last receive */"

It means not only don't send ACK, but merely do send NACK (to signal end of
read). I though "not send ack" means clock stretching so I was wondering. M=
aybe
needs some rewording.

> +
> +	/* make sure we are in plain RX mode if we read a second chunk */
> +	if (i2c->processed !=3D 0) {
> +		con &=3D ~REG_CON_MOD_MASK;
> +		con |=3D REG_CON_MOD(REG_CON_MOD_RX);
> +	}
> +
> +	i2c_writel(i2c, con, REG_CON);
> +	i2c_writel(i2c, len, REG_MRXCNT);
> +}
> +

Thanks, I think we're very close to go...

   Wolfram


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTl1wMAAoJEBQN5MwUoCm2D/YQAKPh43T/DiiswA0UVK9Isf+j
m1/BdVvdP4zJBKmXH13WCazMhkhU15rFl+RxuJCwL3obfLs2mNaMaL68+gFl9lu2
H4KCJvejZy1DL5BPGSLrCVsI5Pasvo5o7uk8BJwFEhWOHydOdeVyZ/9fyat+ThZn
tRXv7f7grVL8J4Wg9/0sQ5gYB5oeTq6uXSdIMAGm2mcSTLJa9xqCt3kPWK2FX75D
g79wJ74FgY5AKpS7zwHk7V/oroBbbmhfUBDMIt66L4hp1zy9wJ89H8z9TlSkpdq3
aFFyT6WtkgJQgzxfvoko3dXsf/9HgyRQNJ7LfpxR3001nmdluVUVhQ9/eEehWeJV
vYnovvBWTyAMPKW2od9vNRnwTczNB8U0tni8iM6gxsYsVxUsiu05r82RFeIqQGeO
TsHqwTjqbo23PWzcPkRkcQLzZjPyag/mHDRDzQBLt7nupj8jq0G2weHPDXhSpQKf
rUKHDLb1c4di5J/+J+xQjRekZHZT+RSpBZKoRVN6lwD3cQmRVe0x2EpNAQwlpnUu
82CsZzPh91kSFhrQOsgp97bKFy8pRR00o7PXRHTNEtbkJFgAJjTBjSaN3jTCZsBx
abMYJVBOXYdQMtglluk+zLKFTzqEbBS3T5KARKPluh+cxCtuQFuDHYaDGyQMomHi
GUvRr8SYTlkEvg8Ctayv
=AlKq
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
