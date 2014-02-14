Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaBNBCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbaBNBCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:02:45 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mtosatti@redhat.com, mgorman@suse.de, aarcange@redhat.com,
        andi@firstfloor.org, riel@redhat.com, davidlohr@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        rientjes@google.com
Subject: [PATCH 1/4] memblock: memblock_virt_alloc_internal(): add __GFP_THISNODE flag support
Date: Thu, 13 Feb 2014 20:02:05 -0500
Message-Id: <1392339728-13487-2-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

Currently, if an allocation from the node specified by the nid argument
fails, memblock_virt_alloc_internal() automatically tries to allocate memory
from other nodes.

This is fine if the caller don't care about which node is going to allocate
the memory. However, there are cases where the caller wants memory to be
allocated from the specified node only. If that's not possible, then
memblock_virt_alloc_internal() should just fail.

This commit adds a new flags argument to memblock_virt_alloc_internal()
where the caller can control this behavior. The flags argument is of type
gfp_t, so that we can (re-)use the __GFP_THISNODE definition.

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 mm/memblock.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 39a31e7..f3821ef 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1035,12 +1035,18 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
  * @min_addr: the lower bound of the memory region to allocate (phys address)
  * @max_addr: the upper bound of the memory region to allocate (phys address)
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ * @flags: control how memory is allocated
  *
  * The @min_addr limit is dropped if it can not be satisfied and the allocation
  * will fall back to memory below @min_addr. Also, allocation may fall back
  * to any node in the system if the specified node can not
  * hold the requested memory.
  *
+ * The @flags argument is one of:
+ *
+ * %__GFP_THISNODE: memory is allocated from the node specified by @nid only.
+ * 	If that fails, an error is returned
+ *
  * The allocation is performed from memory region limited by
  * memblock.current_limit if @max_addr == %BOOTMEM_ALLOC_ACCESSIBLE.
  *
@@ -1058,7 +1064,7 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 static void * __init memblock_virt_alloc_internal(
 				phys_addr_t size, phys_addr_t align,
 				phys_addr_t min_addr, phys_addr_t max_addr,
-				int nid)
+				int nid, gfp_t flags)
 {
 	phys_addr_t alloc;
 	void *ptr;
@@ -1085,6 +1091,8 @@ again:
 					    nid);
 	if (alloc)
 		goto done;
+	if (flags & __GFP_THISNODE)
+		goto error;
 
 	if (nid != NUMA_NO_NODE) {
 		alloc = memblock_find_in_range_node(size, align, min_addr,
@@ -1145,7 +1153,7 @@ void * __init memblock_virt_alloc_try_nid_nopanic(
 		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
 		     (u64)max_addr, (void *)_RET_IP_);
 	return memblock_virt_alloc_internal(size, align, min_addr,
-					     max_addr, nid);
+					     max_addr, nid, 0);
 }
 
 /**
@@ -1177,7 +1185,7 @@ void * __init memblock_virt_alloc_try_nid(
 		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
 		     (u64)max_addr, (void *)_RET_IP_);
 	ptr = memblock_virt_alloc_internal(size, align,
-					   min_addr, max_addr, nid);
+					   min_addr, max_addr, nid, 0);
 	if (ptr)
 		return ptr;
 
-- 
1.8.1.4

