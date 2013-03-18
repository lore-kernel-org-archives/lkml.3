Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3CROwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:52:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab3CROwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:52:04 -0400
Date: Mon, 18 Mar 2013 15:51:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] migrate: add migrate_entry_wait_huge()
Message-ID: <20130318145159.GP10192@dhcp22.suse.cz>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361475708-25991-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-02-13 14:41:40, Naoya Horiguchi wrote:
[...]
> diff --git v3.8.orig/mm/migrate.c v3.8/mm/migrate.c
> index 2fd8b4a..7d84f4c 100644
> --- v3.8.orig/mm/migrate.c
> +++ v3.8/mm/migrate.c
> @@ -236,6 +236,30 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
>  	pte_unmap_unlock(ptep, ptl);
>  }
>  
> +void migration_entry_wait_huge(struct mm_struct *mm, pmd_t *pmd,
> +				unsigned long address)
> +{
> +	spinlock_t *ptl = pte_lockptr(mm, pmd);
> +	pte_t pte;
> +	swp_entry_t entry;
> +	struct page *page;
> +
> +	spin_lock(ptl);
> +	pte = huge_ptep_get((pte_t *)pmd);
> +	if (!is_hugetlb_entry_migration(pte))
> +		goto out;
> +	entry = pte_to_swp_entry(pte);
> +	page = migration_entry_to_page(entry);
> +	if (!get_page_unless_zero(page))
> +		goto out;
> +	spin_unlock(ptl);
> +	wait_on_page_locked(page);
> +	put_page(page);
> +	return;
> +out:
> +	spin_unlock(ptl);
> +}

This duplicates a lot of code from migration_entry_wait. Can we just
teach the generic one to be HugePage aware instead?
All it takes is just opencoding pte_offset_map_lock and calling
huge_ptep_get ofr HugePage and pte_offset_map otherwise.
-- 
Michal Hocko
SUSE Labs
