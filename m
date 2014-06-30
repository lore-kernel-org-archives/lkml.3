Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaF3JrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:47:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55156 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaF3JrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:47:14 -0400
Message-ID: <53B131AF.2040501@ti.com>
Date: Mon, 30 Jun 2014 12:45:19 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhou Wang <wangzhou.bry@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Pekon Gupta <pekon@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Joern Engel <joern@logfs.org>, Randy Dunlap <rdunlap@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <wangzhou1@hisilicon.com>, <caizhiyong@huawei.com>
Subject: Re: [PATCH 2/3] mtd: hisilicon: add a new nand controller driver
 for hisilicon hip04 Soc
References: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com> <1404115409-20200-3-git-send-email-wangzhou.bry@gmail.com>
In-Reply-To: <1404115409-20200-3-git-send-email-wangzhou.bry@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/30/2014 11:03 AM, Zhou Wang wrote:
> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
> ---
>   drivers/mtd/nand/Kconfig     |    5 +
>   drivers/mtd/nand/Makefile    |    1 +
>   drivers/mtd/nand/hisi_nand.c |  847 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 853 insertions(+)
>   create mode 100644 drivers/mtd/nand/hisi_nand.c
>
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 90ff447..253f8c8 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -510,4 +510,9 @@ config MTD_NAND_XWAY
>   	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
>   	  to the External Bus Unit (EBU).
>   
> +config MTD_NAND_HISI
> +	tristate "Support for NAND controller on Hisilicon SoC"
> +	help
> +	  Enables support for NAND controller on Hisilicon SoC.
> +
>   endif # MTD_NAND
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index 542b568..d0881cf 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -49,5 +49,6 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
>   obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
>   obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
>   obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
> +obj-$(CONFIG_MTD_NAND_HISI)	        += hisi_nand.o
>   
>   nand-objs := nand_base.o nand_bbt.o
> diff --git a/drivers/mtd/nand/hisi_nand.c b/drivers/mtd/nand/hisi_nand.c
> new file mode 100644
> index 0000000..fbcb065
> --- /dev/null
> +++ b/drivers/mtd/nand/hisi_nand.c
> @@ -0,0 +1,847 @@
> +/*
> + * Hisilicon NAND Flash controller driver
> + *
> + * Copyright © 2012-2014 HiSilicon Technologies Co., Ltd.
> + *              http://www.hisilicon.com
> + *
> + * Author: Zhou Wang <wangzhou.bry@gmail.com>
> + * The initial developer of the original code is Zhiyong Cai
> + * <caizhiyong@huawei.com>
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
> +#include <linux/of.h>
> +#include <linux/of_mtd.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/sizes.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <linux/mtd/partitions.h>
> +
> +#define HINFC504_MAX_CHIP                               (4)
> +#define HINFC504_W_LATCH                                (5)
> +#define HINFC504_R_LATCH                                (7)
> +#define HINFC504_RW_LATCH                               (3)
> +
> +#define HINFC504_NFC_TIMEOUT				(2 * HZ)
> +#define HINFC504_NFC_DMA_TIMEOUT			(5 * HZ)
> +#define HINFC504_CHIP_DELAY				(25)
> +
> +#define HINFC504_REG_BASE_ADDRESS_LEN			(0x100)
> +#define HINFC504_BUFFER_BASE_ADDRESS_LEN		(2048 + 128)
> +
> +#define HINFC504_ADDR_CYCLE_MASK			0x4
> +
> +#define HINFC504_CON					0x00
> +#define HINFC504_CON_OP_MODE_NORMAL			(1U << 0)
> +#define HINFC504_CON_PAGEISZE_SHIFT			(1)
> +#define HINFC504_CON_PAGESIZE_MASK			(0x07)
> +#define HINFC504_CON_BUS_WIDTH				(1U << 4)
> +#define HINFC504_CON_READY_BUSY_SEL			(1U << 8)
> +#define HINFC504_CON_ECCTYPE_SHIFT			(9)
> +#define HINFC504_CON_ECCTYPE_MASK			(0x07)
> +
> +#define HINFC504_PWIDTH					0x04
> +#define SET_HINFC504_PWIDTH(_w_lcnt, _r_lcnt, _rw_hcnt) \
> +	((_w_lcnt) | (((_r_lcnt) & 0x0F) << 4) | (((_rw_hcnt) & 0x0F) << 8))
> +
> +#define HINFC504_CMD					0x0C
> +#define HINFC504_ADDRL					0x10
> +#define HINFC504_ADDRH					0x14
> +#define HINFC504_DATA_NUM				0x18
> +
> +#define HINFC504_OP					0x1C
> +#define HINFC504_OP_READ_DATA_EN			(1U << 1)
> +#define HINFC504_OP_WAIT_READY_EN			(1U << 2)
> +#define HINFC504_OP_CMD2_EN				(1U << 3)
> +#define HINFC504_OP_WRITE_DATA_EN			(1U << 4)
> +#define HINFC504_OP_ADDR_EN				(1U << 5)
> +#define HINFC504_OP_CMD1_EN				(1U << 6)
> +#define HINFC504_OP_NF_CS_SHIFT				(7)
> +#define HINFC504_OP_NF_CS_MASK				(3)
> +#define HINFC504_OP_ADDR_CYCLE_SHIFT			(9)
> +#define HINFC504_OP_ADDR_CYCLE_MASK			(7)
> +
> +#define HINFC504_STATUS					0x20
> +#define HINFC504_READY					(1U << 0)
> +
> +#define HINFC504_INTEN					0x24
> +#define HINFC504_INTEN_DMA				(1U << 9)
> +#define HINFC504_INTEN_UE				(1U << 6)
> +#define HINFC504_INTEN_CE				(1U << 5)
> +
> +#define HINFC504_INTS					0x28
> +#define HINFC504_INTS_DMA				(1U << 9)
> +#define HINFC504_INTS_UE				(1U << 6)
> +#define HINFC504_INTS_CE				(1U << 5)
> +
> +#define HINFC504_INTCLR					0x2C
> +#define HINFC504_INTCLR_DMA				(1U << 9)
> +#define HINFC504_INTCLR_UE				(1U << 6)
> +#define HINFC504_INTCLR_CE				(1U << 5)
> +
> +#define HINFC504_ECC_STATUS                             0x5C
> +#define HINFC504_ECC_1_BIT_SHIFT                        16
> +#define HINFC504_ECC_16_BIT_SHIFT                       12
> +
> +#define HINFC504_DMA_CTRL				0x60
> +#define HINFC504_DMA_CTRL_DMA_START			(1U << 0)
> +#define HINFC504_DMA_CTRL_WE				(1U << 1)
> +#define HINFC504_DMA_CTRL_DATA_AREA_EN			(1U << 2)
> +#define HINFC504_DMA_CTRL_OOB_AREA_EN			(1U << 3)
> +#define HINFC504_DMA_CTRL_BURST4_EN			(1U << 4)
> +#define HINFC504_DMA_CTRL_BURST8_EN			(1U << 5)
> +#define HINFC504_DMA_CTRL_BURST16_EN			(1U << 6)
> +#define HINFC504_DMA_CTRL_ADDR_NUM_SHIFT		(7)
> +#define HINFC504_DMA_CTRL_ADDR_NUM_MASK			(1)
> +#define HINFC504_DMA_CTRL_CS_SHIFT			(8)
> +#define HINFC504_DMA_CTRL_CS_MASK			(0x03)
> +
> +#define HINFC504_DMA_ADDR_DATA				0x64
> +#define HINFC504_DMA_ADDR_OOB				0x68
> +
> +#define HINFC504_DMA_LEN				0x6C
> +#define HINFC504_DMA_LEN_OOB_SHIFT			(16)
> +#define HINFC504_DMA_LEN_OOB_MASK			(0xFFF)
> +
> +#define HINFC504_DMA_PARA				0x70
> +#define HINFC504_DMA_PARA_DATA_RW_EN			(1U << 0)
> +#define HINFC504_DMA_PARA_OOB_RW_EN			(1U << 1)
> +#define HINFC504_DMA_PARA_DATA_EDC_EN			(1U << 2)
> +#define HINFC504_DMA_PARA_OOB_EDC_EN			(1U << 3)
> +#define HINFC504_DMA_PARA_DATA_ECC_EN			(1U << 4)
> +#define HINFC504_DMA_PARA_OOB_ECC_EN			(1U << 5)
> +
> +#define HINFC_VERSION                                   0x74
> +#define HINFC504_LOG_READ_ADDR				0x7C
> +#define HINFC504_LOG_READ_LEN				0x80
> +
> +#define HINFC504_NANDINFO_LEN				0x10
> +
> +#define hinfc_read(_host, _reg)	readl(_host->iobase + (_reg))
> +#define hinfc_write(_host, _value, _reg)\
> +	writel((_value), _host->iobase + (_reg))
> +
> +struct hinfc_host {
> +	struct nand_chip	*chip;
> +	struct mtd_info		*mtd;
> +	struct device		*dev;
> +	void __iomem		*iobase;
> +	struct completion       cmd_complete;
> +	unsigned int		offset;
> +	unsigned int		command;
> +	int			chipselect;
> +	unsigned int		addr_cycle;
> +	unsigned int		addr_value[2];
> +	unsigned int		cache_addr_value[2];
> +	char			*buffer;
> +	dma_addr_t		dma_buffer;
> +	dma_addr_t		dma_oob;
> +	int			version;
> +	unsigned int            ecc_bits;
> +	unsigned int            irq_status; /* interrupt status */
> +
> +	int (*send_cmd_pageprog)(struct hinfc_host *host);
> +	int (*send_cmd_status)(struct hinfc_host *host);
> +	int (*send_cmd_readstart)(struct hinfc_host *host);
> +	int (*send_cmd_erase)(struct hinfc_host *host);
> +	int (*send_cmd_readid)(struct hinfc_host *host);
> +	int (*send_cmd_reset)(struct hinfc_host *host, int chipselect);
> +};
> +
> +void wait_controller_finished(struct hinfc_host *host)
> +{
> +	unsigned long timeout = jiffies + HINFC504_NFC_TIMEOUT;
> +	int val;
> +
> +	while (time_before(jiffies, timeout)) {
> +		val = hinfc_read(host, HINFC504_STATUS);
> +		if (host->command == NAND_CMD_ERASE2) {
> +			/* nfc is ready */
> +			while (!(val & HINFC504_READY))	{
> +				usleep_range(500, 1000);
> +				val = hinfc_read(host, HINFC504_STATUS);
> +			}
> +			return;
> +		} else {
> +			if (val & HINFC504_READY)
> +				return;
> +		}
> +	}
> +
> +	/* wait cmd timeout */
> +	dev_err(host->dev, "Wait NAND controller exec cmd timeout.\n");
> +}
> +
> +static void hisi_nfc_dma_transfer(struct hinfc_host *host, int todev)
> +{
> +	struct mtd_info	*mtd = host->mtd;
> +	struct nand_chip *chip = mtd->priv;
> +	unsigned long val;
> +	int ret;
> +
> +	hinfc_write(host, host->dma_buffer, HINFC504_DMA_ADDR_DATA);
> +	hinfc_write(host, host->dma_oob, HINFC504_DMA_ADDR_OOB);
> +
> +	if (chip->ecc.mode == NAND_ECC_NONE) {
> +		hinfc_write(host, ((mtd->oobsize & HINFC504_DMA_LEN_OOB_MASK)
> +			<< HINFC504_DMA_LEN_OOB_SHIFT), HINFC504_DMA_LEN);
> +
> +		hinfc_write(host, HINFC504_DMA_PARA_DATA_RW_EN
> +			| HINFC504_DMA_PARA_OOB_RW_EN, HINFC504_DMA_PARA);
> +	} else

Add {} for else also
./scripts/checkpatch.pl.

-- 
Regards,
Ivan Khoronzhuk

