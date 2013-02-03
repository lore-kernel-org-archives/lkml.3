Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3BCB1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:27:00 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54274 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3BCBWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:52 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Subject: [PATCH 48/62] thermal: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:49 -0800
Message-Id: <1359854463-2538-49-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

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
index 8c8ce80..84e95f3 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -132,23 +132,16 @@ EXPORT_SYMBOL_GPL(thermal_unregister_governor);
 
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

