Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3DXXER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:04:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100Ab3DXXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:04:16 -0400
Date: Thu, 25 Apr 2013 00:04:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20130424230410.GB2619@decadent.org.uk>
References: <20130423215333.344045754@linuxfoundation.org>
 <20130423215333.802657218@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423215333.802657218@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 04/26] hugetlbfs: add swap entry check in
 follow_hugetlb_page()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 02:53:44PM -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> commit 9cc3a5bd40067b9a0fbd49199d0780463fc2140f upstream.
> 
> With applying the previous patch "hugetlbfs: stop setting VM_DONTDUMP in
> initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a memory
> error happens on a hugepage and the affected processes try to access the
> error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <= 0) in
> get_page().
 
Is this required?  You didn't apply the previous patch referred to
above (commit a2fce9143057) to 3.4.y or 3.0.y since it claimed to fix
a regression in 3.7 (commit 314e51b9851b 'mm: kill vma flag VM_RESERVED
and mm->reserved_vm counter').

I'm not saying it *isn't* required, mind.

Ben.

> The reason for this bug is that coredump-related code doesn't recognise
> "hugepage hwpoison entry" with which a pmd entry is replaced when a memory
> error occurs on a hugepage.
> 
> In other words, physical address information is stored in different bit
> layout between hugepage hwpoison entry and pmd entry, so
> follow_hugetlb_page() which is called in get_dump_page() returns a wrong
> page from a given address.
> 
> The expected behavior is like this:
> 
>   absent   is_swap_pte   FOLL_DUMP   Expected behavior
>   -------------------------------------------------------------------
>    true     false         false       hugetlb_fault
>    false    true          false       hugetlb_fault
>    false    false         false       return page
>    true     false         true        skip page (to avoid allocation)
>    false    true          true        hugetlb_fault
>    false    false         true        return page
> 
> With this patch, we can call hugetlb_fault() and take proper actions (we
> wait for migration entries, fail with VM_FAULT_HWPOISON_LARGE for
> hwpoisoned entries,) and as the result we can dump all hugepages except
> for hwpoisoned ones.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Rik van Riel <riel@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  mm/hugetlb.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2906,7 +2906,17 @@ int follow_hugetlb_page(struct mm_struct
>  			break;
>  		}
>  
> -		if (absent ||
> +		/*
> +		 * We need call hugetlb_fault for both hugepages under migration
> +		 * (in which case hugetlb_fault waits for the migration,) and
> +		 * hwpoisoned hugepages (in which case we need to prevent the
> +		 * caller from accessing to them.) In order to do this, we use
> +		 * here is_swap_pte instead of is_hugetlb_entry_migration and
> +		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
> +		 * both cases, and because we can't follow correct pages
> +		 * directly from any kind of swap entries.
> +		 */
> +		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
>  		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
>  			int ret;
>  

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
