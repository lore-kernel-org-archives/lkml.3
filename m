Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaLTOtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 09:49:12 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53809 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaLTOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 09:49:08 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: proportions.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 15:51:53 +0100
Message-Id: <1419087113-4087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
prop_change_shift() prop_descriptor_init() prop_fraction_percpu() prop_fraction_single() __prop_inc_percpu_max() prop_local_destroy_percpu() prop_local_destroy_single() prop_local_init_percpu() prop_local_init_single()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 include/linux/proportions.h |   14 ----
 lib/proportions.c           |  177 -------------------------------------------
 2 files changed, 191 deletions(-)

diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index 00e8e8f..494b1a6 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -41,9 +41,6 @@ struct prop_descriptor {
 	struct mutex mutex;		/* serialize the prop_global switch */
 };
 
-int prop_descriptor_init(struct prop_descriptor *pd, int shift, gfp_t gfp);
-void prop_change_shift(struct prop_descriptor *pd, int new_shift);
-
 /*
  * ----- PERCPU ------
  */
@@ -62,11 +59,7 @@ struct prop_local_percpu {
 	raw_spinlock_t lock;		/* protect the snapshot state */
 };
 
-int prop_local_init_percpu(struct prop_local_percpu *pl, gfp_t gfp);
-void prop_local_destroy_percpu(struct prop_local_percpu *pl);
 void __prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl);
-void prop_fraction_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl,
-		long *numerator, long *denominator);
 
 static inline
 void prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl)
@@ -91,9 +84,6 @@ void prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl)
 #define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
 #define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
 
