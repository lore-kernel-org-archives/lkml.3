Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3FGI0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:26:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:20390 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab3FGI0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:26:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="346262164"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        gregkh@linuxfoundation.org, yanmin_zhang@linux.intel.com,
        ShuoX Liu <shuox.liu@intel.com>, Zhang Yanmin <yanmin.zhang@intel.com>
Subject: [PATCH 1/2] PM: use dpm_run_callback in device_prepare
Date: Fri,  7 Jun 2013 16:20:31 +0800
Message-Id: <1370593232-3602-2-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

dpm_run_callback could show more debug info around prepare stage.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 drivers/base/power/main.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 5a9b656..cb89323 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1223,7 +1223,7 @@ int dpm_suspend(pm_message_t state)
  */
 static int device_prepare(struct device *dev, pm_message_t state)
 {
-	int (*callback)(struct device *) = NULL;
+	pm_callback_t callback = NULL;
 	char *info = NULL;
 	int error = 0;
 
@@ -1261,10 +1261,7 @@ static int device_prepare(struct device *dev, pm_message_t state)
 		callback = dev->driver->pm->prepare;
 	}
 
-	if (callback) {
-		error = callback(dev);
-		suspend_report_result(callback, error);
-	}
+	error = dpm_run_callback(callback, dev, state, info);
 
 	device_unlock(dev);
 
@@ -1280,6 +1277,7 @@ static int device_prepare(struct device *dev, pm_message_t state)
 int dpm_prepare(pm_message_t state)
 {
 	int error = 0;
+	ktime_t starttime = ktime_get();
 
 	might_sleep();
 
@@ -1311,6 +1309,7 @@ int dpm_prepare(pm_message_t state)
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	dpm_show_time(starttime, state, "prepare");
 	return error;
 }
 
-- 
1.7.1

