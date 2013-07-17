Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3GQQup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:50:45 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53505 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab3GQQpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:45:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 12/18] vtime: Remove a few unneeded generic vtime state checks
Date: Wed, 17 Jul 2013 18:44:25 +0200
Message-Id: <1374079471-3129-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some generic vtime APIs check if the vtime accounting
is enabled on the local CPU before doing their work.

Some of these are not needed because all their callers already
take care of that. Let's remove the checks on these.

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
 kernel/sched/cputime.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index bb6b29a..5f273b47 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -664,9 +664,6 @@ static void __vtime_account_system(struct task_struct *tsk)
 
 void vtime_account_system(struct task_struct *tsk)
 {
-	if (!vtime_accounting_enabled())
-		return;
-
 	write_seqlock(&tsk->vtime_seqlock);
 	__vtime_account_system(tsk);
 	write_sequnlock(&tsk->vtime_seqlock);
@@ -686,12 +683,7 @@ void vtime_account_irq_exit(struct task_struct *tsk)
 
 void vtime_account_user(struct task_struct *tsk)
 {
-	cputime_t delta_cpu;
-
-	if (!vtime_accounting_enabled())
-		return;
-
-	delta_cpu = get_vtime_delta(tsk);
+	cputime_t delta_cpu = get_vtime_delta(tsk);
 
 	write_seqlock(&tsk->vtime_seqlock);
 	tsk->vtime_snap_whence = VTIME_SYS;
@@ -701,9 +693,6 @@ void vtime_account_user(struct task_struct *tsk)
 
 void vtime_user_enter(struct task_struct *tsk)
 {
-	if (!vtime_accounting_enabled())
-		return;
-
 	write_seqlock(&tsk->vtime_seqlock);
 	tsk->vtime_snap_whence = VTIME_USER;
 	__vtime_account_system(tsk);
-- 
1.7.5.4

