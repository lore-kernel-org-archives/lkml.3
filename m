Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaKTNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:09:26 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:32916 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKTNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:09:25 -0500
From: Dmitry Lavnikevich <D.Lavnikevich@sam-solutions.com>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
CC: Support Opensource <Support.Opensource@diasemi.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Topic: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Index: AQHQBKf+aAnFetIHV0qwuDSOzEEmNpxpLRYAgAAdrYA=
Date: Thu, 20 Nov 2014 13:09:16 +0000
Message-ID: <8A823154-DC33-4A5A-9B4B-8B0E3BCFE83C@sam-solutions.com>
References: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B4836D@SW-EX-MBX02.diasemi.com>
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7D0B4836D@SW-EX-MBX02.diasemi.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.111.33]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A261DD5BAF2C24194BF3552E8A73CBD@sam-solutions.net>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAKD9Wjr010338


> On 20Nov, 2014, at 12:23, Opensource [Steve Twiss] <stwiss.opensource@diasemi.com> wrote:
> 
> On 20 November 2014 09:55 Dmitry Lavnikevich wrote:
> 
>> Call platform_get_irq_byname() returns local IRQ number. Use
>> regmap_irq_get_virq() to get VIRQ instead.
>> This fixes rtc initialization error:
>> da9063-rtc da9063-rtc: Failed to request ALARM IRQ 1: -22
>> 
>> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> 
> Hi Dmitry,
> 
> Please refer to the previous patch :
> http://patchwork.ozlabs.org/patch/329051/

Yes, Iâ€™ve seen this patch for da9055.
I have no hardware with da9055 to test it but as I understood from
da9055-core.c sources the difference is in regmap_add_irq_chip()
call. Looks like passing irq_base = -1 to it dynamically allocates
irq_base so call regmap_irq_chip_get_base() then returns base for
virtual IRQ.

In case of da9063 there is no use of
regmap_add_irq_chip/regmap_irq_chip_get_base and because of that
da9063-core registeres IRQ using irq_base=0 and therefore is local
instead of virtual.

>> ---
>> drivers/rtc/rtc-da9063.c | 1 +
>> 1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
>> index 731ed1a..04743a6 100644
>> --- a/drivers/rtc/rtc-da9063.c
>> +++ b/drivers/rtc/rtc-da9063.c
>> @@ -315,6 +315,7 @@ static int da9063_rtc_probe(struct platform_device
>> *pdev)
>> 	platform_set_drvdata(pdev, rtc);
>> 
>> 	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
>> +	irq_alarm = regmap_irq_get_virq(da9063->regmap_irq, irq_alarm);
>> 	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
>> 					da9063_alarm_event,
>> 					IRQF_TRIGGER_LOW |
>> IRQF_ONESHOT,
>> --
>> 2.1.3
> 
> This patch above gives the following error when running on the DA9063:
> 
> da9063-rtc da9063-rtc: Failed to request ALARM IRQ -22: -22
> da9063-rtc: probe of da9063-rtc failed with error -22

I have tested this patch on pfla02 board and it was ok. On which
board this fail occured?

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
