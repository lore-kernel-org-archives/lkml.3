Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaKDA3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:29:08 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52449 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaKDA3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:29:02 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v3 1/3] perf: Use monotonic clock as a source for timestamps
Date: Tue,  4 Nov 2014 00:28:36 +0000
Message-Id: <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, perf framework never defined the meaning of the timestampt
captured as PERF_SAMPLE_TIME sample type. The values were obtaining
from local (sched) clock, which is unavailable in userspace. This made
it impossible to correlate perf data with any other events. Other
tracing solutions have the source configurable (ftrace) or just share
a common time domain between kernel and userspace (LTTng).

Follow the trend by using monotonic clock, which is readily available
as POSIX CLOCK_MONOTONIC.

Also add a sysctl "perf_sample_time_clk_id" attribute which can be used
by the user to obtain the clk_id to be used with POSIX clock API (eg.
clock_gettime()) to obtain a time value comparable with perf samples.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

Ingo, I remember your comments about this approach in the past, but
during discussions at LPC Thomas was convinced that it's the right
thing to do - see cover letter for the series...

 include/linux/perf_event.h | 1 +
 kernel/events/core.c       | 4 +++-
 kernel/sysctl.c            | 7 +++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d0..ba490d5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -738,6 +738,7 @@ extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 extern int sysctl_perf_cpu_time_max_percent;
+extern int sysctl_perf_sample_time_clk_id;
 
 extern void perf_sample_event_took(u64 sample_len_ns);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2b02c9f..ea3d6d3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -234,6 +234,8 @@ int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
 	return 0;
 }
 
+int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;
+
 /*
  * perf samples are done in some very critical code paths (NMIs).
  * If they take too much CPU time, the system can lock up and not
@@ -324,7 +326,7 @@ extern __weak const char *perf_pmu_name(void)
 
 static inline u64 perf_clock(void)
 {
-	return local_clock();
+	return ktime_get_mono_fast_ns();
 }
 
 static inline struct perf_cpu_context *
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 15f2511..cb75f5b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1094,6 +1094,13 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+	{
+		.procname	= "perf_sample_time_clk_id",
+		.data		= &sysctl_perf_sample_time_clk_id,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
-- 
1.8.3.2

