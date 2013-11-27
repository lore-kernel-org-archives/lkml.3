Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3K0OIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:08:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3K0OIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:08:13 -0500
Date: Wed, 27 Nov 2013 06:07:23 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-32e475d76a3e40879cd9ee4f69b19615062280d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tony.luck@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@gmail.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Expose preempt_schedule_irq()
Git-Commit-ID: 32e475d76a3e40879cd9ee4f69b19615062280d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:07:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32e475d76a3e40879cd9ee4f69b19615062280d7
Gitweb:     http://git.kernel.org/tip/32e475d76a3e40879cd9ee4f69b19615062280d7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Nov 2013 12:41:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:04:53 +0100

sched: Expose preempt_schedule_irq()

Tony reported that aa0d53260596 ("ia64: Use preempt_schedule_irq")
broke PREEMPT=n builds on ia64.

Ok, wrapped my brain around it. I tripped over the magic asm foo which
has a single need_resched check and schedule point for both sys call
return and interrupt return.

So you need the schedule_preempt_irq() for kernel preemption from
interrupt return while on a normal syscall preemption a schedule would
be sufficient. But using schedule_preempt_irq() is not harmful here in
any way. It just sets the preempt_active bit also in cases where it
would not be required.

Even on preempt=n kernels adding the preempt_active bit is completely
harmless. So instead of having an extra function, moving the existing
one out of the ifdef PREEMPT looks like the sanest thing to do.

It would also allow getting rid of various other sti/schedule/cli asm
magic in other archs.

Reported-and-Tested-by: Tony Luck <tony.luck@gmail.com>
Fixes: aa0d53260596 ("ia64: Use preempt_schedule_irq")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[slightly edited Changelog]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 718730d..e85cda2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2660,6 +2660,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 	} while (need_resched());
 }
 EXPORT_SYMBOL(preempt_schedule);
+#endif /* CONFIG_PREEMPT */
 
 /*
  * this is the entry point to schedule() from kernel preemption
@@ -2693,8 +2694,6 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	exception_exit(prev_state);
 }
 
-#endif /* CONFIG_PREEMPT */
-
 int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 			  void *key)
 {
