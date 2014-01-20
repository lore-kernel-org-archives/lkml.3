Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaATIxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:53:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:40905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbaATIxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:53:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461529637"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, pavel@ucw.cz,
        len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH 1/5] PM: Adding two flags for async suspend_noirq and suspend_late
Date: Mon, 20 Jan 2014 16:44:35 +0800
Message-Id: <1390207479-26064-2-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Liu, Chuansheng" <chuansheng.liu@intel.com>

The patch is one helper that adding two new flags for implementing
async threads for suspend_noirq and suspend_late.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |   22 ++++++++++++++++++++--
 include/linux/pm.h        |    2 ++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 6a33dd8..bf71ddb 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -72,6 +72,8 @@ void device_pm_sleep_init(struct device *dev)
 {
 	dev->power.is_prepared = false;
 	dev->power.is_suspended = false;
+	dev->power.is_noirq_suspended = false;
+	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
 	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
@@ -464,6 +466,9 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	if (!dev->power.is_noirq_suspended)
+		goto Out;
+
 	if (dev->pm_domain) {
 		info = "noirq power domain ";
 		callback = pm_noirq_op(&dev->pm_domain->ops, state);
@@ -484,6 +489,7 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
+	dev->power.is_noirq_suspended = false;
 
  Out:
 	TRACE_RESUME(error);
@@ -546,6 +552,9 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	if (!dev->power.is_late_suspended)
+		goto Out;
+
 	if (dev->pm_domain) {
 		info = "early power domain ";
 		callback = pm_late_early_op(&dev->pm_domain->ops, state);
@@ -566,6 +575,7 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
+	dev->power.is_late_suspended = false;
 
  Out:
 	TRACE_RESUME(error);
@@ -902,6 +912,7 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
+	int error;
 
 	if (dev->power.syscore)
 		return 0;
@@ -925,7 +936,10 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 		callback = pm_noirq_op(dev->driver->pm, state);
 	}
 
-	return dpm_run_callback(callback, dev, state, info);
+	error = dpm_run_callback(callback, dev, state, info);
+	if (!error)
+		dev->power.is_noirq_suspended = true;
+	return error;
 }
 
 /**
@@ -988,6 +1002,7 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
+	int error;
 
 	__pm_runtime_disable(dev, false);
 
@@ -1013,7 +1028,10 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 		callback = pm_late_early_op(dev->driver->pm, state);
 	}
 
-	return dpm_run_callback(callback, dev, state, info);
+	error = dpm_run_callback(callback, dev, state, info);
+	if (!error)
+		dev->power.is_late_suspended = true;
+	return error;
 }
 
 /**
diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..fe90a8b 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -521,6 +521,8 @@ struct dev_pm_info {
 	unsigned int		async_suspend:1;
 	bool			is_prepared:1;	/* Owned by the PM core */
 	bool			is_suspended:1;	/* Ditto */
+	bool			is_noirq_suspended:1;
+	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
 	spinlock_t		lock;
-- 
1.7.9.5

