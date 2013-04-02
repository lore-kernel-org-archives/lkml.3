Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576Ab3DBJYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:24:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab3DBJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:24:44 -0400
Date: Tue, 2 Apr 2013 11:24:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugetlbfs: add swap entry check in
 follow_hugetlb_page()
Message-ID: <20130402092441.GE24345@dhcp22.suse.cz>
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1364485358-8745-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130329135730.GB21879@dhcp22.suse.cz>
 <1364577818-615ipxeo-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364577818-615ipxeo-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29-03-13 13:23:38, Naoya Horiguchi wrote:
> Hi,
> 
> On Fri, Mar 29, 2013 at 02:57:30PM +0100, Michal Hocko wrote:
> > On Thu 28-03-13 11:42:38, Naoya Horiguchi wrote:
> > [...]
> > > @@ -2968,7 +2968,8 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
> > >  		 * first, for the page indexing below to work.
> > >  		 */
> > >  		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
> > > -		absent = !pte || huge_pte_none(huge_ptep_get(pte));
> > > +		absent = !pte || huge_pte_none(huge_ptep_get(pte)) ||
> > > +			is_swap_pte(huge_ptep_get(pte));
> > 
> > is_swap_pte doesn't seem right. Shouldn't you use is_hugetlb_entry_hwpoisoned
> > instead?
> 
> I tested only hwpoisoned hugepage, but the same can happen for hugepages
> under migration. So I intended to filter out all types of swap entries.
> The local variable 'absent' seems to mean whether data on the address
> is immediately available, so swap type entry isn't included in it.

OK, I didn't consider huge pages under migration and I was merely worried
that is_hugetlb_entry_hwpoisoned sounds more appropriate than
is_swap_pte.

Could you add a comment which would clarify that is_swap_pte covers both
migration and hwpoison pages, please? Something like:

		/*
		 * is_swap_pte test covers both is_hugetlb_entry_hwpoisoned
		 * and hugepages under migration in which case
		 * hugetlb_fault waits for the migration and bails out
		 * properly for HWPosined pages.
		 */
		 absent = !pte || huge_pte_none(huge_ptep_get(pte)) ||
		 	 is_swap_pte(huge_ptep_get(pte));

Other than that feel free to add
Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks.
-- 
Michal Hocko
SUSE Labs
