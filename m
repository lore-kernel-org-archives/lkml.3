Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3JDRgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:36:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JDRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:36:19 -0400
Date: Fri, 4 Oct 2013 10:35:47 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ebdc195f2ec68576876216081035293e37318e86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.972793648@infradead.org>
References: <20131002092528.972793648@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Collapse __wait_event_hrtimeout()
Git-Commit-ID: ebdc195f2ec68576876216081035293e37318e86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:35:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebdc195f2ec68576876216081035293e37318e86
Gitweb:     http://git.kernel.org/tip/ebdc195f2ec68576876216081035293e37318e86
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:16:22 +0200

sched/wait: Collapse __wait_event_hrtimeout()

While not a whole-sale replacement like the others we can still reduce
the size of __wait_event_hrtimeout() considerably by noting that the
actual core of __wait_event_hrtimeout() is identical to what
___wait_event() generates.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.972793648@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index ec3683e..c065e8a 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -337,7 +337,6 @@ do {									\
 #define __wait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
 	int __ret = 0;							\
-	DEFINE_WAIT(__wait);						\
 	struct hrtimer_sleeper __t;					\
 									\
 	hrtimer_init_on_stack(&__t.timer, CLOCK_MONOTONIC,		\
@@ -348,25 +347,15 @@ do {									\
 				       current->timer_slack_ns,		\
 				       HRTIMER_MODE_REL);		\
 									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, state);			\
-		if (condition)						\
-			break;						\
-		if (state == TASK_INTERRUPTIBLE &&			\
-		    signal_pending(current)) {				\
-			__ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
+	___wait_event(wq, condition, state, 0, __ret,			\
 		if (!__t.task) {					\
 			__ret = -ETIME;					\
 			break;						\
 		}							\
-		schedule();						\
-	}								\
+		schedule());						\
 									\
 	hrtimer_cancel(&__t.timer);					\
 	destroy_hrtimer_on_stack(&__t.timer);				\
-	finish_wait(&wq, &__wait);					\
 	__ret;								\
 })
 
