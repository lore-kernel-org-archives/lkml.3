Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3KMJHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:07:30 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932421Ab3KMJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:07:15 -0500
Message-ID: <52834138.7050005@nod.at>
Date: Wed, 13 Nov 2013 10:07:04 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>, Jeff Dike <jdike@addtoit.com>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>
Subject: Re: [PATCH] arch: um: kernel: skas: mmu: remove pmd_free() and pud_free()
 for failure processing in init_stub_pte()
References: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils> <528308E8.8040203@asianux.com>
In-Reply-To: <528308E8.8040203@asianux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.11.2013 06:06, schrieb Chen Gang:
> Unfortunately, p?d_alloc() and p?d_free() are not pair!! If p?d_alloc()
> succeed, they may be used, so in the next failure, we have to skip them
> to let exit_mmap() or do_munmap() to process it.
> 
> According to "Documentation/vm/locking", 'mm->page_table_lock' is for
> using vma list, so not need it when its related vmas are detached or
> unmapped from using vma list.
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
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Sounds reasonable to me.
*But* there are patches you from out there that tried to fix similar issues and got reverted later.
Now I'm a bit nervous and want a ACK from mm folks to have this verified.
It's not that I don't trust you, but I really don't trust you. ;-)

Thanks,
//richard
