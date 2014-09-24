Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaIXIgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:36:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaIXI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:14 -0400
Message-Id: <20140924082241.988560063@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/11] locking/mutex: Dont assume TASK_RUNNING
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-mutex_lock-vs-task_state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to make might_sleep() test for TASK_RUNNING, because
blocking without TASK_RUNNING will destroy the task state by setting
it to TASK_RUNNING.

There are a few occasions where its 'valid' to call blocking
primitives (and mutex_lock in particular) and not have TASK_RUNNING,
typically such cases are right before we set TASK_RUNNING anyhow.

Robustify the code by not assuming this; this has the beneficial side
effect of allowing optional code emission for fixing the above
might_sleep() false positives.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/locking/mutex.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -378,8 +378,14 @@ static bool mutex_optimistic_spin(struct
 	 * reschedule now, before we try-lock the mutex. This avoids getting
 	 * scheduled out right after we obtained the mutex.
 	 */
-	if (need_resched())
+	if (need_resched()) {
+		/*
+		 * We _should_ have TASK_RUNNING here, but just in case
+		 * we do not, make it so, otherwise we might get stuck.
+		 */
+		__set_current_state(TASK_RUNNING);
 		schedule_preempt_disabled();
+	}
 
 	return false;
 }


