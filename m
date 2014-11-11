Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaKKUbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:31:31 -0500
Received: from sauhun.de ([89.238.76.85]:37756 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaKKUb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:31:27 -0500
Date: Tue, 11 Nov 2014 21:32:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Feng Kan <fkan@apm.com>
Cc: patches@apm.com, jassisingbrar@gmail.com, =devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hieu Le <hnle@apm.com>
Subject: Re: [PATCH 4/6] i2c: busses: add SLIMpro I2C device driver on APM
 X-Gene platform
Message-ID: <20141111203237.GB6443@katana>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
 <1412726809-7525-5-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <1412726809-7525-5-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 05:06:47PM -0700, Feng Kan wrote:
> Add SLIMpro I2C device driver on APM X-Gene platform. This I2C
> device driver use the SLIMpro Mailbox driver to tunnel message to
> the SLIMpro coprocessor to do the work of accessing I2C components.
>=20
> Signed-off-by: Feng Kan <fkan@apm.com>
> Signed-off-by: Hieu Le <hnle@apm.com>

Thank you for this submission!

> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2e45ae3..a03042c 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -1009,6 +1009,15 @@ config I2C_CROS_EC_TUNNEL
>  	  connected there. This will work whatever the interface used to
>  	  talk to the EC (SPI, I2C or LPC).
> =20
> +config I2C_XGENE_SLIMPRO
> +	tristate "APM X-Gene SoC I2C SLIMpro devices support"
> +	depends on ARCH_XGENE && XGENE_SLIMPRO_MBOX
> +	help
> +	  Enable I2C bus access using the APM X-Gene SoC SLIMpro
> +	  co-processor. The I2C device access the I2C bus via the X-Gene
> +	  to SLIMpro (On chip coprocessor) mailbox mechanism.
> +	  If unsure, say N.
> +

I guess this is a driver for embedded? If so, please sort it properly.

>  config SCx200_ACB
>  	tristate "Geode ACCESS.bus support"
>  	depends on X86_32 && PCI
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 49bf07e..22b5f0c 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -99,6 +99,7 @@ obj-$(CONFIG_I2C_CROS_EC_TUNNEL)	+=3D i2c-cros-ec-tunne=
l.o
>  obj-$(CONFIG_I2C_ELEKTOR)	+=3D i2c-elektor.o
>  obj-$(CONFIG_I2C_PCA_ISA)	+=3D i2c-pca-isa.o
>  obj-$(CONFIG_I2C_SIBYTE)	+=3D i2c-sibyte.o
> +obj-$(CONFIG_I2C_XGENE_SLIMPRO) +=3D i2c-xgene-slimpro.o

Ditto.

>  obj-$(CONFIG_SCx200_ACB)	+=3D scx200_acb.o
> =20
>  ccflags-$(CONFIG_I2C_DEBUG_BUS) :=3D -DDEBUG
> diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c b/drivers/i2c/busses/=
i2c-xgene-slimpro.c
> new file mode 100644
> index 0000000..2cf6c33
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
> @@ -0,0 +1,531 @@
> +/*
> + * X-Gene SLIMpro I2C Driver
> + *
> + * Copyright (c) 2014, Applied Micro Circuits Corporation
> + * Author: Feng Kan <fkan@apm.com>
> + * Author: Hieu Le <hnle@apm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.

The license preamble and MODULE_LICENSE do not match!

> +#include <linux/module.h>
> +#include <linux/version.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/i2c.h>
> +#include <linux/mailbox_client.h>
> +#include <linux/delay.h>
> +#include <linux/spinlock.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>

Please sort the includes.

> +
> +#define XGENE_SLIMPRO_I2C		"xgene-slimpro-i2c"

Only used once, not really needed

> +
> +#define SLIMPRO_I2C_WAIT_COUNT		10000
> +
> +#define SLIMPRO_OP_TO_MS		1000	/* Operation time out in ms */

*_TOUT_* or *_TIMEOUT_*. TO sounds like a conversion, from op to ms :)

> +#define SLIMPRO_IIC_BUS			1

What does this '1' mean?

