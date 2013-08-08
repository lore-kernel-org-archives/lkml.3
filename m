Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab3HHLMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:12:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33827 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3HHLMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <51F018FB.1050106@eo.pl>
References: <51F018FB.1050106@eo.pl>
Date: Thu, 8 Aug 2013 19:12:32 +0800
Message-ID: <CA+qZnSRhbPp0KzXm_LhcNRwOJr=JR5xcveE-a9f+dhbTU_C89g@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/proc: cached = pagecache - shmem
From: tingwei liu <tingw.liu@gmail.com>
To: Adrian Brzezinski <adrian.brzezinski@eo.pl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 2:12 AM, Adrian Brzezinski
<adrian.brzezinski@eo.pl> wrote:
>
> Cached value taken from /proc/meminfo counts also shmem pages.
> This can be very confusing when we encounter OOM problems.
>
> Maybe the better solution would be, to not increment NR_FILE_PAGES,
> when we have NR_SHMEM page? Should I rewrote and resend this patch?
>
I suggest to consider push this patch to mainline.
> Signed-off-by: Adrian Brzezinski <adrian.brzezinski@eo.pl>
> ---
>  fs/proc/meminfo.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 5aa847a..d00aef5 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -40,7 +40,12 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>         allowed = ((totalram_pages - hugetlb_total_pages())
>                 * sysctl_overcommit_ratio / 100) + total_swap_pages;
>
> +       /*
> +        * NR_SHMEM pages can't be treated as a cache,
> +        * but they are counted in NR_FILE_PAGES
> +        */
>         cached = global_page_state(NR_FILE_PAGES) -
> +                       global_page_state(NR_SHMEM) -
>                         total_swapcache_pages() - i.bufferram;
>         if (cached < 0)
>                 cached = 0;
> @@ -59,6 +64,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>                 "Buffers:        %8lu kB\n"
>                 "Cached:         %8lu kB\n"
>                 "SwapCached:     %8lu kB\n"
> +               "PageCache:      %8lu kB\n"
>                 "Active:         %8lu kB\n"
>                 "Inactive:       %8lu kB\n"
>                 "Active(anon):   %8lu kB\n"
> @@ -111,6 +117,7 @@ static int meminfo_proc_show(struct seq_file *m,
> void *v)
>                 K(i.bufferram),
>                 K(cached),
>                 K(total_swapcache_pages()),
> +               K(global_page_state(NR_FILE_PAGES)),
>                 K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
>                 K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE]),
>                 K(pages[LRU_ACTIVE_ANON]),
> --
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
