Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaJ1LK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:10:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaJ1LKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:10:25 -0400
Date: Tue, 28 Oct 2014 04:09:27 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6f942a1f264e875c5f3ad6f505d7b500a3e7fa82@git.kernel.org>
Cc: peterz@infradead.org, torvalds@linux-foundation.org, mingo@kernel.org,
        oleg@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Reply-To: torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, oleg@redhat.com,
        hpa@zytor.com, mingo@kernel.org
In-Reply-To: <20140924082241.988560063@infradead.org>
References: <20140924082241.988560063@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] locking/mutex: Don't assume TASK_RUNNING
Git-Commit-ID: 6f942a1f264e875c5f3ad6f505d7b500a3e7fa82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f942a1f264e875c5f3ad6f505d7b500a3e7fa82
Gitweb:     http://git.kernel.org/tip/6f942a1f264e875c5f3ad6f505d7b500a3e7fa82
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:55:08 +0100

locking/mutex: Don't assume TASK_RUNNING

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
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140924082241.988560063@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index dadbf88..4541951 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -378,8 +378,14 @@ done:
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
