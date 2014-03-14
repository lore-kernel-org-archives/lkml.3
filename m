Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaCNP1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:27:45 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44804 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCNP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
Date: Fri, 14 Mar 2014 20:57:42 +0530
Message-ID: <CAK9yfHx_FUaUcA_tpsJ73i0iJmczOp7K8gC6sMGHQ6c50i46=A@mail.gmail.com>
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14 March 2014 10:39, Cho KyongHo <pullip.cho@samsung.com> wrote:
> This commit adds device tree support for System MMU.
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/Kconfig        |    5 ++---
>  drivers/iommu/exynos-iommu.c |   21 +++++++++++++++++----
>  2 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index df56e4c..22af807 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -178,16 +178,15 @@ config TEGRA_IOMMU_SMMU
>
>  config EXYNOS_IOMMU
>         bool "Exynos IOMMU Support"
> -       depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
> +       depends on ARCH_EXYNOS
>         select IOMMU_API
> +       default n

This is not needed as it is the default choice.

>         help
>           Support for the IOMMU(System MMU) of Samsung Exynos application
>           processor family. This enables H/W multimedia accellerators to see
>           non-linear physical memory chunks as a linear memory in their
>           address spaces
>
> -         If unsure, say N here.
> -
>  config EXYNOS_IOMMU_DEBUG
>         bool "Debugging log for Exynos IOMMU"
>         depends on EXYNOS_IOMMU
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 33b424d..34feb04 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -26,6 +26,7 @@
>  #include <linux/list.h>
>  #include <linux/memblock.h>
>  #include <linux/export.h>
> +#include <linux/of.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
> @@ -497,7 +498,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>         read_unlock_irqrestore(&data->lock, flags);
>  }
>
> -static int exynos_sysmmu_probe(struct platform_device *pdev)
> +static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>  {
>         int irq, ret;
>         struct device *dev = &pdev->dev;
> @@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
>         return 0;
>  }
>
> -static struct platform_driver exynos_sysmmu_driver = {
> -       .probe          = exynos_sysmmu_probe,
> -       .driver         = {
> +#ifdef CONFIG_OF

This is not needed as Exynos is DT only platform.

> +static struct of_device_id sysmmu_of_match[] __initconst = {
> +       { .compatible   = "samsung,sysmmu-v1", },
> +       { .compatible   = "samsung,sysmmu-v2", },
> +       { .compatible   = "samsung,sysmmu-v3.1", },
> +       { .compatible   = "samsung,sysmmu-v3.2", },
> +       { .compatible   = "samsung,sysmmu-v3.3", },
> +       { },
> +};
> +#endif
> +
> +static struct platform_driver exynos_sysmmu_driver __refdata = {
> +       .probe  = exynos_sysmmu_probe,
> +       .driver = {
>                 .owner          = THIS_MODULE,
>                 .name           = "exynos-sysmmu",
> +               .of_match_table = of_match_ptr(sysmmu_of_match),

of_match_ptr is not needed for the same reason as above.


-- 
With warm regards,
Sachin
