Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaBRPkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:40:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755330AbaBRPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:40:08 -0500
Date: Tue, 18 Feb 2014 16:37:31 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: David =?iso-8859-1?Q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/8] ARM: sunxi: Add driver for SD/MMC hosts found on
 Allwinner sunxi SoCs
Message-ID: <20140218153731.GK3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100234.15040.84232.stgit@pagira.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MHXEHrrXKLGx71o"
Content-Disposition: inline
In-Reply-To: <20140217100234.15040.84232.stgit@pagira.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MHXEHrrXKLGx71o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry for taking a bit of time to review this.

On Mon, Feb 17, 2014 at 11:02:34AM +0100, David Lanzend=F6rfer wrote:
> This is based on the driver Allwinner ships in their Android kernel sourc=
es.
>=20
> Initial porting to upstream kernels done by David Lanzend=F6rfer, additio=
nal
> fixes and cleanups by Hans de Goede.

This belongs to the driver copyright or MODULE_AUTHOR, not really in
the commit log.

What you should describe here is what the driver does, what the device
it drives is capable of, would it be possible to share some common
code with other drivers, why didn't you do it, etc.

>=20
> It uses dma in bus-master mode using a built-in designware idmac controll=
er,
> which is identical to the one found in the mmc-dw hosts.
> The rest of the host is not identical to mmc-dw.
>=20
> Signed-off-by: David Lanzend=F6rfer <david.lanzendoerfer@o2s.ch>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/mmc/host/Kconfig     |    7=20
>  drivers/mmc/host/Makefile    |    2=20
>  drivers/mmc/host/sunxi-mmc.c |  876 ++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/mmc/host/sunxi-mmc.h |  239 +++++++++++
>  4 files changed, 1124 insertions(+)
>  create mode 100644 drivers/mmc/host/sunxi-mmc.c
>  create mode 100644 drivers/mmc/host/sunxi-mmc.h
>=20
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 1384f67..7caf266 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -689,3 +689,10 @@ config MMC_REALTEK_PCI
>  	help
>  	  Say Y here to include driver code to support SD/MMC card interface
>  	  of Realtek PCI-E card reader
> +
> +config MMC_SUNXI
> +	tristate "Allwinner sunxi SD/MMC Host Controller support"
> +	depends on ARCH_SUNXI
> +	help
> +	  This selects support for the SD/MMC Host Controller on
> +	  Allwinner sunxi SoCs.
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index 3483b6b..f3c7c243 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -54,6 +54,8 @@ obj-$(CONFIG_MMC_WMT)		+=3D wmt-sdmmc.o
> =20
>  obj-$(CONFIG_MMC_REALTEK_PCI)	+=3D rtsx_pci_sdmmc.o
> =20
> +obj-$(CONFIG_MMC_SUNXI)		+=3D sunxi-mmc.o
> +
>  obj-$(CONFIG_MMC_SDHCI_PLTFM)		+=3D sdhci-pltfm.o
>  obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+=3D sdhci-cns3xxx.o
>  obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+=3D sdhci-esdhc-imx.o
> diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
> new file mode 100644
> index 0000000..752e913
> --- /dev/null
> +++ b/drivers/mmc/host/sunxi-mmc.c
> @@ -0,0 +1,876 @@
> +/*
> + * Driver for sunxi SD/MMC host controllers
> + * (C) Copyright 2007-2011 Reuuimlla Technology Co., Ltd.
> + * (C) Copyright 2007-2011 Aaron Maoye <leafy.myeh@reuuimllatech.com>
> + * (C) Copyright 2013-2014 O2S GmbH <www.o2s.ch>
> + * (C) Copyright 2013-2014 David Lanzend?rfer <david.lanzendoerfer@o2s.c=
h>
> + * (C) Copyright 2013-2014 Hans de Goede <hdegoede@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +
> +#include <linux/clk.h>
> +#include <linux/clk-private.h>
> +#include <linux/clk/sunxi.h>
> +
> +#include <linux/gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <linux/of_address.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
> +
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/sd.h>
> +#include <linux/mmc/sdio.h>
> +#include <linux/mmc/mmc.h>
> +#include <linux/mmc/core.h>
> +#include <linux/mmc/card.h>
> +#include <linux/mmc/slot-gpio.h>
> +
> +#include "sunxi-mmc.h"

Usually, drivers don't have a header of their own.

> +static int sunxi_mmc_init_host(struct mmc_host *mmc)
> +{
> +	u32 rval;
> +	struct sunxi_mmc_host *smc_host =3D mmc_priv(mmc);
> +	int ret;
> +
> +	ret =3D  clk_prepare_enable(smc_host->clk_ahb);
> +	if (ret) {
> +		dev_err(mmc_dev(smc_host->mmc), "AHB clk err %d\n", ret);
> +		return ret;
> +	}

Newline.

> +	ret =3D  clk_prepare_enable(smc_host->clk_mod);
> +	if (ret) {
> +		dev_err(mmc_dev(smc_host->mmc), "MOD clk err %d\n", ret);
> +		clk_disable_unprepare(smc_host->clk_ahb);
> +		return ret;
> +	}
> +
> +	/* reset controller */
> +	rval =3D mci_readl(smc_host, REG_GCTRL) | SDXC_HARDWARE_RESET;

You seem to be sometimes using either a oneline construct like this
one, or on several lines. It would be great if you were to be using
the same everywhere.

> +	mci_writel(smc_host, REG_GCTRL, rval);
> +
> +	mci_writel(smc_host, REG_FTRGL, 0x20070008);
> +	mci_writel(smc_host, REG_TMOUT, 0xffffffff);
> +	mci_writel(smc_host, REG_IMASK, smc_host->sdio_imask);
> +	mci_writel(smc_host, REG_RINTR, 0xffffffff);
> +	mci_writel(smc_host, REG_DBGC, 0xdeb);
> +	mci_writel(smc_host, REG_FUNS, 0xceaa0000);
> +	mci_writel(smc_host, REG_DLBA, smc_host->sg_dma);

Newline.

