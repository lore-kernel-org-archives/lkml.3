Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaANNEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:04:38 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:45996 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaANNEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:04:32 -0500
Date: Tue, 14 Jan 2014 13:04:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140114130409.GB11820@lee--X1>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389685656-880-2-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB card reader provides a channel to transfer command or data to flash
> memory cards. This driver exports host instances for mmc and memstick subsystems
> and handles basic works.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mfd/Kconfig          |  10 +
>  drivers/mfd/Makefile         |   1 +
>  drivers/mfd/rtsx_usb.c       | 788 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rtsx_usb.h | 619 +++++++++++++++++++++++++++++++++
>  4 files changed, 1418 insertions(+)
>  create mode 100644 drivers/mfd/rtsx_usb.c
>  create mode 100644 include/linux/mfd/rtsx_usb.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b7c74a7..4c99ebd 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -507,6 +507,16 @@ config MFD_RTSX_PCI
>  	  types of memory cards, such as Memory Stick, Memory Stick Pro,
>  	  Secure Digital and MultiMediaCard.
>  
> +config MFD_RTSX_USB
> +	tristate "Realtek USB card reader"
> +	depends on USB
> +	select MFD_CORE
> +	help
> +	Select this option to get support for Realtek USB 2.0 card readers
> +	including RTS5129, RTS5139, RTS5179 and RTS5170.
> +	Realtek card reader supports access to many types of memory cards,
> +	such as Memory Stick Pro, Secure Digital and MultiMediaCard.
> +

The help section should be indented by 2 spaces.

>  config MFD_RC5T583
>  	bool "Ricoh RC5T583 Power Management system device"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 8a28dc9..33b8de6 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
>  
>  rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
>  obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
> +obj-$(CONFIG_MFD_RTSX_USB)	+= rtsx_usb.o
>  
>  obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
>  obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> new file mode 100644
> index 0000000..905ec8d
> --- /dev/null
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -0,0 +1,788 @@
> +/* Driver for Realtek USB card reader
> + *
> + * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * Author:
> + *   Roger Tseng <rogerable@realtek.com>
> + */
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/usb.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/core.h>
> +#include <asm/unaligned.h>
> +#include <linux/mfd/rtsx_usb.h>
> +
> +static int polling_pipe = 1;
> +module_param(polling_pipe, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(polling_pipe, "polling pipe (0: ctl, 1: bulk)");

'/n' here.

> +static struct mfd_cell rtsx_usb_cells[] = {
> +	[RTSX_USB_SD_CARD] = {
> +		.name = DRV_NAME_RTSX_USB_SDMMC,
> +	},
> +	[RTSX_USB_MS_CARD] = {
> +		.name = DRV_NAME_RTSX_USB_MS,
> +	},
> +};

I'm not entirely convinced that this is an MFD device?

> +static void rtsx_usb_sg_timed_out(unsigned long data)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)data;

What's going to happen when your device runs 64bit?

> +	dev_dbg(&ucr->pusb_intf->dev, "%s: sg transfer timed out", __func__);
> +	usb_sg_cancel(&ucr->current_sg);

Are you sure this needs to live here?

Why isn't this in drivers/usb?

> +	/* we know the cancellation is caused by time-out */
> +	ucr->current_sg.status = -ETIMEDOUT;
> +}
> +
> +static int rtsx_usb_bulk_transfer_sglist(struct rtsx_ucr *ucr,
> +		unsigned int pipe, struct scatterlist *sg, int num_sg,
> +		unsigned int length, unsigned int *act_len, int timeout)
> +{
> +	int ret;
> +
> +	dev_dbg(&ucr->pusb_intf->dev, "%s: xfer %u bytes, %d entries\n",
> +			__func__, length, num_sg);
> +	ret = usb_sg_init(&ucr->current_sg, ucr->pusb_dev, pipe, 0,
> +			sg, num_sg, length, GFP_NOIO);
> +	if (ret)
> +		return ret;
> +
> +	ucr->sg_timer.expires = jiffies + msecs_to_jiffies(timeout);
> +	add_timer(&ucr->sg_timer);
> +	usb_sg_wait(&ucr->current_sg);
> +	del_timer(&ucr->sg_timer);
> +
> +	if (act_len)
> +		*act_len = ucr->current_sg.bytes;
> +
> +	return ucr->current_sg.status;
> +}

