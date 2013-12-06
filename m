Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3LFOmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:42:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab3LFOmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:42:21 -0500
Message-ID: <52A1E248.1000204@suse.cz>
Date: Fri, 06 Dec 2013 15:42:16 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm/migrate: correct return value of migrate_pages()
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 09:41 AM, Joonsoo Kim wrote:
> migrate_pages() should return number of pages not migrated or error code.
> When unmap_and_move return -EAGAIN, outer loop is re-execution without
> initialising nr_failed. This makes nr_failed over-counted.
>
> So this patch correct it by initialising nr_failed in outer loop.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 3747fcd..1f59ccc 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1102,6 +1102,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
>
>   	for(pass = 0; pass < 10 && retry; pass++) {
>   		retry = 0;
> +		nr_failed = 0;
>
>   		list_for_each_entry_safe(page, page2, from, lru) {
>   			cond_resched();
>

If I'm reading the code correctly, unmap_and_move() (and 
unmap_and_move_huge_page() as well) deletes all pages from the 'from' 
list, unless it fails with -EAGAIN. So the only pages you see in 
subsequent passes are those that failed with -EAGAIN and those are not 
counted as nr_failed. So there shouldn't be over-count, but your patch 
could result in under-count.

Perhaps a comment somewhere would clarify this.
