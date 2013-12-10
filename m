Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3LJU1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:27:48 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45719 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3LJU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:27:46 -0500
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perf: POSIX CLOCK_PERF to report current time value
Date: Tue, 10 Dec 2013 13:27:39 -0700
Message-Id: <1386707259-21725-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pawel Moll <pawel.moll@arm.com>

To co-relate user space events with the perf events stream
a current (as in: "what time(stamp) is it now?") time value
must be made available.

This patch adds a POSIX clock returning the perf_clock()
value and accesible from userspace:

    #include <time.h>

    struct timespec ts;

    clock_gettime(CLOCK_PERF, &ts);

Updated to 3.13

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/uapi/linux/time.h |  1 +
 kernel/events/core.c      | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index e75e1b6ff27f..b07f07914a13 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -56,6 +56,7 @@ struct itimerval {
 #define CLOCK_BOOTTIME_ALARM		9
 #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
 #define CLOCK_TAI			11
+#define CLOCK_PERF            12
 
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 72348dc192c1..87aa36ac68f7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/posix-timers.h>
 
 #include "internal.h"
 
@@ -295,6 +296,19 @@ static inline u64 perf_clock(void)
 	return local_clock();
 }
 
+static int perf_posix_clock_getres(const clockid_t which_clock,
+		struct timespec *tp)
+{
+	*tp = ns_to_timespec(TICK_NSEC);
+	return 0;
+}
+
+static int perf_posix_clock_get(clockid_t which_clock, struct timespec *tp)
+{
+	*tp = ns_to_timespec(perf_clock());
+	return 0;
+}
+
 static inline struct perf_cpu_context *
 __get_cpu_context(struct perf_event_context *ctx)
 {
@@ -7904,6 +7918,10 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 
 void __init perf_event_init(void)
 {
+	struct k_clock perf_posix_clock = {
+		.clock_getres = perf_posix_clock_getres,
+		.clock_get = perf_posix_clock_get,
+	};
 	int ret;
 
 	idr_init(&pmu_idr);
@@ -7920,6 +7938,8 @@ void __init perf_event_init(void)
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 
+	posix_timers_register_clock(CLOCK_PERF, &perf_posix_clock);
+
 	/* do not patch jump label more than once per second */
 	jump_label_rate_limit(&perf_sched_events, HZ);
 
-- 
1.8.3.4 (Apple Git-47)

