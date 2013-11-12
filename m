Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3KLXjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:39:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:4941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab3KLXjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:39:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434210671"
Message-ID: <5282BD2D.4070303@linux.intel.com>
Date: Tue, 12 Nov 2013 15:43:41 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <5281595D.9030602@linux.intel.com> <Pine.LNX.4.44L0.1311121046200.1200-100000@iolanthe.rowland.org> <A2CA0424C0A6F04399FB9E1CD98E030458E24316@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E24316@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 11/12/2013 03:09 PM, Paul Zimmerman wrote:
>> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Alan Stern
>> Sent: Tuesday, November 12, 2013 7:51 AM
>>
>> On Mon, 11 Nov 2013, David Cohen wrote:
>>
>>> Hi Alan, Michal,
>>>
>>> On 11/11/2013 01:09 PM, Michal Nazarewicz wrote:
>>>> On Mon, Nov 11 2013, Alan Stern wrote:
>>>>> On Mon, 11 Nov 2013, Michal Nazarewicz wrote:
>>>>>
>>>>>> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
>>>>>> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
>>>>>> to pad epout buffer to match above condition if quirk is found.
>>>>>>
>>>>>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>>>>>
>>>>> I think this is still wrong.
>>>>>
>>>>>> @@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
>>>>>>    		req->context  = &done;
>>>>>>    		req->complete = ffs_epfile_io_complete;
>>>>>>    		req->buf      = data;
>>>>>> -		req->length   = len;
>>>>>> +		req->length   = data_len;
>>>>>
>>>>> IIUC, req->length should still be set to len, not to data_len.
>>>
>>> I misunderstood the first time I read it:
>>> In order to avoid DWC3 to stall, we need to update req->length (this is
>>> the most important fix). kmalloc() is updated too to prevent USB
>>> controller to overflow buffer boundaries.
>>
>> Here I disagree.
>>
>> If the DWC3 hardware stalls, it is up to the DWC3 UDC driver to fix it.
>> Gadget drivers should not have to worry.  Most especially, gadget
>> drivers should not lie about a request length.
>
> The whole point of this quirk is to lie to the DWC3 driver. The quirk is
> only enabled for the DWC3 driver.
>
>> If the UDC driver decides to round up req->length before sending it to
>> the hardware, that's okay.
>
> Not really. If the DWC3 driver unconditionally rounds up req->length,
> then in the case where the buffer has not been expanded to a multiple of
> maxpacket, by this quirk or otherwise, there is the potential to write
> beyond the end of the allocation.
>
> If we do what you suggest, then all the gadgets will have to be audited
> to make sure an OUT buffer with a non-aligned length is never passed to
> the DWC3 driver.

I was really convinced about not updating rep->length was a better idea
until I read this argument of yours: with this approach buffer overflow
can silently happen.

>
> I still think that's the best solution anyway. Just make that the rule,
> and then there is no need for this quirk at all. And there is no need to
> round up req->length in the DWC3 driver either.

I'd have nothing against that, but I'm not sure how it would affect
other environments, given embedded environments are pretty sensitive to
memory consumption (and performance).

>
>> But req->length should be set to len, not data_len.
>
> According to gadget.h:
>
> 	@buf: Buffer used for data
> 	@length: Length of that data
>
> So why shouldn't length be the length of the allocated data buffer?
> Remember, this is for the OUT direction only, so the host has control
> over how much data is actually sent. You could even argue that an OUT
> data buffer should always be a multiple of the max packet size, given
> how USB works.

How about something like this, to let USB controllers to know about
whole allocated memory and avoid hidden overflows. Does that make sense
to you?

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 25a5007f92e3..973b57b709ab 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -31,13 +31,16 @@ struct usb_ep;
   * struct usb_request - describes one i/o request
   * @buf: Buffer used for data.  Always provide this; some controllers
   *     only use PIO, or don't use DMA for some endpoints.
+ * @length: Length of that data
+ * @buf_pad: Some USB controllers may need to pad buffer size due to 
alignment
+ *     constraints. This keeps track of how much memory was allocated 
to @buf
+ *     in addition to @length.
   * @dma: DMA address corresponding to 'buf'.  If you don't set this
   *     field, and the usb controller needs one, it is responsible
   *     for mapping and unmapping the buffer.
   * @sg: a scatterlist for SG-capable controllers.
   * @num_sgs: number of SG entries
   * @num_mapped_sgs: number of SG entries mapped to DMA (internal)
- * @length: Length of that data
   * @stream_id: The stream id, when USB3.0 bulk streams are being used
   * @no_interrupt: If true, hints that no completion irq is needed.
   *     Helpful sometimes with deep request queues that are handled
@@ -91,6 +94,7 @@ struct usb_ep;
  struct usb_request {
         void                    *buf;
         unsigned                length;
+       unsigned                buf_pad;
         dma_addr_t              dma;

         struct scatterlist      *sg;


Br, David Cohen
