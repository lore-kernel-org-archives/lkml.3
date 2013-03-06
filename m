Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3CFJ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:28:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3CFJ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:28:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,794,1355068800"; 
   d="scan'208";a="6823567"
Message-ID: <51370CC7.8050406@cn.fujitsu.com>
Date: Wed, 06 Mar 2013 17:30:47 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC/PATCH 3/5] mm: get_user_pages: use NON-MOVABLE pages when
 FOLL_DURABLE flag is set
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com> <1362466679-17111-4-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1362466679-17111-4-git-send-email-m.szyprowski@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 17:27:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 17:27:08,
	Serialize complete at 2013/03/06 17:27:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 03/05/2013 02:57 PM, Marek Szyprowski wrote:
> @@ -2495,7 +2498,7 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
>   */
>  static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		unsigned long address, pte_t *page_table, pmd_t *pmd,
> -		spinlock_t *ptl, pte_t orig_pte)
> +		spinlock_t *ptl, pte_t orig_pte, unsigned int flags)
>  	__releases(ptl)
>  {
>  	struct page *old_page, *new_page = NULL;
> @@ -2505,6 +2508,10 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	struct page *dirty_page = NULL;
>  	unsigned long mmun_start = 0;	/* For mmu_notifiers */
>  	unsigned long mmun_end = 0;	/* For mmu_notifiers */
> +	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
> +
> +	if (IS_ENABLED(CONFIG_CMA) && (flags & FAULT_FLAG_NO_CMA))
> +		gfp &= ~__GFP_MOVABLE;

Here just simply strip the __GFP_MOVABLE flag, IIUC it will break the page migrate policy.  
Because " But GFP_MOVABLE is not only a zone specifier but also an allocation policy.".

Another problem is that you add a new flag to instruct the page allocation, 
do we have to also handle the hugepage or THP as Mel ever mentioned?
 
thanks,
linfeng
