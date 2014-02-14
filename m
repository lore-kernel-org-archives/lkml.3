Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaBNKfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:35:30 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:25077 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbaBNKf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:35:27 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2014 05:35:26 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-6.tower-194.messagelabs.com!1392373719!10098127!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: RE: [RFC V1] mfd: da9063: Add support for production silicon
 variant code
Thread-Topic: [RFC V1] mfd: da9063: Add support for production silicon
 variant code
Thread-Index: AQHPKWf9+CU+DQqgfkW1F75og72Z1Zq0gQsQ
Date: Fri, 14 Feb 2014 10:28:38 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB78F97CB13@SW-EX-MBX02.diasemi.com>
References: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
 <20140214093435.GI3403@lee--X1>
In-Reply-To: <20140214093435.GI3403@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1EAZdXS002326

Thanks for your reply

On  14 February 2014 09:35 Lee Jones [mailto:lee.jones@linaro.org] wrote:

>> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>>
>> Add the correct silicon variant code ID (0x5) to the driver. This
>> new code is the 'production' variant code ID for DA9063.
>>
>> This patch will remove the older variant code ID which matches the
>> pre-production silicon ID (0x3) for the DA9063 chip.
>>
>> There is also some small amount of correction done in this patch: it
>> renames various incorrectly named variables and moves the dev_info()
>> call before the variant ID test.
>>
>> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>> ---
>>
>>  drivers/mfd/da9063-core.c       | 36 ++++++++++++++++++++----------------
>>  include/linux/mfd/da9063/core.h |  7 ++++++-
>>  2 files changed, 26 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
>> index 26937cd..80ce35a 100644
>> --- a/drivers/mfd/da9063-core.c
>> +++ b/drivers/mfd/da9063-core.c
>> @@ -1,3 +1,4 @@
>> +
>
>Unnecessary new line.
>
><snip>
>

Thanks! I spotted that after I set it yesterday 
It's gone in my latest patch.

>> +	da9063->model = chip_id;
>
>Why have you gone to lengths to rename 'model' to 'chip_id' locally,
>but still call it 'model' in the global container?
>

It's just a style change so naming convention matches the content I get
from the H/W engineers -- I was going to change this globally when I made 
the next set of changes, but I didn't add it here because I would have to
change the rest of the code and I just wanted to concentrate on the chip
variant detection with this patch.

>> diff --git a/include/linux/mfd/da9063/core.h
>b/include/linux/mfd/da9063/core.h
>> index 2d2a0af..2265ccb 100644
>> --- a/include/linux/mfd/da9063/core.h
>> +++ b/include/linux/mfd/da9063/core.h
>> @@ -1,3 +1,4 @@
>> +
>
>Remove this.
>

And again :(
I'm sorry you had to review that part.

>>  /*
>>   * Definitions for DA9063 MFD driver
>>   *
>> @@ -33,6 +34,10 @@ enum da9063_models {
>>  	PMIC_DA9063 = 0x61,
>>  };
>>
>> +enum da9063_variant_codes {
>> +	PMIC_DA9063_BB = 0x5
>
>Why not support both? It's only an extra few chars in the if().
>

Yep, it is only a small change -- but the implication of keeping support for the
previous silicon variant is fairly large at this point.

The previous silicon was only sent out in sample form to selected customers
and will no longer be available. I have been informed that the new silicon
has been sent out, and everybody should have received the new variant by
now. 

The new variant is the only one going into production and the previous silicon
variant will no longer be available. Also, the production silicon of DA9063
makes an alteration to the registers which makes the two register maps
incompatible.

These were known changes.

So, for those two reasons. I would prefer to remove support for the old variant
from the kernel.

>> +};
>> +
>>  /* Interrupts */
>>  enum da9063_irqs {
>>  	DA9063_IRQ_ONKEY = 0,
>> @@ -72,7 +77,7 @@ struct da9063 {
>>  	/* Device */
>>  	struct device	*dev;
>>  	unsigned short	model;
>
>Don't you want to change this to chip_id?
>

Yep, I will .. same reason as above.

>
>--
>Lee Jones
>Linaro STMicroelectronics Landing Team Lead
>Linaro.org â”‚ Open source software for ARM SoCs
>Follow Linaro: Facebook | Twitter | Blog

Thanks for your comments.

Regards,
Steve

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
