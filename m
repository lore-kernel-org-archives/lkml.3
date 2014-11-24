Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaKXTJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:09:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40893 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbaKXTJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:09:28 -0500
Date: Mon, 24 Nov 2014 13:09:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/4] i2c: omap: implement workaround for handling invalid
 BB-bit values
Message-ID: <20141124190937.GF25712@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-3-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <1416518925-20679-3-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 21, 2014 at 01:28:43AM +0400, Alexander Kochetkov wrote:
> In a multimaster environment, after IP software reset, BB-bit value doesn=
't
> correspond to the current bus state. It may happen what BB-bit will be 0,
> while the bus is busy due to another I2C master activity.
>=20
> Any transfer started when BB=3D0 and bus is busy wouldn't be completed by=
 IP
> and results in controller timeout. More over, in some cases IP could
> interrupt another master's transfer and corrupt data on wire.
>=20
> The commit implement method allowing to prevent IP from entering into
> "controller timeout" state and from "data corruption" state.
>=20
> The one drawback is the need to wait for 10ms before the first transfer.
>=20
> Tested on Beagleboard XM C.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>

we have a report from Kevin Hilman that this commit breaks OMAP3530, see
[1]

[1] http://storage.armcloud.us/kernel-ci/next/next-20141124/arm-omap2plus_d=
efconfig/boot-omap3-overo-tobi.log

> ---
>  drivers/i2c/busses/i2c-omap.c |  103 +++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 103 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index a021733..3ffb9c0 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -58,6 +58,9 @@
>  /* timeout for pm runtime autosuspend */
>  #define OMAP_I2C_PM_TIMEOUT		1000	/* ms */
> =20
> +/* timeout for making decision on bus free status */
> +#define OMAP_I2C_BUS_FREE_TIMEOUT (msecs_to_jiffies(10))
> +
>  /* For OMAP3 I2C_IV has changed to I2C_WE (wakeup enable) */
>  enum {
>  	OMAP_I2C_REV_REG =3D 0,
> @@ -210,6 +213,9 @@ struct omap_i2c_dev {
>  						 */
>  	u32			rev;
>  	unsigned		b_hw:1;		/* bad h/w fixes */
> +	unsigned		bb_valid:1;	/* true when BB-bit reflects
> +						 * the I2C bus state
> +						 */
>  	unsigned		receiver:1;	/* true when we're in receiver mode */
>  	u16			iestate;	/* Saved interrupt register */
>  	u16			pscstate;
> @@ -336,7 +342,10 @@ static int omap_i2c_reset(struct omap_i2c_dev *dev)
>  		/* SYSC register is cleared by the reset; rewrite it */
>  		omap_i2c_write_reg(dev, OMAP_I2C_SYSC_REG, sysc);
> =20
> +		/* Schedule I2C-bus monitoring on the next transfer */
> +		dev->bb_valid =3D 0;
>  	}
> +
>  	return 0;
>  }
> =20
> @@ -449,6 +458,11 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
>  	dev->scllstate =3D scll;
>  	dev->sclhstate =3D sclh;
> =20
> +	if (dev->rev < OMAP_I2C_OMAP1_REV_2) {
> +		/* Not implemented */
> +		dev->bb_valid =3D 1;
> +	}
> +
>  	__omap_i2c_init(dev);
> =20
>  	return 0;
> @@ -473,6 +487,91 @@ static int omap_i2c_wait_for_bb(struct omap_i2c_dev =
*dev)
>  	return 0;
>  }
> =20
> +/*
> + * Wait while BB-bit doesn't reflect the I2C bus state
> + *
> + * In a multimaster environment, after IP software reset, BB-bit value d=
oesn't
> + * correspond to the current bus state. It may happen what BB-bit will b=
e 0,
> + * while the bus is busy due to another I2C master activity.
> + * Here are BB-bit values after reset:
> + *     SDA   SCL   BB   NOTES
> + *       0     0    0   1, 2
> + *       1     0    0   1, 2
> + *       0     1    1
> + *       1     1    0   3
> + * Later, if IP detect SDA=3D0 and SCL=3D1 (ACK) or SDA 1->0 while SCL=
=3D1 (START)
> + * combinations on the bus, it set BB-bit to 1.
> + * If IP detect SDA 0->1 while SCL=3D1 (STOP) combination on the bus,
> + * it set BB-bit to 0 and BF to 1.
> + * BB and BF bits correctly tracks the bus state while IP is suspended
> + * BB bit became valid on the next FCLK clock after CON_EN bit set
> + *
> + * NOTES:
> + * 1. Any transfer started when BB=3D0 and bus is busy wouldn't be
> + *    completed by IP and results in controller timeout.
> + * 2. Any transfer started when BB=3D0 and SCL=3D0 results in IP
> + *    starting to drive SDA low. In that case IP corrupt data
> + *    on the bus.
> + * 3. Any transfer started in the middle of another master's transfer
> + *    results in unpredictable results and data corruption
> + */
> +static int omap_i2c_wait_for_bb_valid(struct omap_i2c_dev *dev)
> +{
> +	unsigned long bus_free_timeout =3D 0;
> +	unsigned long timeout;
> +	int bus_free =3D 0;
> +	u16 stat, systest;
> +
> +	if (dev->bb_valid)
> +		return 0;
> +
> +	timeout =3D jiffies + OMAP_I2C_TIMEOUT;
> +	while (1) {
> +		stat =3D omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
> +		/*
> +		 * We will see BB or BF event in a case IP had detected any
> +		 * activity on the I2C bus. Now IP correctly tracks the bus
> +		 * state. BB-bit value is valid.
> +		 */
> +		if (stat & (OMAP_I2C_STAT_BB | OMAP_I2C_STAT_BF))
> +			break;
> +
> +		/*
> +		 * Otherwise, we must look signals on the bus to make
> +		 * the right decision.
> +		 */
> +		systest =3D omap_i2c_read_reg(dev, OMAP_I2C_SYSTEST_REG);
> +		if ((systest & OMAP_I2C_SYSTEST_SCL_I_FUNC) &&
> +		    (systest & OMAP_I2C_SYSTEST_SDA_I_FUNC)) {
> +			if (!bus_free) {
> +				bus_free_timeout =3D jiffies +
> +					OMAP_I2C_BUS_FREE_TIMEOUT;
> +				bus_free =3D 1;
> +			}
> +
> +			/*
> +			 * SDA and SCL lines was high for 10 ms without bus
> +			 * activity detected. The bus is free. Consider
> +			 * BB-bit value is valid.
> +			 */
> +			if (time_after(jiffies, bus_free_timeout))
> +				break;
> +		} else {
> +			bus_free =3D 0;
> +		}
> +
> +		if (time_after(jiffies, timeout)) {
> +			dev_warn(dev->dev, "timeout waiting for bus ready\n");
> +			return -ETIMEDOUT;
> +		}
> +
> +		msleep(1);
> +	}
> +
> +	dev->bb_valid =3D 1;
> +	return 0;
> +}
> +
>  static void omap_i2c_resize_fifo(struct omap_i2c_dev *dev, u8 size, bool=
 is_rx)
