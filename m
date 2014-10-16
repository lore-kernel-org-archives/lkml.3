Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaJPPSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:18:50 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43072 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJPPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:18:48 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        benh@kernel.crashing.org, mpe@ellerman.id.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, will.deacon@arm.com,
        catalin.marinas@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH 1/2] mm: Update generic gup implementation to handle hugepage directory
In-Reply-To: <20141016092529.GA1524@linaro.org>
References: <1413390888-4934-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141016092529.GA1524@linaro.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 16 Oct 2014 20:48:20 +0530
Message-ID: <871tq8kpqb.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101615-0013-0000-0000-0000005BC49B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Capper <steve.capper@linaro.org> writes:

> On Wed, Oct 15, 2014 at 10:04:47PM +0530, Aneesh Kumar K.V wrote:
>> Update generic gup implementation with powerpc specific details.
>> On powerpc at pmd level we can have hugepte, normal pmd pointer
>> or a pointer to the hugepage directory.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> Hi,
> This patch causes compiler errors on arm and arm64 due to pgd_huge
> being undefined. I've attached a fixup below, this fixup will require
> that #define pgd_huge(pgd) 0 be added back into:
> arch/powerpc/include/asm/page.h
> For the second patch in this series.
>
> Another avenue would be to do something like:
> #ifndef pgd_huge
> #define pgd_huge(pgd)	(0)
> #endif
>
> Then no changes would be required to arm and arm64 (or other
> architectures).
>
> To help with bisectability, could we please have a suitable fix applied
> to the two patches in the -mm tree:
> http://ozlabs.org/~akpm/mmots/broken-out/mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch
> http://ozlabs.org/~akpm/mmots/broken-out/arch-powerpc-switch-to-generic-rcu-get_user_pages_fast.patch
>
> rather than applied afterwards?
>
> With pgd_huge(x) defined, this patch passes my futex test on arm
> (Arndale platform) and arm64(Juno).
>
> Cheers,
> -- 
> Steve
>
>
>
> From 2fb7b0308f0aca94c50611257ba82d656abb0768 Mon Sep 17 00:00:00 2001
> From: Steve Capper <steve.capper@linaro.org>
> Date: Thu, 16 Oct 2014 09:09:48 +0100
> Subject: [PATCH] Fixup for Update generic gup implementation
>
> The patch:
> mm: Update generic gup implementation to handle hugepage directory
>
> will not compile for arm or arm64 due to pgd_huge being undefined.
>
> Signed-off-by: Steve Capper <steve.capper@linaro.org>
> ---
>  arch/arm/include/asm/pgtable.h   | 2 ++
>  arch/arm64/include/asm/pgtable.h | 2 ++
>  include/linux/hugetlb.h          | 1 -
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> index 90aa4583..46f81fb 100644
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -181,6 +181,8 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>  /* to find an entry in a kernel page-table-directory */
>  #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
>
> +#define pgd_huge(pgd)		(0)
> +
>  #define pmd_none(pmd)		(!pmd_val(pmd))
>  #define pmd_present(pmd)	(pmd_val(pmd))
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 464c5ce..d4462ca 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -462,6 +462,8 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
>  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>  extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
>
> +#define pgd_huge(pgd)		(0)
> +
>  /*
>   * Encode and decode a swap entry:
>   *	bits 0-1:	present (must be zero)
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65e12a2..6e6d338 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -138,7 +138,6 @@ static inline void hugetlb_show_meminfo(void)
>  #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
>  #define pmd_huge(x)	0
>  #define pud_huge(x)	0
> -#define pgd_huge(x)	0
>  #define is_hugepage_only_range(mm, addr, len)	0
>  #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
>  #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })

don't do the last hunk, that will result in build failures on sub
platforms on ppc64. can you do the arm patch without making the change
to hugetlb.h ?

-aneesh

