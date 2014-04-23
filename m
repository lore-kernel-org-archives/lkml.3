Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaDWNDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:03:10 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38073 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDWNDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
	<1396425058-4012-7-git-send-email-pankaj.dubey@samsung.com>
Date: Wed, 23 Apr 2014 18:32:56 +0530
Message-ID: <CAGm_ybgEfqYfKJch58_svA5GAbkFXfXb1FyOiMSrX12PzBHxyA@mail.gmail.com>
Subject: Re: [PATCH 06/10] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        chow.kim@samsung.com, Young-Gun Jang <yg1004.jang@samsung.com>,
        sunil joshi <joshi@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 2, 2014 at 1:20 PM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> From: Young-Gun Jang <yg1004.jang@samsung.com>
>
> Add support for mapping Exynos Power Management Unit (PMU) base address
> from device tree. Code will use existing samsung pmu binding information.
> This patch also adds "get_exynos_pmubase" a helper function to return mapped base
> address to various other files under "mach-exynos".
>
> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h |    2 ++
>  arch/arm/mach-exynos/exynos.c |   44 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index ff28334..9a55cf6 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -61,4 +61,6 @@ struct exynos_pmu_conf {
>
>  extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
>
> +extern void __iomem *get_exynos_pmubase(void);
> +
>  #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index a5e1349..a5127fb 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -35,6 +35,8 @@
>  #define L2_AUX_VAL 0x7C470001
>  #define L2_AUX_MASK 0xC200ffff
>
> +static void __iomem *exynos_pmu_base __initdata;

Are you sure you want to keep exynos_pmu_base in .init section.
I am seeing a crash in platform_do_lowpower()
I think you should remove __initdata.

> +
>  static struct map_desc exynos4_iodesc[] __initdata = {
>         {
>                 .virtual        = (unsigned long)S3C_VA_SYS,
> @@ -245,6 +247,47 @@ void __init exynos_init_late(void)
>         exynos_pm_init();
>  }
>
> +static char const *exynos_dt_pmu_match[] __initconst = {
> +       "samsung,exynos4210-pmu",
> +       "samsung,exynos4212-pmu",
> +       "samsung,exynos4412-pmu",
> +       "samsung,exynos5250-pmu",
> +       NULL
> +};
> +
> +static int __init exynos_fdt_map_pmu(unsigned long node,
> +               const char *uname, int depth, void *data)
> +{
> +       struct map_desc iodesc;
> +       __be32 *reg;
> +       unsigned long len;
> +
> +       if (of_flat_dt_match(node, exynos_dt_pmu_match)) {
> +               phys_addr_t phys_addr;
> +               reg = of_get_flat_dt_prop(node, "reg", &len);
> +               if (reg == NULL || len != (sizeof(unsigned long) * 2))
> +                       return 0;
> +
> +               phys_addr = be32_to_cpu(reg[0]);
> +               iodesc.pfn = __phys_to_pfn(phys_addr);
> +               iodesc.length = be32_to_cpu(reg[1]) - 1;
> +               iodesc.virtual = (unsigned long)S5P_VA_PMU;
> +               iodesc.type = MT_DEVICE;
> +               iotable_init(&iodesc, 1);
> +
> +               exynos_pmu_base = ioremap(phys_addr, be32_to_cpu(reg[1]));
> +               if (WARN_ON(!exynos_pmu_base))
> +                       return -EFAULT;
> +       }
> +
> +       return 0;
> +}
> +
> +inline void __iomem *get_exynos_pmubase()
> +{
> +       return exynos_pmu_base;
> +}
> +
>  static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
>                                         int depth, void *data)
>  {
> @@ -301,6 +344,7 @@ void __init exynos_init_io(void)
>         debug_ll_io_init();
>
>         of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
> +       of_scan_flat_dt(exynos_fdt_map_pmu, NULL);
>
>         /* detect cpu id and rev. */
>         s5p_init_cpu(S5P_VA_CHIPID);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
