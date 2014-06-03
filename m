Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaFCKUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:20:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52052 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaFCKUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:20:43 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, Javi Merino <javi.merino@arm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC PATCH v3 7/7] thermal: add trace events to the power allocator governor
Date: Tue,  3 Jun 2014 11:18:35 +0100
Message-Id: <1401790715-5630-8-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401790715-5630-1-git-send-email-javi.merino@arm.com>
References: <1401790715-5630-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 03 Jun 2014 10:20:37.0131 (UTC) FILETIME=[7635C5B0:01CF7F15]
X-MC-Unique: 114060311204200501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s53AL2xt004093

Add trace events for the power allocator governor and the power actor
interface of the cpu cooling device.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>

---

trace-cmd needs the patched attached in
http://article.gmane.org/gmane.linux.kernel/1704423 for this to work.

 drivers/thermal/power_actor/cpu_actor.c |  5 +++++
 drivers/thermal/power_allocator.c       | 12 ++++++++++-
 include/trace/events/thermal.h          | 38 +++++++++++++++++++++++++++++++++
 include/trace/events/thermal_governor.h | 37 ++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/thermal.h
 create mode 100644 include/trace/events/thermal_governor.h

diff --git a/drivers/thermal/power_actor/cpu_actor.c b/drivers/thermal/power_actor/cpu_actor.c
index 6eac80d119a5..396689b8fd40 100644
--- a/drivers/thermal/power_actor/cpu_actor.c
+++ b/drivers/thermal/power_actor/cpu_actor.c
@@ -27,6 +27,9 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thermal.h>
+
 #include "power_actor.h"
 
 /**
@@ -297,6 +300,8 @@ static int cpu_set_power(struct power_actor *actor, u32 power)
 		return -EINVAL;
 	}
 
+	trace_thermal_power_limit(&cpu_actor->cpumask, freq, cdev_state, power);
+
 	return cdev->ops->set_cur_state(cdev, cdev_state);
 }
 
diff --git a/drivers/thermal/power_allocator.c b/drivers/thermal/power_allocator.c
index 9c7e7f212eb6..1e57a810903d 100644
--- a/drivers/thermal/power_allocator.c
+++ b/drivers/thermal/power_allocator.c
@@ -19,6 +19,9 @@
 #include <linux/slab.h>
 #include <linux/thermal.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thermal_governor.h>
+
 #include "power_actor/power_actor.h"
 #include "thermal_core.h"
 
@@ -130,7 +133,14 @@ static u32 pid_controller(struct thermal_zone_device *tz,
 	/* feed-forward the known sustainable dissipatable power */
 	power_range = tz->tzp->sustainable_power + frac_to_int(power_range);
 
-	return clamp(power_range, (s64)0, (s64)max_allocatable_power);
+	power_range = clamp(power_range, (s64)0, (s64)max_allocatable_power);
+
+	trace_thermal_power_allocator_pid(frac_to_int(err),
+					frac_to_int(params->err_integral),
+					frac_to_int(p), frac_to_int(i),
+					frac_to_int(d), power_range);
+
+	return power_range;
 }
 
 /**
diff --git a/include/trace/events/thermal.h b/include/trace/events/thermal.h
new file mode 100644
index 000000000000..ce326e5cfe90
--- /dev/null
+++ b/include/trace/events/thermal.h
@@ -0,0 +1,38 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM thermal
+
+#if !defined(_TRACE_THERMAL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_THERMAL_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(thermal_power_limit,
+	TP_PROTO(const struct cpumask *cpus, unsigned int freq,
+		unsigned long cdev_state, u32 power),
+
+	TP_ARGS(cpus, freq, cdev_state, power),
+
+	TP_STRUCT__entry(
+		__bitmask(cpumask, num_possible_cpus())
+		__field(unsigned int,  freq      )
+		__field(unsigned long, cdev_state)
+		__field(u32,           power     )
+	),
+
+	TP_fast_assign(
+		__assign_bitmask(cpumask, cpumask_bits(cpus),
+				num_possible_cpus());
+		__entry->freq = freq;
+		__entry->cdev_state = cdev_state;
+		__entry->power = power;
+	),
+
+	TP_printk("cpus=%s freq=%u cdev_state=%lu power=%u",
+		__get_bitmask(cpumask), __entry->freq, __entry->cdev_state,
+		__entry->power)
+);
+
+#endif /* _TRACE_THERMAL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/thermal_governor.h b/include/trace/events/thermal_governor.h
new file mode 100644
index 000000000000..5e5b25a41a6b
--- /dev/null
+++ b/include/trace/events/thermal_governor.h
@@ -0,0 +1,37 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM thermal_governor
+
+#if !defined(_TRACE_THERMAL_GOVERNOR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_THERMAL_GOVERNOR_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(thermal_power_allocator_pid,
+	TP_PROTO(s32 err, s32 err_integral, s64 p, s64 i, s64 d, s32 output),
+	TP_ARGS(err, err_integral, p, i, d, output),
+	TP_STRUCT__entry(
+		__field(s32, err         )
+		__field(s32, err_integral)
+		__field(s64, p           )
+		__field(s64, i           )
+		__field(s64, d           )
+		__field(s32, output      )
+	),
+	TP_fast_assign(
+		__entry->err = err;
+		__entry->err_integral = err_integral;
+		__entry->p = p;
+		__entry->i = i;
+		__entry->d = d;
+		__entry->output = output;
+	),
+
+	TP_printk("err=%d err_integral=%d p=%lld i=%lld d=%lld output=%d",
+		__entry->err, __entry->err_integral,
+		__entry->p, __entry->i, __entry->d, __entry->output)
+);
+
+#endif /* _TRACE_THERMAL_GOVERNOR_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.9.1


