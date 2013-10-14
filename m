Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3JNM4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:56:42 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63653 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3JNM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <1381754723-21783-2-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381754723-21783-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1381754723-21783-2-git-send-email-kirill.shutemov@linux.intel.com>
Date: Mon, 14 Oct 2013 16:56:39 +0400
Message-ID: <CAMo8BfLTeew19vq8c+6Yps7Ksx4V2T4Y730t7m+GqFthhC2d2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] xtensa: use buddy allocator for PTE table
From: Max Filippov <jcmvbkbc@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Chris Zankel <chris@zankel.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 4:45 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> At the moment xtensa uses slab allocator for PTE table. It doesn't work
> with enabled split page table lock: slab uses page->slab_cache and
> page->first_page for its pages. These fields share stroage with
> page->ptl.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  arch/xtensa/include/asm/pgalloc.h | 19 +++++++++++--------
>  arch/xtensa/include/asm/pgtable.h |  3 +--
>  arch/xtensa/mm/mmu.c              | 20 --------------------
>  3 files changed, 12 insertions(+), 30 deletions(-)
>
> diff --git a/arch/xtensa/include/asm/pgalloc.h b/arch/xtensa/include/asm/pgalloc.h
> index b8774f1e21..4a361cbc31 100644
> --- a/arch/xtensa/include/asm/pgalloc.h
> +++ b/arch/xtensa/include/asm/pgalloc.h
> @@ -38,14 +38,17 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
>         free_page((unsigned long)pgd);
>  }
>
> -/* Use a slab cache for the pte pages (see also sparc64 implementation) */
> -
> -extern struct kmem_cache *pgtable_cache;
> -
>  static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
>                                          unsigned long address)
>  {
> -       return kmem_cache_alloc(pgtable_cache, GFP_KERNEL|__GFP_REPEAT);
> +       pte_t *ptep;
> +       int i;
> +
> +       ptep = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
> +       if (!ptep)
> +               return NULL;
> +       for (i = 0; i < 1024; i++, ptep++)
> +               pte_clear(NULL, 0, ptep);

Missing return value, maybe

+       ptep = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+       if (ptep)
+               for (i = 0; i < 1024; i++)
+                       pte_clear(NULL, 0, ptep + i);
+       return ptep;

>  }
>
>  static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
> @@ -59,7 +62,7 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
>                 return NULL;
>         page = virt_to_page(pte);
>         if (!pgtable_page_ctor(page)) {
> -               kmem_cache_free(pgtable_cache, pte);
> +               __free_page(page);
>                 return NULL;
>         }
>         return page;
> @@ -67,13 +70,13 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
>
>  static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
>  {
> -       kmem_cache_free(pgtable_cache, pte);
> +       free_page((unsigned long)pte);
>  }
>
>  static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
>  {
>         pgtable_page_dtor(pte);
> -       kmem_cache_free(pgtable_cache, page_address(pte));
> +       __free_page(pte);
>  }
>  #define pmd_pgtable(pmd) pmd_page(pmd)
>
> diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
> index 0fdf5d043f..216446295a 100644
> --- a/arch/xtensa/include/asm/pgtable.h
> +++ b/arch/xtensa/include/asm/pgtable.h
> @@ -220,12 +220,11 @@ extern unsigned long empty_zero_page[1024];
>  #ifdef CONFIG_MMU
>  extern pgd_t swapper_pg_dir[PAGE_SIZE/sizeof(pgd_t)];
>  extern void paging_init(void);
> -extern void pgtable_cache_init(void);
>  #else
>  # define swapper_pg_dir NULL
>  static inline void paging_init(void) { }
> -static inline void pgtable_cache_init(void) { }
>  #endif
> +static inline void pgtable_cache_init(void) { }
>
>  /*
>   * The pmd contains the kernel virtual address of the pte page.
> diff --git a/arch/xtensa/mm/mmu.c b/arch/xtensa/mm/mmu.c
> index a1077570e3..c43771c974 100644
> --- a/arch/xtensa/mm/mmu.c
> +++ b/arch/xtensa/mm/mmu.c
> @@ -50,23 +50,3 @@ void __init init_mmu(void)
>          */
>         set_ptevaddr_register(PGTABLE_START);
>  }
> -
> -struct kmem_cache *pgtable_cache __read_mostly;
> -
> -static void pgd_ctor(void *addr)
> -{
> -       pte_t *ptep = (pte_t *)addr;
> -       int i;
> -
> -       for (i = 0; i < 1024; i++, ptep++)
> -               pte_clear(NULL, 0, ptep);
> -
> -}
> -
> -void __init pgtable_cache_init(void)
> -{
> -       pgtable_cache = kmem_cache_create("pgd",
> -                       PAGE_SIZE, PAGE_SIZE,
> -                       SLAB_HWCACHE_ALIGN,
> -                       pgd_ctor);
> -}
> --
> 1.8.4.rc3
>



-- 
Thanks.
-- Max
