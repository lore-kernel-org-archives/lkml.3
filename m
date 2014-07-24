Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaGXJIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaGXJIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:08:06 -0400
Date: Thu, 24 Jul 2014 17:05:52 +0800
From: Baoquan He <bhe@redhat.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec: Export free_huge_page to VMCOREINFO
Message-ID: <20140724090552.GL11399@dhcp-16-105.nay.redhat.com>
References: <0910DD04CBD6DE4193FCF86B9C00BE972400F3@BPXM01GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0910DD04CBD6DE4193FCF86B9C00BE972400F3@BPXM01GP.gisp.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 at 10:34am, Atsushi Kumagai wrote:
> PG_head_mask was added into VMCOREINFO to filter huge pages in
> commit:b3acc56bfe1(kexec: save PG_head_mask in VMCOREINFO), but
> makedumpfile still need another symbol to filter *hugetlbfs* pages.
> 
> If a user hope to filter user pages, makedumpfile tries to exclude
> them by checking the condition whether the page is anonymous, but
> hugetlbfs pages aren't anonymous while they also be user pages.
> 
> We know it's possible to detect them in the same way as PageHuge(),
> so we need the start address of free_huge_page():
> 
>     int PageHuge(struct page *page)
>     {
>             if (!PageCompound(page))
>                     return 0;
> 
>             page = compound_head(page);
>             return get_compound_page_dtor(page) == free_huge_page;
>     }

Since makedumpfile need filter huge pages used for user pages.
Transparent huge pages can be recognised because it's marked as
anonymous page for now. However hugetlbfs huge pages and normal
huge pages can only be differentiated by compound_page_dtor,
hugetlbfs set free_huge_page as compound_page_dtor. So it makes
sense to export compound_page_dtor to VMCOREINFO.

Ack it.

Acked-by: Baoquan He <bhe@redhat.com>

Thanks
Baoquan

> 
> For that reason, this patch changes free_huge_page() into public
> to export it to VMCOREINFO.
> 
> Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
> ---
>  include/linux/hugetlb.h | 1 +
>  kernel/kexec.c          | 2 ++
>  mm/hugetlb.c            | 2 +-
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 255cd5c..a23c096 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -80,6 +80,7 @@ int dequeue_hwpoisoned_huge_page(struct page *page);
>  bool isolate_huge_page(struct page *page, struct list_head *list);
>  void putback_active_hugepage(struct page *page);
>  bool is_hugepage_active(struct page *page);
> +void free_huge_page(struct page *page);
>  
>  #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
>  pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 369f41a..23a088f 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -33,6 +33,7 @@
>  #include <linux/swap.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/compiler.h>
> +#include <linux/hugetlb.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1619,6 +1620,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>  #endif
>  	VMCOREINFO_NUMBER(PG_head_mask);
>  	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
> +	VMCOREINFO_SYMBOL(free_huge_page);
>  
>  	arch_crash_save_vmcoreinfo();
>  	update_vmcoreinfo_note();
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2024bbd..d5437eb 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -856,7 +856,7 @@ struct hstate *size_to_hstate(unsigned long size)
>  	return NULL;
>  }
>  
> -static void free_huge_page(struct page *page)
> +void free_huge_page(struct page *page)
>  {
>  	/*
>  	 * Can't pass hstate in here because it is called from the
> -- 
> 1.9.0
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