>  {
>  	u16		buf;
> @@ -643,6 +742,10 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_m=
sg msgs[], int num)
>  	if (IS_ERR_VALUE(r))
>  		goto out;
> =20
> +	r =3D omap_i2c_wait_for_bb_valid(dev);
> +	if (r < 0)
> +		goto out;
> +
>  	r =3D omap_i2c_wait_for_bb(dev);
>  	if (r < 0)
>  		goto out;
> --=20
> 1.7.9.5
>=20

--=20
balbi

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc4JxAAoJEIaOsuA1yqREn80P/R4SWAUU9wUfc5Phef1ER+FY
Zljt2inZOvP+bvDqY4w1G3PVnLYt7kc4OaGfds1SbueGRry7V7UcvsgEj2BCUe75
P/nsiZCSPMHgft87PL/y01Eh2Jv8UFVIHPdi2Y9/mEhPZnMHxJk2Uc2lHeeM6N4Y
FgrOKgUiZpFrXG0UUEZi6QaFstZliuhiFBf0Nn/CwD+pvFynApMp8j/r8PjdYQO1
LxBVSlcShBEhYeaenIkFOGDrtZ2IwPzTOklMmYIuHLTBMa+W/GRkqapG8qqCDQvQ
7EDWxYIVk4TGul0F9shLHSmuTbocU6RJ2ALUMB+dprT3uqM/i/51UTu+FMeROjgb
VkTf0ppDKDjPv75Xq4qPJ4cekMuJhEQzhJUCswubThQYKB/yNyn8wJ/mmhNw9xUi
S5ZoNUEigGEcvONKBfnfmBY+ED5gaIUanijeMYRGC35LeAxIb5PjvWyGDGf0pJTg
vQEZy8XdCn0QCeyrXiDnCI3XJbXamzwXUO0hvXkEXUEKeG1SDaFgCryCQSpy2nrt
FirY0D2DW8wgSyFo0k8Ew++G6ZghbqaVyqajEOJwefV/iYS2kffHV0vxKVfNUdxb
bVoZW9oB2dux/5F0JOerwqCoK+gDF3GKyI9Wxvbc6fvDNaUSgAyVWc/q8fprRqzD
bs8g93Gfy6GTbPbG/xkO
=LGr1
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