-void __prop_inc_percpu_max(struct prop_descriptor *pd,
-			   struct prop_local_percpu *pl, long frac);
-
 
 /*
  * ----- SINGLE ------
@@ -118,11 +108,7 @@ struct prop_local_single {
 {	.lock = __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 }
 
-int prop_local_init_single(struct prop_local_single *pl);
-void prop_local_destroy_single(struct prop_local_single *pl);
 void __prop_inc_single(struct prop_descriptor *pd, struct prop_local_single *pl);
-void prop_fraction_single(struct prop_descriptor *pd, struct prop_local_single *pl,
-		long *numerator, long *denominator);
 
 static inline
 void prop_inc_single(struct prop_descriptor *pd, struct prop_local_single *pl)
diff --git a/lib/proportions.c b/lib/proportions.c
index 6f72429..b953cc2 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -73,75 +73,6 @@
 #include <linux/proportions.h>
 #include <linux/rcupdate.h>
 
-int prop_descriptor_init(struct prop_descriptor *pd, int shift, gfp_t gfp)
-{
-	int err;
-
-	if (shift > PROP_MAX_SHIFT)
-		shift = PROP_MAX_SHIFT;
-
-	pd->index = 0;
-	pd->pg[0].shift = shift;
-	mutex_init(&pd->mutex);
-	err = percpu_counter_init(&pd->pg[0].events, 0, gfp);
-	if (err)
-		goto out;
-
-	err = percpu_counter_init(&pd->pg[1].events, 0, gfp);
-	if (err)
-		percpu_counter_destroy(&pd->pg[0].events);
-
-out:
-	return err;
-}
-
-/*
- * We have two copies, and flip between them to make it seem like an atomic
- * update. The update is not really atomic wrt the events counter, but
- * it is internally consistent with the bit layout depending on shift.
- *
- * We copy the events count, move the bits around and flip the index.
- */
-void prop_change_shift(struct prop_descriptor *pd, int shift)
-{
-	int index;
-	int offset;
-	u64 events;
-	unsigned long flags;
-
-	if (shift > PROP_MAX_SHIFT)
-		shift = PROP_MAX_SHIFT;
-
-	mutex_lock(&pd->mutex);
-
-	index = pd->index ^ 1;
-	offset = pd->pg[pd->index].shift - shift;
-	if (!offset)
-		goto out;
-
-	pd->pg[index].shift = shift;
-
-	local_irq_save(flags);
-	events = percpu_counter_sum(&pd->pg[pd->index].events);
-	if (offset < 0)
-		events <<= -offset;
-	else
-		events >>= offset;
-	percpu_counter_set(&pd->pg[index].events, events);
-
-	/*
-	 * ensure the new pg is fully written before the switch
-	 */
-	smp_wmb();
-	pd->index = index;
-	local_irq_restore(flags);
-
-	synchronize_rcu();
-
-out:
-	mutex_unlock(&pd->mutex);
-}
-
 /*
  * wrap the access to the data in an rcu_read_lock() section;
  * this is used to track the active references.
@@ -188,19 +119,6 @@ prop_adjust_shift(int *pl_shift, unsigned long *pl_period, int new_shift)
 
 #define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
-int prop_local_init_percpu(struct prop_local_percpu *pl, gfp_t gfp)
-{
-	raw_spin_lock_init(&pl->lock);
-	pl->shift = 0;
-	pl->period = 0;
-	return percpu_counter_init(&pl->events, 0, gfp);
-}
-
-void prop_local_destroy_percpu(struct prop_local_percpu *pl)
-{
-	percpu_counter_destroy(&pl->events);
-}
-
 /*
  * Catch up with missed period expirations.
  *
@@ -264,78 +182,6 @@ void __prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl)
 }
 
 /*
- * identical to __prop_inc_percpu, except that it limits this pl's fraction to
- * @frac/PROP_FRAC_BASE by ignoring events when this limit has been exceeded.
- */
-void __prop_inc_percpu_max(struct prop_descriptor *pd,
-			   struct prop_local_percpu *pl, long frac)
-{
-	struct prop_global *pg = prop_get_global(pd);
-
-	prop_norm_percpu(pg, pl);
-
-	if (unlikely(frac != PROP_FRAC_BASE)) {
-		unsigned long period_2 = 1UL << (pg->shift - 1);
-		unsigned long counter_mask = period_2 - 1;
-		unsigned long global_count;
-		long numerator, denominator;
-
-		numerator = percpu_counter_read_positive(&pl->events);
-		global_count = percpu_counter_read(&pg->events);
-		denominator = period_2 + (global_count & counter_mask);
-
-		if (numerator > ((denominator * frac) >> PROP_FRAC_SHIFT))
-			goto out_put;
-	}
-
-	percpu_counter_add(&pl->events, 1);
-	percpu_counter_add(&pg->events, 1);
-
-out_put:
-	prop_put_global(pd, pg);
-}
-
-/*
- * Obtain a fraction of this proportion
- *
- *   p_{j} = x_{j} / (period/2 + t % period/2)
- */
-void prop_fraction_percpu(struct prop_descriptor *pd,
-		struct prop_local_percpu *pl,
-		long *numerator, long *denominator)
-{
-	struct prop_global *pg = prop_get_global(pd);
-	unsigned long period_2 = 1UL << (pg->shift - 1);
-	unsigned long counter_mask = period_2 - 1;
-	unsigned long global_count;
-
-	prop_norm_percpu(pg, pl);
-	*numerator = percpu_counter_read_positive(&pl->events);
-
-	global_count = percpu_counter_read(&pg->events);
-	*denominator = period_2 + (global_count & counter_mask);
-
-	prop_put_global(pd, pg);
-}
-
-/*
- * SINGLE
- */
-
-int prop_local_init_single(struct prop_local_single *pl)
-{
-	raw_spin_lock_init(&pl->lock);
-	pl->shift = 0;
-	pl->period = 0;
-	pl->events = 0;
-	return 0;
-}
-
-void prop_local_destroy_single(struct prop_local_single *pl)
-{
-}
-
-/*
  * Catch up with missed period expirations.
  */
 static
@@ -382,26 +228,3 @@ void __prop_inc_single(struct prop_descriptor *pd, struct prop_local_single *pl)
 	percpu_counter_add(&pg->events, 1);
 	prop_put_global(pd, pg);
 }
-
-/*
- * Obtain a fraction of this proportion
- *
- *   p_{j} = x_{j} / (period/2 + t % period/2)
- */
-void prop_fraction_single(struct prop_descriptor *pd,
-	       	struct prop_local_single *pl,
-		long *numerator, long *denominator)
-{
-	struct prop_global *pg = prop_get_global(pd);
-	unsigned long period_2 = 1UL << (pg->shift - 1);
-	unsigned long counter_mask = period_2 - 1;
-	unsigned long global_count;
-
-	prop_norm_single(pg, pl);
-	*numerator = pl->events;
-
-	global_count = percpu_counter_read(&pg->events);
-	*denominator = period_2 + (global_count & counter_mask);
-
-	prop_put_global(pd, pg);
-}
-- 
1.7.10.4

