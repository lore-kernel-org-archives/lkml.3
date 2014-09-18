Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaIRMD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:03:28 -0400
Received: from sauhun.de ([89.238.76.85]:40947 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaIRMD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:03:26 -0400
Date: Thu, 18 Sep 2014 14:03:45 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: algos: add support for sc18im700 master i2c bus
 with uart interface
Message-ID: <20140918120345.GC2240@katana>
References: <1402339527-5390-1-git-send-email-ravi23ganiga@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SnV5plBeK2Ge1I9g"
Content-Disposition: inline
In-Reply-To: <1402339527-5390-1-git-send-email-ravi23ganiga@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

thanks for the submission.

On Tue, Jun 10, 2014 at 12:15:27AM +0530, Raghavendra Ganiga wrote:
> This is a patch to add i2c algorith  support for nxp sc18im700
> master i2c bus controller with uart interface

Is this algorithm really shared between various controllers? If not, it
makes sense to combine the algorithm and adapter driver into one source
file. Speaking of: where is one adapter driver for this algorithm?

As a result, this is not a full review. I'd need some code using this
algorithm for an adapter.

> diff --git a/drivers/i2c/algos/i2c-algo-sc18im700.c b/drivers/i2c/algos/i=
2c-algo-sc18im700.c
> new file mode 100644
> index 0000000..cf73aad
> --- /dev/null
> +++ b/drivers/i2c/algos/i2c-algo-sc18im700.c
> @@ -0,0 +1,274 @@
> +/*
> + *  i2c-algo-sc18im700.c i2c driver algorithms for SC18IM700 adapters
> + *  Master I2C bus with UART interface
> + *
> + *  Copyright (C) 2014 Raghavendra Chandra Ganiga <ravi23ganiga@gmail.co=
m>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> + *  MA 02110-1301 USA.

Skip the address

> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-algo-sc18im700.h>
> +
> +#define DEB1(x) if (i2c_debug >=3D 1) x

Simply use dev_dbg instead of DEB1.

> +static int sc18im_init(struct i2c_adapter *adap)
> +{
> +	struct i2c_algo_sc18imdata *algo_data =3D adap->algo_data;
> +	unsigned char data;
> +
> +	sc18im_reset(algo_data);
> +
> +	/* after reset sc18im700 gives out
> +	 * OK response in ascii format
> +	 */
> +	get_sc18im(algo_data, &data);
> +	if (data !=3D 'O') {
> +		DEB1(printk(KERN_ERR
> +		"i2c algo sc18im700: Reset response OK not received\n"));
> +
> +		return -ENXIO;
> +	}
> +
> +	get_sc18im(algo_data, &data);
> +	if (data !=3D 'K') {
> +		DEB1(printk(KERN_ERR
> +		"i2c algo sc18im700: Reset response OK not received\n"));
> +
> +		return -ENXIO;
> +	}
> +
> +	switch (algo_data->clock_freq) {
> +	case I2C_SC18IM_369KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 369 KHz\n");
> +		break;
> +	case I2C_SC18IM_246KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 246 KHz\n");
> +		break;
> +	case I2C_SC18IM_147KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 147 KHz\n");
> +		break;
> +	case I2C_SC18IM_123KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 123 KHz\n");
> +		break;
> +	case I2C_SC18IM_74KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 74 KHz\n");
> +		break;
> +	case I2C_SC18IM_61KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 61 KHz\n");
> +		break;
> +	case I2C_SC18IM_37KHZ:
> +		printk(KERN_INFO
> +			"i2c algo sc18im700: Clock frequency is 37 KHz\n");
> +		break;

So many strings. The frequency values look simply linear, so you should
be able to print out:

	dev_info(your_device, "Clock frequency is %u\n", your_formula);


> +	default:
> +		printk(KERN_WARNING
> +			"i2c algo sc18im700: Invalid Freq: Clock: 37 KHz\n");
> +		algo_data->clock_freq =3D I2C_SC18IM_37KHZ;
> +	}
> +
> +	/* passed clock frequency is divided into
> +	 * half and stored in clock high and clock
> +	 * low to achieve the desired clock frequency
> +	 */
> +	data =3D algo_data->clock_freq / 2;
> +
> +	sc18im_write_reg(algo_data, SC18IM_I2C_CLK_LOW, data);
> +	sc18im_write_reg(algo_data, SC18IM_I2C_CLK_HIGH, data);
> +
> +	data =3D sc18im_get_own_addr(algo_data);
> +	sc18im_write_reg(algo_data, SC18IM_I2CADDR, data);
> +
> +	printk(KERN_DEBUG "i2c algo sc18im700: detected and initialized\n");
> +
> +	return 0;
> +}
> +
> +static const struct i2c_algorithm sc18im_algo =3D {
> +	.master_xfer	=3D sc18im_xfer,
> +	.functionality	=3D sc18im_functionality,
> +};
> +
> +/*
> + * registering functions to load algorithms at runtime
> + */
> +int i2c_sc18im_add_bus(struct i2c_adapter *adap)
> +{
> +	int ret;
> +
> +	adap->algo =3D &sc18im_algo;
> +
> +	ret =3D sc18im_init(adap);
> +	if (ret)
> +		return ret;
> +
> +	return i2c_add_adapter(adap);
> +}
> +EXPORT_SYMBOL(i2c_sc18im_add_bus);
> +
> +int i2c_sc18im_add_numbered_bus(struct i2c_adapter *adap)
> +{
> +	int ret;
> +
> +	adap->algo =3D &sc18im_algo;
> +
> +	ret =3D sc18im_init(adap);
> +	if (ret)
> +		return ret;
> +
> +	return i2c_add_numbered_adapter(adap);
> +}
> +EXPORT_SYMBOL(i2c_sc18im_add_numbered_bus);
> +
> +module_param(i2c_debug, int, S_IRUGO | S_IWUSR);
> +
> +MODULE_PARM_DESC(i2c_debug, "debug level - 0 - off, 1 - more verbose");

