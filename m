Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaFIXlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:41:40 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56084 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbaFIXlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:41:39 -0400
Date: Mon, 9 Jun 2014 16:41:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 01/10] mm, compaction: do not recheck suitable_migration_target
 under lock
In-Reply-To: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1406091636190.17705@chino.kir.corp.google.com>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Vlastimil Babka wrote:

> isolate_freepages_block() rechecks if the pageblock is suitable to be a target
> for migration after it has taken the zone->lock. However, the check has been
> optimized to occur only once per pageblock, and compact_checklock_irqsave()
> might be dropping and reacquiring lock, which means somebody else might have
> changed the pageblock's migratetype meanwhile.
> 
> Furthermore, nothing prevents the migratetype to change right after
> isolate_freepages_block() has finished isolating. Given how imperfect this is,
> it's simpler to just rely on the check done in isolate_freepages() without
> lock, and not pretend that the recheck under lock guarantees anything. It is
> just a heuristic after all.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

We already do a preliminary check for suitable_migration_target() in 
isolate_freepages() in a racy way to avoid unnecessary work (and 
page_order() there is unprotected, I think you already mentioned this) so 
this seems fine to abandon.

> ---
> I suggest folding mm-compactionc-isolate_freepages_block-small-tuneup.patch into this
> 

Hmm, Andrew was just moving some code around in that patch, I'm not sure 
that it makes sense to couple these two together and your patch here is 
addressing an optimization rather than a cleanup (and you've documented it 
well, no need to obscure it with unrelated changes).
