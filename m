Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaKYIdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:33:19 -0500
Received: from mail-yk0-f177.google.com ([209.85.160.177]:49293 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpGjeWx8LkhN9BRLEczGSehXQBAB7A_M1DtCFN9tZOtYg@mail.gmail.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
	<1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
	<1416834256-11225-6-git-send-email-amit.daniel@samsung.com>
	<CAPDyKFpGjeWx8LkhN9BRLEczGSehXQBAB7A_M1DtCFN9tZOtYg@mail.gmail.com>
Date: Tue, 25 Nov 2014 14:03:16 +0530
X-Google-Sender-Auth: qqTIIJcHdvrBo6724OHOz6UTIaE
Message-ID: <CADGdYn43Up6D8EaXUr6ogki3tBMuS3WK7xXqbgjp8t4d8dQfqQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 06/12] driver: soc: exynos-pmu: Add exynos7 power
 domain on/off ops
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 1:00 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 24 November 2014 at 14:04, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
>> This patch uses the restructuring done in PD handlers and adds PD
>> on/off/status handlers for exynos7. In this SoC, some extra settings
>> need to be done prior to turning on/off power domains. Some of those
>> settings are also different from different power domains so is uses
>> the power domain compatible name feature to distinguish between power
>> domains.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/soc/samsung/exynos-pmu.c            |  105 +++++++++++++++++++++++++++
>>  include/linux/soc/samsung/exynos-regs-pmu.h |   17 +++++
>>  2 files changed, 122 insertions(+)
>>
>> diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
>> index e690f65..b9631d5 100644
>> --- a/drivers/soc/samsung/exynos-pmu.c
>> +++ b/drivers/soc/samsung/exynos-pmu.c
>> @@ -1202,6 +1202,104 @@ static void exynos7_pmu_init(void)
>>         }
>>  }
>>
>> +static int exynos7_pd_extraconf_base(const char *pd_name)
>> +{
>> +       if (!pd_name)
>> +               return -EINVAL;
>> +
>> +       if (!strcmp("samsung,exynos7-pd-mfc", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_MFC_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-hevc", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_HEVC_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-mscl", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_MSCL_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-g2d", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_G2D_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-fsys0", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_FSYS0_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-fsys1", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_FSYS1_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-aud", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_AUD_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-disp", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_DISP_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-vpp", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_VPP_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-vpp", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_VPP_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-isp0", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_ISP0_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-isp1", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_ISP1_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-cam0", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_CAM0_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-cam1", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_CAM1_SYS_PWR_REG;
>> +       else if (!strcmp("samsung,exynos7-pd-g3d", pd_name))
>> +               return EXYNOS7_CLKRUN_CMU_CAM1_SYS_PWR_REG;
>
> I think we should move away from using strings to find a matching PM
> domain. Instead we should use a enum/define pointing to the PM domain
> in an array of PM domains, or similar.
Thanks for looking into the series.
Here pd names are compatible string from the pd DT nodes. I think
compatible names are
used in many places like searching for platform data in DT based probe etc.
yes enum can also be used to locate the PM domain. Will check.
>
> The UX500 SOC initial support for PM domains is queued for 3.19 and is
> currently available in linux-next. You may want to get some
> inspiration from that approach.
ok will check them.
>
>> +
>> +       pr_err("%s: Unsupported power domain\n", pd_name);
>> +       return 0;
>> +}
>> +
>> +static int exynos7_pd_powerdown(const char *pd_name, void __iomem *pd_addr)
>> +{
>
> Considering the suggestion above and to move away from using strings
> like this; this function could take a pointer to the PM domain instead
> of a string and the __iomem, right!?
Actually in our case there are 2 files, pm-domain.c and exynos-pmu.c.
I thought of abstracting out generic PD related stuffs from
exynos-pmu.c file so this function
takes these type of arguments.
>
>> +       int off_base = exynos7_pd_extraconf_base(pd_name);
>> +
>> +       if (!off_base)
>> +               return -EINVAL;
>> +
>> +       /* Initialise the pd extraconf registers */
>> +       pmu_raw_writel(0, off_base + EXYNOS7_CLKRUN_CMU_PD_SYS_PWR_REG);
>> +       pmu_raw_writel(0, off_base + EXYNOS7_CLKSTOP_CMU_PD_SYS_PWR_REG);
>> +       pmu_raw_writel(0, off_base + EXYNOS7_DISABLE_PLL_CMU_PD_SYS_PWR_REG);
>> +       pmu_raw_writel(0, off_base + EXYNOS7_RESET_LOGIC_PD_SYS_PWR_REG);
>> +       pmu_raw_writel(0, off_base + EXYNOS7_MEMORY_PD_SYS_PWR_REG);
>> +       pmu_raw_writel(0, off_base + EXYNOS7_RESET_CMU_PD_SYS_PWR_REG);
>> +
>> +       if (!strcmp("samsung,exynos7-pd-fsys0", pd_name) ||
>> +                       !strcmp("samsung,exynos7-pd-fsys1", pd_name))
>> +               pmu_raw_writel(1,
>> +                               off_base + EXYNOS7_RESET_SLEEP_PD_SYS_PWR_REG);
>> +
>> +       if (!strcmp("samsung,exynos7-pd-aud", pd_name)) {
>> +               pmu_raw_writel(0, EXYNOS7_PAD_RETENTION_AUD_SYS_PWR_REG);
>> +               pmu_raw_writel(0, EXYNOS7_GPIO_MODE_AUD_SYS_PWR_REG);
>> +       }
>> +
>> +       writel_relaxed((EXYNOS7_USE_PROLONGED_LOGIC_RESET |
>> +                       EXYNOS7_USE_SC_FEEDBACK), pd_addr + EXYNOS_PD_OPTION);
>> +
>> +       return 0;
>> +}
>> +
>> +static int exynos7_pd_poweron(const char *pd_name, void __iomem *pd_addr)
>> +{
>> +       if (exynos7_pd_powerdown(pd_name, pd_addr))
>> +               return -EINVAL;
>> +
>> +       return __exynos_pd_poweron_off(true, pd_name, pd_addr,
>> +                       EXYNOS7_INT_LOCAL_PWR_EN);
>> +}
>> +
>> +static int exynos7_pd_poweroff(const char *pd_name, void __iomem *pd_addr)
>> +{
>> +       if (exynos7_pd_powerdown(pd_name, pd_addr))
>> +               return -EINVAL;
>> +
>> +       return __exynos_pd_poweron_off(false, pd_name, pd_addr,
>> +                       EXYNOS7_INT_LOCAL_PWR_EN);
>> +}
>> +
>> +static bool exynos7_pd_status(void __iomem *pd_addr)
>> +{
>> +       unsigned int val;
>> +
>> +       val = readl_relaxed(pd_addr + EXYNOS_PD_STATUS) &
>> +                               EXYNOS7_INT_LOCAL_PWR_EN;
>> +       return  val ? true : false;
>> +}
>> +
>>  static struct exynos_pmu_pd_ops exynos_pd_ops = {
>>         .pd_on          = exynos_pd_poweron,
>>         .pd_off         = exynos_pd_poweroff,
>> @@ -1238,12 +1336,19 @@ static struct exynos_pmu_data exynos5420_pmu_data = {
>>         .pd_ops         = &exynos_pd_ops,
>>  };
>>
>> +static struct exynos_pmu_pd_ops exynos7_pd_ops = {
>> +       .pd_on          = exynos7_pd_poweron,
>> +       .pd_off         = exynos7_pd_poweroff,
>> +       .pd_status      = exynos7_pd_status,
>> +};
>> +
>>  static const struct exynos_pmu_data exynos7_pmu_data = {
>>         .pmu_config             = exynos7_pmu_config,
>>         .pmu_init               = exynos7_pmu_init,
>>         .pmu_config_extra       = exynos7_pmu_config_extra,
>>         .powerdown_conf         = exynos7_powerdown_conf,
>>         .powerup_conf           = exynos7_powerup_conf,
>> +       .pd_ops                 = &exynos7_pd_ops,
>>  };
>>
>>  /*
>> diff --git a/include/linux/soc/samsung/exynos-regs-pmu.h b/include/linux/soc/samsung/exynos-regs-pmu.h
>> index c61f91a..520595f 100644
>> --- a/include/linux/soc/samsung/exynos-regs-pmu.h
>> +++ b/include/linux/soc/samsung/exynos-regs-pmu.h
>> @@ -680,6 +680,8 @@ static inline unsigned int exynos_pmu_cpunr(unsigned int mpidr)
>>  #define EXYNOS7_VPP_SYS_PWR_REG                                        (0x1438)
>>  #define EXYNOS7_CLKRUN_CMU_AUD_SYS_PWR_REG                     (0x1440)
>>  #define EXYNOS7_CLKRUN_CMU_BUS0_SYS_PWR_REG                    (0x1444)
>> +#define EXYNOS7_CLKRUN_CMU_CAM0_SYS_PWR_REG                    (0x1448)
>> +#define EXYNOS7_CLKRUN_CMU_CAM1_SYS_PWR_REG                    (0x144C)
>>  #define EXYNOS7_CLKRUN_CMU_DISP_SYS_PWR_REG                    (0x1450)
>>  #define EXYNOS7_CLKRUN_CMU_FSYS0_SYS_PWR_REG                   (0x1454)
>>  #define EXYNOS7_CLKRUN_CMU_FSYS1_SYS_PWR_REG                   (0x1458)
>> @@ -824,6 +826,7 @@ static inline unsigned int exynos_pmu_cpunr(unsigned int mpidr)
>>  #define EXYNOS7_USE_STANDBYWFI                                 (0x1 << 16)
>>  #define EXYNOS7_USE_SC_FEEDBACK                                        (0x1 << 1)
>>  #define EXYNOS7_USE_SC_COUNTER                                 (0x1 << 0)
>> +#define EXYNOS7_USE_PROLONGED_LOGIC_RESET                      (0x1 << 8)
>>
>>  /* EXYNOS7_PAD_RETENTION_AUD_OPTION */
>>  #define PAD_INITIATE_WAKEUP                                    (0x1 << 28)
>> @@ -841,4 +844,18 @@ static inline unsigned int exynos_pmu_cpunr(unsigned int mpidr)
>>
>>  #define EXYNOS7_CORE_ARMCLK_STOPCTRL           (0x1000)
>>
>> +#define EXYNOS7_INT_LOCAL_PWR_EN               0xF
>> +
>> +/*
>> + * Power domain register offsets from the EXYNOS7
>> + * CLKRUN_CMU_HEVC_SYS_PWR_REG configuration register.
>> + */
>> +#define EXYNOS7_CLKRUN_CMU_PD_SYS_PWR_REG      (0x0)
>> +#define EXYNOS7_CLKSTOP_CMU_PD_SYS_PWR_REG     (0x40)
>> +#define EXYNOS7_DISABLE_PLL_CMU_PD_SYS_PWR_REG (0x80)
>> +#define EXYNOS7_RESET_LOGIC_PD_SYS_PWR_REG     (0xC0)
>> +#define EXYNOS7_MEMORY_PD_SYS_PWR_REG          (0x100)
>> +#define EXYNOS7_RESET_CMU_PD_SYS_PWR_REG       (0x140)
>> +#define EXYNOS7_RESET_SLEEP_PD_SYS_PWR_REG     (0x180)
>> +
>>  #endif /* __ASM_ARCH_REGS_PMU_H */
>> --
>> 1.7.9.5
>>
>
> Kind regards
> Uffe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
