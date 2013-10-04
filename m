Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3JDRf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:35:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58894 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3JDRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:35:56 -0400
Date: Fri, 4 Oct 2013 10:35:27 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0d1e1c8a430450a3ce61a842cec64f9e2a9f3b05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.831085521@infradead.org>
References: <20131002092528.831085521@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Collapse __wait_event_interruptible_tty()
Git-Commit-ID: 0d1e1c8a430450a3ce61a842cec64f9e2a9f3b05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:35:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d1e1c8a430450a3ce61a842cec64f9e2a9f3b05
Gitweb:     http://git.kernel.org/tip/0d1e1c8a430450a3ce61a842cec64f9e2a9f3b05
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:16:20 +0200

sched/wait: Collapse __wait_event_interruptible_tty()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.831085521@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/tty.h | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 0503729..6e80329 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -679,23 +679,10 @@ static inline void tty_wait_until_sent_from_close(struct tty_struct *tty,
 })
 
 #define __wait_event_interruptible_tty(tty, wq, condition, ret)		\
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
-		tty_unlock(tty);					\
-		schedule();						\
-		tty_lock(tty);						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	\
+			tty_unlock(tty);				\
+			schedule();					\
+			tty_lock(tty))
 
 #ifdef CONFIG_PROC_FS
 extern void proc_tty_register_driver(struct tty_driver *);
