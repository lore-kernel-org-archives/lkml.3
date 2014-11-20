Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaKTOuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:50:19 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:18207 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbaKTOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:50:17 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2014 09:50:17 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-8.tower-39.messagelabs.com!1416494584!23337584!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.4; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Dmitry Lavnikevich <D.Lavnikevich@sam-solutions.com>
CC: Support Opensource <Support.Opensource@diasemi.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Topic: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Index: AQHQBKgC9623rLeXOUGgGvryE55nuJxpXOmwgAAgJgCAAAuPoA==
Date: Thu, 20 Nov 2014 14:43:01 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B483EE@SW-EX-MBX02.diasemi.com>
References: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B4836D@SW-EX-MBX02.diasemi.com>
 <8A823154-DC33-4A5A-9B4B-8B0E3BCFE83C@sam-solutions.com>
In-Reply-To: <8A823154-DC33-4A5A-9B4B-8B0E3BCFE83C@sam-solutions.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAKEoRYK011050

On 20 November 2014 13:09 Dmitry Lavnikevich wrote:

> > On 20Nov, 2014, at 12:23, Steve Twiss wrote:
> > On 20 November 2014 09:55 Dmitry Lavnikevich wrote:
> >
> >> Call platform_get_irq_byname() returns local IRQ number. Use
> >> regmap_irq_get_virq() to get VIRQ instead.
> >> This fixes rtc initialization error:
> >> da9063-rtc da9063-rtc: Failed to request ALARM IRQ 1: -22
> >>
> >> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> >
> > Hi Dmitry,
> >
> > Please refer to the previous patch :
> > http://patchwork.ozlabs.org/patch/329051/
> 
> Yes, Iâ€™ve seen this patch for da9055.
> I have no hardware with da9055 to test it but as I understood from
> da9055-core.c sources the difference is in regmap_add_irq_chip()
> call. Looks like passing irq_base = -1 to it dynamically allocates
> irq_base so call regmap_irq_chip_get_base() then returns base for
> virtual IRQ.

Hi Dmitry,
-- that is what I expect ... mmm..

[...]
> >
> > da9063-rtc da9063-rtc: Failed to request ALARM IRQ -22: -22
> > da9063-rtc: probe of da9063-rtc failed with error -22
> 
> I have tested this patch on pfla02 board and it was ok. On which
> board this fail occurred?

I am using a MCIMX6DL-SDP board -- although I the differences are in
my code base and not the platform in this case.
My apologies 

Regards,
Steve

patch follows:

=== DIFF of drivers/regulator/da9063-regulator.c ... linux-next/v3.18-rc5 
870,880c870,877
< 	regulators->irq_ldo_lim = regmap_irq_get_virq(da9063->regmap_irq, irq);
< 	if (regulators->irq_ldo_lim >= 0) {
< 		ret = request_threaded_irq(regulators->irq_ldo_lim,
< 					   NULL, da9063_ldo_lim_event,
< 					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
< 					   "LDO_LIM", regulators);
< 		if (ret) {
< 			dev_err(&pdev->dev,
< 					"Failed to request LDO_LIM IRQ.\n");
< 			regulators->irq_ldo_lim = -ENXIO;
< 		}
---
> 	ret = request_threaded_irq(irq,
> 				   NULL, da9063_ldo_lim_event,
> 				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> 				   "LDO_LIM", regulators);
> 	if (ret) {
> 		dev_err(&pdev->dev,
> 				"Failed to request LDO_LIM IRQ.\n");
> 		regulators->irq_ldo_lim = -ENXIO;
=== DIFF of drivers/mfd/da9063-core.c ... linux-next/v3.18-rc5 <> InSparse
121c121
< 		da9063->irq_base = 0;
---
> 		da9063->irq_base = -1;
170a171,172
> 	da9063->irq_base = regmap_irq_chip_get_base(da9063->regmap_irq);
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
