Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab3B1PLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:11:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab3B1OsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/139] posix-cpu-timers: Fix nanosleep task_struct leak
Date: Thu, 28 Feb 2013 14:43:26 +0000
Message-Id: <1362062689-2567-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit e6c42c295e071dd74a66b5a9fcf4f44049888ed8 upstream.

The trinity fuzzer triggered a task_struct reference leak via
clock_nanosleep with CPU_TIMERs. do_cpu_nanosleep() calls
posic_cpu_timer_create(), but misses a corresponding
posix_cpu_timer_del() which leads to the task_struct reference leak.

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20130215100810.GF4392@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/posix-cpu-timers.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..acbb79c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1422,8 +1422,10 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		while (!signal_pending(current)) {
 			if (timer.it.cpu.expires.sched == 0) {
 				/*
-				 * Our timer fired and was reset.
+				 * Our timer fired and was reset, below
+				 * deletion can not fail.
 				 */
+				posix_cpu_timer_del(&timer);
 				spin_unlock_irq(&timer.it_lock);
 				return 0;
 			}
@@ -1441,9 +1443,26 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		 * We were interrupted by a signal.
 		 */
 		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
-		posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		if (!error) {
+			/*
+			 * Timer is now unarmed, deletion can not fail.
+			 */
+			posix_cpu_timer_del(&timer);
+		}
 		spin_unlock_irq(&timer.it_lock);
 
+		while (error == TIMER_RETRY) {
+			/*
+			 * We need to handle case when timer was or is in the
+			 * middle of firing. In other cases we already freed
+			 * resources.
+			 */
+			spin_lock_irq(&timer.it_lock);
+			error = posix_cpu_timer_del(&timer);
+			spin_unlock_irq(&timer.it_lock);
+		}
+
 		if ((it->it_value.tv_sec | it->it_value.tv_nsec) == 0) {
 			/*
 			 * It actually did fire already.
-- 
1.8.1.2

