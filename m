Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbbAZHgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:36:48 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:50150 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbbAZHgm (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:42 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/6] locking/rwsem: Use task->state helpers
Date: Sun, 25 Jan 2015 23:36:04 -0800
Message-Id: <1422257769-14083-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __set_task_state() instead of assigning the new state
directly. These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP
environments, keeping track of who last changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-spinlock.c | 2 +-
 kernel/locking/rwsem-xadd.c     | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 2c93571..2555ae1 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -154,7 +154,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 
-	tsk->state = TASK_RUNNING;
+	__set_task_state(tsk, TASK_RUNNING);
  out:
 	;
 }
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 7628c3f..2f7cc40 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -242,8 +242,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 		schedule();
 	}
 
-	tsk->state = TASK_RUNNING;
-
+	__set_task_state(tsk, TASK_RUNNING);
 	return sem;
 }
 EXPORT_SYMBOL(rwsem_down_read_failed);
-- 
2.1.2

