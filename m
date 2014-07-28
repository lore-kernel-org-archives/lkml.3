Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaG1I3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:29:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaG1I3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:29:14 -0400
Date: Mon, 28 Jul 2014 01:28:10 -0700
From: tip-bot for Daniel Bristot de Oliveira <tipbot@zytor.com>
Message-ID: <tip-d8d28c8f00e84a72e8bee39a85835635417bee49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bristot@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bristot@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com>
References: <9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix sched_setparam() policy == -1 logic
Git-Commit-ID: d8d28c8f00e84a72e8bee39a85835635417bee49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d28c8f00e84a72e8bee39a85835635417bee49
Gitweb:     http://git.kernel.org/tip/d8d28c8f00e84a72e8bee39a85835635417bee49
Author:     Daniel Bristot de Oliveira <bristot@redhat.com>
AuthorDate: Tue, 22 Jul 2014 23:27:41 -0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Jul 2014 10:00:08 +0200

sched: Fix sched_setparam() policy == -1 logic

The scheduler uses policy == -1 to preserve the current policy state to
implement sched_setparam(). But, as (int) -1 is equals to 0xffffffff,
it's matching the if (policy & SCHED_RESET_ON_FORK) on
_sched_setscheduler(). This match changes the policy value to an
invalid value, breaking the sched_setparam() syscall.

This patch checks policy == -1 before check the SCHED_RESET_ON_FORK flag.

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

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org> # 3.14+
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Fixes: 7479f3c9cf67 "sched: Move SCHED_RESET_ON_FORK into attr::sched_flags"
Link: http://lkml.kernel.org/r/9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
