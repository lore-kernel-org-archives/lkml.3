Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3JDRd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:33:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58774 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab3JDRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:33:56 -0400
Date: Fri, 4 Oct 2013 10:33:28 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2f2a2b60adf368bacd6acd2116c01e32caf936c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092527.956416254@infradead.org>
References: <20131002092527.956416254@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Make the signal_pending()
  checks consistent
Git-Commit-ID: 2f2a2b60adf368bacd6acd2116c01e32caf936c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:33:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f2a2b60adf368bacd6acd2116c01e32caf936c4
Gitweb:     http://git.kernel.org/tip/2f2a2b60adf368bacd6acd2116c01e32caf936c4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:44 +0200

sched/wait: Make the signal_pending() checks consistent

There's two patterns to check signals in the __wait_event*() macros:

  if (!signal_pending(current)) {
	schedule();
	continue;
  }
  ret = -ERESTARTSYS;
  break;

And the more natural:

  if (signal_pending(current)) {
	ret = -ERESTARTSYS;
	break;
  }
  schedule();

Change them all into the latter form.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092527.956416254@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/tty.h  | 13 ++++++-------
 include/linux/wait.h | 35 ++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 64f8646..0503729 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -686,14 +686,13 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
-			tty_unlock(tty);					\
-			schedule();					\
-			tty_lock(tty);					\
-			continue;					\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
 		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
+		tty_unlock(tty);					\
+		schedule();						\
+		tty_lock(tty);						\
 	}								\
 	finish_wait(&wq, &__wait);					\
 } while (0)
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a67fc16..ccf0c52 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -261,12 +261,11 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
 		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
+		schedule();						\
 	}								\
 	finish_wait(&wq, &__wait);					\
 } while (0)
@@ -302,14 +301,13 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
-			ret = schedule_timeout(ret);			\
-			if (!ret)					\
-				break;					\
-			continue;					\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
 		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
 	}								\
 	if (!ret && (condition))					\
 		ret = 1;						\
@@ -439,14 +437,13 @@ do {									\
 			finish_wait(&wq, &__wait);			\
 			break;						\
 		}							\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		abort_exclusive_wait(&wq, &__wait, 			\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			abort_exclusive_wait(&wq, &__wait, 		\
 				TASK_INTERRUPTIBLE, NULL);		\
-		break;							\
+			break;						\
+		}							\
+		schedule();						\
 	}								\
 } while (0)
 
