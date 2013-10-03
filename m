Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3JCKgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:36:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23538 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3JCKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:36:45 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-f5-524d48bb331f
Message-id: <524D48BA.9060800@samsung.com>
Date: Thu, 03 Oct 2013 12:36:42 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com
Subject: Re: [PATCH v4] USB: gadget: epautoconf: fix ep maxpacket check
References: <Pine.LNX.4.44L0.1310021128200.1293-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1310021128200.1293-100000@iolanthe.rowland.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7q7PXyDDLZ3y1rMetnOYrFxxnpW
	i4P36y2aF69ns7i8aw6bxaJlrcwWa4/cZbeY8PsCmwOHx/65a9g9Zt/9wejRt2UVo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DK6PvRzVSwS6Ni5U2/Bsb7cl2MnBwSAiYSa+5+Y4WwxSQu
	3FvP1sXIxSEksJRR4si7uSwQzkdGiZuf29hAqngFtCQ+PlkA1sEioCrR0zSdGcRmE9CR2PJ9
	AiOILSoQIfHn9D5WiHpBiR+T77GA2CJAvZubXjKDDGUW2MIocejOT7ChwgLuEm8fTABrEBLw
	kbjWNglsEKeAr0Tz549MIDazgLXEyknbGCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpa
	mlxQnJSea6hXnJhbXJqXrpecn7uJERLuX3YwLj5mdYhRgINRiYe3Q8UnSIg1say4MvcQowQH
	s5IIb4i1b5AQb0piZVVqUX58UWlOavEhRiYOTqkGxsrFDSZOaywYk9iexZx9eiff7owvY+BX
	6dbCmYH3sreXZZ1/1hr8e2/1Hc7tt3UZwx3/T7PYrrXy85fFexwy999yM9CKbT5iLuGwLNT0
	cdCRawwLb/5UWZpQcrhdIFNk7XWbgPt/gr2nXhc8vEqS8yL3AmmWb7r3bA5++Pg33tdIzG97
	5dLjE5VYijMSDbWYi4oTAWCWKX1VAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
