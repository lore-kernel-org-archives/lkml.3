Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaAJMnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:43:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaAJMnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:43:00 -0500
Message-ID: <1389357777.6807.33.camel@linux-fkkt.site>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
From: Oliver Neukum <oneukum@suse.de>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Fri, 10 Jan 2014 13:42:57 +0100
In-Reply-To: <1387792327-2511-2-git-send-email-rogerable@realtek.com>
References: <1387792327-2511-1-git-send-email-rogerable@realtek.com>
	 <1387792327-2511-2-git-send-email-rogerable@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 17:52 +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB card reader provides a channel to transfer command or data to flash
> memory cards. This driver exports host instances for mmc and memstick subsystems
> and handles basic works.

Thank you for writing this driver.
A few remarks about the code and sorry for the delay in reviewing.

> Signed-off-by: Roger Tseng <rogerable@realtek.com>

> +static void rtsx_usb_sg_timed_out(unsigned long data)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)data;
> +
> +	dev_dbg(&ucr->pusb_intf->dev, "%s: sg transfer timed out", __func__);
> +	usb_sg_cancel(&ucr->current_sg);
> +
> +	/* we know the cancellation is caused by time-out */

How do you know? You know it won't complete here, but it may have
completed for another reason.

> +	ucr->current_sg.status = -ETIMEDOUT;
> +}

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

Please use the macros the kernel provides.

> +	ucr->cmd_buf[STAGE_FLAG] = 0;
> +	ucr->cmd_buf[8] = (u8)(addr >> 8);
> +	ucr->cmd_buf[9] = (u8)addr;

Likewise.

> +
> +	memcpy(ucr->cmd_buf + 12, data, len);
> +
> +	return rtsx_usb_transfer_data(ucr,
> +			usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
> +			ucr->cmd_buf, cmd_len, 0, NULL, 100);
> +}

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

Even for fatal errors?

> +		/* clear HW error*/
> +		rtsx_usb_ep0_write_register(ucr, SFSM_ED, 0xf8, 0xf8);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_usb_send_cmd);

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
> +	mutex_unlock(&ucr->dev_mutex);
> +	return 0;
> +}
> +
> +static int rtsx_usb_resume(struct usb_interface *intf)
> +{
> +	return 0;

Don't you want to turn the LED back on?

> +}

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

This is good, but what do you need remote wakeup for?
> +	.soft_unbind =	1,
> +};
> +

