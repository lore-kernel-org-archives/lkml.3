Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3JDReK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:34:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3JDReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:34:06 -0400
Date: Fri, 4 Oct 2013 10:33:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2953ef246b058989657e1e77b36b67566ac06f7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.028892896@infradead.org>
References: <20131002092528.028892896@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Change timeout logic
Git-Commit-ID: 2953ef246b058989657e1e77b36b67566ac06f7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:33:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2953ef246b058989657e1e77b36b67566ac06f7b
Gitweb:     http://git.kernel.org/tip/2953ef246b058989657e1e77b36b67566ac06f7b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:44 +0200

sched/wait: Change timeout logic

Commit 4c663cf ("wait: fix false timeouts when using
wait_event_timeout()") introduced an additional condition check after
a timeout but there's a few issues;

 - it forgot one site
 - it put the check after the main loop; not at the actual timeout
   check.

Cure both; by wrapping the condition (as suggested by Oleg), this
avoids double evaluation of 'condition' which could be quite big.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.028892896@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index ccf0c52..b2afd66 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -179,6 +179,14 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
+#define ___wait_cond_timeout(condition, ret)				\
+({									\
+ 	bool __cond = (condition);					\
+ 	if (__cond && !ret)						\
+ 		ret = 1;						\
+ 	__cond || !ret;							\
+})
+
 #define __wait_event(wq, condition) 					\
 do {									\
 	DEFINE_WAIT(__wait);						\
@@ -217,14 +225,10 @@ do {									\
 									\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
+		if (___wait_cond_timeout(condition, ret))		\
 			break;						\
 		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
 	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -299,18 +303,14 @@ do {									\
 									\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
+		if (___wait_cond_timeout(condition, ret))		\
 			break;						\
 		if (signal_pending(current)) {				\
 			ret = -ERESTARTSYS;				\
 			break;						\
 		}							\
 		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
 	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -815,7 +815,7 @@ do {									\
 									\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
+		if (___wait_cond_timeout(condition, ret))		\
 			break;						\
 		if (signal_pending(current)) {				\
 			ret = -ERESTARTSYS;				\
@@ -824,8 +824,6 @@ do {									\
 		spin_unlock_irq(&lock);					\
 		ret = schedule_timeout(ret);				\
 		spin_lock_irq(&lock);					\
-		if (!ret)						\
-			break;						\
 	}								\
 	finish_wait(&wq, &__wait);					\
 } while (0)
