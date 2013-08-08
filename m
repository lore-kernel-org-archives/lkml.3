Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728Ab3HHNy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:54:59 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14135 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968Ab3HHNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:54:55 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-9a-5203a32d78e2
From: Tomasz Figa <t.figa@samsung.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
Date: Thu, 08 Aug 2013 15:54:50 +0200
Message-id: <1516548.d7oQuzQS7g@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
References: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e/4NV3dxcxBBvsPS1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktTv7pZbRoud7L5MDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mpo2LydreClQcXCNb9YGxiXqnUxcnJICJhIXNq6mw3C
	FpO4cG89kM3FISSwlFHi3rqXLBBOF5PE7a1rmEGq2ATUJD43PALrEBHQkPh8ZT0riM0s8INF
	4tM2vi5GDg5hATeJ1mOCIGEWAVWJrTens4PYvAKaEs8uvAUr5xdQl3i37SkTSLkoUPmEj/kg
	YU4BK4ld/Z+YQcJCApYSB8+XQHQKSvyYfI8FYpG8xL79U6GWakms33mcaQKj4CwkZbOQlM1C
	UraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRki0fdnBuPiY1SFGAQ5GJR7ejgCmICHW
	xLLiytxDjBIczEoivC+ymIOEeFMSK6tSi/Lji0pzUosPMTJxcEo1MAqYnfjNurTczerAga+M
	2wK6RXI3BSlLf97m49S4Z4OLzTbGvPSVPIn3ghJ1/+w2eMLtGGHNJLPe2KHlZBHr8liPI5eF
	F6y/tkZDqsVGv+ug1jXBdrmPccIlh/P2+Fu4LNZdp1TwfLLa3QUrLu+NevzjVaztR7Wp3jYf
	Gg8plZ+rOn7SZ9+LAiWW4oxEQy3mouJEAD2L5dGUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 of August 2013 18:37:43 Cho KyongHo wrote:
> This prevents allocating lv2 page table for the lv1 page table entry
  ^ What this is this this about? :)

> that already has 1MB page mapping. In addition, changed to BUG_ON
> instead of returning -EADDRINUSE.

The change mentioned in last sentence should be a separate patch.

> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |   68
> ++++++++++++++++++++++++----------------- 1 files changed, 40
> insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index d545a25..d90e6fa 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -52,11 +52,11 @@
>  #define lv2ent_large(pent) ((*(pent) & 3) == 1)
> 
>  #define section_phys(sent) (*(sent) & SECT_MASK)
> -#define section_offs(iova) ((iova) & 0xFFFFF)
> +#define section_offs(iova) ((iova) & ~SECT_MASK)
>  #define lpage_phys(pent) (*(pent) & LPAGE_MASK)
> -#define lpage_offs(iova) ((iova) & 0xFFFF)
> +#define lpage_offs(iova) ((iova) & ~LPAGE_MASK)
>  #define spage_phys(pent) (*(pent) & SPAGE_MASK)
> -#define spage_offs(iova) ((iova) & 0xFFF)
> +#define spage_offs(iova) ((iova) & ~SPAGE_MASK)
> 
>  #define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
>  #define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
> @@ -856,13 +856,15 @@ finish:
>  static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long
> iova, short *pgcounter)
>  {
> +	BUG_ON(lv1ent_section(sent));

Is this condition really a critical one, to the point that the system 
should not continue execution?

> +
>  	if (lv1ent_fault(sent)) {
>  		unsigned long *pent;
> 
>  		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
>  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
>  		if (!pent)
> -			return NULL;
> +			return ERR_PTR(-ENOMEM);
> 
>  		*sent = mk_lv1ent_page(__pa(pent));
>  		*pgcounter = NUM_LV2ENTRIES;
> @@ -875,15 +877,11 @@ static unsigned long *alloc_lv2entry(unsigned long
> *sent, unsigned long iova,
> 
>  static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short
> *pgcnt) {
> -	if (lv1ent_section(sent))
> -		return -EADDRINUSE;
> +	BUG_ON(lv1ent_section(sent));

Ditto.

>  	if (lv1ent_page(sent)) {
> -		if (*pgcnt != NUM_LV2ENTRIES)
> -			return -EADDRINUSE;
> -
> +		BUG_ON(*pgcnt != NUM_LV2ENTRIES);

Ditto.

>  		kfree(page_entry(sent, 0));
> -
>  		*pgcnt = 0;
>  	}
> 
> @@ -894,24 +892,24 @@ static int lv1set_section(unsigned long *sent,
> phys_addr_t paddr, short *pgcnt) return 0;
>  }
> 
> +static void clear_page_table(unsigned long *ent, int n)
> +{
> +	if (n > 0)
> +		memset(ent, 0, sizeof(*ent) * n);
> +}

I don't see the point of creating this function. It seems to be used only 
once, in addition with a constant as n, so the check for n > 0 is 
unnecessary.

And even if there is a need for this change, it should be done in separate 
patch, as this one is not about stylistic changes, but fixing page table 
maintenance (at least based on your commit message).

>  static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t
> size, short *pgcnt)
>  {
>  	if (size == SPAGE_SIZE) {
> -		if (!lv2ent_fault(pent))
> -			return -EADDRINUSE;
> -
> +		BUG_ON(!lv2ent_fault(pent));

Ditto.

>  		*pent = mk_lv2ent_spage(paddr);
>  		pgtable_flush(pent, pent + 1);
>  		*pgcnt -= 1;
>  	} else { /* size == LPAGE_SIZE */
>  		int i;
>  		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
> -			if (!lv2ent_fault(pent)) {
> -				memset(pent, 0, sizeof(*pent) * i);
> -				return -EADDRINUSE;
> -			}
> -
> +			BUG_ON(!lv2ent_fault(pent));

Ditto.

>  			*pent = mk_lv2ent_lpage(paddr);
>  		}
>  		pgtable_flush(pent - SPAGES_PER_LPAGE, pent);
> @@ -944,17 +942,16 @@ static int exynos_iommu_map(struct iommu_domain
> *domain, unsigned long iova, pent = alloc_lv2entry(entry, iova,
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
> -	if (ret) {
> -		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
> -							__func__, iova, size);
> -	}
> +	if (ret)
> +		pr_err("%s: Failed(%d) to map 0x%#x bytes @ %#lx\n",
> +			__func__, ret, size, iova);
> 
>  	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> 
> @@ -968,6 +965,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain
> *domain, struct sysmmu_drvdata *data;
>  	unsigned long flags;
>  	unsigned long *ent;
> +	size_t err_pgsize;
> 
>  	BUG_ON(priv->pgtable == NULL);
> 
> @@ -976,7 +974,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain
> *domain, ent = section_entry(priv->pgtable, iova);
> 
>  	if (lv1ent_section(ent)) {
> -		BUG_ON(size < SECT_SIZE);
> +		if (WARN_ON(size < SECT_SIZE)) {
> +			err_pgsize = SECT_SIZE;
> +			goto err;
> +		}
> 
>  		*ent = 0;
>  		pgtable_flush(ent, ent + 1);
> @@ -1008,9 +1009,12 @@ static size_t exynos_iommu_unmap(struct
> iommu_domain *domain, }
> 
>  	/* lv1ent_large(ent) == true here */
> -	BUG_ON(size < LPAGE_SIZE);
> +	if (WARN_ON(size < LPAGE_SIZE)) {
> +		err_pgsize = LPAGE_SIZE;
> +		goto err;
> +	}
> 
> -	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> +	clear_page_table(ent, SPAGES_PER_LPAGE);

This seems to be the only use of the introduced clear_page_table() 
function. Is there a need to replace the memset with it?

>  	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> 
>  	size = LPAGE_SIZE;
> @@ -1023,8 +1027,16 @@ done:
>  		sysmmu_tlb_invalidate_entry(data->dev, iova);
>  	spin_unlock_irqrestore(&priv->lock, flags);
> 
> -
>  	return size;
> +err:
> +	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> +
> +	pr_err("%s: Failed due to size(%#x) @ %#lx is"\
> +		" smaller than page size %#x\n",
> +		__func__, size, iova, err_pgsize);
> +
> +	return 0;
> +

nit: Stray blank line.

Best regards,
Tomasz

>  }
> 
>  static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain
> *domain,
