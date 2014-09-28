Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaI1Vra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:47:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaI1Vr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:47:28 -0400
Date: Sun, 28 Sep 2014 23:44:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] signal: document the RCU protection of ->sighand
Message-ID: <20140928214418.GA17965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928214357.GA17874@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cleanup_sighand() frees sighand without RCU grace period. This is
correct but this looks "obviously buggy" and constantly confuses the
readers, add the comments to explain how this works.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 kernel/fork.c   |    5 ++++-
 kernel/signal.c |   12 +++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1380d8a..2dd9f1d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1017,11 +1017,14 @@ void __cleanup_sighand(struct sighand_struct *sighand)
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
index 8f0876f..c187133 100644
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
1.5.5.1

