Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966653Ab3HIKWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:22:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40725 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965879Ab3HIKWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:22:34 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-08-5204c2e8e1f6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH v2 0/4] mm: reclaim zbud pages on migration and compaction
Date: Fri, 09 Aug 2013 12:22:16 +0200
Message-id: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsVy+t/xa7ovDrEEGUzv1LGYs34Nm8XGGetZ
	LT69fMBo8fqFocXZpjfsFpd3zWGzuLfmP6vF2iN32S0mv3vGaHFo3yp2By6PxXteMnls+jSJ
	3ePEjN8sHg8ObWbx6NuyitFj8+lqj8+b5ALYo7hsUlJzMstSi/TtErgyOvvb2Qv2ClUs3P+S
	pYFxLV8XIyeHhICJRMfTfkYIW0ziwr31bCC2kMBSRom72wW6GLmA7D4mia2fZoEl2ASMJTYv
	XwJmiwj0MUpMumwBUsQs0MMk8f7NZLBJwgJ+En23W4Fsdg4WAVWJF7wgUV4Bd4meRfeAohxA
	uxQk5kyymcDIvYCRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSDh92cG4+JjVIUYBDkYl
	Ht4TW5iDhFgTy4orcw8xSnAwK4nwbp/AEiTEm5JYWZValB9fVJqTWnyIkYmDU6qB0d6v1CXs
	Ilf8m8+HNF/6LPbN26NddXj7zcwtjzns7lvZ3n7FwHN7wXNm8ac3bhp0Hjp8JWSDxbdPBfe3
	btjMkO/RvH3258iFcRO5zxZ9mimiOfva53PzHM5Yb7n67L5FZKRCNbvf73lra/afmL6eY9dT
	6c7K/8/ebZlrfCBxRWZP7P0m0W2KDpVKLMUZiYZazEXFiQAIGyVfBQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently zbud pages are not movable and they cannot be allocated from CMA
region. These patches try to address the problem by:
1. Adding a new form of reclaim of zbud pages.
2. Reclaiming zbud pages during migration and compaction.
3. Allocating zbud pages with __GFP_RECLAIMABLE flag.

This reclaim process is different than zbud_reclaim_page(). It acts more
like swapoff() by trying to unuse pages stored in zbud page and bring
them back to memory. The standard zbud_reclaim_page() on the other hand
tries to write them back.

One of patches introduces PageZbud() function which identifies zbud pages
my page->_mapcount. Dave Hansen proposed aliasing PG_zbud=PG_slab but in
such case patch would be more intrusive.

Any ideas for a better solution are welcome.

TODO-s:
1. Migrate zbud pages directly instead of reclaiming.

Changes since v1:
1. Rebased against v3.11-rc4-103-g6c2580c.
2. Remove rebalance_lists() to fix reinserting zbud page after zbud_free.
   This function was added because similar code was present in
   zbud_free/zbud_alloc/zbud_reclaim_page but it turns out that there
   is no benefit in generalizing this code.
   (suggested by Seth Jennings)
3. Remove BUG_ON checks for first/last chunks during free and reclaim.
   (suggested by Seth Jennings)
4. Use page->_mapcount==-127 instead of new PG_zbud flag.
   (suggested by Dave Hansen)
5. Fix invalid dereference of pointer to compact_control in page_alloc.c.
6. Fix lost return value in try_to_unuse() in swapfile.c (this fixes
   hang when swapoff was interrupted e.g. by CTRL+C).


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (4):
  zbud: use page ref counter for zbud pages
  mm: split code for unusing swap entries from try_to_unuse
  mm: use mapcount for identifying zbud pages
  mm: reclaim zbud pages on migration and compaction

 include/linux/mm.h       |   23 +++
 include/linux/swapfile.h |    2 +
 include/linux/zbud.h     |   11 +-
 mm/compaction.c          |   20 ++-
 mm/internal.h            |    1 +
 mm/page_alloc.c          |    6 +
 mm/swapfile.c            |  356 ++++++++++++++++++++++++----------------------
 mm/zbud.c                |  247 +++++++++++++++++++++++---------
 mm/zswap.c               |   57 +++++++-
 9 files changed, 476 insertions(+), 247 deletions(-)

-- 
1.7.9.5

