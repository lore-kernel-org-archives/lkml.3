Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaCEQUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:20:25 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42026 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaCEQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:20:21 -0500
Message-ID: <53174EB5.1090803@gmail.com>
Date: Wed, 05 Mar 2014 17:20:05 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 03/11] ARM: exynos: Move to generic power domain bindings
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com> <1393862536-9842-4-git-send-email-tomasz.figa@gmail.com> <1713847.uSatLFRtJj@amdc1032>
In-Reply-To: <1713847.uSatLFRtJj@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartek,

On 05.03.2014 17:15, Bartlomiej Zolnierkiewicz wrote:
>
> Hi Tomek,
>
> On Monday, March 03, 2014 05:02:08 PM Tomasz Figa wrote:
>> This patch moves Exynos power domain code to use the new generic power
>> domain look-up framework introduced by previous patch, allowing the new
>> code to be compiled with CONFIG_ARCH_EXYNOS selected as well.
>>
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>> ---
>>   .../bindings/arm/exynos/power_domain.txt           | 12 ++--
>>   arch/arm/mach-exynos/pm_domains.c                  | 80 +---------------------
>>   kernel/power/Kconfig                               |  2 +-
>>   3 files changed, 7 insertions(+), 87 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>> index 5216b41..60f26a8 100644
>> --- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>> +++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>> @@ -8,6 +8,8 @@ Required Properties:
>>       * samsung,exynos4210-pd - for exynos4210 type power domain.
>>   - reg: physical base address of the controller and length of memory mapped
>>       region.
>> +- #power-domain-cells: number of cells in power domain specifier;
>> +    must be 0.
>>
>>   Node of a device using power domains must have a samsung,power-domain property
>>   defined with a phandle to respective power domain.
>> @@ -17,12 +19,8 @@ Example:
>>   	lcd0: power-domain-lcd0 {
>>   		compatible = "samsung,exynos4210-pd";
>>   		reg = <0x10023C00 0x10>;
>> +		#power-domain-cells = <0>;
>>   	};
>>
>> -Example of the node using power domain:
>> -
>> -	node {
>> -		/* ... */
>> -		samsung,power-domain = <&lcd0>;
>> -		/* ... */
>> -	};
>> +See Documentation/devicetree/bindings/power/power_domain.txt for description
>> +of consumer-side bindings.
>> diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
>> index 8fd2488..48ee6c9 100644
>> --- a/arch/arm/mach-exynos/pm_domains.c
>> +++ b/arch/arm/mach-exynos/pm_domains.c
>> @@ -75,78 +75,6 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
>>   	return exynos_pd_power(domain, false);
>>   }
>>
>> -static void exynos_add_device_to_domain(struct exynos_pm_domain *pd,
>> -					 struct device *dev)
>> -{
>> -	int ret;
>> -
>> -	dev_dbg(dev, "adding to power domain %s\n", pd->pd.name);
>> -
>> -	while (1) {
>> -		ret = pm_genpd_add_device(&pd->pd, dev);
>> -		if (ret != -EAGAIN)
>> -			break;
>> -		cond_resched();
>> -	}
>> -
>> -	pm_genpd_dev_need_restore(dev, true);
>> -}
>> -
>> -static void exynos_remove_device_from_domain(struct device *dev)
>> -{
>> -	struct generic_pm_domain *genpd = dev_to_genpd(dev);
>> -	int ret;
>> -
>> -	dev_dbg(dev, "removing from power domain %s\n", genpd->name);
>> -
>> -	while (1) {
>> -		ret = pm_genpd_remove_device(genpd, dev);
>> -		if (ret != -EAGAIN)
>> -			break;
>> -		cond_resched();
>> -	}
>> -}
>> -
>> -static void exynos_read_domain_from_dt(struct device *dev)
>> -{
>> -	struct platform_device *pd_pdev;
>> -	struct exynos_pm_domain *pd;
>> -	struct device_node *node;
>> -
>> -	node = of_parse_phandle(dev->of_node, "samsung,power-domain", 0);
>
> This removes "samsung,power-domain" phandle handling but I cannot find
> in your patch series updates to existing EXYNOS dts files converting
> them to use the new "power-domain" property.  Am I missing something?

Patch 01/11 adds generic parsing code along with fallback to the legacy 
"samsung,power-domain" property, if the generic one is not present, as 
it was pretty straightforward to implement it there.

Best regards,
Tomasz