On 10/02/2013 05:48 PM, Alan Stern wrote:
> On Wed, 2 Oct 2013, Robert Baldyga wrote:
>
>> This patch fix validation of maxpacket value given in endpoint descriptor.
>> Add check of maxpacket for bulk endpoints. If maxpacket is not set in
>> descriptor, it's set to maximum value for given type on endpoint in used
>> speed.
>>
>> Correct maxpacket value is:
>>
>>               FULL-SPEED        HIGH-SPEED   SUPER-SPEED
>> BULK         8, 16, 32, 64     512          1024
>> INTERRUPT    1..64             1..1024      1..1024
>> ISOCHRONOUS  1..1023           1..1024      1..1024
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>
>> Hello,
>>
>> This is fourth version of my patch. From last version I have removed
>> code reporting full speed bulk maxpacket because it's not needed since
>> maxpacket check for all speeds is performed before.
>
> It seems that this patch does a lot of things wrong.  Comments below.
>
>> @@ -124,37 +124,90 @@ ep_matches (
>>
>>   	}
>>
>> +	max = 0x7ff & usb_endpoint_maxp(desc);
>> +
>>   	/*
>> -	 * If the protocol driver hasn't yet decided on wMaxPacketSize
>> -	 * and wants to know the maximum possible, provide the info.
>> +	 * Test if maxpacket given in descriptor isn't greater than maximum
>> +	 * packet size for this endpoint
>>   	 */
>> -	if (desc->wMaxPacketSize == 0)
>> -		desc->wMaxPacketSize = cpu_to_le16(ep->maxpacket);
>> +	if (ep->maxpacket < max)
>> +		return 0;
>>
>> -	/* endpoint maxpacket size is an input parameter, except for bulk
>> -	 * where it's an output parameter representing the full speed limit.
>> -	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
>> +	/*
>> +	 * Test if ep supports maxpacket size set in descriptor.
>> +	 * If the protocol driver hasn't yet decided on wMaxPacketSize
>> +	 * (when wMaxPacketSize == 0) and wants to know the maximum possible,
>> +	 * provide the info.
>
> This disagrees with the kerneldoc for usb_ep_autoconfig().  For bulk
> endpoints, wMaxPacket is always supposed to be set to the full-speed
> value, regardless of what the protocol driver specifies.

Hmm, it looks like all gadgets calls usb_ep_autoconfig() for full speed
descriptors and after it they uses usb_assign_descriptors() function to 
set descriptors proper for device speed. And it works until gadget sets 
full speed descriptors. But what if gadget supports only high speed and
don't want to set full speed descriptors? If it will use
usb_ep_autoconfig() function for high speed descriptor, value of
wMaxPacketSize field will change to 64. Is there any good solution for 
this problem or all gadgets have to support full speed?

>
>>   	 */
>> -	max = 0x7ff & usb_endpoint_maxp(desc);
>>   	switch (type) {
>> +	case USB_ENDPOINT_XFER_BULK:
>> +		/*
>> +		 * LIMITS:
>> +		 * full speed:    64 bytes
>> +		 * high speed:   512 bytes
>> +		 * super speed: 1024 bytes
>> +		 */
>> +		if (max == 0) {
>> +			if (gadget_is_superspeed(gadget))
>> +				desc->wMaxPacketSize = cpu_to_le16(1024);
>> +			else if (gadget_is_dualspeed(gadget))
>> +				desc->wMaxPacketSize = cpu_to_le16(512);
>> +			else
>> +				desc->wMaxPacketSize = cpu_to_le16(64);
>
> So these lines are wrong.  Also, how do you know that 64 is correct for
> full speed?  The hardware might only support 32.
>
>> +		} else {
>> +			if (max > 1024)
>> +				return 0;
>> +			if (!gadget_is_superspeed(gadget) && max > 512)
>> +				return 0;
>> +			if (!gadget_is_dualspeed(gadget) && max > 64)
>> +				return 0;
>> +		}
>
> For bulk endpoints, you should ignore the original value in the
> descriptor.  All that matters is ep->maxpacket; it will override the
> value in the descriptor.
>
>> +		break;
>> +
>>   	case USB_ENDPOINT_XFER_INT:
>> -		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
>> -		if (!gadget_is_dualspeed(gadget) && max > 64)
>> -			return 0;
>> -		/* FALLTHROUGH */
>> +		/*
>> +		 * LIMITS:
>> +		 * full speed:		64 bytes
>> +		 * high/super speed:  1024 bytes
>> +		 * multiple transactions per microframe only for super speed
>
> The last comment is wrong.  High speed also allows multiple interrupt
> transactions in a microframe.
>
> Also, why bother to spell out the limits in the comment?  You're not
> going to use those values; you're going to use the limit in
> ep->maxpacket.
>
>> +		 */
>> +		if (max == 0) {
>> +			if (gadget_is_dualspeed(gadget))
>> +				desc->wMaxPacketSize = cpu_to_le16(1024);
>> +			else
>> +				desc->wMaxPacketSize = cpu_to_le16(64);
>
> These values should be taken from ep->maxpacket, not from the spec.
>
>> +		} else {
>> +			if (max > 1024)
>> +				return 0;
>> +			if (!gadget_is_superspeed(gadget))
>> +				if ((desc->wMaxPacketSize & cpu_to_le16(3<<11)))
>> +					return 0;
>> +			if (!gadget_is_dualspeed(gadget) && max > 64)
>> +				return 0;
>
> The first and third tests are unnecessary, because you have already
> checked that max <= ep->maxpacket.
>
> Similar issues apply to the Isochronous case.
>

Best regards
Robert Baldyga
Samsung R&D Institute Poland

