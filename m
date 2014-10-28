Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaJ1WRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:17:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57417 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbaJ1WRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:17:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] signal: Document the RCU protection of ->sighand
Date: Tue, 28 Oct 2014 15:13:48 -0700
Message-Id: <1414534428-27918-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534428-27918-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028221330.GA27479@linux.vnet.ibm.com>
 <1414534428-27918-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F4FDC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

__cleanup_sighand() frees sighand without RCU grace period. This is
correct but this looks "obviously buggy" and constantly confuses the
readers, add the comments to explain how this works.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/fork.c   |  5 ++++-
 kernel/signal.c | 12 +++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746d6d62..9ca84189cfc2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1022,11 +1022,14 @@ void __cleanup_sighand(struct sighand_struct *sighand)
 {
 	if (atomic_dec_and_test(&sighand->count)) {
 		signalfd_cleanup(sighand);
+		/*
+		 * sighand_cachep is SLAB_DESTROY_BY_RCU so we can free it
+		 * without an RCU grace period, see __lock_task_sighand().
+		 */
 		kmem_cache_free(sighand_cachep, sighand);
 	}
 }
 
-
 /*
  * Initialize POSIX timer handling for a thread group.
  */
diff --git a/kernel/signal.c b/kernel/signal.c
index 54820984a872..19e35135fc60 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1275,7 +1275,17 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 			local_irq_restore(*flags);
 			break;
 		}
-
+		/*
+		 * This sighand can be already freed and even reused, but
+		 * we rely on SLAB_DESTROY_BY_RCU and sighand_ctor() which
+		 * initializes ->siglock: this slab can't go away, it has
+		 * the same object type, ->siglock can't be reinitialized.
+		 *
+		 * We need to ensure that tsk->sighand is still the same
+		 * after we take the lock, we can race with de_thread() or
+		 * __exit_signal(). In the latter case the next iteration
+		 * must see ->sighand == NULL.
+		 */
 		spin_lock(&sighand->siglock);
 		if (likely(sighand == tsk->sighand)) {
 			rcu_read_unlock();
-- 
1.8.1.5

