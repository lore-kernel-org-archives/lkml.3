Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaGWC3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaGWC33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:29:29 -0400
From: Daniel Bristot de Oliveira <bristot@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, rostedt@goodmis.org
Subject: [PATCH] sched: fix sched_setparam() policy=-1 logic
Date: Tue, 22 Jul 2014 23:27:41 -0300
Message-Id: <9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler uses policy=-1 to preserve the current policy state to
implement sched_setparam(). But, as (int) -1 is equals to 0xffffffff,
it's matching the if (policy & SCHED_RESET_ON_FORK) on
_sched_setscheduler(). This match changes the policy value to an
invalid value, breaking the sched_setparam() syscall.

This patch checks policy=-1 before check the SCHED_RESET_ON_FORK flag.

The following program shows the bug:

int main(void)
{
	struct sched_param param = {
		.sched_priority = 5,
	};

	sched_setscheduler(0, SCHED_FIFO, &param);
	param.sched_priority = 1;
	sched_setparam(0, &param);
	param.sched_priority = 0;
	sched_getparam(0, &param);
	if (param.sched_priority != 1)
		printf("failed priority setting (found %d instead of 1)\n",
			param.sched_priority);
	else
		printf("priority setting fine\n");
}

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # 3.14+
Fixes: 7479f3c9cf67 "sched: Move SCHED_RESET_ON_FORK into attr::sched_flags"
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>

---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..0acf96b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3558,9 +3558,10 @@ static int _sched_setscheduler(struct task_struct *p, int policy,
 	};
 
 	/*
-	 * Fixup the legacy SCHED_RESET_ON_FORK hack
+	 * Fixup the legacy SCHED_RESET_ON_FORK hack, except if
+	 * the policy=-1 was passed by sched_setparam().
 	 */
-	if (policy & SCHED_RESET_ON_FORK) {
+	if ((policy != -1) && (policy & SCHED_RESET_ON_FORK)) {
 		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
 		policy &= ~SCHED_RESET_ON_FORK;
 		attr.sched_policy = policy;
-- 
1.9.3

