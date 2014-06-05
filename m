Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaFEAJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:09:05 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50120 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaFEAJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:09:02 -0400
Date: Wed, 4 Jun 2014 17:08:59 -0700 (PDT)
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
Subject: Re: [RFC PATCH 6/6] mm, compaction: don't migrate in blocks that
 cannot be fully compacted in async direct compaction
In-Reply-To: <1401898310-14525-6-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1406041705140.22536@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-6-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Vlastimil Babka wrote:

> In direct compaction, we want to allocate the high-order page as soon as
> possible, so migrating from a block of pages that contains also unmigratable
> pages just adds to allocation latency.
> 

The title of the patch in the subject line should probably be reworded 
since it implies we never isolate from blocks that cannot become 
completely free and what you're really doing is skipping cc->order aligned 
pages.

> This patch therefore makes the migration scanner skip to the next cc->order
> aligned block of pages as soon as it cannot isolate a non-free page. Everything
> isolated up to that point is put back.
> 
> In this mode, the nr_isolated limit to COMPACT_CLUSTER_MAX is not observed,
> allowing the scanner to scan the whole block at once, instead of migrating
> COMPACT_CLUSTER_MAX pages and then finding an unmigratable page in the next
> call. This might however have some implications on too_many_isolated.
> 
> Also in this RFC PATCH, the "skipping mode" is tied to async migration mode,
> which is not optimal. What we most probably want is skipping in direct
> compactions, but not from kswapd and hugepaged.
> 
> In very preliminary tests, this has reduced migrate_scanned, isolations and
> migrations by about 10%, while the success rate of stress-highalloc mmtests
> actually improved a bit.
> 

Ok, so this obsoletes my patchseries that did something similar.  I hope 
you can rebase this set on top of linux-next and then propose it formally 
without the RFC tag.

We also need to discuss the scheduling heuristics, the reliance on 
need_resched(), to abort async compaction.  In testing, we actualy 
sometimes see 2-3 pageblocks scanned before terminating and thp has a very 
little chance of being allocated.  At the same time, if we try to fault 
64MB of anon memory in and each of the 32 calls to compaction are 
expensive but don't result in an order-9 page, we see very lengthy fault 
latency.

I think it would be interesting to consider doing async compaction 
deferral up to 1 << COMPACT_MAX_DEFER_SHIFT after a sysctl-configurable 
amount of memory is scanned, at least for thp, and remove the scheduling 
heuristic entirely.
