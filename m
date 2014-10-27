Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaJ0HeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:34:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:37570 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJ0HeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:34:09 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 27 Oct 2014 16:35:22 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] mm, compaction: always update cached scanner
 positions
Message-ID: <20141027073522.GB23379@js1304-P5Q-DELUXE>
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz>
 <1412696019-21761-5-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412696019-21761-5-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:33:38PM +0200, Vlastimil Babka wrote:
> Compaction caches the migration and free scanner positions between compaction
> invocations, so that the whole zone gets eventually scanned and there is no
> bias towards the initial scanner positions at the beginning/end of the zone.
> 
> The cached positions are continuously updated as scanners progress and the
> updating stops as soon as a page is successfully isolated. The reasoning
> behind this is that a pageblock where isolation succeeded is likely to succeed
> again in near future and it should be worth revisiting it.
> 
> However, the downside is that potentially many pages are rescanned without
> successful isolation. At worst, there might be a page where isolation from LRU
> succeeds but migration fails (potentially always). So upon encountering this
> page, cached position would always stop being updated for no good reason.
> It might have been useful to let such page be rescanned with sync compaction
> after async one failed, but this is now handled by caching scanner position
> for async and sync mode separately since commit 35979ef33931 ("mm, compaction:
> add per-zone migration pfn cache for async compaction").

Hmm... I'm not sure that this patch is good thing.

In asynchronous compaction, compaction could be easily failed and
isolated freepages are returned to the buddy. In this case, next
asynchronous compaction would skip those returned freepages and
both scanners could meet prematurely.

And, I guess that pageblock skip feature effectively disable pageblock
rescanning if there is no freepage during rescan. This patch would
eliminate effect of pageblock skip feature.

IIUC, compaction logic assume that there are many temporary failure
conditions. Retrying from others would reduce effect of this temporary
failure so implementation looks as is.

If what we want is scanning each page once in each epoch, we can
implement compaction logic differently.

Please let me know if I'm missing something.

Thanks.

