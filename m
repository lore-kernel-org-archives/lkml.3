Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaBJR2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:28:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaBJR2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:28:08 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mtosatti@redhat.com, mgorman@suse.de, aarcange@redhat.com,
        andi@firstfloor.org, riel@redhat.com
Subject: [PATCH 1/4] memblock: memblock_virt_alloc_internal(): alloc from specified node only
Date: Mon, 10 Feb 2014 12:27:45 -0500
Message-Id: <1392053268-29239-2-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

If an allocation from the node specified by the nid argument fails,
memblock_virt_alloc_internal() automatically tries to allocate memory
from other nodes.

This is fine is the caller don't care which node is going to allocate
the memory. However, there are cases where the caller wants memory to
be allocated from the specified node only. If that's not possible, then
memblock_virt_alloc_internal() should just fail.

This commit adds a new flags argument to memblock_virt_alloc_internal()
where the caller can control this behavior.

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 mm/memblock.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 39a31e7..b0c7b2e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1028,6 +1028,8 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
+#define ALLOC_SPECIFIED_NODE_ONLY 0x1
+
 /**
  * memblock_virt_alloc_internal - allocate boot memory block
  * @size: size of memory block to be allocated in bytes
@@ -1058,7 +1060,7 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 static void * __init memblock_virt_alloc_internal(
 				phys_addr_t size, phys_addr_t align,
 				phys_addr_t min_addr, phys_addr_t max_addr,
-				int nid)
+				int nid, unsigned int flags)
 {
 	phys_addr_t alloc;
 	void *ptr;
@@ -1085,6 +1087,8 @@ again:
 					    nid);
 	if (alloc)
 		goto done;
+	else if (flags & ALLOC_SPECIFIED_NODE_ONLY)
+		goto error;
 
 	if (nid != NUMA_NO_NODE) {
 		alloc = memblock_find_in_range_node(size, align, min_addr,
@@ -1145,7 +1149,7 @@ void * __init memblock_virt_alloc_try_nid_nopanic(
 		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
 		     (u64)max_addr, (void *)_RET_IP_);
 	return memblock_virt_alloc_internal(size, align, min_addr,
-					     max_addr, nid);
+					     max_addr, nid, 0);
 }
 
 /**
@@ -1177,7 +1181,7 @@ void * __init memblock_virt_alloc_try_nid(
 		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
 		     (u64)max_addr, (void *)_RET_IP_);
 	ptr = memblock_virt_alloc_internal(size, align,
-					   min_addr, max_addr, nid);
+					   min_addr, max_addr, nid, 0);
 	if (ptr)
 		return ptr;
 
-- 
1.8.1.4

