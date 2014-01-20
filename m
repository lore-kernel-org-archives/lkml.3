Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaATIxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:53:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:40905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaATIxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:53:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461529693"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, pavel@ucw.cz,
        len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH 4/5] PM: Enabling the asyncronous threads for suspend_noirq
Date: Mon, 20 Jan 2014 16:44:38 +0800
Message-Id: <1390207479-26064-5-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Liu, Chuansheng" <chuansheng.liu@intel.com>

Just like commit 5af84b82701a and 97df8c12995, using the
asynchronous threads can improve the overall suspend_noirq
time significantly.

This patch is for suspend_noirq phase.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |   57 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 1bad6bd..ec946aa 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -965,12 +965,20 @@ static pm_message_t resume_event(pm_message_t sleep_state)
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_suspend_noirq(struct device *dev, pm_message_t state)
+static int __device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 	int error;
 
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
 
@@ -996,9 +1004,36 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 	error = dpm_run_callback(callback, dev, state, info);
 	if (!error)
 		dev->power.is_noirq_suspended = true;
+	else
+		async_error = error;
+
 	return error;
 }
 
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
+}
+
+static int device_suspend_noirq(struct device *dev)
+{
+	if (pm_async_enabled && dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend_noirq, dev);
+		return 0;
+	}
+	return __device_suspend_noirq(dev, pm_transition);
+}
+
 /**
  * dpm_suspend_noirq - Execute "noirq suspend" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -1014,19 +1049,20 @@ static int dpm_suspend_noirq(pm_message_t state)
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
@@ -1035,15 +1071,18 @@ static int dpm_suspend_noirq(pm_message_t state)
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
+	if (error) {
+		suspend_stats.failed_suspend_noirq++;
+		dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
 		dpm_resume_noirq(resume_event(state));
-	else
+	} else
 		dpm_show_time(starttime, state, "noirq");
 	return error;
 }
-- 
1.7.9.5

