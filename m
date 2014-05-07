Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaEGVod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:44:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63380 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaEGVoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:44:30 -0400
Date: Wed, 7 May 2014 14:44:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 1/2] mm/compaction: do not count migratepages when
 unnecessary
In-Reply-To: <1399464550-26447-1-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1405071443010.8454@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com> <1399464550-26447-1-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Vlastimil Babka wrote:

> During compaction, update_nr_listpages() has been used to count remaining
> non-migrated and free pages after a call to migrage_pages(). The freepages
> counting has become unneccessary, and it turns out that migratepages counting
> is also unnecessary in most cases.
> 
> The only situation when it's needed to count cc->migratepages is when
> migrate_pages() returns with a negative error code. Otherwise, the non-negative
> return value is the number of pages that were not migrated, which is exactly
> the count of remaining pages in the cc->migratepages list.
> 
> Furthermore, any non-zero count is only interesting for the tracepoint of
> mm_compaction_migratepages events, because after that all remaining unmigrated
> pages are put back and their count is set to 0.
> 
> This patch therefore removes update_nr_listpages() completely, and changes the
> tracepoint definition so that the manual counting is done only when the
> tracepoint is enabled, and only when migrate_pages() returns a negative error
> code.
> 
> Furthermore, migrate_pages() and the tracepoints won't be called when there's
> nothing to migrate. This potentially avoids some wasted cycles and reduces the
> volume of uninteresting mm_compaction_migratepages events where "nr_migrated=0
> nr_failed=0". In the stress-highalloc mmtest, this was about 75% of the events.
> The mm_compaction_isolate_migratepages event is better for determining that
> nothing was isolated for migration, and this one was just duplicating the info.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

I like this, before our two patches update_nr_listpages() was expensive 
when called for each pageblock and being able to remove it is certainly a 
step in the right direction to make compaction as fast as possible.
