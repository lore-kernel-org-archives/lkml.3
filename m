Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab3CLVWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:22:39 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:47816 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:22:37 -0400
Date: Tue, 12 Mar 2013 14:22:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
Subject: [PATCH] idr: idr_alloc() shouldn't trigger lowmem warning when
 preloaded
Message-ID: <20130312212233.GK25266@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-68-git-send-email-tj@kernel.org>
 <20130311192955.GA23892@redhat.com>
 <20130311202818.GN24522@htj.dyndns.org>
 <20130312151745.GB7436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312151745.GB7436@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_NOIO is often used for idr_alloc() inside preloaded section as the
allocation mask doesn't really matter.  If the idr tree needs to be
expanded, idr_alloc() first tries to allocate using the specified
allocation mask and if it fails falls back to the preloaded buffer.
This order prevent non-preloading idr_alloc() users from taking
advantage of preloading ones by using preload buffer without filling
it shifting the burden of allocation to the preload users.

Unfortunately, this allowed/expected-to-fail kmem_cache allocation
ends up generating spurious slab lowmem warning before succeeding the
request from the preload buffer.

This patch makes idr_layer_alloc() add __GFP_NOWARN to the first
kmem_cache attempt and try kmem_cache again w/o __GFP_NOWARN after
allocation from preload_buffer fails so that lowmem warning is
generated if not suppressed by the original @gfp_mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Teigland <teigland@redhat.com>
Tested-by: David Teigland <teigland@redhat.com>
---
Hello, Andrew.

I forgot about slab lowmem warning when swapping the positions of
kmem_cache alloc and preload buffer alloc and it's generating spurious
lowmem warnings.  Should probably be shipped to Linus soonish.

Thanks!

 lib/idr.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 00739aa..e410e5d 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -106,8 +106,14 @@ static struct idr_layer *idr_layer_alloc(gfp_t gfp_mask, struct idr *layer_idr)
 	if (layer_idr)
 		return get_from_free_list(layer_idr);
 
-	/* try to allocate directly from kmem_cache */
-	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
+	/*
+	 * Try to allocate directly from kmem_cache.  We want to try this
+	 * before preload buffer; otherwise, non-preloading idr_alloc()
+	 * users will end up taking advantage of preloading ones.  As the
+	 * following is allowed to fail for preloaded cases, suppress
+	 * warning this time.
+	 */
+	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask | __GFP_NOWARN);
 	if (new)
 		return new;
 
@@ -115,18 +121,24 @@ static struct idr_layer *idr_layer_alloc(gfp_t gfp_mask, struct idr *layer_idr)
 	 * Try to fetch one from the per-cpu preload buffer if in process
 	 * context.  See idr_preload() for details.
 	 */
-	if (in_interrupt())
-		return NULL;
-
-	preempt_disable();
-	new = __this_cpu_read(idr_preload_head);
-	if (new) {
-		__this_cpu_write(idr_preload_head, new->ary[0]);
-		__this_cpu_dec(idr_preload_cnt);
-		new->ary[0] = NULL;
+	if (!in_interrupt()) {
+		preempt_disable();
+		new = __this_cpu_read(idr_preload_head);
+		if (new) {
+			__this_cpu_write(idr_preload_head, new->ary[0]);
+			__this_cpu_dec(idr_preload_cnt);
+			new->ary[0] = NULL;
+		}
+		preempt_enable();
+		if (new)
+			return new;
 	}
-	preempt_enable();
-	return new;
+
+	/*
+	 * Both failed.  Try kmem_cache again w/o adding __GFP_NOWARN so
+	 * that memory allocation failure warning is printed as intended.
+	 */
+	return kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 }
 
 static void idr_layer_rcu_free(struct rcu_head *head)
