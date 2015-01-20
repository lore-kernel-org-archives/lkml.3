Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbbATBjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 20:39:36 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44033 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbATBjf (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 19 Jan 2015 20:39:35 -0500
Message-ID: <1421717961.4903.11.camel@stgolabs.net>
Subject: [PATCH -tip] locking/mutex: Explicitly mark task as running after
 wakeup
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>
Date: Mon, 19 Jan 2015 17:39:21 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the time we wake up and get the lock after being asleep
in the slowpath, we better be running. As good practice,
be explicit about this and avoid any mischief.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index c67a60b..5740706 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -587,6 +587,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		schedule_preempt_disabled();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
+	__set_task_state(task, TASK_RUNNING);
+
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
-- 
2.1.2



