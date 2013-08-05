Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3HEQjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:39:49 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47386 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3HEQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <1372781307-7906-1-git-send-email-grundler@chromium.org>
References: <1372781307-7906-1-git-send-email-grundler@chromium.org>
Date: Mon, 5 Aug 2013 09:39:45 -0700
X-Google-Sender-Auth: _MLt0fTwCkfDRquJVOpmFxmAXDk
Message-ID: <CANEJEGu2B9FUDLn5EOPm1hOau1Y+s6rFZy3WVFQCO=3T6acgmg@mail.gmail.com>
Subject: Re: [PATCH] iommu/exynos: remove dead code (set_prefbuf)
From: Grant Grundler <grundler@chromium.org>
To: Linux IOMMU <iommu@lists.linux-foundation.org>,
        KyongHo Cho <pullip.cho@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, Sachin Kamat <sachin.kamat@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Adding linux-iommu ML.

thanks,
grant

On Tue, Jul 2, 2013 at 9:08 AM, Grant Grundler <grundler@chromium.org> wrote:
> exynos_sysmmu_set_prefbuf() is not called any where.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/iommu/exynos-iommu.c | 44 --------------------------------------------
>  1 file changed, 44 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 3f32d64..0740189 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -247,50 +247,6 @@ static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
>         __raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
>  }
>
> -void exynos_sysmmu_set_prefbuf(struct device *dev,
> -                               unsigned long base0, unsigned long size0,
> -                               unsigned long base1, unsigned long size1)
> -{
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -       unsigned long flags;
> -       int i;
> -
> -       BUG_ON((base0 + size0) <= base0);
> -       BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
> -
> -       read_lock_irqsave(&data->lock, flags);
> -       if (!is_sysmmu_active(data))
> -               goto finish;
> -
> -       for (i = 0; i < data->nsfrs; i++) {
> -               if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> -                       if (!sysmmu_block(data->sfrbases[i]))
> -                               continue;
> -
> -                       if (size1 == 0) {
> -                               if (size0 <= SZ_128K) {
> -                                       base1 = base0;
> -                                       size1 = size0;
> -                               } else {
> -                                       size1 = size0 -
> -                                               ALIGN(size0 / 2, SZ_64K);
> -                                       size0 = size0 - size1;
> -                                       base1 = base0 + size0;
> -                               }
> -                       }
> -
> -                       __sysmmu_set_prefbuf(
> -                                       data->sfrbases[i], base0, size0, 0);
> -                       __sysmmu_set_prefbuf(
> -                                       data->sfrbases[i], base1, size1, 1);
> -
> -                       sysmmu_unblock(data->sfrbases[i]);
> -               }
> -       }
> -finish:
> -       read_unlock_irqrestore(&data->lock, flags);
> -}
> -
>  static void __set_fault_handler(struct sysmmu_drvdata *data,
>                                         sysmmu_fault_handler_t handler)
>  {
> --
> 1.8.3
>
