Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JBJvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:51:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41069 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3JBJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:41 -0400
Message-Id: <20131002092528.181897111@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/16] sched/wait: Introduce ___wait_event()
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate-0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's far too much duplication in the __wait_event macros; in order
to fix this introduce ___wait_event() a macro with the capability to
replace most other macros.

With the previous patches changing the various __wait_event*()
implementations to be more uniform; we can now collapse the lot
without also changing generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/wait.h |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -187,6 +187,42 @@ wait_queue_head_t *bit_waitqueue(void *,
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


