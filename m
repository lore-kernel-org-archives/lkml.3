Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaDZDc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 23:32:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53981 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDZDcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 23:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <535ADF59.1020101@gmail.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-9-git-send-email-pankaj.dubey@samsung.com> <535ADF59.1020101@gmail.com>
From: Pankaj Dubey <pankaj.dubey@samsung.com>
Date: Sat, 26 Apr 2014 12:32:33 +0900
X-Google-Sender-Auth: SPptIjLTSQmaQhIqeayffo3HIzE
Message-ID: <CAGcde9EZ-7wKE+ozyUPj-c2krpaAi081jHivhqW1saq03jT3=g@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] ARM: EXYNOS: Refactored code for using PMU
 address via DT
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Tomasz Figa <t.figa@samsung.com>,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Thanks for review.

On Sat, Apr 26, 2014 at 7:19 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi,
>
>
> On 25.04.2014 14:32, Pankaj Dubey wrote:
>>
>> Under "arm/mach-exynos" many files are using PMU register offsets.
>> Since we have added support for accessing PMU base address via DT,
>> now we can remove PMU mapping from exynosX_iodesc.
>> Let's convert all these access using either of "get_exynos_pmuaddr"
>> or "get_exynos_regmap".
>> This will help us in removing static mapping of PMU base address
>> as well as help in reducing dependency over machine header files.
>> Thus helping for migration of PMU implementation from machine to driver
>> folder which can be reused for ARM64 bsed SoC.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/common.h           |    4 +-
>>   arch/arm/mach-exynos/cpuidle.c          |   37 ++-
>>   arch/arm/mach-exynos/exynos.c           |   19 +-
>>   arch/arm/mach-exynos/hotplug.c          |    4 +-
>>   arch/arm/mach-exynos/include/mach/map.h |    3 -
>>   arch/arm/mach-exynos/platsmp.c          |   13 +-
>>   arch/arm/mach-exynos/pm.c               |   60 ++--
>>   arch/arm/mach-exynos/pmu.c              |   40 +--
>>   arch/arm/mach-exynos/regs-pmu.h         |  506
>> +++++++++++++++----------------
>>   9 files changed, 348 insertions(+), 338 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
>> index ecfd0fc..ad5128e 100644
>> --- a/arch/arm/mach-exynos/common.h
>> +++ b/arch/arm/mach-exynos/common.h
>> @@ -40,7 +40,7 @@ extern void exynos_cpu_die(unsigned int cpu);
>>
>>   /* PMU(Power Management Unit) support */
>>
>> -#define PMU_TABLE_END  NULL
>> +#define PMU_TABLE_END  0xFFFF
>
>
> IMHO (-1U) would be more appropriate.
>

OK.

