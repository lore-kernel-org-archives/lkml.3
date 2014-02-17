Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBQFxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:53:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:65110 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaBQFxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:53:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="476347878"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v2 2/5] PM / sleep: Asynchronous threads for resume_noirq
Date: Mon, 17 Feb 2014 13:42:23 +0800
Message-Id: <1392615746-4574-3-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <1392615746-4574-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1392615746-4574-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In analogy with commits 5af84b82701a and 97df8c12995, using
asynchronous threads can improve the overall resume_noirq time
significantly.

One typical case is:
In resume_noirq phase and for the PCI devices, the function
pci_pm_resume_noirq() will be called, and there is one d3_delay
(10ms) at least.

With the way of asynchronous threads, we just need wait d3_delay
time once in parallel for each calling, which saves much time to
resume quickly.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c | 66 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 00c53eb..89172aa 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -469,7 +469,7 @@ static void dpm_watchdog_clear(struct dpm_watchdog *wd)
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_resume_noirq(struct device *dev, pm_message_t state)
+static int device_resume_noirq(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
@@ -481,6 +481,8 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	dpm_wait(dev->parent, async);
+
 	if (!dev->power.is_noirq_suspended)
 		goto Out;
 
@@ -507,10 +509,29 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	dev->power.is_noirq_suspended = false;
 
  Out:
+	complete_all(&dev->power.completion);
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
+	error = device_resume_noirq(dev, pm_transition, true);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+
+	put_device(dev);
+}
+
 /**
  * dpm_resume_noirq - Execute "noirq resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -520,29 +541,48 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
  */
 static void dpm_resume_noirq(pm_message_t state)
 {
+	struct device *dev;
 	ktime_t starttime = ktime_get();
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_noirq_list)) {
-		struct device *dev = to_device(dpm_noirq_list.next);
-		int error;
+	pm_transition = state;
+
+	/*
+	 * Advanced the async threads upfront,
+	 * in case the starting of async threads is
+	 * delayed by non-async resuming devices.
+	 */
+	list_for_each_entry(dev, &dpm_noirq_list, power.entry) {
+		reinit_completion(&dev->power.completion);
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_resume_noirq, dev);
+		}
+	}
 
+	while (!list_empty(&dpm_noirq_list)) {
+		dev = to_device(dpm_noirq_list.next);
 		get_device(dev);
 		list_move_tail(&dev->power.entry, &dpm_late_early_list);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_resume_noirq(dev, state);
-		if (error) {
-			suspend_stats.failed_resume_noirq++;
-			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
-			dpm_save_failed_dev(dev_name(dev));
-			pm_dev_err(dev, state, " noirq", error);
+		if (!is_async(dev)) {
+			int error;
+
+			error = device_resume_noirq(dev, state, false);
+			if (error) {
+				suspend_stats.failed_resume_noirq++;
+				dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
+				dpm_save_failed_dev(dev_name(dev));
+				pm_dev_err(dev, state, " noirq", error);
+			}
 		}
 
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	dpm_show_time(starttime, state, "noirq");
 	resume_device_irqs();
 	cpuidle_resume();
@@ -742,12 +782,6 @@ static void async_resume(void *data, async_cookie_t cookie)
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
-- 
1.9.rc0

