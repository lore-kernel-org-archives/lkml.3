Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3GZRQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:16:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60210 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab3GZRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <004101ce89f3$90200980$b0601c80$@samsung.com>
References: <004101ce89f3$90200980$b0601c80$@samsung.com>
Date: Fri, 26 Jul 2013 10:16:48 -0700
X-Google-Sender-Auth: Ca7rM3SRfmTFt8PkcUW-6WjM0nU
Message-ID: <CANEJEGv0Bj=iMD=O2jPUc4u918mNQ_CuLvjc2P9ztRrKVKP0iQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/12] iommu/exynos: change rwlock to spinlock
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

On Fri, Jul 26, 2013 at 4:30 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> Since acquiring read_lock is not more frequent than write_lock, it is
> not beneficial to use rwlock, this commit changes rwlock to spinlock.
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>

Reviewed-by: Grant Grundler <grundler@chromium.org>

cheers,
grant

> ---
>  drivers/iommu/exynos-iommu.c |   36 ++++++++++++++++++------------------
>  1 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index c62c244..51e5b35 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -187,7 +187,7 @@ struct sysmmu_drvdata {
>         struct clk *clk;
>         struct clk *clk_master;
>         int activations;
> -       rwlock_t lock;
> +       spinlock_t lock;
>         struct iommu_domain *domain;
>         bool runtime_active;
>         unsigned long pgtable;
> @@ -287,7 +287,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
>         BUG_ON((base0 + size0) <= base0);
>         BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
>
> -       read_lock_irqsave(&data->lock, flags);
> +       spin_lock_irqsave(&data->lock, flags);
>         if (!is_sysmmu_active(data))
>                 goto finish;
>
> @@ -319,7 +319,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
>         }
>         clk_disable(data->clk_master);
>  finish:
> -       read_unlock_irqrestore(&data->lock, flags);
> +       spin_unlock_irqrestore(&data->lock, flags);
>  }
>
>  static void show_fault_information(const char *name,
> @@ -371,7 +371,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>
>         if (client)
>                 spin_lock(&client->lock);
> -       read_lock(&data->lock);
> +       spin_lock(&data->lock);
>
>         if (i == data->nsfrs) {
>                 itype = SYSMMU_FAULT_UNKNOWN;
> @@ -402,7 +402,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>         if (itype != SYSMMU_FAULT_UNKNOWN)
>                 sysmmu_unblock(data->sfrbases[i]);
>
> -       read_unlock(&data->lock);
> +       spin_unlock(&data->lock);
>         if (client)
>                 spin_unlock(&client->lock);
>
> @@ -429,7 +429,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
>         bool disabled;
>         unsigned long flags;
>
> -       write_lock_irqsave(&data->lock, flags);
> +       spin_lock_irqsave(&data->lock, flags);
>
>         disabled = set_sysmmu_inactive(data);
>
> @@ -446,7 +446,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
>                                         data->activations);
>         }
>
> -       write_unlock_irqrestore(&data->lock, flags);
> +       spin_unlock_irqrestore(&data->lock, flags);
>
>         return disabled;
>  }
> @@ -493,7 +493,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
>         int ret = 0;
>         unsigned long flags;
>
> -       write_lock_irqsave(&data->lock, flags);
> +       spin_lock_irqsave(&data->lock, flags);
>         if (set_sysmmu_active(data)) {
>                 data->pgtable = pgtable;
>                 data->domain = domain;
> @@ -511,7 +511,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
>         if (WARN_ON(ret < 0))
>                 set_sysmmu_inactive(data); /* decrement count */
>
> -       write_unlock_irqrestore(&data->lock, flags);
> +       spin_unlock_irqrestore(&data->lock, flags);
>
>         return ret;
>  }
> @@ -602,7 +602,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
>
>                 data = dev_get_drvdata(client->sysmmu[i]);
>
> -               read_lock_irqsave(&data->lock, flags);
> +               spin_lock_irqsave(&data->lock, flags);
>                 if (is_sysmmu_active(data) && data->runtime_active) {
>                         int i;
>                         clk_enable(data->clk_master);
> @@ -615,7 +615,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
>                                 "disabled. Skipping TLB invalidation @ %#lx\n",
>                                 iova);
>                 }
> -               read_unlock_irqrestore(&data->lock, flags);
> +               spin_unlock_irqrestore(&data->lock, flags);
>         }
>  }
>
> @@ -630,7 +630,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>
>                 data = dev_get_drvdata(client->sysmmu[i]);
>
> -               read_lock_irqsave(&data->lock, flags);
> +               spin_lock_irqsave(&data->lock, flags);
>                 if (is_sysmmu_active(data) &&
>                                 data->runtime_active) {
>                         int i;
> @@ -646,7 +646,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>                 } else {
>                         dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
>                 }
> -               read_unlock_irqrestore(&data->lock, flags);
> +               spin_unlock_irqrestore(&data->lock, flags);
>         }
>  }
>
> @@ -735,7 +735,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>
>         data->runtime_active = !pm_runtime_enabled(dev);
>
> -       rwlock_init(&data->lock);
> +       spin_lock_init(&data->lock);
>         INIT_LIST_HEAD(&data->node);
>
>         platform_set_drvdata(pdev, data);
> @@ -749,11 +749,11 @@ static int sysmmu_suspend(struct device *dev)
>  {
>         struct sysmmu_drvdata *data = dev_get_drvdata(dev);
>         unsigned long flags;
> -       read_lock_irqsave(&data->lock, flags);
> +       spin_lock_irqsave(&data->lock, flags);
>         if (is_sysmmu_active(data) &&
>                 (!pm_runtime_enabled(dev) || data->runtime_active))
>                 __sysmmu_disable_nocount(data);
> -       read_unlock_irqrestore(&data->lock, flags);
> +       spin_unlock_irqrestore(&data->lock, flags);
>         return 0;
>  }
>
> @@ -761,11 +761,11 @@ static int sysmmu_resume(struct device *dev)
>  {
>         struct sysmmu_drvdata *data = dev_get_drvdata(dev);
>         unsigned long flags;
> -       read_lock_irqsave(&data->lock, flags);
> +       spin_lock_irqsave(&data->lock, flags);
>         if (is_sysmmu_active(data) &&
>                 (!pm_runtime_enabled(dev) || data->runtime_active))
>                 __sysmmu_enable_nocount(data);
> -       read_unlock_irqrestore(&data->lock, flags);
> +       spin_unlock_irqrestore(&data->lock, flags);
>         return 0;
>  }
>  #endif
> --
> 1.7.2.5
>
>
