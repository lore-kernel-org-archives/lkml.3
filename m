Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3DPG5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:57:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:1537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab3DPG5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,483,1363158000"; 
   d="scan'208";a="295522210"
From: "Pan, Zhenjie" <zhenjie.pan@intel.com>
To: "'a.p.zijlstra@chello.nl'" <a.p.zijlstra@chello.nl>,
        "'paulus@samba.org'" <paulus@samba.org>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        "'acme@ghostprotocols.net'" <acme@ghostprotocols.net>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'dzickus@redhat.com'" <dzickus@redhat.com>,
        "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Thread-Topic: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
Thread-Index: Ac46b5lX48efHbUtRT2d/NJzqZ6DWQ==
Date: Tue, 16 Apr 2013 06:57:09 +0000
Message-ID: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Watchdog use performance monitor of cpu clock cycle to generate NMI to detect hard lockup.
But when cpu's frequency changes, the event period will also change.
It's not as expected as the configration.
For example, set the NMI event handler period is 10 seconds when the cpu is 2.0GHz.
If the cpu changes to 800MHz, the period will be 10*(2000/800)=25 seconds.
So it may make hard lockup detect not work if the watchdog timeout is not long enough.
Now, set a notifier to listen to the cpu frequency change.
And dynamic re-config the NMI event to make the event period correct.

Signed-off-by: Pan Zhenjie <zhenjie.pan@intel.com>

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1d795df..78fc218 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -564,7 +564,10 @@ extern void perf_pmu_migrate_context(struct pmu *pmu,
 				int src_cpu, int dst_cpu);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
-
+#ifdef CONFIG_CPU_FREQ
+extern void perf_dynamic_adjust_period(struct perf_event *event,
+						u64 sample_period);
+#endif
 
 struct perf_sample_data {
 	u64				type;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7e0962e..bbe5f57 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -37,6 +37,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
+#include <linux/math64.h>
 
 #include "internal.h"
 
@@ -2428,6 +2429,44 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bo
 	}
 }
 
+#ifdef CONFIG_CPU_FREQ
+static int perf_percpu_dynamic_adjust_period(void *info)
+{
+	struct perf_event *event = info;
+	s64 left;
+	u64 old_period = event->hw.sample_period;
+	u64 new_period = event->attr.sample_period;
+	u64 shift = 0;
+
+	/* precision is enough */
+	while (old_period > 0xF && new_period > 0xF) {
+		old_period >>= 1;
+		new_period >>= 1;
+		shift++;
+	}
+
+	event->pmu->stop(event, PERF_EF_UPDATE);
+
+	left = local64_read(&event->hw.period_left);
+	left = (s64)div64_u64(left * (event->attr.sample_period >> shift),
+		(event->hw.sample_period >> shift));
+	local64_set(&event->hw.period_left, left);
+
+	event->hw.sample_period = event->attr.sample_period;
+
+	event->pmu->start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+void perf_dynamic_adjust_period(struct perf_event *event, u64 sample_period)
+{
+	event->attr.sample_period = sample_period;
+	cpu_function_call(event->cpu, perf_percpu_dynamic_adjust_period, event);
+}
+EXPORT_SYMBOL_GPL(perf_dynamic_adjust_period);
+#endif
+
 /*
  * combine freq adjustment with unthrottling to avoid two passes over the
  * events. At the same time, make sure, having freq events does not change
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4a94467..32f3391 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -28,6 +28,7 @@
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
+#include <linux/cpufreq.h>
 
 int watchdog_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
@@ -470,6 +471,44 @@ static void watchdog_nmi_disable(unsigned int cpu)
 	}
 	return;
 }
+
+#ifdef CONFIG_CPU_FREQ
+static int watchdog_cpufreq_transition(struct notifier_block *nb,
+					unsigned long val, void *data)
+{
+	struct perf_event *event;
+	struct cpufreq_freqs *freq = data;
+
+	if (val == CPUFREQ_POSTCHANGE) {
+		event = per_cpu(watchdog_ev, freq->cpu);
+		perf_dynamic_adjust_period(event,
+				(u64)freq->new * 1000 * watchdog_thresh);
+	}
+
+	return 0;
+}
+
+static struct notifier_block watchdog_nb = {
+	.notifier_call = watchdog_cpufreq_transition,
+	.priority = 0,
+};
+
+static int __init watchdog_cpufreq(void)
+{
+	int ret;
+
+	ret = cpufreq_register_notifier(&watchdog_nb,
+					CPUFREQ_TRANSITION_NOTIFIER);
+
+	if (ret < 0)
+		pr_err("watchdog register CPU frequency notifier fail(%d)\n",
+			ret);
+
+	return ret;
+}
+late_initcall(watchdog_cpufreq);
+#endif
+
 #else
 static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
 static void watchdog_nmi_disable(unsigned int cpu) { return; }
-- 
1.7.9.5
