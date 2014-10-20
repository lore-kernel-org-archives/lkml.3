Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaJTPom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJTPol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:44:41 -0400
Message-ID: <54452DD2.8090205@redhat.com>
Date: Mon, 20 Oct 2014 11:44:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/5] mm, compaction: more focused lru and pcplists draining
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-6-git-send-email-vbabka@suse.cz>
In-Reply-To: <1412696019-21761-6-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 11:33 AM, Vlastimil Babka wrote:
> The goal of memory compaction is to create high-order freepages through page
> migration. Page migration however puts pages on the per-cpu lru_add cache,
> which is later flushed to per-cpu pcplists, and only after pcplists are
> drained the pages can actually merge. This can happen due to the per-cpu
> caches becoming full through further freeing, or explicitly.
>
> During direct compaction, it is useful to do the draining explicitly so that
> pages merge as soon as possible and compaction can detect success immediately
> and keep the latency impact at minimum. However the current implementation is
> far from ideal. Draining is done only in  __alloc_pages_direct_compact(),
> after all zones were already compacted, and the decisions to continue or stop
> compaction in individual zones was done without the last batch of migrations
> being merged. It is also missing the draining of lru_add cache before the
> pcplists.
>
> This patch moves the draining for direct compaction into compact_zone(). It
> adds the missing lru_cache draining and uses the newly introduced single zone
> pcplists draining to reduce overhead and avoid impact on unrelated zones.
> Draining is only performed when it can actually lead to merging of a page of
> desired order (passed by cc->order). This means it is only done when migration
> occurred in the previously scanned cc->order aligned block(s) and the
> migration scanner is now pointing to the next cc->order aligned block.


Acked-by: Rik van Riel <riel@redhat.com>

