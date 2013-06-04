Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3FDXQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:16:01 -0400
Received: from 1wt.eu ([62.212.114.60]:35407 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab3FDWmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:15 -0400
Message-Id: <20130604172130.512168216@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 005/184] posix-cpu-timers: Fix nanosleep task_struct leak
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/posix-cpu-timers.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..ea83f5d 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1537,8 +1537,10 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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
@@ -1556,9 +1558,26 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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
1.7.12.2.21.g234cd45.dirty



