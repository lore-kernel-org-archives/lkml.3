Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3KWPik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:38:40 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:48961 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3KWPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:34 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/10] posix-timers: Use sighand lock instead of tasklist_lock for task clock sample
Date: Sat, 23 Nov 2013 16:37:17 +0100
Message-Id: <1385221040-24731-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for the tasklist_lock just to take a process
wide clock sample.

All we need is to get a coherent sample that doesn't race with
exit() and exec():

* exit() may be concurrently reaping a task and flushing its time

* sighand is unstable under exit() and exec(), and the latter also
  result in group leader that can change

To protect against these, locking the target's sighand is enough.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 7117f6d..cd56e71 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -271,12 +271,22 @@ static int posix_cpu_clock_get_task(struct task_struct *tsk,
 		if (same_thread_group(tsk, current))
 			err = cpu_clock_sample(which_clock, tsk, &rtn);
 	} else {
-		read_lock(&tasklist_lock);
+		unsigned long flags;
+		struct sighand_struct *sighand;
 
-		if (tsk->sighand && (tsk == current || thread_group_leader(tsk)))
+		/*
+		 * while_each_thread() is not yet entirely RCU safe,
+		 * keep locking the group while sampling process
+		 * clock for now.
+		 */
+		sighand = lock_task_sighand(tsk, &flags);
+		if (!sighand)
+			return err;
+
+		if (tsk == current || thread_group_leader(tsk))
 			err = cpu_clock_sample_group(which_clock, tsk, &rtn);
 
-		read_unlock(&tasklist_lock);
+		unlock_task_sighand(tsk, &flags);
 	}
 
 	if (!err)
-- 
1.8.3.1

