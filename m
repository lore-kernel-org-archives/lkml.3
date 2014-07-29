Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaG2KwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:52:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54736 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752168AbaG2Kv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:51:59 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] thermal: trace: Trace when a cooling device's state is updated
Date: Tue, 29 Jul 2014 11:50:49 +0100
Message-Id: <1406631050-14975-3-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
 <1406631050-14975-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce and use an event to trace when a cooling device's state is
updated. This is useful to follow the effect of governor decisions on
cooling devices.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 drivers/thermal/thermal_core.c |    1 +
 include/trace/events/thermal.h |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 6b32391..c74c78d 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1291,6 +1291,7 @@ void thermal_cdev_update(struct thermal_cooling_device *cdev)
 	mutex_unlock(&cdev->lock);
 	cdev->ops->set_cur_state(cdev, target);
 	cdev->updated = true;
+	trace_cdev_update(cdev, target);
 	dev_dbg(&cdev->device, "set to state %lu\n", target);
 }
 EXPORT_SYMBOL(thermal_cdev_update);
diff --git a/include/trace/events/thermal.h b/include/trace/events/thermal.h
index 8c5ca96..894a79e 100644
--- a/include/trace/events/thermal.h
+++ b/include/trace/events/thermal.h
@@ -32,6 +32,25 @@ TRACE_EVENT(thermal_temperature,
 		__entry->temp)
 );
 
+TRACE_EVENT(cdev_update,
+
+	TP_PROTO(struct thermal_cooling_device *cdev, unsigned long target),
+
+	TP_ARGS(cdev, target),
+
+	TP_STRUCT__entry(
+		__string(type, cdev->type)
+		__field(unsigned long, target)
+	),
+
+	TP_fast_assign(
+		__assign_str(type, cdev->type);
+		__entry->target = target;
+	),
+
+	TP_printk("type=%s target=%lu", __get_str(type), __entry->target)
+);
+
 #endif /* _TRACE_THERMAL_H */
 
 /* This part must be outside protection */
-- 
1.7.10.4

