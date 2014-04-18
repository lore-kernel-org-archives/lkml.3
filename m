Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaDRNZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaDRNGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:06:53 -0400
Date: Fri, 18 Apr 2014 06:06:21 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-o2ro6f3vkxklni0bc8f7m68s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait:
  Explain the shadowing and type inconsistencies
Git-Commit-ID: 27e4f9d0012a9bb7011aade862f08679d2921ab0
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

Commit-ID:  27e4f9d0012a9bb7011aade862f08679d2921ab0
Gitweb:     http://git.kernel.org/tip/27e4f9d0012a9bb7011aade862f08679d2921ab0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 9 Apr 2014 12:50:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:22 +0200

sched/wait: Explain the shadowing and type inconsistencies

Stick in a comment before someone else tries to fix the sparse warning
this generates.

Requested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-o2ro6f3vkxklni0bc8f7m68s@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c..2b563a1 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -191,11 +191,23 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 	(!__builtin_constant_p(state) ||				\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
+/*
+ * The below macro ___wait_event() has an explicit shadow of the __ret
+ * variable when used from the wait_event_*() macros.
+ *
+ * This is so that both can use the ___wait_cond_timeout() construct
+ * to wrap the condition.
+ *
+ * The type inconsistency of the wait_event_*() __ret variable is also
+ * on purpose; we use long where we can return timeout values and int
+ * otherwise.
+ */
+
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long __ret = ret;						\
+	long __ret = ret;	/* explicit shadow */			\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