>
>>
>>   enum sys_powerdown {
>>         SYS_AFTR,
>> @@ -51,7 +51,7 @@ enum sys_powerdown {
>>
>>   extern unsigned long l2x0_regs_phys;
>>   struct exynos_pmu_conf {
>> -       void __iomem *reg;
>> +       unsigned int offset;
>>         unsigned int val[NUM_SYS_POWERDOWN];
>>   };
>>
>> diff --git a/arch/arm/mach-exynos/cpuidle.c
>> b/arch/arm/mach-exynos/cpuidle.c
>> index c57cae0..5dcdd46 100644
>> --- a/arch/arm/mach-exynos/cpuidle.c
>> +++ b/arch/arm/mach-exynos/cpuidle.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/module.h>
>>   #include <linux/time.h>
>>   #include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>>
>>   #include <asm/proc-fns.h>
>>   #include <asm/smp_scu.h>
>> @@ -34,10 +35,10 @@
>>
>>   #define REG_DIRECTGO_ADDR     (samsung_rev() == EXYNOS4210_REV_1_1 ? \
>>                         S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0
>> ? \
>> -                       (S5P_VA_SYSRAM + 0x24) : S5P_INFORM0))
>> +                       0x24 : S5P_INFORM0))
>>   #define REG_DIRECTGO_FLAG     (samsung_rev() == EXYNOS4210_REV_1_1 ? \
>>                         S5P_INFORM6 : (samsung_rev() == EXYNOS4210_REV_1_0
>> ? \
>> -                       (S5P_VA_SYSRAM + 0x20) : S5P_INFORM1))
>> +                       0x20 : S5P_INFORM1))
>
>
> This patch seems to be based on old code, before Daniel Lezcano's Exynos
> cpuidle refactor [1] and it should be rebased on top of that series.
>
> [1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085
>
>

OK, I will rebase on top of it along with addressing all other review comments.

>>
>>   #define S5P_CHECK_AFTR                0xFCBA0D10
>>
>> @@ -60,6 +61,8 @@
>>   #define PWR_CTRL2_CORE2_UP_RATIO              (1 << 4)
>>   #define PWR_CTRL2_CORE1_UP_RATIO              (1 << 0)
>>
>> +static struct regmap *pmu_regmap;
>> +
>>   static int exynos4_enter_lowpower(struct cpuidle_device *dev,
>>                                 struct cpuidle_driver *drv,
>>                                 int index);
>> @@ -87,7 +90,7 @@ static struct cpuidle_driver exynos4_idle_driver = {
>>   /* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
>>   static void exynos4_set_wakeupmask(void)
>>   {
>> -       __raw_writel(0x0000ff3e, S5P_WAKEUP_MASK);
>> +       regmap_write(pmu_regmap, S5P_WAKEUP_MASK, 0x0000ff3e);
>>   }
>>
>>   static unsigned int g_pwr_ctrl, g_diag_reg;
>> @@ -120,22 +123,28 @@ static int exynos4_enter_core0_aftr(struct
>> cpuidle_device *dev,
>>                                 struct cpuidle_driver *drv,
>>                                 int index)
>>   {
>> -       unsigned long tmp;
>> +       unsigned int tmp;
>>
>>         exynos4_set_wakeupmask();
>>
>>         /* Set value of power down register for aftr mode */
>>         exynos_sys_powerdown_conf(SYS_AFTR);
>> -
>> -       __raw_writel(virt_to_phys(exynos_cpu_resume), REG_DIRECTGO_ADDR);
>> -       __raw_writel(S5P_CHECK_AFTR, REG_DIRECTGO_FLAG);
>> -
>> +
>> +       if (samsung_rev() == EXYNOS4210_REV_1_0) {
>> +               __raw_writel(virt_to_phys(exynos_cpu_resume),
>> +                               S5P_VA_SYSRAM + REG_DIRECTGO_ADDR);
>> +               __raw_writel(S5P_CHECK_AFTR, S5P_VA_SYSRAM +
>> REG_DIRECTGO_FLAG);
>> +       } else {
>> +               regmap_write(pmu_regmap, REG_DIRECTGO_ADDR,
>> +                               virt_to_phys(exynos_cpu_resume));
>> +               regmap_write(pmu_regmap, REG_DIRECTGO_FLAG,
>> S5P_CHECK_AFTR);
>> +       }
>
>
> This is quite ugly. I'd refactor this into a function pointer set once at
> initialization time depending on SoC type and create two functions for both
> cases.
>

True. I also felt it's getting ugly, but could not think of better
way. Thanks for suggestion let me check how better I can make this.

> In general, please also see my comments about this kind of code checking SoC
> type posted as a part of my review of Vikas' Exynos5260 PMU support series
> [2].
>
> [2] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/28056/focus=29342

Sure.

>
>
>>         save_cpu_arch_register();
>>
>>         /* Setting Central Sequence Register for power down mode */
>> -       tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
>> +       regmap_read(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, &tmp);
>>         tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
>> -       __raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
>> +       regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, tmp);
>>
>>         cpu_pm_enter();
>>         cpu_suspend(0, idle_finisher);
>> @@ -154,14 +163,14 @@ static int exynos4_enter_core0_aftr(struct
>> cpuidle_device *dev,
>>          * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
>>          * in this situation.
>>          */
>> -       tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
>> +       regmap_read(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, &tmp);
>>         if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
>>                 tmp |= S5P_CENTRAL_LOWPWR_CFG;
>> -               __raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
>> +               regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION,
>> tmp);
>>         }
>>
>>         /* Clear wakeup state register */
>> -       __raw_writel(0x0, S5P_WAKEUP_STAT);
>> +       regmap_write(pmu_regmap, S5P_WAKEUP_STAT, 0x0);
>>
>>         return index;
>>   }
>> @@ -219,6 +228,8 @@ static int exynos_cpuidle_probe(struct platform_device
>> *pdev)
>>         int cpu_id, ret;
>>         struct cpuidle_device *device;
>>
>> +       pmu_regmap = get_exynos_pmuregmap();
>
>
> Why couldn't you simply look for PMU node here and then call
> syscon_regmap_lookup_by_phandle()? (You will have to anyway, as Daniel's
> patches mentioned above move the driver to drivers/cpuidle and it is not
> possible to include headers and it is not allowed to include mach/ headers
> from drivers/.)
>

