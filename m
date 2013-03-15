Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3COLCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:02:01 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63157 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3COLCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:02:00 -0400
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/13] rwsem: avoid taking wait_lock in rwsem_down_write_failed
Date: Fri, 15 Mar 2013 03:54:24 -0700
Message-Id: <1363344869-15732-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363344869-15732-1-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rwsem_down_write_failed(), if there are active locks after we wake up
(i.e. the lock got stolen from us), skip taking the wait_lock and go back
to sleep immediately.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 64c2dc007be2..edf3d9ca670e 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -214,8 +214,8 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	/* wait until we successfully acquire the lock */
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (true) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 
 		/* Try acquiring the write lock. */
 		count = RWSEM_ACTIVE_WRITE_BIAS;
@@ -226,7 +226,13 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 			break;
 
 		raw_spin_unlock_irq(&sem->wait_lock);
-		schedule();
+
+		/* Block until there are no active lockers. */
+		do {
+			schedule();
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		} while (sem->count & RWSEM_ACTIVE_MASK);
+
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
 
-- 
1.8.1.3
