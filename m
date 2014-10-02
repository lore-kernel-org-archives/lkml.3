Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaJBTVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:21:54 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41783 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaJBTVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:21:53 -0400
Date: Thu, 2 Oct 2014 12:20:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: migrate: Close race between migration completion
 and mprotect
In-Reply-To: <1412275662-16201-2-git-send-email-mgorman@suse.de>
Message-ID: <alpine.LSU.2.11.1410021211500.7465@eggly.anvils>
References: <1412275662-16201-1-git-send-email-mgorman@suse.de> <1412275662-16201-2-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014, Mel Gorman wrote:

> A migration entry is marked as write if pte_write was true at the time the
> entry was created. The VMA protections are not double checked when migration
> entries are being removed as mprotect marks write-migration-entries as
> read. It means that potentially we take a spurious fault to mark PTEs write
> again but it's straight-forward. However, there is a race between write
> migrations being marked read and migrations finishing. This potentially
> allows a PTE to be write that should have been read. Close this race by
> double checking the VMA permissions using maybe_mkwrite when migration
> completes.
> 
> [torvalds@linux-foundation.org: use maybe_mkwrite]
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>

Sort-of-Acked-by: Hugh Dickins <hughd@google.com>

Safe patch, but I stand by the conclusion we both arrived at when
looking at this case a few weeks ago: it eliminates the surprise
we got in seeing a PROTNONE pte with RW set, but does not appear
to fix any actual bug.  As mprotect proceeds, it's inevitable that
some of the ptes will have more or less permissions than mprotect
is imposing, and it doesn't matter, because mprotect has mmap_sem
exclusively, so faults on the area can only complete either before
or after the whole mprotect operation.

> ---
>  mm/migrate.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index f78ec9b..0c07339 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -146,8 +146,11 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
>  	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
>  	if (pte_swp_soft_dirty(*ptep))
>  		pte = pte_mksoft_dirty(pte);
> +
> +	/* Recheck VMA as permissions can change since migration started  */
>  	if (is_write_migration_entry(entry))
> -		pte = pte_mkwrite(pte);
> +		pte = maybe_mkwrite(pte, vma);
> +
>  #ifdef CONFIG_HUGETLB_PAGE
>  	if (PageHuge(new)) {
>  		pte = pte_mkhuge(pte);
> -- 
> 1.8.4.5