As said above, simply use dev_dbg.

> +MODULE_DESCRIPTION("SC18IM700 I2C Algorithm Driver");
> +MODULE_AUTHOR("Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/i2c-algo-sc18im700.h b/include/linux/i2c-algo-=
sc18im700.h
> new file mode 100644
> index 0000000..231dbd2
> --- /dev/null
> +++ b/include/linux/i2c-algo-sc18im700.h
> @@ -0,0 +1,81 @@
> +/*
> + *  i2c-algo-sc18im700.c i2c driver algorithms header file
> + *
> + *  Copyright (C) 2014 Raghavendra Chandra Ganiga <ravi23ganiga@gmail.co=
m>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> + *  MA 02110-1301 USA.

Skip the address here, too.

> + */
> +
> +#ifndef _LINUX_I2C_ALGO_SC18IM700_H
> +#define _LINUX_I2C_ALGO_SC18IM700_H
> +
> +/* SC18IM700 Internal Registers */
> +
> +#define SC18IM_BRG0		0x00
> +#define SC18IM_BRG1		0x01
> +#define SC18IM_PORT_CONF1	0x02
> +#define SC18IM_PORT_CONF2	0x03
> +#define SC18IM_IOSTATE		0x04
> +#define SC18IM_I2CADDR		0x06
> +#define SC18IM_I2C_CLK_LOW	0x07
> +#define SC18IM_I2C_CLK_HIGH	0x08
> +#define SC18IM_I2CTO		0x09
> +#define SC18IM_I2CSTATUS	0x0A
> +
> +/* SC18IM700 I2C Commands */
> +
> +#define SC18IM_START		0x53
> +#define SC18IM_STOP		0x50
> +#define SC18IM_REG_READ		0x52
> +#define SC18IM_REG_WRITE	0x57
> +#define SC18IM_READ_GPIO	0x49
> +#define SC18IM_WRITE_GPIO	0x4F
> +#define SC18IM_POWER_DOWN	0x5A
> +
> +/* SC18IM700 I2C Clock frequencies */
> +
> +#define I2C_SC18IM_369KHZ	0x0A
> +#define I2C_SC18IM_246KHZ	0x0F
> +#define I2C_SC18IM_147KHZ	0x19
> +#define I2C_SC18IM_123KHZ	0x1E
> +#define I2C_SC18IM_74KHZ	0x32
> +#define I2C_SC18IM_61KHZ	0x3C
> +#define I2C_SC18IM_37KHZ	0x64
> +
> +/* SC18IM700 I2C TRANSACTION STATUS */
> +
> +#define I2C_SC18IM_OK		0xF0
> +#define I2C_SC18IM_NACK_ADDR	0xF1
> +#define I2C_SC18IM_NACK_DATA	0xF2
> +#define I2C_SC18IM_TMOUT	0xF8
> +
> +struct i2c_algo_sc18imdata {
> +	/* private low level data */
> +	void		*data;
> +	unsigned char	clock_freq;
> +
> +	void (*set_data) (void *data, unsigned char value);
> +	int (*get_data) (void *data, unsigned char *buff);
> +	void (*reset) (void *data);
> +	unsigned char (*get_own_addr) (void *data);
> +	void (*xfer_begin) (void *data);
> +	void (*xfer_end) (void *data);
> +};
> +
> +int i2c_sc18im_add_bus(struct i2c_adapter *);
> +int i2c_sc18im_add_numbered_bus(struct i2c_adapter *);
> +
> +#endif /* _LINUX_I2C_ALGO_SC18IM700_H */
> --=20
> 1.9.1
>=20

--SnV5plBeK2Ge1I9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGsogAAoJEBQN5MwUoCm2MkIP/i7ZOpNwLnWYHRq7PChreZOi
q5Kb4RFqDjX85fV3Szjrd9q12+yPz2AiFL3QuzkCMWvsOP2C9VZtwYJfvYRJ//es
zlyB1fqKCxpCSNQKxegWcaHLc5MMCClVwcJxVz8rrRsgr2XX+3NCgBx+n7BdqQkC
IhfwrtvG2Nl6Wc6GCbwzQQ2njlAqjhCG4dFRl2W705Fej6KF3r85NDrmQWwgddvs
omGAwUtMIQsJqutTsl9UROzmkGIB3/B4LfSR3sX2Gfo2my6zO74ygBGcDP+E/5Pz
SnasA4AbfMh+hMfISdcaTxb6djh1ePHyEWHcYOmEBMfSfsqlsivDtCmQ7UbJd0su
iAVAeqarBZxdvMQBMM2XQ55qPa/AgJ4roABDt1x1jghMhphv2sPj0zpNu/I8DKT7
h/tT8IIV8yH/Lk+h90hq5T5pVX28sOLdbEXFCn6VjbASc+VFAD57xvQnTVUQW8g2
5PWvriTOnlSKHfj2oBlL1S7Q5r8C8AI52nnHpbE0TCB4FkV1Uq1ufORZ4C6KfLdg
bmZz9gRJfAeg79XZYKBHgf8aLcAn1PumFiDpaYXl+h7MVhPIpnCaRH6MbZKZysb0
2j2BfXiTxTA2lpFC9Iufwrpz/A2nYpObpF4cyHrmab5tOrbi0Os7G/C6l00Sky7A
v20tYoPEWSdsqJ9Cq9Cn
=2H63
-----END PGP SIGNATURE-----

--SnV5plBeK2Ge1I9g--
