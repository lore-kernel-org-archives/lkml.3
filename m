Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3DVTAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:07 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60568 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3DVTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:00:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/10] sched: Kick full dynticks CPU that have more than one task enqueued.
Date: Mon, 22 Apr 2013 20:59:40 +0200
Message-Id: <1366657186-20556-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kick the tick on full dynticks CPUs when they get more
than one task running on their queue. This makes sure that
local fairness is maintained by the tick on the destination.

This is done regardless of these tasks' class. We should
be able to be more clever in the future depending on these. eg:
a CPU that runs a SCHED_FIFO task doesn't need to maintain
fairness against local pending tasks of the fair class.

But keep things simple for now.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/sched.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 889904d..eb363aa 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -5,6 +5,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/tick.h>
 
 #include "cpupri.h"
 
@@ -1106,6 +1107,16 @@ static inline u64 steal_ticks(u64 steal)
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
+
+#ifdef CONFIG_NO_HZ_FULL
+	if (rq->nr_running == 2) {
+		if (tick_nohz_full_cpu(rq->cpu)) {
+			/* Order rq->nr_running write against the IPI */
+			smp_wmb();
+			smp_send_reschedule(rq->cpu);
+		}
+       }
+#endif
 }
 
 static inline void dec_nr_running(struct rq *rq)
-- 
1.7.5.4

