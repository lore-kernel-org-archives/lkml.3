Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaCOGgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 02:36:04 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37584 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaCOGgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 02:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140314140234.c972b52a96a4fe39acd09fe0@samsung.com>
References: <20140314140234.c972b52a96a4fe39acd09fe0@samsung.com>
Date: Fri, 14 Mar 2014 23:35:59 -0700
X-Google-Sender-Auth: cFfcU699E6zYR8OZcG5m5wOnmv4
Message-ID: <CANEJEGvkoUEWoJ4Y5sXwAr2KHW0MESj-1cHQ31AVRasG0P8pzg@mail.gmail.com>
Subject: Re: [PATCH v11 02/27] iommu/exynos: add missing cache flush for
 removed page table entries
From: Grant Grundler <grundler@chromium.org>
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
        Sachin Kamat <sachin.kamat@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply this. It's way overdue.  It fixes customer kernel crashes
we've seen in the field.

I'd also advocate for seeing this be applied to stable kernels.

thanks,
grant

On Thu, Mar 13, 2014 at 10:02 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> This commit adds cache flush for removed small and large page entries
> in exynos_iommu_unmap(). Missing cache flush of removed page table
> entries can cause missing page fault interrupt when a master IP
> accesses an unmapped area.
>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Tested-by: Grant Grundler <grundler@chromium.org>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 4876d35..1c3a397 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -958,6 +958,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>         if (lv2ent_small(ent)) {
>                 *ent = 0;
>                 size = SPAGE_SIZE;
> +               pgtable_flush(ent, ent + 1);
>                 priv->lv2entcnt[lv1ent_offset(iova)] += 1;
>                 goto done;
>         }
> @@ -966,6 +967,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>         BUG_ON(size < LPAGE_SIZE);
>
>         memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> +       pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
>
>         size = LPAGE_SIZE;
>         priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
> --
> 1.7.9.5
>
