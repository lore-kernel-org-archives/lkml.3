Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaJCHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 03:54:19 -0400
Received: from sauhun.de ([89.238.76.85]:37262 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJCHyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 03:54:18 -0400
Date: Fri, 3 Oct 2014 09:54:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Yuan Yao <yao.yuan@freescale.com>
Cc: marex@denx.de, LW@KARO-electronics.de, mark.rutland@arm.com,
        fugang.duan@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c driver
Message-ID: <20141003075441.GA1349@katana>
References: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
 <1411632689-31531-2-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <1411632689-31531-2-git-send-email-yao.yuan@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

thanks for this submission. Here is my review.

On Thu, Sep 25, 2014 at 04:11:28PM +0800, Yuan Yao wrote:
> Add dma support for i2c. This function depend on DMA driver.
> You can turn on it by write both the dmas and dma-name properties in dts =
node.
> DMA is optional, even DMA request unsuccessfully, i2c can also work well.
>=20
> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> ---
>  drivers/i2c/busses/i2c-imx.c | 352 +++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 342 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index 613069b..c643756 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -37,22 +37,27 @@
>  /** Includes ***********************************************************=
********
>  ************************************************************************=
*******/
> =20
> -#include <linux/init.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dmapool.h>
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/interrupt.h>
> -#include <linux/delay.h>
>  #include <linux/i2c.h>
> +#include <linux/init.h>
>  #include <linux/io.h>
> -#include <linux/sched.h>
> -#include <linux/platform_device.h>
> -#include <linux/clk.h>
> -#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/of_dma.h>
>  #include <linux/platform_data/i2c-imx.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>

This is a seperate patch.

> @@ -432,6 +587,168 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_i=
d)
>  	return IRQ_NONE;
>  }
> =20
> +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> +					struct i2c_msg *msgs)
> +{
> +	int result;
> +	unsigned int temp =3D 0;
> +	unsigned long orig_jiffies =3D jiffies;
> +	struct imx_i2c_dma *dma =3D i2c_imx->dma;
> +	struct device *dev =3D &i2c_imx->adapter.dev;
> +
> +	dev_dbg(dev, "<%s> write slave address: addr=3D0x%x\n",
> +		__func__, msgs->addr << 1);

That debug should really go. We have other means to display ongoing I2C
transactions and their address.

> +
> +	dma->chan_using =3D dma->chan_tx;
> +	dma->dma_transfer_dir =3D DMA_MEM_TO_DEV;
> +	dma->dma_data_dir =3D DMA_TO_DEVICE;
> +	dma->dma_len =3D msgs->len - 1;
> +	result =3D i2c_imx_dma_xfer(i2c_imx, msgs);
> +	if (result)
> +		return result;
> +
> +	temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp |=3D I2CR_DMAEN;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	/*
> +	 * Write slave address.
> +	 * The first byte muse be transmitted by the CPU.

"must"

> +	 */
> +	imx_i2c_write_reg(msgs->addr << 1, i2c_imx, IMX_I2C_I2DR);
> +	reinit_completion(&i2c_imx->dma->cmd_complete);
> +	result =3D wait_for_completion_interruptible_timeout(
> +				&i2c_imx->dma->cmd_complete,
> +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> +	if (result <=3D 0) {
> +		dmaengine_terminate_all(dma->chan_using);
> +		if (result)
> +			return result;
> +		else
> +			return -ETIMEDOUT;
> +	}
> +
> +	/* Waiting for Transfer complete. */

"transfer"

> +	while (1) {
> +		temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +		if (temp & I2SR_ICF)
> +			break;
> +		if (time_after(jiffies, orig_jiffies +
> +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT))) {
> +			dev_dbg(dev, "<%s> Timeout\n", __func__);
> +			return -ETIMEDOUT;
> +		}
> +		schedule();

That might have been asked before. Is there no interrupt for this?

> +	}
> +
> +	temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp &=3D ~I2CR_DMAEN;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	/* The last data byte must be transferred by the CPU. */
> +	imx_i2c_write_reg(msgs->buf[msgs->len-1],
> +				i2c_imx, IMX_I2C_I2DR);
> +	result =3D i2c_imx_trx_complete(i2c_imx);
> +	if (result)
> +		return result;
> +
> +	result =3D i2c_imx_acked(i2c_imx);
> +	if (result)
> +		return result;
> +
> +	return 0;
> +}
> +
> +static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
> +			struct i2c_msg *msgs, bool is_lastmsg)
> +{
> +	int result;
> +	unsigned int temp;
> +	unsigned long orig_jiffies;
> +	struct imx_i2c_dma *dma =3D i2c_imx->dma;
> +	struct device *dev =3D &i2c_imx->adapter.dev;
> +
> +	temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp |=3D I2CR_DMAEN;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	dma->chan_using =3D dma->chan_rx;
> +	dma->dma_transfer_dir =3D DMA_DEV_TO_MEM;
> +	dma->dma_data_dir =3D DMA_FROM_DEVICE;
> +	/* The last two data bytes must be transferred by the CPU. */
> +	dma->dma_len =3D msgs->len - 2;
> +	result =3D i2c_imx_dma_xfer(i2c_imx, msgs);
> +	if (result)
> +		return result;
> +
> +	reinit_completion(&i2c_imx->dma->cmd_complete);
> +	result =3D wait_for_completion_interruptible_timeout(
> +				&i2c_imx->dma->cmd_complete,
> +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> +	if (result <=3D 0) {
> +		dmaengine_terminate_all(dma->chan_using);
> +		if (result)
> +			return result;
> +		else
> +			return -ETIMEDOUT;

return result ?: -ETIMEDOUT;

> +	}
> +
> +	/* waiting for Transfer complete. */

"transfer"

> +	while (1) {
> +		temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> +		if (temp & I2SR_ICF)
> +			break;
> +		if (time_after(jiffies, orig_jiffies +
> +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT))) {
> +			dev_dbg(dev, "<%s> Timeout\n", __func__);
> +			return -ETIMEDOUT;
> +		}
> +		schedule();
> +	}
> +
> +	temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp &=3D ~I2CR_DMAEN;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	/* read n-1 byte data */
> +	temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +	temp |=3D I2CR_TXAK;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +
> +	msgs->buf[msgs->len-2] =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> +	/* read n byte data */
> +	result =3D i2c_imx_trx_complete(i2c_imx);
> +	if (result)
> +		return result;
> +
> +	if (is_lastmsg) {
> +		/*
> +		 * It must generate STOP before read I2DR to prevent
> +		 * controller from generating another clock cycle
> +		 */
> +		dev_dbg(dev, "<%s> clear MSTA\n", __func__);
> +		temp =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> +		temp &=3D ~(I2CR_MSTA | I2CR_MTX);
> +		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> +		i2c_imx_bus_busy(i2c_imx, 0);
> +		i2c_imx->stopped =3D 1;
> +	} else {
> +		/*
> +		 * For i2c master receiver repeat restart operation like:
> +		 * read -> repeat MSTA -> read/write
> +		 * The controller must set MTX before read the last byte in
> +		 * the first read operation, otherwise the first read cost
> +		 * one extra clock cycle.
> +		 */
> +		temp =3D readb(i2c_imx->base + IMX_I2C_I2CR);
> +		temp |=3D I2CR_MTX;
> +		writeb(temp, i2c_imx->base + IMX_I2C_I2CR);
> +	}
> +	msgs->buf[msgs->len-1] =3D imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
> +
> +	return 0;
> +}
> +
>  static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct i2c_msg =
*msgs)
>  {
>  	int i, result;
> @@ -501,6 +818,9 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_im=
x, struct i2c_msg *msgs, bo
> =20
>  	dev_dbg(&i2c_imx->adapter.dev, "<%s> read data\n", __func__);
> =20
> +	if (i2c_imx->dma && msgs->len >=3D IMX_I2C_DMA_THRESHOLD && !block_data)
> +		return i2c_imx_dma_read(i2c_imx, msgs, is_lastmsg);
> +
>  	/* read data */
>  	for (i =3D 0; i < msgs->len; i++) {
>  		u8 len =3D 0;
> @@ -615,8 +935,12 @@ static int i2c_imx_xfer(struct i2c_adapter *adapter,
>  #endif
>  		if (msgs[i].flags & I2C_M_RD)
>  			result =3D i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg);
> -		else
> -			result =3D i2c_imx_write(i2c_imx, &msgs[i]);
> +		else {
> +			if (i2c_imx->dma && msgs[i].len >=3D IMX_I2C_DMA_THRESHOLD)
> +				result =3D i2c_imx_dma_write(i2c_imx, &msgs[i]);
> +			else
> +				result =3D i2c_imx_write(i2c_imx, &msgs[i]);
> +		}
>  		if (result)
>  			goto fail0;
>  	}
> @@ -651,6 +975,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  	struct imxi2c_platform_data *pdata =3D dev_get_platdata(&pdev->dev);
>  	void __iomem *base;
>  	int irq, ret;
> +	dma_addr_t phy_addr;
> =20
>  	dev_dbg(&pdev->dev, "<%s>\n", __func__);
> =20
> @@ -661,6 +986,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
>  	}
> =20
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy_addr =3D (dma_addr_t)res->start;

