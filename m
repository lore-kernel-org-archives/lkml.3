Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3C1Gae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:30:34 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:49958 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3C1Gac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:30:32 -0400
Date: Wed, 27 Mar 2013 23:30:28 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2] workqueue: fix unbound workqueue attrs hashing /
 comparison
Message-ID: <20130328063028.GB14088@htj.dyndns.org>
References: <20130328062947.GA14088@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328062947.GA14088@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b37c3e3a74346749f0278c349dc0857107cb4370 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 27 Mar 2013 23:27:41 -0700

29c91e9912b ("workqueue: implement attribute-based unbound worker_pool
management") implemented attrs based worker_pool matching.  It tried
to avoid false negative when comparing cpumasks with custom hash
function; unfortunately, the hash and comparison functions fail to
ignore CPUs which are not possible.  It incorrectly assumed that
bitmap_copy() skips leftover bits in the last word of bitmap and
cpumask_equal() ignores impossible CPUs.

This patch updates attrs->cpumask handling such that impossible CPUs
are properly ignored.

* Hash and copy functions no longer do anything special.  They expect
  their callers to clear impossible CPUs.

* alloc_workqueue_attrs() initializes the cpumask to cpu_possible_mask
  instead of setting all bits and explicit cpumask_setall() for
  unbound_std_wq_attrs[] in init_workqueues() is dropped.

* apply_workqueue_attrs() is now responsible for ignoring impossible
  CPUs.  It makes a copy of @attrs and clears impossible CPUs before
  doing anything else.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 54 ++++++++++++++++++++++--------------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4d34432..abe1f0d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3302,7 +3302,7 @@ struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
 	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
 		goto fail;
 
-	cpumask_setall(attrs->cpumask);
+	cpumask_copy(attrs->cpumask, cpu_possible_mask);
 	return attrs;
 fail:
 	free_workqueue_attrs(attrs);
@@ -3316,33 +3316,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 	cpumask_copy(to->cpumask, from->cpumask);
 }
 
-/*
- * Hacky implementation of jhash of bitmaps which only considers the
- * specified number of bits.  We probably want a proper implementation in
- * include/linux/jhash.h.
- */
-static u32 jhash_bitmap(const unsigned long *bitmap, int bits, u32 hash)
-{
-	int nr_longs = bits / BITS_PER_LONG;
-	int nr_leftover = bits % BITS_PER_LONG;
-	unsigned long leftover = 0;
-
-	if (nr_longs)
-		hash = jhash(bitmap, nr_longs * sizeof(long), hash);
-	if (nr_leftover) {
-		bitmap_copy(&leftover, bitmap + nr_longs, nr_leftover);
-		hash = jhash(&leftover, sizeof(long), hash);
-	}
-	return hash;
-}
-
 /* hash value of the content of @attr */
 static u32 wqattrs_hash(const struct workqueue_attrs *attrs)
 {
 	u32 hash = 0;
 
 	hash = jhash_1word(attrs->nice, hash);
-	hash = jhash_bitmap(cpumask_bits(attrs->cpumask), nr_cpu_ids, hash);
+	hash = jhash(cpumask_bits(attrs->cpumask),
+		     BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long), hash);
 	return hash;
 }
 
@@ -3652,7 +3633,8 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
 {
-	struct pool_workqueue *pwq, *last_pwq;
+	struct workqueue_attrs *new_attrs;
+	struct pool_workqueue *pwq = NULL, *last_pwq;
 	struct worker_pool *pool;
 
 	/* only unbound workqueues can change attributes */
@@ -3663,15 +3645,21 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
 		return -EINVAL;
 
+	/* make a copy of @attrs and sanitize it */
+	new_attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!new_attrs)
+		goto enomem;
+
+	copy_workqueue_attrs(new_attrs, attrs);
+	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, cpu_possible_mask);
+
 	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
 	if (!pwq)
-		return -ENOMEM;
+		goto enomem;
 
-	pool = get_unbound_pool(attrs);
-	if (!pool) {
-		kmem_cache_free(pwq_cache, pwq);
-		return -ENOMEM;
-	}
+	pool = get_unbound_pool(new_attrs);
+	if (!pool)
+		goto enomem;
 
 	init_and_link_pwq(pwq, wq, pool, &last_pwq);
 	if (last_pwq) {
@@ -3681,6 +3669,11 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	}
 
 	return 0;
+
+enomem:
+	kmem_cache_free(pwq_cache, pwq);
+	free_workqueue_attrs(new_attrs);
+	return -ENOMEM;
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
@@ -4450,10 +4443,7 @@ static int __init init_workqueues(void)
 		struct workqueue_attrs *attrs;
 
 		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
-
 		attrs->nice = std_nice[i];
-		cpumask_setall(attrs->cpumask);
-
 		unbound_std_wq_attrs[i] = attrs;
 	}
 
-- 
1.8.1.4

