Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822AbaABJsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:48:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:48:05 -0500
Date: Thu, 2 Jan 2014 12:47:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140102094750.GZ28413@mwanda>
References: <1387792327-2511-1-git-send-email-rogerable@realtek.com>
 <1387792327-2511-2-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387792327-2511-2-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 05:52:05PM +0800, rogerable@realtek.com wrote:
> +static int rtsx_usb_seq_write_register(struct rtsx_ucr *ucr,
> +		u16 addr, u16 len, u8 *data)
> +{
> +	u16 cmd_len = len + 12;
> +
> +	if (data == NULL)
> +		return -EINVAL;
> +
> +	cmd_len = (cmd_len <= CMD_BUF_LEN) ? cmd_len : CMD_BUF_LEN;
> +


I do not like how you have three names for the same buffer length.

> +#define IOBUF_SIZE           1024
> +#define CMD_BUF_LEN          1024
> +#define RSP_BUF_LEN          1024

The buffer is allocated as IOBUF_SIZE and then CMD_BUF_LEN is used as
a limiter here and one other place.  RSP_BUF_LEN is not used at all.

> +	if (cmd_len % 4)
> +		cmd_len += (4 - cmd_len % 4);
> +
> +
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
> +
> +	memcpy(ucr->cmd_buf + 12, data, len);

Buffer overflow here because ->cmd_buf is only IOBUF_SIZE long.
Probably the earlier two uses of "len" are buffer overflows as well.

> +int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
> +		u8 mask, u8 data)
> +{
> +	u16 value = 0, index = 0;
> +
> +	value |= (u16)(3 & 0x03) << 14;
> +	value |= (u16)(addr & 0x3FFF);

Don't do pointless things:

	value |= 0x03 << 14;
	value |= addr & 0x3FFF;

> +	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);

This is an endian conversion?  It is buggy.  Use the kernel endian
conversion functions cpu_to_le16().

> +	index |= (u16)mask;
> +	index |= (u16)data << 8;
> +
> +	return usb_control_msg(ucr->pusb_dev,
> +			usb_sndctrlpipe(ucr->pusb_dev, 0), 0, 0x40,
> +			value, index, NULL, 0, 100);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_ep0_write_register);
> +
> +int rtsx_usb_ep0_read_register(struct rtsx_ucr *ucr, u16 addr, u8 *data)
> +{
> +	u16 value = 0;
> +
> +	if (data == NULL)
> +		return -EINVAL;
> +	*data = 0;
> +
> +	value |= (u16)(2 & 0x03) << 14;
> +	value |= (u16)(addr & 0x3FFF);
> +	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);

same.

The rest of my comments below are minor white space nits.

