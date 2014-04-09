Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbaDICwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:52:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:17350 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757135AbaDICwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:52:36 -0400
Message-Id: <20140409025231.998774075@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 08 Apr 2014 22:47:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RT 1/2] rwsem-rt: Do not allow readers to nest
References: <20140409024700.702797305@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-rwsem-rt-Do-not-allow-readers-to-nest.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The readers of mainline rwsems are not allowed to nest, the rwsems in the
PREEMPT_RT kernel should not nest either.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rwsem_rt.h |  1 -
 kernel/rt.c              | 37 ++++++++-----------------------------
 2 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/include/linux/rwsem_rt.h b/include/linux/rwsem_rt.h
index e94d945..a81151c 100644
--- a/include/linux/rwsem_rt.h
+++ b/include/linux/rwsem_rt.h
@@ -20,7 +20,6 @@
 
 struct rw_semaphore {
 	struct rt_mutex		lock;
-	int			read_depth;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
diff --git a/kernel/rt.c b/kernel/rt.c
index 5d17727..bb72347 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -316,10 +316,8 @@ EXPORT_SYMBOL(rt_up_write);
 
 void  rt_up_read(struct rw_semaphore *rwsem)
 {
-	if (--rwsem->read_depth == 0) {
-		rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-		rt_mutex_unlock(&rwsem->lock);
-	}
+	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
+	rt_mutex_unlock(&rwsem->lock);
 }
 EXPORT_SYMBOL(rt_up_read);
 
@@ -330,7 +328,6 @@ EXPORT_SYMBOL(rt_up_read);
 void  rt_downgrade_write(struct rw_semaphore *rwsem)
 {
 	BUG_ON(rt_mutex_owner(&rwsem->lock) != current);
-	rwsem->read_depth = 1;
 }
 EXPORT_SYMBOL(rt_downgrade_write);
 
@@ -367,37 +364,20 @@ void rt_down_write_nested_lock(struct rw_semaphore *rwsem,
 
 int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 {
-	struct rt_mutex *lock = &rwsem->lock;
-	int ret = 1;
-
-	/*
-	 * recursive read locks succeed when current owns the rwsem,
-	 * but not when read_depth == 0 which means that the rwsem is
-	 * write locked.
-	 */
-	if (rt_mutex_owner(lock) != current) {
-		ret = rt_mutex_trylock(&rwsem->lock);
-		if (ret)
-			rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
-	} else if (!rwsem->read_depth) {
-		ret = 0;
-	}
+	int ret;
 
+	ret = rt_mutex_trylock(&rwsem->lock);
 	if (ret)
-		rwsem->read_depth++;
+		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
+
 	return ret;
 }
 EXPORT_SYMBOL(rt_down_read_trylock);
 
 static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 {
-	struct rt_mutex *lock = &rwsem->lock;
-
-	if (rt_mutex_owner(lock) != current) {
-		rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
-		rt_mutex_lock(&rwsem->lock);
-	}
-	rwsem->read_depth++;
+	rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
+	rt_mutex_lock(&rwsem->lock);
 }
 
 void  rt_down_read(struct rw_semaphore *rwsem)
@@ -422,7 +402,6 @@ void  __rt_rwsem_init(struct rw_semaphore *rwsem, const char *name,
 	debug_check_no_locks_freed((void *)rwsem, sizeof(*rwsem));
 	lockdep_init_map(&rwsem->dep_map, name, key, 0);
 #endif
-	rwsem->read_depth = 0;
 	rwsem->lock.save_state = 0;
 }
 EXPORT_SYMBOL(__rt_rwsem_init);
-- 
1.8.5.3


