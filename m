Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3KKX7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:59:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:14619 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3KKX7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:59:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433528989"
Message-ID: <5281706F.5050507@linux.intel.com>
Date: Mon, 11 Nov 2013 16:03:59 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-3-git-send-email-david.a.cohen@linux.intel.com> <xa1tzjpawl1x.fsf@mina86.com>
In-Reply-To: <xa1tzjpawl1x.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:55 PM, Michal Nazarewicz wrote:
> On Mon, Nov 11 2013, David Cohen wrote:
>> Due to USB controllers may have different restrictions, usb gadget layer
>> needs to provide a generic way to inform gadget functions to complain
>> with non-standard requirements.
>>
>> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
>> to inform when controller's epout requires buffer size to be aligned to
>> MaxPacketSize. A helper is also provided to align buffer size when
>> necessary.
>>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>
>> ---
>>
>> Michal,
>>
>> I added prefix 'usb: f_fs: ' to patch's subject. I did not add 'usb: gadget:
>> f_fs' due to it would be too long.
>>
>>
>>   include/linux/usb/gadget.h | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>> index 23b3bfd0a842..41e8834af57d 100644
>> --- a/include/linux/usb/gadget.h
>> +++ b/include/linux/usb/gadget.h
>> @@ -441,6 +441,19 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
>>   		ep->ops->fifo_flush(ep);
>>   }
>>
>> +/**
>> + * usb_ep_align_maxpacketsize - returns @len aligned to ep's maxpacketsize
>> + * @ep: the endpoint whose maxpacketsize is used to align @len
>> + * @len: buffer size's length to align to @ep's maxpacketsize
>> + *
>> + * This helper is used in case it's required for any reason to align buffer's
>> + * size to an ep's maxpacketsize.
>> + */
>> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
>> +{
>> +	return round_up(len, (size_t)ep->desc->wMaxPacketSize);
>> +}
>> +
>
> Come to think of it, perhaps even better helper would be:
>
> static inline size_t usb_ep_align_maybe(
> 	struct usb_gadget *gadget, struct usb_ep *ep, size_t len) {
> 	return gadget->quir_ep_out_aligned_size ?
> 		round_up(len, (size_t)ep->desc->wMaxPacketSize) : len;
> }

The CPU time to check unsigned:1 and possibly jump is about the same as
round_up() itself. For readability matters, we can round_up() directly.

Br, David
