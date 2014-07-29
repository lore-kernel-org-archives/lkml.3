Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaG2KwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:52:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54726 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950AbaG2Kv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:51:58 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/3] thermal: trace: Trace when temperature is above a trip point
Date: Tue, 29 Jul 2014 11:50:50 +0100
Message-Id: <1406631050-14975-4-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
 <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new event to trace when the temperature is above a trip
point. Use the trace-point when handling non-critical and critical
trip pionts.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 drivers/thermal/fair_share.c   |   12 ++++++++++++
 drivers/thermal/step_wise.c    |    5 ++++-
 drivers/thermal/thermal_core.c |    2 ++
 include/trace/events/thermal.h |   26 ++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index 944ba2f..6e0a3fb 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/thermal.h>
+#include <trace/events/thermal.h>
 
 #include "thermal_core.h"
 
@@ -34,6 +35,7 @@ static int get_trip_level(struct thermal_zone_device *tz)
 {
 	int count = 0;
 	unsigned long trip_temp;
+	enum thermal_trip_type trip_type;
 
 	if (tz->trips == 0 || !tz->ops->get_trip_temp)
 		return 0;
@@ -43,6 +45,16 @@ static int get_trip_level(struct thermal_zone_device *tz)
 		if (tz->temperature < trip_temp)
 			break;
 	}
+
+	/*
+	 * count > 0 only if temperature is greater than first trip
+	 * point, in which case, trip_point = count - 1
+	 */
+	if (count > 0) {
+		tz->ops->get_trip_type(tz, count - 1, &trip_type);
+		trace_thermal_zone_trip(tz, count - 1, trip_type);
+	}
+
 	return count;
 }
 
diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index f251521..3b54c2c 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/thermal.h>
+#include <trace/events/thermal.h>
 
 #include "thermal_core.h"
 
@@ -129,8 +130,10 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
 
 	trend = get_tz_trend(tz, trip);
 
-	if (tz->temperature >= trip_temp)
+	if (tz->temperature >= trip_temp) {
 		throttle = true;
+		trace_thermal_zone_trip(tz, trip, trip_type);
+	}
 
 	dev_dbg(&tz->device, "Trip%d[type=%d,temp=%ld]:trend=%d,throttle=%d\n",
 				trip, trip_type, trip_temp, trend, throttle);
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index c74c78d..454884a 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -371,6 +371,8 @@ static void handle_critical_trips(struct thermal_zone_device *tz,
 	if (tz->temperature < trip_temp)
 		return;
 
+	trace_thermal_zone_trip(tz, trip, trip_type);
+
 	if (tz->ops->notify)
 		tz->ops->notify(tz, trip, trip_type);
 
diff --git a/include/trace/events/thermal.h b/include/trace/events/thermal.h
index 894a79e..0f4f95d 100644
--- a/include/trace/events/thermal.h
+++ b/include/trace/events/thermal.h
@@ -51,6 +51,32 @@ TRACE_EVENT(cdev_update,
 	TP_printk("type=%s target=%lu", __get_str(type), __entry->target)
 );
 
+TRACE_EVENT(thermal_zone_trip,
+
+	TP_PROTO(struct thermal_zone_device *tz, int trip,
+		enum thermal_trip_type trip_type),
+
+	TP_ARGS(tz, trip, trip_type),
+
+	TP_STRUCT__entry(
+		__string(thermal_zone, tz->type)
+		__field(int, id)
+		__field(int, trip)
+		__field(enum thermal_trip_type, trip_type)
+	),
+
+	TP_fast_assign(
+		__assign_str(thermal_zone, tz->type);
+		__entry->id = tz->id;
+		__entry->trip = trip;
+		__entry->trip_type = trip_type;
+	),
+
+	TP_printk("thermal_zone=%s id=%d trip=%d trip_type=%d",
+		__get_str(thermal_zone), __entry->id, __entry->trip,
+		__entry->trip_type)
+);
+
 #endif /* _TRACE_THERMAL_H */
 
 /* This part must be outside protection */
-- 
1.7.10.4

