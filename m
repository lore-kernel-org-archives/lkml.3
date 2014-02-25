Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaBYMgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:36:42 -0500
Received: from asav21.altibox.net ([109.247.116.8]:48790 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaBYMgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:39 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <henrik@austad.us>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Henrik Austad <haustad@cisco.com>
Subject: [PATCH 1/6] Expose do_timer CPU from tick-common
Date: Tue, 25 Feb 2014 13:33:56 +0100
Message-Id: <1393331641-14016-2-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393331641-14016-1-git-send-email-henrik@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows other parts of the kernel access to the tick_do_timer_cpu
variable in a controlled manner. The values will differ depending on
which mode is compiled in:

* CONFIG_HZ_PERIODIC: One (normally boot-cpu) is responsible for the
  time update. This will never change unless the CPU is removed
  (hotplugging). You will normally see a 0 returned every time here.

* CONFIG_NO_HZ_IDLE: system will disable periodic timer-interrupts on
  the cpu if only the idle-task is running. This means that the timer
  cpu will change often.

* CONFIG_NO_HZ_FULL: any CPU running only a single task can have
  timer-interrupts disabled. As for NO_HZ_IDLE, timer CPU will change
  often.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 kernel/time/tick-common.c   |   12 ++++++++++++
 kernel/time/tick-internal.h |    1 +
 2 files changed, 13 insertions(+)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 20b2fe3..1729b4b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -348,6 +348,18 @@ void tick_handover_do_timer(int *cpup)
 }
 
 /*
+ * Return the current timer-CPU (RO)
+ *
+ * Warning! this value can (and will) change depending on how timer-ticks are
+ * handled, the value returned could be outdated the moment it is read by
+ * userspace.
+ */
+int tick_expose_cpu(void)
+{
+	return tick_do_timer_cpu;
+}
+
+/*
  * Shutdown an event device on a given cpu:
  *
  * This is called on a life CPU, when a CPU is dead. So we cannot
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 8329669..5051dbd 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -154,5 +154,6 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 
 #endif
 
+extern int tick_expose_cpu(void);
 extern void do_timer(unsigned long ticks);
 extern void update_wall_time(void);
-- 
1.7.9.5