> +static int start_i2c_msg_xfer(struct slimpro_i2c_dev *ctx)
> +{
> +	int count;
> +	unsigned long flags;
> +
> +	if (ctx->mbox_client.tx_block) {
> +		if (!wait_for_completion_timeout(&ctx->rd_complete,
> +						 msecs_to_jiffies
> +						 (SLIMPRO_OP_TO_MS)))
> +			return -EIO;

That should be -ETIMEDOUT, no?

> +	} else {
> +		spin_lock_irqsave(&ctx->lock, flags);
> +		ctx->i2c_rx_poll =3D 1;
> +		for (count =3D SLIMPRO_I2C_WAIT_COUNT; count > 0; count--) {
> +			if (ctx->i2c_rx_poll =3D=3D 0)
> +				break;
> +			udelay(100);
> +		}
> +
> +		if (count =3D=3D 0) {
> +			ctx->i2c_rx_poll =3D 0;
> +			ctx->mbox_client.tx_block =3D true;
> +			spin_unlock_irqrestore(&ctx->lock, flags);
> +			return -EIO;

ditto.

> +		}
> +		ctx->mbox_client.tx_block =3D true;
> +		spin_unlock_irqrestore(&ctx->lock, flags);
> +	}
> +
> +	/* Check of invalid data or no device */
> +	if (*ctx->resp_msg =3D=3D 0xffffffff)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int slimpro_i2c_blkrd(struct slimpro_i2c_dev *ctx, u32 chip, u32 =
addr,
> +				u32 addrlen, u32 protocol, u32 readlen,
> +				u32 with_data_len, void *data)
> +{
> +	dma_addr_t paddr;
> +	u32 msg[3];
> +	int rc;
> +
> +	paddr =3D dma_map_single(ctx->dev, ctx->dma_buffer, readlen,
> +			       DMA_FROM_DEVICE);
> +	if (dma_mapping_error(ctx->dev, paddr)) {
> +		dev_err(&ctx->adapter.dev, "Error in mapping dma buffer %p\n",
> +			ctx->dma_buffer);
> +		rc =3D -EIO;

Return the err value from dma_mapping_error?

> +		goto err;
> +	}
> +
> +	if (irqs_disabled())
> +		ctx->mbox_client.tx_block =3D false;
> +
> +	msg[0] =3D SLIMPRO_IIC_ENCODE_MSG(SLIMPRO_IIC_BUS, chip,
> +					SLIMPRO_IIC_READ, protocol, addrlen,
> +					readlen);
> +	msg[1] =3D SLIMPRO_IIC_ENCODE_FLAG_BUFADDR |
> +		 SLIMPRO_IIC_ENCODE_FLAG_WITH_DATA_LEN(with_data_len) |
> +		 SLIMPRO_IIC_ENCODE_UPPER_BUFADDR(paddr) |
> +		 SLIMPRO_IIC_ENCODE_ADDR(addr);
> +	msg[2] =3D (u32) paddr;
> +	ctx->resp_msg =3D msg;
> +
> +	if (ctx->mbox_client.tx_block)
> +		init_completion(&ctx->rd_complete);

reinit_completion? and init_completion in probe?

> +
> +	rc =3D mbox_send_message(ctx->mbox_chan, &msg);
> +	if (rc < 0)
> +		goto err_unmap;
> +
> +	rc =3D start_i2c_msg_xfer(ctx);
> +
> +	/* Copy to destination */
> +	memcpy(data, ctx->dma_buffer, readlen);
> +
> +err_unmap:
> +	dma_unmap_single(ctx->dev, paddr, readlen, DMA_FROM_DEVICE);
> +err:
> +	ctx->resp_msg =3D NULL;
> +	return rc;
> +}
> +
> +static int slimpro_i2c_blkwr(struct slimpro_i2c_dev *ctx, u32 chip,
> +			     u32 addr, u32 addrlen, u32 protocol, u32 writelen,
> +			     void *data)
> +{
> +	dma_addr_t paddr;
> +	u32 msg[3];
> +	int rc;
> +
> +	memcpy(ctx->dma_buffer, data, writelen);
> +	paddr =3D dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
> +			       DMA_TO_DEVICE);
> +	if (dma_mapping_error(ctx->dev, paddr)) {
> +		dev_err(&ctx->adapter.dev, "Error in mapping dma buffer %p\n",
> +			ctx->dma_buffer);
> +		rc =3D -EIO;

same as above

> +		goto err;
> +	}
> +
> +	if (irqs_disabled())
> +		ctx->mbox_client.tx_block =3D false;
> +
> +	msg[0] =3D SLIMPRO_IIC_ENCODE_MSG(SLIMPRO_IIC_BUS, chip,
> +					SLIMPRO_IIC_WRITE, protocol, addrlen,
> +					writelen);
> +	msg[1] =3D SLIMPRO_IIC_ENCODE_FLAG_BUFADDR |
> +		 SLIMPRO_IIC_ENCODE_UPPER_BUFADDR(paddr) |
> +		 SLIMPRO_IIC_ENCODE_ADDR(addr);
> +	msg[2] =3D (u32) paddr;
> +	ctx->resp_msg =3D msg;
> +
> +	if (ctx->mbox_client.tx_block)
> +		init_completion(&ctx->rd_complete);

ditto

> +
> +	rc =3D mbox_send_message(ctx->mbox_chan, &msg);
> +	if (rc < 0)
> +		goto err_unmap;
> +
> +	rc =3D start_i2c_msg_xfer(ctx);
> +
> +err_unmap:
> +	dma_unmap_single(ctx->dev, paddr, writelen, DMA_TO_DEVICE);
> +err:
> +	ctx->resp_msg =3D NULL;
> +	return rc;
> +}
> +
> +static struct platform_driver xgene_slimpro_i2c_driver =3D {
> +	.probe	=3D xgene_slimpro_i2c_probe,
> +	.remove	=3D xgene_slimpro_i2c_remove,
> +	.driver	=3D {
> +		.name	=3D XGENE_SLIMPRO_I2C,
> +		.owner	=3D THIS_MODULE,

Not needed.

> +		.of_match_table =3D of_match_ptr(xgene_slimpro_i2c_id)
> +	},
> +};
> +
> +module_platform_driver(xgene_slimpro_i2c_driver);
> +
> +MODULE_DESCRIPTION("APM X-Gene SLIMpro I2C driver");
> +MODULE_LICENSE("GPL v2");

