Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaJVLYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:24:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46779 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824AbaJVLYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:24:13 -0400
Message-ID: <544793B5.6080601@ti.com>
Date: Wed, 22 Oct 2014 14:23:33 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@gmail.com>, <ssantosh@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <khilman@linaro.org>,
        <ulf.hansson@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: keystone: pm: switch to use generic pm domains
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com> <1413809764-21995-3-git-send-email-grygorii.strashko@ti.com> <5446A065.9050308@gmail.com>
In-Reply-To: <5446A065.9050308@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On 10/21/2014 09:05 PM, Santosh Shilimkar wrote:
> On 10/20/2014 05:56 AM, Grygorii Strashko wrote:
>> This patch switches Keystone 2 PM code to use Generic PM domains
>> instead of PM clock domains because of the lack of DT support
>> for the last.
>>
>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   .../bindings/power/ti,keystone-powerdomain.txt     |  31 ++++++
>>   arch/arm/mach-keystone/Kconfig                     |   1 +
>>   arch/arm/mach-keystone/pm_domain.c                 | 112 
>> ++++++++++++++-------
>>   3 files changed, 107 insertions(+), 37 deletions(-)
>>   create mode 100644 
>> Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
>>
>> diff --git 
>> a/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt 
>> b/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
>> new file mode 100644
>> index 0000000..4bbf2aa
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
>> @@ -0,0 +1,31 @@
>> +* TI Keystone 2 Generic PM Controller
>> +
>> +The TI Keystone 2 Generic PM Controller is responsible for Clock gating
>> +for each controlled IP module.
>> +
>> +Required properties:
>> +- compatible: Should be "ti,keystone-powerdomain"
>> +- #power-domain-cells: Should be 0, see below:
>> +
>> +The gpc node is a power-controller as documented by the generic power 
>> domain
> You renamed gpc but missed to fix the comment ? Pls update it.

ok.

> 
>> +bindings in Documentation/devicetree/bindings/power/power_domain.txt.
>> +
>> +Example:
>> +
>> +    pm_controller: pm-controller {
>> +        compatible = "ti,keystone-powerdomain";
>> +        #power-domain-cells = <0>;
>> +    };
>> +
>> +    netcp: netcp@2090000 {
>> +        reg = <0x2620110 0x8>;
>> +        reg-names = "efuse";
>> +        ...
>> +        #address-cells = <1>;
>> +        #size-cells = <1>;
>> +        ranges;
>> +        power-domains = <&pm_controller>;
>> +
>> +        clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
>> +        dma-coherent;
>> +    }
>> diff --git a/arch/arm/mach-keystone/Kconfig 
>> b/arch/arm/mach-keystone/Kconfig
>> index 98a156a..de43107 100644
>> --- a/arch/arm/mach-keystone/Kconfig
>> +++ b/arch/arm/mach-keystone/Kconfig
>> @@ -9,6 +9,7 @@ config ARCH_KEYSTONE
>>       select COMMON_CLK_KEYSTONE
>>       select ARCH_SUPPORTS_BIG_ENDIAN
>>       select ZONE_DMA if ARM_LPAE
>> +    select PM_GENERIC_DOMAINS if PM
>>       help
>>         Support for boards based on the Texas Instruments Keystone 
>> family of
>>         SoCs.
>> diff --git a/arch/arm/mach-keystone/pm_domain.c 
>> b/arch/arm/mach-keystone/pm_domain.c
>> index ca79dda..d58759d 100644
>> --- a/arch/arm/mach-keystone/pm_domain.c
>> +++ b/arch/arm/mach-keystone/pm_domain.c
>> @@ -12,69 +12,107 @@
>>    * version 2, as published by the Free Software Foundation.
>>    */
>>
>> +#include <linux/clk.h>
>>   #include <linux/init.h>
>> -#include <linux/pm_runtime.h>
>>   #include <linux/pm_clock.h>
>> +#include <linux/pm_domain.h>
>>   #include <linux/platform_device.h>
>> -#include <linux/clk-provider.h>
>>   #include <linux/of.h>
>>
>> -#ifdef CONFIG_PM_RUNTIME
>> -static int keystone_pm_runtime_suspend(struct device *dev)
>> +#ifdef CONFIG_PM_GENERIC_DOMAINS
>> +
>> +struct keystone_domain {
>> +    struct generic_pm_domain genpd;
>> +    struct device    *dev;
>> +};
>> +
>> +void keystone_pm_domain_attach_dev(struct device *dev)
>>   {
>> +    struct clk *clk;
>>       int ret;
>> +    int i = 0;
>>
>>       dev_dbg(dev, "%s\n", __func__);
>>
>> -    ret = pm_generic_runtime_suspend(dev);
>> -    if (ret)
>> -        return ret;
>> -
>> -    ret = pm_clk_suspend(dev);
>> +    ret = pm_clk_create(dev);
>>       if (ret) {
>> -        pm_generic_runtime_resume(dev);
>> -        return ret;
>> +        dev_err(dev, "pm_clk_create failed %d\n", ret);
>> +        return;
>> +    };
>> +
>> +    while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>> +        ret = pm_clk_add_clk(dev, clk);
>> +        if (ret) {
>> +            dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>> +            goto clk_err;
>> +        };
>>       }
>>
>> -    return 0;
>> +    if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
> Can we not okkup two seperate callbacks instead of above check ?
> I don't like this CONFIG check here. Its slightly better version of
> ifdef in middle of the code.

I've found more-less similar comment on patch
"Re: [PATCH v3 1/3] power-domain: add power domain drivers for Rockchip platform"
https://lkml.org/lkml/2014/10/17/257

So, Would you like me to create patch which will enable clocks in pm_clk_add/_clk()
in case !IS_ENABLED(CONFIG_PM_RUNTIME)

regards,
-grygorii
 

