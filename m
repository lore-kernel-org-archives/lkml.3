Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3KNFUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:20:53 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42000 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3KNFUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:20:46 -0500
Date: Wed, 13 Nov 2013 21:20:27 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Chen Gang <gang.chen@asianux.com>
cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>
Subject: Re: [PATCH] arch: um: kernel: skas: mmu: remove pmd_free() and
 pud_free() for failure processing in init_stub_pte()
In-Reply-To: <528308E8.8040203@asianux.com>
Message-ID: <alpine.LNX.2.00.1311132041200.1785@eggly.anvils>
References: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils> <528308E8.8040203@asianux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013, Chen Gang wrote:

> Unfortunately, p?d_alloc() and p?d_free() are not pair!! If p?d_alloc()
> succeed, they may be used, so in the next failure, we have to skip them
> to let exit_mmap() or do_munmap() to process it.
> 
> According to "Documentation/vm/locking", 'mm->page_table_lock' is for
> using vma list, so not need it when its related vmas are detached or
> unmapped from using vma list.

Hah, don't believe a word of Documentation/vm/locking.  From time to
time someone or other has updated some part of it, but on the whole
it represents the state of the art in 1999.  Look at its git history:
not a lot of activity there.

And please don't ask me to update it, and please don't try to update
it yourself.  Delete it?  Maybe.

Study the code itself for how mm locking is actually done
(can you see anywhere we use page_table_lock on the vma list?)

> 
> The related work flow:
> 
>   exit_mmap() ->
>     unmap_vmas(); /* so not need mm->page_table_lock */
>     free_pgtables();
> 
>   do_munmap()->
>     detach_vmas_to_be_unmapped(); /* so not need mm->page_table_lock */
>     unmap_region() ->
>       free_pgtables();
> 
>   free_pgtables() ->
>     free_pgd_range() ->
>       free_pud_range() ->
>         free_pmd_range() ->
>           free_pte_range() ->
>             pmd_clear();
>             pte_free_tlb();
>           pud_clear();
>           pmd_free_tlb();
>         pgd_clear(); 
>         pud_free_tlb();

I don't think those notes would belong in this patch...

> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/um/kernel/skas/mmu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
> index 007d550..3fd1951 100644
> --- a/arch/um/kernel/skas/mmu.c
> +++ b/arch/um/kernel/skas/mmu.c
> @@ -40,9 +40,9 @@ static int init_stub_pte(struct mm_struct *mm, unsigned long proc,
>  	return 0;
>  
>   out_pte:
> -	pmd_free(mm, pmd);
> +	/* used by mm->pgd->pud, will free in do_munmap() or exit_mmap() */
>   out_pmd:
> -	pud_free(mm, pud);
> +	/* used by mm->pgd, will free in do_munmap() or exit_mmap() */
>   out:
>  	return -ENOMEM;
>  }
> -- 
> 1.7.7.6

... but I'm not going to ack this: I just don't share your zest
for mucking around with what I don't understand, and don't have
the time to spare to understand it well enough.

>From the look of it, if an error did occur in init_stub_pte(),
then the special mapping of STUB_CODE and STUB_DATA would not
be installed, so this area would be invisible to munmap and exit,
and with your patch then the pages allocated likely to be leaked.

Which is not to say that the existing code is actually correct:
you're probably right that it's technically wrong.  But it would
be very hard to get init_stub_pte() to fail, and has anyone
reported a problem with it?  My guess is not, and my own
inclination to dabble here is zero.

Hugh
