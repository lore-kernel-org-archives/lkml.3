Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaBUR5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:57:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:42643 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaBUR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:56:08 -0500
Message-Id: <20140221174639.769401182@linutronix.de>
User-Agent: quilt/0.60-1
Date: Fri, 21 Feb 2014 17:56:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [RFC patch 4/5] posix-timers: Expose deferrable mode to user space
References: <20140221173936.583477951@linutronix.de>
Content-Disposition: inline; filename=posix-timer-wire-up-deferrables.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the deferrable timer mode to user space by adding a new
TIMER_IS_DEFERRABLE flag.

The deferrable mode is available for the syscalls clock_nanosleep()
and timer_settime(). For both syscalls TIMER_IS_DEFERRABLE is handed
in via the 'flags' argument. TIMER_ABSTIME and TIMER_IS_DEFERRABLE can
be ored together.

If a timer is started with this flag, the expiry of the timer is
relaxed. The timer is guaranteed to not expire before the given expiry
time, but the expiry can be delayed to the point where a non
deferrable timer expires. Deferred timers are not waking up a cpu from
a deep idle period.

Applications using the TIMER_IS_DEFERRABLE flag work on older kernels
as well, but the timers won't have the deferrable functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 include/uapi/linux/time.h |    4 ++++
 kernel/posix-timers.c     |   10 +++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: tip/include/uapi/linux/time.h
===================================================================
--- tip.orig/include/uapi/linux/time.h
+++ tip/include/uapi/linux/time.h
@@ -63,7 +63,11 @@ struct itimerval {
 
 /*
  * The various flags for setting POSIX.1b interval timers:
+ *
+ * We keep that in sync with the TFD_TIMER_ flags
  */
 #define TIMER_ABSTIME			0x01
+/* Reserved for TFD_ONLY flag		0x02 */
+#define TIMER_IS_DEFERRABLE		0x04
 
 #endif /* _UAPI_LINUX_TIME_H */
Index: tip/kernel/posix-timers.c
===================================================================
--- tip.orig/kernel/posix-timers.c
+++ tip/kernel/posix-timers.c
@@ -846,6 +846,7 @@ common_timer_set(struct k_itimer *timr,
 		return 0;
 
 	mode = flags & TIMER_ABSTIME ? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
+	mode |= flags & TIMER_DEFERRABLE ? HRTIMER_MODE_DEFERRABLE : 0;
 	hrtimer_init(&timr->it.real.timer, timr->it_clock, mode);
 	timr->it.real.timer.function = posix_timer_fn;
 
@@ -1079,9 +1080,12 @@ SYSCALL_DEFINE2(clock_getres, const cloc
 static int common_nsleep(const clockid_t which_clock, int flags,
 			 struct timespec *tsave, struct timespec __user *rmtp)
 {
-	return hrtimer_nanosleep(tsave, rmtp, flags & TIMER_ABSTIME ?
-				 HRTIMER_MODE_ABS : HRTIMER_MODE_REL,
-				 which_clock);
+	enum hrtimer_mode mode;
+
+	mode = flags & TIMER_ABSTIME ? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
+	mode |= flags & TIMER_DEFERRABLE ? HRTIMER_MODE_DEFERRABLE : 0;
+
+	return hrtimer_nanosleep(tsave, rmtp, mode, which_clock);
 }
 
 SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,


