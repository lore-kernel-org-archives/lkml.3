Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3FGI1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:27:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:30351 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab3FGI1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:27:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="251875826"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        gregkh@linuxfoundation.org, yanmin_zhang@linux.intel.com,
        ShuoX Liu <shuox.liu@intel.com>, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: [PATCH 2/2] PM: add dpm_run_callback_void and use it in device_complete
Date: Fri,  7 Jun 2013 16:20:32 +0800
Message-Id: <1370593232-3602-3-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

dpm_run_callback_void could show more debug info around complete stage

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 drivers/base/power/main.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index cb89323..7021491 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -33,6 +33,7 @@
 #include "power.h"
 
 typedef int (*pm_callback_t)(struct device *);
+typedef void (*pm_callback_void_t)(struct device *);
 
 /*
  * The entries in the dpm_list list are in a depth first order, simply
@@ -384,6 +385,23 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 	return error;
 }
 
+static void dpm_run_callback_void(pm_callback_void_t cb, struct device *dev,
+			    pm_message_t state, char *info)
+{
+	ktime_t calltime;
+	int error;
+
+	if (!cb)
+		return;
+
+	calltime = initcall_debug_start(dev);
+
+	pm_dev_dbg(dev, state, info);
+	cb(dev);
+
+	initcall_debug_report(dev, calltime, error);
+}
+
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -722,7 +740,7 @@ void dpm_resume(pm_message_t state)
  */
 static void device_complete(struct device *dev, pm_message_t state)
 {
-	void (*callback)(struct device *) = NULL;
+	pm_callback_void_t callback = NULL;
 	char *info = NULL;
 
 	if (dev->power.syscore)
@@ -749,10 +767,7 @@ static void device_complete(struct device *dev, pm_message_t state)
 		callback = dev->driver->pm->complete;
 	}
 
-	if (callback) {
-		pm_dev_dbg(dev, state, info);
-		callback(dev);
-	}
+	dpm_run_callback_void(callback, dev, state, info);
 
 	device_unlock(dev);
 
@@ -769,6 +784,7 @@ static void device_complete(struct device *dev, pm_message_t state)
 void dpm_complete(pm_message_t state)
 {
 	struct list_head list;
+	ktime_t starttime = ktime_get();
 
 	might_sleep();
 
@@ -789,6 +805,7 @@ void dpm_complete(pm_message_t state)
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	dpm_show_time(starttime, state, "complete");
 }
 
 /**
-- 
1.7.1

