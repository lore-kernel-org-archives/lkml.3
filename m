Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673Ab3DQBYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:24:13 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:39510 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933854Ab3DQBYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:24:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>
Subject: [PATCH 1/2] posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
Date: Wed, 17 Apr 2013 03:24:02 +0200
Message-Id: <1366161843-26098-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366161843-26098-1-git-send-email-fweisbec@gmail.com>
References: <1366161843-26098-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to re-arm a timer after it fired, we take a sample of the
current process or thread cputime.

If the task is dying though, we don't arm anything but we cache the
remaining timer expiration delta for further reads.

Something similar is performed in posix_cpu_timer_get() but here we forget
to take the process wide cputime sample before caching it.

As a result we are storing random stack content, leading every further
reads of that timer to return junk values.

Fix this by taking the appropriate sample in the case of process wide
timers.

This probably doesn't matter much in practice because, at this stage, the
thread is the last one in the group and we reached exit_notify(). This
implies that we called exit_itimers() and there should be no more timers
to handle for that task.

So this is likely dead code anyway but let's fix the current logic
and the warning that came along:

    kernel/posix-cpu-timers.c: In function 'posix_cpu_timer_schedule':
    kernel/posix-cpu-timers.c:1127: warning: 'now' may be used uninitialized in this function

Then we can start to think further about cleaning up that code.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index edf94b6..afd79a9 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1062,6 +1062,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			 * not yet reaped.  Take this opportunity to
 			 * drop our task ref.
 			 */
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
-- 
1.7.5.4

