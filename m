Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3ETQCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:02:18 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57136 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab3ETQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/8] nohz: Fix notifier return val that enforce timekeeping
Date: Mon, 20 May 2013 18:01:53 +0200
Message-Id: <1369065716-22801-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

In tick_nohz_cpu_down_callback() if the cpu is the one handling
timekeeping , we must return something that stops the CPU_DOWN_PREPARE
notifiers and then start notify CPU_DOWN_FAILED on the already called
notifier call backs.

However traditional errno values are not handled by the notifier unless
these are encapsulated using errno_to_notifier().

Hence the current -EINVAL is misinterpreted and converted to junk after
notifier_to_errno(), leaving the notifier subsystem to random behaviour
such as eventually allowing the cpu to go down.

Fix this by using the standard NOTIFY_BAD instead.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cfc798b..58d8d4d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -311,7 +311,7 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 		 * we can't safely shutdown that CPU.
 		 */
 		if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
-			return -EINVAL;
+			return NOTIFY_BAD;
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.7.5.4