res can be NULL! Move it after it has been checked...

>  	base =3D devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(base))
>  		return PTR_ERR(base);

=2E..here.


> @@ -740,6 +1066,9 @@ static int i2c_imx_probe(struct platform_device *pde=
v)
>  		i2c_imx->adapter.name);
>  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> =20
> +	/* Init DMA config if support*/
> +	i2c_imx_dma_request(i2c_imx, phy_addr);
> +
>  	return 0;   /* Return OK */
>  }
> =20
> @@ -751,6 +1080,9 @@ static int i2c_imx_remove(struct platform_device *pd=
ev)
>  	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
>  	i2c_del_adapter(&i2c_imx->adapter);
> =20
> +	if (i2c_imx->dma)
> +		i2c_imx_dma_free(i2c_imx);
> +

Looks mostly good, though.

Thanks,

   Wolfram


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULlZBAAoJEBQN5MwUoCm2//cP/jBsXM2caZw1MnM2N87KsKCn
tLclPMtFwuwbsmxmwHSRHDJ8EVjpALNJzJT2HXCrd3xaqxTS+sLT4y2CXqCqHUw9
xfaHfQHK56N8iYZMZosQkwQpuACCF/BSBDriQst4SoUv6D4RqWkOqJXj+P34mwpG
LdAeKPTcH/e8qcSPjGAEWKd5e4SG0FgFFyxUo+JTufqTwzuV4okG7QmSWCg4IfwU
71ZZOmln8c9EdALUWnobFRuifs1JmRU0oBASA2zsAJSzp0qr9gcXgAVOf0AUzzZX
mF6JM5s1qCPRqXubzmUqajp0D6pFkO6KqRpFL16XiNEI/wj3TnNyMAR7j1S0CsgE
5EkQ3yk2+eEUicsqkUzFAAbg5vYlISPRsTgNROLQ2i8R3NVmnYb2u3vWmOg474I8
Hg71Sj19b4b9Oyefj1UaKb++moFCbLEOzb+s7RY5oHEBovbpb591wlZ7Z+3/s9DV
gdNgV6JfeSGICupZyQ+SAkw/qCHogG+TZgtO1lOfBMRJLxpkHcGhUeeqTDA4JrMs
YYeNgmj9I4A19bxv3Adau007Mg5MFlhY6brs/1O2HMvIRjCubnfOHhAJoPA/m4id
hT/rjJKfxZUHNcd8gcQGx8BwVeuSk/fIvpZ4s8Bu1Be5PlGe8msI7wj7rL8M8C9d
WAamzi3Rffrv36Mcou48
=WRTo
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
