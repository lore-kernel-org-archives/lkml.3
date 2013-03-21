Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3CUVxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33033 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab3CUVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:00 -0400
Message-Id: <20130321215233.518839807@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:52:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 03/34] idle: Implement set/clr functions for need_resched poll
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline;
 filename=smpboot-implement-need-resched-polling-helpers.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement set/clear functions for the idle need_resched poll
implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2473,7 +2473,7 @@ static inline unsigned long *end_of_stac
 #endif
 
 /*
- * Idle thread specific functions to determine the need_resched
+ * Idle thread specific functions for the the need_resched
  * polling state. We have two versions, one based on TS_POLLING in
  * thread_info.status and one based on TIF_POLLING_NRFLAG in
  * thread_info.flags
@@ -2483,13 +2483,34 @@ static inline int tsk_is_polling(struct 
 {
 	return task_thread_info(p)->status & TS_POLLING;
 }
+static inline void current_set_polling(void)
+{
+	current_thread_info()->status |= TS_POLLING;
+}
+
+static inline void current_clr_polling(void)
+{
+	current_thread_info()->status &= ~TS_POLLING;
+	smp_mb__after_clear_bit();
+}
 #elif defined(TIF_POLLING_NRFLAG)
 static inline int tsk_is_polling(struct task_struct *p)
 {
 	test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
 }
+static inline void current_set_polling(void)
+{
+	set_thread_flag(TIF_POLLING_NRFLAG);
+}
+
+static inline void current_clr_polling(void)
+{
+	clear_thread_flag(TIF_POLLING_NRFLAG);
+}
 #else
 static inline int tsk_is_polling(struct task_struct *p) { return 0; }
+static inline void current_set_polling(void) { }
+static inline void current_clr_polling(void) { }
 #endif
 
 static inline int object_is_on_stack(void *obj)


