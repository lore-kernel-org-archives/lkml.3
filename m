Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3KLGUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:20:06 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51866 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3KLGT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:19:57 -0500
MIME-Version: 1.0
In-Reply-To: <1874386.ySRQp0THXS@amdc1227>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1383803612-31834-1-git-send-email-ch.naveen@samsung.com> <1874386.ySRQp0THXS@amdc1227>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Tue, 12 Nov 2013 11:49:34 +0530
Message-ID: <CAHfPSqBKtsT92MWG6oBeSovH5eRnRxR_k2GMQFOuc=N_0GFGBA@mail.gmail.com>
Subject: Re: [PATCH 3/3 v8] thermal: samsung: Add TMU support for Exynos5420 SoCs
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On 7 November 2013 20:39, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Naveen,
>
> On Thursday 07 of November 2013 11:23:32 Naveen Krishna Chatradhi wrote:
>> This patch adds the neccessary register changes and arch information
>> to support Exynos5420 SoCs
>> Exynos5420 has 5 TMU channels one for each CPU 0, 1, 2 and 3 and GPU
>>
>> Also updated the Documentation at
>> Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>>
>> Note: The platform data structure will be handled properly once the driver
>>  moves to complete device driver solution.
>
> Huh? I'm not sure what do you mean here.
This driver is handling platform data from a predefined structs in driver files.
Platform data is better handled when sent via Device tree nodes.

