Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbaIOWkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:40:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43866 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaIOWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:39:58 -0400
Date: Mon, 15 Sep 2014 15:39:44 -0700
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Frank.Li@freescale.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Message-ID: <20140915223944.GH7960@sirena.org.uk>
References: <1410398324-15284-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hjTNX7PlvRO2hhYY"
Content-Disposition: inline
In-Reply-To: <1410398324-15284-1-git-send-email-b38343@freescale.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] spi: spi-imx: add DMA support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hjTNX7PlvRO2hhYY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2014 at 09:18:44AM +0800, Robin Gong wrote:
> Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
> If not set "dma-names" in dts, spi will use PIO mode. This patch only
> validate on i.mx6, not i.mx5, but encourage ones to apply this patch
> on i.mx5 since they share the same IP.

Adding Maerk (who I had to add to earlier versions of this patch).

>=20
> Note:
>   Sometime, there is a weid data in rxfifo after one full tx/rx
> transfer finish by DMA on i.mx6dl, so we disable dma functhion on
> i.mx6dl.
>=20
> Signed-off-by: Frank Li <Frank.Li@freescale.com>
> Signed-off-by: Robin Gong <b38343@freescale.com>
>=20
> ---
> Change from v5:
> 1. Update binding doc fsl-imx-cspi.txt.
> 2. remove usedma flag set from can_dma interface.
>=20
> Change from v4:
> 1. Enrich comments.
> 2. Remove the rxfifo workaround. The issue only exist on i.mx6dl, so disa=
ble
>    dma function in dts.
>=20
> Change from v3:
> 1. Use spi core framwork to handle dump tx/rx buf
> 2. Add one workaround for weird data in rxfifo when one full transfer don=
e.
>=20
> Change from v2:
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/291722/focus=3D294363
> 1. Dma setup only for imx51-ecspi
> 2. Use one small dummy buffer(1 bd size) to templiy store data
>    for meanless rx/tx, instead of malloc the actual transfer size.
> 3. Split spi_mx_sdma_transfer to smaller and easily to read.
> 4. Fix some code indent.
> ---
>  .../devicetree/bindings/spi/fsl-imx-cspi.txt       |   5 +
>  drivers/spi/spi-imx.c                              | 286 +++++++++++++++=
+++++-
>  2 files changed, 285 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt b/Doc=
umentation/devicetree/bindings/spi/fsl-imx-cspi.txt
> index 4256a6d..aad527b 100644
> --- a/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt
> +++ b/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt
> @@ -7,6 +7,9 @@ Required properties:
>  - interrupts : Should contain CSPI/eCSPI interrupt
>  - fsl,spi-num-chipselects : Contains the number of the chipselect
>  - cs-gpios : Specifies the gpio pins to be used for chipselects.
> +- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
> +		Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names: DMA request names should include "tx" and "rx" if present.
> =20
>  Example:
> =20
> @@ -19,4 +22,6 @@ ecspi@70010000 {
>  	fsl,spi-num-chipselects =3D <2>;
>  	cs-gpios =3D <&gpio3 24 0>, /* GPIO3_24 */
>  		   <&gpio3 25 0>; /* GPIO3_25 */
> +	dmas =3D <&sdma 3 7 1>, <&sdma 4 7 2>;
> +	dma-names =3D "rx", "tx";
>  };
> diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
> index 5daff20..3637847 100644
> --- a/drivers/spi/spi-imx.c
> +++ b/drivers/spi/spi-imx.c
> @@ -21,6 +21,8 @@
>  #include <linux/clk.h>
>  #include <linux/completion.h>
>  #include <linux/delay.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/err.h>
>  #include <linux/gpio.h>
>  #include <linux/interrupt.h>
> @@ -37,6 +39,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
> =20
> +#include <linux/platform_data/dma-imx.h>
>  #include <linux/platform_data/spi-imx.h>
> =20
>  #define DRIVER_NAME "spi_imx"
> @@ -51,6 +54,9 @@
>  #define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
>  #define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
> =20
> +/* The maximum  bytes that a sdma BD can transfer.*/
> +#define MAX_SDMA_BD_BYTES  (1 << 15)
> +#define IMX_DMA_TIMEOUT (msecs_to_jiffies(3000))
>  struct spi_imx_config {
>  	unsigned int speed_hz;
>  	unsigned int bpw;
> @@ -95,6 +101,16 @@ struct spi_imx_data {
>  	const void *tx_buf;
>  	unsigned int txfifo; /* number of words pushed in tx FIFO */
> =20
> +	/* DMA */
> +	unsigned int dma_is_inited;
> +	unsigned int dma_finished;
> +	bool usedma;
> +	u32 rx_wml;
> +	u32 tx_wml;
> +	u32 rxt_wml;
> +	struct completion dma_rx_completion;
> +	struct completion dma_tx_completion;
> +
>  	const struct spi_imx_devtype_data *devtype_data;
>  	int chipselect[0];
>  };
> @@ -181,9 +197,21 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fi=
n,
>  	return 7;
>  }
> =20
> +static bool spi_imx_can_dma(struct spi_master *master, struct spi_device=
 *spi,
> +			 struct spi_transfer *transfer)
> +{
> +	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(master);
> +
> +	if (spi_imx->dma_is_inited && (transfer->len > spi_imx->rx_wml)
> +	    && (transfer->len > spi_imx->tx_wml))
> +		return true;
> +	return false;
> +}
> +
>  #define MX51_ECSPI_CTRL		0x08
>  #define MX51_ECSPI_CTRL_ENABLE		(1 <<  0)
>  #define MX51_ECSPI_CTRL_XCH		(1 <<  2)
> +#define MX51_ECSPI_CTRL_SMC		(1 << 3)
>  #define MX51_ECSPI_CTRL_MODE_MASK	(0xf << 4)
>  #define MX51_ECSPI_CTRL_POSTDIV_OFFSET	8
>  #define MX51_ECSPI_CTRL_PREDIV_OFFSET	12
> @@ -201,6 +229,18 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fi=
n,
>  #define MX51_ECSPI_INT_TEEN		(1 <<  0)
>  #define MX51_ECSPI_INT_RREN		(1 <<  3)
> =20
> +#define MX51_ECSPI_DMA      0x14
> +#define MX51_ECSPI_DMA_TX_WML_OFFSET	0
> +#define MX51_ECSPI_DMA_TX_WML_MASK	0x3F
> +#define MX51_ECSPI_DMA_RX_WML_OFFSET	16
> +#define MX51_ECSPI_DMA_RX_WML_MASK	(0x3F << 16)
> +#define MX51_ECSPI_DMA_RXT_WML_OFFSET	24
> +#define MX51_ECSPI_DMA_RXT_WML_MASK	(0x3F << 24)
> +
> +#define MX51_ECSPI_DMA_TEDEN_OFFSET	7
> +#define MX51_ECSPI_DMA_RXDEN_OFFSET	23
> +#define MX51_ECSPI_DMA_RXTDEN_OFFSET	31
> +
>  #define MX51_ECSPI_STAT		0x18
>  #define MX51_ECSPI_STAT_RR		(1 <<  3)
> =20
> @@ -257,17 +297,22 @@ static void __maybe_unused mx51_ecspi_intctrl(struc=
t spi_imx_data *spi_imx, int
> =20
>  static void __maybe_unused mx51_ecspi_trigger(struct spi_imx_data *spi_i=
mx)
>  {
> -	u32 reg;
> -
> -	reg =3D readl(spi_imx->base + MX51_ECSPI_CTRL);
> -	reg |=3D MX51_ECSPI_CTRL_XCH;
> +	u32 reg =3D readl(spi_imx->base + MX51_ECSPI_CTRL);
> +
> +	if (!spi_imx->usedma)
> +		reg |=3D MX51_ECSPI_CTRL_XCH;
> +	else if (!spi_imx->dma_finished)
> +		reg |=3D MX51_ECSPI_CTRL_SMC;
> +	else
> +		reg &=3D ~MX51_ECSPI_CTRL_SMC;
>  	writel(reg, spi_imx->base + MX51_ECSPI_CTRL);
>  }
> =20
>  static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
>  		struct spi_imx_config *config)
>  {
> -	u32 ctrl =3D MX51_ECSPI_CTRL_ENABLE, cfg =3D 0;
> +	u32 ctrl =3D MX51_ECSPI_CTRL_ENABLE, cfg =3D 0, dma =3D 0;
> +	u32 tx_wml_cfg, rx_wml_cfg, rxt_wml_cfg;
>  	u32 clk =3D config->speed_hz, delay;
> =20
>  	/*
> @@ -319,6 +364,30 @@ static int __maybe_unused mx51_ecspi_config(struct s=
pi_imx_data *spi_imx,
>  	else			/* SCLK is _very_ slow */
>  		usleep_range(delay, delay + 10);
> =20
> +	/*
> +	 * Configure the DMA register: setup the watermark
> +	 * and enable DMA request.
> +	 */
> +	if (spi_imx->dma_is_inited) {
> +		dma =3D readl(spi_imx->base + MX51_ECSPI_DMA);
> +
> +		spi_imx->tx_wml =3D spi_imx_get_fifosize(spi_imx) / 2;
> +		spi_imx->rx_wml =3D spi_imx_get_fifosize(spi_imx) / 2;
> +		spi_imx->rxt_wml =3D spi_imx_get_fifosize(spi_imx) / 2;
> +		rx_wml_cfg =3D spi_imx->rx_wml << MX51_ECSPI_DMA_RX_WML_OFFSET;
> +		tx_wml_cfg =3D spi_imx->tx_wml << MX51_ECSPI_DMA_TX_WML_OFFSET;
> +		rxt_wml_cfg =3D spi_imx->rxt_wml << MX51_ECSPI_DMA_RXT_WML_OFFSET;
> +		dma =3D (dma & ~MX51_ECSPI_DMA_TX_WML_MASK
> +			   & ~MX51_ECSPI_DMA_RX_WML_MASK
> +			   & ~MX51_ECSPI_DMA_RXT_WML_MASK)
> +			   | rx_wml_cfg | tx_wml_cfg | rxt_wml_cfg
> +			   |(1 << MX51_ECSPI_DMA_TEDEN_OFFSET)
> +			   |(1 << MX51_ECSPI_DMA_RXDEN_OFFSET)
> +			   |(1 << MX51_ECSPI_DMA_RXTDEN_OFFSET);
> +
> +		writel(dma, spi_imx->base + MX51_ECSPI_DMA);
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -730,7 +799,186 @@ static int spi_imx_setupxfer(struct spi_device *spi,
>  	return 0;
>  }
> =20
> -static int spi_imx_transfer(struct spi_device *spi,
> +static void spi_imx_sdma_exit(struct spi_imx_data *spi_imx)
> +{
> +	struct spi_master *master =3D spi_imx->bitbang.master;
> +
> +	if (master->dma_rx) {
> +		dma_release_channel(master->dma_rx);
> +		master->dma_rx =3D NULL;
> +	}
> +
> +	if (master->dma_tx) {
> +		dma_release_channel(master->dma_tx);
> +		master->dma_tx =3D NULL;
> +	}
> +
> +	spi_imx->dma_is_inited =3D 0;
> +}
> +
> +static int spi_imx_sdma_init(struct device *dev, struct spi_imx_data *sp=
i_imx,
> +			     struct spi_master *master,
> +			     const struct resource *res)
> +{
> +	struct dma_slave_config slave_config =3D {};
> +	int ret;
> +
> +	/* Prepare for TX DMA: */
> +	master->dma_tx =3D dma_request_slave_channel(dev, "tx");
> +	if (!master->dma_tx) {
> +		dev_err(dev, "cannot get the TX DMA channel!\n");
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> +	slave_config.direction =3D DMA_MEM_TO_DEV;
> +	slave_config.dst_addr =3D res->start + MXC_CSPITXDATA;
> +	slave_config.dst_addr_width =3D DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	slave_config.dst_maxburst =3D spi_imx_get_fifosize(spi_imx) / 2;
> +	ret =3D dmaengine_slave_config(master->dma_tx, &slave_config);
> +	if (ret) {
> +		dev_err(dev, "error in TX dma configuration.\n");
> +		goto err;
> +	}
> +
> +	/* Prepare for RX : */
> +	master->dma_rx =3D dma_request_slave_channel(dev, "rx");
> +	if (!master->dma_rx) {
> +		dev_dbg(dev, "cannot get the DMA channel.\n");
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> +	slave_config.direction =3D DMA_DEV_TO_MEM;
> +	slave_config.src_addr =3D res->start + MXC_CSPIRXDATA;
> +	slave_config.src_addr_width =3D DMA_SLAVE_BUSWIDTH_1_BYTE;
> +	slave_config.src_maxburst =3D spi_imx_get_fifosize(spi_imx) / 2;
> +	ret =3D dmaengine_slave_config(master->dma_rx, &slave_config);
> +	if (ret) {
> +		dev_err(dev, "error in RX dma configuration.\n");
> +		goto err;
> +	}
> +
> +	init_completion(&spi_imx->dma_rx_completion);
> +	init_completion(&spi_imx->dma_tx_completion);
> +	master->can_dma =3D spi_imx_can_dma;
> +	master->max_dma_len =3D MAX_SDMA_BD_BYTES;
> +	spi_imx->bitbang.master->flags =3D SPI_MASTER_MUST_RX |
> +					 SPI_MASTER_MUST_TX;
> +	spi_imx->dma_is_inited =3D 1;
> +
> +	return 0;
> +err:
> +	spi_imx_sdma_exit(spi_imx);
> +	return ret;
> +}
> +
> +static void spi_imx_dma_rx_callback(void *cookie)
> +{
> +	struct spi_imx_data *spi_imx =3D (struct spi_imx_data *)cookie;
> +
> +	complete(&spi_imx->dma_rx_completion);
> +}
> +
> +static void spi_imx_dma_tx_callback(void *cookie)
> +{
> +	struct spi_imx_data *spi_imx =3D (struct spi_imx_data *)cookie;
> +
> +	complete(&spi_imx->dma_tx_completion);
> +}
> +
> +static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
> +				struct spi_transfer *transfer)
> +{
> +	struct dma_async_tx_descriptor *desc_tx =3D NULL, *desc_rx =3D NULL;
> +	int ret;
> +	u32 dma;
> +	int left;
> +	struct spi_master *master =3D spi_imx->bitbang.master;
> +	struct sg_table *tx =3D &transfer->tx_sg, *rx =3D &transfer->rx_sg;
> +
> +	if (tx) {
> +		desc_tx =3D dmaengine_prep_slave_sg(master->dma_tx,
> +					tx->sgl, tx->nents, DMA_TO_DEVICE,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +		if (!desc_tx)
> +			goto no_dma;
> +
> +		desc_tx->callback =3D spi_imx_dma_tx_callback;
> +		desc_tx->callback_param =3D (void *)spi_imx;
> +		dmaengine_submit(desc_tx);
> +	}
> +
> +	if (rx) {
> +		desc_rx =3D dmaengine_prep_slave_sg(master->dma_rx,
> +					rx->sgl, rx->nents, DMA_FROM_DEVICE,
> +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +		if (!desc_rx)
> +			goto no_dma;
> +
> +		desc_rx->callback =3D spi_imx_dma_rx_callback;
> +		desc_rx->callback_param =3D (void *)spi_imx;
> +		dmaengine_submit(desc_rx);
> +	}
> +
> +	reinit_completion(&spi_imx->dma_rx_completion);
> +	reinit_completion(&spi_imx->dma_tx_completion);
> +
> +	/* Trigger the cspi module. */
> +	spi_imx->dma_finished =3D 0;
> +
> +	dma =3D readl(spi_imx->base + MX51_ECSPI_DMA);
> +	dma =3D dma & (~MX51_ECSPI_DMA_RXT_WML_MASK);
> +	/* Change RX_DMA_LENGTH trigger dma fetch tail data */
> +	left =3D transfer->len % spi_imx->rxt_wml;
> +	if (left)
> +		writel(dma | (left << MX51_ECSPI_DMA_RXT_WML_OFFSET),
> +				spi_imx->base + MX51_ECSPI_DMA);
> +	spi_imx->devtype_data->trigger(spi_imx);
> +
> +	dma_async_issue_pending(master->dma_tx);
> +	dma_async_issue_pending(master->dma_rx);
> +	/* Wait SDMA to finish the data transfer.*/
> +	ret =3D wait_for_completion_timeout(&spi_imx->dma_tx_completion,
> +						IMX_DMA_TIMEOUT);
> +	if (!ret) {
> +		pr_warn("%s %s: I/O Error in DMA TX\n",
> +			dev_driver_string(&master->dev),
> +			dev_name(&master->dev));
> +		dmaengine_terminate_all(master->dma_tx);
> +	} else {
> +		ret =3D wait_for_completion_timeout(&spi_imx->dma_rx_completion,
> +				IMX_DMA_TIMEOUT);
> +		if (!ret) {
> +			pr_warn("%s %s: I/O Error in DMA RX\n",
> +				dev_driver_string(&master->dev),
> +				dev_name(&master->dev));
> +			spi_imx->devtype_data->reset(spi_imx);
> +			dmaengine_terminate_all(master->dma_rx);
> +		}
> +		writel(dma |
> +		       spi_imx->rxt_wml << MX51_ECSPI_DMA_RXT_WML_OFFSET,
> +		       spi_imx->base + MX51_ECSPI_DMA);
> +	}
> +
> +	spi_imx->dma_finished =3D 1;
> +	spi_imx->devtype_data->trigger(spi_imx);
> +
> +	if (!ret)
> +		ret =3D -ETIMEDOUT;
> +	else if (ret > 0)
> +		ret =3D transfer->len;
> +
> +	return ret;
> +
> +no_dma:
> +	pr_warn_once("%s %s: DMA not available, falling back to PIO\n",
> +		     dev_driver_string(&master->dev),
> +		     dev_name(&master->dev));
> +	return -EAGAIN;
> +}
> +
> +static int spi_imx_pio_transfer(struct spi_device *spi,
>  				struct spi_transfer *transfer)
>  {
>  	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
> @@ -751,6 +999,24 @@ static int spi_imx_transfer(struct spi_device *spi,
>  	return transfer->len;
>  }
> =20
> +static int spi_imx_transfer(struct spi_device *spi,
> +				struct spi_transfer *transfer)
> +{
> +	int ret;
> +	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
> +
> +	if (spi_imx->bitbang.master->can_dma &&
> +	    spi_imx_can_dma(spi_imx->bitbang.master, spi, transfer)) {
> +		spi_imx->usedma =3D true;
> +		ret =3D spi_imx_dma_transfer(spi_imx, transfer);
> +		if (ret !=3D -EAGAIN)
> +			return ret;
> +	}
> +	spi_imx->usedma =3D false;
> +
> +	return spi_imx_pio_transfer(spi, transfer);
> +}
> +
>  static int spi_imx_setup(struct spi_device *spi)
>  {
>  	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
> @@ -911,6 +1177,13 @@ static int spi_imx_probe(struct platform_device *pd=
ev)
>  		goto out_put_per;
> =20
>  	spi_imx->spi_clk =3D clk_get_rate(spi_imx->clk_per);
> +	/*
> +	 * Only validated on i.mx6 now, can remove the constrain if validated on
> +	 * other chips.
> +	 */
> +	if (spi_imx->devtype_data =3D=3D &imx51_ecspi_devtype_data
> +	    && spi_imx_sdma_init(&pdev->dev, spi_imx, master, res))
> +		dev_err(&pdev->dev, "dma setup error,use pio instead\n");
> =20
>  	spi_imx->devtype_data->reset(spi_imx);
> =20
> @@ -949,6 +1222,7 @@ static int spi_imx_remove(struct platform_device *pd=
ev)
>  	writel(0, spi_imx->base + MXC_CSPICTRL);
>  	clk_unprepare(spi_imx->clk_ipg);
>  	clk_unprepare(spi_imx->clk_per);
> +	spi_imx_sdma_exit(spi_imx);
>  	spi_master_put(master);
> =20
>  	return 0;
> --=20
> 1.9.1
>=20
>=20

--hjTNX7PlvRO2hhYY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF2qwAAoJECTWi3JdVIfQLLoH/1COb9K+D+n3lVUIpVidMHPy
+rAynKfWSQNMj614Dh9aksp+VrHxeDG0hiXN9s5g+SlZzhW+CpsucXGcvhD/RIgq
4R0maKdsWcLBa0Wk5hrKLUyHcj+7P8vQFOpRWGobkG1n//lyQouSkQ0a1jRp74j/
mLVVhxvEo9+GmVvQdtU9iSqDBHSMjC9O07htEDat1uvqDUbbEQhRAh0Onu8aSjj6
llr2x6wMEuSSiuiZ5PfOkBeWozLIEMpU4vg+WBeyy3lVO6p3QNfNBg72pa9RGarp
C40yQkRhqxRdJMdiz23+RBP02x19yRwRLl9k2H2XOw98UjcZbBJ/mKzxsIQZdsw=
=h9L4
-----END PGP SIGNATURE-----

--hjTNX7PlvRO2hhYY--
