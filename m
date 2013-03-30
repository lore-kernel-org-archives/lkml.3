Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3C3NQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:16:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34847 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3C3NPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:15:41 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, Chen Gang <gang.chen@asianux.com>
Subject: [PATCH 1/3] posix-timers: Correctly get dying task time sample in posix_cpu_timer_schedule()
Date: Sat, 30 Mar 2013 14:15:29 +0100
Message-Id: <1364649331-30940-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to arm the next timer to schedule, we take a sample of the
current process or thread cputime.

If the task is dying though, we don't arm anything but we
cache the remaining timer expiration delta for further reads.

Something similar is performed in posix_cpu_timer_get() but
here we forget to take the process wide cputime sample
before caching it.

As a result we are storing random stack content, leading
every further reads of that timer to return junk values.

Fix this by taking the appropriate sample in the case of
process wide timers.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Gang <gang.chen@asianux.com>
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

