Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaATIyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:54:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:40905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaATIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:53:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461529725"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, pavel@ucw.cz,
        len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH 5/5] PM: Enabling the asyncronous threads for suspend_late
Date: Mon, 20 Jan 2014 16:44:39 +0800
Message-Id: <1390207479-26064-6-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Liu, Chuansheng" <chuansheng.liu@intel.com>

Just like commit 5af84b82701a and 97df8c12995, using the
asynchronous threads can improve the overall suspend_late
time significantly.

This patch is for suspend_late phase.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |   54 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index ec946aa..19f5195 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1094,7 +1094,7 @@ static int dpm_suspend_noirq(pm_message_t state)
  *
  * Runtime PM is disabled for @dev while this function is being executed.
  */
-static int device_suspend_late(struct device *dev, pm_message_t state)
+static int __device_suspend_late(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
@@ -1102,6 +1102,14 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 
 	__pm_runtime_disable(dev, false);
 
+	if (async_error)
+		return 0;
+
+	if (pm_wakeup_pending()) {
+		async_error = -EBUSY;
+		return async_error;
+	}
+
 	if (dev->power.syscore)
 		return 0;
 
@@ -1127,9 +1135,35 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 	error = dpm_run_callback(callback, dev, state, info);
 	if (!error)
 		dev->power.is_late_suspended = true;
+	else
+		async_error = error;
 	return error;
 }
 
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
+}
+
 /**
  * dpm_suspend_late - Execute "late suspend" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -1140,19 +1174,20 @@ static int dpm_suspend_late(pm_message_t state)
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
@@ -1161,15 +1196,16 @@ static int dpm_suspend_late(pm_message_t state)
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
+	} else
 		dpm_show_time(starttime, state, "late");
 
 	return error;
-- 
1.7.9.5

