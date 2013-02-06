Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3BFT4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:56:23 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65297 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239Ab3BFTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:07 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Subject: [PATCH 64/77] thermal: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:36 -0800
Message-Id: <1360179649-22465-65-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
---
 drivers/thermal/cpu_cooling.c | 17 +++++------------
 drivers/thermal/thermal_sys.c | 17 +++++------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 836828e..c33fa53 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -73,21 +73,14 @@ static struct cpufreq_cooling_device *notify_device;
  */
 static int get_idr(struct idr *idr, int *id)
 {
-	int err;
-again:
-	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
+	int ret;
 
 	mutex_lock(&cooling_cpufreq_lock);
-	err = idr_get_new(idr, NULL, id);
+	ret = idr_alloc(idr, NULL, 0, 0, GFP_KERNEL);
 	mutex_unlock(&cooling_cpufreq_lock);
-
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return err;
-
-	*id = *id & MAX_IDR_MASK;
+	if (unlikely(ret < 0))
+		return ret;
+	*id = ret;
 	return 0;
 }
 
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 0a1bf6b..0767193 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -131,23 +131,16 @@ EXPORT_SYMBOL_GPL(thermal_unregister_governor);
 
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
-	int err;
-
-again:
-	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
+	int ret;
 
 	if (lock)
 		mutex_lock(lock);
-	err = idr_get_new(idr, NULL, id);
+	ret = idr_alloc(idr, NULL, 0, 0, GFP_KERNEL);
 	if (lock)
 		mutex_unlock(lock);
-	if (unlikely(err == -EAGAIN))
-		goto again;
-	else if (unlikely(err))
-		return err;
-
-	*id = *id & MAX_IDR_MASK;
+	if (unlikely(ret < 0))
+		return ret;
+	*id = ret;
 	return 0;
 }
 
-- 
1.8.1

