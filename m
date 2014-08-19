Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaHSGAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:00:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:7254 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaHSGAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,892,1400050800"; 
   d="scan'208";a="560388270"
From: xiaoming wang <xiaoming.wang@intel.com>
To: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: xiaoming wang <xiaoming.wang@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH 2/2] PM / sleep: Asynchronous threads for dpm_complete
Date: Tue, 19 Aug 2014 16:29:29 -0400
Message-Id: <1408480169-18090-2-git-send-email-xiaoming.wang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408480169-18090-1-git-send-email-xiaoming.wang@intel.com>
References: <1408480169-18090-1-git-send-email-xiaoming.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In analogy with commits 5af84b82701a and 97df8c12995,
using asynchronous threads can improve the overall
resume time significantly.

This patch is for dpm_complete phase.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
---
 drivers/base/power/main.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index f9fe1b3..00c4bf1 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -889,14 +889,15 @@ void dpm_resume(pm_message_t state)
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  */
-static void device_complete(struct device *dev, pm_message_t state)
+static void device_complete(struct device *dev, pm_message_t state, bool async)
 {
 	void (*callback)(struct device *) = NULL;
 	char *info = NULL;
 
 	if (dev->power.syscore)
-		return;
+		goto Complete;
 
+	dpm_wait(dev->parent, async);
 	device_lock(dev);
 
 	if (dev->pm_domain) {
@@ -928,6 +929,17 @@ static void device_complete(struct device *dev, pm_message_t state)
 	device_unlock(dev);
 
 	pm_runtime_put(dev);
+
+Complete:
+	complete_all(&dev->power.completion);
+}
+
+static void async_complete(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+
+	device_complete(dev, pm_transition, true);
+	put_device(dev);
 }
 
 /**
@@ -940,27 +952,45 @@ static void device_complete(struct device *dev, pm_message_t state)
 void dpm_complete(pm_message_t state)
 {
 	struct list_head list;
+	struct device *dev;
 
 	trace_suspend_resume(TPS("dpm_complete"), state.event, true);
 	might_sleep();
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
+
+	/*
+	  * Advanced the async threads upfront,
+	  * in case the starting of async threads is
+	  * delayed by non-async resuming devices.
+	  */
+	list_for_each_entry(dev, &dpm_prepared_list, power.entry) {
+		reinit_completion(dev->power.completion);
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_complete, dev);
+		}
+	}
+
 	while (!list_empty(&dpm_prepared_list)) {
-		struct device *dev = to_device(dpm_prepared_list.prev);
+		dev = to_device(dpm_prepared_list.prev);
 
 		get_device(dev);
 		dev->power.is_prepared = false;
 		list_move(&dev->power.entry, &list);
 		mutex_unlock(&dpm_list_mtx);
 
-		device_complete(dev, state);
+		if (!is_async(dev))
+			device_complete(dev, state);
 
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	trace_suspend_resume(TPS("dpm_complete"), state.event, false);
 }
 
-- 
1.7.1

