Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbbAUU3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:29:11 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40537 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbbAUU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:29:03 -0500
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
Subject: [PATCH v5] perf: Use monotonic clock as a source for timestamps
Date: Wed, 21 Jan 2015 20:27:17 +0000
Message-Id: <1421872037-12559-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
References: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, perf framework never defined the meaning of the timestamps
captured as PERF_SAMPLE_TIME sample type. The values were obtaining
from local (sched) clock, which is unavailable in userspace. This made
it impossible to correlate perf data with any other events. Other
tracing solutions have the source configurable (ftrace) or just share
a common time domain between kernel and userspace (LTTng).

Follow the trend by using monotonic clock, which is readily available
as POSIX CLOCK_MONOTONIC.

Also add a sysctl "perf_sample_time_clk_id" attribute (usually available
as "/proc/sys/kernel/perf_sample_time_clk_id") which can be used by the
user to obtain the clk_id to be used with POSIX clock API (eg.
clock_gettime()) to obtain a time value comparable with perf samples.

Old behaviour can be restored by using "perf_use_local_clock" kernel
parameter.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
Changes since v4:

- using jump labels to reduce runtime overhead of the local/mono check

 Documentation/kernel-parameters.txt |  9 ++++++++
 kernel/events/core.c                | 43 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4df73da..3cccd0e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -91,6 +91,7 @@ parameter is applicable:
 	NUMA	NUMA support is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PERF	Performance events and counters support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
@@ -2795,6 +2796,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			allocator.  This parameter is primarily	for debugging
 			and performance comparison.
 
+	perf_use_local_clock
+			[PERF]
+			Use local_clock() as a source for perf timestamps
+			generation. This was be the default behaviour and
+			this parameter can be used to maintain backward
+			compatibility or on older hardware with expensive
+			monotonic clock source.
+
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 882f835..f45434d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -42,6 +42,8 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/compat.h>
+#include <linux/sysctl.h>
+#include <linux/jump_label.h>
 
 #include "internal.h"
 
@@ -322,9 +324,43 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
+static struct static_key perf_use_local_clock_key = STATIC_KEY_INIT_FALSE;
+static bool perf_use_local_clock_param __initdata;
+static int __init perf_use_local_clock_setup(char *__unused)
+{
+	perf_use_local_clock_param = true;
+	return 1;
+}
+__setup("perf_use_local_clock", perf_use_local_clock_setup);
+
+static int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;
+
+static struct ctl_table perf_sample_time_kern_table[] = {
+	{
+		.procname       = "perf_sample_time_clk_id",
+		.data           = &sysctl_perf_sample_time_clk_id,
+		.maxlen         = sizeof(int),
+		.mode           = 0444,
+		.proc_handler   = proc_dointvec,
+	},
+	{}
+};
+
+static struct ctl_table perf_sample_time_root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= perf_sample_time_kern_table,
+	},
+	{}
+};
+
 static inline u64 perf_clock(void)
 {
-	return local_clock();
+	if (static_key_false(&perf_use_local_clock_key))
+		return local_clock();
+	else
+		return ktime_get_mono_fast_ns();
 }
 
 static inline struct perf_cpu_context *
@@ -8271,6 +8307,11 @@ void __init perf_event_init(void)
 	 */
 	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
 		     != 1024);
+
+	if (perf_use_local_clock_param)
+		static_key_slow_inc(&perf_use_local_clock_key);
+	else
+		register_sysctl_table(perf_sample_time_root_table);
 }
 
 static int __init perf_event_sysfs_init(void)
-- 
2.1.0

