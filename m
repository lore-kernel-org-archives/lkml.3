Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3GAFT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:19:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55452 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3GAFTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:19:54 -0400
Message-ID: <51D11124.1070300@ti.com>
Date: Mon, 1 Jul 2013 10:48:28 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>, <artem.bityutskiy@linux.intel.com>
CC: <linux-mtd@lists.infradead.org>, <spi-devel-general@lists.sourceforge.net>,
        <broonie@kernel.org>, <dwmw2@infradead.org>, <manonuevo@micron.com>,
        <tqnguyen@micron.com>, <grant.likely@linaro.org>, <balbi@ti.com>,
        <rnayak@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/3] drivers: mtd: spinand: Add qspi spansion flash controller
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com> <1372232472-2641-4-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1372232472-2641-4-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Artem
On Wednesday 26 June 2013 01:11 PM, Sourav Poddar wrote:
> The patch adds support for spansion s25fl256s spi flash controller.
> Currently, the patch supports only SPI based transaction.
>
> As, the qspi to which flash is attached supports memory mapped interface,
> support will be added in future for memory mapped transactions also.
>
> This driver gets attached to the generic spinand mtd framework proposed in the
> first patch of the series.
>
> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
> ---
>   drivers/mtd/spinand/Kconfig         |    7 +
>   drivers/mtd/spinand/Makefile        |    2 +-
>   drivers/mtd/spinand/ti-qspi-flash.c |  373 +++++++++++++++++++++++++++++++++++
>   3 files changed, 381 insertions(+), 1 deletions(-)
>   create mode 100644 drivers/mtd/spinand/ti-qspi-flash.c
>
> diff --git a/drivers/mtd/spinand/Kconfig b/drivers/mtd/spinand/Kconfig
> index 38c739f..1342de3 100644
> --- a/drivers/mtd/spinand/Kconfig
> +++ b/drivers/mtd/spinand/Kconfig
> @@ -16,6 +16,13 @@ config MTD_SPINAND_ONDIEECC
>   	help
>   	 Internel ECC
>
> +config MTD_S25FL256S
> +	tristate "Support spansion memory mapped SPI Flash chips"
> +	depends on SPI_MASTER
> +	help
> +	  This enables access to spansion QSPI flash chips, which used
> +	  memory mapped interface used for program and data storage.
> +
>   config MTD_SPINAND_SWECC
>   	bool "Use software ECC"
>   	depends on MTD_NAND
> diff --git a/drivers/mtd/spinand/Makefile b/drivers/mtd/spinand/Makefile
> index 355e726..8ad0dd5 100644
> --- a/drivers/mtd/spinand/Makefile
> +++ b/drivers/mtd/spinand/Makefile
> @@ -5,6 +5,6 @@
>   # Core functionality.
>   obj-$(CONFIG_MTD_SPINAND)		+= spinand.o
>
> -spinand-objs := spinand_mtd.o spinand_lld.o
> +spinand-objs := spinand_mtd.o spinand_lld.o ti-qspi-flash.o
>
>
> diff --git a/drivers/mtd/spinand/ti-qspi-flash.c b/drivers/mtd/spinand/ti-qspi-flash.c
> new file mode 100644
> index 0000000..dfa6235
> --- /dev/null
> +++ b/drivers/mtd/spinand/ti-qspi-flash.c
> @@ -0,0 +1,373 @@
> +/*
> + * MTD SPI driver for spansion s25fl256s (and similar) serial flash chips
> + *
> + * Author: Sourav Poddar, sourav.poddar@ti.com
> + *
> + * Copyright (c) 2013, Texas Instruments.
> + *
> + * This code is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> +*/
> +
> +#include<linux/init.h>
> +#include<linux/err.h>
> +#include<linux/errno.h>
> +#include<linux/module.h>
> +#include<linux/device.h>
> +#include<linux/interrupt.h>
> +#include<linux/mutex.h>
> +#include<linux/math64.h>
> +#include<linux/slab.h>
> +#include<linux/sched.h>
> +#include<linux/mod_devicetable.h>
> +
> +#include<linux/mtd/mtd.h>
> +#include<linux/mtd/partitions.h>
> +#include<linux/of_platform.h>
> +
> +#include<linux/spi/spi.h>
> +#include<linux/mtd/spinand.h>
> +
> +#define	CMD_OPCODE_RDSR		0x05    /* Read status register */
> +#define CMD_OPCODE_FAST_READ	0x0b	/* Fast Read */
> +#define	MAX_READY_WAIT_JIFFIES	(40 * HZ) /* M25P16 specs 40s max chip erase */
> +
> +#define	SR_WIP		1       /* Write in progress */
> +#define	SR_WEL		2       /* Write enable latch */
> +
> +static u16	addr_width;
> +bool	fast_read;
> +
> +static struct nand_ecclayout spinand_oob_0 = {
> +	.eccbytes = 0,
> +	.eccpos = {},
> +	.oobavail = 0,
> +	.oobfree = {
> +		{.offset = 0,
> +		.length = 0}, }
> +};
> +
> +/*
> + * Read the status register, returning its value in the location
> + * Return the status register value.
> + * Returns negative if error occurred.
> +*/
> +static int read_sr(struct spi_device *spi_nand)
> +{
> +	ssize_t retval;
> +	u8 val;
> +	u8 code	=	CMD_OPCODE_RDSR;
> +
> +	retval = spi_write_then_read(spi_nand,&code, 1,&val, 1);
> +
> +	if (retval<  0) {
> +		dev_info(&spi_nand->dev, "error %d reading SR\n",
> +			(int) retval);
> +		return retval;
> +	}
> +
> +	return val;
> +}
> +
> +/*
> + * Set write enable latch with Write Enable command.
> + * Returns negative if error occurred.
> +*/
> +static inline int write_enable(struct spi_device *spi_nand)
> +{
> +	u8	code = CMD_WR_ENABLE;
> +
> +	return spi_write_then_read(spi_nand,&code, 1, NULL, 0);
> +}
> +
> +/*
> + * Send write disble instruction to the chip.
> +*/
> +static inline int write_disable(struct spi_device *spi_nand)
> +{
> +	u8	code = CMD_WR_DISABLE;
> +
> +	return spi_write_then_read(spi_nand,&code, 1, NULL, 0);
> +}
> +
> +/*
> + * Service routine to read status register until ready, or timeout occurs.
> + * Returns non-zero if error.
> +*/
> +static int wait_till_ready(struct spi_device *spi_nand)
> +{
> +	unsigned long deadline;
> +	int sr;
> +
> +	deadline = jiffies + MAX_READY_WAIT_JIFFIES;
> +
> +	do {
> +		sr = read_sr(spi_nand);
> +		if (sr<  0)
> +			return -1;
> +		else if (!(sr&  SR_WIP))
> +			break;
> +
> +		cond_resched();
> +	} while (!time_after_eq(jiffies, deadline));
> +
> +	if ((sr&  SR_WIP) == 0)
> +		return 0;
> +
> +	return -1;
> +}
> +
> +static inline int spinand_read_id(struct spi_device *spi_nand, u8 *id)
> +{
> +	u8      code = CMD_READ_ID;
> +
> +	return  spi_write_then_read(spi_nand,&code, 1, id, sizeof(id));
> +}
> +
> +static void s25fl_addr2cmd(struct spi_device *spi_nand,
> +		unsigned int addr, u8 *cmd)
> +{
> +	/* opcode is in cmd[0] */
> +	cmd[1] = addr>>  (addr_width * 8 -  8);
> +	cmd[2] = addr>>  (addr_width * 8 - 16);
> +	cmd[3] = addr>>  (addr_width * 8 - 24);
> +}
> +
> +static int s25fl_cmdsz(struct  spi_device *spi_nand)
> +{
> +	return 1 + addr_width;
> +}
> +
> +static int spinand_erase_block(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 block_id)
> +{
> +	unsigned int offset;
> +	u8 cmd[4];
> +	uint8_t opcode;
> +
> +	offset = block_id * info->block_size;
> +
> +	/* Wait until finished previous write command. */
> +	if (wait_till_ready(spi_nand))
> +		return 1;
> +
> +	/* Send write enable, then erase commands. */
> +	write_enable(spi_nand);
> +
> +	/* Set up command buffer. */
> +	opcode = CMD_ERASE_BLK;
> +	cmd[0] = opcode;
> +	s25fl_addr2cmd(spi_nand, offset, cmd);
> +
> +	spi_write(spi_nand, cmd, s25fl_cmdsz(spi_nand));
> +
> +	return 0;
> +}
> +
> +static int spinand_read_page(struct spi_device *spi_nand,
> +	struct spinand_info *info, u16 page_id, u16 offset, u16 len, u8 *rbuf)
> +{
> +	struct spi_transfer t[2];
> +	struct spi_message m;
> +	uint8_t opcode;
> +	u8 cmd[4];
> +
> +	spi_message_init(&m);
> +	memset(t, 0, sizeof(t));
> +
> +	t[0].tx_buf = cmd;
> +	t[0].len = s25fl_cmdsz(spi_nand);
> +	spi_message_add_tail(&t[0],&m);
> +
> +	t[1].rx_buf = rbuf;
> +	t[1].len = len;
> +	spi_message_add_tail(&t[1],&m);
> +
> +	/* Wait till previous write/erase is done. */
> +	if (wait_till_ready(spi_nand))
> +		return 1;
> +
> +	/* Set up the write data buffer. */
> +	opcode = fast_read ? CMD_OPCODE_FAST_READ : CMD_READ_RDM;
> +	cmd[0] = opcode;
> +
> +	s25fl_addr2cmd(spi_nand, offset, cmd);
> +
> +	spi_sync(spi_nand,&m);
> +
> +	return 0;
> +}
> +
> +static int spinand_program_page(struct spi_device *spi_nand,
> +	struct spinand_info *info, u16 page_id, u16 offset, u16 len, u8 *wbuf)
> +{
> +	struct spi_transfer t[2];
> +	struct spi_message m;
> +	u8 cmd[4];
> +
> +	pr_debug("%s: %s to 0x%08x, len %zd\n", dev_name(&spi_nand->dev),
> +			__func__, (u32)offset, len);
> +
> +	spi_message_init(&m);
> +	memset(t, 0, sizeof(t));
> +
> +	t[0].tx_buf = cmd;
> +	t[0].len = 4;
> +	spi_message_add_tail(&t[0],&m);
> +
> +	t[1].tx_buf = wbuf;
> +        t[0].len = len;
> +	spi_message_add_tail(&t[1],&m);
> +
> +	write_enable(spi_nand);
> +
> +	/* Wait until finished previous write command. */
> +	if (wait_till_ready(spi_nand))
> +		return 1;
> +
> +	/* Set up the opcode in the write buffer. */
> +	cmd[0] = CMD_PROG_PAGE_CLRCACHE;
> +	s25fl_addr2cmd(spi_nand, offset, cmd);
> +
> +	spi_sync(spi_nand,&m);
> +
> +	return 0;
> +}
> +
> +static int spinand_get_info(struct spi_device *spi_nand,
> +		struct spinand_info *info, u8 *id)
> +{
> +	if (id[0] == 0x01&&  id[1] == 0x02) {
> +		info->mid = id[0];
> +		info->did = id[1];
> +		info->name = "S25FL256S";
> +		info->nand_size = (1024 * 32 * 1024);
> +		info->page_size = 256;
> +		info->page_main_size = 256;
> +		info->page_spare_size = info->page_size - info->page_main_size;
> +		info->block_size = (1024 * 64);
> +		info->page_num_per_block = info->block_size / info->page_size;
> +		info->block_main_size = info->page_main_size *
> +						info->page_num_per_block;
> +		info->usable_size = (1024 * 30 * 1024);
> +		info->block_num_per_chip = info->nand_size / info->block_size;
> +		info->block_shift = 16;
> +		info->block_mask = info->block_size - 1;
> +		info->page_shift = 8;
> +		info->page_mask = info->page_size - 1;
> +		info->ecclayout =&spinand_oob_0;
> +	}
> +	return 0;
> +}
> +
> +static int spinand_probe(struct spi_device *spi)
> +{
> +	ssize_t retval;
> +	struct mtd_info *mtd;
> +	struct spinand_chip *chip;
> +	struct spinand_info *info;
> +	struct mtd_part_parser_data     ppdata;
> +	struct device_node __maybe_unused *np = spi->dev.of_node;
> +
> +	u8 id[2] = {0};
> +
> +	retval = spinand_read_id(spi, (u8 *)&id);
> +	if (id[0] == 0&&  id[1] == 0) {
> +		pr_err(KERN_ERR "SPINAND: read id error! 0x%02x, 0x%02x!\n",
> +			id[0], id[1]);
> +		return 0;
> +	}
> +
> +	info  = kzalloc(sizeof(struct spinand_info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	if (np&&  of_property_read_bool(np, "s25fl,fast-read"))
> +		fast_read = true;
> +	if (np&&  of_property_read_bool(np, "s25fl,three-byte"))
> +		addr_width = 3;
> +	else
> +		addr_width = 4;
> +
> +	ppdata.of_node = spi->dev.of_node;
> +
> +	retval = spinand_get_info(spi, info, (u8 *)&id);
> +
> +	chip  = kzalloc(sizeof(struct spinand_chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	chip->spi_nand = spi;
> +	chip->info = info;
> +	chip->read_id = spinand_read_id;
> +	chip->read_page = spinand_read_page;
> +	chip->program_page = spinand_program_page;
> +	chip->erase_block = spinand_erase_block;
> +	chip->buf = kzalloc(info->page_size, GFP_KERNEL);
> +	if (!chip->buf)
> +		return -ENOMEM;
> +
> +	chip->oobbuf = kzalloc(info->ecclayout->oobavail, GFP_KERNEL);
> +	if (!chip->oobbuf)
> +		return -ENOMEM;
> +
> +	mtd = kzalloc(sizeof(struct mtd_info), GFP_KERNEL);
> +	if (!mtd)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(&spi->dev, mtd);
> +
> +	mtd->priv = chip;
> +
> +	retval = spinand_mtd(mtd);
> +
> +	return mtd_device_parse_register(mtd, NULL,&ppdata,
> +			NULL, 1);
> +}
> +
> +/*
> + *spinand_remove--Remove the device driver
> + * @spi: the spi device.
> +*/
> +static int spinand_remove(struct spi_device *spi)
> +{
> +	struct mtd_info *mtd;
> +	struct spinand_chip *chip;
> +
> +	mtd = dev_get_drvdata(&spi->dev);
> +
> +	mtd_device_unregister(mtd);
> +
> +	chip = mtd->priv;
> +
> +	kfree(chip->info);
> +	kfree(chip->buf);
> +	kfree(chip->oobbuf);
> +	kfree(chip);
> +	kfree(mtd);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id s25fl256s_dt_ids[] = {
> +	{ .compatible = "ti, s25fl256s"},
> +	{ /* sentinel */ },
> +};
> +
> +static struct spi_driver spinand_driver = {
> +	.driver = {
> +		.name	= "s25fl256s",
> +		.bus            =&spi_bus_type,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = s25fl256s_dt_ids,
> +	},
> +	.probe	= spinand_probe,
> +	.remove	= spinand_remove,
> +};
> +module_spi_driver(spinand_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Sourav Poddar");
> +MODULE_DESCRIPTION("MTD SPI driver for spansion flash chips");

