Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3KMVrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:47:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:18595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3KMVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:47:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434838433"
Message-ID: <5283F47C.1050202@linux.intel.com>
Date: Wed, 13 Nov 2013 13:51:56 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <Pine.LNX.4.44L0.1311131034100.1424-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1311131034100.1424-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 07:52 AM, Alan Stern wrote:
> On Tue, 12 Nov 2013, Paul Zimmerman wrote:
>
>>>>>>> @@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
>>>>>>>    		req->context  = &done;
>>>>>>>    		req->complete = ffs_epfile_io_complete;
>>>>>>>    		req->buf      = data;
>>>>>>> -		req->length   = len;
>>>>>>> +		req->length   = data_len;
>>>>>>
>>>>>> IIUC, req->length should still be set to len, not to data_len.
>>>>
>>>> I misunderstood the first time I read it:
>>>> In order to avoid DWC3 to stall, we need to update req->length (this is
>>>> the most important fix). kmalloc() is updated too to prevent USB
>>>> controller to overflow buffer boundaries.
>>>
>>> Here I disagree.
>>>
>>> If the DWC3 hardware stalls, it is up to the DWC3 UDC driver to fix it.
>>> Gadget drivers should not have to worry.  Most especially, gadget
>>> drivers should not lie about a request length.
>>
>> The whole point of this quirk is to lie to the DWC3 driver.
>
> No.  The whole point of this quirk is to allow the DWC3 hardware to run
> without stalling.
>
> It's dumb to lie to drivers.  They are there to help you; how can they
> help you if you don't tell them what you want them to do?

IMO if we're not changing req->length we may need to add pad
information to struct usb_request to avoid hidden buffer overflows.
Even though we say it's UDC's responsibility of configure correctly
itself the buffer comes from gadget driver. The driver needs to know
the memory used is safe.

>
>>   The quirk is
>> only enabled for the DWC3 driver.
>
> So what?  Maybe other drivers will need it in the future.
>
>>> If the UDC driver decides to round up req->length before sending it to
>>> the hardware, that's okay.
>>
>> Not really. If the DWC3 driver unconditionally rounds up req->length,
>> then in the case where the buffer has not been expanded to a multiple of
>> maxpacket, by this quirk or otherwise, there is the potential to write
>> beyond the end of the allocation.
>
> Indeed.  It is the gadget driver's responsibility to make sure that
> doesn't happen.
>
>> If we do what you suggest, then all the gadgets will have to be audited
>> to make sure an OUT buffer with a non-aligned length is never passed to
>> the DWC3 driver.
>
> Certainly.  And since gadget drivers have no idea (or, _should_ have no
> idea) which UDC driver they are using, this means all gadgets will have
> to make sure that they _never_ use OUT buffers with non-aligned
> lengths.

But a possibility for a sanity check would be safer. UDCs should be
able to catch insufficient buffer size. Since buffer comes from gadget
driver, we need a way to inform both: request's length and buffer's
length.

>
>> I still think that's the best solution anyway. Just make that the rule,
>> and then there is no need for this quirk at all. And there is no need to
>> round up req->length in the DWC3 driver either.
>
> I agree that there really is no need for the quirk flag.  As for what
> the DWC3 driver does internally, I couldn't care less.  But gadget
> drivers should not round up req->length.
>
>>> But req->length should be set to len, not data_len.
>>
>> According to gadget.h:
>>
>> 	@buf: Buffer used for data
>> 	@length: Length of that data
>>
>> So why shouldn't length be the length of the allocated data buffer?
>
> Read what you just quoted: @length is the length of the _data_.  Not
> the length of the _buffer_.
>
> If the gadget driver wants to receive 100 bytes of data and the buffer
> is 128 bytes long, it should set req->length to 100, not 128.  By doing
> so, it tells the UDC driver that receiving more than 100 bytes is an
> error condition.
>
>> Remember, this is for the OUT direction only, so the host has control
>> over how much data is actually sent. You could even argue that an OUT
>> data buffer should always be a multiple of the max packet size, given
>> how USB works.
>
> Yes, you could.  I have no objection to changing the gadget API so that
> this becomes a firm requirement.

That's another way to go. No quirk would be necessary and DWC3 could
safely take care of itself. As long as no one goes against it.

>
>>> And if the hardware receives more than len bytes of data,
>>> the UDC driver should set req->status to -EOVERFLOW.
>>
>> That would be nice, but I don't see how to accomplish that given the
>> above.
>
> Why not?  The UDC driver knows what was originally in req->length and
> it knows how much data the hardware actually received.  All it has to
> do is:
>
> 	if (actual_length > req->length)
> 		req->status = -EOVERFLOW;

Agreed.

Br, David
