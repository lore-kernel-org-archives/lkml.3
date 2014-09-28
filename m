Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaI1Vrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbaI1Vri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:47:38 -0400
Date: Sun, 28 Sep 2014 23:44:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] rcu: more info about potential deadlocks with
	rcu_read_unlock()
Message-ID: <20140928214421.GA17972@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928214357.GA17874@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above rcu_read_unlock() explains the potential deadlock
if the caller holds one of the locks taken by rt_mutex_unlock() paths,
but it is not clear from this documentation that any lock which can
be taken from interrupt can lead to deadlock as well and we need to
take rt_mutex_lock() into account too.

The problem is that rt_mutex_lock() takes wait_lock without disabling
irqs, and thus an interrupt taking some LOCK can obviously race with
rcu_read_unlock_special() called with the same LOCK held.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcupdate.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d231aa1..5abcfda 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -863,7 +863,9 @@ static inline void rcu_read_lock(void)
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
1.5.5.1

