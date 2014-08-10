Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaHJRsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 13:48:31 -0400
Received: from mx2.parallels.com ([199.115.105.18]:42773 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHJRsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 13:48:30 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH -mm] slab: fix cpuset check in fallback_alloc
Date: Sun, 10 Aug 2014 21:48:11 +0400
Message-ID: <1407692891-24312-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fallback_alloc is called on kmalloc if the preferred node doesn't have
free or partial slabs and there's no pages on the node's free list
(GFP_THISNODE allocations fail). Before invoking the reclaimer it tries
to locate a free or partial slab on other allowed nodes' lists. While
iterating over the preferred node's zonelist it skips those zones which
cpuset_zone_allowed_hardwall returns false for. That means that for a
task bound to a specific node using cpusets fallback_alloc will always
ignore free slabs on other nodes and go directly to the reclaimer,
which, however, may allocate from other nodes if cpuset.mem_hardwall is
unset (default). As a result, we may get lists of free slabs grow
without bounds on other nodes, which is bad, because inactive slabs are
only evicted by cache_reap at a very slow rate and cannot be dropped
forcefully.

To reproduce the issue, run a process that will walk over a directory
tree with lots of files inside a cpuset bound to a node that constantly
experiences memory pressure. Look at num_slabs vs active_slabs growth as
reported by /proc/slabinfo.

We should use cpuset_zone_allowed_softwall in fallback_alloc. Since it
can sleep, we only call it on __GFP_WAIT allocations. For atomic
allocations we simply ignore cpusets, which is in agreement with the
cpuset documenation (see the comment to __cpuset_node_allowed_softwall).

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 2e60bf3dedbb..1d77a4df7ee1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3049,14 +3049,23 @@ retry:
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		nid = zone_to_nid(zone);
 
-		if (cpuset_zone_allowed_hardwall(zone, flags) &&
-			get_node(cache, nid) &&
-			get_node(cache, nid)->free_objects) {
-				obj = ____cache_alloc_node(cache,
-					flags | GFP_THISNODE, nid);
-				if (obj)
-					break;
+		if (!get_node(cache, nid) ||
+		    !get_node(cache, nid)->free_objects)
+			continue;
+
+		if (local_flags & __GFP_WAIT) {
+			bool allowed;
+
+			local_irq_enable();
+			allowed = cpuset_zone_allowed_softwall(zone, flags);
+			local_irq_disable();
+			if (!allowed)
+				continue;
 		}
+
+		obj = ____cache_alloc_node(cache, flags | GFP_THISNODE, nid);
+		if (obj)
+			break;
 	}
 
 	if (!obj) {
-- 
1.7.10.4

