Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3GAFTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:19:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60338 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3GAFTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:19:08 -0400
Message-ID: <51D11106.3040701@ti.com>
Date: Mon, 1 Jul 2013 10:47:58 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>, <artem.bityutskiy@linux.intel.com>
CC: <linux-mtd@lists.infradead.org>, <spi-devel-general@lists.sourceforge.net>,
        <broonie@kernel.org>, <dwmw2@infradead.org>, <manonuevo@micron.com>,
        <tqnguyen@micron.com>, <grant.likely@linaro.org>, <balbi@ti.com>,
        <rnayak@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers: mtd: spinand: Add generic spinand frameowrk
 and micron driver.
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com> <1372232472-2641-2-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1372232472-2641-2-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Artem
On Wednesday 26 June 2013 01:11 PM, Sourav Poddar wrote:
> From: Mona Anonuevo<manonuevo@micron.com>
>
> This patch adds support for a generic spinand framework(spinand_mtd.c).
> This frameowrk can be used for other spi based flash devices also. The idea
> is to have a common model under drivers/mtd, as also present for other no spi
> devices(there is a generic framework and device part simply attaches itself to it.)
>
> The generic frework will be used later by me for a SPI based spansion S25FL256 device.
> The patch also contains a micron driver attaching itself to generic framework.
>
> Signed-off-by: Mona Anonuevo<manonuevo@micron.com>
> Signed-off-by: Tuan Nguyen<tqnguyen@micron.com>
> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
> ----
> [I picked this as a standalone patch, can split it into generic and device part
> based on community feedback.]
>
>   drivers/mtd/Kconfig               |    2 +
>   drivers/mtd/Makefile              |    2 +
>   drivers/mtd/spinand/Kconfig       |   24 ++
>   drivers/mtd/spinand/Makefile      |   10 +
>   drivers/mtd/spinand/spinand_lld.c |  776 +++++++++++++++++++++++++++++++++++++
>   drivers/mtd/spinand/spinand_mtd.c |  690 +++++++++++++++++++++++++++++++++
>   include/linux/mtd/spinand.h       |  155 ++++++++
>   7 files changed, 1659 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/mtd/spinand/Kconfig
>   create mode 100644 drivers/mtd/spinand/Makefile
>   create mode 100644 drivers/mtd/spinand/spinand_lld.c
>   create mode 100644 drivers/mtd/spinand/spinand_mtd.c
>   create mode 100644 include/linux/mtd/spinand.h
>
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 5fab4e6..c9e6c60 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -318,6 +318,8 @@ source "drivers/mtd/nand/Kconfig"
>
>   source "drivers/mtd/onenand/Kconfig"
>
> +source "drivers/mtd/spinand/Kconfig"
> +
>   source "drivers/mtd/lpddr/Kconfig"
>
>   source "drivers/mtd/ubi/Kconfig"
> diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
> index 4cfb31e..cce68db 100644
> --- a/drivers/mtd/Makefile
> +++ b/drivers/mtd/Makefile
> @@ -32,4 +32,6 @@ inftl-objs		:= inftlcore.o inftlmount.o
>
>   obj-y		+= chips/ lpddr/ maps/ devices/ nand/ onenand/ tests/
>
> +obj-y		+= spinand/
> +
>   obj-$(CONFIG_MTD_UBI)		+= ubi/
> diff --git a/drivers/mtd/spinand/Kconfig b/drivers/mtd/spinand/Kconfig
> new file mode 100644
> index 0000000..38c739f
> --- /dev/null
> +++ b/drivers/mtd/spinand/Kconfig
> @@ -0,0 +1,24 @@
> +#
> +# linux/drivers/mtd/spinand/Kconfig
> +#
> +
> +menuconfig MTD_SPINAND
> +	tristate "SPINAND Device Support"
> +	depends on MTD
> +	help
> +	 This enables support for accessing Micron SPI NAND flash
> +	 devices.
> +
> +if MTD_SPINAND
> +
> +config MTD_SPINAND_ONDIEECC
> +	bool "Use SPINAND internal ECC"
> +	help
> +	 Internel ECC
> +
> +config MTD_SPINAND_SWECC
> +	bool "Use software ECC"
> +	depends on MTD_NAND
> +	help
> +	 software ECC
> +endif
> diff --git a/drivers/mtd/spinand/Makefile b/drivers/mtd/spinand/Makefile
> new file mode 100644
> index 0000000..355e726
> --- /dev/null
> +++ b/drivers/mtd/spinand/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Makefile for the SPI NAND MTD
> +#
> +
> +# Core functionality.
> +obj-$(CONFIG_MTD_SPINAND)		+= spinand.o
> +
> +spinand-objs := spinand_mtd.o spinand_lld.o
> +
> +
> diff --git a/drivers/mtd/spinand/spinand_lld.c b/drivers/mtd/spinand/spinand_lld.c
> new file mode 100644
> index 0000000..9f53737
> --- /dev/null
> +++ b/drivers/mtd/spinand/spinand_lld.c
> @@ -0,0 +1,776 @@
> +/*
> +spinand_lld.c
> +
> +Copyright (c) 2009-2010 Micron Technology, Inc.
> +
> +This program is free software; you can redistribute it and/or
> +modify it under the terms of the GNU General Public License
> +as published by the Free Software Foundation; either version 2
> +of the License, or (at your option) any later version.
> +
> +This program is distributed in the hope that it will be useful,
> +but WITHOUT ANY WARRANTY; without even the implied warranty of
> +MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +GNU General Public License for more details.
> +
> +*/
> +
> +#include<linux/init.h>
> +#include<linux/module.h>
> +#include<linux/device.h>
> +#include<linux/interrupt.h>
> +#include<linux/mutex.h>
> +#include<linux/math64.h>
> +
> +#include<linux/mtd/mtd.h>
> +#include<linux/mtd/partitions.h>
> +#include<linux/mtd/spinand.h>
> +
> +#include<linux/spi/spi.h>
> +#include<linux/spi/flash.h>
> +
> +#define mu_spi_nand_driver_version "Beagle-MTD_01.00_Linux2.6.33_20100507"
> +#define SPI_NAND_MICRON_DRIVER_KEY 0x1233567
> +
> +/****************************************************************************/
> +
> +/**
> +   OOB area specification layout:  Total 32 available free bytes.
> +*/
> +static struct nand_ecclayout spinand_oob_64 = {
> +	.eccbytes = 24,
> +	.eccpos = {
> +		   1, 2, 3, 4, 5, 6,
> +		   17, 18, 19, 20, 21, 22,
> +		   33, 34, 35, 36, 37, 38,
> +		   49, 50, 51, 52, 53, 54, },
> +	.oobavail = 32,
> +	.oobfree = {
> +		{.offset = 8,
> +		 .length = 8},
> +		{.offset = 24,
> +		 .length = 8},
> +		{.offset = 40,
> +		 .length = 8},
> +		{.offset = 56,
> +		 .length = 8}, }
> +};
> +/**
> + * spinand_cmd - to process a command to send to the SPI Nand
> + *
> + * Description:
> + *    Set up the command buffer to send to the SPI controller.
> + *    The command buffer has to initized to 0
> + */
> +int spinand_cmd(struct spi_device *spi, struct spinand_cmd *cmd)
> +{
> +	int					ret;
> +	struct spi_message	message;
> +	struct spi_transfer		x[4];
> +	u8 dummy = 0xff;
> +
> +	spi_message_init(&message);
> +	memset(x, 0, sizeof(x));
> +
> +	x[0].len = 1;
> +	x[0].tx_buf =&cmd->cmd;
> +	spi_message_add_tail(&x[0],&message);
> +
> +	if (cmd->n_addr) {
> +		x[1].len = cmd->n_addr;
> +		x[1].tx_buf = cmd->addr;
> +		spi_message_add_tail(&x[1],&message);
> +	}
> +
> +	if (cmd->n_dummy) {
> +		x[2].len = cmd->n_dummy;
> +		x[2].tx_buf =&dummy;
> +		spi_message_add_tail(&x[2],&message);
> +	}
> +
> +	if (cmd->n_tx) {
> +		x[3].len = cmd->n_tx;
> +		x[3].tx_buf = cmd->tx_buf;
> +		spi_message_add_tail(&x[3],&message);
> +	}
> +
> +	if (cmd->n_rx) {
> +		x[3].len = cmd->n_rx;
> +		x[3].rx_buf = cmd->rx_buf;
> +		spi_message_add_tail(&x[3],&message);
> +	}
> +
> +	ret = spi_sync(spi,&message);
> +
> +	return ret;
> +}
> +
> +/**
> + * spinand_reset- send reset command "0xff" to the Nand device
> + *
> + * Description:
> + *    Reset the SPI Nand with the reset command 0xff
> +*/
> +static int spinand_reset(struct spi_device *spi_nand)
> +{
> +	struct spinand_cmd cmd = {0};
> +
> +	cmd.cmd = CMD_RESET;
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +/**
> + * spinand_read_id- Read SPI Nand ID
> + *
> + * Description:
> + *    Read ID: read two ID bytes from the SPI Nand device
> +*/
> +static int spinand_read_id(struct spi_device *spi_nand, u8 *id)
> +{
> +	struct spinand_cmd cmd = {0};
> +	ssize_t retval;
> +
> +	cmd.cmd = CMD_READ_ID;
> +	cmd.n_dummy = 1;
> +	cmd.n_rx = 2;
> +	cmd.rx_buf = id;
> +
> +	retval = spinand_cmd(spi_nand,&cmd);
> +
> +	if (retval != 0) {
> +		dev_err(&spi_nand->dev, "error %d reading id\n",
> +				(int) retval);
> +		return retval;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * spinand_lock_block- send write register 0x1f command to the Nand device
> + *
> + * Description:
> + *    After power up, all the Nand blocks are locked.  This function allows
> + *    one to unlock the blocks, and so it can be wriiten or erased.
> +*/
> +static int spinand_lock_block(struct spi_device *spi_nand,
> +			struct spinand_info *info, u8 lock)
> +{
> +	struct spinand_cmd cmd = {0};
> +	ssize_t retval;
> +
> +	cmd.cmd = CMD_WRITE_REG;
> +	cmd.n_addr = 1;
> +	cmd.addr[0] = REG_BLOCK_LOCK;
> +	cmd.n_tx = 1;
> +	cmd.tx_buf =&lock;
> +
> +	retval = spinand_cmd(spi_nand,&cmd);
> +
> +	if (retval != 0) {
> +		dev_err(&spi_nand->dev, "error %d lock block\n",
> +				(int) retval);
> +		return retval;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * spinand_read_status- send command 0xf to the SPI Nand status register
> + *
> + * Description:
> + * After read, write, or erase, the Nand device is expected to
> +	set the busy status.
> + * This function is to allow reading the status of the command:
> +	read, write, and erase.
> + * Once the status turns to be ready, the other status bits also
> +	are valid status bits.
> +*/
> +static int spinand_read_status(struct spi_device *spi_nand,
> +			struct spinand_info *info, u8 *status)
> +{
> +	struct spinand_cmd cmd = {0};
> +	ssize_t retval;
> +
> +	cmd.cmd = CMD_READ_REG;
> +	cmd.n_addr = 1;
> +	cmd.addr[0] = REG_STATUS;
> +	cmd.n_rx = 1;
> +	cmd.rx_buf = status;
> +
> +	retval = spinand_cmd(spi_nand,&cmd);
> +
> +	if (retval != 0) {
> +		dev_err(&spi_nand->dev, "error %d reading status register\n",
> +				(int) retval);
> +		return retval;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * spinand_get_otp- send command 0xf to read the SPI Nand OTP register
> + *
> + * Description:
> + *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
> + *   Enable chip internal ECC, set the bit to 1
> + *   Disable chip internal ECC, clear the bit to 0
> + */
> +static int spinand_get_otp(struct spi_device *spi_nand,
> +			struct spinand_info *info, u8 *otp)
> +{
> +	struct spinand_cmd cmd = {0};
> +	ssize_t retval;
> +
> +	cmd.cmd = CMD_READ_REG;
> +	cmd.n_addr = 1;
> +	cmd.addr[0] = REG_OTP;
> +	cmd.n_rx = 1;
> +	cmd.rx_buf	 = otp;
> +
> +	retval = spinand_cmd(spi_nand,&cmd);
> +
> +	if (retval != 0) {
> +		dev_err(&spi_nand->dev, "error %d get otp\n",
> +				(int) retval);
> +		return retval;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * spinand_set_otp- send command 0x1f to write the SPI Nand OTP register
> + *
> + * Description:
> + *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
> + *   Enable chip internal ECC, set the bit to 1
> + *   Disable chip internal ECC, clear the bit to 0
> +*/
> +static int spinand_set_otp(struct spi_device *spi_nand,
> +			struct spinand_info *info, u8 *otp)
> +{
> +	struct spinand_cmd cmd = {0};
> +	ssize_t retval;
> +
> +	cmd.cmd = CMD_WRITE_REG;
> +	cmd.n_addr = 1;
> +	cmd.addr[0] = REG_OTP;
> +	cmd.n_tx = 1;
> +	cmd.tx_buf = otp;
> +
> +	retval = spinand_cmd(spi_nand,&cmd);
> +
> +	if (retval != 0) {
> +		dev_err(&spi_nand->dev, "error %d set otp\n",
> +			(int) retval);
> +		return retval;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * sspinand_enable_ecc- send command 0x1f to write the SPI Nand OTP register
> + *
> + * Description:
> + *   There is one bit( bit 0x10 ) to set or to clear the internal ECC.
> + *   Enable chip internal ECC, set the bit to 1
> + *   Disable chip internal ECC, clear the bit to 0
> +*/
> +#ifdef CONFIG_MTD_SPINAND_ONDIEECC
> +static int spinand_enable_ecc(struct spi_device *spi_nand,
> +			struct spinand_info *info)
> +{
> +	ssize_t retval;
> +	u8 otp = 0;
> +
> +	retval = spinand_get_otp(spi_nand, info,&otp);
> +
> +	if ((otp&  OTP_ECC_MASK) == OTP_ECC_MASK) {
> +		return 0;
> +	} else {
> +		otp |= OTP_ECC_MASK;
> +		retval = spinand_set_otp(spi_nand, info,&otp);
> +		retval = spinand_get_otp(spi_nand, info,&otp);
> +		return retval;
> +	}
> +}
> +#else
> +static int spinand_disable_ecc(struct spi_device *spi_nand,
> +				struct spinand_info *info)
> +{
> +	ssize_t retval;
> +	u8 otp = 0;
> +
> +	retval = spinand_get_otp(spi_nand, info,&otp);
> +
> +	if ((otp&  OTP_ECC_MASK) == OTP_ECC_MASK) {
> +		otp&= ~OTP_ECC_MASK;
> +		retval = spinand_set_otp(spi_nand, info,&otp);
> +		retval = spinand_get_otp(spi_nand, info,&otp);
> +		return retval;
> +	} else {
> +		return 0;
> +	}
> +}
> +#endif
> +
> +/**
> + * sspinand_write_enable- send command 0x06 to enable write or erase the Nand cells
> + *
> + * Description:
> + *   Before write and erase the Nand cells, the write enable has to be set.
> + *   After the write or erase, the write enable bit is automatically
> +	cleared( status register bit 2 )
> + *   Set the bit 2 of the status register has the same effect
> +*/
> +static int spinand_write_enable(struct spi_device *spi_nand,
> +					struct spinand_info *info)
> +{
> +	struct spinand_cmd cmd = {0};
> +
> +	cmd.cmd = CMD_WR_ENABLE;
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +static int spinand_read_page_to_cache(struct spi_device *spi_nand,
> +					struct spinand_info *info, u16 page_id)
> +{
> +	struct spinand_cmd cmd = {0};
> +	u16 row;
> +
> +	row = page_id;
> +
> +	cmd.cmd = CMD_READ;
> +	cmd.n_addr = 3;
> +	cmd.addr[1] = (u8)((row&  0xff00)>>  8);
> +	cmd.addr[2] = (u8)(row&  0x00ff);
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +/**
> + * spinand_read_from_cache- send command 0x03 to read out the data from the
> +	cache register( 2112 bytes max )
> + *
> + * Description:
> + *   The read can specify 1 to 2112 bytes of data read at the
> +	coresponded locations.
> + *   No tRd delay.
> +*/
> +static int spinand_read_from_cache(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 byte_id, u16 len, u8 *rbuf)
> +{
> +	struct spinand_cmd cmd = {0};
> +	u16 column;
> +
> +	column = byte_id;
> +
> +	cmd.cmd = CMD_READ_RDM;
> +	cmd.n_addr = 2;
> +	cmd.addr[0] = (u8)((column&0xff00)>>8);
> +	cmd.addr[1] = (u8)(column&0x00ff);
> +	cmd.n_dummy = 1;
> +	cmd.n_rx = len;
> +	cmd.rx_buf = rbuf;
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +/**
> + * spinand_read_page-to read a page with:
> + * @page_id: the physical page number
> + * @offset:  the location from 0 to 2111
> + * @len:     number of bytes to read
> + * @rbuf:    read buffer to hold @len bytes
> + *
> + * Description:
> + *   The read icludes two commands to the Nand: 0x13 and 0x03 commands
> + *   Poll to read status to wait for tRD time.
> + */
> +static int spinand_read_page(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 page_id, u16 offset,
> +			u16 len, u8 *rbuf)
> +{
> +	ssize_t retval;
> +	u8 status = 0;
> +
> +	retval = spinand_read_page_to_cache(spi_nand, info, page_id);
> +
> +	while (1) {
> +		retval = spinand_read_status(spi_nand, info,&status);
> +		if (retval<  0) {
> +			dev_err(&spi_nand->dev, "error %d reading status register\n",
> +					(int) retval);
> +			return retval;
> +		}
> +
> +		if ((status&  STATUS_OIP_MASK) == STATUS_READY) {
> +			if ((status&  STATUS_ECC_MASK) == STATUS_ECC_ERROR) {
> +				dev_err(&spi_nand->dev,
> +					"ecc error, page=%d\n", page_id);
> +			}
> +			break;
> +		}
> +	}
> +
> +	retval = spinand_read_from_cache(spi_nand, info, offset, len, rbuf);
> +	return 0;
> +}
> +
> +/**
> + * spinand_program_data_to_cache--to write a page to cache with:
> + * @byte_id: the location to write to the cache
> + * @len:     number of bytes to write
> + * @rbuf:    read buffer to hold @len bytes
> + *
> + * Description:
> + *   The write command used here is 0x84--indicating that the cache
> +	is not cleared first.
> + *   Since it is writing the data to cache, there is no tPROG time.
> + */
> +static int spinand_program_data_to_cache(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 byte_id, u16 len, u8 *wbuf)
> +{
> +	struct spinand_cmd cmd = {0};
> +	u16 column;
> +
> +	column = byte_id;
> +
> +	cmd.cmd = CMD_PROG_PAGE_CLRCACHE;
> +	cmd.n_addr = 2;
> +	cmd.addr[0] = (u8)((column&  0xff00)>>  8);
> +	cmd.addr[1] = (u8)(column&  0x00ff);
> +	cmd.n_tx = len;
> +	cmd.tx_buf = wbuf;
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +/**
> + * spinand_program_execute--to write a page from cache to the Nand array with:
> + * @page_id: the physical page location to write the page.
> + *
> + * Description:
> + *   The write command used here is 0x10--indicating the cache is
> +	writing to the Nand array.
> + *   Need to wait for tPROG time to finish the transaction.
> + */
> +static int spinand_program_execute(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 page_id)
> +{
> +	struct spinand_cmd cmd = {0};
> +	u16 row;
> +
> +	row = page_id;
> +
> +	cmd.cmd = CMD_PROG_PAGE_EXC;
> +	cmd.n_addr = 3;
> +	cmd.addr[1] = (u8)((row&  0xff00)>>  8);
> +	cmd.addr[2] = (u8)(row&  0x00ff);
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +/**
> + * spinand_program_page--to write a page with:
> + * @page_id: the physical page location to write the page.
> + * @offset:  the location from the cache starting from 0 to 2111
> + * @len:     the number of bytes to write
> + * @wbuf:    the buffer to hold the number of bytes
> + *
> + * Description:
> + *   The commands used here are 0x06, 0x84, and 0x10--indicating that
> +	the write enable is first
> + *   sent, the write cache command, and the write execute command
> + *   Poll to wait for the tPROG time to finish the transaction.
> + */
> +static int spinand_program_page(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 page_id, u16 offset,
> +		u16 len, u8 *wbuf)
> +{
> +	ssize_t retval;
> +	u8 status = 0;
> +
> +	retval = spinand_write_enable(spi_nand, info);
> +
> +	retval = spinand_program_data_to_cache(spi_nand, info, offset,
> +			len, wbuf);
> +
> +	retval = spinand_program_execute(spi_nand, info, page_id);
> +
> +	while (1) {
> +		retval = spinand_read_status(spi_nand, info,&status);
> +		if (retval<  0) {
> +			dev_err(&spi_nand->dev,
> +				"error %d reading status register\n",
> +					(int) retval);
> +			return retval;
> +		}
> +
> +		if ((status&  STATUS_OIP_MASK) == STATUS_READY) {
> +			if ((status&  STATUS_P_FAIL_MASK) == STATUS_P_FAIL) {
> +				dev_err(&spi_nand->dev,
> +					"program error, page=%d\n", page_id);
> +				return -1;
> +			}
> +		} else {
> +			break;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * spinand_erase_block_erase--to erase a page with:
> + * @block_id: the physical block location to erase.
> + *
> + * Description:
> + *   The command used here is 0xd8--indicating an erase
> +command to erase one block--64 pages
> + *   Need to wait for tERS.
> + */
> +static int spinand_erase_block_erase(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 block_id)
> +{
> +	struct spinand_cmd cmd = {0};
> +	u16 row;
> +
> +	row = block_id<<  6;
> +	cmd.cmd = CMD_ERASE_BLK;
> +	cmd.n_addr = 3;
> +	cmd.addr[1] = (u8)((row&  0xff00)>>  8);
> +	cmd.addr[2] = (u8)(row&  0x00ff);
> +
> +	return spinand_cmd(spi_nand,&cmd);
> +}
> +
> +/**
> + * spinand_erase_block--to erase a page with:
> + * @block_id: the physical block location to erase.
> + *
> + * Description:
> + *   The commands used here are 0x06 and 0xd8--indicating an erase
> +	command to erase one block--64 pages
> + *   It will first to enable the write enable bit ( 0x06 command ),
> +	and then send the 0xd8 erase command
> + *   Poll to wait for the tERS time to complete the tranaction.
> + */
> +static int spinand_erase_block(struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 block_id)
> +{
> +	ssize_t retval;
> +	u8 status = 0;
> +
> +	retval = spinand_write_enable(spi_nand, info);
> +
> +	retval = spinand_erase_block_erase(spi_nand, info, block_id);
> +
> +	while (1) {
> +		retval = spinand_read_status(spi_nand, info,&status);
> +		if (retval<  0) {
> +			dev_err(&spi_nand->dev,
> +				"error %d reading status register\n",
> +					(int) retval);
> +			return retval;
> +		}
> +
> +		if ((status&  STATUS_OIP_MASK) == STATUS_READY) {
> +			if ((status&  STATUS_E_FAIL_MASK) == STATUS_E_FAIL) {
> +				dev_err(&spi_nand->dev,
> +					"erase error, block=%d\n", block_id);
> +				return -1;
> +			} else {
> +				break;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * spinand_get_info: get NAND info, from read id or const value
> + * Description:
> + *   To set up the device parameters.
> + */
> +static int spinand_get_info(struct spi_device *spi_nand,
> +		struct spinand_info *info, u8 *id)
> +{
> +	if (id[0] == 0x2C&&  (id[1] == 0x11 ||
> +		id[1] == 0x12 || id[1] == 0x13)) {
> +		info->mid = id[0];
> +		info->did = id[1];
> +		info->name = "MT29F1G01ZAC";
> +		info->nand_size = (1024 * 64 * 2112);
> +		info->usable_size = (1024 * 64 * 2048);
> +		info->block_size = (2112*64);
> +		info->block_main_size = (2048*64);
> +		info->block_num_per_chip = 1024;
> +		info->page_size = 2112;
> +		info->page_main_size = 2048;
> +		info->page_spare_size = 64;
> +		info->page_num_per_block = 64;
> +
> +		info->block_shift = 17;
> +		info->block_mask = 0x1ffff;
> +
> +		info->page_shift = 11;
> +		info->page_mask = 0x7ff;
> +
> +		info->ecclayout =&spinand_oob_64;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * spinand_probe - [spinand Interface]
> + * @spi_nand: registered device driver.
> + *
> + * Description:
> + *   To set up the device driver parameters to make the device available.
> +*/
> +static int spinand_probe(struct spi_device *spi_nand)
> +{
> +	ssize_t retval;
> +	struct mtd_info *mtd;
> +	struct spinand_chip *chip;
> +	struct spinand_info *info;
> +	struct flash_platform_data      *data;
> +	struct mtd_part_parser_data     ppdata;
> +	u8 id[2] = {0};
> +
> +	retval = spinand_reset(spi_nand);
> +	retval = spinand_reset(spi_nand);
> +	retval = spinand_read_id(spi_nand, (u8 *)&id);
> +	if (id[0] == 0&&  id[1] == 0) {
> +		pr_info(KERN_INFO "SPINAND: read id error! 0x%02x, 0x%02x!\n",
> +			id[0], id[1]);
> +		return 0;
> +	}
> +
> +	data = spi_nand->dev.platform_data;
> +	info  = kzalloc(sizeof(struct spinand_info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	retval = spinand_get_info(spi_nand, info, (u8 *)&id);
> +	pr_info(KERN_INFO "SPINAND: 0x%02x, 0x%02x, %s\n",
> +		id[0], id[1], info->name);
> +	pr_info(KERN_INFO "%s\n", mu_spi_nand_driver_version);
> +	retval = spinand_lock_block(spi_nand, info, BL_ALL_UNLOCKED);
> +
> +#ifdef CONFIG_MTD_SPINAND_ONDIEECC
> +	retval = spinand_enable_ecc(spi_nand, info);
> +#else
> +	retval = spinand_disable_ecc(spi_nand, info);
> +#endif
> +
> +	ppdata.of_node = spi_nand->dev.of_node;
> +
> +	chip  = kzalloc(sizeof(struct spinand_chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	chip->spi_nand = spi_nand;
> +	chip->info = info;
> +	chip->reset = spinand_reset;
> +	chip->read_id = spinand_read_id;
> +	chip->read_page = spinand_read_page;
> +	chip->program_page = spinand_program_page;
> +	chip->erase_block = spinand_erase_block;
> +
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
> +	dev_set_drvdata(&spi_nand->dev, mtd);
> +
> +	mtd->priv = chip;
> +
> +	retval = spinand_mtd(mtd);
> +
> +	return mtd_device_parse_register(mtd, NULL,&ppdata,
> +			data ? data->parts : NULL,
> +			data ? data->nr_parts : 0);
> +}
> +
> +/**
> + * __devexit spinand_remove--Remove the device driver
> + * @spi: the spi device.
> + *
> + * Description:
> + *   To remove the device driver parameters and free up allocated memories.
> + */
> +static int spinand_remove(struct spi_device *spi)
> +{
> +	struct mtd_info *mtd;
> +	struct spinand_chip *chip;
> +
> +	pr_debug("%s: remove\n", dev_name(&spi->dev));
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
> +/**
> + * Device name structure description
> +*/
> +static struct spi_driver spinand_driver = {
> +	.driver = {
> +		.name		= "spi_nand",
> +		.bus		=&spi_bus_type,
> +		.owner		= THIS_MODULE,
> +	},
> +
> +	.probe		= spinand_probe,
> +	.remove		= spinand_remove,
> +};
> +
> +/**
> + * Device driver registration
> +*/
> +static int __init spinand_init(void)
> +{
> +	return spi_register_driver(&spinand_driver);
> +}
> +
> +/**
> + * unregister Device driver.
> +*/
> +static void __exit spinand_exit(void)
> +{
> +	spi_unregister_driver(&spinand_driver);
> +}
> +
> +module_init(spinand_init);
> +module_exit(spinand_exit);
> +
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Henry Pan<hspan@micron.com>");
> +MODULE_DESCRIPTION("SPI NAND driver code");
> diff --git a/drivers/mtd/spinand/spinand_mtd.c b/drivers/mtd/spinand/spinand_mtd.c
> new file mode 100644
> index 0000000..8bfff86
> --- /dev/null
> +++ b/drivers/mtd/spinand/spinand_mtd.c
> @@ -0,0 +1,690 @@
> +/*
> +spinand_mtd.c
> +
> +Copyright (c) 2009-2010 Micron Technology, Inc.
> +
> +This program is free software; you can redistribute it and/or
> +modify it under the terms of the GNU General Public License
> +as published by the Free Software Foundation; either version 2
> +of the License, or (at your option) any later version.
> +
> +This program is distributed in the hope that it will be useful,
> +but WITHOUT ANY WARRANTY; without even the implied warranty of
> +MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +GNU General Public License for more details.
> +*/
> +
> +#include<linux/kernel.h>
> +#include<linux/module.h>
> +#include<linux/init.h>
> +#include<linux/sched.h>
> +#include<linux/delay.h>
> +#include<linux/interrupt.h>
> +#include<linux/jiffies.h>
> +#include<linux/mtd/mtd.h>
> +#include<linux/mtd/partitions.h>
> +#include<linux/mtd/spinand.h>
> +#include<linux/mtd/nand_ecc.h>
> +
> +/**
> + * spinand_get_device - [GENERIC] Get chip for selected access
> + * @param mtd		MTD device structure
> + * @param new_state	the state which is requested
> + *
> + * Get the device and lock it for exclusive access
> + */
> +#define mu_spi_nand_driver_version "Beagle-MTD_01.00_Linux2.6.33_20100507"
> +
> +static int spinand_get_device(struct mtd_info *mtd, int new_state)
> +{
> +	struct spinand_chip *this = mtd->priv;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	/*
> +	 * Grab the lock and see if the device is available
> +	 */
> +	while (1) {
> +		spin_lock(&this->chip_lock);
> +		if (this->state == FL_READY) {
> +			this->state = new_state;
> +			spin_unlock(&this->chip_lock);
> +			break;
> +		}
> +		if (new_state == FL_PM_SUSPENDED) {
> +			spin_unlock(&this->chip_lock);
> +			return (this->state == FL_PM_SUSPENDED) ? 0 : -EAGAIN;
> +		}
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		add_wait_queue(&this->wq,&wait);
> +		spin_unlock(&this->chip_lock);
> +		schedule();
> +		remove_wait_queue(&this->wq,&wait);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * spinand_release_device - [GENERIC] release chip
> + * @param mtd		MTD device structure
> + *
> + * Deselect, release chip lock and wake up anyone waiting on the device
> + */
> +static void spinand_release_device(struct mtd_info *mtd)
> +{
> +	struct spinand_chip *this = mtd->priv;
> +
> +	/* Release the chip */
> +	spin_lock(&this->chip_lock);
> +	this->state = FL_READY;
> +	wake_up(&this->wq);
> +	spin_unlock(&this->chip_lock);
> +}
> +
> +#ifdef CONFIG_MTD_SPINAND_SWECC
> +static void spinand_calculate_ecc(struct mtd_info *mtd)
> +{
> +	int i;
> +	int eccsize = 512;
> +	int eccbytes = 3;
> +	int eccsteps = 4;
> +	int ecctotal = 12;
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spinand_info *info = chip->info;
> +	unsigned char *p = chip->buf;
> +
> +	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
> +		__nand_calculate_ecc(p, eccsize,&chip->ecc_calc[i]);
> +
> +	for (i = 0; i<  ecctotal; i++)
> +		chip->buf[info->page_main_size +
> +			info->ecclayout->eccpos[i]] = chip->ecc_calc[i];
> +}
> +
> +static int spinand_correct_data(struct mtd_info *mtd)
> +{
> +	int i;
> +	int eccsize = 512;
> +	int eccbytes = 3;
> +	int eccsteps = 4;
> +	int ecctotal = 12;
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spinand_info *info = chip->info;
> +	unsigned char *p = chip->buf;
> +	int errcode = 0;
> +
> +	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
> +		__nand_calculate_ecc(p, eccsize,&chip->ecc_calc[i]);
> +
> +	for (i = 0; i<  ecctotal; i++)
> +		chip->ecc_code[i] = chip->buf[info->page_main_size +
> +					info->ecclayout->eccpos[i]];
> +
> +	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
> +		int stat;
> +
> +		stat = __nand_correct_data(p,&chip->ecc_code[i],
> +					&chip->ecc_calc[i], eccsize);
> +		if (stat<  0)
> +			errcode = -1;
> +		else if (stat == 1)
> +			errcode = 1;
> +	}
> +	return errcode;
> +}
> +#endif
> +
> +static int spinand_read_ops(struct mtd_info *mtd, loff_t from,
> +			  struct mtd_oob_ops *ops)
> +{
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spi_device *spi_nand = chip->spi_nand;
> +	struct spinand_info *info = chip->info;
> +	int page_id, page_offset, page_num, oob_num;
> +
> +	int count;
> +	int main_ok, main_left, main_offset;
> +	int oob_ok, oob_left;
> +
> +	signed int retval;
> +	signed int errcode = 0;
> +
> +	if (!chip->buf)
> +		return -1;
> +
> +	page_id = from>>  info->page_shift;
> +
> +	/* for main data */
> +	page_offset = from&  info->page_mask;
> +	page_num = (page_offset + ops->len +
> +			info->page_main_size - 1) / info->page_main_size;
> +
> +	/* for oob */
> +	if (info->ecclayout->oobavail)
> +		oob_num = (ops->ooblen +
> +			info->ecclayout->oobavail - 1) / info->ecclayout->oobavail;
> +	else
> +		oob_num = 0;
> +
> +	count = 0;
> +
> +	main_left = ops->len;
> +	main_ok = 0;
> +	main_offset = page_offset;
> +
> +	oob_left = ops->ooblen;
> +	oob_ok = 0;
> +
> +	while (1) {
> +		if (count<  page_num || count<  oob_num) {
> +			memset(chip->buf, 0, info->page_size);
> +			retval = chip->read_page(spi_nand, info,
> +				page_id + count, 0, info->page_size,
> +					chip->buf);
> +			if (retval != 0) {
> +				errcode = -1;
> +				pr_info(KERN_INFO
> +					"spinand_read_ops: fail, page=%d!\n",
> +						page_id);
> +				return errcode;
> +			}
> +		} else {
> +			break;
> +		}
> +		if (count<  page_num&&  ops->datbuf) {
> +			int size;
> +
> +#ifdef CONFIG_MTD_SPINAND_SWECC
> +			retval = spinand_correct_data(mtd);
> +			if (retval == -1)
> +				pr_info(KERN_INFO
> +					"SWECC uncorrectable error! page=%x\n",
> +					page_id+count);
> +			else if (retval == 1)
> +				pr_info(KERN_INFO
> +					"SWECC 1 bit error, corrected! page=%x\n",
> +					page_id+count);
> +#endif
> +
> +			if ((main_offset + main_left)<  info->page_main_size)
> +				size = main_left;
> +			else
> +				size = info->page_main_size - main_offset;
> +
> +			memcpy(ops->datbuf + main_ok, chip->buf, size);
> +
> +			main_ok += size;
> +			main_left -= size;
> +			main_offset = 0;
> +			ops->retlen = main_ok;
> +		}
> +
> +		if (count<  oob_num&&  ops->oobbuf&&  chip->oobbuf) {
> +			int size;
> +			int offset, len, temp;
> +
> +			/* repack spare to oob */
> +			memset(chip->oobbuf, 0, info->ecclayout->oobavail);
> +
> +			temp = 0;
> +			offset = info->ecclayout->oobfree[0].offset;
> +			len = info->ecclayout->oobfree[0].length;
> +			memcpy(chip->oobbuf + temp,
> +				chip->buf + info->page_main_size + offset, len);
> +
> +			temp += len;
> +			offset = info->ecclayout->oobfree[1].offset;
> +			len = info->ecclayout->oobfree[1].length;
> +			memcpy(chip->oobbuf + temp,
> +				chip->buf + info->page_main_size + offset, len);
> +
> +			temp += len;
> +			offset = info->ecclayout->oobfree[2].offset;
> +			len = info->ecclayout->oobfree[2].length;
> +			memcpy(chip->oobbuf + temp,
> +				chip->buf + info->page_main_size + offset, len);
> +
> +			temp += len;
> +			offset = info->ecclayout->oobfree[3].offset;
> +			len = info->ecclayout->oobfree[3].length;
> +			memcpy(chip->oobbuf + temp,
> +				chip->buf + info->page_main_size + offset, len);
> +
> +			/* copy oobbuf to ops oobbuf */
> +			if (oob_left<  info->ecclayout->oobavail)
> +				size = oob_left;
> +			else
> +				size = info->ecclayout->oobavail;
> +
> +			memcpy(ops->oobbuf + oob_ok, chip->oobbuf, size);
> +
> +			oob_ok += size;
> +			oob_left -= size;
> +
> +			ops->oobretlen = oob_ok;
> +		}
> +		count++;
> +	}
> +	return errcode;
> +}
> +
> +static int spinand_write_ops(struct mtd_info *mtd, loff_t to,
> +			 struct mtd_oob_ops *ops)
> +{
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spi_device *spi_nand = chip->spi_nand;
> +	struct spinand_info *info = chip->info;
> +	int page_id, page_offset, page_num, oob_num;
> +
> +	int count;
> +
> +	int main_ok, main_left, main_offset;
> +	int oob_ok, oob_left;
> +
> +	signed int retval;
> +	signed int errcode = 0;
> +
> +	if (!chip->buf)
> +		return -1;
> +
> +	page_id = to>>  info->page_shift;
> +
> +	/* for main data */
> +	page_offset = to&  info->page_mask;
> +	page_num = (page_offset + ops->len +
> +			info->page_main_size - 1) / info->page_main_size;
> +
> +	/* for oob */
> +	if (info->ecclayout->oobavail)
> +		oob_num = (ops->ooblen +
> +			info->ecclayout->oobavail - 1) / info->ecclayout->oobavail;
> +	else
> +		oob_num = 0;
> +
> +	count = 0;
> +
> +	main_left = ops->len;
> +	main_ok = 0;
> +	main_offset = page_offset;
> +
> +	oob_left = ops->ooblen;
> +	oob_ok = 0;
> +
> +	while (1) {
> +		if (count<  page_num || count<  oob_num)
> +			memset(chip->buf, 0xFF, info->page_size);
> +		else
> +			break;
> +
> +		if (count<  page_num&&  ops->datbuf) {
> +			int size;
> +
> +			if ((main_offset + main_left)<  info->page_main_size)
> +				size = main_left;
> +			else
> +				size = info->page_main_size - main_offset;
> +
> +			memcpy(chip->buf, ops->datbuf + main_ok, size);
> +
> +			main_ok += size;
> +			main_left -= size;
> +			main_offset = 0;
> +
> +#ifdef CONFIG_MTD_SPINAND_SWECC
> +		spinand_calculate_ecc(mtd);
> +#endif
> +		}
> +
> +		if (count<  oob_num&&  ops->oobbuf&&  chip->oobbuf) {
> +			int size;
> +			int offset, len, temp;
> +
> +			memset(chip->oobbuf, 0xFF, info->ecclayout->oobavail);
> +
> +			if (oob_left<  info->ecclayout->oobavail)
> +				size = oob_left;
> +			else
> +				size = info->ecclayout->oobavail;
> +
> +			memcpy(chip->oobbuf, ops->oobbuf + oob_ok, size);
> +
> +			oob_ok += size;
> +			oob_left -= size;
> +
> +			/* repack oob to spare */
> +			temp = 0;
> +			offset = info->ecclayout->oobfree[0].offset;
> +			len = info->ecclayout->oobfree[0].length;
> +			memcpy(chip->buf + info->page_main_size + offset,
> +					chip->oobbuf + temp, len);
> +
> +			temp += len;
> +			offset = info->ecclayout->oobfree[1].offset;
> +			len = info->ecclayout->oobfree[1].length;
> +			memcpy(chip->buf + info->page_main_size + offset,
> +					chip->oobbuf + temp, len);
> +
> +			temp += len;
> +			offset = info->ecclayout->oobfree[2].offset;
> +			len = info->ecclayout->oobfree[2].length;
> +			memcpy(chip->buf + info->page_main_size + offset,
> +					chip->oobbuf + temp, len);
> +
> +			temp += len;
> +			offset = info->ecclayout->oobfree[3].offset;
> +			len = info->ecclayout->oobfree[3].length;
> +			memcpy(chip->buf + info->page_main_size + offset,
> +					chip->oobbuf + temp, len);
> +		}
> +
> +		if (count<  page_num || count<  oob_num) {
> +			retval = chip->program_page(spi_nand, info,
> +				page_id + count, 0, info->page_size, chip->buf);
> +			if (retval != 0) {
> +				errcode = -1;
> +				pr_err(KERN_INFO "spinand_write_ops: fail, page=%d!\n", page_id);
> +
> +				return errcode;
> +			}
> +		}
> +
> +		if (count<  page_num&&  ops->datbuf)
> +			ops->retlen = main_ok;
> +
> +		if (count<  oob_num&&  ops->oobbuf&&  chip->oobbuf)
> +			ops->oobretlen = oob_ok;
> +
> +		count++;
> +	}
> +	return errcode;
> +}
> +
> +static int spinand_read(struct mtd_info *mtd, loff_t from, size_t len,
> +	size_t *retlen, u_char *buf)
> +{
> +	struct mtd_oob_ops ops = {0};
> +	int ret;
> +
> +	/* Do not allow reads past end of device */
> +	if ((from + len)>  mtd->size)
> +		return -EINVAL;
> +
> +	if (!len)
> +		return 0;
> +
> +	spinand_get_device(mtd, FL_READING);
> +
> +	ops.len = len;
> +	ops.datbuf = buf;
> +
> +	ret = spinand_read_ops(mtd, from,&ops);
> +
> +	*retlen = ops.retlen;
> +
> +	spinand_release_device(mtd);
> +
> +	return ret;
> +}
> +
> +static int spinand_write(struct mtd_info *mtd, loff_t to, size_t len,
> +	size_t *retlen, const u_char *buf)
> +{
> +	struct mtd_oob_ops ops = {0};
> +	int ret;
> +
> +	/* Do not allow reads past end of device */
> +	if ((to + len)>  mtd->size)
> +		return -EINVAL;
> +	if (!len)
> +		return 0;
> +
> +	spinand_get_device(mtd, FL_WRITING);
> +
> +	ops.len = len;
> +	ops.datbuf = (uint8_t *)buf;
> +
> +	ret =  spinand_write_ops(mtd, to,&ops);
> +
> +	*retlen = ops.retlen;
> +
> +	spinand_release_device(mtd);
> +
> +	return ret;
> +}
> +
> +static int spinand_read_oob(struct mtd_info *mtd, loff_t from,
> +			struct mtd_oob_ops *ops)
> +{
> +	int ret;
> +
> +	spinand_get_device(mtd, FL_READING);
> +
> +	ret = spinand_read_ops(mtd, from, ops);
> +
> +	spinand_release_device(mtd);
> +	return ret;
> +}
> +
> +static int spinand_write_oob(struct mtd_info *mtd, loff_t to,
> +			  struct mtd_oob_ops *ops)
> +{
> +	int ret;
> +
> +	spinand_get_device(mtd, FL_WRITING);
> +
> +	ret = spinand_write_ops(mtd, to, ops);
> +
> +	spinand_release_device(mtd);
> +	return ret;
> +}
> +
> +/**
> + * spinand_erase - [MTD Interface] erase block(s)
> + * @param mtd		MTD device structure
> + * @param instr		erase instruction
> + *
> + * Erase one ore more blocks
> + */
> +static int spinand_erase(struct mtd_info *mtd, struct erase_info *instr)
> +{
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spi_device *spi_nand = chip->spi_nand;
> +	struct spinand_info *info = chip->info;
> +	u16 block_id, block_num, count;
> +	signed int retval = 0;
> +	signed int errcode = 0;
> +
> +	pr_info("spinand_erase: start = 0x%012llx, len = %llu\n",
> +	      (unsigned long long)instr->addr, (unsigned long long)instr->len);
> +
> +	/* check address align on block boundary */
> +	if (instr->addr&  (info->block_main_size - 1)) {
> +		pr_err("spinand_erase: Unaligned address\n");
> +		return -EINVAL;
> +	}
> +
> +	if (instr->len&  (info->block_main_size - 1)) {
> +		pr_err("spinand_erase: ""Length not block aligned\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Do not allow erase past end of device */
> +	if ((instr->len + instr->addr)>  info->usable_size) {
> +		pr_err("spinand_erase: ""Erase past end of device\n");
> +		return -EINVAL;
> +	}
> +
> +	instr->fail_addr = MTD_FAIL_ADDR_UNKNOWN;
> +
> +	/* Grab the lock and see if the device is available */
> +	spinand_get_device(mtd, FL_ERASING);
> +
> +	block_id = instr->addr>>  info->block_shift;
> +	block_num = instr->len>>  info->block_shift;
> +	count = 0;
> +
> +	while (count<  block_num) {
> +		retval = chip->erase_block(spi_nand, info, block_id + count);
> +
> +		if (retval != 0) {
> +			retval = chip->erase_block(spi_nand, info,
> +					block_id + count);
> +			if (retval != 0) {
> +				pr_info(KERN_INFO "spinand_erase: fail, block=%d!\n",
> +					block_id + count);
> +				errcode = -1;
> +			}
> +		}
> +		count++;
> +	}
> +
> +	if (errcode == 0)
> +		instr->state = MTD_ERASE_DONE;
> +
> +	/* Deselect and wake up anyone waiting on the device */
> +	spinand_release_device(mtd);
> +
> +	/* Do call back function */
> +	if (instr->callback)
> +		instr->callback(instr);
> +
> +	return errcode;
> +}
> +
> +/**
> + * spinand_sync - [MTD Interface] sync
> + * @param mtd		MTD device structure
> + *
> + * Sync is actually a wait for chip ready function
> + */
> +static void spinand_sync(struct mtd_info *mtd)
> +{
> +	pr_debug("spinand_sync: called\n");
> +
> +	/* Grab the lock and see if the device is available */
> +	spinand_get_device(mtd, FL_SYNCING);
> +
> +	/* Release it and go back */
> +	spinand_release_device(mtd);
> +}
> +
> +static int spinand_block_isbad(struct mtd_info *mtd, loff_t ofs)
> +{
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spi_device *spi_nand = chip->spi_nand;
> +	struct spinand_info *info = chip->info;
> +	u16 block_id;
> +	u8 is_bad = 0x00;
> +	u8 ret = 0;
> +
> +	spinand_get_device(mtd, FL_READING);
> +
> +	block_id = ofs>>  info->block_shift;
> +
> +	chip->read_page(spi_nand, info, block_id*info->page_num_per_block,
> +				info->page_main_size, 1,&is_bad);
> +
> +	if (is_bad != 0xFF)
> +		ret =  1;
> +
> +	spinand_release_device(mtd);
> +
> +	return ret;
> +}
> +
> +/**
> + * spinand_block_markbad - [MTD Interface] Mark bad block
> + * @param mtd		MTD device structure
> + * @param ofs       Bad block number
> + */
> +static int spinand_block_markbad(struct mtd_info *mtd, loff_t ofs)
> +{
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spi_device *spi_nand = chip->spi_nand;
> +	struct spinand_info *info = chip->info;
> +	u16 block_id;
> +	u8 is_bad = 0x00;
> +	u8 ret = 0;
> +
> +	spinand_get_device(mtd, FL_WRITING);
> +
> +	block_id = ofs>>  info->block_shift;
> +
> +	chip->program_page(spi_nand, info, block_id*info->page_num_per_block,
> +		info->page_main_size, 1,&is_bad);
> +
> +	spinand_release_device(mtd);
> +
> +	return ret;
> +}
> +
> +
> +/**
> + * spinand_suspend - [MTD Interface] Suspend the spinand flash
> + * @param mtd		MTD device structure
> + */
> +static int spinand_suspend(struct mtd_info *mtd)
> +{
> +	return spinand_get_device(mtd, FL_PM_SUSPENDED);
> +}
> +
> +/**
> + * spinand_resume - [MTD Interface] Resume the spinand flash
> + * @param mtd		MTD device structure
> + */
> +static void spinand_resume(struct mtd_info *mtd)
> +{
> +	struct spinand_chip *this = mtd->priv;
> +
> +	if (this->state == FL_PM_SUSPENDED)
> +		spinand_release_device(mtd);
> +	else
> +		pr_err(KERN_ERR "resume() called for the chip which is not" "in suspended state\n");
> +}
> +
> +/**
> + * spinand_mtd - add MTD device with parameters
> + * @param mtd		MTD device structure
> + *
> + * Add MTD device with parameters.
> + */
> +int spinand_mtd(struct mtd_info *mtd)
> +{
> +	struct spinand_chip *chip = mtd->priv;
> +	struct spinand_info *info = chip->info;
> +
> +	chip->state = FL_READY;
> +	init_waitqueue_head(&chip->wq);
> +	spin_lock_init(&chip->chip_lock);
> +
> +	mtd->name = info->name;
> +	mtd->size = info->usable_size;
> +	mtd->erasesize = info->block_main_size;
> +	mtd->writesize = info->page_main_size;
> +	mtd->oobsize = info->page_spare_size;
> +	mtd->owner = THIS_MODULE;
> +	mtd->type = MTD_NANDFLASH;
> +	mtd->flags = MTD_CAP_NANDFLASH;
> +
> +	mtd->ecclayout = info->ecclayout;
> +
> +	mtd->_erase = spinand_erase;
> +	mtd->_point = NULL;
> +	mtd->_unpoint = NULL;
> +	mtd->_read = spinand_read;
> +	mtd->_write = spinand_write;
> +	mtd->_read_oob = spinand_read_oob;
> +	mtd->_write_oob = spinand_write_oob;
> +	mtd->_sync = spinand_sync;
> +	mtd->_lock = NULL;
> +	mtd->_unlock = NULL;
> +	mtd->_suspend = spinand_suspend;
> +	mtd->_resume = spinand_resume;
> +	mtd->_block_isbad = spinand_block_isbad;
> +	mtd->_block_markbad = spinand_block_markbad;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(spinand_mtd);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Henry Pan<hspan@micron.com>");
> diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
> new file mode 100644
> index 0000000..3b8802a
> --- /dev/null
> +++ b/include/linux/mtd/spinand.h
> @@ -0,0 +1,155 @@
> +/*
> + *  linux/include/linux/mtd/spinand.h
> + *  Copyright (c) 2009-2010 Micron Technology, Inc.
> + *  This software is licensed under the terms of the GNU General Public
> + *  License version 2, as published by the Free Software Foundation, and
> + *  may be copied, distributed, and modified under those terms.
> +
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> +/bin/bash: 4: command not found
> + *
> + *  based on nand.h
> + */
> +#ifndef __LINUX_MTD_SPI_NAND_H
> +#define __LINUX_MTD_SPI_NAND_H
> +
> +#include<linux/wait.h>
> +#include<linux/spinlock.h>
> +#include<linux/mtd/mtd.h>
> +
> +/* cmd */
> +#define CMD_READ				0x13
> +#define CMD_READ_RDM			0x03
> +#define CMD_PROG_PAGE_CLRCACHE	0x02
> +#define CMD_PROG_PAGE			0x84
> +#define CMD_PROG_PAGE_EXC		0x10
> +#define CMD_ERASE_BLK			0xd8
> +#define CMD_WR_ENABLE			0x06
> +#define CMD_WR_DISABLE			0x04
> +#define CMD_READ_ID			0x9f
> +#define CMD_RESET				0xff
> +#define CMD_READ_REG			0x0f
> +#define CMD_WRITE_REG			0x1f
> +
> +/* feature/ status reg */
> +#define REG_BLOCK_LOCK		0xa0
> +#define REG_OTP				0xb0
> +#define REG_STATUS			0xc0/* timing */
> +
> +/* status */
> +#define STATUS_OIP_MASK		0x01
> +#define STATUS_READY		(0<<  0)
> +#define STATUS_BUSY			(1<<  0)
> +
> +#define STATUS_E_FAIL_MASK	0x04
> +#define STATUS_E_FAIL		(1<<  2)
> +
> +#define STATUS_P_FAIL_MASK	0x08
> +#define STATUS_P_FAIL		(1<<  3)
> +
> +#define STATUS_ECC_MASK		0x30
> +#define STATUS_ECC_1BIT_CORRECTED	(1<<  4)
> +#define STATUS_ECC_ERROR			(2<<  4)
> +#define STATUS_ECC_RESERVED			(3<<  4)
> +
> +
> +/*ECC enable defines*/
> +#define OTP_ECC_MASK		0x10
> +#define OTP_ECC_OFF			0
> +#define OTP_ECC_ON			1
> +
> +#define ECC_DISABLED
> +#define ECC_IN_NAND
> +#define ECC_SOFT
> +
> +/* block lock */
> +#define BL_ALL_LOCKED      0x38
> +#define BL_1_2_LOCKED      0x30
> +#define BL_1_4_LOCKED      0x28
> +#define BL_1_8_LOCKED      0x20
> +#define BL_1_16_LOCKED     0x18
> +#define BL_1_32_LOCKED     0x10
> +#define BL_1_64_LOCKED     0x08
> +#define BL_ALL_UNLOCKED    0
> +
> +struct spinand_info {
> +	u8		mid;
> +	u8		did;
> +	char		*name;
> +	u64		nand_size;
> +	u64		usable_size;
> +
> +	u32		block_size;
> +	u32		block_main_size;
> +	/*u32		block_spare_size; */
> +	u16		block_num_per_chip;
> +	u16		page_size;
> +	u16		page_main_size;
> +	u16		page_spare_size;
> +	u16		page_num_per_block;
> +	u8		block_shift;
> +	u32		block_mask;
> +	u8		page_shift;
> +	u16		page_mask;
> +
> +	struct nand_ecclayout *ecclayout;
> +};
> +
> +typedef enum {
> +	FL_READY,
> +	FL_READING,
> +	FL_WRITING,
> +	FL_ERASING,
> +	FL_SYNCING,
> +	FL_LOCKING,
> +	FL_RESETING,
> +	FL_OTPING,
> +	FL_PM_SUSPENDED,
> +} spinand_state_t;
> +
> +struct spinand_chip { /* used for multi chip */
> +	spinlock_t		chip_lock;
> +	wait_queue_head_t wq;
> +	spinand_state_t	state;
> +	struct spi_device	*spi_nand;
> +	struct spinand_info *info;
> +	/*struct mtd_info	*mtd; */
> +
> +	int (*reset) (struct spi_device *spi_nand);
> +	int (*read_id) (struct spi_device *spi_nand, u8 *id);
> +	int (*read_page) (struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 page_id, u16 offset,
> +		u16 len, u8 *rbuf);
> +	int (*program_page) (struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 page_id, u16 offset,
> +		u16 len, u8 *wbuf);
> +	int (*erase_block) (struct spi_device *spi_nand,
> +		struct spinand_info *info, u16 block_id);
> +
> +	u8 *buf;
> +	u8 *oobbuf; /* temp buffer */
> +
> +#ifdef CONFIG_MTD_SPINAND_SWECC
> +	u8 ecc_calc[12];
> +	u8 ecc_code[12];
> +#endif
> +};
> +
> +struct spinand_cmd {
> +	u8 cmd;
> +	unsigned n_addr;
> +	u8 addr[3];
> +	unsigned n_dummy;
> +	unsigned n_tx;
> +	u8 *tx_buf;
> +	unsigned n_rx;
> +	u8 *rx_buf;
> +};
> +
> +extern int spinand_mtd(struct mtd_info *mtd);
> +extern void spinand_mtd_release(struct mtd_info *mtd);
> +
> +#endif

