Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaKCVAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:00:25 -0500
Received: from mx2.parallels.com ([199.115.105.18]:39173 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaKCVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:00:19 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 6/8] memcg: introduce memcg_kmem_should_charge helper
Date: Mon, 3 Nov 2014 23:59:44 +0300
Message-ID: <c8744df31379821d269c8e654843471545815c01.1415046910.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1415046910.git.vdavydov@parallels.com>
References: <cover.1415046910.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the same set of checks in both memcg_kmem_newpage_charge and
memcg_kmem_get_cache, and I need it in yet another function, which will
be introduced by one of the following patches. So let's introduce a
helper function for it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/memcontrol.h |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 617652712da8..224c045fd37f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -416,6 +416,26 @@ void memcg_update_array_size(int num_groups);
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
+static __always_inline bool memcg_kmem_should_charge(gfp_t gfp)
+{
+	/*
+	 * __GFP_NOFAIL allocations will move on even if charging is not
+	 * possible. Therefore we don't even try, and have this allocation
+	 * unaccounted. We could in theory charge it forcibly, but we hope
+	 * those allocations are rare, and won't be worth the trouble.
+	 */
+	if (gfp & __GFP_NOFAIL)
+		return false;
+	if (in_interrupt())
+		return false;
+	if (!current->mm || (current->flags & PF_KTHREAD))
+		return false;
+	/* If the test is dying, just let it go. */
+	if (unlikely(fatal_signal_pending(current)))
+		return false;
+	return true;
+}
+
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
@@ -433,22 +453,8 @@ memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
 {
 	if (!memcg_kmem_enabled())
 		return true;
-
-	/*
-	 * __GFP_NOFAIL allocations will move on even if charging is not
-	 * possible. Therefore we don't even try, and have this allocation
-	 * unaccounted. We could in theory charge it forcibly, but we hope
-	 * those allocations are rare, and won't be worth the trouble.
-	 */
-	if (gfp & __GFP_NOFAIL)
-		return true;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
-		return true;
-
-	/* If the test is dying, just let it go. */
-	if (unlikely(fatal_signal_pending(current)))
+	if (!memcg_kmem_should_charge(gfp))
 		return true;
-
 	return __memcg_kmem_newpage_charge(gfp, memcg, order);
 }
 
@@ -491,13 +497,8 @@ memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	if (!memcg_kmem_enabled())
 		return cachep;
-	if (gfp & __GFP_NOFAIL)
-		return cachep;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
-		return cachep;
-	if (unlikely(fatal_signal_pending(current)))
+	if (!memcg_kmem_should_charge(gfp))
 		return cachep;
-
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
 #else
-- 
1.7.10.4

