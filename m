Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3LDWLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:11:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab3LDWL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:11:28 -0500
Date: Wed, 04 Dec 2013 17:11:17 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Wagin <avagin@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <1386195077-yqe6395x-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386183786-9400-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1386183786-9400-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] thp: move preallocated PTE page table on move_huge_pmd()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386183786-9400-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:03:06PM +0200, Kirill A. Shutemov wrote:
> Andrey Wagin reported crash on VM_BUG_ON() in pgtable_pmd_page_dtor()
> with fallowing backtrace:
> 
>   [<ffffffff8119427f>] free_pgd_range+0x2bf/0x410
>   [<ffffffff8119449e>] free_pgtables+0xce/0x120
>   [<ffffffff8119b900>] unmap_region+0xe0/0x120
>   [<ffffffff811a0036>] ? move_page_tables+0x526/0x6b0
>   [<ffffffff8119d6a9>] do_munmap+0x249/0x360
>   [<ffffffff811a0304>] move_vma+0x144/0x270
>   [<ffffffff811a07e9>] SyS_mremap+0x3b9/0x510
>   [<ffffffff8172d512>] system_call_fastpath+0x16/0x1b
> 
> The crash can be reproduce with this test case:
> 
>   #define _GNU_SOURCE
>   #include <sys/mman.h>
>   #include <stdio.h>
>   #include <unistd.h>
> 
>   #define MB (1024 * 1024UL)
>   #define GB (1024 * MB)
> 
>   int main(int argc, char **argv)
>   {
> 	char *p;
> 	int i;
> 
> 	p = mmap((void *) GB, 10 * MB, PROT_READ | PROT_WRITE,
> 			MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
> 	for (i = 0; i < 10 * MB; i += 4096)
> 		p[i] = 1;
> 	mremap(p, 10 * MB, 10 * MB, MREMAP_FIXED | MREMAP_MAYMOVE, 2 * GB);
> 	return 0;
>   }
> 
> Due to split PMD lock, we now store preallocated PTE tables for THP
> pages per-PMD table.  It means we need to move them to other PMD table
> if huge PMD moved there.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Andrey Vagin <avagin@openvz.org>

looks good to me.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/huge_memory.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bccd5a628ea6..33a5dc492810 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1481,8 +1481,18 @@ int move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
>  		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
>  		VM_BUG_ON(!pmd_none(*new_pmd));
>  		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
> -		if (new_ptl != old_ptl)
> +		if (new_ptl != old_ptl) {
> +			pgtable_t pgtable;
> +
> +			/*
> +			 * Move preallocated PTE page table if new_pmd is on
> +			 * different PMD page table.
> +			 */
> +			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
> +			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
> +
>  			spin_unlock(new_ptl);
> +		}
>  		spin_unlock(old_ptl);
>  	}
>  out:
> -- 
> 1.8.4.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
