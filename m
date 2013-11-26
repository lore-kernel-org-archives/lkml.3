Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3KZLDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:03:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab3KZLDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:03:34 -0500
Date: Tue, 26 Nov 2013 11:03:30 +0000
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 5/5] mm: compaction: reset scanner positions immediately
 when they meet
Message-ID: <20131126110330.GJ5285@suse.de>
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz>
 <1385389570-11393-6-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1385389570-11393-6-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:26:10PM +0100, Vlastimil Babka wrote:
> Compaction used to start its migrate and free page scaners at the zone's lowest
> and highest pfn, respectively. Later, caching was introduced to remember the
> scanners' progress across compaction attempts so that pageblocks are not
> re-scanned uselessly. Additionally, pageblocks where isolation failed are
> marked to be quickly skipped when encountered again in future compactions.
> 
> Currently, both the reset of cached pfn's and clearing of the pageblock skip
> information for a zone is done in __reset_isolation_suitable(). This function
> gets called when:
>  - compaction is restarting after being deferred
>  - compact_blockskip_flush flag is set in compact_finished() when the scanners
>    meet (and not again cleared when direct compaction succeeds in allocation)
>    and kswapd acts upon this flag before going to sleep
> 
> This behavior is suboptimal for several reasons:
>  - when direct sync compaction is called after async compaction fails (in the
>    allocation slowpath), it will effectively do nothing, unless kswapd
>    happens to process the compact_blockskip_flush flag meanwhile. This is racy
>    and goes against the purpose of sync compaction to more thoroughly retry
>    the compaction of a zone where async compaction has failed.
>    The restart-after-deferring path cannot help here as deferring happens only
>    after the sync compaction fails. It is also done only for the preferred
>    zone, while the compaction might be done for a fallback zone.
>  - the mechanism of marking pageblock to be skipped has little value since the
>    cached pfn's are reset only together with the pageblock skip flags. This
>    effectively limits pageblock skip usage to parallel compactions.
> 
> This patch changes compact_finished() so that cached pfn's are reset
> immediately when the scanners meet. Clearing pageblock skip flags is unchanged,
> as well as the other situations where cached pfn's are reset. This allows the
> sync-after-async compaction to retry pageblocks not marked as skipped, such as
> blocks !MIGRATE_MOVABLE blocks that async compactions now skips without
> marking them.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
