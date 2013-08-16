Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3HPSsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:48:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3HPSr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:47:58 -0400
Date: Fri, 16 Aug 2013 11:46:56 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, bp@alien8.de,
        paulmck@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com,
        fweisbec@gmail.com, rostedt@goodmis.org, khilman@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, bp@alien8.de,
        paulmck@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        khilman@linaro.org
In-Reply-To: <1375460996-16329-4-git-send-email-fweisbec@gmail.com>
References: <1375460996-16329-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/nohz] nohz:
  Include local CPU in full dynticks global kick
Git-Commit-ID: c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:47:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba
Gitweb:     http://git.kernel.org/tip/c2e7fcf53c3cb02b4ada1c66a9bc8a4d97d58aba
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 2 Aug 2013 18:29:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:55:33 +0200

nohz: Include local CPU in full dynticks global kick

tick_nohz_full_kick_all() is useful to notify all full dynticks
CPUs that there is a system state change to checkout before
re-evaluating the need for the tick.

Unfortunately this is implemented using smp_call_function_many()
that ignores the local CPU. This CPU also needs to re-evaluate
the tick.

on_each_cpu_mask() is not useful either because we don't want to
re-evaluate the tick state in place but asynchronously from an IPI
to avoid messing up with any random locking scenario.

So lets call tick_nohz_full_kick() from tick_nohz_full_kick_all()
so that the usual irq work takes care of it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375460996-16329-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/tick-sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index adea6fc3..3612fc7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -246,6 +246,7 @@ void tick_nohz_full_kick_all(void)
 	preempt_disable();
 	smp_call_function_many(tick_nohz_full_mask,
 			       nohz_full_kick_ipi, NULL, false);
+	tick_nohz_full_kick();
 	preempt_enable();
 }
 
