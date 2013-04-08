Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab3DHUK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:10:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DHUK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:10:57 -0400
Date: Mon, 8 Apr 2013 13:10:32 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-3a98f871ecaf44806e188184332c3fec27c8f08c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20130321215233.518839807@linutronix.de>
References: <20130321215233.518839807@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] idle: Implement set/
 clr functions for need_resched poll
Git-Commit-ID: 3a98f871ecaf44806e188184332c3fec27c8f08c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:10:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a98f871ecaf44806e188184332c3fec27c8f08c
Gitweb:     http://git.kernel.org/tip/3a98f871ecaf44806e188184332c3fec27c8f08c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:33 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:22 +0200

idle: Implement set/clr functions for need_resched poll

Implement set/clear functions for the idle need_resched poll
implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130321215233.518839807@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6709a58..21fe9a1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2632,13 +2632,34 @@ static inline int tsk_is_polling(struct task_struct *p)
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
 	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
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
 
 /*
