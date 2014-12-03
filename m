Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbaLCBPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:15:21 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35792 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCBPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:15:19 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 3 Dec 2014 10:18:47 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v3 1/8] mm/page_ext: resurrect struct page extending code
 for debugging
Message-ID: <20141203011846.GB10084@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-2-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416816926-7756-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 05:15:19PM +0900, Joonsoo Kim wrote:
> When we debug something, we'd like to insert some information to
> every page. For this purpose, we sometimes modify struct page itself.
> But, this has drawbacks. First, it requires re-compile. This makes us
> hesitate to use the powerful debug feature so development process is
> slowed down. And, second, sometimes it is impossible to rebuild the kernel
> due to third party module dependency. At third, system behaviour would be
> largely different after re-compile, because it changes size of struct
> page greatly and this structure is accessed by every part of kernel.
> Keeping this as it is would be better to reproduce errornous situation.
> 
> This feature is intended to overcome above mentioned problems. This feature
> allocates memory for extended data per page in certain place rather than
> the struct page itself. This memory can be accessed by the accessor
> functions provided by this code. During the boot process, it checks whether
> allocation of huge chunk of memory is needed or not. If not, it avoids
> allocating memory at all. With this advantage, we can include this feature
> into the kernel in default and can avoid rebuild and solve related problems.
> 
> Until now, memcg uses this technique. But, now, memcg decides to embed
> their variable to struct page itself and it's code to extend struct page
> has been removed. I'd like to use this code to develop debug feature,
> so this patch resurrect it.
> 
> To help these things to work well, this patch introduces two callbacks
> for clients. One is the need callback which is mandatory if user wants
> to avoid useless memory allocation at boot-time. The other is optional,
> init callback, which is used to do proper initialization after memory
> is allocated. Detailed explanation about purpose of these functions is
> in code comment. Please refer it.
> 
> Others are completely same with previous extension code in memcg.
> 
> v3:
>  minor fix for readable code
> 
> v2:
>  describe overall design at the top of the page extension code.
>  add more description on commit message.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Hello, Andrew.

Could you fold following fix into the merged patch?
It fixes the problem on !CONFIG_SPARSEMEM which is reported by
0day kernel testing robot.

https://lkml.org/lkml/2014/11/28/123

Thanks.


------->8----------
>From 8436eaa754208d08f065e6317c7a16c7dfe1a766 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Wed, 3 Dec 2014 09:48:16 +0900
Subject: [PATCH] mm/page_ext: reserve more space in case of unaligned node
 range

When page allocator's buddy algorithm checks buddy's status,
checked page could be in invalid range. In this case, lookup_page_ext()
will return invalid address and it results in invalid address
defereference problem. For example, if node_start_pfn is 1 and page
with pfn 1 is freed to page allocator, page_is_buddy() would check
the page with pfn 0. In page_ext code, offset would be calculated
by pfn - node_start_pfn, so, 0 - 1 = -1. This causes following problem
reported by Fengguang.

[    0.480155] BUG: unable to handle kernel
[    0.480155] BUG: unable to handle kernel paging requestpaging request at d26bdffc
 at d26bdffc
[    0.481566] IP:
[    0.481566] IP: [<c110bc7a>] free_one_page+0x31a/0x3e0
 [<c110bc7a>] free_one_page+0x31a/0x3e0
