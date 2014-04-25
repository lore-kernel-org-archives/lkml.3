Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaDYS6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaDYS6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:58:20 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] nohz: move NOHZ code bits out of io_schedule{,_timeout} into a helper
Date: Fri, 25 Apr 2014 20:57:29 +0200
Message-Id: <1398452250-6047-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ffea757..3137980 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4208,6 +4208,21 @@ EXPORT_SYMBOL_GPL(yield_to);
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
  */
+#ifdef CONFIG_NO_HZ_COMMON
+static __sched void io_wait_end(struct rq *rq)
+{
+	if (atomic_dec_and_test(&rq->nr_iowait)) {
+		if (raw_smp_processor_id() != cpu_of(rq))
+			tick_nohz_iowait_to_idle(cpu_of(rq));
+	}
+}
+#else
+static inline void io_wait_end(struct rq *rq)
+{
+	atomic_dec(&rq->nr_iowait);
+}
+#endif
+
 void __sched io_schedule(void)
 {
 	struct rq *rq = raw_rq();
@@ -4218,14 +4233,7 @@ void __sched io_schedule(void)
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
-#ifdef CONFIG_NO_HZ_COMMON
-	if (atomic_dec_and_test(&rq->nr_iowait)) {
-		if (raw_smp_processor_id() != cpu_of(rq))
-			tick_nohz_iowait_to_idle(cpu_of(rq));
-	}
-#else
-	atomic_dec(&rq->nr_iowait);
-#endif
+	io_wait_end(rq);
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -4241,14 +4249,7 @@ long __sched io_schedule_timeout(long timeout)
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
-#ifdef CONFIG_NO_HZ_COMMON
-	if (atomic_dec_and_test(&rq->nr_iowait)) {
-		if (raw_smp_processor_id() != cpu_of(rq))
-			tick_nohz_iowait_to_idle(cpu_of(rq));
-	}
-#else
-	atomic_dec(&rq->nr_iowait);
-#endif
+	io_wait_end(rq);
 	delayacct_blkio_end();
 	return ret;
 }
-- 
1.8.1.4

