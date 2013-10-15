Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab3JOLrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:47:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17677 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab3JOLri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:47:38 -0400
X-Spam-Score: -100.8
Message-ID: <525D2B15.8060503@asianux.com>
Date: Tue, 15 Oct 2013 19:46:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: revert mremap pud_free anti-fix
References: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 06:34 PM, Hugh Dickins wrote:
> Revert 1ecfd533f4c5 ("mm/mremap.c: call pud_free() after fail calling
> pmd_alloc()").  The original code was correct: pud_alloc(), pmd_alloc(),
> pte_alloc_map() ensure that the pud, pmd, pt is already allocated, and
> seldom do they need to allocate; on failure, upper levels are freed if
> appropriate by the subsequent do_munmap().  Whereas 1ecfd533f4c5 did an
> unconditional pud_free() of a most-likely still-in-use pud: saved only
> by the near-impossiblity of pmd_alloc() failing.
> 

What you said above sounds reasonable to me,  but better to provide the
information below:

 - pud_free() for pgd_alloc() in "arch/arm/mm/pgd.c".

 - pud_free() for init_stub_pte() in "arch/um/kernel/skas/mmu.c".

 - more details about do_munmap(), (e.g. do it need mm->page_table_lock)
   or more details about the demo "most-likely still-in-use pud ...".


Hmm... I am not quite sure about the 3 things, and I will/should
continue analysing/learning about them, but better to get your reply. :-)

Thanks.

> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> 
>  mm/mremap.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- 3.12-rc5/mm/mremap.c	2013-09-16 17:37:56.841072270 -0700
> +++ linux/mm/mremap.c	2013-10-15 03:07:09.140091599 -0700
> @@ -25,7 +25,6 @@
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
>  #include <asm/tlbflush.h>
> -#include <asm/pgalloc.h>
>  
>  #include "internal.h"
>  
> @@ -63,10 +62,8 @@ static pmd_t *alloc_new_pmd(struct mm_st
>  		return NULL;
>  
>  	pmd = pmd_alloc(mm, pud, addr);
> -	if (!pmd) {
> -		pud_free(mm, pud);
> +	if (!pmd)
>  		return NULL;
> -	}
>  
>  	VM_BUG_ON(pmd_trans_huge(*pmd));
>  
> 
> 


-- 
Chen Gang
