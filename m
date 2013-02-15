Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935776Ab3BOKzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:55:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935762Ab3BOKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:55:22 -0500
Date: Fri, 15 Feb 2013 02:54:01 -0800
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
Message-ID: <tip-e6c42c295e071dd74a66b5a9fcf4f44049888ed8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davej@redhat.com, john.stultz@linaro.org, tglx@linutronix.de,
        tt.rantala@gmail.com, oleg@redhat.com, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davej@redhat.com, john.stultz@linaro.org, tglx@linutronix.de,
        tt.rantala@gmail.com, oleg@redhat.com, sgruszka@redhat.com
In-Reply-To: <20130215100810.GF4392@redhat.com>
References: <20130215100810.GF4392@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-cpu-timers:
  Fix nanosleep task_struct leak
Git-Commit-ID: e6c42c295e071dd74a66b5a9fcf4f44049888ed8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 02:54:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6c42c295e071dd74a66b5a9fcf4f44049888ed8
Gitweb:     http://git.kernel.org/tip/e6c42c295e071dd74a66b5a9fcf4f44049888ed8
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Fri, 15 Feb 2013 11:08:11 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 15 Feb 2013 11:41:56 +0100

posix-cpu-timers: Fix nanosleep task_struct leak

The trinity fuzzer triggered a task_struct reference leak via
clock_nanosleep with CPU_TIMERs. do_cpu_nanosleep() calls
posic_cpu_timer_create(), but misses a corresponding
posix_cpu_timer_del() which leads to the task_struct reference leak.

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20130215100810.GF4392@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/posix-cpu-timers.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a278cad..942ca27 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1401,8 +1401,10 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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
@@ -1420,9 +1422,26 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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
