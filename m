Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3HFB4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:56:22 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55080 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3HFB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:56:21 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 9/8] hugetlb: add pmd_huge_support() to migrate only pmd-based hugepage
In-Reply-To: <1375734465-scgr8g4z-mutt-n-horiguchi@ah.jp.nec.com>
References: <1375734465-scgr8g4z-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 06 Aug 2013 07:26:10 +0530
Message-ID: <87eha7oa4l.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080601-1618-0000-0000-00000467612F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> This patch is motivated by the discussion with Aneesh about "extend
> hugepage migration" patchset.
>   http://thread.gmane.org/gmane.linux.kernel.mm/103933/focus=104391
> I'll append this to the patchset in the next post, but before that
> I want this patch to be reviewed (I don't want to repeat posting the
> whole set for just minor changes.)
>
> Any comments?
>
> Thanks,
> Naoya Horiguchi
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Mon, 5 Aug 2013 13:33:02 -0400
> Subject: [PATCH] hugetlb: add pmd_huge_support() to migrate only pmd-based
>  hugepage
>
> Currently hugepage migration works well only for pmd-based hugepages,
> because core routines of hugepage migration use pmd specific internal
> functions like huge_pte_offset(). So we should not enable the migration
> of other levels of hugepages until we are ready for it.

I guess huge_pte_offset may not be the right reason because archs do
implement huge_pte_offsets even if they are not pmd-based hugepages

pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
{
	/* Only called for hugetlbfs pages, hence can ignore THP */
	return find_linux_pte_or_hugepte(mm->pgd, addr, NULL);
}

>
> Some users of hugepage migration (mbind, move_pages, and migrate_pages)
> do page table walk and check pud/pmd_huge() there, so they are safe.
> But the other users (softoffline and memory hotremove) don't do this,
> so they can try to migrate unexpected types of hugepages.
>
> To prevent this, we introduce an architecture dependent check of whether
> hugepage are implemented on a pmd basis or not. It returns 0 if pmd_huge()
> returns always 0, and 1 otherwise.
>

so why not #define pmd_huge_support pmd_huge or use pmd_huge directly ?

> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  arch/arm/mm/hugetlbpage.c     |  5 +++++
>  arch/arm64/mm/hugetlbpage.c   |  5 +++++
>  arch/ia64/mm/hugetlbpage.c    |  5 +++++
>  arch/metag/mm/hugetlbpage.c   |  5 +++++
>  arch/mips/mm/hugetlbpage.c    |  5 +++++
>  arch/powerpc/mm/hugetlbpage.c | 10 ++++++++++
>  arch/s390/mm/hugetlbpage.c    |  5 +++++
>  arch/sh/mm/hugetlbpage.c      |  5 +++++
>  arch/sparc/mm/hugetlbpage.c   |  5 +++++
>  arch/tile/mm/hugetlbpage.c    |  5 +++++
>  arch/x86/mm/hugetlbpage.c     |  8 ++++++++
>  include/linux/hugetlb.h       |  2 ++
>  mm/migrate.c                  | 11 +++++++++++
>  13 files changed, 76 insertions(+)
>
> diff --git a/arch/arm/mm/hugetlbpage.c b/arch/arm/mm/hugetlbpage.c
> index 3d1e4a2..3f3b6a7 100644
> --- a/arch/arm/mm/hugetlbpage.c
> +++ b/arch/arm/mm/hugetlbpage.c
> @@ -99,3 +99,8 @@ int pmd_huge(pmd_t pmd)
>  {
>  	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
>  }
> +
> +int pmd_huge_support(void)
> +{
> +	return 1;
> +}

-aneesh

