Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3JDRfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:35:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3JDRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:35:12 -0400
Date: Fri, 4 Oct 2013 10:34:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c2ebb1fb4eddf3d1d66fe31d1e89e83ee211b81c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.469616907@infradead.org>
References: <20131002092528.469616907@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Collapse __wait_event_interruptible_timeout()
Git-Commit-ID: c2ebb1fb4eddf3d1d66fe31d1e89e83ee211b81c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:34:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2ebb1fb4eddf3d1d66fe31d1e89e83ee211b81c
Gitweb:     http://git.kernel.org/tip/c2ebb1fb4eddf3d1d66fe31d1e89e83ee211b81c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:49 +0200

sched/wait: Collapse __wait_event_interruptible_timeout()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.469616907@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 39e4bbd..a79fb15 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -304,21 +304,9 @@ do {									\
 })
 
 #define __wait_event_interruptible_timeout(wq, condition, ret)		\
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
-		ret = schedule_timeout(ret);				\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, ___wait_cond_timeout(condition, ret),		\
+		      TASK_INTERRUPTIBLE, 0, ret,			\
+		      ret = schedule_timeout(ret))
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