> +
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
> +{
> +	int i;
> +
> +	if (ucr->cmd_idx < ((CMD_BUF_LEN - CMD_OFFSET) / 4)) {
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
> +		/* clear HW error*/
> +		rtsx_usb_ep0_write_register(ucr, SFSM_ED, 0xf8, 0xf8);

Make this into a function and remove the comment.

		rtsx_usb_ep0_clear_hw_error(ucr);

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
> +
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
> +	*status = (u16)((ucr->rsp_buf[0] >> 2) & 0x0f) |
> +		((ucr->rsp_buf[1] & 0x03) << 4);

The cast to u16 is not needed.  Align it like this:

	*status = ((ucr->rsp_buf[0] >> 2) & 0x0f) |
		  ((ucr->rsp_buf[1] & 0x03) << 4);

> +
> +	return 0;
> +}
> +

[ snip ]

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
> +	n = (u8)(card_clock - 2);

Unneeded cast.

> +	if ((card_clock <= 2) || (n > MAX_DIV_N))
> +		return -EINVAL;
> +
> +	mcu_cnt = (u8)(60/card_clock + 3);

Unneeded cast.  Obviously it fits in u8.

> +	if (mcu_cnt > 15)
> +		mcu_cnt = 15;
> +
> +	/* Make sure that the SSC clock div_n is not less than MIN_DIV_N */
> +
> +	div = CLK_DIV_1;
> +	while ((n < MIN_DIV_N) && (div < CLK_DIV_4)) {

Unneeded parenthesis.

> +		n = (n + 2) * 2 - 2;
> +		div++;
> +	}

[ snip ]

> +static int rtsx_usb_init_chip(struct rtsx_ucr *ucr)
> +{
> +	int ret;
> +	u8 val;
> +
> +	/* clear HW error*/
> +	rtsx_usb_ep0_write_register(ucr, SFSM_ED, 0xf8, 0xf8);
> +
> +	/* power on SSC*/
> +	ret = rtsx_usb_write_register(ucr,
> +			FPDCTL, SSC_POWER_MASK, SSC_POWER_ON);
> +	if (ret)
> +		goto err_out;
> +
> +	usleep_range(100, 1000);
> +	ret = rtsx_usb_write_register(ucr, CLK_DIV, CLK_CHANGE, 0x00);
> +	if (ret)
> +		goto err_out;
> +
> +	/* determine IC version */
> +	ret = rtsx_usb_read_register(ucr, HW_VERSION, &val);
> +	if (ret)
> +		goto err_out;
> +
> +	ucr->ic_version = val & HW_VER_MASK;
> +
> +	/* determine package */
> +	ret = rtsx_usb_read_register(ucr, CARD_SHARE_MODE, &val);
> +	if (ret)
> +		goto err_out;
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
> +	}
> +
> +	ret = rtsx_usb_reset_chip(ucr);
> +	if (ret)
> +		goto err_out;
> +
> +	return 0;
> +err_out:
> +	return ret;

Gar...  Just return directly instead of adding do-nothing-gotos...  No
one likes skipping back and forth within a function to find what a goto
does and then it does nothing, it just returns.

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
> +	if (!ucr) {
> +		dev_err(&intf->dev, "Out of memory\n");

This printk is pointless.  kzalloc() already has a much usefull
printk().

> +		return -ENOMEM;
> +	}
> +
> +	ucr->pusb_dev = usb_dev;
> +
> +	/* alloc coherent buffer */
> +	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
> +			GFP_KERNEL, &ucr->iobuf_dma);
> +	if (!ucr->iobuf) {
> +		ret = -ENOMEM;
> +		goto out_free_chip;
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
> +		rtsx_usb_cells[i].pdata_size = sizeof(*ucr);
> +	}
> +	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
> +			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
> +

Don't put a blank line here.

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
> +	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
> +			ucr->iobuf_dma);
> +
> +out_free_chip:
> +	kfree(ucr);
> +	dev_err(&intf->dev, "%s failed\n", __func__);
> +	return ret;
> +}

[ snip ]

> +#define CARD_DMA1_CTL			0xFD5C
> +#define CARD_PULL_CTL1			0xFD60
> +#define CARD_PULL_CTL2			0xFD61
> +#define CARD_PULL_CTL3			0xFD62
> +#define CARD_PULL_CTL4			0xFD63
> +#define CARD_PULL_CTL5			0xFD64
> +#define CARD_PULL_CTL6			0xFD65
> +#define CARD_EXIST				0xFD6F

In the email CARD_EXIST looks aligned correctly, but in the actual .h
file then it's out of line.

> +#define CARD_INT_PEND			0xFD71
> +

[ snip ]

> +#define MC_IRQ				0xFF00
> +#define MC_IRQEN			0xFF01
> +#define MC_FIFO_CTL			0xFF02
> +#define MC_FIFO_BC0			0xFF03
> +#define MC_FIFO_BC1			0xFF04
> +#define MC_FIFO_STAT			0xFF05
> +#define MC_FIFO_MODE			0xFF06
> +#define MC_FIFO_RD_PTR0		0xFF07
> +#define MC_FIFO_RD_PTR1		0xFF08

MC_FIFO_RD_PTR0 and MC_FIFO_RD_PTR1 are not aligned correctly.

> +#define MC_DMA_CTL			0xFF10
> +#define MC_DMA_TC0			0xFF11

regards,
dan carpenter

