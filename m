Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaFLUl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:41:57 -0400
Received: from mx2.parallels.com ([199.115.105.18]:55999 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaFLUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:41:54 -0400
Date: Fri, 13 Jun 2014 00:41:43 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <iamjoonsoo.kim@lge.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
Message-ID: <20140612204141.GA25829@esperanza>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:38:22AM +0400, Vladimir Davydov wrote:
> Since a dead memcg cache is destroyed only after the last slab allocated
> to it is freed, we must disable caching of free objects/slabs for such
> caches, otherwise they will be hanging around forever.
> 
> For SLAB that means we must disable per cpu free object arrays and make
> free_block always discard empty slabs irrespective of node's free_limit.

An alternative to this could be making cache_reap, which drains per cpu
arrays and drops free slabs periodically for all caches, shrink dead
caches aggressively. The patch doing this is attached.

This approach has its pros and cons comparing to disabling per cpu
arrays.

Pros:
 - Less intrusive: it only requires modification of cache_reap.
 - Doesn't impact performance: free path isn't touched.

Cons:
 - Delays dead cache destruction: lag between the last object is freed
   and the cache is destroyed isn't constant. It depends on the number
   of kmem-active memcgs and the number of dead caches (the more of
   them, the longer it'll take to shrink dead caches). Also, on NUMA
   machines the upper bound will be proportional to the number of NUMA
   nodes, because alien caches are reaped one at a time (see
   reap_alien).
 - If there are a lot of dead caches, periodic shrinking will be slowed
   down even for active caches (see cache_reap).

--

diff --git a/mm/slab.c b/mm/slab.c
index 9ca3b87edabc..811fdb214b9e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3980,6 +3980,11 @@ static void cache_reap(struct work_struct *w)
 		goto out;
 
 	list_for_each_entry(searchp, &slab_caches, list) {
+		int force = 0;
+
+		if (memcg_cache_dead(searchp))
+			force = 1;
+
 		check_irq_on();
 
 		/*
@@ -3991,7 +3996,7 @@ static void cache_reap(struct work_struct *w)
 
 		reap_alien(searchp, n);
 
-		drain_array(searchp, n, cpu_cache_get(searchp), 0, node);
+		drain_array(searchp, n, cpu_cache_get(searchp), force, node);
 
 		/*
 		 * These are racy checks but it does not matter
@@ -4002,15 +4007,17 @@ static void cache_reap(struct work_struct *w)
 
 		n->next_reap = jiffies + REAPTIMEOUT_NODE;
 
-		drain_array(searchp, n, n->shared, 0, node);
+		drain_array(searchp, n, n->shared, force, node);
 
 		if (n->free_touched)
 			n->free_touched = 0;
 		else {
-			int freed;
+			int freed, tofree;
+
+			tofree = force ? slabs_tofree(searchp, n) :
+				DIV_ROUND_UP(n->free_limit, 5 * searchp->num);
 
-			freed = drain_freelist(searchp, n, (n->free_limit +
-				5 * searchp->num - 1) / (5 * searchp->num));
+			freed = drain_freelist(searchp, n, tofree);
 			STATS_ADD_REAPED(searchp, freed);
 		}
 next:
