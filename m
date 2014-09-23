Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbaIWF4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:56:54 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:64793 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaIWFz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:55:28 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/9] percpu_ref: add PCPU_REF_DEAD
Date: Tue, 23 Sep 2014 01:55:14 -0400
Message-Id: <1411451718-17807-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref will be restructured so that percpu/atomic mode switching
and reference killing are dedoupled.  In preparation, add
PCPU_REF_DEAD and PCPU_REF_ATOMIC_DEAD which is OR of ATOMIC and DEAD.
For now, ATOMIC and DEAD are changed together and all PCPU_REF_ATOMIC
uses are converted to PCPU_REF_ATOMIC_DEAD without causing any
behavior changes.

BUILD_BUG_ON() is added to percpu_ref_init() so that later flag
additions don't accidentally clobber lower bits of the pointer in
percpu_ref->pcpu_count_ptr.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/percpu-refcount.h |  4 +++-
 lib/percpu-refcount.c           | 15 +++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 910e5f7..24cf157 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -57,6 +57,8 @@ typedef void (percpu_ref_func_t)(struct percpu_ref *);
 /* flags set in the lower bits of percpu_ref->percpu_count_ptr */
 enum {
 	__PERCPU_REF_ATOMIC	= 1LU << 0,	/* operating in atomic mode */
+	__PERCPU_REF_DEAD	= 1LU << 1,	/* (being) killed */
+	__PERCPU_REF_ATOMIC_DEAD = __PERCPU_REF_ATOMIC | __PERCPU_REF_DEAD,
 };
 
 struct percpu_ref {
@@ -107,7 +109,7 @@ static inline bool __ref_is_percpu(struct percpu_ref *ref,
 	/* paired with smp_store_release() in percpu_ref_reinit() */
 	smp_read_barrier_depends();
 
-	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
+	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC_DEAD))
 		return false;
 
 	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 7aef590..b0b8c09 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -34,7 +34,7 @@
 static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
 {
 	return (unsigned long __percpu *)
-		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
+		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
 }
 
 /**
@@ -52,6 +52,9 @@ static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
 int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 		    gfp_t gfp)
 {
+	BUILD_BUG_ON(__PERCPU_REF_ATOMIC_DEAD &
+		     ~(__alignof__(unsigned long) - 1));
+
 	atomic_long_set(&ref->count, 1 + PERCPU_COUNT_BIAS);
 
 	ref->percpu_count_ptr =
@@ -80,7 +83,7 @@ void percpu_ref_exit(struct percpu_ref *ref)
 
 	if (percpu_count) {
 		free_percpu(percpu_count);
-		ref->percpu_count_ptr = __PERCPU_REF_ATOMIC;
+		ref->percpu_count_ptr = __PERCPU_REF_ATOMIC_DEAD;
 	}
 }
 EXPORT_SYMBOL_GPL(percpu_ref_exit);
@@ -145,10 +148,10 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill)
 {
-	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC,
+	WARN_ONCE(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC_DEAD,
 		  "%s called more than once on %pf!", __func__, ref->release);
 
-	ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC;
+	ref->percpu_count_ptr |= __PERCPU_REF_ATOMIC_DEAD;
 	ref->confirm_switch = confirm_kill;
 
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
@@ -180,12 +183,12 @@ void percpu_ref_reinit(struct percpu_ref *ref)
 	 * Restore per-cpu operation.  smp_store_release() is paired with
 	 * smp_read_barrier_depends() in __ref_is_percpu() and guarantees
 	 * that the zeroing is visible to all percpu accesses which can see
-	 * the following __PERCPU_REF_ATOMIC clearing.
+	 * the following __PERCPU_REF_ATOMIC_DEAD clearing.
 	 */
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(percpu_count, cpu) = 0;
 
 	smp_store_release(&ref->percpu_count_ptr,
-			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC);
+			  ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_reinit);
-- 
1.9.3

