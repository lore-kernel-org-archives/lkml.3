Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab3GZRgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:36:03 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38750 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3GZRgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <003e01ce89f3$4cdb45e0$e691d1a0$@samsung.com>
References: <003e01ce89f3$4cdb45e0$e691d1a0$@samsung.com>
Date: Fri, 26 Jul 2013 10:35:59 -0700
X-Google-Sender-Auth: wMG2u-MUdD87QxOCjTTZHYiaMZE
Message-ID: <CANEJEGtWTZHZEr=XzPXHFbJtP7U5JFD-o58kRjLe23XaTzv=fA@mail.gmail.com>
Subject: Re: [PATCH v8 08/12] iommu/exynos: remove prefetch buffer setting
 when enabling System MMU
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 4:28 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> Prefetch buffer must be handled accurately, exact range of a buffer,
> frame by frame manually. Otherwise, it may causes page fault or
> deadlock in System MMU.
> Thus this patch removes prefetch buffer setting when System MMU is
> initialized(enabled).
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>

Reviewed-by: Grant Grundler <grundler@chromium.org>

BTW, cscope doesn't find any callers of exynos_sysmmu_enable().
Want to submit another patch to remove it?

(Note I'm talking about exynos_sysmmu_enable() without "__" prefix).

cheers,
grant

> ---
>  drivers/iommu/exynos-iommu.c |   32 +++++++++++++++++++++++++++-----
>  1 files changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index cfc02ed..87f6bb7 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -80,6 +80,8 @@
>  #define CTRL_BLOCK     0x7
>  #define CTRL_DISABLE   0x0
>
> +#define CFG_FLPDCACHE  (1 << 20) /* System MMU 3.2+ only */
> +
>  #define REG_MMU_CTRL           0x000
>  #define REG_MMU_CFG            0x004
>  #define REG_MMU_STATUS         0x008
> @@ -96,6 +98,9 @@
>
>  #define REG_MMU_VERSION                0x034
>
> +#define MMU_MAJ_VER(reg)       (reg >> 28)
> +#define MMU_MIN_VER(reg)       ((reg >> 21) & 0x7F)
> +
>  #define REG_PB0_SADDR          0x04C
>  #define REG_PB0_EADDR          0x050
>  #define REG_PB1_SADDR          0x054
> @@ -200,6 +205,22 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
>         return data->activations > 0;
>  }
>
> +static unsigned int __sysmmu_version(struct sysmmu_drvdata *data,
> +                                    int idx, unsigned int *minor)
> +{
> +       unsigned long major;
> +
> +       major = readl(data->sfrbases[idx] + REG_MMU_VERSION);
> +
> +       if (minor)
> +               *minor = MMU_MIN_VER(major);
> +
> +       if (MMU_MAJ_VER(major) > 3)
> +               return 1;
> +
> +       return MMU_MAJ_VER(major);
> +}
> +
>  static void sysmmu_unblock(void __iomem *sfrbase)
>  {
>         __raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
> @@ -460,14 +481,15 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
>         data->pgtable = pgtable;
>
>         for (i = 0; i < data->nsfrs; i++) {
> +               unsigned int min;
> +
>                 __sysmmu_set_ptbase(data->sfrbases[i], pgtable);
>
> -               if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> -                       /* System MMU version is 3.x */
> -                       __raw_writel((1 << 12) | (2 << 28),
> +               if ((__sysmmu_version(data, i, &min) == 3) && (min > 1)) {
> +                       unsigned long cfg;
> +                       cfg = __raw_readl(data->sfrbases[i] + REG_MMU_CFG);
> +                       __raw_writel(cfg | CFG_FLPDCACHE,
>                                         data->sfrbases[i] + REG_MMU_CFG);
> -                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
> -                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
>                 }
>
>                 __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> --
> 1.7.2.5
>
>