So, only minor stuff. Looking good already to me.

Thanks,

   Wolfram


--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYnJkAAoJEBQN5MwUoCm2brMP/0m5oJueyKJyItIzPoa24DRJ
V1ecdFD1kY7Dm51L1ijelgT8+63FOikN8U0t1n5eJfK/ewaaZIxW5ib4ZjCjYoiu
2DuQWH7etLeL7Q/Et83sSMjt2+Qfc8GD7+8sKKH5adkqNh5CoAE2Weuiqyjdqlfr
KdmjaPGSfynp7nkBMfhxDtWX950OOOksMp/lc4qcq+RhJ5pgzy6QRZoJkrpuoY8w
QZgkhq1Xql6YsVWR20hueaz/ibevTKxbI0XDWL1chy0ZoSJw9OChhF67H40sRRu4
qcByDIyrTSwH65k0CWec2XaJtGd11nZY+bfJauBal5jkDQucMtRge9pQnR/AS1hG
oJgH99g8RKyzk4VhL1OfIg+uhswzBb51c9xCEAPzcGEcxNa09m91/Z0NK/s6iATa
iFbghF6IEN+W4OD3D/Mj66gCKqD8Hacew3iCWuaS0KDlV9Rxcase3vHSHRYqYMvN
G+EDOsOlIVv/S3aFQXjSafKtxaCjYDxuzctATcwI3AUaDEZ7iXtIyBj/WXQL83o8
VpYPNG2nx0hVv3lwZncjoMgcY3wCpoN0XiUX4iBxO1iyOqxMYNLyHjO2Em+aPvBk
/oOa7TQyVFCKD28VowSl4MEmeg+G04iki1MCbMKUj/f52y2Fi/Ol4a35AmS4Je8R
wiTaIMwYncKu34y9Xp98
=N1YL
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
