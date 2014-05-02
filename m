Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaEBS27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:28:59 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:56020
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbaEBS26 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:28:58 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging/comedi: fix sparse warning: shift too big
Thread-Topic: [PATCH] staging/comedi: fix sparse warning: shift too big
Thread-Index: AQHPZhbN4Q7heBi8Ik+QHge+NJx2Z5st9jsA//+ib9A=
Date: Fri, 2 May 2014 18:28:57 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E355FD@P3PWEX4MB008.ex4.secureserver.net>
References: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
 <5363CCAE.9000006@mev.co.uk>
In-Reply-To: <5363CCAE.9000006@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 9:50 AM, Ian Abbott wrote:
> On 2014-05-02 15:57, Brilliantov Kirill Vladimirovich wrote:
>> Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
>> ---
>>   drivers/staging/comedi/drivers/ni_stc.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
>> index f0630b78..197b568 100644
>> --- a/drivers/staging/comedi/drivers/ni_stc.h
>> +++ b/drivers/staging/comedi/drivers/ni_stc.h
>> @@ -717,7 +717,7 @@ enum AI_AO_Select_Bits {
>>   static inline unsigned ni_stc_dma_channel_select_bitfield(unsigned channel)
>>   {
>>   	if (channel < 4)
>> -		return 1 << channel;
>> +		return 1 << (channel & 0x3);
>>   	if (channel == 4)
>>   		return 0x3;
>>   	if (channel == 5)
>>
>
> The warning seems a bit spurious!

The whole mite.c driver and it's users are all a bit of a mess.

I did find the information about the "AI AO Select Register" in the National
Instruments PCI E Series manual:

-----

The AI AO Select Register contains 8 bits that control the logical DMA selection for the
analog input and analog output resources. The contents of this register are cleared upon power
up and after a reset condition.
	Address:	base address + 0x09
	Type:		write-only
	Word size:	8-bit

	Bit	Name		Description
	7-4	Reserved	Reserved-Always write 0 to these bits (for PCI-6032E
				and PCI-6033E only).
	7-4	Output<D..A>	Analog Output Logical Channel D through A-These four
				bits select the logical channels of the MITE to be used by
				the analog output. You can only set one of these bits at a
				time (except for the PCI-6032E and PCI-6033E).
	3-0	Input<D..A>	Analog Input Logical Channel D through A-These four
				bits select the logical channels to be used by the analog
				input. You can only set one of these bits at a time.

-----

Based on this the ni_stc_dma_channel_select_bitfield() function appears to be
incorrect. The "channel"s should only be in the range 0 to 3 and result in a returned
bitfield of:

	channel	bitfield	Description
	0		0x01	Analog Input or Output Channel A
	1		0x02 	Analog Input or Output Channel B
	2		0x04 	Analog Input or Output Channel C
	3		0x08 	Analog Input or Output Channel D

Just my two cents...

Hartley

