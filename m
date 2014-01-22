Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaAVCOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:14:14 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:43576 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaAVCON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:14:13 -0500
Message-ID: <52DF2963.7000608@gtsys.com.hk>
Date: Wed, 22 Jan 2014 10:13:55 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Markus Pargmann <mpa@pengutronix.de>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.infradead.org
Subject: Re: [PATCH] imx27: pinctrl: fix wrong offset to ICONFB
References: <1389835103-14811-1-git-send-email-chris.ruehl@gtsys.com.hk> <20140121102452.GA25016@pengutronix.de>
In-Reply-To: <20140121102452.GA25016@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On Tuesday, January 21, 2014 06:24 PM, Markus Pargmann wrote:
> Hi,
>
> On Thu, Jan 16, 2014 at 09:18:23AM +0800, Chris Ruehl wrote:
>> The offset to ICONFB was incorrect, this patch set the correct value 0x14.
>> dev_dbg in function imx1_write_2bit print the wrong address and had been
>> moved after address calculation.
>>
>> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
>
> Reviewed-by: Markus Pargmann <mpa@pengutronix.de>
>
> Perhaps this should go to the stable tree too for 3.13 and 3.14?

Yes of cause, and I have one more, the offset in

@@ -139,7 +139,7 @@ static int imx1_read_2bit(struct imx1_pinctrl *ipctl, 
unsigned int pin_id,
                 u32 reg_offset)
  {
         void __iomem *reg = imx1_mem(ipctl, pin_id) + reg_offset;
-       int offset = pin_id % 16;
+       int offset = (pin_id % 16) * 2;

         /* Use the next register if the pin's port pin number is >=16 */
         if (pin_id % 32 >= 16)

should fixed, otherwise the printout of 
/sys/kernel/debug/pinctrl/10015000.iomuxc/pins show prints the wrong confo / 
iconfa / iconfb

I prepare a patch.

With kind regards,
Chris

>
> Regards,
>
> Markus
>
>> ---
>>   drivers/pinctrl/pinctrl-imx1-core.c |    8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/pinctrl-imx1-core.c
>> index f77914a..8dfc3dc 100644
>> --- a/drivers/pinctrl/pinctrl-imx1-core.c
>> +++ b/drivers/pinctrl/pinctrl-imx1-core.c
>> @@ -45,7 +45,7 @@ struct imx1_pinctrl {
>>   #define MX1_DDIR 0x00
>>   #define MX1_OCR 0x04
>>   #define MX1_ICONFA 0x0c
>> -#define MX1_ICONFB 0x10
>> +#define MX1_ICONFB 0x14
>>   #define MX1_GIUS 0x20
>>   #define MX1_GPR 0x38
>>   #define MX1_PUEN 0x40
>> @@ -97,13 +97,13 @@ static void imx1_write_2bit(struct imx1_pinctrl *ipctl, unsigned int pin_id,
>>   	u32 old_val;
>>   	u32 new_val;
>>
>> -	dev_dbg(ipctl->dev, "write: register 0x%p offset %d value 0x%x\n",
>> -			reg, offset, value);
>> -
>>   	/* Use the next register if the pin's port pin number is >=16 */
>>   	if (pin_id % 32 >= 16)
>>   		reg += 0x04;
>>
>> +	dev_dbg(ipctl->dev, "write: register 0x%p offset %d value 0x%x\n",
>> +			reg, offset, value);
>> +
>>   	/* Get current state of pins */
>>   	old_val = readl(reg);
>>   	old_val &= mask;
>> --
>> 1.7.10.4
>>
>>
>

-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