Will take up the device tree migration once this set is done.
>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> Changes since v1:
>> 1. modified the platform data structure in order to pass SHARED flag
>>    for channels that need sharing of address space.
>> 2. https://lkml.org/lkml/2013/8/1/38 is merged into this patch.
>>    As the changes are minimum and can be added here.
>> Changes since v3:
>>    a. Rearraged the code alphabetically, make exynso5420 come before exynso5440
>>    b. Reduce code duplication in passing platform data by introducing a common macro
>>       Bartlomiej Zolnierkiewicz Thanks for review and suggestions
>> Changes since v4:
>>  None
>> Changes since v5:
>>  None
>> Changes since v6:
>>  - removed the unsued field "inten_fall_shift"
>>  - defined EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT instead of using EXYNOS_TMU_FALL_INT_SHIFT
>> Changes since v7:
>>  - changes ins v6 were moved to the patch 1/3 of this patchset.
>>  - defined EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT instead of using EXYNOS_TMU_FALL_INT_SHIFT
>>
>>  .../devicetree/bindings/thermal/exynos-thermal.txt |   39 ++++++++
>>  drivers/thermal/samsung/exynos_tmu.c               |   12 ++-
>>  drivers/thermal/samsung/exynos_tmu.h               |    1 +
>>  drivers/thermal/samsung/exynos_tmu_data.c          |   98 ++++++++++++++++++++
>>  drivers/thermal/samsung/exynos_tmu_data.h          |    8 ++
>>  5 files changed, 157 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> index 116cca0..c5f9a74 100644
>> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>> @@ -6,6 +6,7 @@
>>              "samsung,exynos4412-tmu"
>>              "samsung,exynos4210-tmu"
>>              "samsung,exynos5250-tmu"
>> +            "samsung,exynos5420-tmu"
>
> I would add a second compatible value here for TMU units that have
> misplaced TRIMINFO data, e.g. "samsung,exynos5420-tmu-broken-triminfo"
> and explicitly specify that second reg and clock-names entry is required
> for this compatible value.
Sure
>
>>              "samsung,exynos5440-tmu"
>>  - interrupt-parent : The phandle for the interrupt controller
>>  - reg : Address range of the thermal registers. For soc's which has multiple
>> @@ -13,6 +14,16 @@
>>       interrupt related then 2 set of register has to supplied. First set
>>       belongs to each instance of TMU and second set belongs to second set
>>       of common TMU registers.
>
> nit: A blank line here would be nice.
>
>> +  NOTE: On Exynos5420, the TRIMINFO register is misplaced for TMU
>> +     channels 2, 3 and 4
>> +
>> +     TRIMINFO at 0x1006c000 contains data for TMU channel 3
>> +     TRIMINFO at 0x100a0000 contains data for TMU channel 4
>> +     TRIMINFO at 0x10068000 contains data for TMU channel 2
>> +
>> +     The misplaced register address is passed through devicetree as the
>> +     second base
>> +
>>  - interrupts : Should contain interrupt for thermal system
>>  - clocks : The main clock for TMU device
>>  - clock-names : Thermal system clock name
>> @@ -43,6 +54,34 @@ Example 2):
>>               clock-names = "tmu_apbif";
>>       };
>>
>> +Example 3): (In case of Exynos5420)
>
> Maybe "in case of misplaced TRIMINFO register" would be better?
Sure
>
>> +     /* tmu for CPU2 */
>> +     tmu@10068000 {
>> +             compatible = "samsung,exynos5420-tmu";
>> +             reg = <0x10068000 0x100>, <0x1006c000 0x4>;
>> +             interrupts = <0 184 0>;
>> +             clocks = <&clock 318>;
>> +             clock-names = "tmu_apbif";
>> +     };
>> +
>
> I believe that just a single example of a node for a TMU with misplaced
> TRIMINFO register will be enough.
right
>
>> +     /* tmu for CPU3 */
>> +     tmu@1006c000 {
>> +             compatible = "samsung,exynos5420-tmu";
>> +             reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
>> +             interrupts = <0 185 0>;
>> +             clocks = <&clock 318>;
>> +             clock-names = "tmu_apbif";
>> +     };
>> +
>> +     /* tmu for GPU */
>> +     tmu@100a0000 {
>> +             compatible = "samsung,exynos5420-tmu";
>> +             reg = <0x100a0000 0x100>, <0x10068000 0x4>;
>> +             interrupts = <0 215 0>;
>> +             clocks = <&clock 318>;
>> +             clock-names = "tmu_apbif";
>> +     };
>> +
>>  Note: For multi-instance tmu each instance should have an alias correctly
>>  numbered in "aliases" node.
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index ae80a87..b54825a 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -186,7 +186,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>                       EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>>               }
>>       } else {
>> -             trim_info = readl(data->base + reg->triminfo_data);
>> +             /* On exynos5420 the triminfo register is in the shared space */
>> +             if (data->base_second && (data->soc == SOC_ARCH_EXYNOS5420))
>
> This is ugly. What about having a quirk based description, that would
> allow to have code like this (just an example, not ready code):
Right now the driverdata is a struct containing the register bases and
various operation
values for TMU, along with the soc specific details.
Will implement quirks, along with proper device tree migration of platform data
>
>         if (data->quirks & EXYNOS_TMU_MISPLACED_TRIMINFO)
>
>> +                     trim_info = readl(data->base_second +
>> +                                                     reg->triminfo_data);
>> +             else
>> +                     trim_info = readl(data->base + reg->triminfo_data);
>>       }
>>       data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
>>       data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
>> @@ -498,6 +503,10 @@ static const struct of_device_id exynos_tmu_match[] = {
> [snip]
>> +#define EXYNOS5420_TMU_DATA \
>> +     __EXYNOS5420_TMU_DATA \
>> +     .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>> +                     TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>> +                     TMU_SUPPORT_EMUL_TIME)
>> +
>> +#define EXYNOS5420_TMU_DATA_SHARED \
>> +     __EXYNOS5420_TMU_DATA \
>> +     .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>> +                     TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>> +                     TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
>> +
>> +struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
>> +     .tmu_data = {
>> +             { EXYNOS5420_TMU_DATA },
>> +             { EXYNOS5420_TMU_DATA },
>> +             { EXYNOS5420_TMU_DATA_SHARED },
>> +             { EXYNOS5420_TMU_DATA_SHARED },
>> +             { EXYNOS5420_TMU_DATA_SHARED },
>> +     },
>> +     .tmu_count = 5,
>> +};
>
> Is this, by any chance, matching by some kind of block index? If yes, this
> is awfully broken, when all of them are separate IP blocks.
I guess not.
>
> What if an SoC shows up with particular TMU channels compatible with
> Exynos 5420, but ordered differently? (e.g. GPU, CPU0, CPU2, CPU1, CPU3)
>
> Instead, such data as contained in exynos_tmu_init_data should be rather
> determined by IP compatible value, just as I suggested earlier in this
> post.
Right, will handling this along with device tree migration of platform data
>
> Best regards,
> Tomasz
>



-- 
Shine bright,
(: Nav :)
