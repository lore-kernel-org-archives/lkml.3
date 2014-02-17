Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaBQGcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:32:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:58529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaBQGbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:31:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="476359315"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v3 3/5] PM / sleep: Asynchronous threads for resume_early
Date: Mon, 17 Feb 2014 14:19:12 +0800
Message-Id: <1392617954-5292-4-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In analogy with commits 5af84b82701a and 97df8c12995, using
asynchronous threads can improve the overall resume_early
time significantly.

This patch is for resume_early phase.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c | 55 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 89172aa..2f2d110 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -595,7 +595,7 @@ static void dpm_resume_noirq(pm_message_t state)
  *
  * Runtime PM is disabled for @dev while this function is being executed.
  */
-static int device_resume_early(struct device *dev, pm_message_t state)
+static int device_resume_early(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
@@ -607,6 +607,8 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	dpm_wait(dev->parent, async);
+
 	if (!dev->power.is_late_suspended)
 		goto Out;
 
@@ -636,38 +638,69 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	TRACE_RESUME(error);
 
 	pm_runtime_enable(dev);
+	complete_all(&dev->power.completion);
 	return error;
 }
 
+static void async_resume_early(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = device_resume_early(dev, pm_transition, true);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+
+	put_device(dev);
+}
+
 /**
  * dpm_resume_early - Execute "early resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
  */
 static void dpm_resume_early(pm_message_t state)
 {
+	struct device *dev;
 	ktime_t starttime = ktime_get();
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_late_early_list)) {
-		struct device *dev = to_device(dpm_late_early_list.next);
-		int error;
+	pm_transition = state;
+
+	/*
+	 * Advanced the async threads upfront,
+	 * in case the starting of async threads is
+	 * delayed by non-async resuming devices.
+	 */
+	list_for_each_entry(dev, &dpm_late_early_list, power.entry) {
+		reinit_completion(&dev->power.completion);
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_resume_early, dev);
+		}
+	}
 
+	while (!list_empty(&dpm_late_early_list)) {
+		dev = to_device(dpm_late_early_list.next);
 		get_device(dev);
 		list_move_tail(&dev->power.entry, &dpm_suspended_list);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_resume_early(dev, state);
-		if (error) {
-			suspend_stats.failed_resume_early++;
-			dpm_save_failed_step(SUSPEND_RESUME_EARLY);
-			dpm_save_failed_dev(dev_name(dev));
-			pm_dev_err(dev, state, " early", error);
-		}
+		if (!is_async(dev)) {
+			int error;
 
+			error = device_resume_early(dev, state, false);
+			if (error) {
+				suspend_stats.failed_resume_early++;
+				dpm_save_failed_step(SUSPEND_RESUME_EARLY);
+				dpm_save_failed_dev(dev_name(dev));
+				pm_dev_err(dev, state, " early", error);
+			}
+		}
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	dpm_show_time(starttime, state, "early");
 }
 
-- 
1.9.rc0