[    0.482801] *pdpt = 0000000001866001
[    0.482801] *pdpt = 0000000001866001 *pde = 0000000012584067 *pde = 0000000012584067 *pte = 80000000126bd060 *pte = 80000000126bd060
[    0.483333] Oops: 0000 [#1]
[    0.483333] Oops: 0000 [#1] SMP SMP DEBUG_PAGEALLOCDEBUG_PAGEALLOC
snip...
[    0.483333] Call Trace:
[    0.483333] Call Trace:
[    0.483333]  [<c110bdec>] __free_pages_ok+0xac/0xf0
[    0.483333]  [<c110bdec>] __free_pages_ok+0xac/0xf0
[    0.483333]  [<c110c769>] __free_pages+0x19/0x30
[    0.483333]  [<c110c769>] __free_pages+0x19/0x30
[    0.483333]  [<c1144ca5>] kfree+0x75/0xf0
[    0.483333]  [<c1144ca5>] kfree+0x75/0xf0
[    0.483333]  [<c111b595>] ? kvfree+0x45/0x50
[    0.483333]  [<c111b595>] ? kvfree+0x45/0x50
[    0.483333]  [<c111b595>] kvfree+0x45/0x50
[    0.483333]  [<c111b595>] kvfree+0x45/0x50
[    0.483333]  [<c134bb73>] rhashtable_expand+0x1b3/0x1e0
[    0.483333]  [<c134bb73>] rhashtable_expand+0x1b3/0x1e0
[    0.483333]  [<c17fc9f9>] test_rht_init+0x173/0x2e8
[    0.483333]  [<c17fc9f9>] test_rht_init+0x173/0x2e8
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b750>] ? jhash2+0xe0/0xe0
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b790>] ? rhashtable_hashfn+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7b0>] ? rht_grow_above_75+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c134b7d0>] ? rht_shrink_below_30+0x20/0x20
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c1000486>] do_one_initcall+0xc6/0x210
[    0.483333]  [<c1000486>] do_one_initcall+0xc6/0x210
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c17fc886>] ? test_rht_lookup+0x8f/0x8f
[    0.483333]  [<c17d0505>] ? repair_env_string+0x12/0x54
[    0.483333]  [<c17d0505>] ? repair_env_string+0x12/0x54
[    0.483333]  [<c17d0cf3>] kernel_init_freeable+0x193/0x213
[    0.483333]  [<c17d0cf3>] kernel_init_freeable+0x193/0x213
[    0.483333]  [<c1512500>] kernel_init+0x10/0xf0
[    0.483333]  [<c1512500>] kernel_init+0x10/0xf0
[    0.483333]  [<c151c5c1>] ret_from_kernel_thread+0x21/0x30
[    0.483333]  [<c151c5c1>] ret_from_kernel_thread+0x21/0x30
[    0.483333]  [<c15124f0>] ? rest_init+0xb0/0xb0
[    0.483333]  [<c15124f0>] ? rest_init+0xb0/0xb0
snip...
[    0.483333] EIP: [<c110bc7a>]
[    0.483333] EIP: [<c110bc7a>] free_one_page+0x31a/0x3e0free_one_page+0x31a/0x3e0 SS:ESP 0068:c0041de0
 SS:ESP 0068:c0041de0
[    0.483333] CR2: 00000000d26bdffc
[    0.483333] CR2: 00000000d26bdffc
[    0.483333] ---[ end trace 7648e12f817ef2ad ]---
[    0.483333] ---[ end trace 7648e12f817ef2ad ]---

This case is already handled in case of struct page by considering
alignment of node_start_pfn. So, this patch follows that way to fix this
situation.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/page_ext.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_ext.c b/mm/page_ext.c
index ce86485..184f3ef 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -112,7 +112,8 @@ struct page_ext *lookup_page_ext(struct page *page)
 	if (unlikely(!base))
 		return NULL;
 #endif
-	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
+	offset = pfn - round_down(node_start_pfn(page_to_nid(page)),
+					MAX_ORDER_NR_PAGES);
 	return base + offset;
 }
 
@@ -126,6 +127,15 @@ static int __init alloc_node_page_ext(int nid)
 	if (!nr_pages)
 		return 0;
 
+	/*
+	 * Need extra space if node range is not aligned with
+	 * MAX_ORDER_NR_PAGES. When page allocator's buddy algorithm
+	 * checks buddy's status, range could be out of exact node range.
+	 */
+	if (!IS_ALIGNED(node_start_pfn(nid), MAX_ORDER_NR_PAGES) ||
+		!IS_ALIGNED(node_end_pfn(nid), MAX_ORDER_NR_PAGES))
+		nr_pages += MAX_ORDER_NR_PAGES;
+
 	table_size = sizeof(struct page_ext) * nr_pages;
 
 	base = memblock_virt_alloc_try_nid_nopanic(
-- 
1.7.9.5

