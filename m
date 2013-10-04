Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3JDRfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:35:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3JDRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:35:36 -0400
Date: Fri, 4 Oct 2013 10:35:08 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8fbd88fa1717601ef91ced49a32f24786b167065@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.686006009@infradead.org>
References: <20131002092528.686006009@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Collapse __wait_event_interruptible_lock_irq()
Git-Commit-ID: 8fbd88fa1717601ef91ced49a32f24786b167065
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:35:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fbd88fa1717601ef91ced49a32f24786b167065
Gitweb:     http://git.kernel.org/tip/8fbd88fa1717601ef91ced49a32f24786b167065
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:16:19 +0200

sched/wait: Collapse __wait_event_interruptible_lock_irq()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.686006009@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index d64918e..a577a85 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -689,26 +689,12 @@ do {									\
 } while (0)
 
 
-#define __wait_event_interruptible_lock_irq(wq, condition,		\
-					    lock, ret, cmd)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq(wq, condition, lock, ret, cmd) \
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	   \
+		      spin_unlock_irq(&lock);				   \
+		      cmd;						   \
+		      schedule();					   \
+		      spin_lock_irq(&lock))
 
 /**
  * wait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.
