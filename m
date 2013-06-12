Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3FLUkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:40:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176Ab3FLUkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:40:39 -0400
Date: Wed, 12 Jun 2013 13:40:32 -0700
From: Tejun Heo <theo@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH percpu/for-3.11] percpu-refcount: consistently use plain
 (non-sched) RCU
Message-ID: <20130612204031.GA15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e96262150a513ce3d54ff221d4ace8aeec96e0bf Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 12 Jun 2013 13:37:42 -0700

percpu_ref_get/put() are using preempt_disable/enable() while
percpu_ref_kill() is using plain call_rcu() instead of
call_rcu_sched().  This is buggy as grace periods of the two may not
match.  Fix it by using plain RCU in percpu_ref_get/put().

(I suggested using sched RCU in the first place but there's no actual
 benefit in doing so unless we're gonna introduce different variants
 of get/put to be called while preemption is alredy disabled, which we
 definitely shouldn't.)

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/percpu-refcount.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 24b31ef..abe1411 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -85,7 +85,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 {
 	unsigned __percpu *pcpu_count;
 
-	preempt_disable();
+	rcu_read_lock();
 
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
@@ -94,7 +94,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 	else
 		atomic_inc(&ref->count);
 
-	preempt_enable();
+	rcu_read_unlock();
 }
 
 /**
@@ -107,7 +107,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 {
 	unsigned __percpu *pcpu_count;
 
-	preempt_disable();
+	rcu_read_lock();
 
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
@@ -116,7 +116,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);
 
-	preempt_enable();
+	rcu_read_unlock();
 }
 
 #endif
-- 
1.8.2.1

