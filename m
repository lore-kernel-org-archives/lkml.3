Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaBUR5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:57:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:42652 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbaBUR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:56:09 -0500
Message-Id: <20140221174639.888426320@linutronix.de>
User-Agent: quilt/0.60-1
Date: Fri, 21 Feb 2014 17:56:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [RFC patch 5/5] timerfd: Expose deferrable mode to user space
References: <20140221173936.583477951@linutronix.de>
Content-Disposition: inline; filename=timerfd-wire-up-deferrables.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the deferrable timer mode to user space by adding a new
TDF_TIMER_DEFERRABLE flag.

The deferrable mode is available through the syscall timerfd_settime()
by handing in TDF_TIMER_IS_DEFERRABLE via the 'flags' argument.
TFD_TIMER_IS_DEFERRABLE and the other TFD_TIMER_ flags can be ored
together.

If a timer is started with this flag, the expiry of the timer is
relaxed. The timer is guaranteed to not expire before the given expiry
time, but the expiry can be delayed to the point where a non
deferrable timer expires. Deferred timers are not waking up a cpu from
a deep idle period.

Applications using the TFD_TIMER_IS_DEFERRABLE flag work on older kernels
as well, but the timers won't have the deferrable functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 fs/timerfd.c            |    1 +
 include/linux/timerfd.h |    1 +
 2 files changed, 2 insertions(+)

Index: tip/fs/timerfd.c
===================================================================
--- tip.orig/fs/timerfd.c
+++ tip/fs/timerfd.c
@@ -166,6 +166,7 @@ static int timerfd_setup(struct timerfd_
 
 	htmode = (flags & TFD_TIMER_ABSTIME) ?
 		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
+	htmode |= (flags & TFD_TIMER_DEFERRABLE) ? HRTIMER_MODE_DEFERRABLE : 0;
 
 	texp = timespec_to_ktime(ktmr->it_value);
 	ctx->expired = 0;
Index: tip/include/linux/timerfd.h
===================================================================
--- tip.orig/include/linux/timerfd.h
+++ tip/include/linux/timerfd.h
@@ -20,6 +20,7 @@
  */
 #define TFD_TIMER_ABSTIME (1 << 0)
 #define TFD_TIMER_CANCEL_ON_SET (1 << 1)
+#define TFD_TIMER_DEFERRABLE (2 << 1)
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 


