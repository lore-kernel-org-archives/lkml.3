Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab3GZP7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:59:03 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:37498 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab3GZP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <003801ce89f2$f8952d20$e9bf8760$@samsung.com>
References: <003801ce89f2$f8952d20$e9bf8760$@samsung.com>
Date: Fri, 26 Jul 2013 08:58:55 -0700
X-Google-Sender-Auth: flXsOHV4c_Krfi6EVZvaYJl8ssA
Message-ID: <CANEJEGshTH2pymFWeN0rOmdxRZOvVFD+AEbZ23QdxNpVkDmevw@mail.gmail.com>
Subject: Re: [PATCH v8 02/12] iommu/exynos: add missing cache flush for
 removed page table entries
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

On Fri, Jul 26, 2013 at 4:26 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> This commit adds cache flush for removed small and large page entries
> in exynos_iommu_unmap(). Missing cache flush of removed page table
> entries can cause missing page fault interrupt when a master IP
> accesses an unmapped area.
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>

Tested-by: Grant Grundler <grundler@chromium.org>

I'm convinced this is a critical fix to apply. Any time we touch the
IOMMU Page Table, we need to flush so the change is immediately
visible to the IOMMU.

thanks,
grant

> ---
>  drivers/iommu/exynos-iommu.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 233f382..e3be3e5 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>         if (lv2ent_small(ent)) {
>                 *ent = 0;
>                 size = SPAGE_SIZE;
> +               pgtable_flush(ent, ent +1);
>                 priv->lv2entcnt[lv1ent_offset(iova)] += 1;
>                 goto done;
>         }
> @@ -1010,6 +1011,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>         BUG_ON(size < LPAGE_SIZE);
>
>         memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> +       pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
>
>         size = LPAGE_SIZE;
>         priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
> --
> 1.7.2.5
>
>
