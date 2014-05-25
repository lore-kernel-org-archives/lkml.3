Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaEYRkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 13:40:35 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47710 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaEYRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 13:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140430165437.GO23679@saruman.home>
References: <20140421160802.GA22794@saruman.home>
	<Pine.LNX.4.44L0.1404211228190.1201-100000@iolanthe.rowland.org>
	<CALHRZur7+MaYXbWOfbvjggPN7_eYAE+th5VNbcLP=ehvm0HGsA@mail.gmail.com>
	<20140422144944.GF5524@saruman.home>
	<CALHRZuoq32qoh70hbb2LtVJNgkwB1j6bvzmYONmxcn3mBnGONQ@mail.gmail.com>
	<20140430165437.GO23679@saruman.home>
Date: Sun, 25 May 2014 23:10:30 +0530
Message-ID: <CALHRZur13jLsszV8m_2q1nnBcd00P+2jO60Bvn48aKeu0f7yNQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
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

Please take a look at below about how this IP works:

IN:
      req.buf ---> DMA (transfers from ddr to IP buffer, raise DMA
done interrupt and set Buffer ready to transfer data to Host)---->Host
PC
  buffer sent interrupt

OUT:
     Host PC--->buffer ready interrupt--->DMA (transfer from IP buffer
to DDR,DMA done interrupt, set Buffer ready to receive next data from
Host)-->req.buf

I written logic to call completion in DMA done handler because it
works for both IN and OUT eps. But I see significant performance
degradation (by copying a file to mass storage gadget). DMA can handle
unaligned address too but it has ep max limit (say 512 for bulk).
Hence it is SW job to split packets and to drive DMA till req.length
completes. I feel polling for a while is faster than switching between
interrupt handler back and forth rapidly. Moreover, DMA may or may not
be present in IP based on user configuration at design time.

I fixed all other comments expect this one if you do not agree for
polling then I may have to create threads and do this stuff. What do
you suggest?

Thanks,
Sundeep

On Wed, Apr 30, 2014 at 10:24 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Apr 23, 2014 at 09:57:52AM +0530, sundeep subbaraya wrote:
>> >> > I get the impression that the two of you are arguing past each other.
>> >> > It appears that Sundeep is talking about transferring data from the
>> >> > gadget driver's buffer to an internal buffer in the UDC hardware, but
>> >> > Felipe is talking about transferring data from the UDC to the host.
>> >> >
>> >> > As I understand it, Sundeep said that when the gadget driver queues a
>> >> > data-IN request, the UDC driver copies as much of the data buffer as
>> >> > possible into a hardware FIFO.  If it succeeds in copying all the data
>> >> > into the FIFO then the request's completion routine gets called
>> >> > immediately, even though the data doesn't get sent from the FIFO to the
>> >> > host until the host asks for it.
>> >> >
>> >> > If only part of the data can be copied into the FIFO then the request
>> >> > is added to the ep's request queue before the usb_ep_queue() call
>> >> > returns.  When space becomes available in the FIFO, the data will be
>> >> > copied and eventually sent to the host.  When all the data has been
>> >> > copied to the FIFO, the request's completion routine will be called.
>> >
>> > there seems to be a slight problem with this approach: how will the IP
>> > know that even though you copied X bytes into the FIFO, it should wait
>> > for another Y bytes before shifting data to the wire ? How will it know
>> > that it shouldn't generate CRC yet because there's still data to be
>> > added ?
>>
>> No. IP does/need not know that it has to wait for Y bytes.We just
>> write X bytes into
>> HW buffer and count as X in buffer count register. IP generates CRC
>> for bytes based
>> on Count register and sends data to Host. Let us consider this
>> scenario of bulk IN transfer:
>> req.length = 5120 and   wMaxPacketSize = 512, ep_queue is called once
>> and is returned with
>> status 0. In ep_queue this code snippet,
>>                if (xudc_write_fifo(ep, req) == 1)
>>                         req = NULL;
>>                if(req != NULL)
>>                          list_add_tail(&req->queue, &ep->queue);
>>
>> xudc_write_fifo does the following if HW buffers not busy:
>>      copies 512 bytes to HW buffer
>>      set count and ready registers so that IP can start data transfer to host
>>      changes req.actual to 512 and returns 0(if req.length >
>> wMaxPacketSize) and 1(if req.length < wMaxPacketSize).
>
> you should return a proper error code, not 1.
>
>> Since return is zero this request is added to queue. When data
>> transfer to host is completed IP generates
>> an interrupt. In the interrupt handler we again call write_fifo if
>> request list is not empty.
>>        if (list_empty(&ep->queue))
>>                 req = NULL;
>>         else
>>                 req = list_entry(ep->queue.next, struct xusb_req, queue);
>>         if (!req)
>>                 return;
>
> okay, this can be improved a bit though:
>
>         if (list_empty(&ep->queue))
>                 return;
>
>         req = list_first_entry(&ep->queue, struct xusb_req, queue);
>
>>         if (ep->is_in)
>>                 xudc_write_fifo(ep, req);
>>         else
>>                 xudc_read_fifo(ep, req);
>>
>> This happens 10 times(since length 5120) and completion is called.
>
> ok.
>
>> > If there's no space in the FIFO yet, why copy data at all ?
>>
>> If HW buffers are busy(IP is still transferring previous data to Host
>> from buffer) then xudc_write_fifo returns 0 without changing
>> req.actual. When previous data transfer completes then Interrupt then
>> again write_fifo from handler.
>
> ok, sounds good to me.
>
>> >> > Thus there never is any need for the gadget driver to queue the request
>> >> > again.
>>
>> Yes
>>
>> >> >An incomplete transfer means the FIFO didn't have enough room
>> >> > when the request was submitted; it doesn't mean that the data didn't
>> >> > eventually get sent to the host.
>> >>
>> >> Exactly Alan,this is what I was trying to say. Probably I was not
>> >> clear in explaining. I didnt see any harm this way and even this
>> >> implementation is same like at91_udc.c. I have been reading
>> >> mas_storage to understand when does gadget driver tries to enqueue a
>> >> request again. Since different gadget drivers might have different
>> >> requirements (agree with Felipe), wanted to know criteria for queuing
>> >> a same request again.
>> >>
>> >> I will change this implementation as per Felipe comments and test with
>> >> some of the gadgets.
>> >
>> > Let's see, please help me understand the questions above.
>>
>> Hope this helps.
>
> it does, but please sort out the small comments I had above.
>
> cheers
>
> --
> balbi
