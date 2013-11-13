Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3KMHNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:13:41 -0500
Received: from intranet.asianux.com ([58.214.24.6]:20443 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3KMHNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:13:38 -0500
X-Spam-Score: -100.8
Message-ID: <52832724.1090000@asianux.com>
Date: Wed, 13 Nov 2013 15:15:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: revert mremap pud_free anti-fix
References: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils> <525D2B15.8060503@asianux.com>
In-Reply-To: <525D2B15.8060503@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 07:46 PM, Chen Gang wrote:
> On 10/15/2013 06:34 PM, Hugh Dickins wrote:
>> > Revert 1ecfd533f4c5 ("mm/mremap.c: call pud_free() after fail calling
>> > pmd_alloc()").  The original code was correct: pud_alloc(), pmd_alloc(),
>> > pte_alloc_map() ensure that the pud, pmd, pt is already allocated, and
>> > seldom do they need to allocate; on failure, upper levels are freed if
>> > appropriate by the subsequent do_munmap().  Whereas 1ecfd533f4c5 did an
>> > unconditional pud_free() of a most-likely still-in-use pud: saved only
>> > by the near-impossiblity of pmd_alloc() failing.
>> > 
> What you said above sounds reasonable to me,  but better to provide the
> information below:
> 
>  - pud_free() for pgd_alloc() in "arch/arm/mm/pgd.c".
> 

It is correct, it is for 'new_pgd' which not come from 'mm'.

>  - pud_free() for init_stub_pte() in "arch/um/kernel/skas/mmu.c".
> 

For me, it need improvement, I have sent related patch for it.

>  - more details about do_munmap(), (e.g. do it need mm->page_table_lock)
>    or more details about the demo "most-likely still-in-use pud ...".
> 

According to "Documentation/vm/locking", 'mm->page_table_lock' is for
using vma list, so not need it when its related vmas are detached from
using vma list.

The related work flow:

  do_munmap()->
    detach_vmas_to_be_unmapped(); /* so not need mm->page_table_lock */
    unmap_region() ->
      free_pgtables() ->
        free_pgd_range() ->
          free_pud_range() ->
            free_pmd_range() ->
              free_pte_range() ->
                pmd_clear();
                pte_free_tlb();
              pud_clear();
              pmd_free_tlb();
            pgd_clear();
            pud_free_tlb();


Thanks.

> 
> Hmm... I am not quite sure about the 3 things, and I will/should
> continue analysing/learning about them, but better to get your reply. :-)


-- 
Chen Gang
