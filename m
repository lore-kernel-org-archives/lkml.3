Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3BVF5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:57:00 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60266 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3BVF4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:56:54 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 2/2] cpustat: convert to atomic operations
Date: Thu, 21 Feb 2013 21:56:44 -0800
Message-Id: <1361512604-2720-3-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361512604-2720-1-git-send-email-khilman@linaro.org>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For non 64-bit platforms, convert cpustat fields to atomic64 type so
reads and udpates of cpustats are atomic on those platforms as well.

For 64-bit platforms, the cpustat field is left as u64 because on
64-bit, using atomic64_add will have the additional overhead of a lock.
We could also have used atomic64_set(atomic64_read() + delta), but on
32-bit platforms using the generic 64-bit ops (lib/atomic64.c), that
results in taking a lock twice.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 include/linux/kernel_stat.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index df8ad75..a433f87 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -32,7 +32,11 @@ enum cpu_usage_stat {
 };
 
 struct kernel_cpustat {
+#ifdef CONFIG_64BIT
 	u64 _cpustat[NR_STATS];
+#else
+	atomic64_t _cpustat[NR_STATS];
+#endif
 };
 
 struct kernel_stat {
@@ -51,11 +55,23 @@ DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 #define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
 #define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
+#ifdef CONFIG_64BIT
 #define kcpustat_cpu_get(cpu, i) (kcpustat_cpu(cpu)._cpustat[i])
 #define kcpustat_cpu_set(cpu, i, val) (kcpustat_cpu(cpu)._cpustat[i] = (val))
 #define kcpustat_cpu_add(cpu, i, val) (kcpustat_cpu(cpu)._cpustat[i] += (val))
 #define kcpustat_this_cpu_set(i, val) (kcpustat_this_cpu->_cpustat[i] = (val))
 #define kcpustat_this_cpu_add(i, val) (kcpustat_this_cpu->_cpustat[i] += (val))
+#else
+#define kcpustat_cpu_get(cpu, i) atomic64_read(&kcpustat_cpu(cpu)._cpustat[i])
+#define kcpustat_cpu_set(cpu, i, val) \
+	atomic64_set(val, &kcpustat_cpu(cpu)._cpustat[i])
+#define kcpustat_cpu_add(cpu, i, val) \
+	atomic64_add(val, &kcpustat_cpu(cpu)._cpustat[i])
+#define kcpustat_this_cpu_set(i, val) \
+	atomic64_set(val, &kcpustat_this_cpu->_cpustat[i])
+#define kcpustat_this_cpu_add(i, val) \
+	atomic64_add(val, &kcpustat_this_cpu->_cpustat[i])
+#endif
 
 extern unsigned long long nr_context_switches(void);
 
-- 
1.8.1.2

