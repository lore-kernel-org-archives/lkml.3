Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab3GQQpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:45:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37440 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3GQQpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:45:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 13/18] vtime: Fix racy cputime delta update
Date: Wed, 17 Jul 2013 18:44:26 +0200
Message-Id: <1374079471-3129-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_vtime_delta() must be called under the task vtime_seqlock
with the code that does the cputime accounting flush.

Otherwise the cputime reader can be fooled and run into
a race where it sees the snapshot update but misses the
cputime flush. As a result it can report a cputime that is
way too short.

Fix vtime_account_user() that wasn't complying to that rule.

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
 kernel/sched/cputime.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5f273b47..b62d5c0 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -683,9 +683,10 @@ void vtime_account_irq_exit(struct task_struct *tsk)
 
 void vtime_account_user(struct task_struct *tsk)
 {
-	cputime_t delta_cpu = get_vtime_delta(tsk);
+	cputime_t delta_cpu;
 
 	write_seqlock(&tsk->vtime_seqlock);
+	delta_cpu = get_vtime_delta(tsk);
 	tsk->vtime_snap_whence = VTIME_SYS;
 	account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
 	write_sequnlock(&tsk->vtime_seqlock);
-- 
1.7.5.4

