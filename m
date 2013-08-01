Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3HAAcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:32:21 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42931 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3HAAcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:32:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 20/23] vtime: Always debug check snapshot source _before_ updating it
Date: Thu,  1 Aug 2013 02:31:37 +0200
Message-Id: <1375317100-20651-21-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vtime delta update performed by get_vtime_delta() always check
that the source of the snapshot is valid.

Meanhile the snapshot updaters that rely on get_vtime_delta() also
set the new snapshot origin. But some of them do this right before
the call to get_vtime_delta(), making its debug check useless.

This is easily fixable by moving the snapshot origin update after
the call to get_vtime_delta(). The order doesn't matter there.

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
 kernel/sched/cputime.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e9e742e..c1d7493 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -660,9 +660,9 @@ void vtime_account_system(struct task_struct *tsk)
 void vtime_gen_account_irq_exit(struct task_struct *tsk)
 {
 	write_seqlock(&tsk->vtime_seqlock);
+	__vtime_account_system(tsk);
 	if (context_tracking_in_user())
 		tsk->vtime_snap_whence = VTIME_USER;
-	__vtime_account_system(tsk);
 	write_sequnlock(&tsk->vtime_seqlock);
 }
 
@@ -680,8 +680,8 @@ void vtime_account_user(struct task_struct *tsk)
 void vtime_user_enter(struct task_struct *tsk)
 {
 	write_seqlock(&tsk->vtime_seqlock);
-	tsk->vtime_snap_whence = VTIME_USER;
 	__vtime_account_system(tsk);
+	tsk->vtime_snap_whence = VTIME_USER;
 	write_sequnlock(&tsk->vtime_seqlock);
 }
 
-- 
1.7.5.4

