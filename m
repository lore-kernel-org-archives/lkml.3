Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3CJKcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:32:39 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59628 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3CJKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <1362902470-25787-11-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
	<1362902470-25787-11-git-send-email-jiang.liu@huawei.com>
Date: Sun, 10 Mar 2013 12:32:26 +0200
X-Google-Sender-Auth: WgcsDYGxIu3DB2B4lSHGwc9gWCQ
Message-ID: <CAOJsxLHoWGo+B9w-Vmxdv_YWneEqN0U_2cSuvM7H4U67sfFksg@mail.gmail.com>
Subject: Re: [PATCH v2, part2 10/10] mm/x86: use free_highmem_page() to free
 highmem pages into buddy system
From: Pekka Enberg <penberg@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Cong Wang <amwang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Attilio Rao <attilio.rao@citrix.com>, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 10:01 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Use helper function free_highmem_page() to free highmem pages into
> the buddy system.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  arch/x86/mm/highmem_32.c |    1 -
>  arch/x86/mm/init_32.c    |   10 +---------
>  2 files changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index 6f31ee5..252b8f5 100644
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -137,5 +137,4 @@ void __init set_highmem_pages_init(void)
>                 add_highpages_with_active_regions(nid, zone_start_pfn,
>                                  zone_end_pfn);
>         }
> -       totalram_pages += totalhigh_pages;

Hmm? I haven't looked at what totalram_pages is used for but could you
explain why this change is safe?

>  }
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 2d19001..3ac7e31 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -427,14 +427,6 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
>         pkmap_page_table = pte;
>  }
>
> -static void __init add_one_highpage_init(struct page *page)
> -{
> -       ClearPageReserved(page);
> -       init_page_count(page);
> -       __free_page(page);
> -       totalhigh_pages++;
> -}
> -
>  void __init add_highpages_with_active_regions(int nid,
>                          unsigned long start_pfn, unsigned long end_pfn)
>  {
> @@ -448,7 +440,7 @@ void __init add_highpages_with_active_regions(int nid,
>                                               start_pfn, end_pfn);
>                 for ( ; pfn < e_pfn; pfn++)
>                         if (pfn_valid(pfn))
> -                               add_one_highpage_init(pfn_to_page(pfn));
> +                               free_highmem_page(pfn_to_page(pfn));
>         }
>  }
>  #else
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
