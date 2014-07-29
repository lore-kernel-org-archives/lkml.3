Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaG2Kvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:51:45 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54460 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950AbaG2Kvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:51:43 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/3] thermal: trace: Trace temperature changes
Date: Tue, 29 Jul 2014 11:50:48 +0100
Message-Id: <1406631050-14975-2-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
 <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new event to trace the temperature of a thermal zone. Using
this event trace the temperature changes of the thermal zone every-time
it is updated.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 drivers/thermal/thermal_core.c |    4 ++++
 include/trace/events/thermal.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)
 create mode 100644 include/trace/events/thermal.h

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0..6b32391 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -38,6 +38,9 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thermal.h>
+
 #include "thermal_core.h"
 #include "thermal_hwmon.h"
 
@@ -463,6 +466,7 @@ static void update_temperature(struct thermal_zone_device *tz)
 	tz->temperature = temp;
 	mutex_unlock(&tz->lock);
 
+	trace_thermal_temperature(tz);
 	dev_dbg(&tz->device, "last_temperature=%d, current_temperature=%d\n",
 				tz->last_temperature, tz->temperature);
 }
diff --git a/include/trace/events/thermal.h b/include/trace/events/thermal.h
new file mode 100644
index 0000000..8c5ca96
--- /dev/null
+++ b/include/trace/events/thermal.h
@@ -0,0 +1,38 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM thermal
+
+#if !defined(_TRACE_THERMAL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_THERMAL_H
+
+#include <linux/thermal.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(thermal_temperature,
+
+	TP_PROTO(struct thermal_zone_device *tz),
+
+	TP_ARGS(tz),
+
+	TP_STRUCT__entry(
+		__string(thermal_zone, tz->type)
+		__field(int, id)
+		__field(int, temp_prev)
+		__field(int, temp)
+	),
+
+	TP_fast_assign(
+		__assign_str(thermal_zone, tz->type);
+		__entry->id = tz->id;
+		__entry->temp_prev = tz->last_temperature;
+		__entry->temp = tz->temperature;
+	),
+
+	TP_printk("thermal_zone=%s id=%d temp_prev=%d temp=%d",
+		__get_str(thermal_zone), __entry->id, __entry->temp_prev,
+		__entry->temp)
+);
+
+#endif /* _TRACE_THERMAL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.10.4

