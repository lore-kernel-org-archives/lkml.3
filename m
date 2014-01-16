Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaAPGxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:53:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:44722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaAPGxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:53:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="467506068"
Subject: [PATCH V2] PM: Enable asynchronous threads for
 suspend/resume_noirq/late/early phases
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuangzhi.li@intel.com, chuansheng.liu@intel.com
In-Reply-To: <1389683888.3650.78.camel@cliu38-desktop-build>
References: <1389683888.3650.78.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jan 2014 14:58:57 +0800
Message-ID: <1389855537.8320.5.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current code has implemented asynchronous threads for dpm_suspend()
and dpm_resume(), which saved much time.

As commit 5af84b82701a and 97df8c12995 said, the total time can be
reduced significantly by running suspend and resume callbacks of
device drivers in parallel with each other.

For the suspend_late/suspend_noirq/resume_noirq/resume_early phases,
sometimes they often taken much time without asynchronous threads,
following the idea of the above commits, implemented it with async
threads too.

One example below for my test platform:
Without this patch:
[ 1411.272218] PM: noirq resume of devices complete after 92.223 msecs
with this patch:
[  110.616735] PM: noirq resume of devices complete after 10.544 msecs

Normally 80% time is saved, which is helpful for the user experience
specially for mobile platform.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |  189 +++++++++++++++++++++++++++++++++++++++------
 include/linux/pm.h        |    2 +
 2 files changed, 166 insertions(+), 25 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 6a33dd8..62648b2 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -72,6 +72,8 @@ void device_pm_sleep_init(struct device *dev)
 {
 	dev->power.is_prepared = false;
 	dev->power.is_suspended = false;
+	dev->power.is_late_suspended = false;
+	dev->power.is_noirq_suspended = false;
 	init_completion(&dev->power.completion);
 	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
@@ -452,7 +454,7 @@ static void dpm_wd_clear(struct dpm_watchdog *wd)
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_resume_noirq(struct device *dev, pm_message_t state)
+static int __device_resume_noirq(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
@@ -464,6 +466,9 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	if (!dev->power.is_noirq_suspended)
+		goto Out;
+
 	if (dev->pm_domain) {
 		info = "noirq power domain ";
 		callback = pm_noirq_op(&dev->pm_domain->ops, state);
@@ -484,12 +489,41 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
+	dev->power.is_noirq_suspended = false;
 
  Out:
 	TRACE_RESUME(error);
 	return error;
 }
 
+static bool is_async(struct device *dev)
+{
+	return dev->power.async_suspend && pm_async_enabled
+		&& !pm_trace_is_enabled();
+}
+
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_resume_noirq(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " noirq", error);
+	put_device(dev);
+}
+
+static int device_resume_noirq(struct device *dev)
+{
+	if (is_async(dev)) {
+		get_device(dev);
+		async_schedule(async_resume_noirq, dev);
+		return 0;
+	}
+
+	return __device_resume_noirq(dev, pm_transition);
+}
+
 /**
  * dpm_resume_noirq - Execute "noirq resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -500,6 +534,7 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 static void dpm_resume_noirq(pm_message_t state)
 {
 	ktime_t starttime = ktime_get();
+	pm_transition = state;
 
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_noirq_list)) {
@@ -510,18 +545,18 @@ static void dpm_resume_noirq(pm_message_t state)
 		list_move_tail(&dev->power.entry, &dpm_late_early_list);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_resume_noirq(dev, state);
+		error = device_resume_noirq(dev);
 		if (error) {
 			suspend_stats.failed_resume_noirq++;
 			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
 			dpm_save_failed_dev(dev_name(dev));
 			pm_dev_err(dev, state, " noirq", error);
 		}
-
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	dpm_show_time(starttime, state, "noirq");
 	resume_device_irqs();
 	cpuidle_resume();
@@ -534,7 +569,7 @@ static void dpm_resume_noirq(pm_message_t state)
  *
  * Runtime PM is disabled for @dev while this function is being executed.
  */
-static int device_resume_early(struct device *dev, pm_message_t state)
+static int __device_resume_early(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
@@ -546,6 +581,9 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	if (!dev->power.is_late_suspended)
+		goto Out;
+
 	if (dev->pm_domain) {
 		info = "early power domain ";
 		callback = pm_late_early_op(&dev->pm_domain->ops, state);
@@ -566,7 +604,7 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
-
+	dev->power.is_late_suspended = false;
  Out:
 	TRACE_RESUME(error);
 
@@ -574,6 +612,28 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	return error;
 }
 
+static void async_resume_early(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_resume_early(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+	put_device(dev);
+}
+
+static int device_resume_early(struct device *dev)
+{
+	if (is_async(dev)) {
+		get_device(dev);
+		async_schedule(async_resume_early, dev);
+		return 0;
+	}
+
+	return __device_resume_early(dev, pm_transition);
+}
+
 /**
  * dpm_resume_early - Execute "early resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -583,6 +643,8 @@ static void dpm_resume_early(pm_message_t state)
 	ktime_t starttime = ktime_get();
 
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
+
 	while (!list_empty(&dpm_late_early_list)) {
 		struct device *dev = to_device(dpm_late_early_list.next);
 		int error;
@@ -591,7 +653,7 @@ static void dpm_resume_early(pm_message_t state)
 		list_move_tail(&dev->power.entry, &dpm_suspended_list);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_resume_early(dev, state);
+		error = device_resume_early(dev);
 		if (error) {
 			suspend_stats.failed_resume_early++;
 			dpm_save_failed_step(SUSPEND_RESUME_EARLY);
@@ -603,6 +665,7 @@ static void dpm_resume_early(pm_message_t state)
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	dpm_show_time(starttime, state, "early");
 }
 
@@ -717,12 +780,6 @@ static void async_resume(void *data, async_cookie_t cookie)
 	put_device(dev);
 }
 
-static bool is_async(struct device *dev)
-{
-	return dev->power.async_suspend && pm_async_enabled
-		&& !pm_trace_is_enabled();
-}
-
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -898,10 +955,14 @@ static pm_message_t resume_event(pm_message_t sleep_state)
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
+	int error;
+
+	if (async_error)
+		return 0;
 
 	if (dev->power.syscore)
 		return 0;
@@ -925,9 +986,38 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 		callback = pm_noirq_op(dev->driver->pm, state);
 	}
 
-	return dpm_run_callback(callback, dev, state, info);
+	error = dpm_run_callback(callback, dev, state, info);
+	if (error)
+		async_error = error;
+	else
+		dev->power.is_noirq_suspended = true;
+
+	return error;
+}
+
+static void async_suspend_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend_noirq(dev, pm_transition);
+	if (error) {
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, pm_transition, " async", error);
+	}
+
+	put_device(dev);
 }
 
+static int device_suspend_noirq(struct device *dev)
+{
+	if (pm_async_enabled && dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+	return __device_suspend_noirq(dev, pm_transition);
+}
 /**
  * dpm_suspend_noirq - Execute "noirq suspend" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -943,19 +1033,20 @@ static int dpm_suspend_noirq(pm_message_t state)
 	cpuidle_pause();
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
+	async_error = 0;
+
 	while (!list_empty(&dpm_late_early_list)) {
 		struct device *dev = to_device(dpm_late_early_list.prev);
 
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend_noirq(dev, state);
+		error = device_suspend_noirq(dev);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			pm_dev_err(dev, state, " noirq", error);
-			suspend_stats.failed_suspend_noirq++;
-			dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
 			dpm_save_failed_dev(dev_name(dev));
 			put_device(dev);
 			break;
@@ -968,10 +1059,17 @@ static int dpm_suspend_noirq(pm_message_t state)
 			error = -EBUSY;
 			break;
 		}
+		if (async_error)
+			break;
 	}
 	mutex_unlock(&dpm_list_mtx);
-	if (error)
+	if (!error)
+		error = async_error;
+	if (error) {
+		suspend_stats.failed_suspend_noirq++;
+		dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
 		dpm_resume_noirq(resume_event(state));
+	}
 	else
 		dpm_show_time(starttime, state, "noirq");
 	return error;
@@ -984,13 +1082,17 @@ static int dpm_suspend_noirq(pm_message_t state)
  *
  * Runtime PM is disabled for @dev while this function is being executed.
  */
-static int device_suspend_late(struct device *dev, pm_message_t state)
+static int __device_suspend_late(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
+	int error = 0;
 
 	__pm_runtime_disable(dev, false);
 
+	if (async_error)
+		return 0;
+
 	if (dev->power.syscore)
 		return 0;
 
@@ -1013,7 +1115,37 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 		callback = pm_late_early_op(dev->driver->pm, state);
 	}
 
-	return dpm_run_callback(callback, dev, state, info);
+	error = dpm_run_callback(callback, dev, state, info);
+	if (error)
+		async_error = error;
+	else
+		dev->power.is_late_suspended = true;
+
+	return error;
+}
+
+static void async_suspend_late(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend_late(dev, pm_transition);
+	if (error) {
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, pm_transition, " async", error);
+	}
+	put_device(dev);
+}
+
+static int device_suspend_late(struct device *dev)
+{
+	if (pm_async_enabled && dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_late, dev);
+		return 0;
+	}
+
+	return __device_suspend_late(dev, pm_transition);
 }
 
 /**
@@ -1026,19 +1158,20 @@ static int dpm_suspend_late(pm_message_t state)
 	int error = 0;
 
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
+	async_error = 0;
+
 	while (!list_empty(&dpm_suspended_list)) {
 		struct device *dev = to_device(dpm_suspended_list.prev);
 
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend_late(dev, state);
+		error = device_suspend_late(dev);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			pm_dev_err(dev, state, " late", error);
-			suspend_stats.failed_suspend_late++;
-			dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
 			dpm_save_failed_dev(dev_name(dev));
 			put_device(dev);
 			break;
@@ -1051,11 +1184,17 @@ static int dpm_suspend_late(pm_message_t state)
 			error = -EBUSY;
 			break;
 		}
+		if (async_error)
+			break;
 	}
 	mutex_unlock(&dpm_list_mtx);
-	if (error)
+	if (!error)
+		error = async_error;
+	if (error) {
+		suspend_stats.failed_suspend_late++;
+		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
 		dpm_resume_early(resume_event(state));
-	else
+	} else
 		dpm_show_time(starttime, state, "late");
 
 	return error;
diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..a0a46ef 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -521,6 +521,8 @@ struct dev_pm_info {
 	unsigned int		async_suspend:1;
 	bool			is_prepared:1;	/* Owned by the PM core */
 	bool			is_suspended:1;	/* Ditto */
+	bool			is_late_suspended:1;
+	bool			is_noirq_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
 	spinlock_t		lock;
-- 
1.7.9.5



