Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534Ab3HIHzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:55:42 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:65169 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967769Ab3HIHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:55:39 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
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
Subject: Re: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own slab
Date: Fri, 09 Aug 2013 09:55:30 +0200
Message-ID: <2101296.S6JDU5igl3@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130809145849.790a9800f4f9893b30e54a1c@samsung.com>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com> <2544843.sndV7usHTj@amdc1227> <20130809145849.790a9800f4f9893b30e54a1c@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Friday 09 of August 2013 14:58:49 Cho KyongHo wrote:
> On Thu, 08 Aug 2013 16:00:18 +0200, Tomasz Figa wrote:
> > On Thursday 08 of August 2013 18:38:04 Cho KyongHo wrote:
> > > Since kmalloc() does not guarantee that the allignment of 1KiB when
> > > it
> > > allocates 1KiB, it is required to allocate lv2 page table from own
> > > slab that guarantees alignment of 1KiB
> > > 
> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > ---
> > > 
> > >  drivers/iommu/exynos-iommu.c |   24 ++++++++++++++++++++----
> > >  1 files changed, 20 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/iommu/exynos-iommu.c
> > > b/drivers/iommu/exynos-iommu.c index d90e6fa..a318049 100644
> > > --- a/drivers/iommu/exynos-iommu.c
> > > +++ b/drivers/iommu/exynos-iommu.c
> > > @@ -100,6 +100,8 @@
> > > 
> > >  #define REG_PB1_SADDR		0x054
> > >  #define REG_PB1_EADDR		0x058
> > > 
> > > +static struct kmem_cache *lv2table_kmem_cache;
> > > +
> > > 
> > >  static unsigned long *section_entry(unsigned long *pgtable,
> > >  unsigned
> > > 
> > > long iova) {
> > > 
> > >  	return pgtable + lv1ent_offset(iova);
> > > 
> > > @@ -765,7 +767,8 @@ static void exynos_iommu_domain_destroy(struct
> > > iommu_domain *domain)
> > > 
> > >  	for (i = 0; i < NUM_LV1ENTRIES; i++)
> > >  	
> > >  		if (lv1ent_page(priv->pgtable + i))
> > > 
> > > -			kfree(__va(lv2table_base(priv->pgtable + i)));
> > > +			kmem_cache_free(lv2table_kmem_cache,
> > > +					__va(lv2table_base(priv->pgtable + 
i)));
> > > 
> > >  	free_pages((unsigned long)priv->pgtable, 2);
> > >  	free_pages((unsigned long)priv->lv2entcnt, 1);
> > > 
> > > @@ -861,7 +864,7 @@ static unsigned long *alloc_lv2entry(unsigned
> > > long
> > > *sent, unsigned long iova, if (lv1ent_fault(sent)) {
> > > 
> > >  		unsigned long *pent;
> > > 
> > > -		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> > > +		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
> > > 
> > >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> > >  		if (!pent)
> > >  		
> > >  			return ERR_PTR(-ENOMEM);
> > > 
> > > @@ -881,7 +884,7 @@ static int lv1set_section(unsigned long *sent,
> > > phys_addr_t paddr, short *pgcnt)
> > > 
> > >  	if (lv1ent_page(sent)) {
> > >  	
> > >  		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> > > 
> > > -		kfree(page_entry(sent, 0));
> > > +		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
> > > 
> > >  		*pgcnt = 0;
> > >  	
> > >  	}
> > > 
> > > @@ -1082,10 +1085,23 @@ static int __init exynos_iommu_init(void)
> > > 
> > >  {
> > >  
> > >  	int ret;
> > > 
> > > +	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> > > +				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > > +	if (!lv2table_kmem_cache) {
> > > +		pr_err("%s: Failed to create kmem cache\n", __func__);
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > > 
> > >  	ret = platform_driver_register(&exynos_sysmmu_driver);
> > >  	
> > >  	if (ret == 0)
> > > 
> > > -		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > > +		ret = bus_set_iommu(&platform_bus_type, 
&exynos_iommu_ops);
> > > +
> > > +	if (ret) {
> > > +		pr_err("%s: Failed to register exynos-iommu driver.\n",
> > > +								__func__);
> > > +		kmem_cache_destroy(lv2table_kmem_cache);
> > > +	}
> > 
> > What about making the return value handling here cleaner? For example:
> > 	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> > 	
> > 				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > 	
> > 	if (!lv2table_kmem_cache) {
> > 	
> > 		...
> > 		return -ENOMEM;
> > 	
> > 	}
> > 	
> > 	ret = platform_driver_register(&exynos_sysmmu_driver);
> > 	if (ret) {
> > 	
> > 		...
> > 		goto err_destroy_kmem_cache;
> > 	
> > 	}
> > 	
> > 	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > 	if (ret) {
> > 	
> > 		...
> > 		goto err_platform_unregister;
> > 	
> > 	}
> > 	
> > 	return 0;
> > 
> > err_platform_unregister:
> > 	...
> > 
> > err_destroy_kmem_cache:
> > 	...
> > 	return ret;
> > 
> > }
> 
> Thank you for suggestion.
> I think you are worrying about missing the information who makes 'ret'
> non-zero.

Oh, this is a valid point, but it was more a nitpick about the coding 
style. Single path error handling (with goto) is widely used in the kernel 
in cases when more than one thing has to be undone and so I suggested this 
method of error handling here as well.

> Ok. I will process it separately.

Since this patch adds most of the error handling to this function, I think 
it should be fine to do it as a part of this patch.

Best regards,
Tomasz

