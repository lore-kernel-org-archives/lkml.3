Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaGGP5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:57:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaGGP5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:57:53 -0400
Message-ID: <53BAC37D.3060703@suse.cz>
Date: Mon, 07 Jul 2014 17:57:49 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] mm/page_alloc: use get_onbuddy_migratetype() to
 get buddy list type
References: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com> <1404460675-24456-9-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1404460675-24456-9-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 09:57 AM, Joonsoo Kim wrote:
> When isolating free page, what we want to know is which list
> the page is linked. If it is linked in isolate migratetype buddy list,
> we can skip watermark check and freepage counting. And if it is linked
> in CMA migratetype buddy list, we need to fixup freepage counting. For
> this purpose, get_onbuddy_migratetype() is more fit and cheap than
> get_pageblock_migratetype(). So use it.

Hm but you made get_onbuddy_migratetype() work only with 
CONFIG_MEMORY_ISOLATION. And __isolate_free_page is (despite the name) 
not at all limited to CONFIG_MEMORY_ISOLATION.

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>   mm/page_alloc.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e1c4c3e..d9fb8bb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1597,7 +1597,7 @@ static int __isolate_free_page(struct page *page, unsigned int order)
>   	BUG_ON(!PageBuddy(page));
>
>   	zone = page_zone(page);
> -	mt = get_pageblock_migratetype(page);
> +	mt = get_onbuddy_migratetype(page);
>
>   	if (!is_migrate_isolate(mt)) {
>   		/* Obey watermarks as if the page was being allocated */
>

