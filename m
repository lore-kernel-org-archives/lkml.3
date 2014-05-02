Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaEBUhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:37:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58933 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbaEBUhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:37:16 -0400
Message-ID: <5363FF10.306@mev.co.uk>
Date: Fri, 2 May 2014 21:24:48 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: fix sparse warning: shift too big
References: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru> <5363CCAE.9000006@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D8825E355FD@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E355FD@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/14 19:28, Hartley Sweeten wrote:
> On Friday, May 02, 2014 9:50 AM, Ian Abbott wrote:
>> On 2014-05-02 15:57, Brilliantov Kirill Vladimirovich wrote:
>>> Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
>>> ---
>>>    drivers/staging/comedi/drivers/ni_stc.h | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
>>> index f0630b78..197b568 100644
>>> --- a/drivers/staging/comedi/drivers/ni_stc.h
>>> +++ b/drivers/staging/comedi/drivers/ni_stc.h
>>> @@ -717,7 +717,7 @@ enum AI_AO_Select_Bits {
>>>    static inline unsigned ni_stc_dma_channel_select_bitfield(unsigned channel)
>>>    {
>>>    	if (channel < 4)
>>> -		return 1 << channel;
>>> +		return 1 << (channel & 0x3);
>>>    	if (channel == 4)
>>>    		return 0x3;
>>>    	if (channel == 5)
>>>
>>
>> The warning seems a bit spurious!
>
> The whole mite.c driver and it's users are all a bit of a mess.
>
> I did find the information about the "AI AO Select Register" in the National
> Instruments PCI E Series manual:
>
> -----
>
> The AI AO Select Register contains 8 bits that control the logical DMA selection for the
> analog input and analog output resources. The contents of this register are cleared upon power
> up and after a reset condition.
> 	Address:	base address + 0x09
> 	Type:		write-only
> 	Word size:	8-bit
>
> 	Bit	Name		Description
> 	7-4	Reserved	Reserved-Always write 0 to these bits (for PCI-6032E
> 				and PCI-6033E only).
> 	7-4	Output<D..A>	Analog Output Logical Channel D through A-These four
> 				bits select the logical channels of the MITE to be used by
> 				the analog output. You can only set one of these bits at a
> 				time (except for the PCI-6032E and PCI-6033E).
> 	3-0	Input<D..A>	Analog Input Logical Channel D through A-These four
> 				bits select the logical channels to be used by the analog
> 				input. You can only set one of these bits at a time.
>
> -----
>
> Based on this the ni_stc_dma_channel_select_bitfield() function appears to be
> incorrect. The "channel"s should only be in the range 0 to 3 and result in a returned
> bitfield of:
>
> 	channel	bitfield	Description
> 	0		0x01	Analog Input or Output Channel A
> 	1		0x02 	Analog Input or Output Channel B
> 	2		0x04 	Analog Input or Output Channel C
> 	3		0x08 	Analog Input or Output Channel D
>
> Just my two cents...

Apparently, the M-series cards have six DMA channels - two more than the 
E-series cards.  They must have decided to keep the existing bitfield 
encoding for the first four channels for backwards compatibility, and 
use special bitfield values for the extra channels.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