Code looks fine, but shouldn't this live an a USB driver?

> +int rtsx_usb_transfer_data(struct rtsx_ucr *ucr, unsigned int pipe,
> +			      void *buf, unsigned int len, int num_sg,
> +			      unsigned int *act_len, int timeout)
> +{
> +	if (timeout < 600)
> +		timeout = 600;
> +
> +	if (num_sg)
> +		return rtsx_usb_bulk_transfer_sglist(ucr, pipe,
> +				(struct scatterlist *)buf, num_sg, len, act_len,
> +				timeout);
> +	else
> +		return usb_bulk_msg(ucr->pusb_dev, pipe, buf, len, act_len,
> +				timeout);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_transfer_data);
> +
> +static int rtsx_usb_seq_write_register(struct rtsx_ucr *ucr,
> +		u16 addr, u16 len, u8 *data)
> +{
> +	u16 cmd_len = len + 12;

Why 12? Please #define.

> +	if (data == NULL)

if (!data)

> +		return -EINVAL;
> +
> +	if (cmd_len > IOBUF_SIZE)
> +		return -EINVAL;
> +
> +	if (cmd_len % 4)
> +		cmd_len += (4 - cmd_len % 4);

Please document in a comment.

> +
> +

Extra '/n'

> +	ucr->cmd_buf[0] = 'R';
> +	ucr->cmd_buf[1] = 'T';
> +	ucr->cmd_buf[2] = 'C';
> +	ucr->cmd_buf[3] = 'R';
> +	ucr->cmd_buf[PACKET_TYPE] = SEQ_WRITE;
> +	ucr->cmd_buf[5] = (u8)(len >> 8);
> +	ucr->cmd_buf[6] = (u8)len;
> +	ucr->cmd_buf[STAGE_FLAG] = 0;
> +	ucr->cmd_buf[8] = (u8)(addr >> 8);
> +	ucr->cmd_buf[9] = (u8)addr;

I think someone said there are kernel macros for this stuff.

> +	memcpy(ucr->cmd_buf + 12, data, len);
> +
> +	return rtsx_usb_transfer_data(ucr,
> +			usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
> +			ucr->cmd_buf, cmd_len, 0, NULL, 100);

Still think it should be a USB driver!

> +}
> +
> +static int rtsx_usb_seq_read_register(struct rtsx_ucr *ucr,
> +		u16 addr, u16 len, u8 *data)
> +{
> +	int i, ret;
> +	u16 rsp_len, res_len;
> +
> +	if (data == NULL)

if (!data)

> +		return -EINVAL;
> +
> +	res_len = len % 4;
> +	rsp_len = len - res_len;
> +
> +	/* 4-byte aligned part */
> +	if (rsp_len) {
> +		ucr->cmd_buf[0] = 'R';
> +		ucr->cmd_buf[1] = 'T';
> +		ucr->cmd_buf[2] = 'C';
> +		ucr->cmd_buf[3] = 'R';
> +		ucr->cmd_buf[PACKET_TYPE] = SEQ_READ;
> +		ucr->cmd_buf[5] = (u8)(rsp_len >> 8);
> +		ucr->cmd_buf[6] = (u8)rsp_len;
> +		ucr->cmd_buf[STAGE_FLAG] = STAGE_R;
> +		ucr->cmd_buf[8] = (u8)(addr >> 8);
> +		ucr->cmd_buf[9] = (u8)addr;

This looks the same as above. If so, please place in a function.

> +		ret = rtsx_usb_transfer_data(ucr,
> +				usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
> +				ucr->cmd_buf, 12, 0, NULL, 100);
> +		if (ret)
> +			return ret;
> +
> +		ret = rtsx_usb_transfer_data(ucr,
> +				usb_rcvbulkpipe(ucr->pusb_dev, EP_BULK_IN),
> +				data, rsp_len, 0, NULL, 100);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* unaligned part */
> +	for (i = 0; i < res_len; i++) {
> +		ret = rtsx_usb_read_register(ucr, addr + rsp_len + i,
> +				data + rsp_len + i);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

'/n' here.

> +int rtsx_usb_read_ppbuf(struct rtsx_ucr *ucr, u8 *buf, int buf_len)
> +{
> +	return rtsx_usb_seq_read_register(ucr, PPBUF_BASE2, (u16)buf_len, buf);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_read_ppbuf);
> +
> +int rtsx_usb_write_ppbuf(struct rtsx_ucr *ucr, u8 *buf, int buf_len)
> +{
> +	return rtsx_usb_seq_write_register(ucr, PPBUF_BASE2, (u16)buf_len, buf);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_write_ppbuf);
> +
> +int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
> +		u8 mask, u8 data)
> +{
> +	u16 value = 0, index = 0;
> +
> +	value |= 0x03 << 14;
> +	value |= addr & 0x3FFF;
> +	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
> +	index |= (u16)mask;
> +	index |= (u16)data << 8;

Lots of random numbers here, please #define for clarity and ease of
reading.

> +	return usb_control_msg(ucr->pusb_dev,
> +			usb_sndctrlpipe(ucr->pusb_dev, 0), 0, 0x40,
> +			value, index, NULL, 0, 100);

Same here.

> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_ep0_write_register);
> +
> +int rtsx_usb_ep0_read_register(struct rtsx_ucr *ucr, u16 addr, u8 *data)
> +{
> +	u16 value = 0;
> +
> +	if (data == NULL)

if (!data), etc

> +		return -EINVAL;
> +	*data = 0;
> +
> +	value |= 0x02 << 14;
> +	value |= addr & 0x3FFF;
> +	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);

Less random numbers for #defines please, etc.

> +	return usb_control_msg(ucr->pusb_dev,
> +			usb_rcvctrlpipe(ucr->pusb_dev, 0), 0, 0xC0,
> +			value, 0, data, 1, 100);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_ep0_read_register);
> +
> +void rtsx_usb_add_cmd(struct rtsx_ucr *ucr,
> +		    u8 cmd_type,
> +		    u16 reg_addr,
> +		    u8 mask,
> +		    u8 data)

This is a strange way of organising your function params.

> +{
> +	int i;
> +
> +	if (ucr->cmd_idx < ((IOBUF_SIZE - CMD_OFFSET) / 4)) {

I think you can drop a layer of ()'s here.

> +		i = CMD_OFFSET + ucr->cmd_idx * 4;
> +
> +		ucr->cmd_buf[i++] = ((cmd_type & 0x03) << 6) |
> +			(u8)((reg_addr >> 8) & 0x3F);
> +		ucr->cmd_buf[i++] = (u8)reg_addr;
> +		ucr->cmd_buf[i++] = mask;
> +		ucr->cmd_buf[i++] = data;
> +
> +		ucr->cmd_idx++;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_add_cmd);
> +
> +int rtsx_usb_send_cmd(struct rtsx_ucr *ucr, u8 flag, int timeout)
> +{
> +	int ret;
> +
> +	ucr->cmd_buf[CNT_H] = (u8)(ucr->cmd_idx >> 8);
> +	ucr->cmd_buf[CNT_L] = (u8)(ucr->cmd_idx);
> +	ucr->cmd_buf[STAGE_FLAG] = flag;
> +
> +	ret = rtsx_usb_transfer_data(ucr,
> +			usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
> +			ucr->cmd_buf, ucr->cmd_idx * 4 + CMD_OFFSET,
> +			0, NULL, timeout);
> +	if (ret) {
> +		rtsx_usb_clear_fsm_err(ucr);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_send_cmd);
> +
> +int rtsx_usb_get_rsp(struct rtsx_ucr *ucr, int rsp_len, int timeout)
> +{
> +	if (rsp_len <= 0)
> +		return -EINVAL;
> +
> +	if (rsp_len % 4)
> +		rsp_len += (4 - rsp_len % 4);

Please document.

> +	return rtsx_usb_transfer_data(ucr,
> +			usb_rcvbulkpipe(ucr->pusb_dev, EP_BULK_IN),
> +			ucr->rsp_buf, rsp_len, 0, NULL, timeout);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_get_rsp);
> +
> +static int rtsx_usb_get_status_with_bulk(struct rtsx_ucr *ucr, u16 *status)
> +{
> +	int ret;
> +
> +	rtsx_usb_init_cmd(ucr);
> +	rtsx_usb_add_cmd(ucr, READ_REG_CMD, CARD_EXIST, 0x00, 0x00);
> +	rtsx_usb_add_cmd(ucr, READ_REG_CMD, OCPSTAT, 0x00, 0x00);
> +	ret = rtsx_usb_send_cmd(ucr, MODE_CR, 100);
> +	if (ret)
> +		return ret;
> +
> +	ret = rtsx_usb_get_rsp(ucr, 2, 100);
> +	if (ret)
> +		return ret;
> +
> +	*status = ((ucr->rsp_buf[0] >> 2) & 0x0f) |
> +		  ((ucr->rsp_buf[1] & 0x03) << 4);
> +
> +	return 0;
> +}
> +
> +int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status)
> +{
> +	int ret;
> +
> +	if (status == NULL)
> +		return -EINVAL;
> +
> +	if (polling_pipe == 0)
> +		ret = usb_control_msg(ucr->pusb_dev,
> +				usb_rcvctrlpipe(ucr->pusb_dev, 0),
> +				0x02, 0xC0, 0, 0, status, 2, 100);
> +	else
> +		ret = rtsx_usb_get_status_with_bulk(ucr, status);
> +
> +	/* usb_control_msg may return positive when success */
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_get_card_status);
> +
> +static int rtsx_usb_write_phy_register(struct rtsx_ucr *ucr, u8 addr, u8 val)
> +{
> +	dev_dbg(&ucr->pusb_intf->dev, "Write 0x%x to phy register 0x%x\n",
> +			val, addr);
> +
> +	rtsx_usb_init_cmd(ucr);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VSTAIN, 0xFF, val);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VCONTROL, 0xFF, addr & 0x0F);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x01);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VCONTROL,
> +			0xFF, (addr >> 4) & 0x0F);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x01);
> +
> +	return rtsx_usb_send_cmd(ucr, MODE_C, 100);
> +}
> +
> +int rtsx_usb_write_register(struct rtsx_ucr *ucr, u16 addr, u8 mask, u8 data)
> +{
> +	rtsx_usb_init_cmd(ucr);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, addr, mask, data);
> +	return rtsx_usb_send_cmd(ucr, MODE_C, 100);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_write_register);
> +
> +int rtsx_usb_read_register(struct rtsx_ucr *ucr, u16 addr, u8 *data)
> +{
> +	int ret;
> +
> +	if (data != NULL)
> +		*data = 0;
> +
> +	rtsx_usb_init_cmd(ucr);
> +	rtsx_usb_add_cmd(ucr, READ_REG_CMD, addr, 0, 0);
> +	ret = rtsx_usb_send_cmd(ucr, MODE_CR, 100);
> +	if (ret)
> +		return ret;
> +
> +	ret = rtsx_usb_get_rsp(ucr, 1, 100);
> +	if (ret)
> +		return ret;
> +
> +	if (data != NULL)
> +		*data = ucr->rsp_buf[0];
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_read_register);
> +
> +static inline u8 double_ssc_depth(u8 depth)
> +{
> +	return ((depth > 1) ? (depth - 1) : depth);

You can drop a layer of ()'s here too.

> +}
> +
> +static u8 revise_ssc_depth(u8 ssc_depth, u8 div)
> +{
> +	if (div > CLK_DIV_1) {
> +		if (ssc_depth > (div - 1))

And here, etc.

> +			ssc_depth -= (div - 1);
> +		else
> +			ssc_depth = SSC_DEPTH_2M;
> +	}
> +
> +	return ssc_depth;
> +}
> +
> +int rtsx_usb_switch_clock(struct rtsx_ucr *ucr, unsigned int card_clock,
> +		u8 ssc_depth, bool initial_mode, bool double_clk, bool vpclk)
> +{
> +	int ret;
> +	u8 n, clk_divider, mcu_cnt, div;
> +
> +	if (!card_clock) {
> +		ucr->cur_clk = 0;
> +		return 0;
> +	}
> +
> +	if (initial_mode) {
> +		/* We use 250k(around) here, in initial stage */
> +		clk_divider = SD_CLK_DIVIDE_128;
> +		card_clock = 30000000;
> +	} else {
> +		clk_divider = SD_CLK_DIVIDE_0;
> +	}
> +
> +	ret = rtsx_usb_write_register(ucr, SD_CFG1,
> +			SD_CLK_DIVIDE_MASK, clk_divider);
> +	if (ret < 0)
> +		return ret;
> +
> +	card_clock /= 1000000;
> +	dev_dbg(&ucr->pusb_intf->dev,
> +			"Switch card clock to %dMHz\n", card_clock);
> +
> +	if (!initial_mode && double_clk)
> +		card_clock *= 2;
> +	dev_dbg(&ucr->pusb_intf->dev,
> +			"Internal SSC clock: %dMHz (cur_clk = %d)\n",
> +			card_clock, ucr->cur_clk);
> +
> +	if (card_clock == ucr->cur_clk)
> +		return 0;
> +
> +	/* Converting clock value into internal settings: n and div */
> +	n = card_clock - 2;
> +	if ((card_clock <= 2) || (n > MAX_DIV_N))
> +		return -EINVAL;
> +
> +	mcu_cnt = 60/card_clock + 3;
> +	if (mcu_cnt > 15)
> +		mcu_cnt = 15;
> +
> +	/* Make sure that the SSC clock div_n is not less than MIN_DIV_N */
> +
> +	div = CLK_DIV_1;
> +	while (n < MIN_DIV_N && div < CLK_DIV_4) {
> +		n = (n + 2) * 2 - 2;
> +		div++;
> +	}
> +	dev_dbg(&ucr->pusb_intf->dev, "n = %d, div = %d\n", n, div);
> +
> +	if (double_clk)
> +		ssc_depth = double_ssc_depth(ssc_depth);
> +
> +	ssc_depth = revise_ssc_depth(ssc_depth, div);
> +	dev_dbg(&ucr->pusb_intf->dev, "ssc_depth = %d\n", ssc_depth);
> +
> +	rtsx_usb_init_cmd(ucr);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CLK_DIV, CLK_CHANGE, CLK_CHANGE);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CLK_DIV,
> +			0x3F, (div << 4) | mcu_cnt);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_CTL1, SSC_RSTB, 0);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_CTL2,
> +			SSC_DEPTH_MASK, ssc_depth);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_DIV_N_0, 0xFF, n);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_CTL1, SSC_RSTB, SSC_RSTB);
> +	if (vpclk) {
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SD_VPCLK0_CTL,
> +				PHASE_NOT_RESET, 0);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SD_VPCLK0_CTL,
> +				PHASE_NOT_RESET, PHASE_NOT_RESET);
> +	}
> +
> +	ret = rtsx_usb_send_cmd(ucr, MODE_C, 2000);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = rtsx_usb_write_register(ucr, SSC_CTL1, 0xff,
> +			SSC_RSTB | SSC_8X_EN | SSC_SEL_4M);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Wait SSC clock stable */
> +	usleep_range(100, 1000);
> +
> +	ret = rtsx_usb_write_register(ucr, CLK_DIV, CLK_CHANGE, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ucr->cur_clk = card_clock;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_switch_clock);
> +
> +int rtsx_usb_card_exclusive_check(struct rtsx_ucr *ucr, int card)
> +{
> +	int ret;
> +	u16 val;
> +	u16 cd_mask[] = {
> +		[RTSX_USB_SD_CARD] = (CD_MASK & ~SD_CD),
> +		[RTSX_USB_MS_CARD] = (CD_MASK & ~MS_CD)
> +	};
> +
> +	ret = rtsx_usb_get_card_status(ucr, &val);
> +	/*
> +	 * If get status fails, return 0 (ok) for the exclusive check
> +	 * and let the flow fail at somewhere else.
> +	 */
> +	if (ret)
> +		return 0;
> +
> +	if (val & cd_mask[card])
> +		return -EIO;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_card_exclusive_check);
> +
> +static int rtsx_usb_reset_chip(struct rtsx_ucr *ucr)
> +{
> +	int ret;
> +	u8 val;
> +
> +	rtsx_usb_init_cmd(ucr);
> +
> +	if (CHECK_PKG(ucr, LQFP48)) {
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PWR_CTL,
> +				LDO3318_PWR_MASK, LDO_SUSPEND);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PWR_CTL,
> +				FORCE_LDO_POWERB, FORCE_LDO_POWERB);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL1,
> +				0x30, 0x10);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL5,
> +				0x03, 0x01);
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL6,
> +				0x0C, 0x04);
> +	}
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SYS_DUMMY0, NYET_MSAK, NYET_EN);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CD_DEGLITCH_WIDTH, 0xFF, 0x08);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +			CD_DEGLITCH_EN, XD_CD_DEGLITCH_EN, 0x0);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SD30_DRIVE_SEL,
> +			SD30_DRIVE_MASK, DRIVER_TYPE_D);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +			CARD_DRIVE_SEL, SD20_DRIVE_MASK, 0x0);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, LDO_POWER_CFG, 0xE0, 0x0);
> +
> +	if (ucr->is_rts5179)
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				CARD_PULL_CTL5, 0x03, 0x01);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_DMA1_CTL,
> +		       EXTEND_DMA1_ASYNC_SIGNAL, EXTEND_DMA1_ASYNC_SIGNAL);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_INT_PEND,
> +			XD_INT | MS_INT | SD_INT,
> +			XD_INT | MS_INT | SD_INT);
> +
> +	ret = rtsx_usb_send_cmd(ucr, MODE_C, 100);
> +	if (ret)
> +		return ret;
> +
> +	/* config non-crystal mode */
> +	rtsx_usb_read_register(ucr, CFG_MODE, &val);
> +	if ((val & XTAL_FREE) || ((val & CLK_MODE_MASK) == CLK_MODE_NON_XTAL)) {
> +		ret = rtsx_usb_write_phy_register(ucr, 0xC2, 0x7C);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rtsx_usb_init_chip(struct rtsx_ucr *ucr)
> +{
> +	int ret;
> +	u8 val;
> +
> +	rtsx_usb_clear_fsm_err(ucr);
> +
> +	/* power on SSC*/

White space error.

> +	ret = rtsx_usb_write_register(ucr,
> +			FPDCTL, SSC_POWER_MASK, SSC_POWER_ON);
> +	if (ret)
> +		return ret;
> +
> +	usleep_range(100, 1000);
> +	ret = rtsx_usb_write_register(ucr, CLK_DIV, CLK_CHANGE, 0x00);
> +	if (ret)
> +		return ret;
> +
> +	/* determine IC version */
> +	ret = rtsx_usb_read_register(ucr, HW_VERSION, &val);
> +	if (ret)
> +		return ret;
> +
> +	ucr->ic_version = val & HW_VER_MASK;
> +
> +	/* determine package */
> +	ret = rtsx_usb_read_register(ucr, CARD_SHARE_MODE, &val);
> +	if (ret)
> +		return ret;

'/n' here.

> +	if (val & CARD_SHARE_LQFP_SEL) {
> +		ucr->package = LQFP48;
> +		dev_dbg(&ucr->pusb_intf->dev, "Package: LQFP48\n");
> +	} else {
> +		ucr->package = QFN24;
> +		dev_dbg(&ucr->pusb_intf->dev, "Package: QFN24\n");
> +	}
> +
> +	/* determine IC variations */
> +	rtsx_usb_read_register(ucr, CFG_MODE_1, &val);
> +	if (val & RTS5179) {
> +		ucr->is_rts5179 = 1;
> +		dev_dbg(&ucr->pusb_intf->dev, "Device is rts5179\n");
> +	} else {
> +		ucr->is_rts5179 = 0;

These are better as bools I think.

> +	}
> +
> +	ret = rtsx_usb_reset_chip(ucr);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

Just
  return rtsx_usb_reset_chip(ucr);

> +}
> +
> +static int rtsx_usb_probe(struct usb_interface *intf,
> +			 const struct usb_device_id *id)
> +{
> +	struct usb_device *usb_dev = interface_to_usbdev(intf);
> +	struct rtsx_ucr *ucr;
> +	int i;
> +	int ret;
> +
> +	dev_dbg(&intf->dev,
> +		": Realtek USB Card Reader found at bus %03d address %03d\n",
> +		 usb_dev->bus->busnum, usb_dev->devnum);
> +
> +	ucr = kzalloc(sizeof(struct rtsx_ucr), GFP_KERNEL);

s/struct rtsx_ucr/*ucr/

Any reason for not using managed resources?

> +	if (!ucr)
> +		return -ENOMEM;
> +
> +	ucr->pusb_dev = usb_dev;
> +
> +	/* alloc coherent buffer */
> +	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
> +			GFP_KERNEL, &ucr->iobuf_dma);
> +	if (!ucr->iobuf) {
> +		ret = -ENOMEM;
> +		goto out_free_chip;

No need to do this if you use managed resources.

> +	}
> +
> +	/* set USB interface data */
> +	usb_set_intfdata(intf, ucr);
> +
> +	ucr->vendor_id = id->idVendor;
> +	ucr->product_id = id->idProduct;
> +	ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
> +
> +	mutex_init(&ucr->dev_mutex);
> +
> +	ucr->pusb_intf = intf;
> +
> +	/* initialize */
> +	ret = rtsx_usb_init_chip(ucr);
> +	if (ret)
> +		goto out_init_fail;
> +
> +	for (i = 0; i < ARRAY_SIZE(rtsx_usb_cells); i++) {
> +		rtsx_usb_cells[i].platform_data = &ucr;

You've already put this in your drvdata (or ntfdata, as it's called
here). Why do you also need it in platform_data?

> +		rtsx_usb_cells[i].pdata_size = sizeof(*ucr);
> +	}
> +	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
> +			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
> +	if (ret)
> +		goto out_init_fail;
> +	/* initialize USB SG transfer timer */
> +	init_timer(&ucr->sg_timer);
> +	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
> +#ifdef CONFIG_PM
> +	intf->needs_remote_wakeup = 1;
> +	usb_enable_autosuspend(usb_dev);
> +#endif
> +
> +	return 0;
> +
> +out_init_fail:
> +	usb_set_intfdata(ucr->pusb_intf, NULL);

