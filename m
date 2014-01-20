Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaATIxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:53:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:40905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbaATIxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:53:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461529679"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, pavel@ucw.cz,
        len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH 3/5] PM: Enabling the asyncronous threads for resume_early
Date: Mon, 20 Jan 2014 16:44:37 +0800
Message-Id: <1390207479-26064-4-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Liu, Chuansheng" <chuansheng.liu@intel.com>

Just like commit 5af84b82701a and 97df8c12995, using the
asynchronous threads can improve the overall resume_early
time significantly.

This patch is for resume_early phase.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |   48 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c8a00fc..1bad6bd 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -619,35 +619,63 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	return error;
 }
 
+static void async_resume_early(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = device_resume_early(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
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
 
+	/*
+	 * Advanced the async threads upfront,
+	 * in case the starting of async threads is
+	 * delayed by non-async resuming devices.
+	 */
+	list_for_each_entry(dev, &dpm_late_early_list, power.entry) {
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_resume_early, dev);
+		}
+	}
+
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
 
+			error = device_resume_early(dev, state);
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
1.7.9.5

