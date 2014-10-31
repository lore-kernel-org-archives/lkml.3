Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbaJaLVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:21:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:32816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJaLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:38 -0400
Message-Id: <20141031111549.492532161@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/7] sched,wait: Fix a kthread race with wait_woken()
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-wait_woken-kthread.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between kthread_stop() and the new wait_woken() that
can result in a lack of progress.

CPU 0                                    | CPU 1
                                         |
rfcomm_run()                             | kthread_stop()
  ...                                    |
  if (!test_bit(KTHREAD_SHOULD_STOP))    |
                                         |   set_bit(KTHREAD_SHOULD_STOP)
                                         |   wake_up_process()
    wait_woken()                         |   wait_for_completion()
      set_current_state(INTERRUPTIBLE)   |
      if (!WQ_FLAG_WOKEN)                |
        schedule_timeout()               |
                                         |

After which both tasks will wait.. forever.

Fix this by having wait_woken() check for kthread_should_stop() but
only for kthreads (obviously).

Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/wait.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
+#include <linux/kthread.h>
 
 void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
@@ -297,6 +298,10 @@ int autoremove_wake_function(wait_queue_
 }
 EXPORT_SYMBOL(autoremove_wake_function);
 
+static inline bool is_kthread_should_stop(void)
+{
+	return (current->flags & PF_KTHREAD) && kthread_should_stop();
+}
 
 /*
  * DEFINE_WAIT_FUNC(wait, woken_wake_func);
@@ -326,7 +331,7 @@ long wait_woken(wait_queue_t *wait, unsi
 	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
 	 * also observe all state before the wakeup.
 	 */
-	if (!(wait->flags & WQ_FLAG_WOKEN))
+	if (!(wait->flags & WQ_FLAG_WOKEN) && !is_kthread_should_stop())
 		timeout = schedule_timeout(timeout);
 	__set_current_state(TASK_RUNNING);
 


