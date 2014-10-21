Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaJUC2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:28:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42977 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaJUC2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:28:09 -0400
Date: Mon, 20 Oct 2014 19:28:05 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v6 1/2] mtd: nand: add sunxi NAND flash controller support
Message-ID: <20141021022805.GB1193@ld-irv-0074>
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413805520-14947-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413805520-14947-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 01:45:19PM +0200, Boris Brezillon wrote:
> Add support for the sunxi NAND Flash Controller (NFC).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

This driver looks mostly good. Sorry for the delays, and thanks for the
patience.

> ---
>  drivers/mtd/nand/Kconfig      |    6 +
>  drivers/mtd/nand/Makefile     |    1 +
>  drivers/mtd/nand/sunxi_nand.c | 1400 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1407 insertions(+)
>  create mode 100644 drivers/mtd/nand/sunxi_nand.c
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index dd10646..4c51d2c 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -516,4 +516,10 @@ config MTD_NAND_XWAY
>  	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
>  	  to the External Bus Unit (EBU).
>  
> +config MTD_NAND_SUNXI
> +	tristate "Support for NAND on Allwinner SoCs"
> +	depends on ARCH_SUNXI
> +	help
> +	  Enables support for NAND Flash chips on Allwinner SoCs.
> +
>  endif # MTD_NAND
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index 9c847e4..bd38f21 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -50,5 +50,6 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
>  obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
>  obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
>  obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
> +obj-$(CONFIG_MTD_NAND_SUNXI)		+= sunxi_nand.o
>  
>  nand-objs := nand_base.o nand_bbt.o nand_timings.o
> diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
> new file mode 100644
> index 0000000..c4e0559
> --- /dev/null
> +++ b/drivers/mtd/nand/sunxi_nand.c
> @@ -0,0 +1,1400 @@
> +/*
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon.dev@gmail.com>
> + *
> + * Derived from:
> + *	https://github.com/yuq/sunxi-nfc-mtd
> + *	Copyright (C) 2013 Qiang Yu <yuq825@gmail.com>
> + *
> + *	https://github.com/hno/Allwinner-Info
> + *	Copyright (C) 2013 Henrik Nordström <Henrik Nordström>
> + *
> + *	Copyright (C) 2013 Dmitriy B. <rzk333@gmail.com>
> + *	Copyright (C) 2013 Sergey Lapin <slapin@ossfans.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_mtd.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dmaengine.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +
> +#define NFC_REG_CTL		0x0000
> +#define NFC_REG_ST		0x0004
> +#define NFC_REG_INT		0x0008
> +#define NFC_REG_TIMING_CTL	0x000C
> +#define NFC_REG_TIMING_CFG	0x0010
> +#define NFC_REG_ADDR_LOW	0x0014
> +#define NFC_REG_ADDR_HIGH	0x0018
> +#define NFC_REG_SECTOR_NUM	0x001C
> +#define NFC_REG_CNT		0x0020
> +#define NFC_REG_CMD		0x0024
> +#define NFC_REG_RCMD_SET	0x0028
> +#define NFC_REG_WCMD_SET	0x002C
> +#define NFC_REG_IO_DATA		0x0030
> +#define NFC_REG_ECC_CTL		0x0034
> +#define NFC_REG_ECC_ST		0x0038
> +#define NFC_REG_DEBUG		0x003C
> +#define NFC_REG_ECC_CNT0	0x0040
> +#define NFC_REG_ECC_CNT1	0x0044
> +#define NFC_REG_ECC_CNT2	0x0048
> +#define NFC_REG_ECC_CNT3	0x004c
> +#define NFC_REG_USER_DATA_BASE	0x0050
> +#define NFC_REG_SPARE_AREA	0x00A0
> +#define NFC_RAM0_BASE		0x0400
> +#define NFC_RAM1_BASE		0x0800
> +
> +/* define bit use in NFC_CTL */
> +#define NFC_EN			BIT(0)
> +#define NFC_RESET		BIT(1)
> +#define NFC_BUS_WIDYH		BIT(2)
> +#define NFC_RB_SEL		BIT(3)
> +#define NFC_CE_SEL		GENMASK(26, 24)
> +#define NFC_CE_CTL		BIT(6)
> +#define NFC_CE_CTL1		BIT(7)
> +#define NFC_PAGE_SIZE		GENMASK(11, 8)
> +#define NFC_SAM			BIT(12)
> +#define NFC_RAM_METHOD		BIT(14)
> +#define NFC_DEBUG_CTL		BIT(31)
> +
> +/* define bit use in NFC_ST */
> +#define NFC_RB_B2R		BIT(0)
> +#define NFC_CMD_INT_FLAG	BIT(1)
> +#define NFC_DMA_INT_FLAG	BIT(2)
> +#define NFC_CMD_FIFO_STATUS	BIT(3)
> +#define NFC_STA			BIT(4)
> +#define NFC_NATCH_INT_FLAG	BIT(5)
> +#define NFC_RB_STATE0		BIT(8)
> +#define NFC_RB_STATE1		BIT(9)
> +#define NFC_RB_STATE2		BIT(10)
> +#define NFC_RB_STATE3		BIT(11)
> +
> +/* define bit use in NFC_INT */
> +#define NFC_B2R_INT_ENABLE	BIT(0)
> +#define NFC_CMD_INT_ENABLE	BIT(1)
> +#define NFC_DMA_INT_ENABLE	BIT(2)
> +#define NFC_INT_MASK		(NFC_B2R_INT_ENABLE | \
> +				 NFC_CMD_INT_ENABLE | \
> +				 NFC_DMA_INT_ENABLE)
> +
> +/* define bit use in NFC_CMD */
> +#define NFC_CMD_LOW_BYTE	GENMASK(7, 0)
> +#define NFC_CMD_HIGH_BYTE	GENMASK(15, 8)
> +#define NFC_ADR_NUM		GENMASK(18, 16)
> +#define NFC_SEND_ADR		BIT(19)
> +#define NFC_ACCESS_DIR		BIT(20)
> +#define NFC_DATA_TRANS		BIT(21)
> +#define NFC_SEND_CMD1		BIT(22)
> +#define NFC_WAIT_FLAG		BIT(23)
> +#define NFC_SEND_CMD2		BIT(24)
> +#define NFC_SEQ			BIT(25)
> +#define NFC_DATA_SWAP_METHOD	BIT(26)
> +#define NFC_ROW_AUTO_INC	BIT(27)
> +#define NFC_SEND_CMD3		BIT(28)
> +#define NFC_SEND_CMD4		BIT(29)
> +#define NFC_CMD_TYPE		GENMASK(31, 30)
> +
> +/* define bit use in NFC_RCMD_SET */
> +#define NFC_READ_CMD		GENMASK(7, 0)
> +#define NFC_RANDOM_READ_CMD0	GENMASK(15, 8)
> +#define NFC_RANDOM_READ_CMD1	GENMASK(23, 16)
> +
> +/* define bit use in NFC_WCMD_SET */
> +#define NFC_PROGRAM_CMD		GENMASK(7, 0)
> +#define NFC_RANDOM_WRITE_CMD	GENMASK(15, 8)
> +#define NFC_READ_CMD0		GENMASK(23, 16)
> +#define NFC_READ_CMD1		GENMASK(31, 24)
> +
> +/* define bit use in NFC_ECC_CTL */
> +#define NFC_ECC_EN		BIT(0)
> +#define NFC_ECC_PIPELINE	BIT(3)
> +#define NFC_ECC_EXCEPTION	BIT(4)
> +#define NFC_ECC_BLOCK_SIZE	BIT(5)
> +#define NFC_RANDOM_EN		BIT(9)
> +#define NFC_RANDOM_DIRECTION	BIT(10)
> +#define NFC_ECC_MODE_SHIFT	12
> +#define NFC_ECC_MODE		GENMASK(15, 12)
> +#define NFC_RANDOM_SEED		GENMASK(30, 16)
> +
> +#define DEFAULT_NAME_FORMAT	"nand@%d"
> +#define MAX_NAME_SIZE		(sizeof("nand@") + 2)
> +
> +#define NFC_DEFAULT_TIMEOUT_MS	1000
> +
> +/*
> + * Ready/Busy detection type: describes the Ready/Busy detection modes
> + *
> + * @RB_NONE:	no external detection available, rely on STATUS command
> + *		and software timeouts
> + * @RB_NATIVE:	use sunxi NAND controller Ready/Busy support. The Ready/Busy
> + *		pin of the NAND flash chip must be connected to one of the
> + *		native NAND R/B pins (those which can be muxed to the NAND
> + *		Controller)
> + * @RB_GPIO:	use a simple GPIO to handle Ready/Busy status. The Ready/Busy
> + *		pin of the NAND flash chip must be connected to a GPIO capable
> + *		pin.
> + */
> +enum sunxi_nand_rb_type {
> +	RB_NONE,
> +	RB_NATIVE,
> +	RB_GPIO,
> +};
> +
> +/*
> + * Ready/Busy structure: stores information related to Ready/Busy detection
> + *
> + * @type:	the Ready/Busy detection mode
> + * @info:	information related to the R/B detection mode. Either a gpio
> + *		id or a native R/B id (those supported by the NAND controller).
> + */
> +struct sunxi_nand_rb {
> +	enum sunxi_nand_rb_type type;
> +	union {
> +		int gpio;
> +		int nativeid;
> +	} info;
> +};
> +
> +/*
> + * Chip Select structure: stores information related to NAND Chip Select
> + *
> + * @cs:		the NAND CS id used to communicate with a NAND Chip
> + * @rb:		the Ready/Busy description
> + */
> +struct sunxi_nand_chip_sel {
> +	u8 cs;
> +	struct sunxi_nand_rb rb;
> +};
> +
> +/*
> + * sunxi HW ECC infos: stores information related to HW ECC support
> + *
> + * @mode:	the sunxi ECC mode field deduced from ECC requirements
> + * @layout:	the OOB layout depending on the ECC requirements and the
> + *		selected ECC mode
> + */
> +struct sunxi_nand_hw_ecc {
> +	int mode;
> +	struct nand_ecclayout layout;
> +};
> +
> +/*
> + * NAND chip structure: stores NAND chip device related information
> + *
> + * @node:		used to store NAND chips into a list
> + * @nand:		base NAND chip structure
> + * @mtd:		base MTD structure
> + * @default_name:	name used if no name was provided by the DT
> + * @clk_rate:		clk_rate required for this NAND chip
> + * @selected:		current active CS
> + * @nsels:		number of CS lines required by the NAND chip
> + * @sels:		array of CS lines descriptions
> + */
> +struct sunxi_nand_chip {
> +	struct list_head node;
> +	struct nand_chip nand;
> +	struct mtd_info mtd;
> +	char default_name[MAX_NAME_SIZE];
> +	unsigned long clk_rate;
> +	int selected;
> +	int nsels;
> +	struct sunxi_nand_chip_sel sels[0];
> +};
> +
> +static inline struct sunxi_nand_chip *to_sunxi_nand(struct nand_chip *nand)
> +{
> +	return container_of(nand, struct sunxi_nand_chip, nand);
> +}
> +
> +/*
> + * NAND Controller structure: stores sunxi NAND controller information
> + *
> + * @controller:		base controller structure
> + * @regs:		NAND controller registers
> + * @ahb_clk:		NAND Controller AHB clock
> + * @mod_clk:		NAND Controller mod clock
> + * @assigned_cs:	bitmask describing already assigned CS lines
> + * @clk_rate:		NAND controller current clock rate
> + * @chips:		a list containing all the NAND chips attached to
> + *			this NAND controller
> + * @complete:		a completion object used to wait for NAND
> + *			controller events
> + */
> +struct sunxi_nfc {
> +	struct nand_hw_control controller;
> +	void __iomem *regs;
> +	struct clk *ahb_clk;
> +	struct clk *mod_clk;
> +	unsigned long assigned_cs;
> +	unsigned long clk_rate;
> +	struct list_head chips;
> +	struct completion complete;
> +};
> +
> +static inline struct sunxi_nfc *to_sunxi_nfc(struct nand_hw_control *ctrl)
> +{
> +	return container_of(ctrl, struct sunxi_nfc, controller);
> +}
> +
> +static irqreturn_t sunxi_nfc_interrupt(int irq, void *dev_id)
> +{
> +	struct sunxi_nfc *nfc = dev_id;
> +	u32 st = readl(nfc->regs + NFC_REG_ST);
> +	u32 ien = readl(nfc->regs + NFC_REG_INT);
> +
> +	if (!(ien & st))
> +		return IRQ_NONE;
> +
> +	if ((ien & st) == ien)
> +		complete(&nfc->complete);
> +
> +	writel(st & NFC_INT_MASK, nfc->regs + NFC_REG_ST);
> +	writel(~st & ien & NFC_INT_MASK, nfc->regs + NFC_REG_INT);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int sunxi_nfc_wait_int(struct sunxi_nfc *nfc, u32 flags,
> +			      unsigned int timeout_ms)
> +{
> +	init_completion(&nfc->complete);
> +
> +	writel(flags, nfc->regs + NFC_REG_INT);
> +
> +	if (!timeout_ms)
> +		timeout_ms = NFC_DEFAULT_TIMEOUT_MS;
> +
> +	if (!wait_for_completion_timeout(&nfc->complete,
> +					 msecs_to_jiffies(timeout_ms)))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +static void sunxi_nfc_wait_cmd_fifo_empty(struct sunxi_nfc *nfc)
> +{
> +	unsigned long timeout = jiffies +
> +				msecs_to_jiffies(NFC_DEFAULT_TIMEOUT_MS);
> +
> +	while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS) &&
> +	       time_before(jiffies, timeout))
> +		;

It's typically good form to return an error and/or print a message on
timeouts.

> +}
> +
> +static void sunxi_nfc_rst(struct sunxi_nfc *nfc)
> +{
> +	unsigned long timeout = jiffies +
> +				msecs_to_jiffies(NFC_DEFAULT_TIMEOUT_MS);
> +
> +	writel(0, nfc->regs + NFC_REG_ECC_CTL);
> +	writel(NFC_RESET, nfc->regs + NFC_REG_CTL);
> +	while ((readl(nfc->regs + NFC_REG_CTL) & NFC_RESET) &&
> +	       time_before(jiffies, timeout))
> +		;

Same here.

> +}
> +
> +static int sunxi_nfc_dev_ready(struct mtd_info *mtd)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> +	struct sunxi_nand_rb *rb;
> +	unsigned long timeo = (sunxi_nand->nand.state == FL_ERASING ? 400 : 20);
> +	int ret;
> +
> +	if (sunxi_nand->selected < 0)
> +		return 0;
> +
> +	rb = &sunxi_nand->sels[sunxi_nand->selected].rb;
> +
> +	switch (rb->type) {
> +	case RB_NATIVE:
> +		ret = !!(readl(nfc->regs + NFC_REG_ST) &
> +			 (NFC_RB_STATE0 << rb->info.nativeid));
> +		if (ret)
> +			break;
> +
> +		sunxi_nfc_wait_int(nfc, NFC_RB_B2R, timeo);
> +		ret = !!(readl(nfc->regs + NFC_REG_ST) &
> +			 (NFC_RB_STATE0 << rb->info.nativeid));
> +		break;
> +	case RB_GPIO:
> +		ret = gpio_get_value(rb->info.gpio);
> +		break;
> +	case RB_NONE:
> +	default:
> +		ret = 0;
> +		pr_err("cannot check R/B NAND status!");
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void sunxi_nfc_select_chip(struct mtd_info *mtd, int chip)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> +	struct sunxi_nand_chip_sel *sel;
> +	u32 ctl;
> +
> +	if (chip > 0 && chip >= sunxi_nand->nsels)
> +		return;
> +
> +	if (chip == sunxi_nand->selected)
> +		return;
> +
> +	ctl = readl(nfc->regs + NFC_REG_CTL) &
> +	      ~(NFC_CE_SEL | NFC_RB_SEL | NFC_EN);
> +
> +	if (chip >= 0) {
> +		sel = &sunxi_nand->sels[chip];
> +
> +		ctl |= (sel->cs << 24) | NFC_EN |
> +		       (((nand->page_shift - 10) & 0xf) << 8);
> +		if (sel->rb.type == RB_NONE) {
> +			nand->dev_ready = NULL;
> +		} else {
> +			nand->dev_ready = sunxi_nfc_dev_ready;
> +			if (sel->rb.type == RB_NATIVE)
> +				ctl |= (sel->rb.info.nativeid << 3);
> +		}
> +
> +		writel(mtd->writesize, nfc->regs + NFC_REG_SPARE_AREA);
> +
> +		if (nfc->clk_rate != sunxi_nand->clk_rate) {
> +			clk_set_rate(nfc->mod_clk, sunxi_nand->clk_rate);
> +			nfc->clk_rate = sunxi_nand->clk_rate;
> +		}
> +	}
> +
> +	writel(ctl, nfc->regs + NFC_REG_CTL);
> +
> +	sunxi_nand->selected = chip;
> +}
> +
> +static void sunxi_nfc_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> +	int cnt;
> +	int offs = 0;
> +	u32 tmp;
> +
> +	while (len > offs) {
> +		cnt = len - offs;
> +		if (cnt > 1024)
> +			cnt = 1024;

'1024' might deserve its own macro, to represent the controller's buffer
size.

And more succinctly:

	cnt = min(len - offs, 1024);

> +
> +		sunxi_nfc_wait_cmd_fifo_empty(nfc);
> +		writel(cnt, nfc->regs + NFC_REG_CNT);
> +		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD;
> +		writel(tmp, nfc->regs + NFC_REG_CMD);
> +		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +		if (buf)
> +			memcpy_fromio(buf + offs, nfc->regs + NFC_RAM0_BASE,
> +				      cnt);
> +		offs += cnt;
> +	}
> +}
> +
> +static void sunxi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
> +				int len)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> +	int cnt;
> +	int offs = 0;
> +	u32 tmp;
> +
> +	while (len > offs) {
> +		cnt = len - offs;
> +		if (cnt > 1024)
> +			cnt = 1024;

Same here.

> +
> +		sunxi_nfc_wait_cmd_fifo_empty(nfc);
> +		writel(cnt, nfc->regs + NFC_REG_CNT);
> +		memcpy_toio(nfc->regs + NFC_RAM0_BASE, buf + offs, cnt);
> +		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD |
> +		      NFC_ACCESS_DIR;
> +		writel(tmp, nfc->regs + NFC_REG_CMD);
> +		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +		offs += cnt;
> +	}
> +}
> +
> +static uint8_t sunxi_nfc_read_byte(struct mtd_info *mtd)
> +{
> +	uint8_t ret;
> +
> +	sunxi_nfc_read_buf(mtd, &ret, 1);
> +
> +	return ret;
> +}
> +
> +static void sunxi_nfc_cmd_ctrl(struct mtd_info *mtd, int dat,
> +			       unsigned int ctrl)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> +	u32 tmp;
> +
> +	sunxi_nfc_wait_cmd_fifo_empty(nfc);
> +
> +	if (ctrl & NAND_CTRL_CHANGE) {
> +		tmp = readl(nfc->regs + NFC_REG_CTL);
> +		if (ctrl & NAND_NCE)
> +			tmp |= NFC_CE_CTL;
> +		else
> +			tmp &= ~NFC_CE_CTL;
> +		writel(tmp, nfc->regs + NFC_REG_CTL);
> +	}
> +
> +	if (dat == NAND_CMD_NONE)
> +		return;
> +
> +	if (ctrl & NAND_CLE) {
> +		writel(NFC_SEND_CMD1 | dat, nfc->regs + NFC_REG_CMD);
> +	} else {
> +		writel(dat, nfc->regs + NFC_REG_ADDR_LOW);
> +		writel(NFC_SEND_ADR, nfc->regs + NFC_REG_CMD);
> +	}
> +
> +	sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +}
> +
> +static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
> +				      struct nand_chip *chip, uint8_t *buf,
> +				      int oob_required, int page)
> +{
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(chip->controller);
> +	struct nand_ecc_ctrl *ecc = &chip->ecc;
> +	struct nand_ecclayout *layout = ecc->layout;
> +	struct sunxi_nand_hw_ecc *data = ecc->priv;
> +	int steps = mtd->writesize / ecc->size;

Could you just use ecc->steps?

> +	unsigned int max_bitflips = 0;
> +	int offset;
> +	u32 tmp;
> +	int i;
> +	int cnt;
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE);
> +	tmp |= NFC_ECC_EN | (data->mode << NFC_ECC_MODE_SHIFT) |
> +	       NFC_ECC_EXCEPTION;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	for (i = 0; i < steps; i++) {
> +		if (i)
> +			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, i * ecc->size, -1);
> +
> +		offset = mtd->writesize + layout->eccpos[i * ecc->bytes] - 4;
> +
> +		chip->read_buf(mtd, NULL, ecc->size);
> +
> +		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
> +		sunxi_nfc_wait_cmd_fifo_empty(nfc);
> +
> +		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | (1 << 30);
> +		writel(tmp, nfc->regs + NFC_REG_CMD);
> +		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +		memcpy_fromio(buf + (i * ecc->size),
> +			      nfc->regs + NFC_RAM0_BASE, ecc->size);
> +
> +		if (readl(nfc->regs + NFC_REG_ECC_ST) & 0x1) {
> +			mtd->ecc_stats.failed++;
> +		} else {
> +			tmp = readl(nfc->regs + NFC_REG_ECC_CNT0) & 0xff;
> +			mtd->ecc_stats.corrected += tmp;
> +			max_bitflips = max_t(unsigned int, max_bitflips, tmp);
> +		}
> +
> +		if (oob_required) {
> +			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
> +			sunxi_nfc_wait_cmd_fifo_empty(nfc);
> +			offset -= mtd->writesize;
> +			chip->read_buf(mtd, chip->oob_poi + offset,
> +				      ecc->bytes + 4);
> +		}
> +	}
> +
> +	if (oob_required) {
> +		cnt = ecc->layout->oobfree[steps].length;
> +		if (cnt > 0) {
> +			offset = mtd->writesize +
> +				 ecc->layout->oobfree[steps].offset;
> +			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
> +			offset -= mtd->writesize;
> +			chip->read_buf(mtd, chip->oob_poi + offset, cnt);
> +		}
> +	}
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~NFC_ECC_EN;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	return max_bitflips;
> +}
> +
> +static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
> +				       struct nand_chip *chip,
> +				       const uint8_t *buf, int oob_required)
> +{
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(chip->controller);
> +	struct nand_ecc_ctrl *ecc = &chip->ecc;
> +	struct nand_ecclayout *layout = ecc->layout;
> +	struct sunxi_nand_hw_ecc *data = ecc->priv;
> +	int offset;
> +	u32 tmp;
> +	int i;
> +	int cnt;
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE);
> +	tmp |= NFC_ECC_EN | (data->mode << NFC_ECC_MODE_SHIFT) |
> +	       NFC_ECC_EXCEPTION;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	for (i = 0; i < mtd->writesize / ecc->size; i++) {
> +		if (i)
> +			chip->cmdfunc(mtd, NAND_CMD_RNDIN, i * ecc->size, -1);
> +
> +		chip->write_buf(mtd, buf + (i * ecc->size), ecc->size);
> +
> +		offset = layout->eccpos[i * ecc->bytes] - 4 + mtd->writesize;
> +
> +		/* Fill OOB data in */
> +		if (oob_required) {
> +			tmp = 0xffffffff;
> +			memcpy_toio(nfc->regs + NFC_REG_USER_DATA_BASE, &tmp,
> +				    4);
> +		} else {
> +			memcpy_toio(nfc->regs + NFC_REG_USER_DATA_BASE,
> +				    chip->oob_poi + offset - mtd->writesize,
> +				    4);
> +		}
> +
> +		chip->cmdfunc(mtd, NAND_CMD_RNDIN, offset, -1);
> +		sunxi_nfc_wait_cmd_fifo_empty(nfc);
> +
> +		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ACCESS_DIR |
> +		      (1 << 30);
> +		writel(tmp, nfc->regs + NFC_REG_CMD);
> +		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +	}
> +
> +	if (oob_required) {
> +		cnt = ecc->layout->oobfree[i].length;
> +		if (cnt > 0) {
> +			offset = mtd->writesize +
> +				 ecc->layout->oobfree[i].offset;
> +			chip->cmdfunc(mtd, NAND_CMD_RNDIN, offset, -1);
> +			offset -= mtd->writesize;
> +			chip->write_buf(mtd, chip->oob_poi + offset, cnt);
> +		}
> +	}
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~NFC_ECC_EN;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	return 0;
> +}
> +
> +static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
> +					       struct nand_chip *chip,
> +					       uint8_t *buf, int oob_required,
> +					       int page)
> +{
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(chip->controller);
> +	struct nand_ecc_ctrl *ecc = &chip->ecc;
> +	struct sunxi_nand_hw_ecc *data = ecc->priv;
> +	int steps = mtd->writesize / ecc->size;

ecc->steps?

> +	unsigned int max_bitflips = 0;
> +	uint8_t *oob = chip->oob_poi;
> +	int offset = 0;
> +	int cnt;
> +	u32 tmp;
> +	int i;
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE);
> +	tmp |= NFC_ECC_EN | (data->mode << NFC_ECC_MODE_SHIFT) |
> +	       NFC_ECC_EXCEPTION;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	for (i = 0; i < steps; i++) {
> +		chip->read_buf(mtd, NULL, ecc->size);
> +
> +		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | (1 << 30);
> +		writel(tmp, nfc->regs + NFC_REG_CMD);
> +		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +		memcpy_fromio(buf, nfc->regs + NFC_RAM0_BASE, ecc->size);
> +		buf += ecc->size;
> +		offset += ecc->size;
> +
> +		if (readl(nfc->regs + NFC_REG_ECC_ST) & 0x1) {
> +			mtd->ecc_stats.failed++;
> +		} else {
> +			tmp = readl(nfc->regs + NFC_REG_ECC_CNT0) & 0xff;
> +			mtd->ecc_stats.corrected += tmp;
> +			max_bitflips = max_t(unsigned int, max_bitflips, tmp);
> +		}
> +
> +		if (oob_required) {
> +			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
> +			chip->read_buf(mtd, oob, ecc->bytes + ecc->prepad);
> +			oob += ecc->bytes + ecc->prepad;
> +		}
> +
> +		offset += ecc->bytes + ecc->prepad;
> +	}
> +
> +	if (oob_required) {
> +		cnt = mtd->oobsize - (oob - chip->oob_poi);
> +		if (cnt > 0) {
> +			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
> +			chip->read_buf(mtd, oob, cnt);
> +		}
> +	}
> +
> +	writel(readl(nfc->regs + NFC_REG_ECC_CTL) & ~NFC_ECC_EN,
> +	       nfc->regs + NFC_REG_ECC_CTL);
> +
> +	return max_bitflips;
> +}
> +
> +static int sunxi_nfc_hw_syndrome_ecc_write_page(struct mtd_info *mtd,
> +						struct nand_chip *chip,
> +						const uint8_t *buf,
> +						int oob_required)
> +{
> +	struct sunxi_nfc *nfc = to_sunxi_nfc(chip->controller);
> +	struct nand_ecc_ctrl *ecc = &chip->ecc;
> +	struct sunxi_nand_hw_ecc *data = ecc->priv;
> +	int steps = mtd->writesize / ecc->size;

ecc->steps?

> +	uint8_t *oob = chip->oob_poi;
> +	int offset = 0;
> +	int cnt;
> +	u32 tmp;
> +	int i;
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE);
> +	tmp |= NFC_ECC_EN | (data->mode << NFC_ECC_MODE_SHIFT) |
> +	       NFC_ECC_EXCEPTION;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	for (i = 0; i < steps; i++) {
> +		chip->write_buf(mtd, buf + (i * ecc->size), ecc->size);
> +		offset += ecc->size;
> +
> +		/* Fill OOB data in */
> +		if (oob_required) {
> +			tmp = 0xffffffff;
> +			memcpy_toio(nfc->regs + NFC_REG_USER_DATA_BASE, &tmp,
> +				    4);
> +		} else {
> +			memcpy_toio(nfc->regs + NFC_REG_USER_DATA_BASE, oob ,

Stray space before the comma.

> +				    4);
> +		}
> +
> +		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ACCESS_DIR |
> +		      (1 << 30);
> +		writel(tmp, nfc->regs + NFC_REG_CMD);
> +		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
> +
> +		offset += ecc->bytes + ecc->prepad;
> +		oob += ecc->bytes + ecc->prepad;
> +	}
> +
> +	if (oob_required) {
> +		cnt = mtd->oobsize - (oob - chip->oob_poi);
> +		if (cnt > 0) {
> +			chip->cmdfunc(mtd, NAND_CMD_RNDIN, offset, -1);
> +			chip->write_buf(mtd, oob, cnt);
> +		}
> +	}
> +
> +	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
> +	tmp &= ~NFC_ECC_EN;
> +
> +	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
> +
> +	return 0;
> +}
> +
> +static int sunxi_nand_chip_set_timings(struct sunxi_nand_chip *chip,
> +				       const struct nand_sdr_timings *timings)
> +{
> +	u32 min_clk_period = 0;
> +
> +	/* T1 <=> tCLS */
> +	if (timings->tCLS_min > min_clk_period)
> +		min_clk_period = timings->tCLS_min;
> +
> +	/* T2 <=> tCLH */
> +	if (timings->tCLH_min > min_clk_period)
> +		min_clk_period = timings->tCLH_min;
> +
> +	/* T3 <=> tCS */
> +	if (timings->tCS_min > min_clk_period)
> +		min_clk_period = timings->tCS_min;
> +
> +	/* T4 <=> tCH */
> +	if (timings->tCH_min > min_clk_period)
> +		min_clk_period = timings->tCH_min;
> +
> +	/* T5 <=> tWP */
> +	if (timings->tWP_min > min_clk_period)
> +		min_clk_period = timings->tWP_min;
> +
> +	/* T6 <=> tWH */
> +	if (timings->tWH_min > min_clk_period)
> +		min_clk_period = timings->tWH_min;
> +
> +	/* T7 <=> tALS */
> +	if (timings->tALS_min > min_clk_period)
> +		min_clk_period = timings->tALS_min;
> +
> +	/* T8 <=> tDS */
> +	if (timings->tDS_min > min_clk_period)
> +		min_clk_period = timings->tDS_min;
> +
> +	/* T9 <=> tDH */
> +	if (timings->tDH_min > min_clk_period)
> +		min_clk_period = timings->tDH_min;
> +
> +	/* T10 <=> tRR */
> +	if (timings->tRR_min > (min_clk_period * 3))
> +		min_clk_period = (timings->tRR_min + 2) / 3;

Could be:

		min_clk_period = DIV_ROUND_UP(timings->tRR_min, 3);

> +
> +	/* T11 <=> tALH */
> +	if (timings->tALH_min > min_clk_period)
> +		min_clk_period = timings->tALH_min;
> +
> +	/* T12 <=> tRP */
> +	if (timings->tRP_min > min_clk_period)
> +		min_clk_period = timings->tRP_min;
> +
> +	/* T13 <=> tREH */
> +	if (timings->tREH_min > min_clk_period)
> +		min_clk_period = timings->tREH_min;
> +
> +	/* T14 <=> tRC */
> +	if (timings->tRC_min > (min_clk_period * 2))
> +		min_clk_period = (timings->tRC_min + 1) / 2;

DIV_ROUND_UP()?

> +
> +	/* T15 <=> tWC */
> +	if (timings->tWC_min > (min_clk_period * 2))
> +		min_clk_period = (timings->tWC_min + 1) / 2;

DIV_ROUND_UP()?

> +
> +
> +	/* min_clk_period = (NAND-clk-period * 2) */
> +	if (min_clk_period < 1000)
> +		min_clk_period = 1000;
> +
> +	min_clk_period /= 1000;

Perhaps the above three lines would work better as:

	min_clk_period = DIV_ROUND_UP(min_clk_period, 1000);

Although that does change the computation a bit.

Also, I think this is a picoseconds to nanoseconds conversion, right?
That deserves at least a comment, if not a named macro.

> +	chip->clk_rate = (2 * 1000000000) / min_clk_period;

Hmm, can you be a little more explicit about what conversion is going on
here? A comment could help, to include units (Hz, nanoseconds, etc.)

> +
> +	/* TODO: configure T16-T19 */
> +
> +	return 0;
> +}
> +
> +static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
> +					struct device_node *np)
> +{
> +	const struct nand_sdr_timings *timings;
> +	int ret;
> +	int mode;
> +
> +	mode = onfi_get_async_timing_mode(&chip->nand);
> +	if (mode == ONFI_TIMING_MODE_UNKNOWN) {
> +		mode = chip->nand.onfi_timing_mode_default;
> +	} else {
> +		uint8_t feature[ONFI_SUBFEATURE_PARAM_LEN] = {};
> +
> +		mode = fls(mode) - 1;
> +		if (mode < 0)
> +			mode = 0;
> +
> +		feature[0] = mode;
> +		ret = chip->nand.onfi_set_features(&chip->mtd, &chip->nand,
> +						ONFI_FEATURE_ADDR_TIMING_MODE,
> +						feature);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	timings = onfi_async_timing_mode_to_sdr_timings(mode);
> +	if (IS_ERR(timings))
> +		return PTR_ERR(timings);
> +
> +	return sunxi_nand_chip_set_timings(chip, timings);
> +}
> +
> +static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
> +					      struct nand_ecc_ctrl *ecc,
> +					      struct device_node *np)
> +{
> +	struct sunxi_nand_hw_ecc *data;
> +	struct nand_ecclayout *layout;
> +	int nsectors;
> +	int ret;
> +
> +	if (!ecc->strength || !ecc->size)
> +		return -EINVAL;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* Add ECC info retrieval from DT */
> +	if (ecc->strength <= 16) {
> +		ecc->strength = 16;
> +		data->mode = 0;
> +	} else if (ecc->strength <= 24) {
> +		ecc->strength = 24;
> +		data->mode = 1;
> +	} else if (ecc->strength <= 28) {
> +		ecc->strength = 28;
> +		data->mode = 2;
> +	} else if (ecc->strength <= 32) {
> +		ecc->strength = 32;
> +		data->mode = 3;
> +	} else if (ecc->strength <= 40) {
> +		ecc->strength = 40;
> +		data->mode = 4;
> +	} else if (ecc->strength <= 48) {
> +		ecc->strength = 48;
> +		data->mode = 5;
> +	} else if (ecc->strength <= 56) {
> +		ecc->strength = 56;
> +		data->mode = 6;
> +	} else if (ecc->strength <= 60) {
> +		ecc->strength = 60;
> +		data->mode = 7;
> +	} else if (ecc->strength <= 64) {
> +		ecc->strength = 64;
> +		data->mode = 8;
> +	} else {
> +		pr_err("unsupported strength\n");
> +		ret = -ENOTSUPP;
> +		goto err;
> +	}

Not strictly necessary, but this if/else structure might be better
served by a loop over a sorted array of mode/strength pairs.

> +
> +	/* HW ECC always request ECC bytes for 1024 bytes blocks */
> +	ecc->bytes = ((ecc->strength * fls(8 * 1024)) + 7) / 8;

Could be:

	ecc->bytes = DIV_ROUND_UP(ecc->strength * fls(8 * 1024), 8);

> +
> +	/* HW ECC always work with even numbers of ECC bytes */
> +	if (ecc->bytes % 2)
> +		ecc->bytes++;

Could be:

	ecc->bytes = ALIGN(ecc->bytes, 2);

> +
> +	layout = &data->layout;
> +	nsectors = mtd->writesize / ecc->size;
> +
> +	if (mtd->oobsize < ((ecc->bytes + 4) * nsectors)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	layout->eccbytes = (ecc->bytes * nsectors);
> +
> +	ecc->layout = layout;
> +	ecc->priv = data;
> +
> +	return 0;
> +
> +err:
> +	kfree(data);
> +
> +	return ret;
> +}
> +
> +static void sunxi_nand_hw_common_ecc_ctrl_cleanup(struct nand_ecc_ctrl *ecc)
> +{
> +	kfree(ecc->priv);
> +}
> +
> +static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
> +				       struct nand_ecc_ctrl *ecc,
> +				       struct device_node *np)
> +{
> +	struct nand_ecclayout *layout;
> +	int nsectors;
> +	int i, j;
> +	int ret;
> +
> +	ret = sunxi_nand_hw_common_ecc_ctrl_init(mtd, ecc, np);
> +	if (ret)
> +		return ret;
> +
> +	ecc->read_page = sunxi_nfc_hw_ecc_read_page;
> +	ecc->write_page = sunxi_nfc_hw_ecc_write_page;
> +	layout = ecc->layout;
> +	nsectors = mtd->writesize / ecc->size;
> +
> +	for (i = 0; i < nsectors; i++) {
> +		if (i) {
> +			layout->oobfree[i].offset =
> +				layout->oobfree[i - 1].offset +
> +				layout->oobfree[i - 1].length +
> +				ecc->bytes;
> +			layout->oobfree[i].length = 4;
> +		} else {
> +			/*
> +			 * The first 2 bytes are used for BB markers, hence we
> +			 * only have 2 bytes available in the first user data
> +			 * section.
> +			 */
> +			layout->oobfree[i].length = 2;
> +			layout->oobfree[i].offset = 2;
> +		}
> +
> +		for (j = 0; j < ecc->bytes; j++)
> +			layout->eccpos[(ecc->bytes * i) + j] =
> +					layout->oobfree[i].offset +
> +					layout->oobfree[i].length + j;
> +	}
> +
> +	if (mtd->oobsize > (ecc->bytes + 4) * nsectors) {
> +		layout->oobfree[nsectors].offset =
> +				layout->oobfree[nsectors - 1].offset +
> +				layout->oobfree[nsectors - 1].length +
> +				ecc->bytes;
> +		layout->oobfree[nsectors].length = mtd->oobsize -
> +				((ecc->bytes + 4) * nsectors);
> +	}
> +
> +	return 0;
> +}
> +
> +static int sunxi_nand_hw_syndrome_ecc_ctrl_init(struct mtd_info *mtd,
> +						struct nand_ecc_ctrl *ecc,
> +						struct device_node *np)
> +{
> +	struct nand_ecclayout *layout;
> +	int nsectors;
> +	int i;
> +	int ret;
> +
> +	ret = sunxi_nand_hw_common_ecc_ctrl_init(mtd, ecc, np);
> +	if (ret)
> +		return ret;
> +
> +	ecc->prepad = 4;
> +	ecc->read_page = sunxi_nfc_hw_syndrome_ecc_read_page;
> +	ecc->write_page = sunxi_nfc_hw_syndrome_ecc_write_page;
> +
> +	layout = ecc->layout;
> +	nsectors = mtd->writesize / ecc->size;
> +
> +	for (i = 0; i < (ecc->bytes * nsectors); i++)
> +		layout->eccpos[i] = i;
> +
> +	layout->oobfree[0].length = mtd->oobsize - i;
> +	layout->oobfree[0].offset = i;
> +
> +	return 0;
> +}
> +
> +static void sunxi_nand_ecc_cleanup(struct nand_ecc_ctrl *ecc)
> +{
> +	switch (ecc->mode) {
> +	case NAND_ECC_HW:
> +	case NAND_ECC_HW_SYNDROME:
> +		sunxi_nand_hw_common_ecc_ctrl_cleanup(ecc);
> +		break;
> +	case NAND_ECC_NONE:
> +		kfree(ecc->layout);
> +	default:
> +		break;
> +	}
> +}
> +
> +static int sunxi_nand_ecc_init(struct mtd_info *mtd, struct nand_ecc_ctrl *ecc,
> +			       struct device_node *np)
> +{
> +	struct nand_chip *nand = mtd->priv;
> +	int strength;
> +	int blk_size;
> +	int ret;
> +
> +	blk_size = of_get_nand_ecc_step_size(np);
> +	strength = of_get_nand_ecc_strength(np);
> +	if (blk_size > 0 && strength > 0) {
> +		ecc->size = blk_size;
> +		ecc->strength = strength;
> +	} else {
> +		ecc->size = nand->ecc_step_ds;
> +		ecc->strength = nand->ecc_strength_ds;
> +	}

Might you just want to catch the case where you neither got ECC info
from DT nor from the *_ds parameters? This could happen, for instance,
if you have CONFIG_OF=n.

Then, you won't need to catch the !ecc->size || !ecc->strength cases
elsewhere.

> +
> +	ecc->mode = NAND_ECC_HW;
> +
> +	ret = of_get_nand_ecc_mode(np);
> +	if (ret >= 0)
> +		ecc->mode = ret;
> +
> +	switch (ecc->mode) {
> +	case NAND_ECC_SOFT_BCH:
> +		if (!ecc->size || !ecc->strength)
> +			return -EINVAL;
> +		ecc->bytes = ((ecc->strength * fls(8 * ecc->size)) + 7) / 8;

DIV_ROUND_UP()

> +		break;
> +	case NAND_ECC_HW:
> +		ret = sunxi_nand_hw_ecc_ctrl_init(mtd, ecc, np);
> +		if (ret)
> +			return ret;
> +		break;
> +	case NAND_ECC_HW_SYNDROME:
> +		ret = sunxi_nand_hw_syndrome_ecc_ctrl_init(mtd, ecc, np);
> +		if (ret)
> +			return ret;
> +		break;
> +	case NAND_ECC_NONE:
> +		ecc->layout = kzalloc(sizeof(*ecc->layout), GFP_KERNEL);
> +		if (!ecc->layout)
> +			return -ENOMEM;
> +		ecc->layout->oobfree[0].length = mtd->oobsize;
> +	case NAND_ECC_SOFT:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
> +				struct device_node *np)
> +{
> +	const struct nand_sdr_timings *timings;
> +	struct sunxi_nand_chip *chip;
> +	struct mtd_part_parser_data ppdata;
> +	struct mtd_info *mtd;
> +	struct nand_chip *nand;
> +	int nsels;
> +	int ret;
> +	int i;
> +	u32 tmp;
> +
> +	if (!of_get_property(np, "reg", &nsels))
> +		return -EINVAL;
> +
> +	nsels /= sizeof(u32);
> +	if (!nsels) {
> +		dev_err(dev, "invalid reg porperty size\n");

s/porperty/property/

> +		return -EINVAL;
> +	}
> +
> +	chip = devm_kzalloc(dev,
> +			    sizeof(*chip) +
> +			    (nsels * sizeof(struct sunxi_nand_chip_sel)),
> +			    GFP_KERNEL);
> +	if (!chip) {
> +		dev_err(dev, "could not allocate chip\n");
> +		return -ENOMEM;
> +	}
> +
> +	chip->nsels = nsels;
> +	chip->selected = -1;
> +
> +	for (i = 0; i < nsels; i++) {
> +		ret = of_property_read_u32_index(np, "reg", i, &tmp);
> +		if (ret) {
> +			dev_err(dev, "could not retrieve reg property: %d\n",
> +				ret);
> +			return ret;
> +		}
> +
> +		if (tmp > 7) {
> +			dev_err(dev,
> +				"invalid reg value: %u (max CS = 7)\n",

Could use a macro for the constant '7'. And placing its definition near
the definition of MAX_NAME_SIZE could help guide the reader.

> +				tmp);
> +			return -EINVAL;
> +		}
> +
> +		if (test_and_set_bit(tmp, &nfc->assigned_cs)) {
> +			dev_err(dev, "CS %d already assigned\n", tmp);
> +			return -EINVAL;
> +		}
> +
> +		chip->sels[i].cs = tmp;
> +
> +		if (!of_property_read_u32_index(np, "allwinner,rb", i, &tmp) &&
> +		    tmp < 2) {
> +			chip->sels[i].rb.type = RB_NATIVE;
> +			chip->sels[i].rb.info.nativeid = tmp;
> +		} else {
> +			ret = of_get_named_gpio(np, "rb-gpios", i);
> +			if (ret >= 0) {
> +				tmp = ret;
> +				chip->sels[i].rb.type = RB_GPIO;
> +				chip->sels[i].rb.info.gpio = tmp;
> +				ret = devm_gpio_request(dev, tmp, "nand-rb");
> +				if (ret)
> +					return ret;
> +
> +				ret = gpio_direction_input(tmp);
> +				if (ret)
> +					return ret;
> +			} else {
> +				chip->sels[i].rb.type = RB_NONE;
> +			}
> +		}
> +	}
> +
> +	timings = onfi_async_timing_mode_to_sdr_timings(0);
> +	if (IS_ERR(timings)) {
> +		ret = PTR_ERR(timings);
> +		dev_err(dev,
> +			"could not retrieve timings for ONFI mode 0: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret = sunxi_nand_chip_set_timings(chip, timings);
> +	if (ret) {
> +		dev_err(dev, "could not configure chip timings: %d\n", ret);
> +		return ret;
> +	}
> +
> +	nand = &chip->nand;
> +	/* Default tR value specified in the ONFI spec (chapter 4.15.1) */
> +	nand->chip_delay = 200;
> +	nand->controller = &nfc->controller;
> +	nand->select_chip = sunxi_nfc_select_chip;
> +	nand->cmd_ctrl = sunxi_nfc_cmd_ctrl;
> +	nand->read_buf = sunxi_nfc_read_buf;
> +	nand->write_buf = sunxi_nfc_write_buf;
> +	nand->read_byte = sunxi_nfc_read_byte;
> +
> +	if (of_get_nand_on_flash_bbt(np))
> +		nand->bbt_options |= NAND_BBT_USE_FLASH | NAND_BBT_NO_OOB;
> +
> +	mtd = &chip->mtd;
> +	mtd->dev.parent = dev;
> +	mtd->priv = nand;
> +	mtd->owner = THIS_MODULE;
> +
> +	ret = nand_scan_ident(mtd, nsels, NULL);
> +	if (ret)
> +		return ret;
> +
> +	ret = sunxi_nand_chip_init_timings(chip, np);
> +	if (ret) {
> +		dev_err(dev, "could not configure chip timings: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = sunxi_nand_ecc_init(mtd, &nand->ecc, np);
> +	if (ret) {
> +		dev_err(dev, "ECC init failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = nand_scan_tail(mtd);
> +	if (ret) {
> +		dev_err(dev, "nand_scan_tail failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (of_property_read_string(np, "nand-name", &mtd->name)) {
> +		snprintf(chip->default_name, MAX_NAME_SIZE,
> +			 DEFAULT_NAME_FORMAT, chip->sels[i].cs);
> +		mtd->name = chip->default_name;
> +	}
> +
> +	ppdata.of_node = np;
> +	ret = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
> +	if (ret) {
> +		dev_err(dev, "failed to register mtd device: %d\n", ret);
> +		nand_release(mtd);
> +		return ret;
> +	}
> +
> +	list_add_tail(&chip->node, &nfc->chips);
> +
> +	return 0;
> +}
> +
> +static int sunxi_nand_chips_init(struct device *dev, struct sunxi_nfc *nfc)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct device_node *nand_np;
> +	int nchips = of_get_child_count(np);
> +	int ret;
> +
> +	if (nchips > 8) {
> +		dev_err(dev, "too many NAND chips: %d (max = 8)\n", nchips);
> +		return -EINVAL;
> +	}
> +
> +	for_each_child_of_node(np, nand_np) {
> +		ret = sunxi_nand_chip_init(dev, nfc, nand_np);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void sunxi_nand_chips_cleanup(struct sunxi_nfc *nfc)
> +{
> +	struct sunxi_nand_chip *chip;
> +
> +	while (!list_empty(&nfc->chips)) {
> +		chip = list_first_entry(&nfc->chips, struct sunxi_nand_chip,
> +					node);
> +		nand_release(&chip->mtd);
> +		sunxi_nand_ecc_cleanup(&chip->nand.ecc);
> +	}
> +}
> +
> +static int sunxi_nfc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *r;
> +	struct sunxi_nfc *nfc;
> +	int irq;
> +	int ret;
> +
> +	nfc = devm_kzalloc(dev, sizeof(*nfc), GFP_KERNEL);
> +	if (!nfc)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&nfc->controller.lock);
> +	init_waitqueue_head(&nfc->controller.wq);
> +	INIT_LIST_HEAD(&nfc->chips);
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	nfc->regs = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(nfc->regs))
> +		return PTR_ERR(nfc->regs);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(dev, "failed to retrieve irq\n");
> +		return irq;
> +	}
> +
> +	nfc->ahb_clk = devm_clk_get(dev, "ahb");
> +	if (IS_ERR(nfc->ahb_clk)) {
> +		dev_err(dev, "failed to retrieve ahb clk\n");
> +		return PTR_ERR(nfc->ahb_clk);
> +	}
> +
> +	ret = clk_prepare_enable(nfc->ahb_clk);
> +	if (ret)
> +		return ret;
> +
> +	nfc->mod_clk = devm_clk_get(dev, "mod");
> +	if (IS_ERR(nfc->mod_clk)) {
> +		dev_err(dev, "failed to retrieve mod clk\n");
> +		ret = PTR_ERR(nfc->mod_clk);
> +		goto out_ahb_clk_unprepare;
> +	}
> +
> +	ret = clk_prepare_enable(nfc->mod_clk);
> +	if (ret)
> +		goto out_ahb_clk_unprepare;
> +
> +	sunxi_nfc_rst(nfc);
> +
> +	writel(0, nfc->regs + NFC_REG_INT);
> +	ret = devm_request_irq(dev, irq, sunxi_nfc_interrupt,
> +			       0, "sunxi-nand", nfc);
> +	if (ret)
> +		goto out_mod_clk_unprepare;
> +
> +	platform_set_drvdata(pdev, nfc);
> +
> +	/*
> +	 * TODO: replace these magic values with proper flags as soon as we
> +	 * know what they are encoding.
> +	 */
> +	writel(0x100, nfc->regs + NFC_REG_TIMING_CTL);
> +	writel(0x7ff, nfc->regs + NFC_REG_TIMING_CFG);
> +
> +	ret = sunxi_nand_chips_init(dev, nfc);
> +	if (ret) {
> +		dev_err(dev, "failed to init nand chips\n");
> +		goto out_mod_clk_unprepare;
> +	}
> +
> +	return 0;
> +
> +out_mod_clk_unprepare:
> +	clk_disable_unprepare(nfc->mod_clk);
> +out_ahb_clk_unprepare:
> +	clk_disable_unprepare(nfc->ahb_clk);
> +
> +	return ret;
> +}
> +
> +static int sunxi_nfc_remove(struct platform_device *pdev)
> +{
> +	struct sunxi_nfc *nfc = platform_get_drvdata(pdev);
> +
> +	sunxi_nand_chips_cleanup(nfc);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id sunxi_nfc_ids[] = {
> +	{ .compatible = "allwinner,sun4i-a10-nand" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, sunxi_nfc_ids);
> +
> +static struct platform_driver sunxi_nfc_driver = {
> +	.driver = {
> +		.name = "sunxi_nand",
> +		.owner = THIS_MODULE,
> +		.of_match_table = sunxi_nfc_ids,
> +	},
> +	.probe = sunxi_nfc_probe,
> +	.remove = sunxi_nfc_remove,
> +};
> +module_platform_driver(sunxi_nfc_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Boris BREZILLON");
> +MODULE_DESCRIPTION("Allwinner NAND Flash Controller driver");
> +MODULE_ALIAS("platform:sunxi_nand");

Brian
