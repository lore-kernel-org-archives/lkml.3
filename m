Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3JDRfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:35:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58854 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3JDRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:35:17 -0400
Date: Fri, 4 Oct 2013 10:34:48 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-48c2521717b39cb6904941ec2847d9775669207a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.541716442@infradead.org>
References: <20131002092528.541716442@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Collapse __wait_event_interruptible_exclusive()
Git-Commit-ID: 48c2521717b39cb6904941ec2847d9775669207a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:34:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48c2521717b39cb6904941ec2847d9775669207a
Gitweb:     http://git.kernel.org/tip/48c2521717b39cb6904941ec2847d9775669207a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:49 +0200

sched/wait: Collapse __wait_event_interruptible_exclusive()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.541716442@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a79fb15..c4ab172 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -421,26 +421,8 @@ do {									\
 })
 
 #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
-do {									\
-	__label__ __out;						\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait_exclusive(&wq, &__wait,			\
-					TASK_INTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			abort_exclusive_wait(&wq, &__wait, 		\
-				TASK_INTERRUPTIBLE, NULL);		\
-			goto __out;					\
-		}							\
-		schedule();						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-__out:	;								\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, ret,	\
+		      schedule())
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
