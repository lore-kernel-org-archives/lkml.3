Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3KKOls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:41:48 -0500
Received: from [204.155.152.216] ([204.155.152.216]:45697 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab3KKOln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:41:43 -0500
Date: Mon, 11 Nov 2013 15:45:19 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] x86, mm: get ASLR work for hugetlb mappings
Message-ID: <20131111134519.GA2926@shutemov.name>
References: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 04:52:20PM +0300, Kirill A. Shutemov wrote:
> Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.
> The reason is genereic hugetlb_get_unmapped_area() which is used on
> x86-64. It doesn't support randomization and use bottom-up unmapped area
> lookup, instead of usual top-down on x86-64.
> 
> x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> x86-32.
> 
> Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
> It fixes the issue and make hugetlb use top-down unmapped area lookup.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>

Gentelmen,

Could you take a look on the patch, please?

It's currently in -mm to get it tested on -next, but it should go through
x86 tree, I believe.

> ---
>  arch/x86/include/asm/page.h    | 1 +
>  arch/x86/include/asm/page_32.h | 4 ----
>  arch/x86/mm/hugetlbpage.c      | 9 +++------
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index c87892442e..775873d3be 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -71,6 +71,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
>  #include <asm-generic/getorder.h>
>  
>  #define __HAVE_ARCH_GATE_AREA 1
> +#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
>  
>  #endif	/* __KERNEL__ */
>  #endif /* _ASM_X86_PAGE_H */
> diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
> index 4d550d04b6..904f528cc8 100644
> --- a/arch/x86/include/asm/page_32.h
> +++ b/arch/x86/include/asm/page_32.h
> @@ -5,10 +5,6 @@
>  
>  #ifndef __ASSEMBLY__
>  
> -#ifdef CONFIG_HUGETLB_PAGE
> -#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
> -#endif
> -
>  #define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
>  #ifdef CONFIG_DEBUG_VIRTUAL
>  extern unsigned long __phys_addr(unsigned long);
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 9d980d88b7..8c9f647ff9 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -87,9 +87,7 @@ int pmd_huge_support(void)
>  }
>  #endif
>  
> -/* x86_64 also uses this file */
> -
> -#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
> +#ifdef CONFIG_HUGETLB_PAGE
>  static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
>  		unsigned long addr, unsigned long len,
>  		unsigned long pgoff, unsigned long flags)
> @@ -99,7 +97,7 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
>  
>  	info.flags = 0;
>  	info.length = len;
> -	info.low_limit = TASK_UNMAPPED_BASE;
> +	info.low_limit = current->mm->mmap_legacy_base;
>  	info.high_limit = TASK_SIZE;
>  	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
>  	info.align_offset = 0;
> @@ -172,8 +170,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>  		return hugetlb_get_unmapped_area_topdown(file, addr, len,
>  				pgoff, flags);
>  }
> -
> -#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
> +#endif /* CONFIG_HUGETLB_PAGE */
>  
>  #ifdef CONFIG_X86_64
>  static __init int setup_hugepagesz(char *opt)
> -- 
> 1.8.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
