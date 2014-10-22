Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaJVSti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:49:38 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43205 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaJVSth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:49:37 -0400
Message-ID: <5447FC47.2060003@gmail.com>
Date: Wed, 22 Oct 2014 11:49:43 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ulf.hansson@linaro.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: keystone: pm: switch to use generic pm domains
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>	<1413809764-21995-3-git-send-email-grygorii.strashko@ti.com>	<5446A065.9050308@gmail.com> <544793B5.6080601@ti.com> <7h61fccd0v.fsf@deeprootsystems.com>
In-Reply-To: <7h61fccd0v.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 08:58 AM, Kevin Hilman wrote:
> Grygorii Strashko <grygorii.strashko@ti.com> writes:
>
>> Hi Santosh,
>>
>> On 10/21/2014 09:05 PM, Santosh Shilimkar wrote:
>>> On 10/20/2014 05:56 AM, Grygorii Strashko wrote:
>>>> This patch switches Keystone 2 PM code to use Generic PM domains
>>>> instead of PM clock domains because of the lack of DT support
>>>> for the last.
>>>>
>>>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> ---
>>>>    .../bindings/power/ti,keystone-powerdomain.txt     |  31 ++++++
>>>>    arch/arm/mach-keystone/Kconfig                     |   1 +
>>>>    arch/arm/mach-keystone/pm_domain.c                 | 112
>>>> ++++++++++++++-------
>>>>    3 files changed, 107 insertions(+), 37 deletions(-)
>>>>    create mode 100644
>>>> Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
>>>>

[..]

>>>> diff --git a/arch/arm/mach-keystone/pm_domain.c
>>>> b/arch/arm/mach-keystone/pm_domain.c
>>>> index ca79dda..d58759d 100644
>>>> --- a/arch/arm/mach-keystone/pm_domain.c
>>>> +++ b/arch/arm/mach-keystone/pm_domain.c
>>>> @@ -12,69 +12,107 @@
>>>>     * version 2, as published by the Free Software Foundation.
>>>>     */
>>>>
>>>> +#include <linux/clk.h>
>>>>    #include <linux/init.h>
>>>> -#include <linux/pm_runtime.h>
>>>>    #include <linux/pm_clock.h>
>>>> +#include <linux/pm_domain.h>
>>>>    #include <linux/platform_device.h>
>>>> -#include <linux/clk-provider.h>
>>>>    #include <linux/of.h>
>>>>
>>>> -#ifdef CONFIG_PM_RUNTIME
>>>> -static int keystone_pm_runtime_suspend(struct device *dev)
>>>> +#ifdef CONFIG_PM_GENERIC_DOMAINS
>>>> +
>>>> +struct keystone_domain {
>>>> +    struct generic_pm_domain genpd;
>>>> +    struct device    *dev;
>>>> +};
>>>> +
>>>> +void keystone_pm_domain_attach_dev(struct device *dev)
>>>>    {
>>>> +    struct clk *clk;
>>>>        int ret;
>>>> +    int i = 0;
>>>>
>>>>        dev_dbg(dev, "%s\n", __func__);
>>>>
>>>> -    ret = pm_generic_runtime_suspend(dev);
>>>> -    if (ret)
>>>> -        return ret;
>>>> -
>>>> -    ret = pm_clk_suspend(dev);
>>>> +    ret = pm_clk_create(dev);
>>>>        if (ret) {
>>>> -        pm_generic_runtime_resume(dev);
>>>> -        return ret;
>>>> +        dev_err(dev, "pm_clk_create failed %d\n", ret);
>>>> +        return;
>>>> +    };
>>>> +
>>>> +    while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>>>> +        ret = pm_clk_add_clk(dev, clk);
>>>> +        if (ret) {
>>>> +            dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>>>> +            goto clk_err;
>>>> +        };
>>>>        }
>>>>
>>>> -    return 0;
>>>> +    if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
>>> Can we not okkup two seperate callbacks instead of above check ?
>>> I don't like this CONFIG check here. Its slightly better version of
>>> ifdef in middle of the code.
>>
>> I've found more-less similar comment on patch
>> "Re: [PATCH v3 1/3] power-domain: add power domain drivers for Rockchip platform"
>> https://lkml.org/lkml/2014/10/17/257
>>
>> So, Would you like me to create patch which will enable clocks in pm_clk_add/_clk()
>> in case !IS_ENABLED(CONFIG_PM_RUNTIME)
>
> Yes, I think it's a good idea to propose that change and propose to
> Rafael on linux-pm.  Be sure that myself, Ulf and Geert are Cc'd.
>
Lets do that.

regards,
Santosh
