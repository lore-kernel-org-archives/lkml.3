Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3CNT5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:57:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59949 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3CNT5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:57:06 -0400
Message-ID: <1363291021.3100.144.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Thu, 14 Mar 2013 19:57:01 +0000
In-Reply-To: <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	 <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	 <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Mar 2013 19:57:02.0002 (UTC) FILETIME=[1829C920:01CE20EE]
X-MC-Unique: 113031419570305201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 15:34 +0000, Stephane Eranian wrote:
> > Well, the timestamps themselves are already exposed to userspace
> > through the ftrace and perf data logs. All people want is to add
> > secondary data stream in the same time-line.
> >
> I agree with Peter on this. The timestamps are already visible.
> All we need is the ability to generate them for another user-level
> level data stream.

Ok, how about the code below? I must say I have some doubts about the
resolution, as there seem to be no generic way of figuring it out for
the sched_clock (the arch/arm/kernel/sched_clock.c is actually
calculating it, but than just prints it out and nothing more).

And, to summarize, we went through 3 ideas:

1. ioctl() - http://article.gmane.org/gmane.linux.kernel/1433933
2. syscall - http://article.gmane.org/gmane.linux.kernel/1437057
3. POSIX clock - below

John also suggested that maybe the perf could use CLOCK_MONOTONIC_RAW
instead of local/sched_clock().

How about a final decision?

Regards

Pawel

8<--------------------
>From c986492d38156f1fc25ab3182f0a494bb13389ce Mon Sep 17 00:00:00 2001
From: Pawel Moll <pawel.moll@arm.com>
Date: Thu, 14 Mar 2013 19:49:09 +0000
Subject: [PATCH] perf: POSIX CLOCK_PERF to report current time value

To co-relate user space events with the perf events stream
a current (as in: "what time(stamp) is it now?") time value
must be made available.

This patch adds a POSIX clock returning the perf_clock()
value and accesible from userspace:

	#include <time.h>

	struct timespec ts;

	clock_gettime(CLOCK_PERF, &ts);

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/uapi/linux/time.h |    1 +
 kernel/events/core.c      |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index 0d3c0ed..cea16b0 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -54,6 +54,7 @@ struct itimerval {
 #define CLOCK_BOOTTIME			7
 #define CLOCK_REALTIME_ALARM		8
 #define CLOCK_BOOTTIME_ALARM		9
+#define CLOCK_PERF			10
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..81ca459 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -37,6 +37,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
+#include <linux/posix-timers.h>
 
 #include "internal.h"
 
@@ -209,6 +210,19 @@ static inline u64 perf_clock(void)
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
@@ -7391,6 +7405,10 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 
 void __init perf_event_init(void)
 {
+	struct k_clock perf_posix_clock = {
+		.clock_getres = perf_posix_clock_getres,
+		.clock_get = perf_posix_clock_get,
+	};
 	int ret;
 
 	idr_init(&pmu_idr);
@@ -7407,6 +7425,8 @@ void __init perf_event_init(void)
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 
+	posix_timers_register_clock(CLOCK_PERF, &perf_posix_clock);
+
 	/* do not patch jump label more than once per second */
 	jump_label_rate_limit(&perf_sched_events, HZ);
 
-- 
1.7.10.4




