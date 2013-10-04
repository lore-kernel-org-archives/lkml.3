Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3JDRef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:34:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3JDReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:34:31 -0400
Date: Fri, 4 Oct 2013 10:33:59 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-41a1431b178c3b731d6dfc40b987528b333dd93e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.181897111@infradead.org>
References: <20131002092528.181897111@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Introduce ___wait_event()
Git-Commit-ID: 41a1431b178c3b731d6dfc40b987528b333dd93e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:34:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41a1431b178c3b731d6dfc40b987528b333dd93e
Gitweb:     http://git.kernel.org/tip/41a1431b178c3b731d6dfc40b987528b333dd93e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:46 +0200

sched/wait: Introduce ___wait_event()

There's far too much duplication in the __wait_event macros; in order
to fix this introduce ___wait_event() a macro with the capability to
replace most other macros.

With the previous patches changing the various __wait_event*()
implementations to be more uniform; we can now collapse the lot
without also changing generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.181897111@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 7d7819d..29d0249 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -187,6 +187,42 @@ wait_queue_head_t *bit_waitqueue(void *, int);
  	__cond || !ret;							\
 })
 
+#define ___wait_signal_pending(state)					\
+	((state == TASK_INTERRUPTIBLE && signal_pending(current)) ||	\
+	 (state == TASK_KILLABLE && fatal_signal_pending(current)))
+
+#define ___wait_nop_ret		int ret __always_unused
+
+#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
+do {									\
+	__label__ __out;						\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		if (exclusive)						\
+			prepare_to_wait_exclusive(&wq, &__wait, state); \
+		else							\
+			prepare_to_wait(&wq, &__wait, state);		\
+									\
+		if (condition)						\
+			break;						\
+									\
+		if (___wait_signal_pending(state)) {			\
+			ret = -ERESTARTSYS;				\
+			if (exclusive) {				\
+				abort_exclusive_wait(&wq, &__wait, 	\
+						     state, NULL); 	\
+				goto __out;				\
+			}						\
+			break;						\
+		}							\
+									\
+		cmd;							\
+	}								\
+	finish_wait(&wq, &__wait);					\
+__out:	;								\
+} while (0)
+
 #define __wait_event(wq, condition) 					\
 do {									\
 	DEFINE_WAIT(__wait);						\
