Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3JDRfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:35:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3JDRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:35:46 -0400
Date: Fri, 4 Oct 2013 10:35:17 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a1dc6852ac5eecdcd3122ae01703183a3e88e979@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.759956109@infradead.org>
References: <20131002092528.759956109@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Collapse __wait_event_interruptible_lock_irq_timeout()
Git-Commit-ID: a1dc6852ac5eecdcd3122ae01703183a3e88e979
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:35:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1dc6852ac5eecdcd3122ae01703183a3e88e979
Gitweb:     http://git.kernel.org/tip/a1dc6852ac5eecdcd3122ae01703183a3e88e979
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:16:20 +0200

sched/wait: Collapse __wait_event_interruptible_lock_irq_timeout()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.759956109@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a577a85..5d5408b 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -763,25 +763,12 @@ do {									\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
-						    lock, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (___wait_cond_timeout(condition, ret))		\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		ret = schedule_timeout(ret);				\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition, lock, ret) \
+	___wait_event(wq, ___wait_cond_timeout(condition, ret),		      \
+		      TASK_INTERRUPTIBLE, 0, ret,	      		      \
+		      spin_unlock_irq(&lock);				      \
+		      ret = schedule_timeout(ret);			      \
+		      spin_lock_irq(&lock));
 
 /**
  * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.
