Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaLANIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:08:30 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42625 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaLANI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:08:27 -0500
Message-ID: <547C685A.3090804@gmail.com>
Date: Mon, 01 Dec 2014 21:08:42 +0800
From: Zhou Wang <wangzhou.bry@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mtd: hisilicon: add a new NAND controller driver
 for hisilicon hip04 Soc
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com> <1415105221-7732-2-git-send-email-wangzhou.bry@gmail.com> <20141130093529.GH3608@norris-Latitude-E6410>
In-Reply-To: <20141130093529.GH3608@norris-Latitude-E6410>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月30日 17:35, Brian Norris wrote:
> On Tue, Nov 04, 2014 at 08:47:00PM +0800, Zhou Wang wrote:
>> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
>
> This driver mostly looks good. A few comments.
>
>> ---
>>   drivers/mtd/nand/Kconfig        |    5 +
>>   drivers/mtd/nand/Makefile       |    1 +
>>   drivers/mtd/nand/hisi504_nand.c |  846 +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 852 insertions(+)
>>   create mode 100644 drivers/mtd/nand/hisi504_nand.c
>>
>> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
>> index dd10646..e451a08 100644
>> --- a/drivers/mtd/nand/Kconfig
>> +++ b/drivers/mtd/nand/Kconfig
>> @@ -516,4 +516,9 @@ config MTD_NAND_XWAY
>>   	  Enables support for NAND Flash chips on Lantiq XWAY SoCs. NAND is attached
>>   	  to the External Bus Unit (EBU).
>>
>> +config MTD_NAND_HISI504
>> +	tristate "Support for NAND controller on Hisilicon SoC Hip04"
>> +	help
>> +	  Enables support for NAND controller on Hisilicon SoC Hip04.
>> +
>>   endif # MTD_NAND
>
> You'll want to rebase on l2-mtd.git when you resend. There are some
> small Kconfig and Makefile conflicts. (I can fix them myself, but if
> you're going to resend anyway...)
>

Hi Brian,

I will rebase the patchset on l2-mtd.git when resend.

>> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
>> index 9c847e4..fb1b2e4 100644
>> --- a/drivers/mtd/nand/Makefile
>> +++ b/drivers/mtd/nand/Makefile
>> @@ -50,5 +50,6 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
>>   obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
>>   obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
>>   obj-$(CONFIG_MTD_NAND_BCM47XXNFLASH)	+= bcm47xxnflash/
>> +obj-$(CONFIG_MTD_NAND_HISI504)	        += hisi504_nand.o
>>
>>   nand-objs := nand_base.o nand_bbt.o nand_timings.o
>> diff --git a/drivers/mtd/nand/hisi504_nand.c b/drivers/mtd/nand/hisi504_nand.c
>> new file mode 100644
>> index 0000000..a169cd8
>> --- /dev/null
>> +++ b/drivers/mtd/nand/hisi504_nand.c
>> @@ -0,0 +1,846 @@
>> +/*
>> + * Hisilicon NAND Flash controller driver
>> + *
>> + * Copyright © 2012-2014 HiSilicon Technologies Co., Ltd.
>> + *              http://www.hisilicon.com
>> + *
>> + * Author: Zhou Wang <wangzhou.bry@gmail.com>
>> + * The initial developer of the original code is Zhiyong Cai
>> + * <caizhiyong@huawei.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <linux/of.h>
>> +#include <linux/of_mtd.h>
>> +#include <linux/mtd/mtd.h>
>> +#include <linux/sizes.h>
>> +#include <linux/clk.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/mtd/nand.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mtd/partitions.h>
>> +
>> +#define HINFC504_MAX_CHIP                               (4)
>> +#define HINFC504_W_LATCH                                (5)
>> +#define HINFC504_R_LATCH                                (7)
>> +#define HINFC504_RW_LATCH                               (3)
>> +
>> +#define HINFC504_NFC_TIMEOUT				(2 * HZ)
>> +#define HINFC504_NFC_DMA_TIMEOUT			(5 * HZ)
>> +#define HINFC504_CHIP_DELAY				(25)
>> +
>> +#define HINFC504_REG_BASE_ADDRESS_LEN			(0x100)
>> +#define HINFC504_BUFFER_BASE_ADDRESS_LEN		(2048 + 128)
>> +
>> +#define HINFC504_ADDR_CYCLE_MASK			0x4
>> +
>> +#define HINFC504_CON					0x00
>> +#define HINFC504_CON_OP_MODE_NORMAL			(1U << 0)
>> +#define HINFC504_CON_PAGEISZE_SHIFT			(1)
>> +#define HINFC504_CON_PAGESIZE_MASK			(0x07)
>> +#define HINFC504_CON_BUS_WIDTH				(1U << 4)
>> +#define HINFC504_CON_READY_BUSY_SEL			(1U << 8)
>> +#define HINFC504_CON_ECCTYPE_SHIFT			(9)
>> +#define HINFC504_CON_ECCTYPE_MASK			(0x07)
>> +
>> +#define HINFC504_PWIDTH					0x04
>> +#define SET_HINFC504_PWIDTH(_w_lcnt, _r_lcnt, _rw_hcnt) \
>> +	((_w_lcnt) | (((_r_lcnt) & 0x0F) << 4) | (((_rw_hcnt) & 0x0F) << 8))
>> +
>> +#define HINFC504_CMD					0x0C
>> +#define HINFC504_ADDRL					0x10
>> +#define HINFC504_ADDRH					0x14
>> +#define HINFC504_DATA_NUM				0x18
>> +
>> +#define HINFC504_OP					0x1C
>> +#define HINFC504_OP_READ_DATA_EN			(1U << 1)
>> +#define HINFC504_OP_WAIT_READY_EN			(1U << 2)
>> +#define HINFC504_OP_CMD2_EN				(1U << 3)
>> +#define HINFC504_OP_WRITE_DATA_EN			(1U << 4)
>> +#define HINFC504_OP_ADDR_EN				(1U << 5)
>> +#define HINFC504_OP_CMD1_EN				(1U << 6)
>
> Might try the BIT() macros here.

will modify this and use BIT(), thanks.

>
>> +#define HINFC504_OP_NF_CS_SHIFT				(7)
>> +#define HINFC504_OP_NF_CS_MASK				(3)
>> +#define HINFC504_OP_ADDR_CYCLE_SHIFT			(9)
>> +#define HINFC504_OP_ADDR_CYCLE_MASK			(7)
>> +
>> +#define HINFC504_STATUS					0x20
>> +#define HINFC504_READY					(1U << 0)
>> +
>> +#define HINFC504_INTEN					0x24
>> +#define HINFC504_INTEN_DMA				(1U << 9)
>> +#define HINFC504_INTEN_UE				(1U << 6)
>> +#define HINFC504_INTEN_CE				(1U << 5)
>
> Same here, and in the next few blocks.
>
>> +
>> +#define HINFC504_INTS					0x28
>> +#define HINFC504_INTS_DMA				(1U << 9)
>> +#define HINFC504_INTS_UE				(1U << 6)
>> +#define HINFC504_INTS_CE				(1U << 5)
>> +
>> +#define HINFC504_INTCLR					0x2C
>> +#define HINFC504_INTCLR_DMA				(1U << 9)
>> +#define HINFC504_INTCLR_UE				(1U << 6)
>> +#define HINFC504_INTCLR_CE				(1U << 5)
>> +
>> +#define HINFC504_ECC_STATUS                             0x5C
>> +#define HINFC504_ECC_1_BIT_SHIFT                        16
>> +#define HINFC504_ECC_16_BIT_SHIFT                       12
>> +
>> +#define HINFC504_DMA_CTRL				0x60
>> +#define HINFC504_DMA_CTRL_DMA_START			(1U << 0)
>> +#define HINFC504_DMA_CTRL_WE				(1U << 1)
>> +#define HINFC504_DMA_CTRL_DATA_AREA_EN			(1U << 2)
>> +#define HINFC504_DMA_CTRL_OOB_AREA_EN			(1U << 3)
>> +#define HINFC504_DMA_CTRL_BURST4_EN			(1U << 4)
>> +#define HINFC504_DMA_CTRL_BURST8_EN			(1U << 5)
>> +#define HINFC504_DMA_CTRL_BURST16_EN			(1U << 6)
>> +#define HINFC504_DMA_CTRL_ADDR_NUM_SHIFT		(7)
>> +#define HINFC504_DMA_CTRL_ADDR_NUM_MASK			(1)
>> +#define HINFC504_DMA_CTRL_CS_SHIFT			(8)
>> +#define HINFC504_DMA_CTRL_CS_MASK			(0x03)
>> +
>> +#define HINFC504_DMA_ADDR_DATA				0x64
>> +#define HINFC504_DMA_ADDR_OOB				0x68
>> +
>> +#define HINFC504_DMA_LEN				0x6C
>> +#define HINFC504_DMA_LEN_OOB_SHIFT			(16)
>> +#define HINFC504_DMA_LEN_OOB_MASK			(0xFFF)
>> +
>> +#define HINFC504_DMA_PARA				0x70
>> +#define HINFC504_DMA_PARA_DATA_RW_EN			(1U << 0)
>> +#define HINFC504_DMA_PARA_OOB_RW_EN			(1U << 1)
>> +#define HINFC504_DMA_PARA_DATA_EDC_EN			(1U << 2)
>> +#define HINFC504_DMA_PARA_OOB_EDC_EN			(1U << 3)
>> +#define HINFC504_DMA_PARA_DATA_ECC_EN			(1U << 4)
>> +#define HINFC504_DMA_PARA_OOB_ECC_EN			(1U << 5)
>> +
>> +#define HINFC_VERSION                                   0x74
>> +#define HINFC504_LOG_READ_ADDR				0x7C
>> +#define HINFC504_LOG_READ_LEN				0x80
>> +
>> +#define HINFC504_NANDINFO_LEN				0x10
>> +
>> +struct hinfc_host {
>> +	struct nand_chip	chip;
>> +	struct mtd_info		mtd;
>> +	struct device		*dev;
>> +	void __iomem		*iobase;
>> +	struct completion       cmd_complete;
>> +	unsigned int		offset;
>> +	unsigned int		command;
>> +	int			chipselect;
>> +	unsigned int		addr_cycle;
>> +	unsigned int		addr_value[2];
>
> It looks like you're using addr_value as 32-bit copies of the HW
> register. Might make sense to declare them as u32, since you care about
> the width.
>

Right, thanks.

>> +	unsigned int		cache_addr_value[2];
>> +	char			*buffer;
>> +	dma_addr_t		dma_buffer;
>> +	dma_addr_t		dma_oob;
>> +	int			version;
>> +	unsigned int            ecc_bits;
>> +	unsigned int            irq_status; /* interrupt status */
>> +};
>> +
>> +static inline unsigned int hinfc_read(struct hinfc_host *host, unsigned int reg)
>> +{
>> +	return readl(host->iobase + reg);
>> +}
>> +
>> +static inline void hinfc_write(struct hinfc_host *host, unsigned int value,
>> +			       unsigned int reg)
>> +{
>> +	writel(value, host->iobase + reg);
>> +}
>> +
>> +static void wait_controller_finished(struct hinfc_host *host)
>> +{
>> +	unsigned long timeout = jiffies + HINFC504_NFC_TIMEOUT;
>> +	int val;
>> +
>> +	while (time_before(jiffies, timeout)) {
>> +		val = hinfc_read(host, HINFC504_STATUS);
>> +		if (host->command == NAND_CMD_ERASE2) {
>> +			/* nfc is ready */
>> +			while (!(val & HINFC504_READY))	{
>> +				usleep_range(500, 1000);
>> +				val = hinfc_read(host, HINFC504_STATUS);
>> +			}
>> +			return;
>> +		}
>> +
>> +		if (val & HINFC504_READY)
>> +			return;
>> +	}
>> +
>> +	/* wait cmd timeout */
>> +	dev_err(host->dev, "Wait NAND controller exec cmd timeout.\n");
>> +}
>> +
>> +static void hisi_nfc_dma_transfer(struct hinfc_host *host, int todev)
>> +{
>> +	struct mtd_info	*mtd = &host->mtd;
>> +	struct nand_chip *chip = mtd->priv;
>> +	unsigned long val;
>> +	int ret;
>> +
>> +	hinfc_write(host, host->dma_buffer, HINFC504_DMA_ADDR_DATA);
>> +	hinfc_write(host, host->dma_oob, HINFC504_DMA_ADDR_OOB);
>> +
>> +	if (chip->ecc.mode == NAND_ECC_NONE) {
>> +		hinfc_write(host, ((mtd->oobsize & HINFC504_DMA_LEN_OOB_MASK)
>> +			<< HINFC504_DMA_LEN_OOB_SHIFT), HINFC504_DMA_LEN);
>> +
>> +		hinfc_write(host, HINFC504_DMA_PARA_DATA_RW_EN
>> +			| HINFC504_DMA_PARA_OOB_RW_EN, HINFC504_DMA_PARA);
>> +	} else {
>> +		hinfc_write(host, HINFC504_DMA_PARA_DATA_RW_EN
>> +		| HINFC504_DMA_PARA_OOB_RW_EN | HINFC504_DMA_PARA_DATA_EDC_EN
>> +		| HINFC504_DMA_PARA_OOB_EDC_EN | HINFC504_DMA_PARA_DATA_ECC_EN
>> +		| HINFC504_DMA_PARA_OOB_ECC_EN, HINFC504_DMA_PARA);
>> +	}
>> +
>> +	val = (HINFC504_DMA_CTRL_DMA_START | HINFC504_DMA_CTRL_BURST4_EN
>> +		| HINFC504_DMA_CTRL_BURST8_EN | HINFC504_DMA_CTRL_BURST16_EN
>> +		| HINFC504_DMA_CTRL_DATA_AREA_EN | HINFC504_DMA_CTRL_OOB_AREA_EN
>> +		| ((host->addr_cycle == 4 ? 1 : 0)
>> +			<< HINFC504_DMA_CTRL_ADDR_NUM_SHIFT)
>> +		| ((host->chipselect & HINFC504_DMA_CTRL_CS_MASK)
>> +			<< HINFC504_DMA_CTRL_CS_SHIFT));
>> +
>> +	if (todev)
>> +		val |= HINFC504_DMA_CTRL_WE;
>> +
>> +	hinfc_write(host, val, HINFC504_DMA_CTRL);
>> +
>> +	init_completion(&host->cmd_complete);
>
> You need to run init_completion() *before* you kick off your I/O.
> Otherwise, your interrupt handler is racing with this function.
>

Do you mean that it needs put init_completion() before hinfc_write()?
If not so, interrupt handler maybe execute before init_completion()
which will cause something wrong.

>> +	ret = wait_for_completion_timeout(&host->cmd_complete,
>> +			HINFC504_NFC_DMA_TIMEOUT);
>> +
>> +	if (!ret) {
>> +		dev_err(host->dev, "DMA operation(irq) timeout!\n");
>> +		/* sanity check */
>> +		val = hinfc_read(host, HINFC504_DMA_CTRL);
>> +		if (!(val & HINFC504_DMA_CTRL_DMA_START))
>> +			dev_err(host->dev, "dma is already done but without irq ACK!");
>
> You're missing a newline at the end of this message. Please check your
> other prints too.
>
> Also, s/dma/DMA/

will modify this, thanks!

>
>> +		else
>> +			dev_err(host->dev, "dma is really timeout!");
>> +	}
>> +}
>> +
>> +static int hisi_nfc_send_cmd_pageprog(struct hinfc_host *host)
>> +{
>> +	host->addr_value[0] &= 0xffff0000;
>> +
>> +	hinfc_write(host, host->addr_value[0], HINFC504_ADDRL);
>> +	hinfc_write(host, host->addr_value[1], HINFC504_ADDRH);
>> +	hinfc_write(host, NAND_CMD_PAGEPROG << 8 | NAND_CMD_SEQIN,
>> +		    HINFC504_CMD);
>> +
>> +	hisi_nfc_dma_transfer(host, 1);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_send_cmd_readstart(struct hinfc_host *host)
>> +{
>> +	struct mtd_info	*mtd = &host->mtd;
>> +
>> +	if ((host->addr_value[0] == host->cache_addr_value[0]) &&
>> +	    (host->addr_value[1] == host->cache_addr_value[1]))
>> +		return 0;
>> +
>> +	host->addr_value[0] &= 0xffff0000;
>> +
>> +	hinfc_write(host, host->addr_value[0], HINFC504_ADDRL);
>> +	hinfc_write(host, host->addr_value[1], HINFC504_ADDRH);
>> +	hinfc_write(host, NAND_CMD_READSTART << 8 | NAND_CMD_READ0,
>> +		    HINFC504_CMD);
>> +
>> +	hinfc_write(host, 0, HINFC504_LOG_READ_ADDR);
>> +	hinfc_write(host, mtd->writesize + mtd->oobsize,
>> +		    HINFC504_LOG_READ_LEN);
>> +
>> +	hisi_nfc_dma_transfer(host, 0);
>> +
>> +	host->cache_addr_value[0] = host->addr_value[0];
>> +	host->cache_addr_value[1] = host->addr_value[1];
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_send_cmd_erase(struct hinfc_host *host)
>> +{
>> +	hinfc_write(host, host->addr_value[0], HINFC504_ADDRL);
>> +	hinfc_write(host, (NAND_CMD_ERASE2 << 8) | NAND_CMD_ERASE1,
>> +		    HINFC504_CMD);
>> +
>> +	hinfc_write(host, HINFC504_OP_WAIT_READY_EN
>> +		| HINFC504_OP_CMD2_EN
>> +		| HINFC504_OP_CMD1_EN
>> +		| HINFC504_OP_ADDR_EN
>> +		| ((host->chipselect & HINFC504_OP_NF_CS_MASK)
>> +			<< HINFC504_OP_NF_CS_SHIFT)
>> +		| ((host->addr_cycle & HINFC504_OP_ADDR_CYCLE_MASK)
>> +			<< HINFC504_OP_ADDR_CYCLE_SHIFT),
>> +		HINFC504_OP);
>> +
>> +	wait_controller_finished(host);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_send_cmd_readid(struct hinfc_host *host)
>> +{
>> +	hinfc_write(host, HINFC504_NANDINFO_LEN, HINFC504_DATA_NUM);
>> +	hinfc_write(host, NAND_CMD_READID, HINFC504_CMD);
>> +	hinfc_write(host, 0, HINFC504_ADDRL);
>> +
>> +	hinfc_write(host, HINFC504_OP_CMD1_EN | HINFC504_OP_ADDR_EN
>> +		| HINFC504_OP_READ_DATA_EN
>> +		| ((host->chipselect & HINFC504_OP_NF_CS_MASK)
>> +			<< HINFC504_OP_NF_CS_SHIFT)
>> +		| 1 << HINFC504_OP_ADDR_CYCLE_SHIFT, HINFC504_OP);
>> +
>> +	wait_controller_finished(host);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_send_cmd_status(struct hinfc_host *host)
>> +{
>> +	hinfc_write(host, HINFC504_NANDINFO_LEN, HINFC504_DATA_NUM);
>> +	hinfc_write(host, NAND_CMD_STATUS, HINFC504_CMD);
>> +	hinfc_write(host, HINFC504_OP_CMD1_EN
>> +		| HINFC504_OP_READ_DATA_EN
>> +		| ((host->chipselect & HINFC504_OP_NF_CS_MASK)
>> +			<< HINFC504_OP_NF_CS_SHIFT),
>> +		HINFC504_OP);
>> +
>> +	wait_controller_finished(host);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_send_cmd_reset(struct hinfc_host *host, int chipselect)
>> +{
>> +	hinfc_write(host, NAND_CMD_RESET, HINFC504_CMD);
>> +
>> +	hinfc_write(host, HINFC504_OP_CMD1_EN
>> +		| ((chipselect & HINFC504_OP_NF_CS_MASK)
>> +			<< HINFC504_OP_NF_CS_SHIFT)
>> +		| HINFC504_OP_WAIT_READY_EN,
>> +		HINFC504_OP);
>> +
>> +	wait_controller_finished(host);
>> +
>> +	return 0;
>> +}
>> +
>> +static void hisi_nfc_select_chip(struct mtd_info *mtd, int chipselect)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +
>> +	if (chipselect < 0)
>> +		return;
>> +
>> +	host->chipselect = chipselect;
>> +}
>> +
>> +static uint8_t hisi_nfc_read_byte(struct mtd_info *mtd)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +
>> +	if (host->command == NAND_CMD_STATUS)
>> +		return readb(chip->IO_ADDR_R);
>> +
>> +	host->offset++;
>> +
>> +	if (host->command == NAND_CMD_READID)
>> +		return readb(chip->IO_ADDR_R + host->offset - 1);
>> +
>> +	return readb(host->buffer + host->offset - 1);
>> +}
>> +
>> +static u16 hisi_nfc_read_word(struct mtd_info *mtd)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +
>> +	host->offset += 2;
>> +	return readw(host->buffer + host->offset - 2);
>> +}
>> +
>> +static void
>> +hisi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +
>> +	memcpy(host->buffer + host->offset, buf, len);
>> +	host->offset += len;
>> +}
>> +
>> +static void hisi_nfc_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +
>> +	memcpy(buf, host->buffer + host->offset, len);
>> +	host->offset += len;
>> +}
>> +
>> +static void set_addr(struct mtd_info *mtd, int column, int page_addr)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +
>> +	host->addr_cycle    = 0;
>> +	host->addr_value[0] = 0;
>> +	host->addr_value[1] = 0;
>> +
>> +	/* Serially input address */
>> +	if (column != -1) {
>> +		/* Adjust columns for 16 bit buswidth */
>> +		if (chip->options & NAND_BUSWIDTH_16)
>> +			column >>= 1;
>
> It doesn't look like you're supporting ONFI parameter pages yet, but you
> might consider checking for !nand_opcode_8bits(opcode) before adjusting the
> address. We had to fix some other drivers for this recently.
>

sorry, could you give me more clue about this?  Do you mean that we
should first make sure it is not 8 bits bus width?

>> +
>> +		host->addr_value[0] = column & 0xffff;
>> +		host->addr_cycle    = 2;
>> +	}
>> +	if (page_addr != -1) {
>> +		host->addr_value[0] |= (page_addr & 0xffff)
>> +			<< (host->addr_cycle * 8);
>> +		host->addr_cycle    += 2;
>> +		/* One more address cycle for devices > 128MiB */
>> +		if (chip->chipsize > (128 << 20)) {
>> +			host->addr_cycle += 1;
>> +			if (host->command == NAND_CMD_ERASE1)
>> +				host->addr_value[0] |= ((page_addr >> 16) & 0xff) << 16;
>> +			else
>> +				host->addr_value[1] |= ((page_addr >> 16) & 0xff);
>> +		}
>> +	}
>> +}
>> +
>> +static void hisi_nfc_cmdfunc(struct mtd_info *mtd, unsigned command, int column,
>> +		int page_addr)
>> +{
>> +	struct nand_chip *chip = mtd->priv;
>> +	struct hinfc_host *host = chip->priv;
>> +	int is_cache_invalid = 1;
>> +	unsigned int flag = 0;
>> +
>> +	host->command =  command;
>> +
>> +	switch (command) {
>> +	case NAND_CMD_READ0:
>> +	case NAND_CMD_READOOB:
>> +		if (command == NAND_CMD_READ0)
>> +			host->offset = column;
>> +		else
>> +			host->offset = column + mtd->writesize;
>> +
>> +		is_cache_invalid = 0;
>> +		set_addr(mtd, column, page_addr);
>> +		hisi_nfc_send_cmd_readstart(host);
>> +		break;
>> +
>> +	case NAND_CMD_SEQIN:
>> +		host->offset = column;
>> +		set_addr(mtd, column, page_addr);
>> +		break;
>> +
>> +	case NAND_CMD_ERASE1:
>> +		set_addr(mtd, column, page_addr);
>> +		break;
>> +
>> +	case NAND_CMD_PAGEPROG:
>> +		hisi_nfc_send_cmd_pageprog(host);
>> +		break;
>> +
>> +	case NAND_CMD_ERASE2:
>> +		hisi_nfc_send_cmd_erase(host);
>> +		break;
>> +
>> +	case NAND_CMD_READID:
>> +		host->offset = column;
>> +		memset(chip->IO_ADDR_R, 0, 0x10);
>> +		hisi_nfc_send_cmd_readid(host);
>> +		break;
>> +
>> +	case NAND_CMD_STATUS:
>> +		flag = hinfc_read(host, HINFC504_CON);
>> +		if (chip->ecc.mode == NAND_ECC_HW)
>> +			hinfc_write(host,
>> +				    flag && ~(HINFC504_CON_ECCTYPE_MASK <<
>> +				    HINFC504_CON_ECCTYPE_SHIFT), HINFC504_CON);
>> +
>> +		host->offset = 0;
>> +		memset(chip->IO_ADDR_R, 0, 0x10);
>> +		hisi_nfc_send_cmd_status(host);
>> +		hinfc_write(host, flag, HINFC504_CON);
>> +		break;
>> +
>> +	case NAND_CMD_RESET:
>> +		hisi_nfc_send_cmd_reset(host, host->chipselect);
>> +		break;
>> +
>> +	default:
>> +		dev_err(host->dev, "Error: unsupported cmd(cmd=%x, col=%x, page=%x)\n",
>> +			command, column, page_addr);
>> +	}
>> +
>> +	if (is_cache_invalid) {
>> +		host->cache_addr_value[0] = ~0;
>> +		host->cache_addr_value[1] = ~0;
>> +	}
>> +}
>> +
>> +static irqreturn_t hinfc_irq_handle(int irq, void *devid)
>> +{
>> +	struct hinfc_host *host = devid;
>> +	unsigned int flag;
>> +
>> +	flag = hinfc_read(host, HINFC504_INTS);
>> +	/* store interrupts state */
>> +	host->irq_status |= flag;
>> +
>> +	if (flag & HINFC504_INTS_DMA) {
>> +		hinfc_write(host, HINFC504_INTCLR_DMA, HINFC504_INTCLR);
>> +		complete(&host->cmd_complete);
>> +	} else if (flag & HINFC504_INTS_CE) {
>> +		hinfc_write(host, HINFC504_INTCLR_CE, HINFC504_INTCLR);
>> +	} else if (flag & HINFC504_INTS_UE) {
>> +		hinfc_write(host, HINFC504_INTCLR_UE, HINFC504_INTCLR);
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int hisi_nand_read_page_hwecc(struct mtd_info *mtd,
>> +	struct nand_chip *chip, uint8_t *buf, int oob_required, int page)
>> +{
>> +	struct hinfc_host *host = chip->priv;
>> +	int max_bitflips = 0, stat = 0;
>> +
>> +	chip->read_buf(mtd, buf, mtd->writesize);
>> +	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
>> +
>> +	/* errors which can not be corrected by ECC */
>> +	if (host->irq_status & HINFC504_INTS_UE) {
>> +		mtd->ecc_stats.failed++;
>> +	} else if (host->irq_status & HINFC504_INTS_CE) {
>> +		/* need add other ECC modes! */
>> +		switch (host->ecc_bits) {
>> +		case 1:
>> +			stat = hweight8(hinfc_read(host, HINFC504_ECC_STATUS)>>
>> +						HINFC504_ECC_1_BIT_SHIFT);
>> +			break;
>> +		case 6:
>> +			stat = hweight16(hinfc_read(host, HINFC504_ECC_STATUS)>>
>> +			HINFC504_ECC_16_BIT_SHIFT & 0x0fff);
>> +		}
>> +		mtd->ecc_stats.corrected += stat;
>> +		max_bitflips = max_t(unsigned int, max_bitflips, stat);
>> +	}
>> +	host->irq_status = 0;
>> +
>> +	return max_bitflips;
>> +}
>> +
>> +static int hisi_nand_write_page_hwecc(struct mtd_info *mtd,
>> +		struct nand_chip *chip, const uint8_t *buf, int oob_required)
>> +{
>> +	chip->write_buf(mtd, buf, mtd->writesize);
>> +	if (oob_required)
>> +		chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
>> +
>> +	return 0;
>> +}
>> +
>> +static void hisi_nfc_host_init(struct hinfc_host *host)
>> +{
>> +	struct nand_chip *chip = &host->chip;
>> +	unsigned int flag = 0;
>> +
>> +	host->version = hinfc_read(host, HINFC_VERSION);
>> +	host->addr_cycle		= 0;
>> +	host->addr_value[0]		= 0;
>> +	host->addr_value[1]		= 0;
>> +	host->cache_addr_value[0]	= ~0;
>> +	host->cache_addr_value[1]	= ~0;
>> +	host->chipselect		= 0;
>> +
>> +	/* default page size: 2K, ecc_none. need modify */
>> +	flag = HINFC504_CON_OP_MODE_NORMAL | HINFC504_CON_READY_BUSY_SEL
>> +		| ((0x001 & HINFC504_CON_PAGESIZE_MASK)
>> +			<< HINFC504_CON_PAGEISZE_SHIFT)
>> +		| ((0x0 & HINFC504_CON_ECCTYPE_MASK)
>> +			<< HINFC504_CON_ECCTYPE_SHIFT)
>> +		| ((chip->options & NAND_BUSWIDTH_16) ?
>> +			HINFC504_CON_BUS_WIDTH : 0);
>> +	hinfc_write(host, flag, HINFC504_CON);
>> +
>> +	memset(chip->IO_ADDR_R, 0xff, HINFC504_BUFFER_BASE_ADDRESS_LEN);
>> +
>> +	hinfc_write(host, SET_HINFC504_PWIDTH(HINFC504_W_LATCH,
>> +		    HINFC504_R_LATCH, HINFC504_RW_LATCH), HINFC504_PWIDTH);
>> +
>> +	/* enable dma irq */
>> +	hinfc_write(host, HINFC504_INTEN_DMA, HINFC504_INTEN);
>> +}
>> +
>> +static struct nand_ecclayout nand_ecc_2K_1bit = {
>> +	.oobfree = { {24, 40} }
>> +};
>> +
>> +static struct nand_ecclayout nand_ecc_2K_16bits = {
>> +	.oobavail = 6,
>> +	.oobfree = { {2, 6} },
>> +};
>> +
>> +static int hisi_nfc_ecc_probe(struct hinfc_host *host)
>> +{
>> +	struct nand_chip *chip = &host->chip;
>> +	unsigned int flag;
>> +
>> +	chip->ecc.read_page = hisi_nand_read_page_hwecc;
>> +	chip->ecc.write_page = hisi_nand_write_page_hwecc;
>> +
>> +	switch (host->ecc_bits) {
>> +	case 1:
>> +		chip->ecc.layout = &nand_ecc_2K_1bit;
>> +		chip->ecc.strength = 1;
>> +		chip->ecc.size = 512;
>> +		break;
>> +	case 6:
>> +		chip->ecc.layout = &nand_ecc_2K_16bits;
>> +		chip->ecc.strength = 16;
>> +		chip->ecc.size = 1024;
>> +	}
>> +
>> +	flag = hinfc_read(host, HINFC504_CON);
>> +	/* add ecc type configure */
>> +	flag |= ((host->ecc_bits & HINFC504_CON_ECCTYPE_MASK)
>> +						<< HINFC504_CON_ECCTYPE_SHIFT);
>> +	hinfc_write(host, flag, HINFC504_CON);
>> +
>> +	/* enable ecc irq */
>> +	flag = hinfc_read(host, HINFC504_INTEN) & 0xfff;
>> +	hinfc_write(host, flag | HINFC504_INTEN_UE | HINFC504_INTEN_CE,
>> +		    HINFC504_INTEN);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_probe(struct platform_device *pdev)
>> +{
>> +	int ret = 0, irq, buswidth, flag, max_chips = HINFC504_MAX_CHIP;
>> +	struct device *dev = &pdev->dev;
>> +	struct hinfc_host *host;
>> +	struct nand_chip  *chip;
>> +	struct mtd_info   *mtd;
>> +	struct resource	  *res;
>> +	struct device_node *np = dev->of_node;
>> +	struct mtd_part_parser_data ppdata;
>> +
>> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
>> +	if (!host)
>> +		return -ENOMEM;
>> +	host->dev = dev;
>> +
>> +	platform_set_drvdata(pdev, host);
>> +	chip = &host->chip;
>> +	mtd  = &host->mtd;
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq < 0) {
>> +		dev_err(dev, "no IRQ resource defined\n");
>> +		ret = -ENXIO;
>> +		goto err_res;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	host->iobase = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(host->iobase)) {
>> +		ret = PTR_ERR(host->iobase);
>> +		dev_err(dev, "devm_ioremap_resource[0] fail\n");
>> +		goto err_res;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +	chip->IO_ADDR_R = chip->IO_ADDR_W = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(chip->IO_ADDR_R)) {
>> +		ret = PTR_ERR(chip->IO_ADDR_R);
>> +		dev_err(dev, "devm_ioremap_resource[1] fail\n");
>> +		goto err_res;
>> +	}
>> +
>> +	mtd->priv		= chip;
>> +	mtd->owner		= THIS_MODULE;
>> +	mtd->name		= "hisi_nand";
>> +	mtd->dev.parent         = &pdev->dev;
>> +
>> +	chip->priv		= host;
>> +	chip->cmdfunc		= hisi_nfc_cmdfunc;
>> +	chip->select_chip	= hisi_nfc_select_chip;
>> +	chip->read_byte		= hisi_nfc_read_byte;
>> +	chip->read_word		= hisi_nfc_read_word;
>> +	chip->write_buf		= hisi_nfc_write_buf;
>> +	chip->read_buf		= hisi_nfc_read_buf;
>> +	chip->chip_delay	= HINFC504_CHIP_DELAY;
>> +
>> +	chip->ecc.mode = of_get_nand_ecc_mode(np);
>> +	/* read ecc-bits from dts */
>> +	of_property_read_u32(np, "hisi,nand-ecc-bits", &host->ecc_bits);
>
> Replace this with of_get_nand_ecc_step_size() and
> of_get_nand_ecc_strength().

OK, will modify this.

>
>> +	if (host->ecc_bits != 0 && host->ecc_bits != 1 && host->ecc_bits != 6) {
>> +		ret = -EINVAL;
>> +		dev_err(dev, "invalid nand-ecc-bits: %u\n", host->ecc_bits);
>> +		goto err_res;
>> +	}
>> +
>> +	buswidth = of_get_nand_bus_width(np);
>> +	if (buswidth == 16)
>> +		chip->options |= NAND_BUSWIDTH_16;
>> +
>> +	hisi_nfc_host_init(host);
>> +
>> +	ret = devm_request_irq(dev, irq, hinfc_irq_handle, IRQF_DISABLED,
>> +				"nandc", host);
>> +	if (ret) {
>> +		dev_err(dev, "failed to request IRQ\n");
>> +		goto err_irq;
>> +	}
>> +
>> +	ret = nand_scan_ident(mtd, max_chips, NULL);
>> +	if (ret) {
>> +		ret = -ENODEV;
>> +		goto err_ident;
>> +	}
>> +
>> +	host->buffer = dma_alloc_coherent(dev, mtd->writesize + mtd->oobsize,
>> +		&host->dma_buffer, GFP_KERNEL);
>
> Can you use dmam_alloc_coherent()? That will save you some of the
> cleanup on error and removal paths.
>

OK, will modify this and related code.

>> +	if (!host->buffer) {
>> +		dev_err(dev, "Can't malloc memory for NAND driver.\n");
>> +		ret = -ENOMEM;
>> +		goto err_buf;
>> +	}
>> +	host->dma_oob = host->dma_buffer + mtd->writesize;
>> +	memset(host->buffer, 0xff, mtd->writesize + mtd->oobsize);
>> +
>> +	flag = hinfc_read(host, HINFC504_CON);
>> +	flag &= ~(HINFC504_CON_PAGESIZE_MASK << HINFC504_CON_PAGEISZE_SHIFT);
>> +	switch (mtd->writesize) {
>> +	case 2048:
>> +		flag |= (0x001 << HINFC504_CON_PAGEISZE_SHIFT);
>> +	/* add more pagesize support
>> +	 * default pagesize has been set in hisi_nfc_host_init
>> +	 */
>
> Does this mean you can't handle any other page size? You might want to
> put the words 'TODO' or 'FIXME' in the comment, and you might want to
> print an error and exit if you see some other value for mtd->writesize.
>

Yes, this NAND controller can handle not only 2048 page size. But
the NAND controller on hip04-d01 board which I used to test this driver 
connects with a NAND flash chip which is just 2048 page size. So here I
just listed 'case 2048', Maybe I need indicate this by 'TODO:...'?

>> +	}
>> +	hinfc_write(host, flag, HINFC504_CON);
>> +
>> +	if (chip->ecc.mode == NAND_ECC_HW)
>> +		hisi_nfc_ecc_probe(host);
>> +
>> +	nand_scan_tail(mtd);
>
> Please capture and handle the return value here.
>

will modify this, thanks!

>> +
>> +	ppdata.of_node = np;
>> +	ret = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
>> +	if (ret) {
>> +		dev_err(dev, "Err MTD partition=%d\n", ret);
>> +		goto err_mtd;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_mtd:
>> +	nand_release(mtd);
>> +err_ident:
>> +err_irq:
>
> Do you really need these empty labels?
>

will merge the err_ident, err_irq, err_buf into err_res.

>> +err_buf:
>> +	if (host->buffer)
>> +		dma_free_coherent(dev, mtd->writesize + mtd->oobsize,
>> +				  host->buffer, host->dma_buffer);
>
> This will go away.
>
>> +err_res:
>> +	return ret;
>> +}
>> +
>> +static int hisi_nfc_remove(struct platform_device *pdev)
>> +{
>> +	struct hinfc_host *host = platform_get_drvdata(pdev);
>> +	struct mtd_info *mtd = &host->mtd;
>> +
>> +	nand_release(mtd);
>> +	dma_free_coherent(&pdev->dev, mtd->writesize + mtd->oobsize,
>> +			  host->buffer, host->dma_buffer);
>
> Same here.
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int hisi_nfc_suspend(struct platform_device *pdev,
>> +			       pm_message_t state)
>> +{
>> +	struct hinfc_host *host = platform_get_drvdata(pdev);
>> +
>> +	while ((hinfc_read(host, HINFC504_STATUS) & 0x1) == 0x0)
>> +		;
>> +
>> +	while ((hinfc_read(host, HINFC504_DMA_CTRL))
>> +		& HINFC504_DMA_CTRL_DMA_START)
>> +		_cond_resched();
>
> It's probably best if these don't spin forever. Can you implement a
> timeout, and return an error on failure?
>

will add a timeout here, thanks!

>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_resume(struct platform_device *pdev)
>> +{
>> +	int cs;
>> +	struct hinfc_host *host = platform_get_drvdata(pdev);
>> +	struct nand_chip *chip = &host->chip;
>> +
>> +	for (cs = 0; cs < chip->numchips; cs++)
>> +		hisi_nfc_send_cmd_reset(host, cs);
>> +	hinfc_write(host, SET_HINFC504_PWIDTH(HINFC504_W_LATCH,
>> +		    HINFC504_R_LATCH, HINFC504_RW_LATCH), HINFC504_PWIDTH);
>> +
>> +	return 0;
>> +}
>> +#endif
>> +static SIMPLE_DEV_PM_OPS(hisi_nfc_pm_ops, hisi_nfc_suspend, hisi_nfc_resume);
>> +
>> +static const struct of_device_id nfc_id_table[] = {
>> +	{ .compatible = "hisilicon,504-nfc" },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(of, nfc_id_table);
>> +
>> +static struct platform_driver hisi_nfc_driver = {
>> +	.driver = {
>> +		.name  = "hisi_nand",
>> +		.of_match_table = of_match_ptr(nfc_id_table),
>> +		.pm = &hisi_nfc_pm_ops,
>> +	},
>> +	.probe		= hisi_nfc_probe,
>> +	.remove		= hisi_nfc_remove,
>> +};
>> +
>> +module_platform_driver(hisi_nfc_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Zhiyong Cai");
>> +MODULE_AUTHOR("Zhou Wang");
>> +MODULE_DESCRIPTION("Hisilicon Nand Flash Controller Driver");
>
> Brian
>
Thanks!
Zhou Wang

