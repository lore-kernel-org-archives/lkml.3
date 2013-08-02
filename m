Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3HBQaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:30:20 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50338 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3HBQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:30:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3/3] nohz: Include local CPU in full dynticks global kick
Date: Fri,  2 Aug 2013 18:29:56 +0200
Message-Id: <1375460996-16329-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
References: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_nohz_full_kick_all() is useful to notify all full dynticks
CPUs that there is a system state change to checkout before
re-evaluating the need for the tick.

Unfortunately this is implemented using smp_call_function_many()
that ignores the local CPU. This CPU also needs to re-evaluate
the tick.

on_each_cpu_mask() is not useful either because we don't want to
re-evaluate the tick state in place but asynchronously from an IPI
to avoid messing up with any random locking scenario.

Sol lets call tick_nohz_full_kick() from tick_nohz_full_kick_all()
so that the usual irq work takes care of it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
---
 kernel/time/tick-sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e80183f..30849d4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -244,6 +244,7 @@ void tick_nohz_full_kick_all(void)
 	preempt_disable();
 	smp_call_function_many(nohz_full_mask,
 			       nohz_full_kick_ipi, NULL, false);
+	tick_nohz_full_kick();
 	preempt_enable();
 }
 
-- 
1.7.5.4

