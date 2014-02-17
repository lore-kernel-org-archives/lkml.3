Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaBQFxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:53:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:34271 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaBQFxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:53:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="476347976"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v2 5/5] PM / sleep: Asynchronous threads for suspend_late
Date: Mon, 17 Feb 2014 13:42:26 +0800
Message-Id: <1392615746-4574-6-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <1392615746-4574-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1392615746-4574-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In analogy with commits 5af84b82701a and 97df8c12995, using
asynchronous threads can improve the overall suspend_late
time significantly.

This patch is for suspend_late phase.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c | 64 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 72b4c9c..0c5fad0 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1127,16 +1127,24 @@ static int dpm_suspend_noirq(pm_message_t state)
  *
  * Runtime PM is disabled for @dev while this function is being executed.
  */
-static int device_suspend_late(struct device *dev, pm_message_t state)
+static int __device_suspend_late(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
-	int error;
+	int error = 0;
 
 	__pm_runtime_disable(dev, false);
 
+	if (async_error)
+		goto Complete;
+
+	if (pm_wakeup_pending()) {
+		async_error = -EBUSY;
+		goto Complete;
+	}
+
 	if (dev->power.syscore)
-		return 0;
+		goto Complete;
 
 	if (dev->pm_domain) {
 		info = "late power domain ";
@@ -1160,10 +1168,40 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 	error = dpm_run_callback(callback, dev, state, info);
 	if (!error)
 		dev->power.is_late_suspended = true;
+	else
+		async_error = error;
 
+Complete:
+	complete_all(&dev->power.completion);
 	return error;
 }
 
+static void async_suspend_late(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend_late(dev, pm_transition, true);
+	if (error) {
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, pm_transition, " async", error);
+	}
+	put_device(dev);
+}
+
+static int device_suspend_late(struct device *dev)
+{
+	reinit_completion(&dev->power.completion);
+
+	if (pm_async_enabled && dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_late, dev);
+		return 0;
+	}
+
+	return __device_suspend_late(dev, pm_transition, false);
+}
+
 /**
  * dpm_suspend_late - Execute "late suspend" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -1174,19 +1212,20 @@ static int dpm_suspend_late(pm_message_t state)
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
@@ -1195,17 +1234,18 @@ static int dpm_suspend_late(pm_message_t state)
 			list_move(&dev->power.entry, &dpm_late_early_list);
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
+	if (error) {
+		suspend_stats.failed_suspend_late++;
+		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);
 		dpm_resume_early(resume_event(state));
-	else
+	} else {
 		dpm_show_time(starttime, state, "late");
-
+	}
 	return error;
 }
 
-- 
1.9.rc0

