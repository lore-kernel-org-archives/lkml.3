Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaBSJuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:50:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52008 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbaBSJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:50:06 -0500
Date: Wed, 19 Feb 2014 10:46:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: David =?iso-8859-1?Q?Lanzend=F6rfer?= 
	<david.lanzendoerfer@o2s.ch>,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/8] ARM: sunxi: Add driver for SD/MMC hosts found on
 Allwinner sunxi SoCs
Message-ID: <20140219094615.GT3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100234.15040.84232.stgit@pagira.o2s.ch>
 <20140218153731.GK3142@lukather>
 <5303C751.5090809@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rBVNTu5JXDAWzN2S"
Content-Disposition: inline
In-Reply-To: <5303C751.5090809@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rBVNTu5JXDAWzN2S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Tue, Feb 18, 2014 at 09:49:21PM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 02/18/2014 04:37 PM, Maxime Ripard wrote:
>=20
> <snip>
>=20
> >>+
> >>+	for (i =3D 0; i < data->sg_len; i++) {
> >>+		pdes[i].config =3D SDXC_IDMAC_DES0_CH | SDXC_IDMAC_DES0_OWN |
> >>+				 SDXC_IDMAC_DES0_DIC;
> >>+
> >>+		if (data->sg[i].length =3D=3D max_len)
> >>+			pdes[i].buf_size =3D 0; /* 0 =3D=3D max_len */
> >>+		else
> >>+			pdes[i].buf_size =3D data->sg[i].length;
> >>+
> >>+		pdes[i].buf_addr_ptr1 =3D sg_dma_address(&data->sg[i]);
> >>+		pdes[i].buf_addr_ptr2 =3D (u32)&pdes_pa[i + 1];
> >>+	}
> >>+
> >>+	pdes[0].config |=3D SDXC_IDMAC_DES0_FD;
> >>+	pdes[i - 1].config =3D SDXC_IDMAC_DES0_OWN | SDXC_IDMAC_DES0_LD;
> >>+
> >>+	wmb(); /* Ensure idma_des hit main mem before we start the idmac */
> >
> >wmb ensure the proper ordering of the instructions, not flushing the
> >caches like what your comment implies.
>=20
> Since I put that comment there, allow me to explain. A modern ARM
> cpu core has 2 or more units handling stores. One for regular
> memory stores, and one for io-mem stores. Regular mem stores can
> be re-ordered, io stores cannot. Normally there is no "syncing"
> between the 2 store units. Cache flushing is not an issue here
> since the memory holding the descriptors for the idma controller
> is allocated cache coherent, which on arm means it is not cached.
>=20
> What is an issue here is the io-store starting the idmac hitting
> the io-mem before the descriptors hit the main-mem, the wmb()
> ensures this does not happen.

To expand a bit, my point was not that it was functionnally
wrong. Since you put a barrier in there, and that it resides in a
cache coherent section, we're fine.

My point was that the comment itself was misleading.

