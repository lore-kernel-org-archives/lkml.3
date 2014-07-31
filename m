Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaGaW5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:57:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaGaW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:57:05 -0400
Date: Thu, 31 Jul 2014 15:57:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gioh Kim <gioh.kim@lge.com>
Cc: "=?UTF-8?Q?'=EA=B9=80=EC=A4=80=EC=88=98'?=" <iamjoonsoo.kim@lge.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ????????? <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: Re: [PATCHv2] CMA/HOTPLUG: clear buffer-head lru before page
 migration
Message-Id: <20140731155703.a8bc3b77af913c8b3a63090a@linux-foundation.org>
In-Reply-To: <53D9A86B.20208@lge.com>
References: <53D9A86B.20208@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 11:22:35 +0900 Gioh Kim <gioh.kim@lge.com> wrote:

> The previous PATCH inserts invalidate_bh_lrus() only into CMA code.
> HOTPLUG needs also dropping bh of lru.
> So v2 inserts invalidate_bh_lrus() into both of CMA and HOTPLUG.
> 
> 
> ---------------------------- 8< ----------------------------
> The bh must be free to migrate a page at which bh is mapped.
> The reference count of bh is increased when it is installed
> into lru so that the bh of lru must be freed before migrating the page.
> 
> This frees every bh of lru. We could free only bh of migrating page.
> But searching lru sometimes costs more than invalidating entire lru.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  mm/memory_hotplug.c |    1 +
>  mm/page_alloc.c     |    2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a3797d3..1c5454f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1672,6 +1672,7 @@ repeat:
>                 lru_add_drain_all();
>                 cond_resched();
>                 drain_all_pages();
> +               invalidate_bh_lrus();

Both of these calls should have a comment explaining why
invalidate_bh_lrus() is being called.

>         }
> 
>         pfn = scan_movable_pages(start_pfn, end_pfn);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b99643d4..c00dedf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6369,6 +6369,8 @@ int alloc_contig_range(unsigned long start, unsigned long end,
>         if (ret)
>                 return ret;
> 
> +       invalidate_bh_lrus();
> +
>         ret = __alloc_contig_migrate_range(&cc, start, end);
>         if (ret)
>                 goto done;

I do feel that this change is likely to be beneficial, but I don't want
to apply such a patch until I know what its effects are upon all
alloc_contig_range() callers.  Especially hugetlb.
