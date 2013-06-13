Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3FMGSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:18:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46186 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3FMGSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:18:39 -0400
Message-ID: <51B96410.7000807@ti.com>
Date: Thu, 13 Jun 2013 11:47:52 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] gpio: davinci: Modify to platform driver
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-4-git-send-email-avinashphilip@ti.com> <51B71056.9010103@ti.com> <518397C60809E147AF5323E0420B992E3EAD9D75@DBDE04.ent.ti.com> <51B826BF.7050009@ti.com> <518397C60809E147AF5323E0420B992E3EADA252@DBDE04.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EADA252@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2013 5:40 PM, Philip, Avinash wrote:
> On Wed, Jun 12, 2013 at 13:13:59, Nori, Sekhar wrote:
>> On 6/11/2013 6:25 PM, Philip, Avinash wrote:
>>
>>> On Tue, Jun 11, 2013 at 17:26:06, Nori, Sekhar wrote:
>>
>>>> On 5/22/2013 12:40 PM, Philip Avinash wrote:
>>
>>>>> @@ -179,13 +204,10 @@ static int __init davinci_gpio_setup(void)
>>>>>  		gpiochip_add(&ctlrs[i].chip);
>>>>>  	}
>>>>>  
>>>>> -	soc_info->gpio_ctlrs = ctlrs;
>>>>
>>>>> -	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);
>>>>
>>>> You drop setting gpio_ctlrs_num here and don't introduce it anywhere
>>>> else in the patchset so in effect you render the inline gpio get/set API
>>>> useless. Looks like this initialization should be moved to platform code?
>>>
>>> With [PATCH 08/11] ARM: davinci: start using gpiolib support gpio get/set API
>>> Has no more dependency on soc_info->gpio_ctlrs_num.
>>
>> With this series, you have removed support for inline gpio get/set API.
>> I see that the inline functions are still available for use on
>> tnetv107x. I wonder why it is important to keep these for tnetv107x when
>> not necessary for other DaVinci devices?
> 
> To support DT boot in da850, gpio davinci has to be converted to a driver and
> remove references to davinci_soc_info from driver. But tnetv107x has 
> separate GPIO driver and reference to davinci_soc_info can also be removed.
> But I didn't found defconfig support for tnetv107x platforms and left untouched.
> As I will not be able to build and test on tnetv107x, I prefer to not touch it.

You can always build it by enabling it in menuconfig. Its an ARMv6
platform so you will have to disable other ARMv5 based platforms from
while enabling it. ARMv5 and ARMv6 cannot co-exist in the same image.

> 
>>
>> When you are removing this feature, please note it prominently in your
>> cover letter and patch description.
> 
> Ok
> 
>> Also, please provide some data on 
>> how the latency now compares to that of inline access earlier. This is
>> important especially for the read.
> 
> I am not sure whether I understood correctly or not? Meanwhile I had done
> an experiment by reading printk timing before and after gpio_get_value from
> a test module. I think this will help in software latency for inline access over
> gpiolib specific access.
> 
> gpio_get_value latency testing code
> 
> +
> +       local_irq_disable();
> +       pr_emerg("%d %x\n", __LINE__, jiffies);
> +       gpio_get_value(gpio_num);
> +       pr_emerg("%d %x\n", __LINE__, jiffies);
> +       local_irq_enable();
> 
> inline gpio functions with interrupt disabled
> [   29.734337] 81 ffff966c
> [   29.736847] 83 ffff966c
> 
> Time diff = 	0.00251
> 
> gpio library with interrupt disabled
> 
> [  272.876763] 81 fffff567
> [  272.879291] 83 fffff567
> 
> Time diff =	0.002528
> 
> Inline function takes less time as expected.

Okay, please note these experiments in your cover letter. Its an 18usec
difference. I have no reference to say if that will affect any
application, but it will at least serve as information for someone who
may get affected by it.

> 
>> For the writes, gpio clock will
>> mostly determine how soon the value changes on the pin.
>>
>> I am okay with removing the inline access feature. It helps simplify
>> code and most arm machines don't use them. I would just like to see some
>> data for justification as this can be seen as feature regression. Also,
>> if we are removing it, its better to also remove it completely and get
>> the LOC savings instead of just stopping its usage.
> 
> I see build failure with below patch for tnetv107x
> [v6,6/6] Davinci: tnetv107x default configuration 

Where is this patch? What is the commit-id if it is in mainline? Where
is the failure log?

> 
> So I prefer to leave tnetv107x platform for now.

I don't think that's acceptable. At least by me.

Thanks,
Sekhar
