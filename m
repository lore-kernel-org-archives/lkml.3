Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3LCOiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:38:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37728 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3LCOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:38:39 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/6] posix-timers: Spare workqueue if there is no full dynticks CPU to kick
Date: Tue,  3 Dec 2013 15:38:25 +0100
Message-Id: <1386081506-24358-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
References: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a posix cpu timer is set, a workqueue is scheduled in order to
kick the full dynticks CPUs and let them restart their tick if
necessary in case the task they are running is concerned by the
new timer.

This kick is implemented by way of IPIs, which require interrupts
to be enabled, hence the need for a workqueue to raise them because
the posix cpu timer set path has interrupts disabled.

Now if there is no full dynticks CPU on the system, the workqueue is
still scheduled but it simply won't send any IPI and return immediately.

So lets spare that worqueue when it is not needed.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/posix-cpu-timers.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c7f31aa..35509c5 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -608,7 +608,8 @@ static DECLARE_WORK(nohz_kick_work, nohz_kick_work_fn);
  */
 static void posix_cpu_timer_kick_nohz(void)
 {
-	schedule_work(&nohz_kick_work);
+	if (context_tracking_is_enabled())
+		schedule_work(&nohz_kick_work);
 }
 
 bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk)
-- 
1.8.3.1

