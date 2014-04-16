Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaDPKjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:39:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63045 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbaDPKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140403145853.GD14162@saruman.home>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
	<113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
	<20140403145853.GD14162@saruman.home>
Date: Wed, 16 Apr 2014 16:09:28 +0530
Message-ID: <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: balbi@ti.com
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Apr 3, 2014 at 8:28 PM, Felipe Balbi <balbi@ti.com> wrote:

>> +static int start_dma(struct xusb_ep *ep, u32 src, u32 dst, u32 length)
>
> please prepend this with xudc_, it makes tracing a lot easier.
>
>> +{
>> +     struct xusb_udc *udc;
>> +     int rc = 0;
>> +     unsigned long timeout;
>> +
>> +     udc = ep->udc;
>> +     /*
>> +      * Set the addresses in the DMA source and
>> +      * destination registers and then set the length
>> +      * into the DMA length register.
>> +      */
>> +     udc->write_fn(udc->base_address, XUSB_DMA_DSAR_ADDR_OFFSET, src);
>> +     udc->write_fn(udc->base_address, XUSB_DMA_DDAR_ADDR_OFFSET, dst);
>> +     udc->write_fn(udc->base_address, XUSB_DMA_LENGTH_OFFSET, length);
>> +
>> +     /*
>> +      * Wait till DMA transaction is complete and
>> +      * check whether the DMA transaction was
>> +      * successful.
>> +     */
>> +     while ((udc->read_fn(ep->udc->base_address + XUSB_DMA_STATUS_OFFSET) &
>> +                     XUSB_DMA_DMASR_BUSY) == XUSB_DMA_DMASR_BUSY) {
>> +             timeout = jiffies + 10000;
>> +
>> +             if (time_after(jiffies, timeout)) {
>> +                     rc = -ETIMEDOUT;
>> +                     goto clean;
>> +             }
>> +     }
>
> don't you get an IRQ for DMA completion ? If you do, you could be using
> wait_for_completion()

This function is called in interrupt context when buffer is ready or
free. It initiates
DMA to transfer data from IP buffer to memory. Hence it waits in busy
loop till DMA
completes

Thanks,
Sundeep.B.S.
> --
> balbi
