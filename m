Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3JIOiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:38:54 -0400
Received: from mailer1.option.com ([81.246.70.162]:47134 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3JIOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:38:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQEAGppVVIKAAAZ/2dsb2JhbABagz+Der4PF4EcdIIlAQEBBAECIAQJBBUwDAQCAQgNBAMBAgECAgYGEwUCAgIBAR8HJwgBAQQBDAYCAQEEAYdrAxumYohKDYlrgSmLL4EZG4EIBhAbBwQCgmQ1gQQDjxWGI2EBgxiFL4VthxyBQIFv
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
Content-class: urn:content-classes:message
Subject: Re: Fwd: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION GTM601 during RING indication
Date: Wed, 9 Oct 2013 16:38:34 +0200
Message-ID: <7685369CB6CCA443BA30E328A476A8CB2BDD6E@SRV-SATURNUS.OPTION.local>
In-Reply-To: <7685369CB6CCA443BA30E328A476A8CB2BDD6D@SRV-SATURNUS.OPTION.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Fwd: Fwd: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION GTM601 during RING indication
Thread-Index: Ac7E/UMiej4Z/5sEQJSaTduxXzaMAg==
References: <91D2D2F662ED984BACEF03B3F4B10BB803C47097@SRV-SATURNUS.OPTION.local> <91D2D2F662ED984BACEF03B3F4B10BB803C4709C@SRV-SATURNUS.OPTION.local> <7685369CB6CCA443BA30E328A476A8CB2BDD6D@SRV-SATURNUS.OPTION.local>
From: "Eric Verdonck" <E.Verdonck@option.com>
To: <marek.belisko@gmail.com>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>
Cc: "Jan Dumon" <j.dumon@option.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r99Ed4We012593


Met vriendelijke groeten,
Eric Verdonck
Driver Development
Option nv, Gaston Geenslaan 14, B-3001 Leuven

T: +32 16 311 597
F: +32 16 207 164
E-mail: e.verdonck@option.com
Website: www.option.com
Disclaimer:http://www.option.com/company/disclaimer.shtml

RPR Leuven 0429.375.448

On 10/09/2013 03:58 PM, Eric Verdonck wrote:
> Hi all,
>
> Thank you very much for your problem report. The line 
> le16_to_cpu(serial_state_notification->wIndex) != W_INDEX) in the 
> function "tiocmget_intr_callback" of the hso driver intents to discard 
> the notification if the notification urb is not coming from the modem 
> interface. Actually the line discards the urb if the interface number 
> differs from the hard coded value W_INDEX ( see Table 67: 
> Class-Specific Notifications of 
> www.usb.org/developers/devclass_docs/usbcdc11.pdfâ€ for the meaning of 
> wIndex). Depending of the tyoe of device used and/or depending of the 
> actual configuration of the device the interface number of the modem 
> port will vary. Therefore I would like to suggest to remove this check 
> and replace it by a discard if the urb doesn't belong to an interface 
> with its port_spec set to HSO_PORT_MODEM. This test has the advantage 
> that it's independend of the actual configuration or type of the modem 
> device ( see patch below)
>
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index e2dd324..288ec46 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -1503,7 +1503,7 @@ static void tiocmget_intr_callback(struct urb *urb)
> if (serial_state_notification->bmRequestType != BM_REQUEST_TYPE ||
> serial_state_notification->bNotification != B_NOTIFICATION ||
> le16_to_cpu(serial_state_notification->wValue) != W_VALUE ||
> - le16_to_cpu(serial_state_notification->wIndex) != W_INDEX ||
> + (serial->parent->port_spec & HSO_PORT_MASK) != HSO_PORT_MODEM ||
> le16_to_cpu(serial_state_notification->wLength) != W_LENGTH) {
> dev_warn(&usb->dev,
> "hso received invalid serial state notification\n");
> Best regards,
> Eric Verdonck
> Firmware development engineer
> Option nv, Gaston Geenslaan 14, B-3001 Leuven
>
> T: +32 16 311 597
> F: +32 16 207 164
> E-mail:e.verdonck@option.com
> Website:www.option.com  
> Disclaimer:http://www.option.com/company/disclaimer.shtml
>
> RPR Leuven 0429.375.448
>
> On 10/09/2013 01:37 PM, Jan Dumon wrote:
>>
>>
>>
>> -------- Original Message --------
>> Subject: 	Fwd: [PATCH 1/1] hso: fix problem with wrong status code 
>> sent by OPTION GTM601 during RING indication
>> Date: 	Fri, 4 Oct 2013 08:49:46 +0200
>> From: 	Jan Dumon <J.Dumon@option.com>
>> To: 	Axel Schollaert <a.schollaert@option.com>
>>
>>
>>
>>
>>
>>
>> -------- Original Message --------
>> Subject: 	[PATCH 1/1] hso: fix problem with wrong status code sent by 
>> OPTION GTM601 during RING indication
>> Date: 	Wed, 2 Oct 2013 09:00:18 +0200
>> From: 	Dr. H. Nikolaus Schaller <hns@goldelico.com>
>> To: 	Jan Dumon <j.dumon@option.com>
>> CC: 	Belisko Marek <marek.belisko@gmail.com>, 
>> linux-usb@vger.kernel.org, netdev@vger.kernel.org, 
>> linux-kernel@vger.kernel.org
>>
>>
>>
>> Hi Jan,
>>
>> we are using a GTM601 modem (Firmware 1.7) for a while and have spotted an
>> issue that under some conditions the modem sends a packed wIndex over USB
>> that is rejected by the hso driver making troubles afterwards. Not rejecting makes
>> it work fine.
>>
>> BR,
>> Nikolaus Schaller
>>
>> ---
>>
>>  From f5c7e15b61f2ce4fe3105ff914f6bfaf5d74af0d Mon Sep 17 00:00:00 2001
>> From: "H. Nikolaus Schaller"<hns@goldelico.com>
>> Date: Thu, 15 Nov 2012 14:40:57 +0100
>> Subject: [PATCH 1/1] hso: fix problem with wrong status code sent by OPTION
>>   GTM601 during RING indication
>>
>>   It has been observed that the GTM601 with 1.7 firmware sometimes sends a value
>>   wIndex that has bit 0x04 set instead of being reset as the code expects. So we
>>   mask it for the error check.
>>   
>>   Seehttp://lists.goldelico.com/pipermail/gta04-owner/2012-February/001643.html
>>
>> Signed-off-by: NeilBrown<neilb@suse.de>
>> Signed-off-by: H. Nikolaus Schaller<hns@goldelico.de>
>> ---
>>   drivers/net/usb/hso.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
>> index cba1d46..d146e26 100644
>> --- a/drivers/net/usb/hso.c
>> +++ b/drivers/net/usb/hso.c
>> @@ -1503,7 +1503,8 @@ static void tiocmget_intr_callback(struct urb *urb)
>>   	if (serial_state_notification->bmRequestType != BM_REQUEST_TYPE ||
>>   	    serial_state_notification->bNotification != B_NOTIFICATION ||
>>   	    le16_to_cpu(serial_state_notification->wValue) != W_VALUE ||
>> -	    le16_to_cpu(serial_state_notification->wIndex) != W_INDEX ||
>> +	    (le16_to_cpu(serial_state_notification->wIndex) & ~0x4) !=
>> +		W_INDEX ||
>>   	    le16_to_cpu(serial_state_notification->wLength) != W_LENGTH) {
>>   		dev_warn(&usb->dev,
>>   			 "hso received invalid serial state notification\n");
>> -- 
>> 1.7.7.4
>>
>>
>>
>>
>>
>>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
