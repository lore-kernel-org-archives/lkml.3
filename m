Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3AXDgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:36:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3AXDbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Prasad Koya <prasad.koya@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 55/74] mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
Date: Thu, 24 Jan 2013 01:27:07 -0200
Message-Id: <1358998046-613-56-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 10d73e655cef6e86ea8589dca3df4e495e4900b0 upstream.

Currently free_all_bootmem_core ignores that node_min_pfn may be not
multiple of BITS_PER_LONG.  Eg commit 6dccdcbe2c3e ("mm: bootmem: fix
checking the bitmap when finally freeing bootmem") shifts vec by lower
bits of start instead of lower bits of idx.  Also

  if (IS_ALIGNED(start, BITS_PER_LONG) && vec == ~0UL)

assumes that vec bit 0 corresponds to start pfn, which is only true when
node_min_pfn is a multiple of BITS_PER_LONG.  Also loop in the else
clause can double-free pages (e.g.  with node_min_pfn == start == 1,
map[0] == ~0 on 32-bit machine page 32 will be double-freed).

This bug causes the following message during xtensa kernel boot:

  bootmem::free_all_bootmem_core nid=0 start=1 end=8000
  BUG: Bad page state in process swapper  pfn:00001
  page:d04bd020 count:0 mapcount:-127 mapping:  (null) index:0x2
  page flags: 0x0()
  Call Trace:
    bad_page+0x8c/0x9c
    free_pages_prepare+0x5e/0x88
    free_hot_cold_page+0xc/0xa0
    __free_pages+0x24/0x38
    __free_pages_bootmem+0x54/0x56
    free_all_bootmem_core$part$11+0xeb/0x138
    free_all_bootmem+0x46/0x58
    mem_init+0x25/0xa4
    start_kernel+0x11e/0x25c
    should_never_return+0x0/0x3be7

The fix is the following:
 - always align vec so that its bit 0 corresponds to start
 - provide BITS_PER_LONG bits in vec, if those bits are available in the
   map
 - don't free pages past next start position in the else clause.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Prasad Koya <prasad.koya@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/bootmem.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index bcb63ac..ceca0da 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -185,10 +185,23 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 
 	while (start < end) {
 		unsigned long *map, idx, vec;
+		unsigned shift;
 
 		map = bdata->node_bootmem_map;
 		idx = start - bdata->node_min_pfn;
+		shift = idx & (BITS_PER_LONG - 1);
+		/*
+		 * vec holds at most BITS_PER_LONG map bits,
+		 * bit 0 corresponds to start.
+		 */
 		vec = ~map[idx / BITS_PER_LONG];
+
+		if (shift) {
+			vec >>= shift;
+			if (end - start >= BITS_PER_LONG)
+				vec |= ~map[idx / BITS_PER_LONG + 1] <<
+					(BITS_PER_LONG - shift);
+		}
 		/*
 		 * If we have a properly aligned and fully unreserved
 		 * BITS_PER_LONG block of pages in front of us, free
@@ -201,19 +214,18 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
-			unsigned long off = 0;
+			unsigned long cur = start;
 
-			vec >>= start & (BITS_PER_LONG - 1);
-			while (vec) {
+			start = ALIGN(start + 1, BITS_PER_LONG);
+			while (vec && cur != start) {
 				if (vec & 1) {
-					page = pfn_to_page(start + off);
+					page = pfn_to_page(cur);
 					__free_pages_bootmem(page, 0);
 					count++;
 				}
 				vec >>= 1;
-				off++;
+				++cur;
 			}
-			start = ALIGN(start + 1, BITS_PER_LONG);
 		}
 	}
 
-- 
1.7.9.5

