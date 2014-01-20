Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaATIxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:53:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:40905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaATIxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:53:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461529663"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, pavel@ucw.cz,
        len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH 2/5] PM: Enabling the asynchronous threads for resume_noirq
Date: Mon, 20 Jan 2014 16:44:36 +0800
Message-Id: <1390207479-26064-3-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Liu, Chuansheng" <chuansheng.liu@intel.com>

Just like commit 5af84b82701a and 97df8c12995, using the
asynchronous threads can improve the overall resume_noirq
time significantly.

One typical case is:
In resume_noirq phase and for the PCI devices, the function
pci_pm_resume_noirq() will be called, and there is one d3_delay
(10ms) at least.

With the way of asynchronous threads, we just need wait d3_delay
time once in parallel for each calling, which save much time to
resume quickly.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |   59 +++++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bf71ddb..c8a00fc 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -496,6 +496,23 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
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
+	error = device_resume_noirq(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+	put_device(dev);
+}
+
 /**
  * dpm_resume_noirq - Execute "noirq resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -505,29 +522,47 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
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
 
+	/*
+	 * Advanced the async threads upfront,
+	 * in case the starting of async threads is
+	 * delayed by non-async resuming devices.
+	 */
+	list_for_each_entry(dev, &dpm_noirq_list, power.entry) {
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_resume_noirq, dev);
+		}
+	}
+
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
+			error = device_resume_noirq(dev, state);
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
@@ -727,12 +762,6 @@ static void async_resume(void *data, async_cookie_t cookie)
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
1.7.9.5

