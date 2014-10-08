Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaJHBmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:42:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:14362 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaJHBmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:42:44 -0400
Message-ID: <54349671.6090008@huawei.com>
Date: Wed, 8 Oct 2014 09:42:09 +0800
From: He YunLei <heyunlei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <wangbintian@huawei.com>,
        <liguozhu@hisilicon.com>, <kong.kongxinwei@hisilicon.com>
Subject: Re: [RFC PATCH] pinctrl: pinctrl-single.c:  init pinctrl single at
 arch_initcall time
References: <542934F4.10303@huawei.com> <20140929175427.GE3122@atomide.com>
In-Reply-To: <20140929175427.GE3122@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.64.99]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/30 1:54, Tony Lindgren wrote:
> * He YunLei <heyunlei@huawei.com> [140929 03:32]:
>> On our arm platform, some modules (e.g. I2C bus driver) will use the
>> pinctrl-single driver to configure the SoC pin, but pinctrl-single driver
>> uses module_init time, that makes some modules initialize ahead the
>> pinctrl-single and fail to register.
>>
>> This patch promotes the initialization priority of pinctrl-single from
>> module_init time to arch_initcall time.
>
> This has come up earlier and so far in all cases the problem
> is that you have custom initcall levels for your other drivers.
>
> Get rid of custom initcall levels for your drivers and the
> problem goes away. There's no need to init the drivers earlier
> nowadays. If you have other dependencies then deferred probe
> helps but should be only needed for a limited number of cases.
>
> We want to initialize things later, not earlier in general. That
> removes the issues of no proper debug output while booting the
> kernel.
>
> Regards,
>
> Tony
>
>
>> Signed-off-by: Yunlei He <heyunlei@huawei.com>
>> Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
>> ---
>>   drivers/pinctrl/pinctrl-single.c |   13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-single.c
>> b/drivers/pinctrl/pinctrl-single.c
>> index 95dd9cf..4b9e5b9 100644
>> --- a/drivers/pinctrl/pinctrl-single.c
>> +++ b/drivers/pinctrl/pinctrl-single.c
>> @@ -2012,7 +2012,18 @@ static struct platform_driver pcs_driver = {
>>   #endif
>>   };
>>
>> -module_platform_driver(pcs_driver);
>> +static int __init pinctrl_single_init(void)
>> +{
>> +		return platform_driver_register(&pcs_driver);
>> +}
>> +
>> +static void __exit pinctrl_single_exit(void)
>> +{
>> +		platform_driver_unregister(&pcs_driver);
>> +}
>> +
>> +arch_initcall(pinctrl_single_init);
>> +module_exit(pinctrl_single_exit);
>>
>>   MODULE_AUTHOR("Tony Lindgren <tony@atomide.com>");
>>   MODULE_DESCRIPTION("One-register-per-pin type device tree based pinctrl
>> driver");
>> --
>> 1.7.9.5
>>
>
> .
>

Thanks for your review and I am really appreciated it, but in our arm 
platform, we haven't custom initcall levels for other drivers. Although 
deferred probe helps other drivers to register well, we are also 
confused for the issues of lots of pin request errors debug output while 
booting the kernel. Besides, if the number is bigger than the limited 
number, whether deferred probe can solve this problem.

Regards,
He YunLei