> +	rval =3D mci_readl(smc_host, REG_GCTRL)|SDXC_INTERRUPT_ENABLE_BIT;
> +	rval &=3D ~SDXC_ACCESS_DONE_DIRECT;
> +	mci_writel(smc_host, REG_GCTRL, rval);
> +
> +	return 0;
> +}
> +
> +static void sunxi_mmc_exit_host(struct sunxi_mmc_host *smc_host)
> +{
> +	mci_writel(smc_host, REG_GCTRL, SDXC_HARDWARE_RESET);
> +	clk_disable_unprepare(smc_host->clk_ahb);
> +	clk_disable_unprepare(smc_host->clk_mod);
> +}
> +
> +/* /\* UHS-I Operation Modes */
> +/*  * DS		25MHz	12.5MB/s	3.3V */
> +/*  * HS		50MHz	25MB/s		3.3V */
> +/*  * SDR12	25MHz	12.5MB/s	1.8V */
> +/*  * SDR25	50MHz	25MB/s		1.8V */
> +/*  * SDR50	100MHz	50MB/s		1.8V */
> +/*  * SDR104	208MHz	104MB/s		1.8V */
> +/*  * DDR50	50MHz	50MB/s		1.8V */
> +/*  * MMC Operation Modes */
> +/*  * DS		26MHz	26MB/s		3/1.8/1.2V */
> +/*  * HS		52MHz	52MB/s		3/1.8/1.2V */
> +/*  * HSDDR	52MHz	104MB/s		3/1.8/1.2V */
> +/*  * HS200	200MHz	200MB/s		1.8/1.2V */
> +/*  * */
> +/*  * Spec. Timing */
> +/*  * SD3.0 */
> +/*  * Fcclk    Tcclk   Fsclk   Tsclk   Tis     Tih     odly  RTis     RT=
ih */
> +/*  * 400K     2.5us   24M     41ns    5ns     5ns     1     2209ns   41=
ns */
> +/*  * 25M      40ns    600M    1.67ns  5ns     5ns     3     14.99ns  5.=
01ns */
> +/*  * 50M      20ns    600M    1.67ns  6ns     2ns     3     14.99ns  5.=
01ns */
> +/*  * 50MDDR   20ns    600M    1.67ns  6ns     0.8ns   2     6.67ns   3.=
33ns */
> +/*  * 104M     9.6ns   600M    1.67ns  3ns     0.8ns   1     7.93ns   1.=
67ns */
> +/*  * 208M     4.8ns   600M    1.67ns  1.4ns   0.8ns   1     3.33ns   1.=
67ns */
> +
> +/*  * 25M      40ns    300M    3.33ns  5ns     5ns     2     13.34ns   6=
=2E66ns */
> +/*  * 50M      20ns    300M    3.33ns  6ns     2ns     2     13.34ns   6=
=2E66ns */
> +/*  * 50MDDR   20ns    300M    3.33ns  6ns     0.8ns   1     6.67ns    3=
=2E33ns */
> +/*  * 104M     9.6ns   300M    3.33ns  3ns     0.8ns   0     7.93ns    1=
=2E67ns */
> +/*  * 208M     4.8ns   300M    3.33ns  1.4ns   0.8ns   0     3.13ns    1=
=2E67ns */
> +
> +/*  * eMMC4.5 */
> +/*  * 400K     2.5us   24M     41ns    3ns     3ns     1     2209ns    4=
1ns */
> +/*  * 25M      40ns    600M    1.67ns  3ns     3ns     3     14.99ns   5=
=2E01ns */
> +/*  * 50M      20ns    600M    1.67ns  3ns     3ns     3     14.99ns   5=
=2E01ns */
> +/*  * 50MDDR   20ns    600M    1.67ns  2.5ns   2.5ns   2     6.67ns    3=
=2E33ns */
> +/*  * 200M     5ns     600M    1.67ns  1.4ns   0.8ns   1     3.33ns    1=
=2E67ns */
> +/*  *\/ */
> +
> +static void sunxi_mmc_init_idma_des(struct sunxi_mmc_host *host,
> +				    struct mmc_data *data)
> +{
> +	struct sunxi_idma_des *pdes =3D (struct sunxi_idma_des *)host->sg_cpu;
> +	struct sunxi_idma_des *pdes_pa =3D (struct sunxi_idma_des *)host->sg_dm=
a;
> +	int i, max_len =3D (1 << host->idma_des_size_bits);

Please use the BIT() macro here.

> +
> +	for (i =3D 0; i < data->sg_len; i++) {
> +		pdes[i].config =3D SDXC_IDMAC_DES0_CH | SDXC_IDMAC_DES0_OWN |
> +				 SDXC_IDMAC_DES0_DIC;
> +
> +		if (data->sg[i].length =3D=3D max_len)
> +			pdes[i].buf_size =3D 0; /* 0 =3D=3D max_len */
> +		else
> +			pdes[i].buf_size =3D data->sg[i].length;
> +
> +		pdes[i].buf_addr_ptr1 =3D sg_dma_address(&data->sg[i]);
> +		pdes[i].buf_addr_ptr2 =3D (u32)&pdes_pa[i + 1];
> +	}
> +
> +	pdes[0].config |=3D SDXC_IDMAC_DES0_FD;
> +	pdes[i - 1].config =3D SDXC_IDMAC_DES0_OWN | SDXC_IDMAC_DES0_LD;
> +
> +	wmb(); /* Ensure idma_des hit main mem before we start the idmac */

wmb ensure the proper ordering of the instructions, not flushing the
caches like what your comment implies.

> +}
> +
> +static enum dma_data_direction sunxi_mmc_get_dma_dir(struct mmc_data *da=
ta)
> +{
> +	if (data->flags & MMC_DATA_WRITE)
> +		return DMA_TO_DEVICE;
> +	else
> +		return DMA_FROM_DEVICE;
> +}
> +
> +static int sunxi_mmc_prepare_dma(struct sunxi_mmc_host *smc_host,
> +				 struct mmc_data *data)
> +{
> +	u32 dma_len;
> +	u32 i;
> +	u32 temp;
> +	struct scatterlist *sg;
> +
> +	dma_len =3D dma_map_sg(mmc_dev(smc_host->mmc), data->sg, data->sg_len,
> +			     sunxi_mmc_get_dma_dir(data));
> +	if (dma_len =3D=3D 0) {
> +		dev_err(mmc_dev(smc_host->mmc), "dma_map_sg failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	for_each_sg(data->sg, sg, data->sg_len, i) {
> +		if (sg->offset & 3 || sg->length & 3) {
> +			dev_err(mmc_dev(smc_host->mmc),
> +				"unaligned scatterlist: os %x length %d\n",
> +				sg->offset, sg->length);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	sunxi_mmc_init_idma_des(smc_host, data);
> +
> +	temp =3D mci_readl(smc_host, REG_GCTRL);
> +	temp |=3D SDXC_DMA_ENABLE_BIT;
> +	mci_writel(smc_host, REG_GCTRL, temp);
> +	temp |=3D SDXC_DMA_RESET;
> +	mci_writel(smc_host, REG_GCTRL, temp);

Does it really need to be done in two steps?

(Newline)

> +	mci_writel(smc_host, REG_DMAC, SDXC_IDMAC_SOFT_RESET);
> +
> +	if (!(data->flags & MMC_DATA_WRITE))
> +		mci_writel(smc_host, REG_IDIE, SDXC_IDMAC_RECEIVE_INTERRUPT);
> +
> +	mci_writel(smc_host, REG_DMAC, SDXC_IDMAC_FIX_BURST | SDXC_IDMAC_IDMA_O=
N);
> +
> +	return 0;
> +}
> +
> +static void sunxi_mmc_send_manual_stop(struct sunxi_mmc_host *host,
> +				       struct mmc_request *req)
> +{
> +	u32 cmd_val =3D SDXC_START | SDXC_RESP_EXPIRE | SDXC_STOP_ABORT_CMD
> +			| SDXC_CHECK_RESPONSE_CRC | MMC_STOP_TRANSMISSION;
> +	u32 ri =3D 0;
> +	unsigned long expire =3D jiffies + msecs_to_jiffies(1000);
> +
> +	mci_writel(host, REG_CARG, 0);
> +	mci_writel(host, REG_CMDR, cmd_val);
> +
> +	do {
> +		ri =3D mci_readl(host, REG_RINTR);
> +	} while (!(ri & (SDXC_COMMAND_DONE | SDXC_INTERRUPT_ERROR_BIT)) &&
> +		 time_before(jiffies, expire));
> +
> +	if (ri & SDXC_INTERRUPT_ERROR_BIT) {
> +		dev_err(mmc_dev(host->mmc), "send stop command failed\n");
> +		if (req->stop)
> +			req->stop->resp[0] =3D -ETIMEDOUT;
> +	} else {
> +		if (req->stop)
> +			req->stop->resp[0] =3D mci_readl(host, REG_RESP0);
> +	}
> +
> +	mci_writel(host, REG_RINTR, 0xffff);
> +}
> +
> +static void sunxi_mmc_dump_errinfo(struct sunxi_mmc_host *smc_host)
> +{
> +	struct mmc_command *cmd =3D smc_host->mrq->cmd;
> +	struct mmc_data *data =3D smc_host->mrq->data;
> +
> +	/* For some cmds timeout is normal with sd/mmc cards */
> +	if ((smc_host->int_sum & SDXC_INTERRUPT_ERROR_BIT) =3D=3D SDXC_RESP_TIM=
EOUT &&
> +			(cmd->opcode =3D=3D SD_IO_SEND_OP_COND || cmd->opcode =3D=3D SD_IO_RW=
_DIRECT))
> +		return;
> +
> +	dev_err(mmc_dev(smc_host->mmc),

I'd rather put it at a debug loglevel.

> +		"smc %d err, cmd %d,%s%s%s%s%s%s%s%s%s%s !!\n",
> +		smc_host->mmc->index, cmd->opcode,
> +		data ? (data->flags & MMC_DATA_WRITE ? " WR" : " RD") : "",
> +		smc_host->int_sum & SDXC_RESP_ERROR     ? " RE"     : "",
> +		smc_host->int_sum & SDXC_RESP_CRC_ERROR  ? " RCE"    : "",
> +		smc_host->int_sum & SDXC_DATA_CRC_ERROR  ? " DCE"    : "",
> +		smc_host->int_sum & SDXC_RESP_TIMEOUT ? " RTO"    : "",
> +		smc_host->int_sum & SDXC_DATA_TIMEOUT ? " DTO"    : "",
> +		smc_host->int_sum & SDXC_FIFO_RUN_ERROR  ? " FE"     : "",
> +		smc_host->int_sum & SDXC_HARD_WARE_LOCKED ? " HL"     : "",
> +		smc_host->int_sum & SDXC_START_BIT_ERROR ? " SBE"    : "",
> +		smc_host->int_sum & SDXC_END_BIT_ERROR   ? " EBE"    : ""
> +		);
> +}
> +
> +static void sunxi_mmc_finalize_request(struct sunxi_mmc_host *host)
> +{
> +	struct mmc_request *mrq;
> +	unsigned long iflags;
> +
> +	spin_lock_irqsave(&host->lock, iflags);
> +
> +	mrq =3D host->mrq;
> +	if (!mrq) {
> +		spin_unlock_irqrestore(&host->lock, iflags);
> +		dev_err(mmc_dev(host->mmc), "no request to finalize\n");
> +		return;
> +	}
> +
> +	if (host->int_sum & SDXC_INTERRUPT_ERROR_BIT) {
> +		sunxi_mmc_dump_errinfo(host);
> +		mrq->cmd->error =3D -ETIMEDOUT;

Newline

> +		if (mrq->data)
> +			mrq->data->error =3D -ETIMEDOUT;

Newline

> +		if (mrq->stop)
> +			mrq->stop->error =3D -ETIMEDOUT;
> +	} else {
> +		if (mrq->cmd->flags & MMC_RSP_136) {
> +			mrq->cmd->resp[0] =3D mci_readl(host, REG_RESP3);
> +			mrq->cmd->resp[1] =3D mci_readl(host, REG_RESP2);
> +			mrq->cmd->resp[2] =3D mci_readl(host, REG_RESP1);
> +			mrq->cmd->resp[3] =3D mci_readl(host, REG_RESP0);
> +		} else {
> +			mrq->cmd->resp[0] =3D mci_readl(host, REG_RESP0);
> +		}
> +

Newline

> +		if (mrq->data)
> +			mrq->data->bytes_xfered =3D
> +				mrq->data->blocks * mrq->data->blksz;
> +	}
> +
> +	if (mrq->data) {
> +		struct mmc_data *data =3D mrq->data;
> +		u32 temp;
> +
> +		mci_writel(host, REG_IDST, 0x337);
> +		mci_writel(host, REG_DMAC, 0);
> +		temp =3D mci_readl(host, REG_GCTRL);
> +		mci_writel(host, REG_GCTRL, temp|SDXC_DMA_RESET);
> +		temp &=3D ~SDXC_DMA_ENABLE_BIT;
> +		mci_writel(host, REG_GCTRL, temp);
> +		temp |=3D SDXC_FIFO_RESET;
> +		mci_writel(host, REG_GCTRL, temp);
> +		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
> +				     sunxi_mmc_get_dma_dir(data));
> +	}
> +
> +	mci_writel(host, REG_RINTR, 0xffff);
> +
> +	dev_dbg(mmc_dev(host->mmc), "req done, resp %08x %08x %08x %08x\n",
> +		mrq->cmd->resp[0], mrq->cmd->resp[1],
> +		mrq->cmd->resp[2], mrq->cmd->resp[3]);
> +
> +	host->mrq =3D NULL;
> +	host->int_sum =3D 0;
> +	host->wait_dma =3D 0;
> +
> +	spin_unlock_irqrestore(&host->lock, iflags);
> +
> +	if (mrq->data && mrq->data->error) {
> +		dev_err(mmc_dev(host->mmc),
> +			"data error, sending stop command\n");
> +		sunxi_mmc_send_manual_stop(host, mrq);
> +	}
> +
> +	mmc_request_done(host->mmc, mrq);
> +}
> +
> +static irqreturn_t sunxi_mmc_irq(int irq, void *dev_id)
> +{
> +	struct sunxi_mmc_host *host =3D dev_id;
> +	u32 finalize =3D 0;
> +	u32 sdio_int =3D 0;
> +	u32 msk_int;
> +	u32 idma_int;
> +
> +	spin_lock(&host->lock);
> +
> +	idma_int  =3D mci_readl(host, REG_IDST);
> +	msk_int   =3D mci_readl(host, REG_MISTA);
> +
> +	dev_dbg(mmc_dev(host->mmc), "irq: rq %p mi %08x idi %08x\n",
> +		host->mrq, msk_int, idma_int);
> +
> +	if (host->mrq) {
> +		if (idma_int & SDXC_IDMAC_RECEIVE_INTERRUPT)
> +			host->wait_dma =3D 0;
> +
> +		host->int_sum |=3D msk_int;
> +
> +		/* Wait for COMMAND_DONE on RESPONSE_TIMEOUT before finishing the req =
*/
> +		if ((host->int_sum & SDXC_RESP_TIMEOUT) &&
> +				!(host->int_sum & SDXC_COMMAND_DONE))
> +			mci_writel(host, REG_IMASK,
> +				   host->sdio_imask | SDXC_COMMAND_DONE);
> +		else if (host->int_sum & SDXC_INTERRUPT_ERROR_BIT)
> +			finalize =3D 1; /* Don't wait for dma on error */
> +		else if (host->int_sum & SDXC_INTERRUPT_DONE_BIT && !host->wait_dma)
> +			finalize =3D 1; /* Done */

Usually, the comments are not placed on the same line, but on a
separate line just above (like you did a few lines earlier).

> +
> +		if (finalize) {
> +			mci_writel(host, REG_IMASK, host->sdio_imask);
> +			mci_writel(host, REG_IDIE, 0);
> +		}
> +	}
> +
> +	if (msk_int & SDXC_SDIO_INTERRUPT)
> +		sdio_int =3D 1;
> +
> +	mci_writel(host, REG_RINTR, msk_int);
> +	mci_writel(host, REG_IDST, idma_int);
> +
> +	spin_unlock(&host->lock);
> +
> +	if (finalize)
> +		tasklet_schedule(&host->tasklet);
> +
> +	if (sdio_int)
> +		mmc_signal_sdio_irq(host->mmc);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void sunxi_mmc_tasklet(unsigned long data)
> +{
> +	struct sunxi_mmc_host *smc_host =3D (struct sunxi_mmc_host *) data;
> +	sunxi_mmc_finalize_request(smc_host);
> +}
> +
> +static void sunxi_mmc_oclk_onoff(struct sunxi_mmc_host *host, u32 oclk_e=
n)
> +{
> +	unsigned long expire =3D jiffies + msecs_to_jiffies(2000);
> +	u32 rval;
> +
> +	rval =3D mci_readl(host, REG_CLKCR);
> +	rval &=3D ~(SDXC_CARD_CLOCK_ON | SDXC_LOW_POWER_ON);
> +
> +	if (oclk_en)
> +		rval |=3D SDXC_CARD_CLOCK_ON;
> +
> +	if (!host->io_flag)
> +		rval |=3D SDXC_LOW_POWER_ON;
> +
> +	mci_writel(host, REG_CLKCR, rval);
> +
> +	rval =3D SDXC_START | SDXC_UPCLK_ONLY | SDXC_WAIT_PRE_OVER;
> +	if (host->voltage_switching)
> +		rval |=3D SDXC_VOLTAGE_SWITCH;
> +	mci_writel(host, REG_CMDR, rval);
> +
> +	do {
> +		rval =3D mci_readl(host, REG_CMDR);
> +	} while (time_before(jiffies, expire) && (rval & SDXC_START));
> +
> +	if (rval & SDXC_START) {
> +		dev_err(mmc_dev(host->mmc), "fatal err update clk timeout\n");
> +		host->ferror =3D 1;
> +	}
> +}
> +
> +static void sunxi_mmc_set_clk_dly(struct sunxi_mmc_host *smc_host,
> +				  u32 oclk_dly, u32 sclk_dly)
> +{
> +	unsigned long iflags;
> +	struct clk_hw *hw =3D __clk_get_hw(smc_host->clk_mod);
> +
> +	spin_lock_irqsave(&smc_host->lock, iflags);
> +	clk_sunxi_mmc_phase_control(hw, sclk_dly, oclk_dly);
> +	spin_unlock_irqrestore(&smc_host->lock, iflags);
> +}
> +
> +struct sunxi_mmc_clk_dly mmc_clk_dly[MMC_CLK_MOD_NUM] =3D {
> +	{ MMC_CLK_400K, 0, 7 },
> +	{ MMC_CLK_25M, 0, 5 },
> +	{ MMC_CLK_50M, 3, 5 },
> +	{ MMC_CLK_50MDDR, 2, 4 },
> +	{ MMC_CLK_50MDDR_8BIT, 2, 4 },
> +	{ MMC_CLK_100M, 1, 4 },
> +	{ MMC_CLK_200M, 1, 4 },
> +};
> +
> +static void sunxi_mmc_clk_set_rate(struct sunxi_mmc_host *smc_host,
> +				   unsigned int rate)
> +{
> +	u32 newrate;
> +	u32 src_clk;
> +	u32 oclk_dly;
> +	u32 sclk_dly;
> +	u32 temp;
> +	struct sunxi_mmc_clk_dly *dly =3D NULL;
> +
> +	newrate =3D clk_round_rate(smc_host->clk_mod, rate);
> +	if (smc_host->clk_mod_rate =3D=3D newrate) {
> +		dev_dbg(mmc_dev(smc_host->mmc), "clk already %d, rounded %d\n",
> +			rate, newrate);
> +		return;
> +	}
> +
> +	dev_dbg(mmc_dev(smc_host->mmc), "setting clk to %d, rounded %d\n",
> +		rate, newrate);
> +
> +	/* setting clock rate */
> +	clk_disable(smc_host->clk_mod);
> +	clk_set_rate(smc_host->clk_mod, newrate);
> +	clk_enable(smc_host->clk_mod);

You don't need to disable/enable the clocks here.

> +	smc_host->clk_mod_rate =3D newrate =3D clk_get_rate(smc_host->clk_mod);
> +	dev_dbg(mmc_dev(smc_host->mmc), "clk is now %d\n", newrate);

You don't seem to use this newrate variable somewhere else in the
function, can't you just use the clk_mod_rate one?

And it doesn't seem like you use clk_mod_rate much either.

> +
> +	sunxi_mmc_oclk_onoff(smc_host, 0);
> +	/* clear internal divider */
> +	temp =3D mci_readl(smc_host, REG_CLKCR);
> +	temp &=3D ~0xff;
> +	mci_writel(smc_host, REG_CLKCR, temp);
> +
> +	/* determine delays */
> +	if (rate <=3D 400000) {
> +		dly =3D &mmc_clk_dly[MMC_CLK_400K];
> +	} else if (rate <=3D 25000000) {
> +		dly =3D &mmc_clk_dly[MMC_CLK_25M];
> +	} else if (rate <=3D 50000000) {
> +		if (smc_host->ddr) {
> +			if (smc_host->bus_width =3D=3D 8)
> +				dly =3D &mmc_clk_dly[MMC_CLK_50MDDR_8BIT];
> +			else
> +				dly =3D &mmc_clk_dly[MMC_CLK_50MDDR];
> +		} else {
> +			dly =3D &mmc_clk_dly[MMC_CLK_50M];
> +		}
> +	} else if (rate <=3D 104000000) {
> +		dly =3D &mmc_clk_dly[MMC_CLK_100M];
> +	} else if (rate <=3D 208000000) {
> +		dly =3D &mmc_clk_dly[MMC_CLK_200M];
> +	} else {
> +		dly =3D &mmc_clk_dly[MMC_CLK_50M];
> +	}
> +
> +	oclk_dly =3D dly->oclk_dly;
> +	sclk_dly =3D dly->sclk_dly;
> +
> +	src_clk =3D clk_get_rate(clk_get_parent(smc_host->clk_mod));
> +
> +	if (src_clk >=3D 300000000 && src_clk <=3D 400000000) {
> +		if (oclk_dly)
> +			oclk_dly--;
> +		if (sclk_dly)
> +			sclk_dly--;
> +	}
> +
> +	sunxi_mmc_set_clk_dly(smc_host, oclk_dly, sclk_dly);
> +	sunxi_mmc_oclk_onoff(smc_host, 1);
> +
> +	/* oclk_onoff sets various irq status bits, clear these */
> +	mci_writel(smc_host, REG_RINTR,
> +		   mci_readl(smc_host, REG_RINTR) & ~SDXC_SDIO_INTERRUPT);
> +}
> +
> +static void sunxi_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> +{
> +	struct sunxi_mmc_host *host =3D mmc_priv(mmc);
> +	u32 temp;
> +	s32 err;
> +
> +	/* Set the power state */
> +	switch (ios->power_mode) {
> +	case MMC_POWER_ON:
> +		break;
> +
> +	case MMC_POWER_UP:
> +		if (!IS_ERR(host->vmmc)) {
> +			mmc_regulator_set_ocr(host->mmc, host->vmmc, ios->vdd);
> +			udelay(200);
> +		}
> +
> +		err =3D sunxi_mmc_init_host(mmc);
> +		if (err) {
> +			host->ferror =3D 1;
> +			return;
> +		}

Newline

> +		enable_irq(host->irq);
> +
> +		dev_dbg(mmc_dev(host->mmc), "power on!\n");
> +		host->ferror =3D 0;
> +		break;
> +
> +	case MMC_POWER_OFF:
> +		dev_dbg(mmc_dev(host->mmc), "power off!\n");
> +		disable_irq(host->irq);
> +		sunxi_mmc_exit_host(host);
> +		if (!IS_ERR(host->vmmc))
> +			mmc_regulator_set_ocr(host->mmc, host->vmmc, 0);

Newline

> +		host->ferror =3D 0;
> +		break;
> +	}
> +
> +	/* set bus width */
> +	switch (ios->bus_width) {
> +	case MMC_BUS_WIDTH_1:
> +		mci_writel(host, REG_WIDTH, SDXC_WIDTH1);
> +		host->bus_width =3D 1;
> +		break;
> +	case MMC_BUS_WIDTH_4:
> +		mci_writel(host, REG_WIDTH, SDXC_WIDTH4);
> +		host->bus_width =3D 4;
> +		break;
> +	case MMC_BUS_WIDTH_8:
> +		mci_writel(host, REG_WIDTH, SDXC_WIDTH8);
> +		host->bus_width =3D 8;
> +		break;
> +	}
> +
> +	/* set ddr mode */
> +	temp =3D mci_readl(host, REG_GCTRL);
> +	if (ios->timing =3D=3D MMC_TIMING_UHS_DDR50) {
> +		temp |=3D SDXC_DDR_MODE;
> +		host->ddr =3D 1;
> +	} else {
> +		temp &=3D ~SDXC_DDR_MODE;
> +		host->ddr =3D 0;
> +	}
> +	mci_writel(host, REG_GCTRL, temp);
> +
> +	/* set up clock */
> +	if (ios->clock && ios->power_mode) {
> +		dev_dbg(mmc_dev(host->mmc), "ios->clock: %d\n", ios->clock);
> +		sunxi_mmc_clk_set_rate(host, ios->clock);
> +		usleep_range(50000, 55000);
> +	}
> +}
> +
> +static void sunxi_mmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
> +{
> +	struct sunxi_mmc_host *smc_host =3D mmc_priv(mmc);
> +	unsigned long flags;
> +	int ret;
> +	u32 imask;
> +
> +	spin_lock_irqsave(&smc_host->lock, flags);
> +
> +	/* Make sure the controller is in a sane state before enabling irqs */
> +	ret =3D sunxi_mmc_init_host(mmc);
> +	if (ret) {
> +		spin_unlock_irqrestore(&smc_host->lock, flags);
> +		return;
> +	}
> +
> +	imask =3D mci_readl(smc_host, REG_IMASK);
> +	if (enable) {
> +		smc_host->sdio_imask =3D SDXC_SDIO_INTERRUPT;
> +		imask |=3D SDXC_SDIO_INTERRUPT;
> +	} else {
> +		smc_host->sdio_imask =3D 0;
> +		imask &=3D ~SDXC_SDIO_INTERRUPT;
> +	}
> +	mci_writel(smc_host, REG_IMASK, imask);
> +	spin_unlock_irqrestore(&smc_host->lock, flags);
> +}
> +
> +static void sunxi_mmc_hw_reset(struct mmc_host *mmc)
> +{
> +	struct sunxi_mmc_host *smc_host =3D mmc_priv(mmc);
> +	mci_writel(smc_host, REG_HWRST, 0);
> +	udelay(10);
> +	mci_writel(smc_host, REG_HWRST, 1);
> +	udelay(300);
> +}
> +
> +static void sunxi_mmc_request(struct mmc_host *mmc, struct mmc_request *=
mrq)
> +{
> +	struct sunxi_mmc_host *host =3D mmc_priv(mmc);
> +	struct mmc_command *cmd =3D mrq->cmd;
> +	struct mmc_data *data =3D mrq->data;
> +	unsigned long iflags;
> +	u32 imask =3D SDXC_INTERRUPT_ERROR_BIT;
> +	u32 cmd_val =3D SDXC_START | (cmd->opcode & 0x3f);
> +	u32 byte_cnt =3D 0;
> +	int ret;
> +
> +	if (!mmc_gpio_get_cd(mmc) || host->ferror) {
> +		dev_dbg(mmc_dev(host->mmc), "no medium present\n");
> +		mrq->cmd->error =3D -ENOMEDIUM;
> +		mmc_request_done(mmc, mrq);
> +		return;
> +	}
> +
> +	if (data) {
> +		byte_cnt =3D data->blksz * data->blocks;
> +		mci_writel(host, REG_BLKSZ, data->blksz);
> +		mci_writel(host, REG_BCNTR, byte_cnt);
> +		ret =3D sunxi_mmc_prepare_dma(host, data);
> +		if (ret < 0) {
> +			dev_err(mmc_dev(host->mmc), "prepare DMA failed\n");
> +			cmd->error =3D ret;
> +			cmd->data->error =3D ret;
> +			mmc_request_done(host->mmc, mrq);
> +			return;
> +		}
> +	}
> +
> +	if (cmd->opcode =3D=3D MMC_GO_IDLE_STATE) {
> +		cmd_val |=3D SDXC_SEND_INIT_SEQUENCE;
> +		imask |=3D SDXC_COMMAND_DONE;
> +	}
> +
> +	if (cmd->opcode =3D=3D SD_SWITCH_VOLTAGE) {
> +		cmd_val |=3D SDXC_VOLTAGE_SWITCH;
> +		imask |=3D SDXC_VOLTAGE_CHANGE_DONE;
> +		host->voltage_switching =3D 1;
> +		sunxi_mmc_oclk_onoff(host, 1);
> +	}
> +
> +	if (cmd->flags & MMC_RSP_PRESENT) {
> +		cmd_val |=3D SDXC_RESP_EXPIRE;
> +		if (cmd->flags & MMC_RSP_136)
> +			cmd_val |=3D SDXC_LONG_RESPONSE;
> +		if (cmd->flags & MMC_RSP_CRC)
> +			cmd_val |=3D SDXC_CHECK_RESPONSE_CRC;
> +
> +		if ((cmd->flags & MMC_CMD_MASK) =3D=3D MMC_CMD_ADTC) {
> +			cmd_val |=3D SDXC_DATA_EXPIRE | SDXC_WAIT_PRE_OVER;
> +			if (cmd->data->flags & MMC_DATA_STREAM) {
> +				imask |=3D SDXC_AUTO_COMMAND_DONE;
> +				cmd_val |=3D SDXC_SEQUENCE_MODE | SDXC_SEND_AUTO_STOP;
> +			}

Newline

> +			if (cmd->data->stop) {
> +				imask |=3D SDXC_AUTO_COMMAND_DONE;
> +				cmd_val |=3D SDXC_SEND_AUTO_STOP;
> +			} else
> +				imask |=3D SDXC_DATA_OVER;

You should have braces here

> +			if (cmd->data->flags & MMC_DATA_WRITE)
> +				cmd_val |=3D SDXC_WRITE;
> +			else
> +				host->wait_dma =3D 1;
> +		} else
> +			imask |=3D SDXC_COMMAND_DONE;

And here

> +	} else
> +		imask |=3D SDXC_COMMAND_DONE;

And here

> +	dev_dbg(mmc_dev(host->mmc), "cmd %d(%08x) arg %x ie 0x%08x len %d\n",
> +		cmd_val & 0x3f, cmd_val, cmd->arg, imask,
> +		mrq->data ? mrq->data->blksz * mrq->data->blocks : 0);
> +
> +	spin_lock_irqsave(&host->lock, iflags);
> +	host->mrq =3D mrq;
> +	mci_writel(host, REG_IMASK, host->sdio_imask | imask);
> +	spin_unlock_irqrestore(&host->lock, iflags);
> +
> +	mci_writel(host, REG_CARG, cmd->arg);
> +	mci_writel(host, REG_CMDR, cmd_val);
> +}
> +
> +static const struct of_device_id sunxi_mmc_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun4i-a10-mmc", },
> +	{ .compatible =3D "allwinner,sun5i-a13-mmc", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, sunxi_mmc_of_match);
> +
> +static struct mmc_host_ops sunxi_mmc_ops =3D {
> +	.request	 =3D sunxi_mmc_request,
> +	.set_ios	 =3D sunxi_mmc_set_ios,
> +	.get_ro		 =3D mmc_gpio_get_ro,
> +	.get_cd		 =3D mmc_gpio_get_cd,
> +	.enable_sdio_irq =3D sunxi_mmc_enable_sdio_irq,
> +	.hw_reset	 =3D sunxi_mmc_hw_reset,
> +};
> +
> +static int sunxi_mmc_resource_request(struct sunxi_mmc_host *host,
> +				      struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	int ret;
> +
> +	if (of_device_is_compatible(np, "allwinner,sun4i-a10-mmc"))
> +		host->idma_des_size_bits =3D 13;
> +	else
> +		host->idma_des_size_bits =3D 16;
> +
> +	host->vmmc =3D devm_regulator_get_optional(&pdev->dev, "vmmc");
> +	if (IS_ERR(host->vmmc) && PTR_ERR(host->vmmc) =3D=3D -EPROBE_DEFER)
> +		return -EPROBE_DEFER;
> +
> +	host->reg_base =3D devm_ioremap_resource(&pdev->dev,
> +			      platform_get_resource(pdev, IORESOURCE_MEM, 0));
> +	if (IS_ERR(host->reg_base))
> +		return PTR_ERR(host->reg_base);
> +
> +	host->clk_ahb =3D devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(host->clk_ahb)) {
> +		dev_err(&pdev->dev, "Could not get ahb clock\n");
> +		return PTR_ERR(host->clk_ahb);
> +	}
> +
> +	host->clk_mod =3D devm_clk_get(&pdev->dev, "mod");
> +	if (IS_ERR(host->clk_mod)) {
> +		dev_err(&pdev->dev, "Could not get mod clock\n");
> +		return PTR_ERR(host->clk_mod);
> +	}
> +
> +	/* Make sure the controller is in a sane state before enabling irqs */
> +	ret =3D sunxi_mmc_init_host(host->mmc);
> +	if (ret)
> +		return ret;
> +
> +	host->irq =3D platform_get_irq(pdev, 0);
> +	ret =3D devm_request_irq(&pdev->dev, host->irq, sunxi_mmc_irq, 0,
> +			       "sunxi-mmc", host);
> +	if (ret =3D=3D 0)
> +		disable_irq(host->irq);

The disable_irq is useless here. Just exit.

> +
> +	/* And put it back in reset */
> +	sunxi_mmc_exit_host(host);

Hu? If it's in reset, how can it generate some IRQs?

> +	return ret;
> +}
> +
> +static int sunxi_mmc_probe(struct platform_device *pdev)
> +{
> +	struct sunxi_mmc_host *host;
> +	struct mmc_host *mmc;
> +	int ret;
> +
> +	mmc =3D mmc_alloc_host(sizeof(struct sunxi_mmc_host), &pdev->dev);
> +	if (!mmc) {
> +		dev_err(&pdev->dev, "mmc alloc host failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret =3D mmc_of_parse(mmc);
> +	if (ret)
> +		goto error_free_host;
> +
> +	host =3D mmc_priv(mmc);
> +	host->mmc =3D mmc;
> +	spin_lock_init(&host->lock);
> +	tasklet_init(&host->tasklet, sunxi_mmc_tasklet, (unsigned long)host);
> +
> +	ret =3D sunxi_mmc_resource_request(host, pdev);
> +	if (ret)
> +		goto error_free_host;
> +
> +	host->sg_cpu =3D dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> +					  &host->sg_dma, GFP_KERNEL);
> +	if (!host->sg_cpu) {
> +		dev_err(&pdev->dev, "Failed to allocate DMA descriptor mem\n");
> +		ret =3D -ENOMEM;
> +		goto error_free_host;
> +	}
> +
> +	mmc->ops		=3D &sunxi_mmc_ops;
> +	mmc->max_blk_count	=3D 8192;
> +	mmc->max_blk_size	=3D 4096;
> +	mmc->max_segs		=3D PAGE_SIZE / sizeof(struct sunxi_idma_des);
> +	mmc->max_seg_size	=3D (1 << host->idma_des_size_bits);
> +	mmc->max_req_size	=3D mmc->max_seg_size * mmc->max_segs;
> +	/* 400kHz ~ 50MHz */
> +	mmc->f_min		=3D   400000;
> +	mmc->f_max		=3D 50000000;
> +	/* available voltages */
> +	if (!IS_ERR(host->vmmc))
> +		mmc->ocr_avail =3D mmc_regulator_get_ocrmask(host->vmmc);
> +	else
> +		mmc->ocr_avail =3D MMC_VDD_32_33 | MMC_VDD_33_34;
> +
> +	mmc->caps =3D MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
> +		MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25 | MMC_CAP_UHS_SDR50 |
> +		MMC_CAP_UHS_DDR50 | MMC_CAP_SDIO_IRQ | MMC_CAP_DRIVER_TYPE_A;
> +	mmc->caps2 =3D MMC_CAP2_NO_PRESCAN_POWERUP;
> +
> +	ret =3D mmc_add_host(mmc);
> +
> +	if (ret)
> +		goto error_free_dma;
> +
> +	dev_info(&pdev->dev, "base:0x%p irq:%u\n", host->reg_base, host->irq);
> +	platform_set_drvdata(pdev, mmc);

This should be before the registration. Otherwise, you're racy.

> +	return 0;
> +
> +error_free_dma:
> +	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
> +error_free_host:
> +	mmc_free_host(mmc);
> +	return ret;
> +}
> +
> +static int sunxi_mmc_remove(struct platform_device *pdev)
> +{
> +	struct mmc_host	*mmc =3D platform_get_drvdata(pdev);
> +	struct sunxi_mmc_host *host =3D mmc_priv(mmc);
> +
> +	mmc_remove_host(mmc);
> +	sunxi_mmc_exit_host(host);
> +	tasklet_disable(&host->tasklet);
> +	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
> +	mmc_free_host(mmc);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver sunxi_mmc_driver =3D {
> +	.driver =3D {
> +		.name	=3D "sunxi-mmc",
> +		.owner	=3D THIS_MODULE,
> +		.of_match_table =3D of_match_ptr(sunxi_mmc_of_match),
> +	},
> +	.probe		=3D sunxi_mmc_probe,
> +	.remove		=3D sunxi_mmc_remove,
> +};
> +module_platform_driver(sunxi_mmc_driver);
> +
> +MODULE_DESCRIPTION("Allwinner's SD/MMC Card Controller Driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("David Lanzend?rfer <david.lanzendoerfer@o2s.ch>");
> +MODULE_ALIAS("platform:sunxi-mmc");
> diff --git a/drivers/mmc/host/sunxi-mmc.h b/drivers/mmc/host/sunxi-mmc.h
> new file mode 100644
> index 0000000..75eaa02
> --- /dev/null
> +++ b/drivers/mmc/host/sunxi-mmc.h
> @@ -0,0 +1,239 @@
> +/*
> + * Driver for sunxi SD/MMC host controllers
> + * (C) Copyright 2007-2011 Reuuimlla Technology Co., Ltd.
> + * (C) Copyright 2007-2011 Aaron Maoye <leafy.myeh@reuuimllatech.com>
> + * (C) Copyright 2013-2014 O2S GmbH <www.o2s.ch>
> + * (C) Copyright 2013-2014 David Lanzend?rfer <david.lanzendoerfer@o2s.c=
h>
> + * (C) Copyright 2013-2014 Hans de Goede <hdegoede@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + */
> +
> +#ifndef __SUNXI_MMC_H__
> +#define __SUNXI_MMC_H__
> +
> +/* register offset definitions */
> +#define SDXC_REG_GCTRL	(0x00) /* SMC Global Control Register */
> +#define SDXC_REG_CLKCR	(0x04) /* SMC Clock Control Register */
> +#define SDXC_REG_TMOUT	(0x08) /* SMC Time Out Register */
> +#define SDXC_REG_WIDTH	(0x0C) /* SMC Bus Width Register */
> +#define SDXC_REG_BLKSZ	(0x10) /* SMC Block Size Register */
> +#define SDXC_REG_BCNTR	(0x14) /* SMC Byte Count Register */
> +#define SDXC_REG_CMDR	(0x18) /* SMC Command Register */
> +#define SDXC_REG_CARG	(0x1C) /* SMC Argument Register */
> +#define SDXC_REG_RESP0	(0x20) /* SMC Response Register 0 */
> +#define SDXC_REG_RESP1	(0x24) /* SMC Response Register 1 */
> +#define SDXC_REG_RESP2	(0x28) /* SMC Response Register 2 */
> +#define SDXC_REG_RESP3	(0x2C) /* SMC Response Register 3 */
> +#define SDXC_REG_IMASK	(0x30) /* SMC Interrupt Mask Register */
> +#define SDXC_REG_MISTA	(0x34) /* SMC Masked Interrupt Status Register */
> +#define SDXC_REG_RINTR	(0x38) /* SMC Raw Interrupt Status Register */
> +#define SDXC_REG_STAS	(0x3C) /* SMC Status Register */
> +#define SDXC_REG_FTRGL	(0x40) /* SMC FIFO Threshold Watermark Registe */
> +#define SDXC_REG_FUNS	(0x44) /* SMC Function Select Register */
> +#define SDXC_REG_CBCR	(0x48) /* SMC CIU Byte Count Register */
> +#define SDXC_REG_BBCR	(0x4C) /* SMC BIU Byte Count Register */
> +#define SDXC_REG_DBGC	(0x50) /* SMC Debug Enable Register */
> +#define SDXC_REG_HWRST	(0x78) /* SMC Card Hardware Reset for Register */
> +#define SDXC_REG_DMAC	(0x80) /* SMC IDMAC Control Register */
> +#define SDXC_REG_DLBA	(0x84) /* SMC IDMAC Descriptor List Base Addre */
> +#define SDXC_REG_IDST	(0x88) /* SMC IDMAC Status Register */
> +#define SDXC_REG_IDIE	(0x8C) /* SMC IDMAC Interrupt Enable Register */
> +#define SDXC_REG_CHDA	(0x90)
> +#define SDXC_REG_CBDA	(0x94)
> +
> +#define mci_readl(host, reg) \
> +	readl((host)->reg_base + SDXC_##reg)
> +#define mci_writel(host, reg, value) \
> +	writel((value), (host)->reg_base + SDXC_##reg)

Please use some inline functions here.

> +/* global control register bits */
> +#define SDXC_SOFT_RESET		BIT(0)
> +#define SDXC_FIFO_RESET		BIT(1)
> +#define SDXC_DMA_RESET		BIT(2)
> +#define SDXC_HARDWARE_RESET		(SDXC_SOFT_RESET|SDXC_FIFO_RESET|SDXC_DMA_R=
ESET)
> +#define SDXC_INTERRUPT_ENABLE_BIT		BIT(4)
> +#define SDXC_DMA_ENABLE_BIT		BIT(5)
> +#define SDXC_DEBOUNCE_ENABLE_BIT	BIT(8)
> +#define SDXC_POSEDGE_LATCH_DATA	BIT(9)
> +#define SDXC_DDR_MODE		BIT(10)
> +#define SDXC_MEMORY_ACCESS_DONE	BIT(29)
> +#define SDXC_ACCESS_DONE_DIRECT	BIT(30)
> +#define SDXC_ACCESS_BY_AHB	BIT(31)
> +#define SDXC_ACCESS_BY_DMA	(0U << 31)

Isn't it 0?

> +/* clock control bits */
> +#define SDXC_CARD_CLOCK_ON		BIT(16)
> +#define SDXC_LOW_POWER_ON		BIT(17)
> +/* bus width */
> +#define SDXC_WIDTH1		(0)
> +#define SDXC_WIDTH4		(1)
> +#define SDXC_WIDTH8		(2)
> +/* smc command bits */
> +#define SDXC_RESP_EXPIRE		BIT(6)
> +#define SDXC_LONG_RESPONSE		BIT(7)
> +#define SDXC_CHECK_RESPONSE_CRC	BIT(8)
> +#define SDXC_DATA_EXPIRE		BIT(9)
> +#define SDXC_WRITE		BIT(10)
> +#define SDXC_SEQUENCE_MODE		BIT(11)
> +#define SDXC_SEND_AUTO_STOP	BIT(12)
> +#define SDXC_WAIT_PRE_OVER	BIT(13)
> +#define SDXC_STOP_ABORT_CMD	BIT(14)
> +#define SDXC_SEND_INIT_SEQUENCE	BIT(15)
> +#define SDXC_UPCLK_ONLY		BIT(21)
> +#define SDXC_READ_CEATA_DEV		BIT(22)
> +#define SDXC_CCS_EXPIRE		BIT(23)
> +#define SDXC_ENABLE_BIT_BOOT		BIT(24)
> +#define SDXC_ALT_BOOT_OPTIONS		BIT(25)
> +#define SDXC_BOOT_ACK_EXPIRE		BIT(26)
> +#define SDXC_BOOT_ABORT		BIT(27)
> +#define SDXC_VOLTAGE_SWITCH	        BIT(28)
> +#define SDXC_USE_HOLD_REGISTER	        BIT(29)
> +#define SDXC_START	        BIT(31)
> +/* interrupt bits */
> +#define SDXC_RESP_ERROR		BIT(1)
> +#define SDXC_COMMAND_DONE		BIT(2)
> +#define SDXC_DATA_OVER		BIT(3)
> +#define SDXC_TX_DATA_REQUEST		BIT(4)
> +#define SDXC_RX_DATA_REQUEST		BIT(5)
> +#define SDXC_RESP_CRC_ERROR		BIT(6)
> +#define SDXC_DATA_CRC_ERROR		BIT(7)
> +#define SDXC_RESP_TIMEOUT	BIT(8)
> +#define SDXC_DATA_TIMEOUT	BIT(9)
> +#define SDXC_VOLTAGE_CHANGE_DONE		BIT(10)
> +#define SDXC_FIFO_RUN_ERROR		BIT(11)
> +#define SDXC_HARD_WARE_LOCKED	BIT(12)
> +#define SDXC_START_BIT_ERROR	BIT(13)
> +#define SDXC_AUTO_COMMAND_DONE	BIT(14)
> +#define SDXC_END_BIT_ERROR		BIT(15)
> +#define SDXC_SDIO_INTERRUPT		BIT(16)
> +#define SDXC_CARD_INSERT		BIT(30)
> +#define SDXC_CARD_REMOVE		BIT(31)
> +#define SDXC_INTERRUPT_ERROR_BIT		(SDXC_RESP_ERROR | SDXC_RESP_CRC_ERROR=
 | \
> +				 SDXC_DATA_CRC_ERROR | SDXC_RESP_TIMEOUT | \
> +				 SDXC_DATA_TIMEOUT | SDXC_FIFO_RUN_ERROR | \
> +				 SDXC_HARD_WARE_LOCKED | SDXC_START_BIT_ERROR | \
> +				 SDXC_END_BIT_ERROR) /* 0xbbc2 */
> +#define SDXC_INTERRUPT_DONE_BIT		(SDXC_AUTO_COMMAND_DONE | SDXC_DATA_OVE=
R | \
> +				 SDXC_COMMAND_DONE | SDXC_VOLTAGE_CHANGE_DONE)
> +/* status */
> +#define SDXC_RXWL_FLAG		BIT(0)
> +#define SDXC_TXWL_FLAG		BIT(1)
> +#define SDXC_FIFO_EMPTY		BIT(2)
> +#define SDXC_FIFO_FULL		BIT(3)
> +#define SDXC_CARD_PRESENT	BIT(8)
> +#define SDXC_CARD_DATA_BUSY	BIT(9)
> +#define SDXC_DATA_FSM_BUSY	BIT(10)
> +#define SDXC_DMA_REQUEST		BIT(31)
> +#define SDXC_FIFO_SIZE		(16)
> +/* Function select */
> +#define SDXC_CEATA_ON		(0xceaaU << 16)
> +#define SDXC_SEND_IRQ_RESPONSE		BIT(0)
> +#define SDXC_SDIO_READ_WAIT		BIT(1)
> +#define SDXC_ABORT_READ_DATA		BIT(2)
> +#define SDXC_SEND_CCSD		BIT(8)
> +#define SDXC_SEND_AUTO_STOPCCSD	BIT(9)
> +#define SDXC_CEATA_DEV_INTERRUPT_ENABLE_BIT	BIT(10)
> +/* IDMA controller bus mod bit field */
> +#define SDXC_IDMAC_SOFT_RESET	BIT(0)
> +#define SDXC_IDMAC_FIX_BURST	BIT(1)
> +#define SDXC_IDMAC_IDMA_ON	BIT(7)
> +#define SDXC_IDMAC_REFETCH_DES	BIT(31)
> +/* IDMA status bit field */
> +#define SDXC_IDMAC_TRANSMIT_INTERRUPT	BIT(0)
> +#define SDXC_IDMAC_RECEIVE_INTERRUPT	BIT(1)
> +#define SDXC_IDMAC_FATAL_BUS_ERROR	BIT(2)
> +#define SDXC_IDMAC_DESTINATION_INVALID	BIT(4)
> +#define SDXC_IDMAC_CARD_ERROR_SUM	BIT(5)
> +#define SDXC_IDMAC_NORMAL_INTERRUPT_SUM	BIT(8)
> +#define SDXC_IDMAC_ABNORMAL_INTERRUPT_SUM BIT(9)
> +#define SDXC_IDMAC_HOST_ABORT_INTERRUPT_TX	BIT(10)
> +#define SDXC_IDMAC_HOST_ABORT_INTERRUPT_RX	BIT(10)
> +#define SDXC_IDMAC_IDLE		(0U << 13)

Ditto

> +#define SDXC_IDMAC_SUSPEND	(1U << 13)
> +#define SDXC_IDMAC_DESC_READ	(2U << 13)
> +#define SDXC_IDMAC_DESC_CHECK	(3U << 13)
> +#define SDXC_IDMAC_READ_REQUEST_WAIT	(4U << 13)
> +#define SDXC_IDMAC_WRITE_REQUEST_WAIT	(5U << 13)
> +#define SDXC_IDMAC_READ		(6U << 13)
> +#define SDXC_IDMAC_WRITE		(7U << 13)
> +#define SDXC_IDMAC_DESC_CLOSE	(8U << 13)

Please use BIT as much as possible here.


> +
> +/*
> +* If the idma-des-size-bits of property is ie 13, bufsize bits are:
> +*  Bits  0-12: buf1 size
> +*  Bits 13-25: buf2 size
> +*  Bits 26-31: not used
> +* Since we only ever set buf1 size, we can simply store it directly.
> +*/
> +#define SDXC_IDMAC_DES0_DIC	BIT(1)  /* disable interrupt on completion */
> +#define SDXC_IDMAC_DES0_LD	BIT(2)  /* last descriptor */
> +#define SDXC_IDMAC_DES0_FD	BIT(3)  /* first descriptor */
> +#define SDXC_IDMAC_DES0_CH	BIT(4)  /* chain mode */
> +#define SDXC_IDMAC_DES0_ER	BIT(5)  /* end of ring */
> +#define SDXC_IDMAC_DES0_CES	BIT(30) /* card error summary */
> +#define SDXC_IDMAC_DES0_OWN	BIT(31) /* 1-idma owns it, 0-host owns it */

Overall, I prefer to have the registers right beneath the register
declaration. It's easier to spot what bits belong to what registers
that way.

> +struct sunxi_idma_des {
> +	u32	config;
> +	u32	buf_size;
> +	u32	buf_addr_ptr1;
> +	u32	buf_addr_ptr2;
> +};

Some comments on top of this structure would be great.

> +struct sunxi_mmc_host {
> +	struct mmc_host *mmc;
> +	struct regulator *vmmc;
> +
> +	/* IO mapping base */
> +	void __iomem *reg_base;
> +
> +	spinlock_t lock;
> +	struct tasklet_struct tasklet;
> +
> +	/* clock management */
> +	struct clk *clk_ahb;
> +	struct clk *clk_mod;
> +
> +	/* ios information */
> +	u32		clk_mod_rate;
> +	u32		bus_width;
> +	u32		idma_des_size_bits;
> +	u32		ddr;
> +	u32		voltage_switching;
> +
> +	/* irq */
> +	int		irq;
> +	u32		int_sum;
> +	u32		sdio_imask;
> +
> +	/* flags */
> +	u32		power_on:1;
> +	u32		io_flag:1;
> +	u32		wait_dma:1;

bool?

> +	dma_addr_t	sg_dma;
> +	void		*sg_cpu;
> +
> +	struct mmc_request *mrq;
> +	u32		ferror;
> +};

Please be consistent in your spacing, either align the variable names,
or don't, but make a decision :)

> +#define MMC_CLK_400K            0
> +#define MMC_CLK_25M             1
> +#define MMC_CLK_50M             2
> +#define MMC_CLK_50MDDR          3
> +#define MMC_CLK_50MDDR_8BIT     4
> +#define MMC_CLK_100M            5
> +#define MMC_CLK_200M            6
> +#define MMC_CLK_MOD_NUM         7

Wouldn't an enum be better here?

> +
> +struct sunxi_mmc_clk_dly {
> +	u32 mode;
> +	u32 oclk_dly;
> +	u32 sclk_dly;
> +};

Comments here would be great too.

Thanks for working on this!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3MHXEHrrXKLGx71o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTA346AAoJEBx+YmzsjxAgO30P/0ElkP7N7XswzvQ37jbwSC3M
ewyDSZbCkjei+rc/lA5dCVN7SXyzR/y67RiWXG6pE8SQcsxn9wQ6gTO77NGN+8X+
+ttHTUguVB9lfAOT+4nRnJR1eur8l98RdyPAbhfLsKMrX10vpd7tFKtBw70VBzoh
y6RZ4wI1LIUiwh2iK672yi3iX3l06ijHzEMVqAHoNYDzCMpRzjE885B8p/c8Vsl9
fWOYjERH/zTUyDP6oj6964RCY5t9bDnU814nYwTdJBA06wdX7gPIsSpF/NeCSwUt
m3st/5gngeb3xePd9tm3UKD6hC93whgRp4xZ00VZJoDKWhttZgK0rvmEKWU7jBfj
tNqxiiykokmgdD6g2DFrrBRMiVC9s3Q1z11ar58Dzrp16KHHzR1Q18E3XlBBxkFH
Px5qSkWnV6IXzHts6VCVUK5R2LxXQ8EtYNFMS97i2EkigzErYX2mcD5dOemu66re
gv70OIsQ8YczG0MgPeKTp1k78tFhV+zZak8SCwu74tNRKvFry7KQxTiJO0SkhemY
bwmwdr+TWzjwQDw8Z0GDUIfcBJSILbX2k0+gzk5ttdGybTPUEKiot8BdGPujjson
xGl/9JL9QjDm3eNG848H9khKvoqjpFp7XFZNWnwzkMpeTJu6+AxjPS7V9lkFBM4b
hB7tkRTFAbydUWjMiIqF
=jgsw
-----END PGP SIGNATURE-----

--3MHXEHrrXKLGx71o--
