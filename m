Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3KKWVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:21:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:49903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab3KKWVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:21:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,680,1378882800"; 
   d="scan'208";a="425833768"
Message-ID: <5281595D.9030602@linux.intel.com>
Date: Mon, 11 Nov 2013 14:25:33 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <Pine.LNX.4.44L0.1311111517160.17105-100000@netrider.rowland.org> <xa1thabiy7a4.fsf@mina86.com>
In-Reply-To: <xa1thabiy7a4.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, Michal,

On 11/11/2013 01:09 PM, Michal Nazarewicz wrote:
> On Mon, Nov 11 2013, Alan Stern wrote:
>> On Mon, 11 Nov 2013, Michal Nazarewicz wrote:
>>
>>> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
>>> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
>>> to pad epout buffer to match above condition if quirk is found.
>>>
>>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>>
>> I think this is still wrong.
>>
>>> @@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
>>>   		req->context  = &done;
>>>   		req->complete = ffs_epfile_io_complete;
>>>   		req->buf      = data;
>>> -		req->length   = len;
>>> +		req->length   = data_len;
>>
>> IIUC, req->length should still be set to len, not to data_len.

I misunderstood the first time I read it:
In order to avoid DWC3 to stall, we need to update req->length (this is
the most important fix). kmalloc() is updated too to prevent USB
controller to overflow buffer boundaries.

>>
>>>
>>>   		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
>>>
>>> @@ -836,9 +844,16 @@ static ssize_t ffs_epfile_io(struct file *file,
>>>   			ret = -EINTR;
>>>   			usb_ep_dequeue(ep->ep, req);
>>>   		} else {
>>> +			/*
>>> +			 * XXX We may end up silently droping data here.
>>> +			 * Since data_len (i.e. req->length) may be bigger
>>> +			 * than len (after being rounded up to maxpacketsize),
>>> +			 * we may end up with more data then user space has
>>> +			 * space for.
>>> +			 */
>>
>> Then this will never come up.  If the host sends a packet that's too
>> long, you'll get a -EOVERFLOW error.
>>
>>>   			ret = ep->status;
>>>   			if (read && ret > 0 &&
>>> -			    unlikely(copy_to_user(buf, data, ret)))
>>> +			    unlikely(copy_to_user(buf, data, min(ret, len))))
>>>   				ret = -EFAULT;
>>>   		}
>>>   	}
>>
>> The reason for the quirk is that the controller may write all the
>> incoming data to the buffer, even if this is more data than the driver
>> requested.
>
> If that's the case, then it indeed solves the problem of silently
> throwing away data.  I guess it makes more sense then my understanding
> of the quirk.

The main reason of this quirk it to prevent DWC3 to stall or to
overflow buffer after usb_ep_queue() above. Since req->length has to be
updated, I disagree with Alan in this case and give my ack to this
Michal's approach.

Br, David Cohen
