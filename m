Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3JDRfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:35:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab3JDRf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:35:26 -0400
Date: Fri, 4 Oct 2013 10:34:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-13cb5042a4b80396f77cf5d599d2c002c57b89dc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.612813379@infradead.org>
References: <20131002092528.612813379@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Collapse __wait_event_lock_irq()
Git-Commit-ID: 13cb5042a4b80396f77cf5d599d2c002c57b89dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:35:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13cb5042a4b80396f77cf5d599d2c002c57b89dc
Gitweb:     http://git.kernel.org/tip/13cb5042a4b80396f77cf5d599d2c002c57b89dc
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:50 +0200

sched/wait: Collapse __wait_event_lock_irq()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.612813379@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index c4ab172..d64918e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -624,20 +624,12 @@ do {									\
 
 
 #define __wait_event_lock_irq(wq, condition, lock, cmd)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,		\
+		      ___wait_nop_ret,					\
+		      spin_unlock_irq(&lock);				\
+		      cmd;						\
+		      schedule();					\
+		      spin_lock_irq(&lock))
 
 /**
  * wait_event_lock_irq_cmd - sleep until a condition gets true. The
