Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaJTLu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:50:59 -0400
Received: from mx2.parallels.com ([199.115.105.18]:37040 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaJTLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:50:53 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zefan Li <lizefan@huawei.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH RESEND 3/4] slab: fix cpuset check in fallback_alloc
Date: Mon, 20 Oct 2014 15:50:31 +0400
Message-ID: <8056c9162584fe15df5ad8d5c09db9871d0dc9f8.1413804554.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1413804554.git.vdavydov@parallels.com>
References: <cover.1413804554.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fallback_alloc is called on kmalloc if the preferred node doesn't have
free or partial slabs and there's no pages on the node's free list
(GFP_THISNODE allocations fail). Before invoking the reclaimer it tries
to locate a free or partial slab on other allowed nodes' lists. While
iterating over the preferred node's zonelist it skips those zones which
hardwall cpuset check returns false for. That means that for a task
bound to a specific node using cpusets fallback_alloc will always ignore
free slabs on other nodes and go directly to the reclaimer, which,
however, may allocate from other nodes if cpuset.mem_hardwall is unset
(default). As a result, we may get lists of free slabs grow without
bounds on other nodes, which is bad, because inactive slabs are only
evicted by cache_reap at a very slow rate and cannot be dropped
forcefully.

To reproduce the issue, run a process that will walk over a directory
tree with lots of files inside a cpuset bound to a node that constantly
experiences memory pressure. Look at num_slabs vs active_slabs growth as
reported by /proc/slabinfo.

To avoid this we should use softwall cpuset check in fallback_alloc.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Zefan Li <lizefan@huawei.com>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 063a91bc8826..c44c17478551 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3012,7 +3012,7 @@ retry:
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		nid = zone_to_nid(zone);
 
-		if (cpuset_zone_allowed(zone, flags | __GFP_HARDWALL) &&
+		if (cpuset_zone_allowed(zone, flags) &&
 			get_node(cache, nid) &&
 			get_node(cache, nid)->free_objects) {
 				obj = ____cache_alloc_node(cache,
-- 
1.7.10.4