Once I rebase on top of Daniel's patches this change won't require any more.

>
>> +
>>         if (soc_is_exynos5250())
>>                 exynos5_core_down_clk();
>>
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index 68f60e1..b01987e 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_domain.h>
>>   #include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/hardware/cache-l2x0.h>
>> @@ -67,11 +68,6 @@ static struct map_desc exynos4_iodesc[] __initdata = {
>>                 .length         = SZ_4K,
>>                 .type           = MT_DEVICE,
>>         }, {
>> -               .virtual        = (unsigned long)S5P_VA_PMU,
>> -               .pfn            = __phys_to_pfn(EXYNOS4_PA_PMU),
>> -               .length         = SZ_64K,
>> -               .type           = MT_DEVICE,
>> -       }, {
>>                 .virtual        = (unsigned long)S5P_VA_COMBINER_BASE,
>>                 .pfn            = __phys_to_pfn(EXYNOS4_PA_COMBINER),
>>                 .length         = SZ_4K,
>> @@ -195,11 +191,6 @@ static struct map_desc exynos5_iodesc[] __initdata =
>> {
>>                 .pfn            = __phys_to_pfn(EXYNOS5_PA_CMU),
>>                 .length         = 144 * SZ_1K,
>>                 .type           = MT_DEVICE,
>> -       }, {
>> -               .virtual        = (unsigned long)S5P_VA_PMU,
>> -               .pfn            = __phys_to_pfn(EXYNOS5_PA_PMU),
>> -               .length         = SZ_64K,
>> -               .type           = MT_DEVICE,
>>         },
>>   };
>>
>> @@ -207,7 +198,7 @@ static void exynos_restart(enum reboot_mode mode,
>> const char *cmd)
>>   {
>>         struct device_node *np;
>>         u32 val = 0x1;
>> -       void __iomem *addr = EXYNOS_SWRESET;
>> +       void __iomem *addr = NULL;
>>
>>         if (of_machine_is_compatible("samsung,exynos5440")) {
>>                 u32 status;
>> @@ -220,9 +211,9 @@ static void exynos_restart(enum reboot_mode mode,
>> const char *cmd)
>>                 val = __raw_readl(addr);
>>
>>                 val = (val & 0xffff0000) | (status & 0xffff);
>> -       }
>> -
>> -       __raw_writel(val, addr);
>> +               __raw_writel(val, addr);
>> +       } else
>> +               regmap_write(exynos_pmu_regmap, EXYNOS_SWRESET, val);
>>   }
>>
>>   static struct platform_device exynos_cpuidle = {
>> diff --git a/arch/arm/mach-exynos/hotplug.c
>> b/arch/arm/mach-exynos/hotplug.c
>> index 73b0b5c..7831e64 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/errno.h>
>>   #include <linux/smp.h>
>>   #include <linux/io.h>
>> +#include <linux/regmap.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/cp15.h>
>> @@ -91,11 +92,12 @@ static inline void cpu_leave_lowpower(void)
>>
>>   static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>>   {
>> +       struct regmap *pmu_base = get_exynos_pmuregmap();
>
>
> pmu_base is rather unfortunate name for a variable holding a pointer to a
> regmap, still...

OK, I will rename as "pmu_regmap".

>
>
>>         for (;;) {
>>
>>                 /* make cpu1 to be turned off at next WFI command */
>>                 if (cpu == 1)
>> -                       __raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
>> +                       regmap_write(pmu_base,
>> S5P_ARM_CORE1_CONFIGURATION, 0);
>
>
> ...inside mach-exynos you could probably define exynos_pmu_write() that
> would call regmap_write() with exynos_pmu_regmap (after making it
> non-static) directly. This way the old code wouldn't have to care about the
> regmap at all, just __raw_writel() would be replaced with
> exynos_pmu_write().
>

OK, sounds good to me.

> OR
>
> In case of registers that are known to not need sharing between multiple
> drivers, the mapped area could be used directly. This would probably let you
> eliminate any regmap-specific code from mach-exynos.
>

In v1 patch [1], I just used ioremapped virtual address, but as
Sylwester suggested here [2], for using syscon mapped regmap handles
instead, to avoid ioremapping same PMU address once in "syscon" and
then in "exynos.c", and again in "pmu.c". I tried to adopt "early
syscon initialization" method [3] in this patch V2. But I observed one
issue in "early syscon initialization" that we can't use it before DT
is unflattened.
So I have three options now as:

1: Use only ioremapped address and drop regmap specific code as you
are suggesting, even though we will end up mapping same address range
in multiple files. Same was done in patch v1 [1].

2: Use only PMU regmap handles by using "early syscon initialization"
method [2], as suggested by Sylwester [3]. But as I mentioned due to
limitation of "early syscon" we can't call "early_syscon_init" before
device tree unflattens. So after exploring I have found one way to do
it, even though I am not sure will be be acceptable. Since we can't
delay "early_syscon_init" after machine_desc->init_time. As just after
that secondary core bootup starts and we need to access PMU registers
during that time in platsmp.c. I need to provide exynos_init_time in
machine_desc and call "early_syscon_init" along with "of_clk_init" and
"clock_source_init". I have verfied this and everything works fine
without any side-effect. Only concern is will it be acceptable to call
"early_syscon_init" from "exynos_time_init".

3: Use both ioremapped address (only used in platsmp.c) and PMU regmap
handle (used in all other exynos machine files), same has been
implemented in this patch V2. But as you suggested above I can reduce
changes by introducing "exynos_pmu_read/write".

Please let me know your opinion about this.

[1] : https://lkml.org/lkml/2014/4/2/50
[2] : https://lkml.org/lkml/2014/4/8/239
[3] : https://lkml.org/lkml/2014/4/2/171

>
>>
>>                 /*
>>                  * here's the WFI
>> diff --git a/arch/arm/mach-exynos/include/mach/map.h
>> b/arch/arm/mach-exynos/include/mach/map.h
>> index 7b046b5..1ba7fb5 100644
>> --- a/arch/arm/mach-exynos/include/mach/map.h
>> +++ b/arch/arm/mach-exynos/include/mach/map.h
>> @@ -35,9 +35,6 @@
>>   #define EXYNOS4_PA_SYSCON             0x10010000
>>   #define EXYNOS5_PA_SYSCON             0x10050100
>>
>> -#define EXYNOS4_PA_PMU                 0x10020000
>> -#define EXYNOS5_PA_PMU                 0x10040000
>> -
>>   #define EXYNOS4_PA_CMU                        0x10030000
>>   #define EXYNOS5_PA_CMU                        0x10010000
>>
>> diff --git a/arch/arm/mach-exynos/platsmp.c
>> b/arch/arm/mach-exynos/platsmp.c
>> index 29c2286..9ce4c9f9 100644
>> --- a/arch/arm/mach-exynos/platsmp.c
>> +++ b/arch/arm/mach-exynos/platsmp.c
>> @@ -31,11 +31,12 @@
>>   #include "regs-pmu.h"
>>
>>   extern void exynos4_secondary_startup(void);
>> +static void __iomem *pmu_base;
>>
>>   static inline void __iomem *cpu_boot_reg_base(void)
>>   {
>>         if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
>> -               return S5P_INFORM5;
>> +               return pmu_base + S5P_INFORM5;
>>         return S5P_VA_SYSRAM;
>>   }
>>
>> @@ -106,14 +107,14 @@ static int exynos_boot_secondary(unsigned int cpu,
>> struct task_struct *idle)
>>          */
>>         write_pen_release(phys_cpu);
>>
>> -       if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN))
>> {
>> +       if (!(__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
>> +                               & S5P_CORE_LOCAL_PWR_EN)) {
>>                 __raw_writel(S5P_CORE_LOCAL_PWR_EN,
>> -                            S5P_ARM_CORE1_CONFIGURATION);
>> -
>> +                       pmu_base + S5P_ARM_CORE1_CONFIGURATION);
>>                 timeout = 10;
>>
>>                 /* wait max 10 ms until cpu1 is on */
>> -               while ((__raw_readl(S5P_ARM_CORE1_STATUS)
>> +               while ((__raw_readl(pmu_base + S5P_ARM_CORE1_STATUS)
>>                         & S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN)
>> {
>>                         if (timeout-- == 0)
>>                                 break;
>> @@ -201,6 +202,8 @@ static void __init exynos_smp_prepare_cpus(unsigned
>> int max_cpus)
>>   {
>>         int i;
>>
>> +       pmu_base = get_exynos_pmuaddr();
>> +
>>         if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
>>                 scu_enable(scu_base_addr());
>>
>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>> index 723c988..e4c10d4 100644
>> --- a/arch/arm/mach-exynos/pm.c
>> +++ b/arch/arm/mach-exynos/pm.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/irqchip/arm-gic.h>
>>   #include <linux/err.h>
>>   #include <linux/clk.h>
>> +#include <linux/regmap.h>
>>
>>   #include <asm/cacheflush.h>
>>   #include <asm/hardware/cache-l2x0.h>
>> @@ -37,6 +38,8 @@
>>   #include "regs-pmu.h"
>>   #include "regs-sys.h"
>>
>> +static struct regmap *pmu_regmap;
>> +
>>   /**
>>    * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
>>    * @hwirq: Hardware IRQ signal of the GIC
>> @@ -125,43 +128,44 @@ static void exynos_pm_prepare(void)
>>         unsigned int tmp;
>>
>>         /* Set wake-up mask registers */
>> -       __raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
>> -       __raw_writel(exynos_irqwake_intmask & ~(1 << 31),
>> S5P_WAKEUP_MASK);
>> +       regmap_write(pmu_regmap, S5P_EINT_WAKEUP_MASK,
>> +                       exynos_get_eint_wake_mask());
>> +       regmap_write(pmu_regmap, S5P_WAKEUP_MASK,
>> +                       exynos_irqwake_intmask & ~(1 << 31));
>>
>>         s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
>>
>>         if (soc_is_exynos5250()) {
>>                 s3c_pm_do_save(exynos5_sys_save,
>> ARRAY_SIZE(exynos5_sys_save));
>>                 /* Disable USE_RETENTION of JPEG_MEM_OPTION */
>> -               tmp = __raw_readl(EXYNOS5_JPEG_MEM_OPTION);
>> +               regmap_read(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, &tmp);
>>                 tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
>> -               __raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
>> +               regmap_write(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, tmp);
>>         }
>>
>>         /* Set value of power down register for sleep mode */
>>
>>         exynos_sys_powerdown_conf(SYS_SLEEP);
>> -       __raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
>> +       regmap_write(pmu_regmap, S5P_INFORM1, S5P_CHECK_SLEEP);
>>
>>         /* ensure at least INFORM0 has the resume address */
>>
>> -       __raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
>> +       regmap_write(pmu_regmap, S5P_INFORM0,
>> virt_to_phys(exynos_cpu_resume));
>>   }
>>
>>   static int exynos_pm_suspend(void)
>>   {
>> -       unsigned long tmp;
>> +       unsigned int tmp;
>>
>>         /* Setting Central Sequence Register for power down mode */
>>
>> -       tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
>> +       regmap_read(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, &tmp);
>>         tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
>> -       __raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
>> -
>> +       regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, tmp);
>>         /* Setting SEQ_OPTION register */
>>
>>         tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
>> -       __raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
>> +       regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_OPTION, tmp);
>>
>>         if (!soc_is_exynos5250()) {
>>                 /* Save Power control register */
>> @@ -180,7 +184,7 @@ static int exynos_pm_suspend(void)
>>
>>   static void exynos_pm_resume(void)
>>   {
>> -       unsigned long tmp;
>> +       unsigned int tmp;
>>
>>         /*
>>          * If PMU failed while entering sleep mode, WFI will be
>> @@ -188,12 +192,12 @@ static void exynos_pm_resume(void)
>>          * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
>>          * in this situation.
>>          */
>> -       tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
>> +       regmap_read(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION, &tmp);
>>         if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
>>                 tmp |= S5P_CENTRAL_LOWPWR_CFG;
>> -               __raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
>> +               regmap_write(pmu_regmap, S5P_CENTRAL_SEQ_CONFIGURATION,
>> tmp);
>>                 /* clear the wakeup state register */
>> -               __raw_writel(0x0, S5P_WAKEUP_STAT);
>> +               regmap_write(pmu_regmap, S5P_WAKEUP_STAT, 0x0);
>>                 /* No need to perform below restore code */
>>                 goto early_wakeup;
>>         }
>> @@ -213,13 +217,13 @@ static void exynos_pm_resume(void)
>>
>>         /* For release retention */
>>
>> -       __raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
>> -       __raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
>> -       __raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
>> -       __raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
>> -       __raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
>> -       __raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
>> -       __raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_MAUDIO_OPTION, (1 << 28));
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_GPIO_OPTION, (1 << 28));
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_UART_OPTION, (1 << 28));
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_MMCA_OPTION, (1 << 28));
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_MMCB_OPTION, (1 << 28));
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_EBIA_OPTION, (1 << 28));
>> +       regmap_write(pmu_regmap, S5P_PAD_RET_EBIB_OPTION, (1 << 28));
>>
>>         if (soc_is_exynos5250())
>>                 s3c_pm_do_restore(exynos5_sys_save,
>> @@ -233,7 +237,7 @@ static void exynos_pm_resume(void)
>>   early_wakeup:
>>
>>         /* Clear SLEEP mode set in INFORM1 */
>> -       __raw_writel(0x0, S5P_INFORM1);
>> +       regmap_write(pmu_regmap, S5P_INFORM1, 0x0);
>>
>>         return;
>>   }
>> @@ -276,8 +280,8 @@ static int exynos_suspend_enter(suspend_state_t state)
>>
>>         s3c_pm_restore_uarts();
>>
>> -       S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
>> -                       __raw_readl(S5P_WAKEUP_STAT));
>> +       regmap_read(pmu_regmap, S5P_WAKEUP_STAT, &ret);
>> +       S3C_PMDBG("%s: wakeup stat: %08x\n", __func__, ret);
>>
>>         s3c_pm_check_restore();
>>
>> @@ -308,14 +312,14 @@ static const struct platform_suspend_ops
>> exynos_suspend_ops = {
>>   void __init exynos_pm_init(void)
>>   {
>>         u32 tmp;
>> -
>> +       pmu_regmap = get_exynos_pmuregmap();
>>         /* Platform-specific GIC callback */
>>         gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
>>
>>         /* All wakeup disable */
>> -       tmp = __raw_readl(S5P_WAKEUP_MASK);
>> +       regmap_read(pmu_regmap, S5P_WAKEUP_MASK, &tmp);
>>         tmp |= ((0xFF << 8) | (0x1F << 1));
>> -       __raw_writel(tmp, S5P_WAKEUP_MASK);
>> +       regmap_write(pmu_regmap, S5P_WAKEUP_MASK, tmp);
>>
>>         register_syscore_ops(&exynos_pm_syscore_ops);
>>         suspend_set_ops(&exynos_suspend_ops);
>
>
> As I said above, I don't think there is any need to use the regmap in such
> low level code for registers that will not be shared.
>
>
>> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
>> index 4c3453a..67116a5 100644
>> --- a/arch/arm/mach-exynos/pmu.c
>> +++ b/arch/arm/mach-exynos/pmu.c
>> @@ -11,6 +11,7 @@
>>
>>   #include <linux/io.h>
>>   #include <linux/kernel.h>
>> +#include <linux/regmap.h>
>>
>>   #include <plat/cpu.h>
>>
>> @@ -18,6 +19,7 @@
>>   #include "regs-pmu.h"
>>
>>   static const struct exynos_pmu_conf *exynos_pmu_config;
>> +static struct regmap *pmu_regmap;
>>
>>   static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
>>         /* { .reg = address, .val = { AFTR, LPA, SLEEP } */
>> @@ -317,7 +319,7 @@ static const struct exynos_pmu_conf
>> exynos5250_pmu_config[] = {
>>         { PMU_TABLE_END,},
>>   };
>>
>> -static void __iomem * const exynos5_list_both_cnt_feed[] = {
>> +static unsigned int const exynos5_list_both_cnt_feed[] = {
>>         EXYNOS5_ARM_CORE0_OPTION,
>>         EXYNOS5_ARM_CORE1_OPTION,
>>         EXYNOS5_ARM_COMMON_OPTION,
>> @@ -331,7 +333,7 @@ static void __iomem * const
>> exynos5_list_both_cnt_feed[] = {
>>         EXYNOS5_TOP_PWR_SYSMEM_OPTION,
>>   };
>>
>> -static void __iomem * const exynos5_list_diable_wfi_wfe[] = {
>> +static unsigned int const exynos5_list_diable_wfi_wfe[] = {
>>         EXYNOS5_ARM_CORE1_OPTION,
>>         EXYNOS5_FSYS_ARM_OPTION,
>>         EXYNOS5_ISP_ARM_OPTION,
>> @@ -346,27 +348,28 @@ static void exynos5_init_pmu(void)
>>          * Enable both SC_FEEDBACK and SC_COUNTER
>>          */
>>         for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
>> -               tmp = __raw_readl(exynos5_list_both_cnt_feed[i]);
>> +               regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i],
>> &tmp);
>>                 tmp |= (EXYNOS5_USE_SC_FEEDBACK |
>>                         EXYNOS5_USE_SC_COUNTER);
>> -               __raw_writel(tmp, exynos5_list_both_cnt_feed[i]);
>> +               regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i],
>> tmp);
>>         }
>>
>>         /*
>>          * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
>>          */
>> -       tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
>> +       regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
>>         tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
>> -       __raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
>> +       regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
>>
>>         /*
>>          * Disable WFI/WFE on XXX_OPTION
>>          */
>>         for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
>> -               tmp = __raw_readl(exynos5_list_diable_wfi_wfe[i]);
>> +               tmp = regmap_read(pmu_regmap,
>> exynos5_list_diable_wfi_wfe[i],
>> +                               &tmp);
>>                 tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
>>                          EXYNOS5_OPTION_USE_STANDBYWFI);
>> -               __raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
>> +               regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
>> tmp);
>>         }
>>   }
>>
>> @@ -377,14 +380,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown
>> mode)
>>         if (soc_is_exynos5250())
>>                 exynos5_init_pmu();
>>
>> -       for (i = 0; (exynos_pmu_config[i].reg != PMU_TABLE_END) ; i++)
>> -               __raw_writel(exynos_pmu_config[i].val[mode],
>> -                               exynos_pmu_config[i].reg);
>> +       for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
>> +               regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
>> +                               exynos_pmu_config[i].val[mode]);
>>
>>         if (soc_is_exynos4412()) {
>> -               for (i = 0; exynos4412_pmu_config[i].reg != PMU_TABLE_END
>> ; i++)
>> -                       __raw_writel(exynos4412_pmu_config[i].val[mode],
>> -                               exynos4412_pmu_config[i].reg);
>> +               for (i = 0; exynos4412_pmu_config[i].offset !=
>> PMU_TABLE_END; i++)
>> +                       regmap_write(pmu_regmap,
>> exynos4412_pmu_config[i].offset,
>> +
>> exynos4412_pmu_config[i].val[mode]);
>>         }
>>   }
>>
>> @@ -393,6 +396,7 @@ static int __init exynos_pmu_init(void)
>>         unsigned int value;
>>
>>         exynos_pmu_config = exynos4210_pmu_config;
>> +       pmu_regmap = get_exynos_pmuregmap();
>>
>>         if (soc_is_exynos4210()) {
>>                 exynos_pmu_config = exynos4210_pmu_config;
>> @@ -405,13 +409,13 @@ static int __init exynos_pmu_init(void)
>>                  * When SYS_WDTRESET is set, watchdog timer reset request
>>                  * is ignored by power management unit.
>>                  */
>> -               value = __raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
>> +               regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
>> &value);
>>                 value &= ~EXYNOS5_SYS_WDTRESET;
>> -               __raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
>> +               regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE,
>> value);
>>
>> -               value = __raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
>> +               regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
>> &value);
>>                 value &= ~EXYNOS5_SYS_WDTRESET;
>> -               __raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
>> +               regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST,
>> value);
>>
>>                 exynos_pmu_config = exynos5250_pmu_config;
>>                 pr_info("EXYNOS5250 PMU Initialize\n");
>
>
> Same here.
>
>
>> diff --git a/arch/arm/mach-exynos/regs-pmu.h
>> b/arch/arm/mach-exynos/regs-pmu.h
>> index bfebe84..7f3bf65 100644
>> --- a/arch/arm/mach-exynos/regs-pmu.h
>> +++ b/arch/arm/mach-exynos/regs-pmu.h
>> @@ -14,290 +14,288 @@
>>
>>   #include <mach/map.h>
>>
>
> Is inclusion of this header still needed after getting rid of S5P_VA_PMU
> below?
>

This change has been done in separate patch [1]. As platsmp.c requires
this and was using it indirectly from regs-pmu.h.

[1] : https://lkml.org/lkml/2014/4/25/233

Thanks,
Pankaj Dubey

>
>> -#define S5P_PMUREG(x)                          (S5P_VA_PMU + (x))
>> -
>
>
> Best regards,
> Tomasz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
