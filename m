Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaF3QUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbaF3QU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:20:27 -0400
Date: Mon, 30 Jun 2014 18:18:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] rcu: change rcu_dereference_check(c) to check "c"
	first
Message-ID: <20140630161852.GA15894@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630161837.GA15873@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of "c" and "_held" checks in rcu_dereference_check(),
this can help if __builtin_constant_p(c).

CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU + CONFIG_TREE_RCU_TRACE

	- 5578795 3026776 14757888 23363459
	+ 5542443 3014040 14757888 23314371

saves 49088 bytes according to size vmlinux.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcupdate.h |    6 +++---
 include/linux/srcu.h     |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b82d1d6..e8c55d8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -694,7 +694,7 @@ static inline void rcu_preempt_sleep_check(void)
  * annotated as __rcu.
  */
 #define rcu_dereference_check(p, c) \
-	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)
+	__rcu_dereference_check((p), (c) || rcu_read_lock_held(), __rcu)
 
 /**
  * rcu_dereference_bh_check() - rcu_dereference_bh with debug checking
@@ -704,7 +704,7 @@ static inline void rcu_preempt_sleep_check(void)
  * This is the RCU-bh counterpart to rcu_dereference_check().
  */
 #define rcu_dereference_bh_check(p, c) \
-	__rcu_dereference_check((p), rcu_read_lock_bh_held() || (c), __rcu)
+	__rcu_dereference_check((p), (c) || rcu_read_lock_bh_held(), __rcu)
 
 /**
  * rcu_dereference_sched_check() - rcu_dereference_sched with debug checking
@@ -714,7 +714,7 @@ static inline void rcu_preempt_sleep_check(void)
  * This is the RCU-sched counterpart to rcu_dereference_check().
  */
 #define rcu_dereference_sched_check(p, c) \
-	__rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
+	__rcu_dereference_check((p), (c) || rcu_read_lock_sched_held(), \
 				__rcu)
 
 #define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 5c06289..eae58d4 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -184,7 +184,7 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
  * lockdep_is_held() calls.
  */
 #define srcu_dereference_check(p, sp, c) \
-	__rcu_dereference_check((p), srcu_read_lock_held(sp) || (c), __rcu)
+	__rcu_dereference_check((p), (c) || srcu_read_lock_held(sp), __rcu)
 
 /**
  * srcu_dereference - fetch SRCU-protected pointer for later dereferencing
-- 
1.5.5.1

