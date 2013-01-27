Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3A0Sso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 13:48:44 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46080 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755Ab3A0Ssc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 13:48:32 -0500
Date: Sun, 27 Jan 2013 19:48:30 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, greg@kroah.com, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net, sebastian@breakpoint.cc
Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20130127184830.GB7163@breakpoint.cc>
References: <fdfec7483556.3556fdfec748@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdfec7483556.3556fdfec748@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:46:13AM +0800, fangxiaozhi 00110321 wrote:
> diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/initializers.c linux-3.8-rc4/drivers/usb/storage/initializers.c
> --- linux-3.8-rc4_orig/drivers/usb/storage/initializers.c 2013-01-22 14:12:42.594238726 +0800
> +++ linux-3.8-rc4/drivers/usb/storage/initializers.c 2013-01-22 14:28:21.512294889 +0800
> @@ -104,3 +104,75 @@ int usb_stor_huawei_e220_init(struct us_
>   US_DEBUGP("Huawei mode set result is %d\n", result);
>   return 0;
>  }
> +
> +/*
> + * It will send a scsi switch command called rewind' to huawei dongle.
> + * When the dongle receives this command at the first time,
> + * it will reboot immediately. After rebooted, it will ignore this command.
> + * So it is  unnecessary to read its response.
> + */
> +static int usb_stor_huawei_scsi_init(struct us_data *us)
> +{
> + int result = 0;
> + int act_len = 0;
> + struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> + char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> +                 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> +
> + bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> + bcbw->Tag = 0;
> + bcbw->DataTransferLength = 0;
> + bcbw->Flags = bcbw->Lun = 0;
> + bcbw->Length = sizeof(rewind_cmd);
> + memset(bcbw->CDB, 0, sizeof(bcbw->CDB));

First you memset() 16 bytes of CDB to 0
> + memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
And now you copy 16 bytes from rewind_cmd to CDB. So the memset is not really
required, is it?

> +
> + result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcbw,
> +                                 US_BULK_CB_WRAP_LEN, &act_len);
> + US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
> + return result;
> +}

Sebastian
