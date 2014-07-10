Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaGJOUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:20:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35901 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaGJOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:20:06 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC PATCH v5 09/10] thermal: add trace events to the power allocator governor
Date: Thu, 10 Jul 2014 15:18:47 +0100
Message-Id: <1405001928-12697-10-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 10 Jul 2014 14:20:02.0408 (UTC) FILETIME=[09DDD680:01CF9C4A]
X-MC-Unique: 114071015200410901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s6AEL2NA009853

Add trace events for the power allocator governor and the power actor
interface of the cpu cooling device.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 drivers/thermal/cpu_actor.c                    |  17 ++-
 drivers/thermal/power_allocator.c              |  22 +++-
 include/trace/events/thermal_power_allocator.h | 138 +++++++++++++++++++++++++
 3 files changed, 173 insertions(+), 4 deletions(-)
 create mode 100644 include/trace/events/thermal_power_allocator.h

diff --git a/drivers/thermal/cpu_actor.c b/drivers/thermal/cpu_actor.c
index 45ea4fa92ea0..b5ed2e80e288 100644
--- a/drivers/thermal/cpu_actor.c
+++ b/drivers/thermal/cpu_actor.c
@@ -28,6 +28,8 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 
+#include <trace/events/thermal_power_allocator.h>
+
 /**
  * struct power_table - frequency to power conversion
  * @frequency:	frequency in KHz
@@ -184,11 +186,12 @@ static u32 get_static_power(struct cpu_actor *cpu_actor,
  */
 static u32 get_dynamic_power(struct cpu_actor *cpu_actor, unsigned long freq)
 {
-	int cpu;
-	u32 power = 0, raw_cpu_power, total_load = 0;
+	int i, cpu;
+	u32 power = 0, raw_cpu_power, total_load = 0, load_cpu[NR_CPUS];
 
 	raw_cpu_power = cpu_freq_to_power(cpu_actor, freq);
 
+	i = 0;
 	for_each_cpu(cpu, &cpu_actor->cpumask) {
 		u32 load;
 
@@ -198,8 +201,15 @@ static u32 get_dynamic_power(struct cpu_actor *cpu_actor, unsigned long freq)
 		load = get_load(cpu_actor, cpu);
 		power += (raw_cpu_power * load) / 100;
 		total_load += load;
+		load_cpu[i] = load;
+
+		i++;
 	}
 
+	trace_thermal_power_actor_cpu_get_dyn_power(&cpu_actor->cpumask, freq,
+						raw_cpu_power, load_cpu, i,
+						power);
+
 	cpu_actor->last_load = total_load;
 
 	return power;
@@ -296,6 +306,9 @@ static int cpu_set_power(struct power_actor *actor,
 		return -EINVAL;
 	}
 
+	trace_thermal_power_actor_cpu_limit(&cpu_actor->cpumask, target_freq,
+					cdev_state, power);
+
 	return cdev->ops->set_cur_state(cdev, cdev_state);
 }
 
diff --git a/drivers/thermal/power_allocator.c b/drivers/thermal/power_allocator.c
index eb1797cd859b..e6793d6d1288 100644
--- a/drivers/thermal/power_allocator.c
+++ b/drivers/thermal/power_allocator.c
@@ -20,6 +20,9 @@
 #include <linux/slab.h>
 #include <linux/thermal.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thermal_power_allocator.h>
+
 #include "thermal_core.h"
 
 #define FRAC_BITS 8
