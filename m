Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3KEPNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:13:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:14810 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3KEPNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:13:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="430138122"
Message-ID: <52790A97.4040408@linux.intel.com>
Date: Tue, 05 Nov 2013 07:11:19 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <Pine.LNX.4.44L0.1311050948360.1360-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1311050948360.1360-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 06:50 AM, Alan Stern wrote:
> On Mon, 4 Nov 2013, David Cohen wrote:
> 
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
>> ---
>>  include/linux/usb/gadget.h | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>> index 23b3bfd0a842..260d972489bd 100644
>> --- a/include/linux/usb/gadget.h
>> +++ b/include/linux/usb/gadget.h
>> @@ -442,6 +442,22 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
>>  }
>>  
>>  
>> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
>> +{
>> +	int aligned;
>> +
>> +	if (ep->desc->bmAttributes & USB_ENDPOINT_XFER_INT)
>> +		/*
>> +		 * Interrupt eps don't need max packet size to be power of 2,
>> +		 * so can't use cheap IS_ALIGNED() macro.
>> +		 */
>> +		aligned = !(len % ep->desc->wMaxPacketSize);
>> +	else
>> +		aligned = IS_ALIGNED(len, ep->desc->wMaxPacketSize);
> 
> This isn't on a hot path, and I suspect that the extra "if" will 
> require nearly as much time as you save by not doing the division.  You 
> might as well always use the % operation.

Perhaps if I use unlikely() on 'if' condition instead?
Anyway I'll double check the costs of if + IS_ALIGNED vs modulo.

Br, David
