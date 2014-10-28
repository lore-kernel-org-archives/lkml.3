Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaJ1WPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:15:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58410 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbaJ1WN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:58 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/9] rcu: More info about potential deadlocks with rcu_read_unlock()
Date: Tue, 28 Oct 2014 15:10:00 -0700
Message-Id: <1414534202-27312-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F05F70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

The comment above rcu_read_unlock() explains the potential deadlock
if the caller holds one of the locks taken by rt_mutex_unlock() paths,
but it is not clear from this documentation that any lock which can
be taken from interrupt can lead to deadlock as well and we need to
take rt_mutex_lock() into account too.

The problem is that rt_mutex_lock() takes wait_lock without disabling
irqs, and thus an interrupt taking some LOCK can obviously race with
rcu_read_unlock_special() called with the same LOCK held.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 36ea3ba5c516..ae6942a84a0d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -887,7 +887,9 @@ static inline void rcu_read_lock(void)
  * Unfortunately, this function acquires the scheduler's runqueue and
  * priority-inheritance spinlocks.  This means that deadlock could result
  * if the caller of rcu_read_unlock() already holds one of these locks or
- * any lock that is ever acquired while holding them.
+ * any lock that is ever acquired while holding them; or any lock which
+ * can be taken from interrupt context because rcu_boost()->rt_mutex_lock()
+ * does not disable irqs while taking ->wait_lock.
  *
  * That said, RCU readers are never priority boosted unless they were
  * preempted.  Therefore, one way to avoid deadlock is to make sure
-- 
1.8.1.5

