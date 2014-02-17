Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaBQGbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:31:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:33635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaBQGbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:31:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="476359247"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH v3 1/5] PM / sleep: Two flags for async suspend_noirq and suspend_late
Date: Mon, 17 Feb 2014 14:19:10 +0800
Message-Id: <1392617954-5292-2-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1392617954-5292-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is a helper adding two new flags for implementing
async threads for suspend_noirq and suspend_late.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c | 24 ++++++++++++++++++++++--
 include/linux/pm.h        |  2 ++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 1b41fca..00c53eb 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -91,6 +91,8 @@ void device_pm_sleep_init(struct device *dev)
 {
 	dev->power.is_prepared = false;
 	dev->power.is_suspended = false;
+	dev->power.is_noirq_suspended = false;
+	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
 	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
@@ -479,6 +481,9 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	if (!dev->power.is_noirq_suspended)
+		goto Out;
+
 	if (dev->pm_domain) {
 		info = "noirq power domain ";
 		callback = pm_noirq_op(&dev->pm_domain->ops, state);
@@ -499,6 +504,7 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
+	dev->power.is_noirq_suspended = false;
 
  Out:
 	TRACE_RESUME(error);
@@ -561,6 +567,9 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	if (dev->power.syscore)
 		goto Out;
 
+	if (!dev->power.is_late_suspended)
+		goto Out;
+
 	if (dev->pm_domain) {
 		info = "early power domain ";
 		callback = pm_late_early_op(&dev->pm_domain->ops, state);
@@ -581,6 +590,7 @@ static int device_resume_early(struct device *dev, pm_message_t state)
 	}
 
 	error = dpm_run_callback(callback, dev, state, info);
+	dev->power.is_late_suspended = false;
 
  Out:
 	TRACE_RESUME(error);
@@ -917,6 +927,7 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
+	int error;
 
 	if (dev->power.syscore)
 		return 0;
@@ -940,7 +951,11 @@ static int device_suspend_noirq(struct device *dev, pm_message_t state)
 		callback = pm_noirq_op(dev->driver->pm, state);
 	}
 
-	return dpm_run_callback(callback, dev, state, info);
+	error = dpm_run_callback(callback, dev, state, info);
+	if (!error)
+		dev->power.is_noirq_suspended = true;
+
+	return error;
 }
 
 /**
@@ -1003,6 +1018,7 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 {
 	pm_callback_t callback = NULL;
 	char *info = NULL;
+	int error;
 
 	__pm_runtime_disable(dev, false);
 
@@ -1028,7 +1044,11 @@ static int device_suspend_late(struct device *dev, pm_message_t state)
 		callback = pm_late_early_op(dev->driver->pm, state);
 	}
 
-	return dpm_run_callback(callback, dev, state, info);
+	error = dpm_run_callback(callback, dev, state, info);
+	if (!error)
+		dev->power.is_late_suspended = true;
+
+	return error;
 }
 
 /**
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 8c6583a..f23a4f1 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -542,6 +542,8 @@ struct dev_pm_info {
 	unsigned int		async_suspend:1;
 	bool			is_prepared:1;	/* Owned by the PM core */
 	bool			is_suspended:1;	/* Ditto */
+	bool			is_noirq_suspended:1;
+	bool			is_late_suspended:1;
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
 	spinlock_t		lock;
-- 
1.9.rc0

