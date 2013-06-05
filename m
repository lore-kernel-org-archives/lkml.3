Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3FELch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:32:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37692 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab3FELcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:32:35 -0400
Message-ID: <51AF20F0.30000@ti.com>
Date: Wed, 5 Jun 2013 14:28:48 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: omap: convert to module_platform_driver()
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com> <1366723151-23209-2-git-send-email-grygorii.strashko@ti.com> <87fvwylxl8.fsf@linaro.org> <51ADD06B.3000201@ti.com> <87zjv5zq41.fsf@linaro.org>
In-Reply-To: <87zjv5zq41.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 09:29 PM, Kevin Hilman wrote:
> Grygorii Strashko <grygorii.strashko@ti.com> writes:
>
>> Hi Kevin,
>> On 06/03/2013 11:59 PM, Kevin Hilman wrote:
>>> Grygorii Strashko <grygorii.strashko@ti.com> writes:
>>>
>>>> The OMAP I2C driver has a relation to pinctrl-single driver. As result,
>>>> its probe will be deferred during system boot until late init time,
>>>> because the pinctrl-single is initizalized as moudle/device init time.
>>>> This, in turn, will delay initialization of all I2C devices (like mfd,
>>>> I2C regulators and etc.) and cause boot delay (more over, it can broken
>>>> initialization of drivers which are not ready to use deferred probe
>>>> mechanism yet, for example DSS).
>>>>
>>>> There are no sense to keep OMAP I2C initialization on subsys init layer
>>>> any more, hence shift it to module/device layer where the i2c <-->
>>>> pinctrl-single dependency is resolved in drivers/Makefile now.
>>>>
>>>> Cc: Wolfram Sang <wsa@the-dreams.de>
>>>> Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
>>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>> Cc: linux-omap@vger.kernel.org
>>>> Cc: linux-i2c@vger.kernel.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>>
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Testing this patch with PATCH 1/2, the twl_rtc driver fails to correctly
>>> initialize on OMAP3:
>>>
>>>            twl_rtc rtc.22: hctosys: invalid date/time
>>>
>>> instead of the expected result:
>>>
>>>             twl_rtc rtc.22: setting system clock to 2000-01-01 00:00:00 UTC (946684800)
>>>
>>> so something is still not right for the init sequence.
>>>
>>> Kevin
>> I think, the root cause of the problem isn't this patch - it's just
>> yet another side effect
>> of using deferred probes :). I've taken a look on twl-rtc code and
>> found possible error place
>> static int __init twl_rtc_init(void)
>> {
>>      if (twl_class_is_4030()) <------ here,
>>          rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
>>      else
>>          rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
>>
>>      return platform_driver_register(&twl4030rtc_driver);
>> }
>> In drivers/Makefile:
>> obj-$(CONFIG_RTC_LIB)        += rtc/  <------ RTC is placed before I2C
>> obj-y                += i2c/ media/ <----- and only here I2C bus
>> instantiates TWL-core device
>> and configures twl_priv->twl_id
>>
>> Thats why it's working on my OMAP4/twl6030 board. Could you check if
>> below fix will work on OMAP3:
> Yes, your fix works.  Thanks for digging into it.
>
> Care to send a proper patch?  Please be sure to send to Andrew Morton
> also, since he'll be the one to queue the RTC patch.
Hi Kevin,

The similar patch already exists:
https://patchwork.kernel.org/patch/2448251/ - [v2,1/2] RTC: rtc-twl: Fix 
rtc_reg_map initialization
from Peter Ujfalusi

-grygorii

>
>> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
>> index 8751a52..aaa5015 100644
>> --- a/drivers/rtc/rtc-twl.c
>> +++ b/drivers/rtc/rtc-twl.c
>> @@ -469,6 +469,11 @@ static int twl_rtc_probe(struct platform_device *pdev)
>>          if (irq <= 0)
>>                  goto out1;
>>
>> +       if (twl_class_is_4030())
>> +               rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
>> +       else
>> +               rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
>> +
>>          ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
>>          if (ret < 0)
>>                  goto out1;
>> @@ -610,11 +615,6 @@ static struct platform_driver twl4030rtc_driver = {
>>
>>   static int __init twl_rtc_init(void)
>>   {
>> -       if (twl_class_is_4030())
>> -               rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
>> -       else
>> -               rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
>> -
>>          return platform_driver_register(&twl4030rtc_driver);
>>   }
>>   module_init(twl_rtc_init);
>>
>> Unfortunately, I have no OMAP3 HW and can't check it.
> I suggest you find a Beagle or Gumstix/Overo type board someplace.
> There is an abundance of cheap OMAP3 hardware available.
>
> Kevin
>

