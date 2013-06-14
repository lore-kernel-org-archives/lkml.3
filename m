Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3FNQeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:34:03 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:43548 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab3FNQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:33:57 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] power: Include additional information in pm_print_times
Date: Fri, 14 Jun 2013 10:33:45 -0600
Message-Id: <1371227625-3141-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change __device_suspend() path to include driver name and the ops that
get run for a device. This additional information helps associate driver
and the type of pm_ops the device uses in suspend path very quickly and
aid in debugging problems in suspend and resume paths. Added the additional
information at the end of the original message.

dmesg output before the change:

[  164.390032] calling  1-1+ @ 69, parent: usb1
[  164.390035] call 1-1+ returned 0 after 0 usecs

[  164.390352] calling  00:0a+ @ 2457, parent: pnp0
[  164.390357] call 00:0a+ returned 0 after 3 usecs

[  164.390361] calling  00:09+ @ 2457, parent: pnp0
[  164.496458] call 00:09+ returned 0 after 103500 usecs

[  164.496494] calling  00:05+ @ 2457, parent: pnp0
[  164.496511] call 00:05+ returned 0 after 14 usecs

dmesg output after the change:

[  317.295499] calling 1-1+ @ 71, parent: usb1 driver: usb type pm ops
[  317.297671] call 1-1+ returned 0 after 2117 usecs

[  318.134469] calling 00:0a+ @ 2941, parent: pnp0 driver: system legacy bus
[  318.134476] call 00:0a+ returned 0 after 5 usecs

[  317.292894] calling 00:09+ @ 2941, parent: pnp0 driver: tpm_tis legacy bus pm ops
[  317.397315] call 00:09+ returned 0 after 101967 usecs

[  317.397353] calling 00:05+ @ 2941, parent: pnp0 driver: rtc_cmos legacy bus pm ops
[  317.397369] call 00:05+ returned 0 after 13 usecs

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
CC: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/base/power/main.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 5a9b656..900266d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -157,14 +157,15 @@ void device_pm_move_last(struct device *dev)
 	list_move_tail(&dev->power.entry, &dpm_list);
 }
 
-static ktime_t initcall_debug_start(struct device *dev)
+static ktime_t initcall_debug_start(struct device *dev, char *info)
 {
 	ktime_t calltime = ktime_set(0, 0);
 
 	if (pm_print_times_enabled) {
-		pr_info("calling  %s+ @ %i, parent: %s\n",
+		pr_info("calling %s+ @ %i, parent: %s driver: %s %s\n",
 			dev_name(dev), task_pid_nr(current),
-			dev->parent ? dev_name(dev->parent) : "none");
+			dev->parent ? dev_name(dev->parent) : "none",
+			dev_driver_string(dev), info);
 		calltime = ktime_get();
 	}
 
@@ -373,7 +374,7 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 	if (!cb)
 		return 0;
 
-	calltime = initcall_debug_start(dev);
+	calltime = initcall_debug_start(dev, info);
 
 	pm_dev_dbg(dev, state, info);
 	error = cb(dev);
@@ -1027,13 +1028,15 @@ EXPORT_SYMBOL_GPL(dpm_suspend_end);
  * @cb: Suspend callback to execute.
  */
 static int legacy_suspend(struct device *dev, pm_message_t state,
-			  int (*cb)(struct device *dev, pm_message_t state))
+			  int (*cb)(struct device *dev, pm_message_t state),
+			  char *info)
 {
 	int error;
 	ktime_t calltime;
 
-	calltime = initcall_debug_start(dev);
+	calltime = initcall_debug_start(dev, info);
 
+	pm_dev_dbg(dev, state, info);
 	error = cb(dev, state);
 	suspend_report_result(cb, error);
 
@@ -1079,43 +1082,45 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	device_lock(dev);
 
 	if (dev->pm_domain) {
-		info = "power domain ";
+		info = "power domain pm ops ";
 		callback = pm_op(&dev->pm_domain->ops, state);
 		goto Run;
 	}
 
 	if (dev->type && dev->type->pm) {
-		info = "type ";
+		info = "type pm ops ";
 		callback = pm_op(dev->type->pm, state);
 		goto Run;
 	}
 
 	if (dev->class) {
 		if (dev->class->pm) {
-			info = "class ";
+			info = "class pm ops ";
 			callback = pm_op(dev->class->pm, state);
 			goto Run;
 		} else if (dev->class->suspend) {
-			pm_dev_dbg(dev, state, "legacy class ");
-			error = legacy_suspend(dev, state, dev->class->suspend);
+			info = "legacy class pm ops ";
+			error = legacy_suspend(dev, state, dev->class->suspend,
+				info);
 			goto End;
 		}
 	}
 
 	if (dev->bus) {
 		if (dev->bus->pm) {
-			info = "bus ";
+			info = "bus pm ops ";
 			callback = pm_op(dev->bus->pm, state);
 		} else if (dev->bus->suspend) {
-			pm_dev_dbg(dev, state, "legacy bus ");
-			error = legacy_suspend(dev, state, dev->bus->suspend);
+			info = "legacy bus pm ops ";
+			error = legacy_suspend(dev, state, dev->bus->suspend,
+				info);
 			goto End;
 		}
 	}
 
  Run:
 	if (!callback && dev->driver && dev->driver->pm) {
-		info = "driver ";
+		info = "driver pm ops ";
 		callback = pm_op(dev->driver->pm, state);
 	}
 
-- 
1.7.10.4

