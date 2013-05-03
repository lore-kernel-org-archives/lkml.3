Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3ECEsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:48:51 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:58822 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3ECEst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:48:49 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/7] posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting
Date: Fri,  3 May 2013 00:47:42 -0400
Message-Id: <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When tsk->signal->cputimer->running is 1, signal->cputimer and
tsk->sum_sched_runtime increase at the same pace because update_curr()
increases both accounting.

However, there is one exception. When thread exiting, __exit_signal() turns
over task's sum_shced_runtime to sig->sum_sched_runtime, but it doesn't stop
signal->cputimer accounting.

This inconsistency makes POSIX timer wake up too early. This patch fixes it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched/stats.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..5a0cfc4 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -225,6 +225,13 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
+	/*
+	 * After turning over se.sum_exec_runtime to sig->sum_sched_runtime
+	 * in __exit_signal(), we must not account exec_runtime for consistency.
+	 */
+	if (unlikely(!tsk->sighand))
+		return;
+
 	raw_spin_lock(&cputimer->lock);
 	cputimer->cputime.sum_exec_runtime += ns;
 	raw_spin_unlock(&cputimer->lock);
-- 
1.7.1

