Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3LMWF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:05:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3LMWF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:05:56 -0500
Date: Fri, 13 Dec 2013 17:05:37 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Message-ID: <1386972337-x4axszvt-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386917611-11319-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386917611-11319-3-git-send-email-iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 2/6] mm/migrate: correct failure handling if
 !hugepage_migration_support()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386917611-11319-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:53:27PM +0900, Joonsoo Kim wrote:
> We should remove the page from the list if we fail with ENOSYS,
> since migrate_pages() consider error cases except -ENOMEM and -EAGAIN
> as permanent failure and it assumes that the page would be removed from
> the list. Without this patch, we could overcount number of failure.
> 
> In addition, we should put back the new hugepage if
> !hugepage_migration_support(). If not, we would leak hugepage memory.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi

> diff --git a/mm/migrate.c b/mm/migrate.c
> index c6ac87a..b1cfd01 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1011,7 +1011,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
>  {
>  	int rc = 0;
>  	int *result = NULL;
> -	struct page *new_hpage = get_new_page(hpage, private, &result);
> +	struct page *new_hpage;
>  	struct anon_vma *anon_vma = NULL;
>  
>  	/*
> @@ -1021,9 +1021,12 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
>  	 * tables or check whether the hugepage is pmd-based or not before
>  	 * kicking migration.
>  	 */
> -	if (!hugepage_migration_support(page_hstate(hpage)))
> +	if (!hugepage_migration_support(page_hstate(hpage))) {
> +		putback_active_hugepage(hpage);
>  		return -ENOSYS;
> +	}
>  
> +	new_hpage = get_new_page(hpage, private, &result);
>  	if (!new_hpage)
>  		return -ENOMEM;
>  
> -- 
> 1.7.9.5
> 
