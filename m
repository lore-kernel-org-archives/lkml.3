Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaAPJfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:35:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62189 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:35:16 -0500
Date: Thu, 16 Jan 2014 09:35:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <cjb@laptop.org>,
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
Message-ID: <20140116093506.GI11820@lee--X1>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
 <20140114130409.GB11820@lee--X1>
 <52D79E31.6000300@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52D79E31.6000300@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+static int rtsx_usb_bulk_transfer_sglist(struct rtsx_ucr *ucr,
> >>+             unsigned int pipe, struct scatterlist *sg, int num_sg,
> >>+             unsigned int length, unsigned int *act_len, int timeout)
> >>+{
> >>+     int ret;
> >>+
> >>+     dev_dbg(&ucr->pusb_intf->dev, "%s: xfer %u bytes, %d entries\n",
> >>+                     __func__, length, num_sg);
> >>+     ret = usb_sg_init(&ucr->current_sg, ucr->pusb_dev, pipe, 0,
> >>+                     sg, num_sg, length, GFP_NOIO);
> >>+     if (ret)
> >>+             return ret;
> >>+
> >>+     ucr->sg_timer.expires = jiffies + msecs_to_jiffies(timeout);
> >>+     add_timer(&ucr->sg_timer);
> >>+     usb_sg_wait(&ucr->current_sg);
> >>+     del_timer(&ucr->sg_timer);
> >>+
> >>+     if (act_len)
> >>+             *act_len = ucr->current_sg.bytes;
> >>+
> >>+     return ucr->current_sg.status;
> >>+}
> >
> >Code looks fine, but shouldn't this live in a USB driver?
> >
> We have studied drivers in usb/storage, the place that most likely
> to put the driver. All of them are for STANDARD usb mass storage
> class(something like USB_CLASS_MASS_STORAGE). But this is not the
> same case. This driver is for our vendor-class device with
> completely different protocol. It is really an USB interfaced flash
> card command converter(or channel) device rather than a real
> storage. It also has two derived modules(rtsx_usb_sdmmc,
> rtsx_usb_memstick) for other two subsystems.
> 
> We also have another driver: rtsx_pcr.c resident in mfd/ for similar
> devices but of PCIe interface. It is nature for us to choose the
> same place for this variant.

Very well, as long as it truly does not fit in drivers/usb. It would
be good to have one of the USB folk give the nod though.

> >>+     }
> >>+
> >>+     /* set USB interface data */
> >>+     usb_set_intfdata(intf, ucr);
> >>+
> >>+     ucr->vendor_id = id->idVendor;
> >>+     ucr->product_id = id->idProduct;
> >>+     ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
> >>+
> >>+     mutex_init(&ucr->dev_mutex);
> >>+
> >>+     ucr->pusb_intf = intf;
> >>+
> >>+     /* initialize */
> >>+     ret = rtsx_usb_init_chip(ucr);
> >>+     if (ret)
> >>+             goto out_init_fail;
> >>+
> >>+     for (i = 0; i < ARRAY_SIZE(rtsx_usb_cells); i++) {
> >>+             rtsx_usb_cells[i].platform_data = &ucr;
> >
> >You've already put this in your drvdata (or ntfdata, as it's called
> >here). Why do you also need it in platform_data?
> 
> Derived modules rtsx_usb_sdmmc and rtsx_usb_memstick will retrieve
> this from platform_data. They will not be aware of usb interface
> struct.

They don't need to. If the MMC or Memstick subsystems do not have
their own helpers you can just use something like:

  struct rtsx_ucr *ucr = dev_get_drvdata(pdev->dev.parent);

Naturally this is untested code and might not work off the bat, but it
does give you some idea of what you can do without iterating through
and populating each sub-device's platform data.

> >>+#define DRV_NAME_RTSX_USB            "rtsx_usb"
> >>+#define DRV_NAME_RTSX_USB_SDMMC              "rtsx_usb_sdmmc"
> >>+#define DRV_NAME_RTSX_USB_MS         "rtsx_usb_ms"
> >
> >Can you just put the names in the correct places please?
> >
> Do you mean just remove these definitions and fill the string
> directly at the using place?

I do.

I find these types of defines unhelpful and somewhat obfuscating.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
