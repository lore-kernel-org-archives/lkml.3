Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBQGbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:31:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:58529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaBQGbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:31:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="476359326"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v3 4/5] PM / sleep: Asynchronous threads for suspend_noirq
Date: Mon, 17 Feb 2014 14:19:13 +0800
Message-Id: <1392617954-5292-5-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In analogy with commits 5af84b82701a and 97df8c12995, using
asynchronous threads can improve the overall suspend_noirq
time significantly.

This patch is for suspend_noirq phase.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c | 68 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 2f2d110..72b4c9c 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -990,14 +990,24 @@ static pm_message_t resume_event(pm_message_t sleep_state)
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
-	int error;
+	int error = 0;
+
+	dpm_wait_for_children(dev, async);
+
+	if (async_error)
+		goto Complete;
+
+	if (pm_wakeup_pending()) {
+		async_error = -EBUSY;
+		goto Complete;
+	}
 
 	if (dev->power.syscore)
-		return 0;
+		goto Complete;
 
 	if (dev->pm_domain) {
 		info = "noirq power domain ";
@@ -1021,10 +1031,40 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 	error = dpm_run_callback(callback, dev, state, info);
 	if (!error)
 		dev->power.is_noirq_suspended = true;
+	else
+		async_error = error;
 
+Complete:
+	complete_all(&dev->power.completion);
 	return error;
 }
 
+static void async_suspend_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend_noirq(dev, pm_transition, true);
+	if (error) {
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, pm_transition, " async", error);
+	}
+
+	put_device(dev);
+}
+
+static int device_suspend_noirq(struct device *dev)
+{
+	reinit_completion(&dev->power.completion);
+
+	if (pm_async_enabled && dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+	return __device_suspend_noirq(dev, pm_transition, false);
+}
+
 /**
  * dpm_suspend_noirq - Execute "noirq suspend" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -1040,19 +1080,20 @@ static int dpm_suspend_noirq(pm_message_t state)
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
@@ -1061,16 +1102,21 @@ static int dpm_suspend_noirq(pm_message_t state)
 			list_move(&dev->power.entry, &dpm_noirq_list);
 		put_device(dev);
 
-		if (pm_wakeup_pending()) {
-			error = -EBUSY;
+		if (async_error)
 			break;
-		}
 	}
 	mutex_unlock(&dpm_list_mtx);
-	if (error)
+	async_synchronize_full();
+	if (!error)
+		error = async_error;
+
+	if (error) {
+		suspend_stats.failed_suspend_noirq++;
+		dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
 		dpm_resume_noirq(resume_event(state));
-	else
+	} else {
 		dpm_show_time(starttime, state, "noirq");
+	}
 	return error;
 }
 
-- 
1.9.rc0

