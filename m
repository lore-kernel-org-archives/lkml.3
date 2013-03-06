Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3CFXWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:22:15 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60190 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab3CFXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:22:12 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] rwsem: skip initial trylock in rwsem_down_write_failed
Date: Wed,  6 Mar 2013 15:21:48 -0800
Message-Id: <1362612111-28673-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can skip the initial trylock in rwsem_down_write_failed() if there are
known active lockers already, thus saving one likely-to-fail cmpxchg.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index edf3d9ca670e..0d50e46d5b0c 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -216,14 +216,15 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	/* wait until we successfully acquire the lock */
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (true) {
-
-		/* Try acquiring the write lock. */
-		count = RWSEM_ACTIVE_WRITE_BIAS;
-		if (!list_is_singular(&sem->wait_list))
-			count += RWSEM_WAITING_BIAS;
-		if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
+		if (!(count & RWSEM_ACTIVE_MASK)) {
+			/* Try acquiring the write lock. */
+			count = RWSEM_ACTIVE_WRITE_BIAS;
+			if (!list_is_singular(&sem->wait_list))
+				count += RWSEM_WAITING_BIAS;
+			if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
 							RWSEM_WAITING_BIAS)
-			break;
+				break;
+		}
 
 		raw_spin_unlock_irq(&sem->wait_lock);
 
@@ -231,7 +232,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		do {
 			schedule();
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		} while (sem->count & RWSEM_ACTIVE_MASK);
+		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
 
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
-- 
1.8.1.3
