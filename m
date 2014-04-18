Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaDROEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:04:12 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50496 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaDROEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140417150110.GB20889@saruman.home>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
	<113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
	<20140403145853.GD14162@saruman.home>
	<CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
	<20140416180228.GK28035@saruman.home>
	<CALHRZuq6=TMryHtbjTw7rYoGwbu2w0BTdxiOA95HYS3_CG6vwQ@mail.gmail.com>
	<20140417150110.GB20889@saruman.home>
Date: Fri, 18 Apr 2014 19:34:08 +0530
Message-ID: <CALHRZuqetzEANE=F4mit5sPG_Q-X8Vxsd9-N4k-MKW4_uzDFwg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: "balbi@ti.com" <balbi@ti.com>
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

On Thu, Apr 17, 2014 at 8:31 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 17, 2014 at 03:01:37PM +0530, sundeep subbaraya wrote:
>> Hi Felipe,
>>
>> On Wed, Apr 16, 2014 at 11:32 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Wed, Apr 16, 2014 at 04:09:28PM +0530, sundeep subbaraya wrote:
>> >> Hi Felipe,
>> >>
>> >> On Thu, Apr 3, 2014 at 8:28 PM, Felipe Balbi <balbi@ti.com> wrote:
>> >>
>> >> >> +static int start_dma(struct xusb_ep *ep, u32 src, u32 dst, u32 length)
>> >> >
>> >> > please prepend this with xudc_, it makes tracing a lot easier.
>> >> >
>> >> >> +{
>> >> >> +     struct xusb_udc *udc;
>> >> >> +     int rc = 0;
>> >> >> +     unsigned long timeout;
>> >> >> +
>> >> >> +     udc = ep->udc;
>> >> >> +     /*
>> >> >> +      * Set the addresses in the DMA source and
>> >> >> +      * destination registers and then set the length
>> >> >> +      * into the DMA length register.
>> >> >> +      */
>> >> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DSAR_ADDR_OFFSET, src);
>> >> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DDAR_ADDR_OFFSET, dst);
>> >> >> +     udc->write_fn(udc->base_address, XUSB_DMA_LENGTH_OFFSET, length);
>> >> >> +
>> >> >> +     /*
>> >> >> +      * Wait till DMA transaction is complete and
>> >> >> +      * check whether the DMA transaction was
>> >> >> +      * successful.
>> >> >> +     */
>> >> >> +     while ((udc->read_fn(ep->udc->base_address + XUSB_DMA_STATUS_OFFSET) &
>> >> >> +                     XUSB_DMA_DMASR_BUSY) == XUSB_DMA_DMASR_BUSY) {
>> >> >> +             timeout = jiffies + 10000;
>> >> >> +
>> >> >> +             if (time_after(jiffies, timeout)) {
>> >> >> +                     rc = -ETIMEDOUT;
>> >> >> +                     goto clean;
>> >> >> +             }
>> >> >> +     }
>> >> >
>> >> > don't you get an IRQ for DMA completion ? If you do, you could be using
>> >> > wait_for_completion()
>> >>
>> >> This function is called in interrupt context when buffer is ready or
>> >> free. It initiates DMA to transfer data from IP buffer to memory.
>> >> Hence it waits in busy loop till DMA completes
>> >
>> > wait, so you start_dma() before your gadget driver asks you to ?
>>
>> in ep_queue driver starts dma transfer from/to IP buffer to/from req->buf.
>> If transfer is completed then request is not added to ep request queue
>> and returns from ep_queue.
>> If transfer is not completed (actual < length) then request is added
>> to queue and returns from ep_queue.
>
> This is wrong. Why wouldn't you give gadget driver the chance to decide
> if it needs to queue the request again or not ?

When does gadget driver decides to queue the same request again?
if -EBUSY is returned from ep_queue or req.status != 0 in completion
routine?

there are cases where ping-pong buffers both are busy. currently this driver
adds request to queue only when buffers are busy. In normal cases request is
processed without adding to queue.

do i need to have another local queue for requests waiting since
buffers are busy?
Or dequeue the request ?

>
>> when buffer processed interrupt occurs, handler starts dma if there is
>> request in queue and calls complete call back (when actual == length)
>> Hence answer is Yes for some transfers (start dma called from
>> interrupt handler not from ep_queue).
>
> this also seems wrong(-ish).
>
> 1) as Paul pointed out, you can't rely on jiffies if you're calling this
> with IRQs disabled.
>
> 2) you don't really need to wait until DMA finishes its transaction
> before returning from start_dma(), just use the DMA completion IRQ,
>
> 3) I don't see anywhere any sanitizing of arguments, can your DMA really
> handle any alignment/unaligned addresses or should you make sure you're
> getting good arguments?
>
> You need to work on this a little bit, I guess.

Yes am working on this and will be using seperate ep_ops for ep0  like
drivers/usb/dwc3/gadget.c since ep0 has no dma and ping-pong buffers

Thanks,
Sundeep.B.S.

>
> --
> balbi
