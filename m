Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3GKRh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:37:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22798 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3GKRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:37:55 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-e8-51deed716fc2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: Re: [PATCH v7 3/9] iommu/exynos: fix page table maintenance
Date: Thu, 11 Jul 2013 19:37:47 +0200
Message-id: <1933986.4vddYccClk@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
In-reply-to: <002b01ce797b$44d4ad10$ce7e0730$@samsung.com>
References: <002b01ce797b$44d4ad10$ce7e0730$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xoG7h23uBBs9eqVi8OvKDyWLBfmuL
	ztkb2C02H1zHYtG74CqbReO9CWwWmx5fY7W4vGsOm8WM8/uYLC6s2Mhu8a/3IKPFlEWHWS1a
	rvcyOfB6PDk4j8ljdsNFFo871/aweWxeUu8x+cZyRo++LasYPT5vkgtgj+KySUnNySxLLdK3
	S+DK2H3sJXvBc8WKpr972RsYj0p1MXJySAiYSJw/fYwNwhaTuHBvPZDNxSEkMJ1R4vf/yYwg
	CSGBFiaJ5fMrQGw2ASuJie2rwOIiAhoSn6+sZwVpYBbYzCLR1b+EBSQhLOAi8XfxRaAiDg4W
	AVWJnSdCQcK8ApoSy/q3sYPYogL2EtvevQVbzAk0c/frLSwQuywlvt55ywJRLyjxY/I9MJtZ
	QF5i3/6prBC2lsT6nceZJjAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBEfMM+kdjKsaLA4xCnAwKvHwFpy4FyjEmlhWXJl7iFGCg1lJhDf4ClCINyWxsiq1KD++
	qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDY3Kh60MpK67gsri3XmzPihnf
	LlnyRHC31M3zhxNLrz0P2hyw5s4nFRa17pWv/vaHR3CZxWtNeO1zrHa318cVe/K3rJad3jvt
	udkb3vtJOZrb22reiVt9DTrqqc/ZbiKxOVg1fN3kbu+ggwFq+R3T047Xm3ttdjvldS7BbXeQ
	9LcFvMsXzWKcocRSnJFoqMVcVJwIAAiyp1uUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Some minor nitpicks below.

On Friday, July 05, 2013 09:29:18 PM Cho KyongHo wrote:
> This prevents allocating lv2 page table for the lv1 page table entry
> that already has 1MB page mapping. In addition some BUG_ON() is
> changed to WARN_ON().
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++++++--------
>  1 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index e3be3e5..2bfe9fa 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -862,12 +862,14 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
>  		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
>  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
>  		if (!pent)
> -			return NULL;
> +			return ERR_PTR(-ENOMEM);
>  
>  		*sent = mk_lv1ent_page(__pa(pent));
>  		*pgcounter = NUM_LV2ENTRIES;
>  		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
>  		pgtable_flush(sent, sent + 1);
> +	} else if (lv1ent_section(sent)) {
> +		return ERR_PTR(-EADDRINUSE);
>  	}
>  
>  	return page_entry(sent, iova);
> @@ -944,16 +946,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
>  		pent = alloc_lv2entry(entry, iova,
>  					&priv->lv2entcnt[lv1ent_offset(iova)]);
>  
> -		if (!pent)
> -			ret = -ENOMEM;
> +		if (IS_ERR(pent))
> +			ret = PTR_ERR(pent);
>  		else
>  			ret = lv2set_page(pent, paddr, size,
>  					&priv->lv2entcnt[lv1ent_offset(iova)]);
>  	}
>  
>  	if (ret) {
> -		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
> -							__func__, iova, size);
> +		pr_err("%s: Failed(%d) to map iova 0x%#x bytes @ %#lx\n",
> +						__func__, ret, size, iova);
>  	}

Intendation is a bit weird, it should be more like:

		pr_err("%s: Failed(%d) to map iova 0x%#x bytes @ %#lx\n",
			__func__, ret, size, iova);

to be consistent with the rest of the driver.

You could have also removed superfluous braces while at it.

>  	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> @@ -968,6 +970,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>  	struct sysmmu_drvdata *data;
>  	unsigned long flags;
>  	unsigned long *ent;
> +	size_t err_page;
>  
>  	BUG_ON(priv->pgtable == NULL);
>  
> @@ -976,7 +979,8 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>  	ent = section_entry(priv->pgtable, iova);
>  
>  	if (lv1ent_section(ent)) {
> -		BUG_ON(size < SECT_SIZE);
> +		if (WARN_ON(size < SECT_SIZE))
> +			goto err;
>  
>  		*ent = 0;
>  		pgtable_flush(ent, ent + 1);
> @@ -1008,7 +1012,8 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>  	}
>  
>  	/* lv1ent_large(ent) == true here */
> -	BUG_ON(size < LPAGE_SIZE);
> +	if (WARN_ON(size < LPAGE_SIZE))
> +		goto err;
>  
>  	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
>  	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> @@ -1023,8 +1028,21 @@ done:
>  		sysmmu_tlb_invalidate_entry(data->dev, iova);
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  
> -
>  	return size;
> +err:
> +	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> +
> +	err_page = (
> +		((unsigned long)ent - (unsigned long)priv->pgtable)
> +			< (NUM_LV1ENTRIES * sizeof(long))

Maybe you could add LV1TABLE_SIZE define and use it here (there is
already a LV2TABLE_SIZE define)?

> +			   ) ?  SECT_SIZE : LPAGE_SIZE;

It also seems that err_page should be of unsigned long type, no need
to make it size_t one.

The above code is quite ugly currently, it could be rewritten into
something prettier, i.e.:

	err_page = (unsigned long)ent - (unsigned long)priv->pgtable;
	err_page = (err_page < LV1TABLE_SIZE) ? SECT_SIZE : LPAGE_SIZE;

> +	pr_err("%s: Failed due to size(%#lx) @ %#x is"\
> +		" smaller than page size %#x\n",
> +		__func__, iova, size, err_page);

Aren't iova and size arguments interchanged here?

> +
> +	       return 0;

There is an intendation issue here (extra whitespaces).

> +
>  }
>  
>  static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

