Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967587Ab3DRRYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:24:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38333 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967131Ab3DRRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:23:58 -0400
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
Subject: [PATCH 2/3] posix_timers: Defer per process timer stop after timers processing
Date: Thu, 18 Apr 2013 19:23:41 +0200
Message-Id: <1366305822-5499-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we process the posix cpu timers from the tick, we run through
two passes:

1) get the timers that want to fire and walk through the remaining
ones in order to set the next expiry time.

2) execute the firing timers and possibly reschedule some of them and
thus update the next expiry time again.

If there are no more timers in the queue after the firing ones in the
first pass, we may call stop_process_timers() there. If some firing
timers are rescheduled in the second pass, this leaves a tiny frame
where it is considered we have no process timers running, while we
are going to re-enqueue some.

This is a problem if there are full dynticks CPUs around. Having posix CPU
timers running is one of the reasons for full dynticks CPU to
prevent from stopping their tick. If they see this tiny frame clear of
timers by verifying that sig->cputimer.running == 0, they may stop their tick.

One solution would be to send these CPUs a notification if we re-enqueue
timers in the second pass so that they restart their tick accordingly. But
it looks like a hammer.

The other solution is to defer the call to stop_process_timers() after
the second pass once we are really sure that no more timers are in the queue
by the very end of the posix cpu timers processing.

This perhaps implies a little more contention against threadgroup lock and
sig->cputimer.lock if some other CPUs are concurrently checking the process
timers while we are executing those that fired. But this is probably not a big
issue in practice.

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
 kernel/posix-cpu-timers.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..3b73ae8 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1130,8 +1130,6 @@ static void check_process_timers(struct task_struct *tsk,
 	sig->cputime_expires.prof_exp = prof_expires;
 	sig->cputime_expires.virt_exp = virt_expires;
 	sig->cputime_expires.sched_exp = sched_expires;
-	if (task_cputime_zero(&sig->cputime_expires))
-		stop_process_timers(sig);
 }
 
 /*
@@ -1279,6 +1277,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
 	unsigned long flags;
+	struct signal_struct *sig;
 
 	BUG_ON(!irqs_disabled());
 
@@ -1336,6 +1335,10 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 			cpu_timer_fire(timer);
 		spin_unlock(&timer->it_lock);
 	}
+
+	sig = tsk->signal;
+	if (task_cputime_zero(&sig->cputime_expires))
+		stop_process_timers(sig);
 }
 
 /*
-- 
1.7.5.4

