Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3GDQro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:47:44 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45490 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3GDQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:46:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/7] posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
Date: Thu,  4 Jul 2013 18:46:23 +0200
Message-Id: <1372956385-25396-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
References: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to re-arm a timer after it fired, we take a sample of the current
process or thread cputime.

If the task is dying though, we don't arm anything but we cache the
remaining timer expiration delta for further reads.

Something similar is performed in posix_cpu_timer_get() but here we forget
to take the process wide cputime sample before caching it.

As a result we are storing random stack content, leading every further
reads of that timer to return junk values.

Fix this by taking the appropriate sample in the case of process wide
timers.

This probably doesn't matter much in practice because, at this stage, the
thread is the last one in the group and we reached exit_notify().  This
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
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 92a4fbf..4ebd8ad 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1097,6 +1097,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			 * not yet reaped.  Take this opportunity to
 			 * drop our task ref.
 			 */
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
-- 
1.7.5.4

