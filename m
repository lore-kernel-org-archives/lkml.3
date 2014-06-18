Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbaFRBIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:08:18 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39069 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992AbaFRBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:08:15 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] percpu-refcount: use unsigned long for pcpu_count pointer
Date: Tue, 17 Jun 2014 21:08:03 -0400
Message-Id: <1403053685-28240-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403053685-28240-1-git-send-email-tj@kernel.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref->pcpu_count is a percpu pointer with a status flag in its
lowest bit.  As such, it always goes through arithmetic operations
which is very cumbersome to do on a pointer.  It has to be first
casted to unsigned long and then back.

Let's just make the field unsigned long so that we can skip the first
casts.  While at it, rename it to pcpu_counter_ptr to clarify that
it's a pointer value.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-refcount.h |  4 ++--
 lib/percpu-refcount.c           | 11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index b62a4ee..6f8cd4c 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -61,7 +61,7 @@ struct percpu_ref {
 	 * hack because we need to keep the pointer around for
 	 * percpu_ref_kill_rcu())
 	 */
-	unsigned __percpu	*pcpu_count;
+	unsigned long		pcpu_count_ptr;
 	percpu_ref_func_t	*release;
 	percpu_ref_func_t	*confirm_kill;
 	struct rcu_head		rcu;
@@ -99,7 +99,7 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
 				    unsigned __percpu **pcpu_countp)
 {
-	unsigned long pcpu_ptr = (unsigned long)ACCESS_ONCE(ref->pcpu_count);
+	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
 
 	if (unlikely(pcpu_ptr & PCPU_REF_DEAD))
 		return false;
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 087f1a0..94e5b62 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -33,7 +33,7 @@
 
 static unsigned __percpu *pcpu_count_ptr(struct percpu_ref *ref)
 {
-	return (unsigned __percpu *)((unsigned long)ref->pcpu_count & ~PCPU_REF_DEAD);
+	return (unsigned __percpu *)(ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
 }
 
 /**
@@ -51,8 +51,8 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
 {
 	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
 
-	ref->pcpu_count = alloc_percpu(unsigned);
-	if (!ref->pcpu_count)
+	ref->pcpu_count_ptr = (unsigned long)alloc_percpu(unsigned);
+	if (!ref->pcpu_count_ptr)
 		return -ENOMEM;
 
 	ref->release = release;
@@ -153,11 +153,10 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill)
 {
-	WARN_ONCE((unsigned long)ref->pcpu_count & PCPU_REF_DEAD,
+	WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
 		  "percpu_ref_kill() called more than once!\n");
 
-	ref->pcpu_count = (unsigned __percpu *)
-		(((unsigned long) ref->pcpu_count)|PCPU_REF_DEAD);
+	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
 	ref->confirm_kill = confirm_kill;
 
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
-- 
1.9.3

