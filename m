Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965399Ab3HHOA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:00:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18061 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500Ab3HHOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:00:23 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-b3-5203a474bb6e
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
Subject: Re: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own
 slab
Date: Thu, 08 Aug 2013 16:00:18 +0200
Message-id: <2544843.sndV7usHTj@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4Fd2SJcxBBtNWmFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktTv7pZbRoud7L5MDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpY1baOvaBXqmL2i52sDYx9ol2MnBwSAiYSqy/PYIaw
	xSQu3FvP1sXIxSEksJRR4tLbI6wQTheTxIyvE9hAqtgE1CQ+NzwCs0UENCQ+X1nPCmIzC/xg
	kfi0jQ/EFhYIltj07CcjiM0ioCrRvfQeWD2vgKbEkQ3T2UFsfgF1iXfbnjJ1MXJwiAq4SUz4
	mA8S5hSwklg+/yALiC0kYCnx+sFtZohWQYkfk++xQKySl9i3fyrUWi2J9TuPM01gFJyFpGwW
	krJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJuC87GBcfszrEKMDBqMTD2xHA
	FCTEmlhWXJl7iFGCg1lJhPdFFnOQEG9KYmVValF+fFFpTmrxIUYmDk6pBkbDzv27kkQ3bPGR
	np1ev8Y112vrd++tm97cuK66V6dwdfSpI2mMTJvnXBV4zP3NWNo19prPLgfPKv0Vd5I3ltW+
	v/jrfMrLSTIrN72ZU69fr5H89ZqpxZFnlhMXygv5X21YmTxvTf2bg+8mX7sX2XKONyHGdmX4
	dN/Ef8+vaydsL3tt2HzogVC6EktxRqKhFnNRcSIAGCWd1JYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 of August 2013 18:38:04 Cho KyongHo wrote:
> Since kmalloc() does not guarantee that the allignment of 1KiB when it
> allocates 1KiB, it is required to allocate lv2 page table from own
> slab that guarantees alignment of 1KiB
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index d90e6fa..a318049 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -100,6 +100,8 @@
>  #define REG_PB1_SADDR		0x054
>  #define REG_PB1_EADDR		0x058
> 
> +static struct kmem_cache *lv2table_kmem_cache;
> +
>  static unsigned long *section_entry(unsigned long *pgtable, unsigned
> long iova) {
>  	return pgtable + lv1ent_offset(iova);
> @@ -765,7 +767,8 @@ static void exynos_iommu_domain_destroy(struct
> iommu_domain *domain)
> 
>  	for (i = 0; i < NUM_LV1ENTRIES; i++)
>  		if (lv1ent_page(priv->pgtable + i))
> -			kfree(__va(lv2table_base(priv->pgtable + i)));
> +			kmem_cache_free(lv2table_kmem_cache,
> +					__va(lv2table_base(priv->pgtable + i)));
> 
>  	free_pages((unsigned long)priv->pgtable, 2);
>  	free_pages((unsigned long)priv->lv2entcnt, 1);
> @@ -861,7 +864,7 @@ static unsigned long *alloc_lv2entry(unsigned long
> *sent, unsigned long iova, if (lv1ent_fault(sent)) {
>  		unsigned long *pent;
> 
> -		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> +		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
>  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
>  		if (!pent)
>  			return ERR_PTR(-ENOMEM);
> @@ -881,7 +884,7 @@ static int lv1set_section(unsigned long *sent,
> phys_addr_t paddr, short *pgcnt)
> 
>  	if (lv1ent_page(sent)) {
>  		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> -		kfree(page_entry(sent, 0));
> +		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
>  		*pgcnt = 0;
>  	}
> 
> @@ -1082,10 +1085,23 @@ static int __init exynos_iommu_init(void)
>  {
>  	int ret;
> 
> +	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> +				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> +	if (!lv2table_kmem_cache) {
> +		pr_err("%s: Failed to create kmem cache\n", __func__);
> +		return -ENOMEM;
> +	}
> +
>  	ret = platform_driver_register(&exynos_sysmmu_driver);
> 
>  	if (ret == 0)
> -		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> +		ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> +
> +	if (ret) {
> +		pr_err("%s: Failed to register exynos-iommu driver.\n",
> +								__func__);
> +		kmem_cache_destroy(lv2table_kmem_cache);
> +	}

What about making the return value handling here cleaner? For example:

	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
	if (!lv2table_kmem_cache) {
		...
		return -ENOMEM;
	}

	ret = platform_driver_register(&exynos_sysmmu_driver);
	if (ret) {
		...
		goto err_destroy_kmem_cache;
	}

	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
	if (ret) {
		...
		goto err_platform_unregister;
	}

	return 0;

err_platform_unregister:
	...
err_destroy_kmem_cache:
	...
	return ret;
}

Best regards,
Tomasz

