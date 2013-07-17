Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3GQP5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:57:48 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48819 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755622Ab3GQP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:57:46 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paul.gortmaker@windriver.com, joe@perches.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH v2] power: new trace event to print device suspend and resume time
Date: Wed, 17 Jul 2013 09:57:39 -0600
Message-Id: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new trace event is added to pm events to print time it takes to suspend and
resume a device. It generates trace message that includes device, driver,
parent information in addition to the type of pm ops invoked as well as the
pm event and error status from the pm ops. Example trace below:

bash-2484  [001] ....   907.330148: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=freeze ops=class  usecs=0 err=0

bash-2484  [001] ....   909.906743: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=restore ops=class  usecs=0 err=0

bash-2484  [001] ....   907.330155: device_pm_report_time: rfkill rfkill3 parent=phy0 state=freeze ops=legacy class  usecs=0 err=0

bash-2484  [001] ....   909.906739: device_pm_report_time: rfkill rfkill3 parent=phy0 state=restore ops=legacy class  usecs=1 err=0

bash-2484  [000] ....   907.389079: device_pm_report_time: ieee80211 phy0 parent=0000:01:00.0 state=freeze ops=legacy class  usecs=57497 err=0

bash-2484  [001] ....   909.906731: device_pm_report_time: ieee80211 phy0 parent=0000:01:00.0 state=restore ops=legacy class  usecs=95119 err=0

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/power/main.c    |   27 +++++++++++++++++++--------
 include/trace/events/power.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 8 deletions(-)

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
index 8e42410..6240541 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -66,6 +66,40 @@ TRACE_EVENT(machine_suspend,
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
+		__field(s64, ops_time)
+		__field(int, error)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, device);
+		__assign_str(driver, driver);
+		__assign_str(parent, parent);
+		__assign_str(pm_ops, pm_ops);
+		__assign_str(pm_event_str, pm_event_str);
+		__entry->ops_time = ktime_to_ns(ops_time) >> 10;
+		__entry->error = error;
+	),
+
+	TP_printk("%s %s parent=%s state=%s ops=%s usecs=%lld err=%d\n",
+		__get_str(driver), __get_str(device), __get_str(parent),
+		__get_str(pm_event_str), __get_str(pm_ops),
+		__entry->ops_time, __entry->error)
+);
+
 DECLARE_EVENT_CLASS(wakeup_source,
 
 	TP_PROTO(const char *name, unsigned int state),
-- 
1.7.10.4

