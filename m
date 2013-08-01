Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3HAIsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:48:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63225 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3HAIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <CADGdYn4DA83AcxAzEJW-ndg+wvojruqJYY=urKhxn_6GjJzE3w@mail.gmail.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com> <CADGdYn4DA83AcxAzEJW-ndg+wvojruqJYY=urKhxn_6GjJzE3w@mail.gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 1 Aug 2013 14:18:22 +0530
Message-ID: <CAHfPSqAQ_tc+kKR+EBNCa5gM=2AJtnjt8uCdUgHV-1VNA_-9bQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos: Handle the misplaced TRIMINFO register
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 August 2013 14:02, amit daniel kachhap <amit.daniel@samsung.com> wrote:
> Hi Naveen,
>
> Can you rebase these patches against
> https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux-soc-thermal.git/log/?h=next.
> All these patches have been queued for 3.12 merge and contains the new
> re-structured TMU driver.
Sure, I will re base and submit.
>
> Thanks,
> Amit Daniel
>
> On Thu, Aug 1, 2013 at 11:32 AM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> This patch adds code to handle the misplaced TRIMINFO register
>> incase of Exynos5420.
>>
>> On Exynos5420 we have a TRIMINFO register being misplaced for
>> TMU channels 2, 3 and 4
>>
>> TRIMINFO at 0x1006c000 contains data for TMU channel 3
>> TRIMINFO at 0x100a0000 contains data for TMU channel 4
>> TRIMINFO at 0x10068000 contains data for TMU channel 2
>>
>> The misplaced register address is passed through devicetree and
>> map it seperately during probe.
>> Also, adds the documentation under devicetree/bindings/thermal/
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>> ---
>>
>> Rebased on http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> master branch. I'm not sure which one is the right tree to rebase.
>>
>>  .../devicetree/bindings/thermal/exynos-thermal.txt | 48 ++++++++++++++++++++++
>>  drivers/thermal/exynos_thermal.c                   | 26 +++++++++++-
>>  2 files changed, 72 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> new file mode 100644
>> index 0000000..1db279e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> @@ -0,0 +1,48 @@
>> +* Exynos Thermal
>> +
>> +Required properties:
>> +- compatible: should be one of the following.
>> +    * "samsung,exynos4210-tmu" - for controllers compatible with exynos4210 tmu.
>> +    * "samsung,exynos5250-tmu" - for controllers compatible with exynos5250 tmu.
>> +    * "samsung,exynos5420-tmu" - for controllers compatible with exynos5420 tmu.
>> +
>> +- reg: physical base address of the controller and length of
>> +  memory mapped region.
>> +
>> +    ** NOTE FOR EXYNOS5420 **
>> +    TRIMINFO register is being misplaced for TMU channels 2, 3 and 4
>> +
>> +    TERMINFO for TMU channel 2 is present in address space of TMU channel 3
>> +    TERMINFO for TMU channel 3 is present in address space of TMU channel 4
>> +    TERMINFO for TMU channel 4 is present in address space of TMU channel 2
>> +
>> +    * In such cases the reg property contains the misplaced register address and
>> +      range as the second parameter.
>> +
>> +- interrupts : interrupt number to the cpu.
>> +- clocks : Clock number as per common clock framework for the cpu.
>> +- clock-names : clock name to be used in the driver
>> +
>> +Example:
>> +
>> +       /* tmu for CPU0 */
>> +       tmu@10060000 {
>> +               compatible = "samsung,exynos5420-tmu";
>> +               reg = <0x10060000 0x100>;
>> +               interrupts = <0 65 0>;
>> +               clocks = <&clock 318>;
>> +               clock-names = "tmu_apbif";
>> +       };
>> +
>> +Example: In case of Exynos5420 TMU channel 3
>> +
>> +       /* tmu for CPU3 */
>> +       tmu@1006c000 {
>> +               compatible = "samsung,exynos5420-tmu";
>> +               /* 2nd reg is for the misplaced TRIMINFO register */
>> +               reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
>> +               interrupts = <0 185 0>;
>> +               clocks = <&clock 318>;
>> +               clock-names = "tmu_apbif";
>> +       };
>> +
>> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
>> index cec3f1f..a229314 100644
>> --- a/drivers/thermal/exynos_thermal.c
>> +++ b/drivers/thermal/exynos_thermal.c
>> @@ -38,6 +38,7 @@
>>  #include <linux/cpufreq.h>
>>  #include <linux/cpu_cooling.h>
>>  #include <linux/of.h>
>> +#include <linux/of_address.h>
>>
>>  #include <plat/cpu.h>
>>  #include <mach/regs-pmu.h>     /* for EXYNOS5_PS_HOLD_CONTROL */
>> @@ -123,7 +124,7 @@ struct exynos_thermal_zone;
>>  struct exynos_tmu_data {
>>         struct exynos_tmu_platform_data *pdata;
>>         struct resource *mem;
>> -       void __iomem *base;
>> +       void __iomem *base, *triminfo_base;
>>         int irq;
>>         enum soc_type soc;
>>         struct work_struct irq_work;
>> @@ -665,8 +666,14 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>                 __raw_writel(EXYNOS_TRIMINFO_RELOAD,
>>                                 data->base + EXYNOS_TMU_TRIMINFO_CON);
>>         }
>> +
>>         /* Save trimming info in order to perform calibration */
>> -       trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
>> +       if (data->triminfo_base)
>> +               /* On exynos5420 TRIMINFO is misplaced for some channels */
>> +               trim_info = readl(data->triminfo_base);
>> +       else
>> +               trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
>> +
>>         data->temp_error1 = trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
>>         data->temp_error2 = ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK);
>>
>> @@ -1016,6 +1023,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>                 return -ENODEV;
>>         }
>>
>> +       /* For Exynos5420 The misplaced TERMINFO register address will be
>> +        * passed from device tree node.
>> +        *
>> +        * We cannot use devm_request_and_ioremap, as the base address
>> +        * over laps with the address space of the other TMU channel.
>> +        * Check Documentation for details
>> +        */
>> +       data->triminfo_base = of_iomap(pdev->dev.of_node, 1);
>> +
>>         data->clk = devm_clk_get(&pdev->dev, "tmu_apbif");
>>         if (IS_ERR(data->clk)) {
>>                 dev_err(&pdev->dev, "Failed to get clock\n");
>> @@ -1086,6 +1102,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>  err_irq:
>>         exynos_unregister_thermal(data);
>>  err_clk:
>> +       if (data->triminfo_base)
>> +               iounmap(data->triminfo_base);
>> +
>>         platform_set_drvdata(pdev, NULL);
>>         clk_unprepare(data->clk);
>>         return ret;
>> @@ -1100,6 +1119,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>>
>>         exynos_unregister_thermal(data);
>>
>> +       if (data->triminfo_base)
>> +               iounmap(data->triminfo_base);
>> +
>>         clk_unprepare(data->clk);
>>
>>         platform_set_drvdata(pdev, NULL);
>> --
>> 1.7.12.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
