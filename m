Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaJTPpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:45:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaJTPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:45:35 -0400
Message-ID: <54452E0A.2050702@redhat.com>
Date: Mon, 20 Oct 2014 11:45:14 -0400
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
Subject: Re: [PATCH 1/5] mm, compaction: pass classzone_idx and alloc_flags
 to watermark checking
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-2-git-send-email-vbabka@suse.cz>
In-Reply-To: <1412696019-21761-2-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 11:33 AM, Vlastimil Babka wrote:
> Compaction relies on zone watermark checks for decisions such as if it's worth
> to start compacting in compaction_suitable() or whether compaction should stop
> in compact_finished(). The watermark checks take classzone_idx and alloc_flags
> parameters, which are related to the memory allocation request. But from the
> context of compaction they are currently passed as 0, including the direct
> compaction which is invoked to satisfy the allocation request, and could
> therefore know the proper values.
>
> The lack of proper values can lead to mismatch between decisions taken during
> compaction and decisions related to the allocation request. Lack of proper
> classzone_idx value means that lowmem_reserve is not taken into account.
> This has manifested (during recent changes to deferred compaction) when DMA
> zone was used as fallback for preferred Normal zone. compaction_suitable()
> without proper classzone_idx would think that the watermarks are already
> satisfied, but watermark check in get_page_from_freelist() would fail. Because
> of this problem, deferring compaction has extra complexity that can be removed
> in the following patch.
>
> The issue (not confirmed in practice) with missing alloc_flags is opposite in
> nature. For allocations that include ALLOC_HIGH, ALLOC_HIGHER or ALLOC_CMA in
> alloc_flags (the last includes all MOVABLE allocations on CMA-enabled systems)
> the watermark checking in compaction with 0 passed will be stricter than in
> get_page_from_freelist(). In these cases compaction might be running for a
> longer time than is really needed.
>
> This patch fixes these problems by adding alloc_flags and classzone_idx to
> struct compact_control and related functions involved in direct compaction and
> watermark checking. Where possible, all other callers of compaction_suitable()
> pass proper values where those are known. This is currently limited to
> classzone_idx, which is sometimes known in kswapd context. However, the direct
> reclaim callers should_continue_reclaim() and compaction_ready() do not
> currently know the proper values, so the coordination between reclaim and
> compaction may still not be as accurate as it could. This can be fixed later,
> if it's shown to be an issue.
>
> The effect of this patch should be slightly better high-order allocation
> success rates and/or less compaction overhead, depending on the type of
> allocations and presence of CMA. It allows simplifying deferred compaction
> code in a followup patch.
>
> When testing with stress-highalloc, there was some slight improvement (which
> might be just due to variance) in success rates of non-THP-like allocations.
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

Acked-by: Rik van Riel <riel@redhat.com>

