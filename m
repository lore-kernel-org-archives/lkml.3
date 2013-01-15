Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab3AOXg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:36:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab3AOXg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:36:27 -0500
Date: Tue, 15 Jan 2013 15:36:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH v2] mm: remove MIGRATE_ISOLATE check in hotpath
Message-Id: <20130115153625.96265439.akpm@linux-foundation.org>
In-Reply-To: <1358209006-18859-1-git-send-email-minchan@kernel.org>
References: <1358209006-18859-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 09:16:46 +0900
Minchan Kim <minchan@kernel.org> wrote:

> Now mm several functions test MIGRATE_ISOLATE and some of those
> are hotpath but MIGRATE_ISOLATE is used only if we enable
> CONFIG_MEMORY_ISOLATION(ie, CMA, memory-hotplug and memory-failure)
> which are not common config option. So let's not add unnecessary
> overhead and code when we don't enable CONFIG_MEMORY_ISOLATION.

ugh.  Better than nothing, I guess.

There remain call sites which do open-coded

	get_pageblock_migratetype(page) != MIGRATE_ISOLATE

(undo_isolate_page_range() is one).  Wanna clean these up as well?

>
> ...
>
> @@ -683,7 +683,7 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
>  	zone->pages_scanned = 0;
>  
>  	__free_one_page(page, zone, order, migratetype);
> -	if (unlikely(migratetype != MIGRATE_ISOLATE))
> +	if (unlikely(!is_migrate_isolate(migratetype)))
>  		__mod_zone_freepage_state(zone, 1 << order, migratetype);
>  	spin_unlock(&zone->lock);
>  }

The code both before and after this patch is assuming that the
migratetype in free_one_page is likely to be MIGRATE_ISOLATE.  Seems
wrong.  If CONFIG_MEMORY_ISOLATION=n this ends up doing
if(unlikely(true)) which is harmless-but-amusing.

