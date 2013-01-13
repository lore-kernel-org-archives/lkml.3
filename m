Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3AMWFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 17:05:49 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54314 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299Ab3AMWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:05:47 -0500
Date: Sun, 13 Jan 2013 23:05:45 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net
Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20130113220545.GB4876@breakpoint.cc>
References: <fe8cd5406b9b.6b9bfe8cd540@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8cd5406b9b.6b9bfe8cd540@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 05:57:44PM +0800, fangxiaozhi 00110321 wrote:
> diff -uprN linux-3.8-rc3_orig/drivers/usb/storage/initializers.c linux-3.8-rc3/drivers/usb/storage/initializers.c
> --- linux-3.8-rc3_orig/drivers/usb/storage/initializers.c	2013-01-11 17:53:19.757842845 +0800
> +++ linux-3.8-rc3/drivers/usb/storage/initializers.c	2013-01-11 17:55:04.137841849 +0800
> @@ -104,3 +104,71 @@ int usb_stor_huawei_e220_init(struct us_
>  	US_DEBUGP("Huawei mode set result is %d\n", result);
>  	return 0;
>  }
> +
> +/* It will send a scsi switch command called rewind' to huawei dongle.
> + * When the dongle receives this command at the first time,
> + * it will reboot immediately. After rebooted, it will ignore this command.
> + * So it is  unnecessary to read its response. */
This multiline comment is wrong. See Documentation/CodingStyle Chapter 8:
Commenting

> +static int usb_stor_huawei_scsi_init(struct us_data *us)
> +{
> +	int result = 0;
> +	int act_len = 0;
> +	struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> +	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> +			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> +	
> +	bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> +	bcbw->Tag = 0;
> +	bcbw->DataTransferLength = 0;
> +	bcbw->Flags = bcbw->Lun = 0;
> +	bcbw->Length = sizeof(rewind_cmd);
> +	memset(bcbw->CDB, 0, sizeof(bcbw->CDB));
> +	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));

You asked me about this, and just replied.

> +	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcbw,
> +					US_BULK_CB_WRAP_LEN, &act_len);
> +	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
> +	return result;
> +}
> +
> +/* It tries to find the supported Huawei USB dongles.
> + * In Huawei, they assign the following product IDs
> + * for all of their mobile broadband dongles,
> + * including the new dongles in the future.
> + * So if the product ID is not included in this list,
> + * it means it is not Huawei's mobile broadband dongles.*/

multiline comment again.

> +static int usb_stor_huawei_dongles_pid(struct us_data *us)
> +{
> +	struct usb_interface_descriptor *idesc;
> +	int idProduct;
> +	
> +	idesc = &us->pusb_intf->cur_altsetting->desc;
> +	idProduct = us->pusb_dev->descriptor.idProduct;
> +	/* The first port is CDROM,
> +	 * means the dongle in the single port mode,
> +	 * and a switch command is required to be sent. */

Multiline comment + means fits in the first line, doesn't it?

> +	if (idesc && idesc->bInterfaceNumber == 0) {
if you do

	if (!idesc || idesc-> != 0)
		return 0;

then you lose one ident level.

> +		if ((idProduct == 0x1001)
> +			|| (idProduct == 0x1003)
> +			|| (idProduct == 0x1004)
> +			|| (idProduct >= 0x1401 && idProduct <= 0x1500)
> +			|| (idProduct >= 0x1505 && idProduct <= 0x1600)
> +			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
> +			return 1;

what about the switch case here?

> +		}
> +	}
> +	return 0;
> +}
> +
> +int usb_stor_huawei_init(struct us_data *us)
> +{
> +	int result = 0;
> +	
> +	if (usb_stor_huawei_dongles_pid(us)) {
> +		if (us->pusb_dev->descriptor.idProduct >= 0x1446)
> +			result = usb_stor_huawei_scsi_init(us);
> +		else
> +			result = usb_stor_huawei_feature_init(us);
> +	}
> +	return result;
> +}
> Binary files linux-3.8-rc3_orig/drivers/usb/storage/initializers.o and linux-3.8-rc3/drivers/usb/storage/initializers.o differ
^^^

Sebastian