@@ -133,7 +136,14 @@ static u32 pid_controller(struct thermal_zone_device *tz,
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
@@ -214,7 +224,7 @@ static int allocate_power(struct thermal_zone_device *tz,
 	struct power_actor *actor;
 	u32 *req_power, *max_power, *granted_power;
 	u32 total_req_power, max_allocatable_power;
-	u32 power_range;
+	u32 total_granted_power, power_range;
 	int i, num_actors, ret = 0;
 
 	mutex_lock(&tz->lock);
@@ -265,12 +275,20 @@ static int allocate_power(struct thermal_zone_device *tz,
 	divvy_up_power(req_power, max_power, num_actors, total_req_power,
 		power_range, granted_power);
 
+	total_granted_power = 0;
 	i = 0;
 	list_for_each_entry_rcu(actor, &actor_list, actor_node) {
 		actor->ops->set_power(actor, tz, granted_power[i]);
+		total_granted_power += granted_power[i];
+
 		i++;
 	}
 
+	trace_thermal_power_allocator(req_power, total_req_power, granted_power,
+				total_granted_power, num_actors, power_range,
+				max_allocatable_power, current_temp,
+				(s32)control_temp - (s32)current_temp);
+
 	devm_kfree(&tz->device, granted_power);
 free_max_power:
 	devm_kfree(&tz->device, max_power);
diff --git a/include/trace/events/thermal_power_allocator.h b/include/trace/events/thermal_power_allocator.h
new file mode 100644
index 000000000000..9140cec55c63
--- /dev/null
+++ b/include/trace/events/thermal_power_allocator.h
@@ -0,0 +1,138 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM thermal_power_allocator
+
+#if !defined(_TRACE_THERMAL_POWER_ALLOCATOR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_THERMAL_POWER_ALLOCATOR_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(thermal_power_allocator,
+	TP_PROTO(u32 *req_power, u32 total_req_power, u32 *granted_power,
+		u32 total_granted_power, size_t num_actors, u32 power_range,
+		u32 max_allocatable_power, unsigned long current_temp,
+		s32 delta_temp),
+	TP_ARGS(req_power, total_req_power, granted_power, total_granted_power,
+		num_actors, power_range, max_allocatable_power, current_temp,
+		delta_temp),
+	TP_STRUCT__entry(
+		__dynamic_array(u32,   req_power, num_actors    )
+		__field(u32,           total_req_power          )
+		__dynamic_array(u32,   granted_power, num_actors)
+		__field(u32,           total_granted_power      )
+		__field(size_t,        num_actors               )
+		__field(u32,           power_range              )
+		__field(u32,           max_allocatable_power    )
+		__field(unsigned long, current_temp             )
+		__field(s32,           delta_temp               )
+	),
+	TP_fast_assign(
+		memcpy(__get_dynamic_array(req_power), req_power,
+			num_actors * sizeof(*req_power));
+		__entry->total_req_power = total_req_power;
+		memcpy(__get_dynamic_array(granted_power), granted_power,
+			num_actors * sizeof(*granted_power));
+		__entry->total_granted_power = total_granted_power;
+		__entry->num_actors = num_actors;
+		__entry->power_range = power_range;
+		__entry->max_allocatable_power = max_allocatable_power;
+		__entry->current_temp = current_temp;
+		__entry->delta_temp = delta_temp;
+	),
+
+	TP_printk("req_power={%s} total_req_power=%u granted_power={%s} total_granted_power=%u power_range=%u max_allocatable_power=%u current_temperature=%lu delta_temperature=%d",
+		__print_u32_array(__get_dynamic_array(req_power),
+				__entry->num_actors),
+		__entry->total_req_power,
+		__print_u32_array(__get_dynamic_array(granted_power),
+				__entry->num_actors),
+		__entry->total_granted_power, __entry->power_range,
+		__entry->max_allocatable_power, __entry->current_temp,
+		__entry->delta_temp)
+);
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
+TRACE_EVENT(thermal_power_actor_cpu_get_dyn_power,
+	TP_PROTO(const struct cpumask *cpus, unsigned long freq,
+		u32 raw_cpu_power, u32 *load, size_t load_len, u32 power),
+
+	TP_ARGS(cpus, freq, raw_cpu_power, load, load_len, power),
+
+	TP_STRUCT__entry(
+		__bitmask(cpumask, num_possible_cpus())
+		__field(unsigned long, freq          )
+		__field(u32,           raw_cpu_power )
+		__dynamic_array(u32,   load, load_len)
+		__field(size_t,        load_len      )
+		__field(u32,           power         )
+	),
+
+	TP_fast_assign(
+		__assign_bitmask(cpumask, cpumask_bits(cpus),
+				num_possible_cpus());
+		__entry->freq = freq;
+		__entry->raw_cpu_power = raw_cpu_power;
+		memcpy(__get_dynamic_array(load), load,
+			load_len * sizeof(*load));
+		__entry->load_len = load_len;
+		__entry->power = power;
+	),
+
+	TP_printk("cpus=%s freq=%lu raw_cpu_power=%d load={%s} power=%d",
+		__get_bitmask(cpumask), __entry->freq, __entry->raw_cpu_power,
+		__print_u32_array(__get_dynamic_array(load), __entry->load_len),
+		__entry->power)
+);
+
+TRACE_EVENT(thermal_power_actor_cpu_limit,
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
+#endif /* _TRACE_THERMAL_POWER_ALLOCATOR_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.9.1


