Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaKUGNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:13:19 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56791 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaKUGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:13:18 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
In-Reply-To: <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com> <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Notmuch/0.18.2+162~g34d2c62 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Fri, 21 Nov 2014 11:42:51 +0530
Message-ID: <87h9xt6pzw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112106-0033-0000-0000-000000900C1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> writes:

> We're going to allow mapping of individual 4k pages of THP compound and
> we need a cheap way to find out how many time the compound page is
> mapped with PMD -- compound_mapcount() does this.
>
> page_mapcount() counts both: PTE and PMD mappings of the page.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/mm.h   | 17 +++++++++++++++--
>  include/linux/rmap.h |  4 ++--
>  mm/huge_memory.c     | 23 ++++++++++++++---------
>  mm/hugetlb.c         |  4 ++--
>  mm/memory.c          |  2 +-
>  mm/migrate.c         |  2 +-
>  mm/page_alloc.c      | 13 ++++++++++---
>  mm/rmap.c            | 50 +++++++++++++++++++++++++++++++++++++++++++-------
>  8 files changed, 88 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1825c468f158..aef03acff228 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -435,6 +435,19 @@ static inline struct page *compound_head(struct page *page)
>  	return page;
>  }
>  
> +static inline atomic_t *compound_mapcount_ptr(struct page *page)
> +{
> +	return (atomic_t *)&page[1].mapping;
> +}
> +
> +static inline int compound_mapcount(struct page *page)
> +{
> +	if (!PageCompound(page))
> +		return 0;
> +	page = compound_head(page);
> +	return atomic_read(compound_mapcount_ptr(page)) + 1;
> +}


How about 

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6e0b286649f1..59c9cf3d8510 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -46,6 +46,11 @@ struct page {
 	unsigned long flags;		/* Atomic flags, some possibly
 					 * updated asynchronously */
 	union {
+		/*
+		  * For THP we use this to track the compound
+		  * page mapcount.
+		  */
+		atomic_t _compound_mapcount;
 		struct address_space *mapping;	/* If low bit clear, points to
 						 * inode address_space, or NULL.
 						 * If page mapped as anonymous

and 

static inline atomic_t *compound_mapcount_ptr(struct page *page)
{
        return (atomic_t *)&page[1]._compound_mapcount;
}



-aneesh