> >>+static int sunxi_mmc_prepare_dma(struct sunxi_mmc_host *smc_host,
> >>+				 struct mmc_data *data)
> >>+{
> >>+	u32 dma_len;
> >>+	u32 i;
> >>+	u32 temp;
> >>+	struct scatterlist *sg;
> >>+
> >>+	dma_len =3D dma_map_sg(mmc_dev(smc_host->mmc), data->sg, data->sg_len,
> >>+			     sunxi_mmc_get_dma_dir(data));
> >>+	if (dma_len =3D=3D 0) {
> >>+		dev_err(mmc_dev(smc_host->mmc), "dma_map_sg failed\n");
> >>+		return -ENOMEM;
> >>+	}
> >>+
> >>+	for_each_sg(data->sg, sg, data->sg_len, i) {
> >>+		if (sg->offset & 3 || sg->length & 3) {
> >>+			dev_err(mmc_dev(smc_host->mmc),
> >>+				"unaligned scatterlist: os %x length %d\n",
> >>+				sg->offset, sg->length);
> >>+			return -EINVAL;
> >>+		}
> >>+	}
> >>+
> >>+	sunxi_mmc_init_idma_des(smc_host, data);
> >>+
> >>+	temp =3D mci_readl(smc_host, REG_GCTRL);
> >>+	temp |=3D SDXC_DMA_ENABLE_BIT;
> >>+	mci_writel(smc_host, REG_GCTRL, temp);
> >>+	temp |=3D SDXC_DMA_RESET;
> >>+	mci_writel(smc_host, REG_GCTRL, temp);
> >
> >Does it really need to be done in two steps?
>=20
> We don't know, so this is probably best left as is.

Ok.

> >
> >(Newline)
> >
> >>+	mci_writel(smc_host, REG_DMAC, SDXC_IDMAC_SOFT_RESET);
> >>+
> >>+	if (!(data->flags & MMC_DATA_WRITE))
> >>+		mci_writel(smc_host, REG_IDIE, SDXC_IDMAC_RECEIVE_INTERRUPT);
> >>+
> >>+	mci_writel(smc_host, REG_DMAC, SDXC_IDMAC_FIX_BURST | SDXC_IDMAC_IDMA=
_ON);
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static void sunxi_mmc_send_manual_stop(struct sunxi_mmc_host *host,
> >>+				       struct mmc_request *req)
> >>+{
> >>+	u32 cmd_val =3D SDXC_START | SDXC_RESP_EXPIRE | SDXC_STOP_ABORT_CMD
> >>+			| SDXC_CHECK_RESPONSE_CRC | MMC_STOP_TRANSMISSION;
> >>+	u32 ri =3D 0;
> >>+	unsigned long expire =3D jiffies + msecs_to_jiffies(1000);
> >>+
> >>+	mci_writel(host, REG_CARG, 0);
> >>+	mci_writel(host, REG_CMDR, cmd_val);
> >>+
> >>+	do {
> >>+		ri =3D mci_readl(host, REG_RINTR);
> >>+	} while (!(ri & (SDXC_COMMAND_DONE | SDXC_INTERRUPT_ERROR_BIT)) &&
> >>+		 time_before(jiffies, expire));
> >>+
> >>+	if (ri & SDXC_INTERRUPT_ERROR_BIT) {
> >>+		dev_err(mmc_dev(host->mmc), "send stop command failed\n");
> >>+		if (req->stop)
> >>+			req->stop->resp[0] =3D -ETIMEDOUT;
> >>+	} else {
> >>+		if (req->stop)
> >>+			req->stop->resp[0] =3D mci_readl(host, REG_RESP0);
> >>+	}
> >>+
> >>+	mci_writel(host, REG_RINTR, 0xffff);
> >>+}
> >>+
> >>+static void sunxi_mmc_dump_errinfo(struct sunxi_mmc_host *smc_host)
> >>+{
> >>+	struct mmc_command *cmd =3D smc_host->mrq->cmd;
> >>+	struct mmc_data *data =3D smc_host->mrq->data;
> >>+
> >>+	/* For some cmds timeout is normal with sd/mmc cards */
> >>+	if ((smc_host->int_sum & SDXC_INTERRUPT_ERROR_BIT) =3D=3D SDXC_RESP_T=
IMEOUT &&
> >>+			(cmd->opcode =3D=3D SD_IO_SEND_OP_COND || cmd->opcode =3D=3D SD_IO_=
RW_DIRECT))
> >>+		return;
> >>+
> >>+	dev_err(mmc_dev(smc_host->mmc),
> >
> >I'd rather put it at a debug loglevel.
>=20
> Erm, this only happens if something is seriously wrong.

Still. Something would be seriously wrong in the MMC
driver/controller. You don't want to bloat the whole kernel logs with
the dump of your registers just because the MMC is failing. This is of
no interest to anyone but someone that would actually try to debug
what's wrong.

> >>+	/* Make sure the controller is in a sane state before enabling irqs */
> >>+	ret =3D sunxi_mmc_init_host(host->mmc);
> >>+	if (ret)
> >>+		return ret;
> >>+
> >>+	host->irq =3D platform_get_irq(pdev, 0);
> >>+	ret =3D devm_request_irq(&pdev->dev, host->irq, sunxi_mmc_irq, 0,
> >>+			       "sunxi-mmc", host);
> >>+	if (ret =3D=3D 0)
> >>+		disable_irq(host->irq);
> >
> >The disable_irq is useless here. Just exit.
>=20
> No it is not note the ret =3D=3D 0, this is not an error handling path!

Doh... Right.
My bad.

> This is done under an if because we want to do the sunxi_mmc_exit_host
> regardless of the request_irq succeeding or not.
>=20
> >
> >>+
> >>+	/* And put it back in reset */
> >>+	sunxi_mmc_exit_host(host);
> >
> >Hu? If it's in reset, how can it generate some IRQs?
>=20
> Yes, that is why we do the whole dance of init controller, get irq,
> disable irq, drop it back in reset (until the mmc subsys does a power on
> of the mmc card / sdio dev).
>=20
> Sometime the controller asserts the irq in reset for some reason, so
> without the dance as soon as we do the devm_request_irq we get an irq,
> and worse, not only do we get an irq, we cannot clear it since writing to
> the interrupt status register does not work when the controller is in res=
et,
> so we get stuck re-entering the irq handler.

Hmmm, I see. It probably deserves some commenting here too then.

> >>+	return ret;
> >>+}
> >>+
> >>+static int sunxi_mmc_probe(struct platform_device *pdev)
> >>+{
> >>+	struct sunxi_mmc_host *host;
> >>+	struct mmc_host *mmc;
> >>+	int ret;
> >>+
> >>+	mmc =3D mmc_alloc_host(sizeof(struct sunxi_mmc_host), &pdev->dev);
> >>+	if (!mmc) {
> >>+		dev_err(&pdev->dev, "mmc alloc host failed\n");
> >>+		return -ENOMEM;
> >>+	}
> >>+
> >>+	ret =3D mmc_of_parse(mmc);
> >>+	if (ret)
> >>+		goto error_free_host;
> >>+
> >>+	host =3D mmc_priv(mmc);
> >>+	host->mmc =3D mmc;
> >>+	spin_lock_init(&host->lock);
> >>+	tasklet_init(&host->tasklet, sunxi_mmc_tasklet, (unsigned long)host);
> >>+
> >>+	ret =3D sunxi_mmc_resource_request(host, pdev);
> >>+	if (ret)
> >>+		goto error_free_host;
> >>+
> >>+	host->sg_cpu =3D dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> >>+					  &host->sg_dma, GFP_KERNEL);
> >>+	if (!host->sg_cpu) {
> >>+		dev_err(&pdev->dev, "Failed to allocate DMA descriptor mem\n");
> >>+		ret =3D -ENOMEM;
> >>+		goto error_free_host;
> >>+	}
> >>+
> >>+	mmc->ops		=3D &sunxi_mmc_ops;
> >>+	mmc->max_blk_count	=3D 8192;
> >>+	mmc->max_blk_size	=3D 4096;
> >>+	mmc->max_segs		=3D PAGE_SIZE / sizeof(struct sunxi_idma_des);
> >>+	mmc->max_seg_size	=3D (1 << host->idma_des_size_bits);
> >>+	mmc->max_req_size	=3D mmc->max_seg_size * mmc->max_segs;
> >>+	/* 400kHz ~ 50MHz */
> >>+	mmc->f_min		=3D   400000;
> >>+	mmc->f_max		=3D 50000000;
> >>+	/* available voltages */
> >>+	if (!IS_ERR(host->vmmc))
> >>+		mmc->ocr_avail =3D mmc_regulator_get_ocrmask(host->vmmc);
> >>+	else
> >>+		mmc->ocr_avail =3D MMC_VDD_32_33 | MMC_VDD_33_34;
> >>+
> >>+	mmc->caps =3D MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
> >>+		MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25 | MMC_CAP_UHS_SDR50 |
> >>+		MMC_CAP_UHS_DDR50 | MMC_CAP_SDIO_IRQ | MMC_CAP_DRIVER_TYPE_A;
> >>+	mmc->caps2 =3D MMC_CAP2_NO_PRESCAN_POWERUP;
> >>+
> >>+	ret =3D mmc_add_host(mmc);
> >>+
> >>+	if (ret)
> >>+		goto error_free_dma;
> >>+
> >>+	dev_info(&pdev->dev, "base:0x%p irq:%u\n", host->reg_base, host->irq);
> >>+	platform_set_drvdata(pdev, mmc);
> >
> >This should be before the registration. Otherwise, you're racy.
>=20
> Nope, we only need this to get the data on sunxi_mmc_remove, everywhere
> else the data is found through the mmc-host struct.

Still, if anyone makes a following patch using the platform_device for
some reason, we will have a race condition, without any way to notice
it.

Plus, you're doing all the other bits of initialization of your
structures much earlier, why not be consistent and having all of them
at the same place?

> >
> >>+	return 0;
> >>+
> >>+error_free_dma:
> >>+	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
> >>+error_free_host:
> >>+	mmc_free_host(mmc);
> >>+	return ret;
> >>+}
> >>+
> >>+static int sunxi_mmc_remove(struct platform_device *pdev)
> >>+{
> >>+	struct mmc_host	*mmc =3D platform_get_drvdata(pdev);
> >>+	struct sunxi_mmc_host *host =3D mmc_priv(mmc);
> >>+
> >>+	mmc_remove_host(mmc);
> >>+	sunxi_mmc_exit_host(host);
> >>+	tasklet_disable(&host->tasklet);
> >>+	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
> >>+	mmc_free_host(mmc);
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static struct platform_driver sunxi_mmc_driver =3D {
> >>+	.driver =3D {
> >>+		.name	=3D "sunxi-mmc",
> >>+		.owner	=3D THIS_MODULE,
> >>+		.of_match_table =3D of_match_ptr(sunxi_mmc_of_match),
> >>+	},
> >>+	.probe		=3D sunxi_mmc_probe,
> >>+	.remove		=3D sunxi_mmc_remove,
> >>+};
> >>+module_platform_driver(sunxi_mmc_driver);
> >>+
> >>+MODULE_DESCRIPTION("Allwinner's SD/MMC Card Controller Driver");
> >>+MODULE_LICENSE("GPL v2");
> >>+MODULE_AUTHOR("David Lanzend?rfer <david.lanzendoerfer@o2s.ch>");
> >>+MODULE_ALIAS("platform:sunxi-mmc");
> >>diff --git a/drivers/mmc/host/sunxi-mmc.h b/drivers/mmc/host/sunxi-mmc.h
> >>new file mode 100644
> >>index 0000000..75eaa02
> >>--- /dev/null
> >>+++ b/drivers/mmc/host/sunxi-mmc.h
> >>@@ -0,0 +1,239 @@
> >>+/*
> >>+ * Driver for sunxi SD/MMC host controllers
> >>+ * (C) Copyright 2007-2011 Reuuimlla Technology Co., Ltd.
> >>+ * (C) Copyright 2007-2011 Aaron Maoye <leafy.myeh@reuuimllatech.com>
> >>+ * (C) Copyright 2013-2014 O2S GmbH <www.o2s.ch>
> >>+ * (C) Copyright 2013-2014 David Lanzend?rfer <david.lanzendoerfer@o2s=
=2Ech>
> >>+ * (C) Copyright 2013-2014 Hans de Goede <hdegoede@redhat.com>
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or
> >>+ * modify it under the terms of the GNU General Public License as
> >>+ * published by the Free Software Foundation; either version 2 of
> >>+ * the License, or (at your option) any later version.
> >>+ */
> >>+
> >>+#ifndef __SUNXI_MMC_H__
> >>+#define __SUNXI_MMC_H__
> >>+
> >>+/* register offset definitions */
> >>+#define SDXC_REG_GCTRL	(0x00) /* SMC Global Control Register */
> >>+#define SDXC_REG_CLKCR	(0x04) /* SMC Clock Control Register */
> >>+#define SDXC_REG_TMOUT	(0x08) /* SMC Time Out Register */
> >>+#define SDXC_REG_WIDTH	(0x0C) /* SMC Bus Width Register */
> >>+#define SDXC_REG_BLKSZ	(0x10) /* SMC Block Size Register */
> >>+#define SDXC_REG_BCNTR	(0x14) /* SMC Byte Count Register */
> >>+#define SDXC_REG_CMDR	(0x18) /* SMC Command Register */
> >>+#define SDXC_REG_CARG	(0x1C) /* SMC Argument Register */
> >>+#define SDXC_REG_RESP0	(0x20) /* SMC Response Register 0 */
> >>+#define SDXC_REG_RESP1	(0x24) /* SMC Response Register 1 */
> >>+#define SDXC_REG_RESP2	(0x28) /* SMC Response Register 2 */
> >>+#define SDXC_REG_RESP3	(0x2C) /* SMC Response Register 3 */
> >>+#define SDXC_REG_IMASK	(0x30) /* SMC Interrupt Mask Register */
> >>+#define SDXC_REG_MISTA	(0x34) /* SMC Masked Interrupt Status Register =
*/
> >>+#define SDXC_REG_RINTR	(0x38) /* SMC Raw Interrupt Status Register */
> >>+#define SDXC_REG_STAS	(0x3C) /* SMC Status Register */
> >>+#define SDXC_REG_FTRGL	(0x40) /* SMC FIFO Threshold Watermark Registe =
*/
> >>+#define SDXC_REG_FUNS	(0x44) /* SMC Function Select Register */
> >>+#define SDXC_REG_CBCR	(0x48) /* SMC CIU Byte Count Register */
> >>+#define SDXC_REG_BBCR	(0x4C) /* SMC BIU Byte Count Register */
> >>+#define SDXC_REG_DBGC	(0x50) /* SMC Debug Enable Register */
> >>+#define SDXC_REG_HWRST	(0x78) /* SMC Card Hardware Reset for Register =
*/
> >>+#define SDXC_REG_DMAC	(0x80) /* SMC IDMAC Control Register */
> >>+#define SDXC_REG_DLBA	(0x84) /* SMC IDMAC Descriptor List Base Addre */
> >>+#define SDXC_REG_IDST	(0x88) /* SMC IDMAC Status Register */
> >>+#define SDXC_REG_IDIE	(0x8C) /* SMC IDMAC Interrupt Enable Register */
> >>+#define SDXC_REG_CHDA	(0x90)
> >>+#define SDXC_REG_CBDA	(0x94)
> >>+
> >>+#define mci_readl(host, reg) \
> >>+	readl((host)->reg_base + SDXC_##reg)
> >>+#define mci_writel(host, reg, value) \
> >>+	writel((value), (host)->reg_base + SDXC_##reg)
> >
> >Please use some inline functions here.
> >
> >>+/* global control register bits */
> >>+#define SDXC_SOFT_RESET		BIT(0)
> >>+#define SDXC_FIFO_RESET		BIT(1)
> >>+#define SDXC_DMA_RESET		BIT(2)
> >>+#define SDXC_HARDWARE_RESET		(SDXC_SOFT_RESET|SDXC_FIFO_RESET|SDXC_DMA=
_RESET)
> >>+#define SDXC_INTERRUPT_ENABLE_BIT		BIT(4)
> >>+#define SDXC_DMA_ENABLE_BIT		BIT(5)
> >>+#define SDXC_DEBOUNCE_ENABLE_BIT	BIT(8)
> >>+#define SDXC_POSEDGE_LATCH_DATA	BIT(9)
> >>+#define SDXC_DDR_MODE		BIT(10)
> >>+#define SDXC_MEMORY_ACCESS_DONE	BIT(29)
> >>+#define SDXC_ACCESS_DONE_DIRECT	BIT(30)
> >>+#define SDXC_ACCESS_BY_AHB	BIT(31)
> >>+#define SDXC_ACCESS_BY_DMA	(0U << 31)
> >
> >Isn't it 0?
>=20
> Yes, but is is the inverse of ACCESS_BY_DMA, which
> this makes much clearer then just 0 does.
>=20
> >
> >>+/* clock control bits */
> >>+#define SDXC_CARD_CLOCK_ON		BIT(16)
> >>+#define SDXC_LOW_POWER_ON		BIT(17)
> >>+/* bus width */
> >>+#define SDXC_WIDTH1		(0)
> >>+#define SDXC_WIDTH4		(1)
> >>+#define SDXC_WIDTH8		(2)
> >>+/* smc command bits */
> >>+#define SDXC_RESP_EXPIRE		BIT(6)
> >>+#define SDXC_LONG_RESPONSE		BIT(7)
> >>+#define SDXC_CHECK_RESPONSE_CRC	BIT(8)
> >>+#define SDXC_DATA_EXPIRE		BIT(9)
> >>+#define SDXC_WRITE		BIT(10)
> >>+#define SDXC_SEQUENCE_MODE		BIT(11)
> >>+#define SDXC_SEND_AUTO_STOP	BIT(12)
> >>+#define SDXC_WAIT_PRE_OVER	BIT(13)
> >>+#define SDXC_STOP_ABORT_CMD	BIT(14)
> >>+#define SDXC_SEND_INIT_SEQUENCE	BIT(15)
> >>+#define SDXC_UPCLK_ONLY		BIT(21)
> >>+#define SDXC_READ_CEATA_DEV		BIT(22)
> >>+#define SDXC_CCS_EXPIRE		BIT(23)
> >>+#define SDXC_ENABLE_BIT_BOOT		BIT(24)
> >>+#define SDXC_ALT_BOOT_OPTIONS		BIT(25)
> >>+#define SDXC_BOOT_ACK_EXPIRE		BIT(26)
> >>+#define SDXC_BOOT_ABORT		BIT(27)
> >>+#define SDXC_VOLTAGE_SWITCH	        BIT(28)
> >>+#define SDXC_USE_HOLD_REGISTER	        BIT(29)
> >>+#define SDXC_START	        BIT(31)
> >>+/* interrupt bits */
> >>+#define SDXC_RESP_ERROR		BIT(1)
> >>+#define SDXC_COMMAND_DONE		BIT(2)
> >>+#define SDXC_DATA_OVER		BIT(3)
> >>+#define SDXC_TX_DATA_REQUEST		BIT(4)
> >>+#define SDXC_RX_DATA_REQUEST		BIT(5)
> >>+#define SDXC_RESP_CRC_ERROR		BIT(6)
> >>+#define SDXC_DATA_CRC_ERROR		BIT(7)
> >>+#define SDXC_RESP_TIMEOUT	BIT(8)
> >>+#define SDXC_DATA_TIMEOUT	BIT(9)
> >>+#define SDXC_VOLTAGE_CHANGE_DONE		BIT(10)
> >>+#define SDXC_FIFO_RUN_ERROR		BIT(11)
> >>+#define SDXC_HARD_WARE_LOCKED	BIT(12)
> >>+#define SDXC_START_BIT_ERROR	BIT(13)
> >>+#define SDXC_AUTO_COMMAND_DONE	BIT(14)
> >>+#define SDXC_END_BIT_ERROR		BIT(15)
> >>+#define SDXC_SDIO_INTERRUPT		BIT(16)
> >>+#define SDXC_CARD_INSERT		BIT(30)
> >>+#define SDXC_CARD_REMOVE		BIT(31)
> >>+#define SDXC_INTERRUPT_ERROR_BIT		(SDXC_RESP_ERROR | SDXC_RESP_CRC_ERR=
OR | \
> >>+				 SDXC_DATA_CRC_ERROR | SDXC_RESP_TIMEOUT | \
> >>+				 SDXC_DATA_TIMEOUT | SDXC_FIFO_RUN_ERROR | \
> >>+				 SDXC_HARD_WARE_LOCKED | SDXC_START_BIT_ERROR | \
> >>+				 SDXC_END_BIT_ERROR) /* 0xbbc2 */
> >>+#define SDXC_INTERRUPT_DONE_BIT		(SDXC_AUTO_COMMAND_DONE | SDXC_DATA_O=
VER | \
> >>+				 SDXC_COMMAND_DONE | SDXC_VOLTAGE_CHANGE_DONE)
> >>+/* status */
> >>+#define SDXC_RXWL_FLAG		BIT(0)
> >>+#define SDXC_TXWL_FLAG		BIT(1)
> >>+#define SDXC_FIFO_EMPTY		BIT(2)
> >>+#define SDXC_FIFO_FULL		BIT(3)
> >>+#define SDXC_CARD_PRESENT	BIT(8)
> >>+#define SDXC_CARD_DATA_BUSY	BIT(9)
> >>+#define SDXC_DATA_FSM_BUSY	BIT(10)
> >>+#define SDXC_DMA_REQUEST		BIT(31)
> >>+#define SDXC_FIFO_SIZE		(16)
> >>+/* Function select */
> >>+#define SDXC_CEATA_ON		(0xceaaU << 16)
> >>+#define SDXC_SEND_IRQ_RESPONSE		BIT(0)
> >>+#define SDXC_SDIO_READ_WAIT		BIT(1)
> >>+#define SDXC_ABORT_READ_DATA		BIT(2)
> >>+#define SDXC_SEND_CCSD		BIT(8)
> >>+#define SDXC_SEND_AUTO_STOPCCSD	BIT(9)
> >>+#define SDXC_CEATA_DEV_INTERRUPT_ENABLE_BIT	BIT(10)
> >>+/* IDMA controller bus mod bit field */
> >>+#define SDXC_IDMAC_SOFT_RESET	BIT(0)
> >>+#define SDXC_IDMAC_FIX_BURST	BIT(1)
> >>+#define SDXC_IDMAC_IDMA_ON	BIT(7)
> >>+#define SDXC_IDMAC_REFETCH_DES	BIT(31)
> >>+/* IDMA status bit field */
> >>+#define SDXC_IDMAC_TRANSMIT_INTERRUPT	BIT(0)
> >>+#define SDXC_IDMAC_RECEIVE_INTERRUPT	BIT(1)
> >>+#define SDXC_IDMAC_FATAL_BUS_ERROR	BIT(2)
> >>+#define SDXC_IDMAC_DESTINATION_INVALID	BIT(4)
> >>+#define SDXC_IDMAC_CARD_ERROR_SUM	BIT(5)
> >>+#define SDXC_IDMAC_NORMAL_INTERRUPT_SUM	BIT(8)
> >>+#define SDXC_IDMAC_ABNORMAL_INTERRUPT_SUM BIT(9)
> >>+#define SDXC_IDMAC_HOST_ABORT_INTERRUPT_TX	BIT(10)
> >>+#define SDXC_IDMAC_HOST_ABORT_INTERRUPT_RX	BIT(10)
> >>+#define SDXC_IDMAC_IDLE		(0U << 13)
> >
> >Ditto
> >
> >>+#define SDXC_IDMAC_SUSPEND	(1U << 13)
> >>+#define SDXC_IDMAC_DESC_READ	(2U << 13)
> >>+#define SDXC_IDMAC_DESC_CHECK	(3U << 13)
> >>+#define SDXC_IDMAC_READ_REQUEST_WAIT	(4U << 13)
> >>+#define SDXC_IDMAC_WRITE_REQUEST_WAIT	(5U << 13)
> >>+#define SDXC_IDMAC_READ		(6U << 13)
> >>+#define SDXC_IDMAC_WRITE		(7U << 13)
> >>+#define SDXC_IDMAC_DESC_CLOSE	(8U << 13)
> >
> >Please use BIT as much as possible here.
>=20
> Erm lets not do that, nor remove the 0 << 13, this are all
> values to store in a multi-bit field which lives in bits 13-xx,
> changing the values which happen to be power of 2 into BIT
> macros is not helpful.

Ok.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--rBVNTu5JXDAWzN2S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTBH1nAAoJEBx+YmzsjxAg7m4P+wVbbthSqGkntoIm7irXnfuu
PFPEWd5xARLqj8M/GASb3h/mw9RvF10xUJAQp9SNTNhuQWu/LrTHmyUt4wKgRw16
wbCvyTJ77g7eGIg/Eq0wUF3wIoa1m8w87HIRuXBT+2A9nMNVcd8yffN7pQ5F75BD
leZsBav6Kqa2/L0wiu0ZrxLioCSY/SDfDMG72vRzUX/EOJ8/14eezzslKZ3ZVOBv
lErhgzSAg+PtT3M4nO4KahT3lXG1irY96XUkXpW0+A+DSp8rgqXpYYSAGnGY1mVU
rpMIhOwxmeWlp09l7HgstA4FLM/CiZgJks81upMpp+3wF9aKj3EFy7OXOsLkZcxF
RwVSonrOWFxdOuKHhyindTipexNhZNQp6I6xfV55wVwiNlf66Q3txwZHI1SKcC1z
dAcTV4SGyNyVhbZfm5cXNbGmp1NpS/+KWqDKDuS2I0YBNg92fpSpSwkb8z2pmq0j
JoWqXHg2yfQ7u6IXNrpWzo4PiJcxtpsF3OKOR7DyKlILOrzcLm3JQxFTJV1sSrgs
4Yk6Pnk7M6zOLcmszjsw2jl3ug8MYcKliLy6SxqGOgbacl1oiCtVRvS/FJiBTozk
sSsR410yq037XhGl9UoHODWzwQxkeO6m0Ae4CXEnw7y1DPU3aJpsoekvGrqP3yXh
6/K+eWIQhNSNhZfRBFES
=eRlP
-----END PGP SIGNATURE-----

--rBVNTu5JXDAWzN2S--
