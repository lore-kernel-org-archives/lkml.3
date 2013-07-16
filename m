Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab3GPVXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:23:34 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:45257
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933617Ab3GPVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:23:32 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paul.gortmaker@windriver.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, shuahkhan@gmail.com
Subject: [PATCH] power: new trace event to print device suspend and resume time
Date: Tue, 16 Jul 2013 15:23:26 -0600
Message-Id: <1374009806-11823-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new trace event is added to pm events to print time it takes to suspend and
resume a device. It generates trace message that includes device, driver,
parent information in addition to the type of pm ops invoked as well as the
pm event and error status from the pm ops. Example trace below:

bash-2356  [000] ....  1512.375576: device_pm_report_time: acpi_video0 driver(backlight) parent(0000:00:02.0) freeze class  (0 usecs) err (0)

bash-2356  [000] ....  1512.375582: device_pm_report_time: rfkill3 driver(rfkill) parent(phy0) freeze legacy class  (0 usecs) err (0)

bash-2356  [001] ....  1513.046559: device_pm_report_time: 0000:00:00.0 driver(pci) parent(pci0000:00) restore noirq bus  (10 usecs) err (0)

bash-2356  [001] ....  1513.046580: device_pm_report_time: 0000:00:02.0 driver(i915) parent(pci0000:00) restore noirq bus  (16 usecs) err (0)

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/power/main.c    |   27 +++++++++++++++++++--------
 include/trace/events/power.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 5a9b656..d268c45 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/async.h>
 #include <linux/suspend.h>
+#include <trace/events/power.h>
 #include <linux/cpuidle.h>
 #include "../base.h"
 #include "power.h"
@@ -56,6 +57,8 @@ static pm_message_t pm_transition;
 
 static int async_error;
 
+static char *pm_verb(int);
+
 /**
  * device_pm_sleep_init - Initialize system suspend-related device fields.
  * @dev: Device object being initialized.
@@ -172,16 +175,21 @@ static ktime_t initcall_debug_start(struct device *dev)
 }
 
 static void initcall_debug_report(struct device *dev, ktime_t calltime,
-				  int error)
+				  int error, pm_message_t state, char *info)
 {
 	ktime_t delta, rettime;
 
+	rettime = ktime_get();
+	delta = ktime_sub(rettime, calltime);
+
 	if (pm_print_times_enabled) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
 		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
 			error, (unsigned long long)ktime_to_ns(delta) >> 10);
 	}
+
+	trace_device_pm_report_time(dev_name(dev), dev_driver_string(dev),
+				dev->parent ? dev_name(dev->parent) : "none",
+				info, delta, pm_verb(state.event), error);
 }
 
 /**
@@ -379,7 +387,7 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 	error = cb(dev);
 	suspend_report_result(cb, error);
 
-	initcall_debug_report(dev, calltime, error);
+	initcall_debug_report(dev, calltime, error, state, info);
 
 	return error;
 }
@@ -1027,7 +1035,8 @@ EXPORT_SYMBOL_GPL(dpm_suspend_end);
  * @cb: Suspend callback to execute.
  */
 static int legacy_suspend(struct device *dev, pm_message_t state,
-			  int (*cb)(struct device *dev, pm_message_t state))
+			  int (*cb)(struct device *dev, pm_message_t state),
+			  char *info)
 {
 	int error;
 	ktime_t calltime;
@@ -1037,7 +1046,7 @@ static int legacy_suspend(struct device *dev, pm_message_t state,
 	error = cb(dev, state);
 	suspend_report_result(cb, error);
 
-	initcall_debug_report(dev, calltime, error);
+	initcall_debug_report(dev, calltime, error, state, info);
 
 	return error;
 }
@@ -1097,7 +1106,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 			goto Run;
 		} else if (dev->class->suspend) {
 			pm_dev_dbg(dev, state, "legacy class ");
-			error = legacy_suspend(dev, state, dev->class->suspend);
+			error = legacy_suspend(dev, state, dev->class->suspend,
+						"legacy class ");
 			goto End;
 		}
 	}
@@ -1108,7 +1118,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 			callback = pm_op(dev->bus->pm, state);
 		} else if (dev->bus->suspend) {
 			pm_dev_dbg(dev, state, "legacy bus ");
-			error = legacy_suspend(dev, state, dev->bus->suspend);
+			error = legacy_suspend(dev, state, dev->bus->suspend,
+						"legacy bus ");
 			goto End;
 		}
 	}
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 8e42410..d8eded6 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -66,6 +66,41 @@ TRACE_EVENT(machine_suspend,
 	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
+TRACE_EVENT(device_pm_report_time,
+
+	TP_PROTO(const char *device, const char *driver, const char *parent,
+		 const char *pm_ops, ktime_t ops_time, char *pm_event_str,
+		 int error),
+
+	TP_ARGS(device, driver, parent, pm_ops, ops_time, pm_event_str, error),
+
+	TP_STRUCT__entry(
+		__string(device, device)
+		__string(driver, driver)
+		__string(parent, parent)
+		__string(pm_ops, pm_ops)
+		__string(pm_event_str, pm_event_str)
+		__field(unsigned long long, ops_time)
+		__field(int, error)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, device);
+		__assign_str(driver, driver);
+		__assign_str(parent, parent);
+		__assign_str(pm_ops, pm_ops);
+		__assign_str(pm_event_str, pm_event_str);
+		__entry->ops_time = (unsigned long long)
+					ktime_to_ns(ops_time) >> 10;
+		__entry->error = error;
+	),
+
+	TP_printk("%s driver(%s) parent(%s) %s %s (%llu usecs) err(%d)\n",
+		__get_str(device), __get_str(driver), __get_str(parent),
+		__get_str(pm_event_str), __get_str(pm_ops),
+		__entry->ops_time, __entry->error)
+);
+
 DECLARE_EVENT_CLASS(wakeup_source,
 
 	TP_PROTO(const char *name, unsigned int state),
-- 
1.7.10.4