No need to do this, it's taken care of elsewhere.

> +	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
> +			ucr->iobuf_dma);
> +
> +out_free_chip:
> +	kfree(ucr);
> +	dev_err(&intf->dev, "%s failed\n", __func__);
> +	return ret;
> +}
> +
> +static void rtsx_usb_disconnect(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	dev_dbg(&intf->dev, "%s called\n", __func__);
> +
> +	mfd_remove_devices(&intf->dev);
> +
> +	usb_set_intfdata(ucr->pusb_intf, NULL);
> +	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
> +			ucr->iobuf_dma);
> +
> +	kfree(ucr);
> +}
> +
> +#ifdef CONFIG_PM
> +static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct rtsx_ucr *ucr =
> +		(struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
> +			__func__, message.event);
> +
> +	mutex_lock(&ucr->dev_mutex);
> +	rtsx_usb_turn_off_led(ucr);

That's it? That's all you do during suspend? :)

> +	mutex_unlock(&ucr->dev_mutex);
> +	return 0;
> +}
> +
> +static int rtsx_usb_resume(struct usb_interface *intf)
> +{

Don't you want to turn the LED back on here?

Or will that happen automatically when you write/read to/from it again?

> +	return 0;
> +}
> +
> +static int rtsx_usb_reset_resume(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr =
> +		(struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	rtsx_usb_reset_chip(ucr);
> +	return 0;
> +}
> +
> +#else /* CONFIG_PM */
> +
> +#define rtsx_usb_suspend NULL
> +#define rtsx_usb_resume NULL
> +#define rtsx_usb_reset_resume NULL
> +
> +#endif /* CONFIG_PM */
> +
> +
> +static int rtsx_usb_pre_reset(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	mutex_lock(&ucr->dev_mutex);

Is this normal?

> +	return 0;
> +}
> +
> +static int rtsx_usb_post_reset(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	mutex_unlock(&ucr->dev_mutex);
> +	return 0;
> +}
> +
> +static struct usb_device_id rtsx_usb_usb_ids[] = {
> +	{ USB_DEVICE(0x0BDA, 0x0129) },
> +	{ USB_DEVICE(0x0BDA, 0x0139) },
> +	{ USB_DEVICE(0x0BDA, 0x0140) },
> +	{ }
> +};
> +
> +static struct usb_driver rtsx_usb_driver = {
> +	.name =		DRV_NAME_RTSX_USB,
> +	.probe =	rtsx_usb_probe,
> +	.disconnect =	rtsx_usb_disconnect,
> +	.suspend =	rtsx_usb_suspend,
> +	.resume =	rtsx_usb_resume,
> +	.reset_resume =	rtsx_usb_reset_resume,
> +	.pre_reset =	rtsx_usb_pre_reset,
> +	.post_reset =	rtsx_usb_post_reset,
> +	.id_table =	rtsx_usb_usb_ids,
> +	.supports_autosuspend = 1,
> +	.soft_unbind =	1,

Better if you line up from the ='s I think:

static struct usb_driver rtsx_usb_driver = {
	.name         =	DRV_NAME_RTSX_USB,
	.probe        =	rtsx_usb_probe,
	.disconnect   =	rtsx_usb_disconnect,
	.suspend      =	rtsx_usb_suspend,

<snip>

> +#include <linux/usb.h>
> +
> +/* related module names */
> +#define RTSX_USB_SD_CARD		0
> +#define RTSX_USB_MS_CARD		1
> +
> +#define DRV_NAME_RTSX_USB		"rtsx_usb"
> +#define DRV_NAME_RTSX_USB_SDMMC		"rtsx_usb_sdmmc"
> +#define DRV_NAME_RTSX_USB_MS		"rtsx_usb_ms"

Can you just put the names in the correct places please?

> +/* endpoint numbers */
> +#define EP_BULK_OUT		1
> +#define EP_BULK_IN		2
> +#define EP_INTR_IN		3

I assume these aren't defined anywhere else?

> +/* data structures */
> +struct rtsx_ucr {
> +	u16			vendor_id;
> +	u16			product_id;
> +
> +	int			package;
> +#define QFN24			0
> +#define LQFP48			1
> +#define CHECK_PKG(ucr, pkg)	((ucr)->package == (pkg))

Please remove this from the struct.

> +	u8			ic_version;
> +	u8			is_rts5179;

bool

> +	unsigned int		cur_clk;
> +
> +	u8			*cmd_buf;
> +	unsigned int		cmd_idx;
> +	u8			*rsp_buf;
> +
> +	struct usb_device	*pusb_dev;
> +	struct usb_interface	*pusb_intf;
> +	struct usb_sg_request	current_sg;
> +	unsigned char		*iobuf;
> +	dma_addr_t		iobuf_dma;
> +
> +	struct timer_list	sg_timer;
> +	struct mutex		dev_mutex;
> +};

<snip>

> +static inline void rtsx_usb_init_cmd(struct rtsx_ucr *ucr)
> +{
> +	ucr->cmd_idx = 0;
> +	ucr->cmd_buf[0] = 'R';
> +	ucr->cmd_buf[1] = 'T';
> +	ucr->cmd_buf[2] = 'C';
> +	ucr->cmd_buf[3] = 'R';
> +	ucr->cmd_buf[PACKET_TYPE] = BATCH_CMD;
> +}

Now you have this same hunk of code 3 times in the same patch.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
