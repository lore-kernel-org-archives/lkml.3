Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaAPIvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:51:53 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51478 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaAPIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:51:51 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s0G8pMNu029853, This message is accepted by code: ctloc85258
Message-ID: <52D79E31.6000300@realtek.com>
Date: Thu, 16 Jan 2014 16:54:09 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "micky_ching@realsil.com.cn" <micky_ching@realsil.com.cn>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
References: <1389685656-880-1-git-send-email-rogerable@realtek.com> <1389685656-880-2-git-send-email-rogerable@realtek.com> <20140114130409.GB11820@lee--X1>
In-Reply-To: <20140114130409.GB11820@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 09:04 PM, Lee Jones wrote:
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Realtek USB card reader provides a channel to transfer command or data to flash
>> memory cards. This driver exports host instances for mmc and memstick subsystems
>> and handles basic works.
>>
>> Signed-off-by: Roger Tseng <rogerable@realtek.com>

[snip]

>> +static int rtsx_usb_bulk_transfer_sglist(struct rtsx_ucr *ucr,
>> +             unsigned int pipe, struct scatterlist *sg, int num_sg,
>> +             unsigned int length, unsigned int *act_len, int timeout)
>> +{
>> +     int ret;
>> +
>> +     dev_dbg(&ucr->pusb_intf->dev, "%s: xfer %u bytes, %d entries\n",
>> +                     __func__, length, num_sg);
>> +     ret = usb_sg_init(&ucr->current_sg, ucr->pusb_dev, pipe, 0,
>> +                     sg, num_sg, length, GFP_NOIO);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ucr->sg_timer.expires = jiffies + msecs_to_jiffies(timeout);
>> +     add_timer(&ucr->sg_timer);
>> +     usb_sg_wait(&ucr->current_sg);
>> +     del_timer(&ucr->sg_timer);
>> +
>> +     if (act_len)
>> +             *act_len = ucr->current_sg.bytes;
>> +
>> +     return ucr->current_sg.status;
>> +}
>
> Code looks fine, but shouldn't this live an a USB driver?
>
We have studied drivers in usb/storage, the place that most likely to 
put the driver. All of them are for STANDARD usb mass storage 
class(something like USB_CLASS_MASS_STORAGE). But this is not the same 
case. This driver is for our vendor-class device with completely 
different protocol. It is really an USB interfaced flash card command 
converter(or channel) device rather than a real storage. It also has two 
derived modules(rtsx_usb_sdmmc, rtsx_usb_memstick) for other two subsystems.

We also have another driver: rtsx_pcr.c resident in mfd/ for similar 
devices but of PCIe interface. It is nature for us to choose the same 
place for this variant.

[snip]

>> +     }
>> +
>> +     /* set USB interface data */
>> +     usb_set_intfdata(intf, ucr);
>> +
>> +     ucr->vendor_id = id->idVendor;
>> +     ucr->product_id = id->idProduct;
>> +     ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
>> +
>> +     mutex_init(&ucr->dev_mutex);
>> +
>> +     ucr->pusb_intf = intf;
>> +
>> +     /* initialize */
>> +     ret = rtsx_usb_init_chip(ucr);
>> +     if (ret)
>> +             goto out_init_fail;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(rtsx_usb_cells); i++) {
>> +             rtsx_usb_cells[i].platform_data = &ucr;
>
> You've already put this in your drvdata (or ntfdata, as it's called
> here). Why do you also need it in platform_data?

Derived modules rtsx_usb_sdmmc and rtsx_usb_memstick will retrieve this 
from platform_data. They will not be aware of usb interface struct.

[snip]

>> +#ifdef CONFIG_PM
>> +static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
>> +{
>> +     struct rtsx_ucr *ucr =
>> +             (struct rtsx_ucr *)usb_get_intfdata(intf);
>> +
>> +     dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
>> +                     __func__, message.event);
>> +
>> +     mutex_lock(&ucr->dev_mutex);
>> +     rtsx_usb_turn_off_led(ucr);
>
> That's it? That's all you do during suspend? :)
>
Yes. The rest of power things like turning-off card power or clock 
should be taken care by cores of derived modules(mmc, memstick). We put 
only one task here to make sure the LED is off, preventing any module 
from turn it on but doesn't turn off before suspend.
>> +     mutex_unlock(&ucr->dev_mutex);
>> +     return 0;
>> +}
>> +
>> +static int rtsx_usb_resume(struct usb_interface *intf)
>> +{
>
> Don't you want to turn the LED back on here?
>
> Or will that happen automatically when you write/read to/from it again?
>
Yes, it would blink again during use. The turn-off before suspend is not 
a permanent power off.
>> +     return 0;
>> +}
>> +
>> +static int rtsx_usb_reset_resume(struct usb_interface *intf)
>> +{
>> +     struct rtsx_ucr *ucr =
>> +             (struct rtsx_ucr *)usb_get_intfdata(intf);
>> +
>> +     rtsx_usb_reset_chip(ucr);
>> +     return 0;
>> +}
>> +
>> +#else /* CONFIG_PM */
>> +
>> +#define rtsx_usb_suspend NULL
>> +#define rtsx_usb_resume NULL
>> +#define rtsx_usb_reset_resume NULL
>> +
>> +#endif /* CONFIG_PM */
>> +
>> +
>> +static int rtsx_usb_pre_reset(struct usb_interface *intf)
>> +{
>> +     struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
>> +
>> +     mutex_lock(&ucr->dev_mutex);
>
> Is this normal?

Yes. It is used to prevent commands during port reset. Same to the one 
in usb/storage/usb.c.

[snip]
>
>> +#include <linux/usb.h>
>> +
>> +/* related module names */
>> +#define RTSX_USB_SD_CARD             0
>> +#define RTSX_USB_MS_CARD             1
>> +
>> +#define DRV_NAME_RTSX_USB            "rtsx_usb"
>> +#define DRV_NAME_RTSX_USB_SDMMC              "rtsx_usb_sdmmc"
>> +#define DRV_NAME_RTSX_USB_MS         "rtsx_usb_ms"
>
> Can you just put the names in the correct places please?
>
Do you mean just remove these definitions and fill the string directly 
at the using place?

>> +/* endpoint numbers */
>> +#define EP_BULK_OUT          1
>> +#define EP_BULK_IN           2
>> +#define EP_INTR_IN           3
>
> I assume these aren't defined anywhere else?
>
It should not be defined anywhere else since it is really depends on the 
hardware design but not any general spec.

[snip]
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
>
> ------Please consider the environment before printing this e-mail.
>
