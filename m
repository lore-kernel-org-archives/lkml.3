Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab3GZRX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:23:59 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48454 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3GZRXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <004201ce89f3$9b849a20$d28dce60$@samsung.com>
References: <004201ce89f3$9b849a20$d28dce60$@samsung.com>
Date: Fri, 26 Jul 2013 10:23:54 -0700
X-Google-Sender-Auth: 222_XTqE4SU4rBcObZoU3b2wA4Y
Message-ID: <CANEJEGs_mVetwzT-_hiWie0uc9cZDgEzUXAVYhOu8eeszvGXOQ@mail.gmail.com>
Subject: Re: [PATCH v8 12/12] iommu/exynos: return 0 if iommu_attach_device() successes
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

On Fri, Jul 26, 2013 at 4:31 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> iommu_attach_device() against exynos-iommu positive integer on success
> if the caller calls iommu_attach_device() with the same iommu_domain
> multiple times without call to iommu_detach_device() to inform the
> caller how many calls to iommu_detach_device() to really detach iommu.
>
> However the convention of the return value of success of common API is
> zero, this patch makes iommu_attach_device() call against exynos-iommu
> always return zero if the given device is successfully attached to
> the given iommu_domain even though it is already attached to the same
> iommu_domain.
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>

Reviewed-by: Grant Grundler <grundler@chromium.org>

cheers,
grant

> ---
>  drivers/iommu/exynos-iommu.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 51e5b35..6eed6d6 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -882,15 +882,16 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
>
>         spin_unlock_irqrestore(&priv->lock, flags);
>
> -       if (ret < 0)
> +       if (ret < 0) {
>                 dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
>                                 __func__, __pa(priv->pgtable));
> -       else
> -               dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
> -                                       __func__, __pa(priv->pgtable),
> -                                       (ret == 0) ? "" : ", again");
> +               return ret;
> +       }
>
> -       return ret;
> +       dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
> +               __func__, __pa(priv->pgtable), (ret == 0) ? "" : ", again");
> +
> +       return 0;
>  }
>
>  static void exynos_iommu_detach_device(struct iommu_domain *domain,
> --
> 1.7.2.5
>
>
