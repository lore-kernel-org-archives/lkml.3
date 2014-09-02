Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaIBMbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaIBMbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:31:52 -0400
Date: Tue, 2 Sep 2014 08:31:34 -0400
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 2/6] mm/balloon_compaction: keep ballooned pages away
 from normal migration path
Message-ID: <20140902123133.GC14419@t510.redhat.com>
References: <20140830163834.29066.98205.stgit@zurg>
 <20140830164113.29066.25879.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830164113.29066.25879.stgit@zurg>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 08:41:13PM +0400, Konstantin Khlebnikov wrote:
> From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> 
> Proper testing shows yet another problem in balloon migration: it works only
> once for each page. balloon_page_movable() check page flags and page_count.
> In __unmap_and_move page is locked, reference counter is elevated, so
> balloon_page_movable() _always_ fails here. As result in __unmap_and_move()
> migration goes to the normal migration path.
> 
> Balloon ->migratepage() is so special, it returns MIGRATEPAGE_BALLOON_SUCCESS
> instead of MIGRATEPAGE_SUCCESS. After that in move_to_new_page() successfully
> migrated page got NULL into its mapping pointer and loses connectivity with
> balloon and ability for further migration.
> 
> It's safe to use __is_movable_balloon_page here: page is isolated and pinned.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Cc: stable <stable@vger.kernel.org> # v3.8
> ---
>  include/linux/balloon_compaction.h |    5 +++++
>  mm/migrate.c                       |    2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index 53d482e..284fc1d 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -258,6 +258,11 @@ static inline void balloon_page_delete(struct page *page)
>  	list_del(&page->lru);
>  }
>  
> +static inline bool __is_movable_balloon_page(struct page *page)
> +{
> +	return false;
> +}
> +
>  static inline bool balloon_page_movable(struct page *page)
>  {
>  	return false;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 905b1aa..57c94f9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -873,7 +873,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
>  		}
>  	}
>  
> -	if (unlikely(balloon_page_movable(page))) {
> +	if (unlikely(__is_movable_balloon_page(page))) {
>  		/*
>  		 * A ballooned page does not need any special attention from
>  		 * physical to virtual reverse mapping procedures.
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

